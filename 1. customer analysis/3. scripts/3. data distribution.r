# Summary of Categorical Variables
location_summary <- table(df$Location)
gender_summary <- table(df$Gender)

# Convert to data frame for plotting
location_df <- as.data.frame(location_summary)
gender_df <- as.data.frame(gender_summary)

# Rename columns for clarity
colnames(location_df) <- c("Location", "Count")
colnames(gender_df) <- c("Gender", "Count")

# Histogram for Age
plot1 <- ggplot(df, aes(x = Age)) +
  geom_histogram(binwidth = 5, fill = "skyblue", color = "black") +
  labs(title = "Age Distribution", x = "Age", y = "Frequency") +
  theme_minimal()

# Histogram for Income
plot2 <- ggplot(df, aes(x = Income)) +
  geom_histogram(binwidth = 900000, fill = "skyblue", color = "black") +
  labs(title = "Income Distribution", x = "Income", y = "Frequency") +
  theme_minimal()

# Income x Location x Gender
plot3 <- ggplot(df, aes(x = Location, y = log10(Income), fill = Gender)) +
  geom_boxplot() + 
  labs(title = "log distribution: Income x Location x Gender", 
       x = "Location", 
       y = "Log10(Income)") +
  theme_minimal() +
  scale_fill_brewer(palette = "Set2")

# Income x Gender x Location
plot4 <- ggplot(df, aes(x = Gender, y = log10(Income), fill = Location)) +
  geom_boxplot() + 
  labs(title = "log distribution: Income x Gender x Location", 
       x = "Gender", 
       y = "Log10(Income)") +
  theme_minimal() +
  scale_fill_brewer(palette = "Set2")

# Plot for Location Summary
plot5 <- ggplot(location_df, aes(x = Location, y = Count, fill = Location)) +
  geom_bar(stat = "identity") +
  theme_minimal() +
  labs(title = "Location Distribution", x = "Location", y = "Count") +
  theme(legend.position = "none") +
  coord_flip() # Flip the coordinates for horizontal bars

# Plot for Gender Summary
plot6 <- ggplot(gender_df, aes(x = Gender, y = Count, fill = Gender)) +
  geom_bar(stat = "identity") +
  theme_minimal() +
  labs(title = "Gender Distribution", x = "Gender", y = "Count") +
  theme(legend.position = "none") +
  coord_flip() # Flip the coordinates for horizontal bars
