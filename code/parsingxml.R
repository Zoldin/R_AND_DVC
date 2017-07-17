#!/usr/bin/Rscript
library(XML)
args = commandArgs(trailingOnly=TRUE)

if (!length(args)==2) {
  stop("Two arguments must be supplied (input file name ,output file name - csv ext).n", call.=FALSE)
} 

#con <- file("./data/Posts.xml", "r")
con <- file(args[1], "r")


lines <- readLines(con, -1)
test <- lapply(lines,function(x){return(xmlTreeParse(x,useInternalNodes = TRUE))})


ID <- as.numeric(sapply(test,function(x){return(xpathSApply(x, "//row",xmlGetAttr, "Id"))}))

Tags <- sapply(test,function(x){return(xpathSApply(x, "//row",xmlGetAttr, "Tags"))})
Title <- as.character(sapply(test,function(x){return(xpathSApply(x, "//row",xmlGetAttr, "Title"))}))
Body <- as.character(sapply(test,function(x){return(xpathSApply(x, "//row",xmlGetAttr, "Body"))}))
text = paste(Title,Body)

Title = gsub("\n", " ", Title)
Title = gsub("\r", " ", Title)
Title = gsub("\t", " ", Title)

Body = gsub("\n", " ", Body)
Body = gsub("\r", " ", Body)
Body = gsub("\t", " ", Body)



label = as.numeric(sapply(Tags,function(x){return(grep("python",x))}))
label[is.na(label)]=0


df <- as.data.frame(cbind(ID,label,text),stringsAsFactors = FALSE)
df$ID=as.numeric(df$ID)
df$label=as.numeric(df$label)


write.csv(df, file=args[2],row.names=FALSE)
print("output file created....")


