income_subset <- subset(df, Income_Category == "$50,000 to $74,999")

boxplot_income <- ggplot(income_subset, aes(y = Income)) +
  geom_boxplot(fill = "skyblue") +
  labs(title = "Boxplot for $50,000 to $74,999 Income", y = "Income Values") +
  theme_minimal()

histogram_income <- ggplot(income_subset, aes(x = Income)) +
  geom_histogram(fill = "lightgreen", bins = 20, color = "black") +
  labs(title = "Histogram for $50,000 to $74,999 Income", x = "Income Values", y = "Frequency") +
  theme_minimal()

ggplot(income_subset, aes(x = seq_along(Income), y = Income)) + 
  geom_point(color = "blue") +
  labs(title = "Scatterplot for $50,000 to $74,999 Income", x = "Index", y = "Income") +
  theme_minimal()
