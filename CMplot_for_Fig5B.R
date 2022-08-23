#Install package
install.packages("CMplot")

#Library
library("CMplot")

#a. first column is SNP
#b. second column is chromosome
#c. third column is position


#Read dataset
data <- read.table("PH.SNP.txt",header=T)

# users can personally set the windowsize and the max of legend by:
# bin.size=1e6
# bin.max=N
# memo: add a character to the output file name.

CMplot(
  data, plot.type="d",  bin.size=1e6, col=c("darkgreen", "yellow", "red"),
  file="jpg", memo="Fig1", dpi=1200, file.output=TRUE, verbose=TRUE
)
