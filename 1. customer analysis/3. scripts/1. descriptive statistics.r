summary(df)

# Summary of Categorical Variables
location_summary <- table(df$Location)
gender_summary <- table(df$Gender)

print("Location Distribution")
print(location_summary)

print("Gender Distribution")
print(gender_summary)
