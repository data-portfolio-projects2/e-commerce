set.seed(123)  
sample_indices <- sample(seq_len(nrow(scaled_income)), size = 100) 
sampled_scaled_income <- scaled_income[sample_indices, ]
cosine_dist_matrix_sample <- proxy::dist(sampled_scaled_income, method = "cosine")
cosine_dist_matrix_sample <- as.dist(cosine_dist_matrix_sample)
hc_cosine_sample <- hclust(cosine_dist_matrix_sample, method = "ward.D2")
plot(hc_cosine_sample, main = "Hierarchical Clustering (Sampled Data)")

clusters <- cutree(hc_cosine, k = 4) 
