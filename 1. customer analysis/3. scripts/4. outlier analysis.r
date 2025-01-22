income_bins <- c(-Inf, 15000, 25000, 35000, 50000, 75000, 100000, 150000, 200000, Inf)

income_labels <- c("Under $15,000", "$15,000 to $24,999", "$25,000 to $34,999", 
                   "$35,000 to $49,999", "$50,000 to $74,999", "$75,000 to $99,999", 
                   "$100,000 to $149,999", "$150,000 to $199,999", "$200,000 and over")

df$Income_Category <- cut(df$Income, 
                          breaks = income_bins, 
                          labels = income_labels, 
                          right = FALSE)

df$Outlier <- ifelse(df$Income < min(income_bins) | df$Income > max(income_bins), TRUE, FALSE)

outliers_below_min <- sum(df$Income < min(income_bins)) 
outliers_above_max <- sum(df$Income > max(income_bins))

cat("Number of outliers below minimum:", outliers_below_min, "\n")
cat("Number of outliers above maximum:", outliers_above_max, "\n")
