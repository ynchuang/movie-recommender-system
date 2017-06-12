library(shiny)
library(recommenderlab)

#load data
movie = read.csv("movies.csv", header = TRUE)
movies = movie[with(movie, order(title)), ]
rating = read.csv("m.csv", header = TRUE)
#data("u2.test") 

shinyServer(
  function(input,output){

    # Table containing recommendations
    output$table <- renderTable({
      
      movies11 = movies[which(movies$genre1 == input$select2 ),]
      s = as.character(movies11[,3])
      movies1 = s[sample(1:length(movies11),3)]
      given1 =  movies1[1]
      given2 =  movies1[2]
      given3 =  movies1[3]
      
      # Filter for based on genre of selected movies to enhance recommendations
#      cat1 <- subset(movies, title==given1)
#      cat2 <- subset(movies, title==given2)
#      cat3 <- subset(movies, title==given3)
      
      # If genre contains 'Sci-Fi' then  return sci-fi movies
      # If genre contains 'Children' then  return children movies
#      if (grepl("Sci-Fi", cat1$genres) | grepl("Sci-Fi", cat2$genres) | grepl("Sci-Fi", cat3$genres)) {
#        movies2 <- (movies[grepl("Sci-Fi", movies$genres) , ])
#      } else if (grepl("Children", cat1$genres) | grepl("Children", cat2$genres) | grepl("Children", cat3$genres)) {
#        movies2 <- movies[grepl("Children", movies$genres), ]
#      } else {
#        movies2 <- movies[grepl(cat1$genres, movies$genres)
#                          | grepl(cat2$genres, movies$genres)
#                          | grepl(cat3$genres, movies$genres), ]
#      }
      
      movie_recommendation <- function(input1,input2,input3){
        row_num <- which(movies11[,3] == input1)
        row_num2 <- which(movies11[,3] == input2)
        row_num3 <- which(movies11[,3] == input3)
        userSelect <- matrix(NA,length(unique(rating$movieId)))
        userSelect[row_num] <- 5 #hard code first selection to rating 5
        userSelect[row_num2] <- 4 #hard code second selection to rating 4
        userSelect[row_num3] <- 4 #hard code third selection to rating 4
        userSelect <- t(userSelect)
        
        ratingmat <- dcast(rating, userId~movieId, value.var = "rating", na.rm=FALSE)
        ratingmat <- ratingmat[,-1]
        colnames(userSelect) <- colnames(ratingmat)
        ratingmat2 <- rbind(userSelect,ratingmat)
        ratingmat2 <- as.matrix(ratingmat2)
        
        #Convert rating matrix into a sparse matrix
        ratingmat2 <- as(ratingmat2, "realRatingMatrix")
        
        #Create Recommender Model
        recommender_model <- Recommender(ratingmat2, method = "UBCF",param=list(method="Cosine",nn=30))
        recom <- predict(recommender_model, ratingmat2[1], n=30)
        recom_list <- as(recom, "list")
        recom_result <- data.frame(matrix(NA,30))
        recom_result[1:30,1] <- movies11[as.integer(recom_list[[1]][1:30]),3]
        recom_result <- data.frame(na.omit(recom_result[order(order(recom_result)),]))
        recom_result <- data.frame(recom_result[1:5,])
        m1 = as.character(movies[which(movies$movieId == recom_result[1,]),][1,3])
        m2 = as.character(movies[which(movies$movieId == recom_result[2,]),][1,3])
        m3 = as.character(movies[which(movies$movieId == recom_result[3,]),][1,3])
        m4 = as.character(movies[which(movies$movieId == recom_result[4,]),][1,3])
        m5 = as.character(movies[which(movies$movieId == recom_result[5,]),][1,3])
        Recommended_Titles = c(m1, m2, m3, m4, m5)
        recom_result <- data.frame(Recommended_Titles)
        #        return(stm_ans)
#       return(t(movies[which(movies$movieId == t(recom_result)[2]),][3])[1])
        return(recom_result)
      }
      
      movie_recommendation(given1, given2, given3)
      
    })
   
       
  output$progressBox1 = renderInfoBox({
    infoBox(
      "GENDER", paste0(input$select1),  
       icon = icon("venus-mars") ,
      color = "aqua"
    )
  })
  
  output$approvalBox2 = renderInfoBox({
    infoBox(
      "GENRE", paste0(input$select2), icon = icon("film"),
      color = "aqua"
    )
  })
  
  output$approvalBox3 = renderInfoBox({
    infoBox(
      "RATING", paste0(input$select3), icon = icon("thumbs-up"),
      color = "aqua"
    )
  })
  
  # Generate a table summarizing each players stats
  output$myTable = renderDataTable({
    movies[c("title", "genres")]
  })
  
  
  }
)