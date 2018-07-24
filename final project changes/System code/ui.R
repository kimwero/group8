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
                       "Controls for the Graph",
                       sliderInput("bins","Number of Breaks",1,100,50),
                       tags$hr(),
                       "The first tab Panel shows the Distribution of Star Ratings ",
                       tags$hr(),
                       "The last tab Panel shows a word cloud of most frequently used words"
                       
                       
                       
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
                   "This tab shows Analyis on the punctuation errors in the Reviews",
                   tags$hr(),
                   "The Reviews with end mark tab Panel shows the distribution of Reviews that have an end mark",
                   tags$hr(),
                   "The Good punctuation Vs star ratings tab Panel shows how poor punctuation affects Review Ratings"
                   
                   
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
                   "This tab shows sentiment analysis on all the reviews",
                   tags$hr(),
                   "Sentiment Analysis comprises of both Polarity and Emotions",
                   tags$hr(),
                   "Emotions tab Panel shows a bar Plot of Emotions scores in the Reviews",
                   tags$hr(),
                   "The Polarity tab Panel shows the polarity scores of the Reviews"
                   
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
                 "This tab contains Analysis on spelling errors",
                 tags$hr(),
                 "The Review Length vs Review rating Shows how Review Length Affects Star Ratings ",
                 tags$hr(),
                 "The spelling Errors tab Panel shows the distribution of Reviews with Spelling Errors ",
                 tags$hr(),
                 "The spellings vs Review Ratings tab Panel shows how spelling errors affect star ratings",
                 tags$hr(),
                 "The frequent spelling errors tab Panel shows the most frequent spelling errors"
                 
               ),
               mainPanel(
                 tabsetPanel(
                   tabPanel("Review Length Vs Review rating",plotOutput("word_count")),
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
  
 

  
