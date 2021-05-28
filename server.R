library(shiny)
library(shinydashboard)
library(ggplot2)
library(RSQLite)
library(plotly)

# db=dbConnect(dbDriver("SQLite"),dbname="G:\\NICST_job\\db")
# 
# df2=dbGetQuery(db,"select * from AdmissionAssessment_wide")
# names(df2)[names(df2) == "AdmissionAssessment.antibiotics"] <- "antibiotics"
# names(df2)[names(df2) == "AdmissionAssessment.cardiovascular_support"] <- "cardiovascular_support"
# names(df2)[names(df2) == "AdmissionAssessment.mechanically_ventilated"] <- "mechanically_ventilated"
# 
# mech=table(df2$date_of_admission[df2$mechanically_ventilated=="mechanical_vent"])
# df4=data.frame(mech)
# df4$Var1<- as.Date(df4$Var1)
#d=df4[df4$Var1>=as.Date('2020-05-15') & df4$Var1<=as.Date('2020-05-20'),]


#a=read.csv("freq.csv")
#a$Var1<- as.Date(a$Var1, '%m/%d/%Y')
# c=a[a$Var1>=as.Date('2020-01-15') & a$Var1<=as.Date('2020-01-30'),]
# c=a[a$Var1>=as.Date(input) & a$Var1<=as.Date(daterange[2]),]

shinyServer(function(input,output){
  
  icudate<-reactive({
    a[a$Var1>=as.Date(input$daterange[1]) & a$Var1<=as.Date(input$daterange[2]),]
  })
  
  antiper<-reactive({
    round(c((sum(icudate()$Yes)*100)/(sum(icudate()$Yes)+sum(icudate()$No)),(sum(icudate()$No)*100)/(sum(icudate()$Yes)+sum(icudate()$No))))
  })

  cardper<-reactive({
    round(c((sum(icudate()$Yes_card)*100)/(sum(icudate()$Yes_card)+sum(icudate()$No_card)),(sum(icudate()$No_card)*100)/(sum(icudate()$Yes_card)+sum(icudate()$No_card))))
  })
  
  output$info1<-renderInfoBox({
    infoBox(title="Total admissions",value=sum(icudate()$Freq),
            color="aqua",width=2,fill=T,icon = icon("user-alt"))
  })
  
  output$info2<-renderInfoBox({
    infoBox(title="Bed occupancy",color="aqua",width=3,fill=T,icon = icon("chart-line"))
  })
  
  output$info3<-renderInfoBox({
    infoBox(title="Average LoS",color="aqua",width=3,fill=T,icon = icon("calendar-alt"))
  })
  
  output$info4<-renderInfoBox({
    infoBox(title="Admission type",value=paste0(sum(icudate()$unplanned),":unplanned  ",sum(icudate()$planned),":planned"),
            color="aqua",width=3,fill=T,icon = icon("procedures"))
  })
  
  output$histogram<-renderPlotly({
    
    yaxis <- list(
      title = 'Number of patients',
      automargin = TRUE
    )
    fig<-plot_ly(icudate(),x =icudate()$Var1, y =icudate()$Freq, 
                 width = 500, height = 300, type = 'bar',color = I("deepskyblue1"))
    fig<- fig %>% layout(autosize = F,title="ICU admissions",yaxis=yaxis)
    
    fig
    
  
    # ggplot(data =icudate(), aes(x = Var1, y = Freq)) +
    #   geom_bar(stat = "identity", fill = "deepskyblue1") +
    #   #geom_text(aes(label=Freq), position=position_dodge(width=0.9), vjust=-0.25)+
    #   labs(title = "ICU Admissions",
    #        x = "Date", y = "Number of Pateints")
    # 
    # 
  })
  
  output$apache<-renderText({
    paste("Mean APACHE II score")
  })
  
  
  
  output$ventilator<-renderPlotly({
    
    yaxis <- list(
      title = 'Number of patients',
      automargin = TRUE
    )
    fig<-plot_ly(icudate(),x =icudate()$Var1, y =icudate()$Freq_mech, 
                 width = 500, height = 300, type = 'bar',color = I("deepskyblue1"))
    fig<- fig %>% layout(autosize = F,title="Mechanically ventilated within 24 hours of admission",yaxis=yaxis)
    
    fig
    
    # ggplot(data = icudate(), aes(x =Var1, y =Freq_mech)) +
    #   geom_bar(stat = "identity", fill = "deepskyblue1") +
    #   labs(title = "Mechanically ventilated within 24 hours of admission",
    #        x = "Date", y = "Number of Pateints")
    
  })
  
  output$anti<-renderPlot({
    ggplot() +
      geom_bar(aes(x="", y=antiper(), fill=group),
               stat="identity", width=1, color="white") +
      labs(title = "Antibiotics within 24 hours of admission") +
      coord_polar("y", start=0) +
      geom_text(aes(x="",y=cumsum(antiper())-0.5*antiper(),
                    label =paste0(antiper(),"%")), 
                size=5)+
      
      theme_void()
  })
  
  output$card<-renderPlot({
    ggplot() +
      geom_bar(aes(x="", y=cardper(),fill=group),
        stat="identity", width=1, color="white") +
      labs(title = "Cardiovascular support within 24 hours of admission") +
      coord_polar("y", start=0) +
      geom_text(aes(x="",y=cumsum(cardper())-0.5*cardper(),
                    label =paste0(cardper(),"%")), 
                size=5)+
      
      theme_void()
  })

  output$msgOutput<-renderMenu({
    msgs<-apply(read.csv("messages.csv"),1,function(row){
      messageItem(from=row[["from"]],message=row[["message"]])
    })
    
    dropdownMenu(type="messages", .list=msgs)
  })
})

