# R_AND_DVC
Codes were made for testing purposes - Data version control on R example.
R example was made in R version 3.4.0 (2017-04-21), 64bit version, on linux machine 

   R version 3.4.0 (2017-04-21) -- "You Stupid Darkness"
   Copyright (C) 2017 The R Foundation for Statistical Computing
   Platform: x86_64-pc-linux-gnu (64-bit)

Following R codes were created:

1) requirements.R will install necessary packages into local computer
Run this job only once, you need to install packages that are used in this project (Matrix, MASS, glmnet etc).

2) parsingxml.R will take only relevant columns from Posts.xml and stores them into a csv file (xml file is located at  https://s3-us-west-2.amazonaws.com/dvc-share/so/25K/Posts.xml.tgz). This R code can only work with downloaded file).

   Rscript cmd that runs this job:
   Rscript --vanilla code/parsingxml.R data/Posts.xml data/Posts.csv
   Two arguments are needed : input file name (in this case Posts.xml) and output file name (csv file name needs to be defined)
   
3) train_test_spliting.R - stratified sampling by target variables. Two outputs (txt files will be created - one for train and other for test)

    Rscript cmd that runs this job:
    Rscript --vanilla code/train_test_spliting.R data/Posts.csv 0.33 20170426 data/train_post.csv data/test_post.csv
    5 arguments are needed : input file (csv file name that was created with parsingxml.R)
                             splitting ratio (how big test ds will be) 
                             seed number
                             output csv file for the train data
                             output csv file for the test data
                             
4) featurization.R - feature extaction. From provided posts we will create variables that will be used to model training. 
   Term frequency and inverse frequency matrix will be created for train and test data set (vocabular is created on train data set). For detail exaplanation check https://en.wikipedia.org/wiki/Tf%E2%80%93idf
   
   Rscript cmd that runs this job:
   Rscript --vanilla code/featurization.R data/train_post.csv data/test_post.csv data/matrix_train.txt data/matrix_test.txt
   4 arguments are needed:  train data - csv file name (created with train_test_spliting.R)
                            test data - csv file name (created with train_test_spliting.R)
                            txt file name in which matrix with the train data will be saved
                            txt file name in which matrix with the test data will be saved
                            
5) train_model.R - model building. From TF-IDF matrices we will try to build a model and predict a target variable
   Here we are using glmnet algorithm - logistic regression (class probabilities)
   
   Rscript cmd that runs this job:
   Rscript --vanilla code/train_model.R data/matrix_train.txt 20170426 data/glmnet.Rdata
   3 arguments are needed: txt file name in which matrix with the train data is saved (created in featurization.R)
                           seed number
                           file name (.RData) for model storing
                  
6) evaluate.R - model validation on test data. AUC will be printed as a result in txt format
  
    Rscript cmd that runs this job:
    Rscript --vanilla code/evaluate.R data/glmnet.Rdata data/matrix_test.txt data/evaluation.txt
    3 arguments are needed: Rdata name where glmnet model is stored
                            file name where are the test data (matrix created in step featurization.R)
                            output file name where AUC will be stored
                            


                 
   
