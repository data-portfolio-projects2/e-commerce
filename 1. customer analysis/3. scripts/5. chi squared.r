chi_squared_goodness_of_fit <- function(df) {
  
  observed_counts <- table(df$Income_Category)
  total_observations <- sum(observed_counts)
  num_categories <- length(observed_counts)
  expected_counts <- rep(total_observations / num_categories, num_categories)
  
  overall_test <- chisq.test(observed_counts, p = expected_counts / total_observations)
  cat("\nOverall Chi-Squared Test for Income_Category:\n")
  print(overall_test)
  
  cat("\nChi-Squared Goodness-of-Fit Tests for Each Income_Category:\n")
  unique_categories <- unique(df$Income_Category)
  
  for (category in unique_categories) {
   
    subset_data <- df[df$Income_Category == category, ]
    category_observed <- table(subset_data$Income_Category)
    
    if (sum(category_observed) == 0) {
      cat(paste("Skipped category:", category, "- zero counts\n"))
      next
    }
    
    category_total <- sum(category_observed)
    category_expected <- rep(category_total / length(category_observed), length(category_observed))
    category_test <- chisq.test(category_observed, p = category_expected / category_total)
    
    cat(paste("\nCategory:", category, "\n"))
    print(category_test)
  }
}
