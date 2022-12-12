library(tidyverse)
library(ggplot2)

setwd('/Users/bessyhuang/Downloads/Fabry_stat/PCA/')

# Read Data
pca_num = 20
eigenval <- read.table("FabryDisease_93_HWE_Filtered_0.0005_PCA_Expt7.eigenval", header=FALSE, skip=0, sep=' ')
eigenvec <- read.table("FabryDisease_93_HWE_Filtered_0.0005_PCA_Expt7.eigenvec", header=FALSE, skip=0, sep=' ')

rownames(eigenvec) <- eigenvec[,2]
eigenvec <- eigenvec[,3:ncol(eigenvec)]
colnames(eigenvec) <- paste('PC', c(1:20), sep = '')

# Read .fam
FAM <- read.table('FabryDisease_93_HWE_Filtered_0.0005_bfile_Expt7.fam', header=F, skip=0, sep=' ')

eigenvec$CaseControl <- FAM$V6
eigenvec$CaseControl[eigenvec$CaseControl == 2] <- 'Case'
eigenvec$CaseControl[eigenvec$CaseControl == 1] <- 'Control'
eigenvec$CaseControl <- factor(eigenvec$CaseControl, levels=c("Case","Control"))

################# START: Scree plot & Cumulative Proportion of Variance Explained plot #################
# Scree plot -> choose principle componets
tiff(filename = "1_screeplot0_PCA_Expt7_HWE_Filtered_0.0005.tiff", height=6, width=8, units='in', res=600)
plot(x=seq(1:length(eigenval$V1)), y=eigenval$V1, type="o", xlim = c(1, 20), ylim = c(0, 10),
     xlab="Principal component", ylab="Number of Variance")
dev.off()

# Percentage of explained variance
pdf("2_screeplot0_Proportion-of-Variance-Explained_PCA_Expt7_HWE_Filtered_0.0005.pdf")
eigenval$percentage = 100*eigenval$V1/sum(eigenval$V1)
plot(eigenval$percentage, type="o", pch=18, cex=0.8, xlim = c(1, 20), ylim = c(0, 100), 
     xlab = "Principal component", ylab = "Proportion of Variance Explained (%)")
dev.off()

# Cumulative Proportion of Variance Explained plot
eigenval$cumulative_percentage = 100*cumsum(eigenval$V1)/sum(eigenval$V1)
pdf("3_Cumulative-Proportion-of-Variance-Explained-Plot0_PCA_Expt7_HWE_Filtered_0.0005.pdf")
plot(eigenval$cumulative_percentage[1:20], type="o", pch=18, cex=0.8,
     xlab = "Principal Component", ylab = "Cumulative Proportion of Variance Explained (%)")
dev.off()
################# END: Scree plot & Cumulative Proportion of Variance Explained plot #################

# Generate Plot 1: PCA single-plot
PCA_1 <- ggplot(data = eigenvec, mapping = aes(x = PC1, y = PC2, color = CaseControl)) + 
  xlim(-1, 1) + ylim(-1, 1) + geom_point()
  geom_text(label = rownames(eigenvec), size = 2, nudge_x = 0.005, nudge_y = 0.015)
ggsave("plot1_PCA_Expt7_HWE_Filtered_0.0005_with_label.pdf")

PCA_1 <- ggplot(data = eigenvec, mapping = aes(x = PC1, y = PC2, color = CaseControl)) + 
  xlim(-1, 1) + ylim(-1, 1) + geom_point()
ggsave("plot1_PCA_Expt7_HWE_Filtered_0.0005_no_label.pdf")


# Generate Plot 2: PCA multi-plots
#install.packages("ggpubr")
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

ggsave("plot2_PCA_Expt7_HWE_Filtered_0.0005.png")


# 補充：set colours
# library(RColorBrewer)     #創建漸層的顏色範圍
# https://vimsky.com/zh-tw/examples/usage/create-a-range-of-colors-between-the-specified-colors-in-r-programming-colorramppalette-function.html
