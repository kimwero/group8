require("datasets")  # This loads the datasets package. 
mtcars1 <- mtcars[, c(1:4, 6:7, 9:11)] # New object, select variables. 
mtcars1[1:3, ] # Show the first three lines of the new object.


km <- kmeans(mtcars1, 3) # Specify 3 clusters 
km
require("cluster") #loads cluster package
clusplot(mtcars1, # Data frame 
         km$cluster, # Cluster data 	
         color = TRUE, # Use color 
         shade = FALSE, # Colored lines in clusters (FALSE is default). 
         lines = 3, # Turns off lines connecting centroids. 
         labels = 2) # Labels clusters and cases. 	
d <- dist(mtcars1) # Calculate the distance matrix. 
c <- hclust(d) # Use distance matrix for clustering. 
plot(c) # Plot a dendrogram of clusters
g3 <- cutree(c, k = 3) # "g3" = "groups: 3" 
g3[30:32] # Show groups for the last three cases. 	
rect.hclust(c, k = 2, border = "gray") 
rect.hclust(c, k = 3, border = "blue") 
rect.hclust(c, k = 4, border = "green4") 
rect.hclust(c, k = 5, border = "red") 	


