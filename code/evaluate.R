#!/usr/bin/Rscript
library(Matrix)
library(glmnet)

args = commandArgs(trailingOnly=TRUE)

if (!length(args)==3) {
  stop("Three arguments must be supplied ( file name where model is stored (RDataname), test file (.txt, matrix) and file name for AUC output).n", call.=FALSE)
} 


load(args[1])
testMM = readMM(args[2])
testMM_reg <- as.matrix(testMM)


preds = predict(glmnet_classifier, testMM_reg[,2:500] , type = 'response')[, 1]
 glmnet:::auc(testMM_reg[,1], preds)

 

write.table(file=args[3],paste('AUC for the test file is : ',glmnet:::auc(testMM_reg[,1], preds)),row.names = FALSE,col.names = FALSE)
