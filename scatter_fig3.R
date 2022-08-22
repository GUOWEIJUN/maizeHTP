##
#install package
install.packages("GGally")
#library
library("GGally")
#read dataset
dat=read.delim(header=T,file='S6.txt',sep="\t",check.names = FALSE)
head(dat)
#iLI1	iLI2	iLI3	iLI4	iLI5	iLI6	iLI7	iLI8	iLI9	iLI10	iLI11	iLI12	iPH	stage
#0.309	1.069	1.137	1.844	0.148	2.178	1.032	0.312	0.18	1.234	1.482	4.905	5.145	S6_S5
#1.122	0.822	1.572	2.207	1.212	1.465	1.616	2.753	0.153	1.389	5.2	8.247	5.185	S6_S5
#1.137	1.857	2.643	3.097	2.91	0.044	1.61	1.142	5.155	5.171	10.367	11.939	11.956	S6_S5
#0.569	1.814	1.612	1.188	1.524	0.211	0.685	3.755	3.921	2.757	2.143	4.01	16.293	S6_S5
#2.794	2.082	0.294	0.675	0.837	2.604	0.76	0.691	2.057	7.244	9.484	9.347	16.558	S6_S5
#visualization
ggpairs(dat)
