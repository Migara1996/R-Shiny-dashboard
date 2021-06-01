library(shiny)
library(shinydashboard)
library(plotly)


# a=read.csv("an_mech_ad.csv")
# a$Var1=as.Date(a$Var1, '%m/%d/%Y')


shinyUI(
  dashboardPage(
    dashboardHeader(title = "Protect ICU Registry",dropdownMenuOutput("msgOutput"),
                    # dropdownMenu(type="message",
                    #              messageItem(from="Finance update",message="We are on threshold"),
                    #              messageItem(from="Sales update",message="Sales are at 55%",icon=icon("bar-chart"),time="22:00"),
                    #              messageItem(from="Sales update",message="Sales meeting at 6 PM on Monday",icon =icon("handshake-o"),time="03-25-2021")
                    #   
                    # )
                    dropdownMenu(type="notifications",
                                 notificationItem(
                                   text="2 new tabs added to the dashboard",
                                   icon=icon("dashboard"),
                                   status="success"
                                 ),
                                 notificationItem(
                                   text="Server is currently running at 95%",
                                   icon=icon("warning"),
                                   status="warning"
                                 )
                                 ),
                    dropdownMenu(type="tasks",
                                 taskItem(
                                 value=80,
                                 color="aqua",
                                 "Shiny Dashboard Education"
                                 ),
                                 taskItem(
                                 value=55,
                                 color="red",
                                 "Overall R Education"
                                 ),
                                 taskItem(
                                 value=40,
                                 color="green",
                                 "Data Science Education"
                                 )
                                 )
                    ),
    
    
    dashboardSidebar(
      sidebarMenu(
      menuItem("Dashboards",tabName="dashboard",icon = icon("dashboard"),
        menuSubItem("My Unit",tabName = "myunit"),
        menuSubItem("My Registry",tabName = "registry")),
      menuItem("Patients",icon = icon("clinic-medical")),
      menuItem("Reports",icon = icon("clipboard-list")),
      menuItem("Resources",icon = icon("atlas")),
      menuItem("Search",icon = icon("search")),
      menuItem("Logout",icon = icon("sign-out"))
    ),collapsed = TRUE),
    dashboardBody(
      tabItems(
        tabItem(tabName="myunit",
                fluidRow(
                  dateRangeInput(
                   inputId="daterange",
                   label="Select the date range",
                   start="2020-05-01",
                   end="2020-05-10",
                   min="2018-01-01",
                   max="2021-01-21",
                   # start=a$Var1[a$Var1=="2020-05-1"],
                   # end=a$Var1[a$Var1=="2020-05-31"],
                   # min=a$Var1[a$Var1=="2020-05-1"],
                   # max=a$Var1[a$Var1=="2020-05-31"],
                   # start=min(a$Var1),
                   # end=max(a$Var1),
                   # min=min(a$Var1),
                   # max=max(a$Var1),
                   format="yyyy/mm/dd",
                   separator="-"
                  
                ),align="center"),
                fluidRow(
                  infoBoxOutput("info1",width = 3),
                  infoBoxOutput("info2",width = 3),
                  infoBoxOutput("info3",width = 3),
                  infoBoxOutput("info4",width = 3)
                  #infoBox(title="Total admissions",value=4,color="aqua",width=3,fill=T,icon = icon("user-alt")),
                  #infoBox(title="Bed occupancy",value="1%",color="aqua",width=3,fill=T,icon = icon("chart-line")),
                  #infoBox(title="Average LoS",color="aqua",width=3,fill=T,icon = icon("calendar-alt")),
                  #infoBox(title="Admission type",color="aqua",width=3,fill=T,icon = icon("procedures")),
                  #infoBox(title="ICU turn over",color="aqua",width=3,fill=T,icon = icon("chart-line"))
                ),
                fluidRow(
                  box(plotlyOutput("histogram"),width = 4,height = 250),
                  box(htmlOutput("apache"),width = 4,title = "Severity of illness score",height=250),
                  box(plotlyOutput("ventilator"),width = 4,height = 250)
                ),
                fluidRow(
                  box(plotlyOutput("anti"),width = 4,height = 320),
                  box(textOutput("reason"),width = 4,title = "Reason for admission",height = 320),
                  box(plotlyOutput("card"),width = 4,height = 320)
                )),
        tabItem(tabName = "registry",
                h1("My Registry")
                )
          
        )
      )

    )
  )


