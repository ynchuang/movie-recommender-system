library(shiny)
library(shinydashboard)
library(proxy)
library(recommenderlab)
library(reshape2)
library(plyr)
library(dplyr)
library(DT)
library(RCurl)


movie = read.csv("movies.csv", header = TRUE, stringsAsFactors = FALSE)
movies = movie[with(movie, order(title)), ]
rating = read.csv("m.csv", header = TRUE)

shinyUI(dashboardPage(skin="blue",
                      dashboardHeader(title = "VIR System"),
                      dashboardSidebar(
                        sidebarMenu(
                          menuItem("Movies", tabName = "movies", icon = icon("star-o")),
                          menuItem("About", tabName = "about", icon = icon("question-circle")),
                          menuItem("Work", icon = icon("file-code-o"), href = "http://ppt.cc/RTzOO"),
                          menuItem( 
                            list(      selectInput("select1", label = h5("GENDER"),
                                                   choices = as.character(c("M","F")),
                                                   selectize = FALSE,
                                                   selected = "None"),
                                       selectInput("select2", label = h5("GENRES"),
                                                   choices = as.character(unique(movie$genre1[1:length(unique(movie$movieId))])),
                                                   selectize = FALSE,
                                                   selected = "18"),
                                       selectInput("select3", label = h5("RATING"),
                                                   choices = as.character(c(0.5,1,1.5,2,2.5,3,3.5,4,4.5,5)),
                                                   selectize = FALSE,
                                                   selected = "Allen"),
                                       submitButton("Submit")
                            )
                          )
                        )
                      ),
                      
                      dashboardBody(
                        tags$head(
                          tags$style(type="text/css", "select { max-width: 720px; }"),
                          tags$style(type="text/css", ".span4 { max-width: 720px; }"),
                          tags$style(type="text/css",  ".well { max-width: 720px; }")
                        ),
                        
                      tabItems(  
                        tabItem(tabName = "about",
                                  h2("About this App"),
                                  
                                  HTML('<br/>'),
                                  
                                  fluidRow(
                                    box(title = "Author: ALLEN CHUANG", background = "black", width=12, collapsible = TRUE,
                                        
                                        helpText(p(strong("This application a movie reccomnder using the movielense dataset."))),
                                        
                                        helpText(p("Please contact Yu-Neng Chuang on ",
                                                   a(href ="http://ppt.cc/RTzOO", "Facebook",target = "_blank"),
                                                   " or at my",
                                                   a(href ="https://github.com/ALLEN-CHUANG", "Github", target = "_blank"),
                                                   ", for more details and suggest improvements or report errors.")),
                                        
                                        helpText(p("All source code and data is available at ",
                                                   a(href ="https://github.com/ALLEN-CHUANG", "my GitHub page",target = "_blank"),
                                                   "or git from my Github."
                                                )),   
                                        
                                        helpText(p("Special Thanks for NCCU Math Lab and",
                                                 a(href ="https://github.com/moonstarsky37", "Zi-Yu, Huang", target = "_blank"),
                                                 "."))
                                        
                                    )
                                  )
                          ) 
                      ),    
                      tabItem(tabName = "movies",
                              fluidRow(
                                fluidRow(
                                  
                                  infoBoxOutput("progressBox1"),
                                  infoBoxOutput("approvalBox2"),
                                  infoBoxOutput("approvalBox3"),
                                  box(
                                    width = 6, status = "info", solidHead = TRUE,
                                    title = "Movies Recommend You",
                                    tableOutput("table")
                                    ),
                                  HTML('<br/>'),
                                  box(DT::dataTableOutput("myTable"), title = "All Movies We Have", width=12, collapsible = TRUE)
                                )
                              )
                                
                              )
                      )
                  )
)                         
