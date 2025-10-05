df$Income_Level <- cut(df$Income,
                       breaks = c(-Inf, 68446, 350668, Inf),
                       labels = c("Low", "Medium", "High"),
                       right = FALSE)

df$Age_Segment <- cut(df$Age,
                      breaks = c(-Inf, 30, 43, 56, Inf),
                      labels = c("Emerging Adults", 
                                 "Established Adults", 
                                 "Experienced Adults", 
                                 "Pre-Retirement"),
                      right = TRUE)

