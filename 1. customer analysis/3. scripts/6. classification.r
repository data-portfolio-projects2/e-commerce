install_and_load_packages <- function(packages) {
  new_packages <- packages[!(packages %in% installed.packages()[,"Package"])]
  if(length(new_packages)) {
    install.packages(new_packages)
  }
  lapply(packages, library, character.only = TRUE)
  return(paste("The following packages were successfully installed and loaded: ", paste(packages, collapse = ", ")))
}

required_packages <- c("caret", "ggplot2", "gridExtra", "pROC", "dplyr", "class", "tidyverse", "gridExtra")

check_missing_values <- function(df) {
  missing_values <- sum(is.na(df))
  if (missing_values > 0) {
    missing_details <- colSums(is.na(df))
    return(list(has_missing_values = TRUE, missing_details = missing_details))
  } else {
    return(list(has_missing_values = FALSE, missing_details = NULL))
  }
}

check_column_types <- function(df) {
  categorical_columns <- list()
  numerical_columns <- list()
  for (col in colnames(df)) {
    if (is.factor(df[[col]]) | is.character(df[[col]])) {
      categorical_columns <- c(categorical_columns, col)
    } else if (is.numeric(df[[col]]) | is.integer(df[[col]])) {
      numerical_columns <- c(numerical_columns, col)
    }
  }
  result <- list(
    categorical_columns = categorical_columns,
    numerical_columns = numerical_columns
  )
  return(result)
}

apply_min_max_scaling <- function(df) {
  column_types <- check_column_types(df)
  for (col in column_types$numerical_columns) {
    df[[col]] <- scale(df[[col]], center = min(df[[col]]), scale = max(df[[col]]) - min(df[[col]]))
  }
  return(df)
}

apply_one_hot_encoding <- function(df) {
  column_types <- check_column_types(df)
  for (col in column_types$categorical_columns) {
    one_hot <- model.matrix(~ df[[col]] - 1)
    one_hot <- as.data.frame(one_hot)
    df <- df[, !(colnames(df) == col)]
    df <- cbind(df, one_hot)
  }
  return(df)
}

validate_numeric_columns <- function(df) {
  all_numeric <- all(sapply(df, is.numeric))
  return(all_numeric)
}

process_and_validate_data <- function(df) {
  missing_check <- check_missing_values(df)
  if (missing_check$has_missing_values) {
    stop("Error: Missing values found in the following columns: ", 
         paste(names(missing_check$missing_details[missing_check$missing_details > 0]), collapse = ", "))
  }
  df <- apply_min_max_scaling(df)
  df <- apply_one_hot_encoding(df)
  if (validate_numeric_columns(df)) {
    processed_df <- df
    return(processed_df)
  } else {
    stop("Error: Not all columns are numeric after transformation.")
  }
}

orchestrator_function <- function(df) {
  success <- TRUE
  tryCatch({
    loading_packages_message <- install_and_load_packages(required_packages)
  }, error = function(e) {
    print(paste("Error in installing/loading packages:", e$message))
    success <<- FALSE
  })
  
  tryCatch({
    missing_check <- check_missing_values(df)
  }, error = function(e) {
    print(paste("Error in checking missing values:", e$message))
    success <<- FALSE
  })
  
  tryCatch({
    column_types <- check_column_types(df)
  }, error = function(e) {
    print(paste("Error in checking column types:", e$message))
    success <<- FALSE
  })
  
  tryCatch({
    df <- apply_min_max_scaling(df)
  }, error = function(e) {
    print(paste("Error in applying Min-Max scaling:", e$message))
    success <<- FALSE
  })
  
  tryCatch({
    df <- apply_one_hot_encoding(df)
  }, error = function(e) {
    print(paste("Error in applying One-Hot encoding:", e$message))
    success <<- FALSE
  })
  
  tryCatch({
    all_numeric <- validate_numeric_columns(df)
  }, error = function(e) {
    print(paste("Error in validating numeric columns:", e$message))
    success <<- FALSE
  })
  
  tryCatch({
    processed_df <- process_and_validate_data(df)
  }, error = function(e) {
    print(paste("Error in processing and validating data:", e$message))
    success <<- FALSE
  })
  
  if (success) {
    success_message <- "All functions were successfully executed and the new dataframe was created."
    print(success_message)
    return(processed_df)
  } else {
    print("One or more functions failed. Please check the error messages above.")
    return(NULL)
  }
}

define_target_and_features <- function(df, target_variable) {
  target_columns <- grep(target_variable, colnames(df), value = TRUE)
  if (length(target_columns) == 0) {
    stop("Error: No one-hot encoded columns found for the target variable.")
  }
  target <- apply(df[, target_columns], 1, function(row) {
    which(row == 1)
  })
  features <- df %>% select(-all_of(target_columns))
  return(list(target = target, features = features))
}

split_data <- function(features, target, train_size = 0.8) {
  if (train_size <= 0 || train_size >= 1) {
    stop("Error: Train size must be between 0 and 1.")
  }
  if (anyNA(features) || anyNA(target)) {
    stop("Error: Missing values detected in features or target variable.")
  }
  train_index <- createDataPartition(target, p = train_size, list = FALSE)
  train_data <- features[train_index, ]
  test_data <- features[-train_index, ]
  train_target <- target[train_index]
  test_target <- target[-train_index]
  return(list(
    train_data = train_data,
    test_data = test_data,
    train_target = train_target,
    test_target = test_target
  ))
}

evaluate_knn_accuracy <- function(train_data, test_data, train_target, test_target, max_k = 20) {
  if (!is.data.frame(train_data) || !is.data.frame(test_data)) {
    stop("Error: train_data and test_data should be data frames.")
  }
  if (!is.vector(train_target) || !is.vector(test_target)) {
    stop("Error: train_target and test_target should be vectors.")
  }
  if (length(train_target) != nrow(train_data)) {
    stop("Error: Length of train_target does not match number of rows in train_data.")
  }
  if (length(test_target) != nrow(test_data)) {
    stop("Error: Length of test_target does not match number of rows in test_data.")
  }
  K_values <- 1:max_k
  train_accuracy <- numeric(max_k)
  test_accuracy <- numeric(max_k)
  accuracy_difference <- numeric(max_k)
  for (k_optimal in K_values) {
    knn_train_model <- knn(train = train_data, test = train_data, 
                           cl = train_target, k = k_optimal)
    train_accuracy[k_optimal] <- sum(knn_train_model == train_target) / length(train_target)
    knn_test_model <- knn(train = train_data, test = test_data, 
                          cl = train_target, k = k_optimal)
    test_accuracy[k_optimal] <- sum(knn_test_model == test_target) / length(test_target)
    accuracy_difference[k_optimal] <- abs(train_accuracy[k_optimal] - test_accuracy[k_optimal])
  }
  results <- data.frame(K = K_values, 
                        Train_Accuracy = train_accuracy, 
                        Test_Accuracy = test_accuracy,
                        Accuracy_Difference = accuracy_difference)
  return(results)
}

plot_knn_accuracy <- function(accuracy_values, max_k) {
  results_melted <- accuracy_values %>%
    select(K, Train_Accuracy, Test_Accuracy) %>%
    pivot_longer(cols = c("Train_Accuracy", "Test_Accuracy"), 
                 names_to = "Metric", values_to = "Value")
  accuracy_plot <- ggplot(results_melted, aes(x = K, y = Value, color = Metric, group = Metric)) +
    geom_line(linewidth = 1) +
    geom_point(size = 2) +
    labs(title = "Training vs Test Accuracy for Multiple k", 
         y = "Accuracy", x = "k (Number of Neighbors)") +
    scale_color_manual(values = c("blue", "green"), 
                       labels = c("Training Accuracy", "Test Accuracy")) +
    theme_minimal() +
    theme(legend.title = element_blank())
  grid.arrange(accuracy_plot, ncol = 1)
}

orchestrator_knn <- function(df, target_variable, train_size = 0.8, max_k = 20) {
  target_and_features <- define_target_and_features(df, target_variable)
  target <- target_and_features$target
  features <- target_and_features$features
  split_data_result <- split_data(features, target, train_size)
  train_data <- split_data_result$train_data
  test_data <- split_data_result$test_data
  train_target <- split_data_result$train_target
  test_target <- split_data_result$test_target
  accuracy_values <- evaluate_knn_accuracy(train_data, test_data, train_target, test_target, max_k)
  plot_knn_accuracy(accuracy_values, max_k)
  return(accuracy_values)
}

evaluate_confusion_matrix <- function(knn_model, test_target) {
  test_target <- factor(test_target)
  knn_model <- factor(knn_model, levels = levels(test_target))
  conf_matrix <- confusionMatrix(knn_model, test_target)
  return(conf_matrix)
}

calculate_accuracy <- function(conf_matrix) {
  accuracy <- conf_matrix$overall['Accuracy']
  return(accuracy)
}

calculate_f1_scores <- function(knn_model, test_target) {
  test_target <- factor(test_target)
  knn_model <- factor(knn_model, levels = levels(test_target))
  f1_scores <- sapply(levels(test_target), function(class) {
    true_positive <- sum(knn_model == class & test_target == class)
    false_positive <- sum(knn_model == class & test_target != class)
    false_negative <- sum(knn_model != class & test_target == class)
    precision <- ifelse(true_positive + false_positive > 0, true_positive / (true_positive + false_positive), 0)
    recall <- ifelse(true_positive + false_negative > 0, true_positive / (true_positive + false_negative), 0)
    f1 <- ifelse(precision + recall > 0, 2 * (precision * recall) / (precision + recall), NA)
    return(f1)
  })
  f1_scores <- as.vector(f1_scores)
  names(f1_scores) <- levels(test_target)
  return(f1_scores)
}

create_confusion_matrix_heatmap <- function(conf_matrix) {
  conf_matrix_table <- as.table(conf_matrix$table)
  conf_matrix_df <- as.data.frame(conf_matrix_table)
  colnames(conf_matrix_df) <- c("Actual", "Predicted", "Freq")
  heatmap_plot <- ggplot(conf_matrix_df, aes(Actual, Predicted, fill = Freq)) +
    geom_tile() +
    geom_text(aes(label = Freq), color = "white", size = 6) +
    scale_fill_gradient(low = "white", high = "blue") +
    labs(title = "Confusion Matrix Heatmap", x = "Actual", y = "Predicted") +
    theme_minimal() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))
  return(heatmap_plot)
}

orchestrator_knn_analysis <- function(df, target_variable, train_size = 0.8, k = 4) {
  target_and_features <- define_target_and_features(df, target_variable)
  target <- target_and_features$target
  features <- target_and_features$features
  split_data_result <- split_data(features, target, train_size)
  train_data <- split_data_result$train_data
  test_data <- split_data_result$test_data
  train_target <- split_data_result$train_target
  test_target <- split_data_result$test_target
  knn_model <- apply_knn(train_data, test_data, train_target, k)
  conf_matrix <- evaluate_confusion_matrix(knn_model, test_target)
  print(conf_matrix)
  accuracy <- calculate_accuracy(conf_matrix)
  cat("Accuracy:", accuracy, "\n")
  f1_scores <- calculate_f1_scores(knn_model, test_target)
  cat("F1-Scores by Class:\n")
  print(f1_scores)
  roc_auc <- calculate_roc_auc(knn_model, test_target)
  cat("ROC-AUC Score:", roc_auc, "\n")
  heatmap_plot <- create_confusion_matrix_heatmap(conf_matrix)
  print(heatmap_plot)
  return(list(accuracy = accuracy, f1_scores = f1_scores, roc_auc = roc_auc))
}

plot2 <- ggplot(df_count, aes(x = Income_Category, y = Count, fill = Count_Label)) + 
  geom_bar(stat = "identity") + 
  labs(
    title = "Count Distribution by Income Category", 
    x = "Income Category", 
    y = "Count",
    fill = "Legend"  
  ) +  
  theme_minimal() +
  scale_fill_brewer(palette = "Set2") + 
  scale_x_discrete(labels = labels) +   
  coord_flip()  

