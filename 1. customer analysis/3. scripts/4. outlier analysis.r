income_bins <- c(-Inf, 15000, 24999, 34999, 49999, 74999, 99999, 149999, 199999, Inf)

df$Income_category <- cut(df$Income, breaks = income_bins, 
                          labels = c("lower_outlier", "$15,000 to $24,999", "$25,000 to $34,999", 
                                     "$35,000 to $49,999", "$50,000 to $74,999", "$75,000 to $99,999", 
                                     "$100,000 to $149,999", "$150,000 to $199,999", "upper_outlier"),
                          right = FALSE)

head(df$Income_category)

outliers_below_min <- sum(df$Income_category == "lower_outlier")  
outliers_above_max <- sum(df$Income_category == "upper_outlier") 

cat("outliers below minimum:", outliers_below_min, "\n")
cat("outliers above maximum:", outliers_above_max, "\n")
