library(shiny)
library(shinydashboard)
library(ggplot2)
library(RSQLite)
library(plotly)

#a=read.csv("freq.csv")
#a$Var1<- as.Date(a$Var1, '%m/%d/%Y')
# c=a[a$Var1>=as.Date('2020-01-15') & a$Var1<=as.Date('2020-01-30'),]
# c=a[a$Var1>=as.Date(input) & a$Var1<=as.Date(daterange[2]),]

shinyServer(function(input,output){
  
  # icudate<-reactive({
  #   a[a$Var1>=as.Date(input$daterange[1]) & a$Var1<=as.Date(input$daterange[2]),]
  # })
  
  icudate1<-reactive({
    newdf[newdf$Var1>=as.Date(input$daterange[1]) & newdf$Var1<=as.Date(input$daterange[2]),]
  })
  
  # antiper<-reactive({
  #   round(c((sum(icudate()$Yes)*100)/(sum(icudate()$Yes)+sum(icudate()$No)),(sum(icudate()$No)*100)/(sum(icudate()$Yes)+sum(icudate()$No))))
  # })

  antiper1<-reactive({
    round(c((sum(icudate1()$Yes_anti)*100)/(sum(icudate1()$Yes_anti)+sum(icudate1()$No_anti)),(sum(icudate1()$No_anti)*100)/(sum(icudate1()$Yes_anti)+sum(icudate1()$No_anti))))
  })
  
  # cardper<-reactive({
  #   round(c((sum(icudate()$Yes_card)*100)/(sum(icudate()$Yes_card)+sum(icudate()$No_card)),(sum(icudate()$No_card)*100)/(sum(icudate()$Yes_card)+sum(icudate()$No_card))))
  # })

  cardper1<-reactive({
    round(c((sum(icudate1()$Yes_card)*100)/(sum(icudate1()$Yes_card)+sum(icudate1()$No_card)),(sum(icudate1()$No_card)*100)/(sum(icudate1()$Yes_card)+sum(icudate1()$No_card))))
  })
  
  output$info1<-renderInfoBox({
    infoBox(title="Total admissions",value=sum(icudate1()$Freq),
            color="aqua",width=2,fill=T,icon = icon("user-alt"))
  })
  
  output$info2<-renderInfoBox({
    infoBox(title="Bed occupancy",color="aqua",width=3,fill=T,icon = icon("chart-line"))
  })
  
  output$info3<-renderInfoBox({
    infoBox(title="Average LoS",color="aqua",width=3,fill=T,icon = icon("calendar-alt"))
  })
  
  output$info4<-renderInfoBox({
    infoBox(title="Admission type",value=paste0(sum(icudate1()$unplanned),":unplanned  ",sum(icudate1()$planned),":planned"),
            color="aqua",width=3,fill=T,icon = icon("procedures"))
  })
  
  output$histogram<-renderPlotly({
    
    yaxis <- list(
      title = 'Number of patients',
      automargin = TRUE
    )
    t<-list(
      size=10
    )
    xaxis<-list(
      autotick=FALSE,
      ticks = "outside",
      tickcolor = toRGB("black"),
      showticklabels = TRUE,
      tickangle = 45,
      type = 'date',
      tickformat = "%d/%m"
    )
    fig <- plot_ly(icudate1(), x =icudate1()$Var1, y = icudate1()$planned, 
                   type = 'bar', name = 'Emergency',width = 400,height = 225,marker=list(color="lightskyblue"))
    fig <- fig %>% add_trace(y =icudate1()$unplanned, name = 'Non Emergency',marker=list(color="darkblue"))
    fig <- fig %>% layout(yaxis =yaxis,title="ICU admissions",font=t,
                          barmode = 'stack',xaxis=xaxis)
    
    fig
    
    # ggplot(data =icudate(), aes(x = Var1, y = Freq)) +
    #   geom_bar(stat = "identity", fill = "deepskyblue1") +
    #   #geom_text(aes(label=Freq), position=position_dodge(width=0.9), vjust=-0.25)+
    #   labs(title = "ICU Admissions",
    #        x = "Date", y = "Number of Pateints")
    # 
    # 
  })
  
  apache_plan<-reactive({
    if(length(icudate1()$apache_plan)>sum(is.na(icudate1()$apache_plan))){
      round(mean(icudate1()$apache_plan,na.rm = TRUE))
    }else{
      paste0("No Data")
    }
  })
  apache_un<-reactive({
    if(length(icudate1()$apache_un)>sum(is.na(icudate1()$apache_un))){
      round(mean(icudate1()$apache_un,na.rm = TRUE))
    }else{
      paste0("No Data")
    }
  })
  
  output$apache<-renderUI({

    HTML(paste0("Mean APACHE II score [planned] = ",apache_plan(),"<br/>","<br/>",
           " Mean APACHE II score [unplanned] = ",apache_un()))

  })
  
  
  
  output$ventilator<-renderPlotly({
    
    yaxis <- list(
      title = 'Number of patients',
      automargin = TRUE
    )
    t<-list(
      size=10
    )
  
    fig<-plot_ly(icudate1(),x =icudate1()$Var1, y =icudate1()$mech_freq, 
                 width = 400, height = 225, type = 'bar',color = I("lightskyblue"))
    fig<- fig %>% layout(autosize = F,title="Mechanically ventilated within 24 hours of admission",yaxis=yaxis,font=t)
    
    fig
    
    # ggplot(data = icudate(), aes(x =Var1, y =Freq_mech)) +
    #   geom_bar(stat = "identity", fill = "deepskyblue1") +
    #   labs(title = "Mechanically ventilated within 24 hours of admission",
    #        x = "Date", y = "Number of Pateints")
    
  })
  
  output$anti<-renderPlotly({
    t<-list(
      size=10
    )
    fig <- plot_ly(data.frame(antiper1(),group), labels = group, values = antiper1(), 
                   type = 'pie',height = 300,marker=list(colors=c("darkblue","lightskyblue")))
    fig <- fig %>% layout(title = 'Antibiotics within 24 hours of admission', font=t,
                          xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
                          yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
    
    fig
    # ggplot() +
    #   geom_bar(aes(x="", y=antiper(), fill=group),
    #            stat="identity", width=1, color="white") +
    #   labs(title = "Antibiotics within 24 hours of admission") +
    #   coord_polar("y", start=0) +
    #   geom_text(aes(x="",y=cumsum(antiper())-0.5*antiper(),
    #                 label =paste0(antiper(),"%")), 
    #             size=5)+
    #   
    #   theme_void()
  })
  
  output$card<-renderPlotly({
    t<-list(
      size=10
    )
    fig <- plot_ly(data.frame(cardper1(),group), labels = group, values = cardper1(), 
                   type = 'pie',height = 300,marker=list(colors=c("darkblue","lightskyblue")))
    fig <- fig %>% layout(title = 'Cardiovascular support within 24 hours of admission',font=t,
                          xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
                          yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
    
    fig
    
    # ggplot() +
    #   geom_bar(aes(x="", y=cardper(),fill=group),
    #     stat="identity", width=1, color="white") +
    #   labs(title = "Cardiovascular support within 24 hours of admission") +
    #   coord_polar("y", start=0) +
    #   geom_text(aes(x="",y=cumsum(cardper())-0.5*cardper(),
    #                 label =paste0(cardper(),"%")), 
    #             size=5)+
    #   
    #   theme_void()
  })

  # output$msgOutput<-renderMenu({
  #   msgs<-apply(read.csv("messages.csv"),1,function(row){
  #     messageItem(from=row[["from"]],message=row[["message"]])
  #   })
  #   
  #   dropdownMenu(type="messages", .list=msgs)
  # })
})

