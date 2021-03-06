library(shiny)
library(DT)

ui <- navbarPage( "CRS-medialib harvest monitor",                   
                 ##tabPanel(sprintf("Current (query %s)", file.mtime('/harvesterrors-db.csv')),
                 tabPanel("Current harvest",
                          DT::dataTableOutput("view.current.table")
                          ),
                 tabPanel("Archive",
                          sidebarLayout(
                              sidebarPanel(
                                  selectInput("dataset",
                                              "Choose harvest error file (reload page to refresh list)",
                                              sort(list.files(path="/", pattern="harvest-[0-9]{4}.*\\.csv$"),
                                                   decreasing=TRUE))
                              ),
                              mainPanel(
                                  DT::dataTableOutput("view.harvest.table")
                              )
                              
                          )
                          ),
                 tabPanel("Support",
                          htmlOutput("html.link")
                          )
                 )


