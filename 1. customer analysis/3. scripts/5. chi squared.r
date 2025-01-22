chi_squared_goodness_of_fit <- function(income_category) {

  subset_data <- df[df$Income_Category == income_category, ]
  
  observed_counts <- table(subset_data$Age_Segment)
  
  if (all(observed_counts > 0)) {
 
    total_observations <- sum(observed_counts)
    expected_counts <- rep(total_observations / length(observed_counts), length(observed_counts))
    
    chi_squared_test <- chisq.test(observed_counts, p = expected_counts / total_observations)
    
    cat(paste("Chi-Squared Test for Income_Category =", income_category, ":\n"))
    print(chi_squared_test)
    cat("\n")
  } else {
   
    cat(paste("Chi-Squared Test for Income_Category =", income_category, ": Skipped (Zero counts in observed data)\n"))
  }
}

chi_square_results <- chisq.test(table(df$Income_Category, df$Age_Segment))
print(chi_square_results)  

unique_categories <- unique(df$Income_Category)
for (category in unique_categories) {
  chi_squared_goodness_of_fit(category)
}
