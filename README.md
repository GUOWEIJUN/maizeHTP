# maizeHTP
Integrating high-throughput phenotyping, GWAS and prediction models reveals the genetic architecture of plant height in maize

# Introduction
Here, we developed an automated high-throughput phenotyping platform (HTP) and used it to quantify image-based traits (i-traits) for 228 maize inbred lines across all developmental stages. We upload all code used in the paper entitled "Integrating high-throughput phenotyping, GWAS and prediction models reveals the genetic architecture of plant height in maize".

First, the i-Traits were extracted from maize images (code: maize image analysis.iac) on the HTP platform software system, and then all i-Traits data were analyzed, such as Principal component analysis (PCA) in R (code: PCA_for_FigS1.R, dataset:S.all.trait.txt);

Next, we performed genome-wide association analysis (GWAS) and showed the distribution of significant association SNP at a genome-wide scale (code: CMplot_for_Fig5B.R, dataset: PH.SNP.txt);

Finally, we implemented maize final plant height (PH) prediction using early stage i-Traits based on Random forests (RF) (code: caret_regression_RF_CV10.R, dataset: S4_all.txt).

# System requirement
## For GWAS

  1. plink v1.90b6.21   
  2. admixture v1.3.0   
  3. bedtools v2.30.0  
  4. PopLDdecay v3.42
  5. GEC tool v0.2  
  6. TASSEL v5.0
  7. LDBlockShow v1.40

## For data visualization

  1. R v4.1.0  
  2. Rstudio   
  3. R package  
      * ggplot2 v3.3.6  
      * caret v6.0-93  
      * FactoMineR v2.6   
      * factoextra v1.0.7  
      * ggpubr v0.4.0
      


# Quick Start to install the required program
  1. insatll conda  
  
    Download annoconda form conda (https://anaconda.org/anaconda/conda)  
      
  2. create environment and install software  
     
    conda create -n GWAS plink  admixture bedtools   
     
  3. install PopLDdecay form github  
    
    Download PopLDdecay-master.zip and unzip 
    cd PopLDdecaymaster 
    cd src  
    make  
    ../bin/PopLDdecay
    
   **Note:** More detail please see https://github.com/BGI-shenzhen/PopLDdecay
   
  4. install GEC tool 
     
    Downlaod GEC tool from http://pmglab.top/gec/#/download  
    unzip GEC.zip  
  
  5. insatll tassel  
     
    Download TASSEL from https://tassel.bitbucket.io/  
  
  6. install LDBlockShow
  
    Downlaod LDBlockShow-master.zip and unzip  
    tar -zxvf  LDBlockShowXXX.tar.gz  
    cd LDBlockShowXXX;  cd src;  
    sh  make.sh                         
    ../bin/LDBlockShow  
 
  # R package
    install.packages("ggplot2")
    install.packages("caret") 
    install.packages("FactoMineR")
    install.packages("factoextra")  
    install.packages("ggpubr")  
    
# GWAS
## 1. data preparation  
    # All_imputated.hmp
    Download genotype data form maizeGO (http://www.maizego.org/Resources.html)  
    
## 2. Format conversion and filter with MAF (minor allelic frequency)
     
     run_pipeline.pl  -Xmx100g   -SortGenotypeFilePlugin -inputFile All_imputated.hmp -outputFile All_imputated.sort.hmp.txt -fileType Hapmap  
     run_pipeline.pl  -Xms10g   -Xmx100g  -fork1 -h   All_imputated.sort.hmp.txt -export -exportType VCF  
     plink --vcf  All_imputated.vcf    --maf  0.05  --recode vcf-iid --out  All.SNP.filter.maf0.05 --allow-extra-chr  
     
     #2649413 All_imputated.vcf
     #1253830 All.SNP.filter.maf0.05.vcf

          
## 3. Linkagedisequilibrium (LD) calculation and visualization
     
     /home/guoweijun/soft/LD/PopLDdecay-master/bin/PopLDdecay     -InVCF   All_imputated.vcf  -OutStat  LDdecay  -MaxDist  300  -Miss 0.1  -MAF 0.05  
     perl  /home/guoweijun/soft/LD/PopLDdecay-master/bin/Plot_OnePop.pl  -inFile   LDdecay.stat.gz  -output  Fig-all  

## 4. Admixture

     plink --vcf All.SNP.filter.maf0.05.vcf --indep-pairwise 50 10 0.1 --out demo.admixture --allow-extra-chr  
     plink --vcf All.SNP.filter.maf0.05.vcf --recode vcf-iid --extract demo.admixture.prune.in --out demo.admixture.in  
     plink --vcf demo.admixture.in.vcf  --make-bed  --out imputed  
     for K in {1..10}; do admixture --cv  imputed.bed $K | tee log${K}.out; done  
     grep -h CV log*.out  
     #CV error (K=10): 0.85957  
     #CV error (K=1): 0.92360  
     #CV error (K=2): 0.89921  
     #CV error (K=3): 0.88652  
     #CV error (K=4): 0.87761  
     #CV error (K=5): 0.87044  
     #CV error (K=6): 0.86636  
     #CV error (K=7): 0.86133  
     #CV error (K=8): 0.86028  
     #CV error (K=9): 0.86086  

   **Note:** K=10, Q was selected for next analysis.


## 5. Calculating the effective number (EN) of independent SNP

     java -Xmx10g -jar /home/00.soft/kggsee.jar --var-gec --nt 8 --filter-maf-le 0.05 --vcf-ref All.SNP.filter.maf0.05.vcf --out All.SNP.filter.maf0.05.efficent    

     #1828 variants are ignored due to their minor allele frequency (MAF) in sample <=0.05000000074505806
     #1253814 variant-lines (0 indels) are scanned in /mnt/d/guowj/share/MP/response/00.SNP_info/all_data/All.SNP.filter.maf0.05.vcf; and 1251986 variants of 540 individual(s) are retained.

## 6. GWAS using TASSEL
   
     1. Open TASSEL  
     2. Import data  
         Genotype data: All.SNP.filter.maf0.05.vcf  
         Phenotype data  
         Q: imputed.10.Q 
         Kinship:kinship.txt (Tassel - Analysis -Relatedness - Kinship)  
     3. Data - InsertJoin - Analysis - Association - MLM  
     4.Export results  

## 7. Candidate gene analysis

     #.Zm00001d035008	i-TL

     ### 1. Extracting upstream- and down-stream 50kb SNP of significant SNP associated with i-TL  

     zcat  All_imputated.vcf.gz   |awk  -v OFS="\t"  '($1=="6"&&$2>=1487642&&$2<=1591643){print$0}'   >Zm035008.vcf  

     ### 2. Extracting GWAS result  
     awk  -v OFS="\t"  '($3=="6"&&$4>=1487642&&$4<=1591643){print$3,$4,$6}'  GLM_Stats_5.dMPAR_S7.txt  >i-MPAR_S7_Zm035008.GLM.txt  
     awk  -v OFS="\t"  '($3=="6"&&$4>=1487642&&$4<=1591643){print$3,$4,$7}'  MLM_statistics_5.dMPAR_S7.txt  >i-MPAR_S7_Zm035008.MLM.txt  

     ### 3. Extracting significant GWAS result
     
     awk  -v OFS="\t"  '($3=="6"&&$4>=1487642&&$4<=1591643&&$7<=7.98731E-07){print$3,$4,$2}'  MLM_statistics_i-TL.txt   >i-MPAR_S7_Zm035008.MLM.snp  
     
     ### 4.Visualization
     
     ./LDBlockShow-master/bin/LDBlockShow   -InVCF  Zm035008.vcf -OutPut  Zm035008     -InGWAS  i-MPAR_S7_Zm035008.GLM.txt  -Region   6:1487642:1591643    -OutPng    -SeleVar 2  
     ./LDBlockShow-master/bin/ShowLDSVG   -InPreFix  Zm035008  -OutPut   Zm035008.1     -InGWAS   i-MPAR_S7_Zm035008.GLM.txt   -Cutline  6.097599473  -PointSize 15   -OutPng   -SpeSNPName  i-MPAR_S7_Zm035008.GLM.snp  -ShowGWASSpeSNP  

     
    
