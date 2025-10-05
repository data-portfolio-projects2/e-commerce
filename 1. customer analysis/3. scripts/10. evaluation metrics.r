install.packages(c("cluster", "clValid", "clusterSim", "viridis", "fpc", "proxy"))

library(cluster)       
library(clValid)       
library(clusterSim)  
library(viridis)       
library(fpc)         
library(proxy)         

clusters_euclidean <- clustering_results$EuclideanCluster
clusters_manhattan <- clustering_results$ManhattanCluster
clusters_cosine <- clustering_results$CosineCluster

scaled_income <- clustering_results[, c("Age", "Income")]  

euclidean_dist <- dist(scaled_income, method = "euclidean")
manhattan_dist <- dist(scaled_income, method = "manhattan")
cosine_dist <- dist(scaled_income, method = "cosine")  

hclust_euclidean <- hclust(euclidean_dist, method = "ward.D2")
hclust_manhattan <- hclust(manhattan_dist, method = "ward.D2")
hclust_cosine <- hclust(cosine_dist, method = "ward.D2")

k <- 3
clusters_euclidean_hclust <- cutree(hclust_euclidean, k = k)
clusters_manhattan_hclust <- cutree(hclust_manhattan, k = k)
clusters_cosine_hclust <- cutree(hclust_cosine, k = k)

sil_euclidean <- silhouette(clusters_euclidean, euclidean_dist)
sil_manhattan <- silhouette(clusters_manhattan, manhattan_dist)
sil_cosine <- silhouette(clusters_cosine, cosine_dist)

par(mfrow = c(1, 3))
plot(sil_euclidean, main = "Silhouette Plot (Euclidean)")
plot(sil_manhattan, main = "Silhouette Plot (Manhattan)")
plot(sil_cosine, main = "Silhouette Plot (Cosine)")

dunn_euclidean <- dunn(euclidean_dist, clusters_euclidean)
dunn_manhattan <- dunn(manhattan_dist, clusters_manhattan)
dunn_cosine <- dunn(cosine_dist, clusters_cosine)

cat("Dunn Index (Euclidean):", dunn_euclidean, "\n")
cat("Dunn Index (Manhattan):", dunn_manhattan, "\n")
cat("Dunn Index (Cosine):", dunn_cosine, "\n")

db_euclidean <- index.DB(scaled_income, clusters_euclidean)
db_manhattan <- index.DB(scaled_income, clusters_manhattan)
db_cosine <- index.DB(scaled_income, clusters_cosine)

cat("Davies-Bouldin Index (Euclidean):", db_euclidean$DB, "\n")
cat("Davies-Bouldin Index (Manhattan):", db_manhattan$DB, "\n")
cat("Davies-Bouldin Index (Cosine):", db_cosine$DB, "\n")

cluster_stability <- clusterboot(euclidean_dist, B = 100, clustermethod = hclustCBI, method = "ward.D2", k = 3)
cat("Cluster Stability (Mean Bootstrapped Value):", cluster_stability$bootmean, "\n")

heatmap(as.matrix(scaled_income), Rowv = as.dendrogram(hclust_euclidean),
        col = viridis(100), scale = "row", main = "Cluster Heatmap (Euclidean)")

clustering_df <- data.frame(
  Cluster = factor(c(clusters_euclidean, clusters_manhattan, clusters_cosine)),
  Method = factor(rep(c("Euclidean", "Manhattan", "Cosine"), each = length(clusters_euclidean))),
  stringsAsFactors = TRUE
)

ggplot(clustering_df, aes(x = Cluster, fill = Method)) +
  geom_bar(position = "dodge", stat = "count", width = 0.7) +
  labs(title = "Cluster Distribution across Different Distance Measures",
       x = "Cluster", y = "Frequency") +
  scale_fill_viridis_d(name = "Distance Measure") +
  theme_minimal() +
  theme(legend.position = "top")
