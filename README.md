# maizeHTP
Integrating high-throughput phenotyping, GWAS and prediction models reveals the genetic architecture of plant height in maize

# Introduction
Here, we developed an automated high-throughput phenotyping platform (HTP) and used it to quantify image-based traits (i-traits) for 228 maize inbred lines across all developmental stages. We upload all code used in the paper entitled "Integrating high-throughput phenotyping, GWAS and prediction models reveals the genetic architecture of plant height in maize".

First, the i-Traits were extracted from maize images (code: maize image analysis.iac) on the HTP platform software system, and then all i-Traits data were analyzed, such as Principal component analysis (PCA) in R (code: PCA_for_FigS1.R, dataset:S.all.trait.txt);

Next, we performed genome-wide association analysis (GWAS) and showed the distribution of significant association SNP at a genome-wide scale (code: CMplot_for_Fig5B.R, dataset: PH.SNP.txt);

Finally, we implemented maize final plant height (PH) prediction using early stage i-Traits based on Random forests (RF) (code: caret_regression_RF_CV10.R, dataset: S4_all.txt).

# System requirement
For GWAS

   1.plink 1.90b6.21   
   2.admixture 1.3.0   
   3.bedtools 2.30.0  

For data visualization

   1.R 4.1.0  
   2.Rstudio   
   3.R package  

(1) ggplot2 3.3.6

(2) caret 6.0-93


# GWAS
1.data preparation
