set.seed(123)

plot_scatter_clusters <- function(distance_method, scaled_data, k, subset_size = 500) {

  dist_matrix <- dist(scaled_data, method = distance_method)
  hc <- hclust(dist_matrix, method = "ward.D2")
  clusters <- cutree(hc, k = k)
  cluster_data <- data.frame(Income = income_subset$Income, Cluster = factor(clusters))
  sampled_data <- cluster_data %>%
    sample_n(subset_size)  
  
  p <- ggplot(sampled_data, aes(x = seq_along(Income), y = Income, color = Cluster)) +
    geom_point(size = 3) +  # Scatter plot
    labs(title = paste("Clusters Visualized with", distance_method, "Distance"), 
         x = "Index", 
         y = "Income") +
    theme_minimal() +
    theme(legend.position = "top")  
  
  return(p)
}

plot_euclidean <- plot_scatter_clusters("euclidean", scaled_income, k = 4, subset_size = 100)
plot_manhattan <- plot_scatter_clusters("manhattan", scaled_income, k = 4, subset_size = 100)
grid.arrange(plot_euclidean, plot_manhattan, ncol = 2)

set.seed(123)  
sample_indices <- sample(seq_len(nrow(scaled_income)), size = 100) 
sampled_scaled_income <- scaled_income[sample_indices, ]
cosine_dist_matrix_sample <- proxy::dist(sampled_scaled_income, method = "cosine")
cosine_dist_matrix_sample <- as.dist(cosine_dist_matrix_sample)
hc_cosine_sample <- hclust(cosine_dist_matrix_sample, method = "ward.D2")
plot(hc_cosine_sample, main = "Hierarchical Clustering (Sampled Data)")

clusters <- cutree(hc_cosine, k = 4) 
