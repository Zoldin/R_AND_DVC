#!/usr/bin/Rscript
library(Matrix)
library(glmnet)

    # three arguments needs to be provided - train file (.txt, matrix), seed and output name for RData file

args = commandArgs(trailingOnly=TRUE)

if (!length(args)==3) {
  stop("Three arguments must be supplied ( train file (.txt, matrix), seed and argument for RData model name).n", call.=FALSE)
} 



trainMM = readMM(args[1])
set.seed(as.numeric(args[2]))


trainMM_reg <- as.matrix(trainMM)


#t1 = Sys.time()
#mdl = randomForest(x=trainMM_reg[,4500:dim(trainMM_reg)[2]],y=as.factor(trainMM_reg[,1]),ntree=5)
#print(difftime(Sys.time(), t1, units = 'sec'))
#xgboost_mdl = xgboost(data=trainMM_reg[,2:dim(trainMM_reg)[2]],label=trainMM_reg[,1],num_parallel_tree = 5,
#                 nround = 1, objective = "binary:logistic",verbose=2)



t1 = Sys.time()
print("Started to train the model... ")
glmnet_classifier = cv.glmnet(x = trainMM_reg[,2:500], y = trainMM_reg[,1], 
                              family = 'binomial', 
                              # L1 penalty
                              alpha = 1,
                              # interested in the area under ROC curve
                              type.measure = "auc",
                              # 5-fold cross-validation
                              nfolds = 5,
                              # high value is less accurate, but has faster training
                              thresh = 1e-3,
                              # again lower number of iterations for faster training
                              maxit = 1e3)
print("Model generated...")
print(difftime(Sys.time(), t1, units = 'sec'))
#plot(glmnet_classifier)


preds = predict(glmnet_classifier, trainMM_reg[,2:500], type = 'response')[,1]
print("AUC for the train... ")
glmnet:::auc(trainMM_reg[,1], preds)
#print(paste("max AUC =", round(max(glmnet_classifier$cvm), 4)))
save(glmnet_classifier,file=args[3])






