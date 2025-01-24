set.seed(123)  
sample_indices <- sample(seq_len(nrow(scaled_income)), size = 100) 
sampled_scaled_income <- scaled_income[sample_indices, ]

cosine_dist_matrix_sample <- proxy::dist(sampled_scaled_income, method = "cosine")
cosine_dist_matrix_sample <- as.dist(cosine_dist_matrix_sample)

hc_cosine_sample <- hclust(cosine_dist_matrix_sample, method = "ward.D2")

plot(hc_cosine_sample, main = "Hierarchical Clustering (Sampled Data)")

clusters <- cutree(hc_cosine, k = 4) 

ggplot(income_subset, aes(x = Income, fill = as.factor(Cluster))) +
  geom_histogram(binwidth = 5000, alpha = 0.7, position = "dodge") +
  facet_wrap(~Cluster, scales = "free_y") +  
  labs(
    title = "Income Distribution by Cluster",
    x = "Income",
    y = "Count",
    fill = "Cluster"
  ) +
  scale_fill_viridis_d() +  
  theme_minimal()
