#Install package
install.packages("ggplot2")   
install.packages("caret")     
install.packages("doParallel")
install.packages("ggpubr")    

#Library
library(ggplot2)
library(caret)
library(doParallel)
library(ggpubr)

#Read dataset
S4 <- read.delim("S4_all.txt",header = T,sep = "\t",row.names = 1)
S4_sv1 <- S4[,c(1:27,82)]   #for i-traits from side view image1
S4_sv2 <- S4[,c(28:54,82)]  #for i-traits from side view image2
S4_tv <- S4[,c(55:82)]      #for i-traits from top view image 

#Partitioning the data set
S4_t_index <- createDataPartition(S4$PH, p = .8, list = FALSE, times = 1)
S4_train <- S4[S4_t_index,]
S4_test <- S4[-S4_t_index,]
  
#Parallel
cl <- makePSOCKcluster(10)
registerDoParallel(cl)

#Train model 
model1 <- train(PH ~ ., data = S4_train,
                method = "rf", 
                preProcess = 'scale',
                trControl = fitControl)
#varImp(model1$finalModel,scale=TRUE) # feature importance

#Export model feature importance
write.table(varImp(model1$finalModel,scale=TRUE),file = "S4_all-RF.varImp.txt",sep = "\t")

#Prediction
pred1 <- predict(model1, S4_test) # presiction
#Correllation test
cor.test(pred1,S4_test$PH)   

#Visualization
sca_S4_all <-as.data.frame(cbind(pred1,S4_test$PH)) 
colnames(sca_S4_all) <- c("pred1","PH")
pdf("S4.all.RF.pdf")
ggplot(sca_S4_all,aes(x=PH, y=pred1))+geom_point(color="#00AFBB")+stat_smooth(method="lm",se=T,level=0.99,colour="#00AFBB")+stat_cor(method = "pearson")+
  theme_bw() 
dev.off()

#Export RMSE
postResample(pred = pred1,
             obs = S4_test$PH)
write.table(postResample(pred = pred1,
                         obs = S4_test$PH),file = "S4_all-RF.postResample.txt",sep = "\t")
RMSE(pred1, S4_test$PH) 

#Save model and export dataset
saveRDS(model1$finalModel,file = "S4_all-RF.model") 
write.table(model1$resample,file = "S4_all-RF.resample.txt")   

#10-fold cross validation
cv <- function(peakKmerRes.df, k=10)
{
  require(ranger)
  require(caret)
  folds <- createFolds(peakKmerRes.df$PH, k = k)
  lapply(folds, function(x)
  {
    cv_train <- peakKmerRes.df[-x, ]
    cv_test <- peakKmerRes.df[x, ]
    cv_model <- ranger(PH~., cv_train)
    cv_pred <- predict(cv_model, cv_test)
    corRes <- cor.test(cv_pred$prediction,cv_test$PH)
    return(c(corRes$p.value, corRes$estimate, cv_model$r.squared))
  }
  )
}

L1 <- cv(S4)

#Export 10-fold cross validation results
a <- as.data.frame(L1)
rownames(a) <- c("p.value","estimate","r.squared")
write.table(a,file = "S4_all-RF.cv10.txt",sep = "\t",quote = F) 
