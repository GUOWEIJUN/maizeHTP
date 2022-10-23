#PCA analysis

#Install package
install.packages("FactoMineR")
install.packages("factoextra")

#Library
library("FactoMineR")
library("factoextra")

#Read dataset
S <- read.table("S.all.trait.txt",header = T,sep ="\t")

#PCA analysis
S.pca <- PCA(S, graph = FALSE)
fviz_pca_var(S.pca, col.var = "black")


#Variance analysis
var <- get_pca_var(S.pca)
var$cos2

library("corrplot")
pdf("PCA.cos.pdf",width = 15,height = 15)
corrplot(var$cos2,is.corr=FALSE)
dev.off()


pdf("PCA.corr.pdf",width = 8,height = 8)
fviz_pca_var(S.pca, col.var = "cos2",
             gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"),
             repel = TRUE # Avoid text overlapping
)
dev.off()

library("corrplot")
pdf("PCA.contrib.pdf",width = 15,height = 15)
corrplot(var$contrib, is.corr=FALSE)
dev.off()

#Contribution
png("PCA.contrib.png",width = 8,height = 8)
fviz_pca_var(S.pca, col.var = "contrib",
             gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07")
)
dev.off()

