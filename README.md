# maizeHTP
Here, we developed an automated high-throughput phenotyping platform (HTP) and used to quantify 
image-based traits (i-traits) for 228 maize inbred lines across all developmental stages.
We upload all code used in the paper entited "Integrating high-throughput phenotyping, GWAS and
prediction models reveals the genetic architecture of plant height in maize".

First, all i-Traits data were analyed, such as Principal component analysis (PCA) in R (code: PCA_for_FigS1.R, dataset:S.all.trait.txt);

Next, we perdormed Genome-wide association analysis (GWAS) and showed the distribution of significant association SNP at a genome-wide scale (code: CMplot_for_Fig5B.R, dataset: PH.SNP.txt);

Finally, we implemented maize final plant height (PH) prediction using early stage i-Traits based on Random forests (RF) (code: caret_regression_RF_CV10.R, dataset: S4_all.txt).
