library(shiny)
library(ggplot2)
library(hunspell)
library(textclean)
library(tm)
library(syuzhet)
library(SnowballC)
library(RColorBrewer)
library(wordcloud)
options(shiny.maxRequestSize=98*1024^2)

shinyServer(
  function(input, output){
    #using reactive function to upload data
    data<-reactive({
      req(input$file1)
      df <- read.csv(input$file1$datapath,
                     header = input$header,
                     sep = input$sep,
                     quote = input$quote)
      return(df)
      
      
    })
    #outputing the first 6 columns of the data
    output$contents <- renderTable({
      
      head(data())
      
    })
     #histogram showing the distribution of star ratings across the products
     output$hist<-renderPlot({
       
       ggplot(data= as.data.frame(data()),aes(x=reviews.rating))+geom_histogram(bins = input$bins)+
         theme_bw()+
         labs(title="Distribution of star ratings a cross products",
              subtitle="A histogram showing the  distribution of star ratings across products",
              x="Star ratings",
              y="Number of products")
     })
     #bar plot to showing how reviews with an end mark affects the rating
     output$bar_graph<-renderPlot({
       good_punctiation<-has_endmark(data()$reviews.text)
       new_data<-cbind(data(),good_punctiation)
       ggplot(data=new_data,aes(x=reviews.rating,fill=good_punctiation))+
         geom_bar(position = "fill")+
         theme_bw()+
         labs(title="A bar graph to showing how good punctuation affects review ratings",
              x="Review Ratings",
              y="Probability")
     })
     #bar plot showing the distribution of reviews with an end mark
     output$punctuation<-renderPlot({
       good_punctuation<-has_endmark(data()$reviews.text)
       new_data<-cbind(data(),good_punctuation)
       ggplot(data= new_data,aes(x=good_punctuation,fill=good_punctuation))+geom_bar()+
         theme_bw()+
         labs(title="Distribution of reviews with an end mark at the end",
              x="Good punctuation",
              y="Number of Reviews")
       
     })
     #a wor cloud showing the most frequently used words
     output$word_cloud<-renderPlot({
       words<-data()$reviews.text
       #creating a corpus
       data2.Corpus<-Corpus(VectorSource(words))
       #cleaning the review content
       data2.Clean<-tm_map(data2.Corpus, PlainTextDocument)
       data2.Clean<-tm_map(data2.Corpus,tolower)
       data2.Clean<-tm_map(data2.Clean,removeNumbers)
       data2.Clean<-tm_map(data2.Clean,removeWords,stopwords("english"))
       data2.Clean<-tm_map(data2.Clean,removePunctuation)
       data2.Clean<-tm_map(data2.Clean,stripWhitespace)
       data2.Clean<-tm_map(data2.Clean,stemDocument)
       #styling the wordcloud
       wordcloud(words = data2.Clean, min.freq = 100,
                 max.words=1000,random.order = FALSE, 
                 colors=brewer.pal(8, "Dark2"))
       
     })
     # a bar plot showing sentiments basing on emotions
     output$emot<-renderPlot({
       mydataCopy <- data()$reviews.text
       #carryout sentiment mining using the get_nrc_sentiment()function #log the findings under a variable result
       result <- get_nrc_sentiment(as.character(mydataCopy))
       #change result from a list to a data frame and transpose it 
       result1<-data.frame(t(result))
       #rowSums computes column sums across rows for each level of a #grouping variable.
       new_result <- data.frame(rowSums(result1))
       #name rows and columns of the dataframe
       names(new_result)[1] <- "count"
       new_result <- cbind("sentiment" = rownames(new_result), new_result)
       rownames(new_result) <- NULL
       #plot the first 8 rows,the distinct emotions
       qplot(sentiment, data=new_result[1:8,], weight=count, geom="bar",fill=sentiment)+ggtitle("Product Reviews Sentiments")
     })
     #A barplot showing sentiment analysis basing on polarity
     output$pol<-renderPlot({
       mydataCopy <- data()$reviews.text
       #carryout sentiment mining using the get_nrc_sentiment()function #log the findings under a variable result
       result <- get_nrc_sentiment(as.character(mydataCopy))
       #change result from a list to a data frame and transpose it 
       result1<-data.frame(t(result))
       #rowSums computes column sums across rows for each level of a #grouping variable.
       new_result <- data.frame(rowSums(result1))
       #name rows and columns of the dataframe
       names(new_result)[1] <- "count"
       new_result <- cbind("sentiment" = rownames(new_result), new_result)
       rownames(new_result) <- NULL
       #plot the last 2 rows ,positive and negative
       qplot(sentiment, data=new_result[9:10,], weight=count, geom="bar",fill=sentiment)+ggtitle("Product Reviews Polarity")
       
     })
     #A box plot showing how Review Length affects the star ratings
     output$word_count<-renderPlot({
       word_count<-sapply(strsplit(as.character(data()$reviews.text), " "), length)
       extra_data<-cbind(data(),word_count)
       extra_data
       ggplot(data=extra_data,aes(x=as.factor(reviews.rating),y=word_count,fill=as.factor(reviews.rating)))+
         theme_bw()+
         geom_boxplot()+
         labs(title="Boxplot showing how the Review Length affects the star ratings across the products",
              x="Review Rating",
              y="Review Length")
       
     })
     #A bar plot showing the distribution of reviews with spelling errors
     output$spell_errors<-renderPlot({
       check_data<-hunspell_find(as.character(data()$reviews.text))
       check_data<-as.character(check_data)
       new_data<-cbind(data(),check_data)
       good_spelling<-new_data$check_data=="character(0)"
       new_data1<-cbind(new_data,good_spelling)
       #plotting the distribution of reveiews with spelling out errors
       ggplot(data=new_data1,aes(x=good_spelling,fill=good_spelling))+
         theme_bw()+
         geom_bar()+
         labs(title="Bar plot showing the distribution Of Reviews with spelling Errors",
              x="Good Spelling",
              y="Number of Reviews")
     })
     #A histogram showing how spelling errors affect star ratings
     output$spell_review<-renderPlot({
       check_data<-hunspell_find(as.character(data()$reviews.text))
       check_data<-as.character(check_data)
       new_data<-cbind(data(),check_data)
       good_spelling<-new_data$check_data=="character(0)"
       new_data1<-cbind(new_data,good_spelling)
       #how spellings affect star ratings
       ggplot(data =new_data1,aes(x=reviews.rating,fill=good_spelling))+
         geom_histogram(bins = 30)+
         theme_bw()+
         labs(title="A histogram showing the distribution of Reviews with spelling Errors According to rating",
              x="Review Rating",
              y="Number of Reviews")
     })
     #A word cloud showing most frequently made spelling errors
     output$miss_pell<-renderPlot({
       poor_spellings<-hunspell_find(as.character(data()$reviews.text))
       poor_spellings<-as.character(poor_spellings)
       new_data<-cbind(data(),poor_spellings)
       #filtering
       check_data<-new_data$poor_spellings=="character(0)"
       #binding data
       new_data1<-cbind(new_data,check_data)
       get_words<-new_data1$reviews.text[new_data1$check_data=="FALSE"]
       bad_words<-hunspell_find(as.character(get_words))
       #creating a corpus
       bad_words.Corpus<-Corpus(VectorSource(bad_words))
       #cleaning the corpus data
       bad_words.Clean<-tm_map(bad_words.Corpus, PlainTextDocument)
       bad_words.Clean<-tm_map(bad_words.Corpus,tolower)
       bad_words.Clean<-tm_map(bad_words.Clean,removeNumbers)
       bad_words.Clean<-tm_map(bad_words.Clean,removePunctuation)
       bad_words.Clean<-tm_map(bad_words.Clean,stripWhitespace)
       bad_words.Clean<-tm_map(bad_words.Clean,stemDocument)
       #making a word cloud
       wordcloud(words = bad_words.Clean, min.freq = 25,
                 max.words=1000,random.order = FALSE, 
                 colors=brewer.pal(8, "Dark2"))
     })
  }
 
)