#!/usr/bin/Rscript
library(caret)

args = commandArgs(trailingOnly=TRUE)

if (!length(args)==5) {
  stop("Five arguments must be supplied (input file name, splitting ratio related to test data set, seed, train output file name, test output file name).n", call.=FALSE)
} 


set.seed(as.numeric(args[3]))

df <- read.csv(args[1],stringsAsFactors = FALSE)

test.index <- createDataPartition(df$label, p = as.numeric(args[2]), list = FALSE)


train <- df[-test.index,]
test  <- df[test.index,]


write.csv(train, file=args[4],row.names=FALSE)
write.csv(test, file=args[5],row.names=FALSE)
print("train/test files created....")

