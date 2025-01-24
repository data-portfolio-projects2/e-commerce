kruskal_result <- kruskal.test(Income ~ Income_Category, data = df)

print(kruskal_result)

if (kruskal_result$p.value < 0.05) {
  pairwise_result <- pairwise.wilcox.test(df$Income, df$Income_Category, p.adjust.method = "BH")
  print(pairwise_result)
} else {
  print("No significant differences between income levels.")
}
