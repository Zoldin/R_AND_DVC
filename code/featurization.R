#!/usr/bin/Rscript
    #I need two inputs - train and test data set - csv format
    #       two outputs - train and text matrices 

library(text2vec)
library(MASS)
library(Matrix)

args = commandArgs(trailingOnly=TRUE)

if (!length(args)==4) {
  stop("Four arguments must be supplied ( train file (csv format) ,test data set (csv format), train output file name and test output file name - txt files ).n", call.=FALSE)
} 



stop_words=c('a','about','above','across','after','afterwards','again','against','all','almost','alone',
  'along','already','also','although','always','am','among','amongst','amoungst','amount','an','and','another','any','anyhow','anyone','anything',
  'anyway','anywhere','are','around','as','at','back','be','became','because','become',
  'becomes','becoming','been','before','beforehand','behind','being','below','beside','besides','between','beyond','bill','both','bottom','but','by','call',
  'can','cannot','cant','co','con','could','couldnt','cry','de','describe','detail','do','done','down','due','during','each', 'eg',
  'eight', 'either','eleven','else','elsewhere', 'empty',
  'enough','etc','even','ever','every','everyone','everything','everywhere','except','few','fifteen','fifty','fill','find','fire','first','five',
  'for','former','formerly','forty','found','four','from','front','full','further','get','give','go',
  'had','has','hasnt','have','he','hence','her','here','hereafter','hereby','herein','hereupon','hers','herself','him','himself','his','how','however',
  'hundred','i','ie','if','in','inc','indeed','interest','into','is','it','its','itself','keep','last','latter','latterly',
  'least','less','ltd','made','many','may','me','meanwhile','might','mill','mine','more','moreover','most','mostly','move','much','must',
  'my','myself','name','namely','neither','never','nevertheless','next','nine','no','nobody','none','noone','nor',
  'not','nothing','now','nowhere','of','off','often','on','once','one','only','onto','or','other','others','otherwise','our','ours',
  'ourselves','out','over','own','part','per','perhaps','please',
  'put','rather','re','same','see','seem','seemed','seeming','seems','serious',
  'several','she','should','show','side','since','sincere','six','sixty','so','some','somehow','someone','something','sometime','sometimes','somewhere',
  'still','such','system','take','ten','than','that','the','their','them','themselves','then','thence','there',
  'thereafter','thereby','therefore','therein','thereupon','these','they','thick','thin','third','this','those','though','three','through','throughout',
  'thru','thus','to','together','too','top','toward','towards','twelve','twenty','two','un','under','until','up','upon','us','very','via',
  'was','we','well','were','what','whatever','when','whence','whenever','where','whereafter','whereas','whereby','wherein','whereupon','wherever','whether','which',
  'while','whither','who','whoever','whole','whom','whose','why','will','with','within','without','would','yet','you','your',  'yours','yourself','yourselves')


df_train = read.csv(args[1],stringsAsFactors = FALSE)
df_test = read.csv(args[2],stringsAsFactors = FALSE)

#df2 = head(df)
#example <- c( "The sky is blue.", "The sun is bright today.","The sun in the sky is bright.", "We can see the shining sun, the bright sun." )

prep_fun = tolower
tok_fun = word_tokenizer

it_train = itoken(df_train$text,  preprocessor = prep_fun,  tokenizer = tok_fun,  ids = df_train$ID, progressbar = FALSE)
vocab = create_vocabulary(it_train,stopwords = stop_words)

pruned_vocab <- prune_vocabulary(vocab, vocab_term_max=5000)

#str(vocab$vocab$terms)
#str(pruned_vocab$vocab$terms_counts)
#sort(pruned_vocab$vocab$terms)

vectorizer = vocab_vectorizer(pruned_vocab)
dtm_train = create_dtm(it_train, vectorizer)

tfidf = TfIdf$new()
# fit model to train data and transform train data with fitted model
dtm_train_tfidf = fit_transform(dtm_train, tfidf)

it_test = itoken(df_test$text,  preprocessor = prep_fun,  tokenizer = tok_fun,  ids = df_test$ID, progressbar = FALSE)
dtm_test_tfidf  = create_dtm(it_test, vectorizer) %>% 
  transform(tfidf)

dtm_train_tfidf<- Matrix(cbind(label=df_train$label,dtm_train_tfidf),sparse = TRUE)
dtm_test_tfidf<- Matrix(cbind(label=df_test$label,dtm_test_tfidf),sparse = TRUE)



writeMM(dtm_train_tfidf,args[3])
writeMM(dtm_test_tfidf,args[4])

print("Two matrices were created - one for train and one for test data set")


