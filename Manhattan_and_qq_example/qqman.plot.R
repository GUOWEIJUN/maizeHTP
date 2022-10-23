
#install packages

options("repos" = c(CRAN="https://mirrors.tuna.tsinghua.edu.cn/CRAN/"))
options(BioC_mirror="https://mirrors.tuna.tsinghua.edu.cn/bioconductor")
install.packages('qqman')
#==========================================================
rm(list=ls())
library(qqman)

#input file format
#  SNP   CHR   BP   P
color_set <- c ("#E71F19", "#35A6E0","#F19517", "#1B4B9D","#C1D730", "#574497", "#71B92A", "#B54E98", "#6DBB5C", "#E61D4C" )


data<-read.table('dMARAt_S6.input',header=T)
# 取bonferroni矫正阈值
#fdr=0.01/nrow(data)
data_chr1<- subset(data,CHR=="1")

manhattan(data, main = "43", 
          ylim = c(0, 8), cex = 1.0, cex.axis = 0.9, 
          col = color_set, 
          suggestiveline = F, genomewideline = F)

qq(data_chr1$P, main = "43", 
   xlim = c(0, 7), ylim = c(0,8), 
   pch = 20, col = "blue1", cex = 1.5)

#export results
