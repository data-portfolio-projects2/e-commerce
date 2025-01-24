```
Confusion Matrix and Statistics

          Reference
Prediction    1    2    3    4    5    6
         1    1    1    0    0    0    0
         2    8   29    0    0    0    0
         3    6   17 1170   74    9    6
         4    0    0    0   12   13    7
         5    0    0    0    0   40    3
         6    0    0    0    0    3   24

Overall Statistics
                                         
               Accuracy : 0.8967         
                 95% CI : (0.8797, 0.912)
    No Information Rate : 0.8222         
    P-Value [Acc > NIR] : 2.947e-15      
                                         
                  Kappa : 0.5951         
                                         
 Mcnemar's Test P-Value : NA             

Statistics by Class:

                      Class: 1 Class: 2 Class: 3 Class: 4 Class: 5
Sensitivity          0.0666667  0.61702   1.0000 0.139535  0.61538
Specificity          0.9992898  0.99419   0.5573 0.985041  0.99779
Pos Pred Value       0.5000000  0.78378   0.9126 0.375000  0.93023
Neg Pred Value       0.9901478  0.98701   1.0000 0.946801  0.98188
Prevalence           0.0105411  0.03303   0.8222 0.060436  0.04568
Detection Rate       0.0007027  0.02038   0.8222 0.008433  0.02811
Detection Prevalence 0.0014055  0.02600   0.9009 0.022488  0.03022
Balanced Accuracy    0.5329782  0.80560   0.7787 0.562288  0.80659
                     Class: 6
Sensitivity           0.60000
Specificity           0.99783
Pos Pred Value        0.88889
Neg Pred Value        0.98854
Prevalence            0.02811
Detection Rate        0.01687
Detection Prevalence  0.01897
Balanced Accuracy     0.79892
Accuracy: 0.8966971 
First few predicted values (knn_model):  3 3 3 3 3 3 
First few actual values (test_target):  3 3 3 3 3 3 
Levels of test_target:  1 2 3 4 5 6 
Levels of knn_model:  1 2 3 4 5 6 
F1-scores by Class:  0.1176471 0.6904762 0.954323 0.2033898 0.7407407 0.7164179 
F1-Scores by Class:
        1         2         3         4         5         6 
0.1176471 0.6904762 0.9543230 0.2033898 0.7407407 0.7164179 

ROC-AUC Score: 0.8399382 
```

