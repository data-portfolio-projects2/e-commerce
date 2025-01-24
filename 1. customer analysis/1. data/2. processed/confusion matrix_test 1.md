```
Confusion Matrix and Statistics

          Reference
Prediction    1    2    3    4    5    6
         1    0    3    0    0    0    0
         2    9   31    0    0    0    0
         3    4   22 1163   71    2    2
         4    0    0    0   13    7    4
         5    0    0    0    0   46   17
         6    0    0    0    0    1   28

Overall Statistics
                                          
               Accuracy : 0.9002          
                 95% CI : (0.8835, 0.9153)
    No Information Rate : 0.8173          
    P-Value [Acc > NIR] : < 2.2e-16       
                                          
                  Kappa : 0.6296          
                                          
 Mcnemar's Test P-Value : NA              

Statistics by Class:

                     Class: 1 Class: 2 Class: 3 Class: 4 Class: 5
Sensitivity          0.000000  0.55357   1.0000 0.154762  0.82143
Specificity          0.997872  0.99342   0.6115 0.991785  0.98756
Pos Pred Value       0.000000  0.77500   0.9201 0.541667  0.73016
Neg Pred Value       0.990845  0.98192   1.0000 0.949249  0.99265
Prevalence           0.009136  0.03935   0.8173 0.059030  0.03935
Detection Rate       0.000000  0.02178   0.8173 0.009136  0.03233
Detection Prevalence 0.002108  0.02811   0.8883 0.016866  0.04427
Balanced Accuracy    0.498936  0.77349   0.8058 0.573273  0.90450
                     Class: 6
Sensitivity           0.54902
Specificity           0.99927
Pos Pred Value        0.96552
Neg Pred Value        0.98350
Prevalence            0.03584
Detection Rate        0.01968
Detection Prevalence  0.02038
Balanced Accuracy     0.77415
Accuracy: 0.9002108 
First few predicted values (knn_model):  3 3 3 3 3 3 
First few actual values (test_target):  3 3 3 3 3 3 
Levels of test_target:  1 2 3 4 5 6 
Levels of knn_model:  1 2 3 4 5 6 
F1-scores by Class:  NA 0.6458333 0.9583848 0.2407407 0.7731092 0.7 
F1-Scores by Class:
        1         2         3         4         5         6 
       NA 0.6458333 0.9583848 0.2407407 0.7731092 0.7000000

ROC-AUC Score: 0.8716907 
```
