library(shiny)
library(shinythemes)
shinyUI(fluidPage(
  theme=shinytheme("yeti"),
  navbarPage(
    title="GRAMMAR AND ONLINE PRODUCT REVIEWS",
    tabPanel("Upload Data",value = "upload Data",
             sidebarLayout(
               sidebarPanel(
                 fileInput("file1", "Upload File to Use",
                           multiple = TRUE,
                           accept = c("text/csv",
                                      "text/comma-separated-values,text/plain",
                                      ".csv")),
                 
                 
                 
                 tags$hr(),
                 h5(helpText("select the table options below")),
                 checkboxInput("header", "Header", TRUE),
                 br(),
                 radioButtons("sep", "Separator",
                              choices = c(Comma = ",",
                                          Semicolon = ";",
                                          Tab = "\t"),
                              selected = ","),
                 tags$hr(),
                 radioButtons("quote", "Quote",
                              choices = c(None = "",
                                          "Double Quote" = '"',
                                          "Single Quote" = "'"),
                              selected = '"')
                 
                 
               ),
               mainPanel(
                 tableOutput("contents")
               )
               
             )
             
             
               
             ),
          tabPanel("Graphs",value = "Graphs",
                   sidebarLayout(
                     sidebarPanel(
                       sliderInput("bins","Number of Breaks",1,100,50)
                       
                     ),
                     mainPanel(
                       tabsetPanel(
                         tabPanel("Distribution of star ratings",plotOutput("hist")),
                         tabPanel("Frequently used words",plotOutput("word_cloud"))
                         
                       )
                       
                     )
                   )
            
          ),
      tabPanel("Punctuation  Analysis",value = "Punctuation Analyis",
               sidebarLayout(
                 sidebarPanel(
                   
                 ),
                 mainPanel(
                   tabsetPanel(
                     tabPanel("Reviews with end mark",plotOutput("punctuation")),
                     tabPanel("Good punctuation Vs star ratings", plotOutput("bar_graph"))
                   )
                   
                 )
               )
               
               ),
      tabPanel("Sentiment Analysis",value = "Sentiment Analysis",
               sidebarLayout(
                 sidebarPanel(
                   
                 ),
                 mainPanel(
                   tabsetPanel(
                     tabPanel("Emotions",plotOutput("emot")),
                     tabPanel("Polarity", plotOutput("pol"))
                   )
                   
                   
                 )
               )
               ),
    tabPanel("Grammar Analysis",value = "Grammar Analysis",
             sidebarLayout(
               sidebarPanel(
                 
               ),
               mainPanel(
                 tabsetPanel(
                   tabPanel("wordcount Vs User rating",plotOutput("word_count")),
                   tabPanel("Spelling Errors",plotOutput("spell_errors")),
                   tabPanel("Spelling Errors Vs Review Rating",plotOutput("spell_review")),
                   tabPanel("frequent Spelling Errors ",plotOutput("miss_pell"))
                   
                   
                 )
               )
             )
             )
    
               
             )
  
      
    )
  )
  
 

  
