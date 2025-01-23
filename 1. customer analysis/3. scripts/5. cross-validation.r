# Perform cross-validation
df$Expected_Bracket <- cut(df$Income,
                           breaks = income_bins, 
                           labels = income_labels, 
                           right = FALSE)

results <- lapply(seq_along(folds), function(i) {
  test_index <- folds[[i]]
  train_data <- df[-test_index, ]
  test_data <- df[test_index, ]

  if (!"Expected_Bracket" %in% names(train_data)) {
    stop("Column 'Expected_Bracket' is missing from train_data.")
  }
  
  if (!"Expected_Bracket" %in% names(test_data)) {
    stop("Column 'Expected_Bracket' is missing from test_data.")
  }
  
  train_data$Income_Category <- cut(
    train_data$Income, 
    breaks = income_bins, 
    labels = income_labels, 
    right = FALSE, 
    include.lowest = TRUE
  )
  test_data$Income_Category <- cut(
    test_data$Income, 
    breaks = income_bins, 
    labels = income_labels, 
    right = FALSE, 
    include.lowest = TRUE
  )
  
  levels(train_data$Income_Category) <- c(levels(train_data$Income_Category), "undefined")
  levels(test_data$Income_Category) <- c(levels(test_data$Income_Category), "undefined")
  train_data$Income_Category[is.na(train_data$Income_Category)] <- "undefined"
  test_data$Income_Category[is.na(test_data$Income_Category)] <- "undefined"
  
  test_data$Expected_Bracket <- factor(
    test_data$Expected_Bracket,
    levels = levels(test_data$Income_Category)
  )
  
  print(paste("Inspecting test_data for fold", i, ":"))
  print(head(test_data[, c("Income", "Income_Category", "Expected_Bracket")]))
  
  accuracy <- mean(
    test_data$Income_Category == test_data$Expected_Bracket,
    na.rm = TRUE
  )
  print(paste("Accuracy for fold", i, ":", accuracy))
  return(accuracy)
})

mean_accuracy <- mean(unlist(results), na.rm = TRUE)
