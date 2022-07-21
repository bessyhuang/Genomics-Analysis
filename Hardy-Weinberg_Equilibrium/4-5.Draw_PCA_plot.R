install.packages("tidyverse", repos="http://cran.us.r-project.org")
library(tidyverse)
library(ggplot2)

setwd('/staging/reserve/aging/chia2831/FabryDisease/Merge_Fabry_Aging_total_186/Replaced_header_vcf/HardyWeinberg_result/Create_HWE_filtered_VCF/')


################# START: Scree plot & Cumulative Proportion of Variance Explained plot #################
# Scree plot -> choose principle componets
tiff(filename = "1_screeplot0_PCA_Expt5_HWE_Filtered_0.0005.tiff", height=6, width=8, units='in', res=600)

eigenval <- read.table("FabryDisease_93_HWE_Filtered_0.0005_PCA_Expt5.eigenval")$V1
plot(x=seq(1:length(eigenval)), y=eigenval, type="o", xlab="Principle Component", ylab="Variance")
dev.off()

# Percentage of explained variance
val <- read.table("FabryDisease_93_HWE_Filtered_0.0005_PCA_Expt5.eigenval")

pdf("2_screeplot0_PCA_Expt5_HWE_Filtered_0.0005.pdf")
PC1PC2_plot1 = plot(val$V1[1:pca_num], type="o", pch=18, cex=0.8,
     xlab = "Principal Component",
     ylab = "Proportion of Variance Explained")
dev.off()

# Cumulative Proportion of Variance Explained plot
val <- read.table("FabryDisease_93_HWE_Filtered_0.0005_PCA_Expt5.eigenval")
val$cumulative_percentage = 100*cumsum(val$V1)/sum(val$V1)

pdf("3_Cumulative-Proportion-of-Variance-Explained-Plot0_PCA_Expt5_HWE_Filtered_0.0005.pdf")
per = val$cumulative_percentage
Cumulative_Plot = plot(cumsum(val$V1[1:20]), type="b", pch=18, cex=0.8,
     xlab = "Principal Component",
     ylab = "Cumulative Proportion of Variance Explained")
dev.off()

# PC1 PC2 plot
pca_num = 20
vec <- read.table("FabryDisease_93_HWE_Filtered_0.0005_PCA_Expt5.eigenvec")
colnames(vec) <- c("FID", "IID", paste0(rep("PC", pca_num), c(1:pca_num)))
PC1PC2_plot0 = ggplot(vec, aes(x=PC1, y=PC2)) + geom_point() + theme_classic() + theme(plot.title = element_text(hjust=0.5)) 
ggsave("2_PC1PC2-plot0_PCA_Expt5_HWE_Filtered_0.0005.png")
################# END: Scree plot & Cumulative Proportion of Variance Explained plot #################



# Read .eigenvec
eigenvec <- read.table('Fabry_Aging_186_HWE_Filtered_0.0001_PCA_Expt1.eigenvec', header=FALSE, skip=0, sep=' ')
rownames(eigenvec) <- eigenvec[,2]
eigenvec <- eigenvec[,3:ncol(eigenvec)]
colnames(eigenvec) <- paste('PC', c(1:20), sep = '')

# Read .fam
FAM <- read.table('Fabry_Aging_186_HWE_Filtered_0.0001_bfile_Expt1.fam', header=F, skip=0, sep=' ')

eigenvec$CaseControl <- FAM$V6
eigenvec$CaseControl[eigenvec$CaseControl == 2] <- 'Case'
eigenvec$CaseControl[eigenvec$CaseControl == 1] <- 'Control'
eigenvec$CaseControl <- factor(eigenvec$CaseControl, levels=c("Case","Control"))


# Generate Plot 1: PCA single-plot
PCA_1 <- ggplot(data = eigenvec, mapping = aes(x = PC1, y = PC2, color = CaseControl)) + 
  geom_point() + 
  geom_text(label = rownames(eigenvec), size = 2, nudge_x = 0.005, nudge_y = 0.015)

ggsave("plot1_PCA_Expt1_HWE_Filtered_0.0001.pdf")



# Generate Plot 2: PCA multi-plots
install.packages("ggpubr")
library(ggpubr)

PCA_2 <- ggplot(data = eigenvec, mapping = aes(x = PC1, y = PC3, color = CaseControl)) + 
  geom_point() + 
  geom_text(label = eigenvec$CaseControl, size = 2, nudge_x = 0.01, nudge_y = 0.05)

PCA_3 <- ggplot(data = eigenvec, mapping = aes(x = PC2, y = PC3, color = CaseControl)) + 
  geom_point() + 
  geom_text(label = eigenvec$CaseControl, size = 2, nudge_x = 0.01, nudge_y = 0.05)

multi_plot <- ggarrange(PCA_1, PCA_2, PCA_3 + rremove("x.text"), 
          labels = c("A", "B", "C"),
          ncol = 2, nrow = 2)

ggsave("plot2_PCA_Expt1_HWE_Filtered_0.0001.png")


# 補充：set colours
# library(RColorBrewer)     #創建漸層的顏色範圍
# https://vimsky.com/zh-tw/examples/usage/create-a-range-of-colors-between-the-specified-colors-in-r-programming-colorramppalette-function.html
