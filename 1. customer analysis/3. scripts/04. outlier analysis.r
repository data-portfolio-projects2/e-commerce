income_bins <- c(-Inf, 15000, 24999, 34999, 49999, 74999, 99999, 149999, 200000, Inf)

df$Income_Category <- cut(df$Income, breaks = income_bins, 
                          labels = c("lower_outlier", "$15,000 to $24,999", "$25,000 to $34,999", 
                                     "$35,000 to $49,999", "$50,000 to $74,999", "$75,000 to $99,999", 
                                     "$100,000 to $149,999", "$150,000 to $200,000", "upper_outlier"),
                          right = FALSE)

plot1 <- ggplot(df, aes(x = Income_Category, y = log10(Income), fill = Income_Category)) + 
  geom_boxplot() + 
  labs(title = "Log Distribution: Income x Income_Category", 
       x = "Income Category", 
       y = "Log10(Income)") +
  theme_minimal() +
  scale_fill_brewer(palette = "Set2")

plot2 <- ggplot(df, aes(x = Income_Category, y = log10(Income), fill = Income_Category)) + 
  geom_bar(stat = "identity") + 
  labs(title = "Log Distribution: Income x Income_Category", 
       x = "Income Category", 
       y = "Log10(Income)") +
  theme_minimal() +
  scale_fill_brewer(palette = "Set2")

plot3 <- ggplot(df_sum, aes(x = Income_Category, y = log10(Total_Income), fill = Income_Category)) + 
  geom_bar(stat = "identity") + 
  labs(title = "Log Distribution: Total Income by Income Category", 
       x = "Income Category", 
       y = "Log10(Total Income)") +
  theme_minimal() +
  scale_fill_brewer(palette = "Set2") + 
  scale_x_discrete(labels = labels)  


