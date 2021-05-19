library(shiny)
library(shinydashboard)
library(ggplot2)

a=read.csv("freq.csv")
a$Var1<- as.Date(a$Var1, '%m/%d/%Y')
#c=a[a$Var1>=as.Date('2020-01-15') & a$Var1<=as.Date('2020-01-30'),]
#c=a[a$Var1>=as.Date(input) & a$Var1<=as.Date(daterange[2]),]

shinyServer(function(input,output){
  

  output$histogram<-renderPlot({
    ggplot(data =a[a$Var1>=as.Date(input$daterange[1]) & a$Var1<=as.Date(input$daterange[2]),], aes(x = Var1, y = Freq)) +
      geom_bar(stat = "identity", fill = "deepskyblue1") +
      labs(title = "ICU Admissions",
           x = "Date", y = "Number of Pateints")
  })
  
  output$msgOutput<-renderMenu({
    msgs<-apply(read.csv("messages.csv"),1,function(row){
      messageItem(from=row[["from"]],message=row[["message"]])
    })
    
    dropdownMenu(type="messages", .list=msgs)
  })
})