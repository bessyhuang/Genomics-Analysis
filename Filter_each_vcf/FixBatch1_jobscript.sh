#!/bin/bash
#SBATCH -A MST109178
#SBATCH -J 1-70_filter_vcf_FD
#SBATCH -p ngs384G
#SBATCH -c 56
#SBATCH --mem=372g
#SBATCH -o fastq_val_1-70.std
#SBATCH -e fastq_val_1-70.err

bash 1.FixBatch1_Filter_each_vcfgz.sh
