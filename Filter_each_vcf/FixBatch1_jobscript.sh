#!/bin/bash
#SBATCH -A MST109178
#SBATCH -J 1-2093_filter_vcf_FD
#SBATCH -p ngs384G
#SBATCH -c 56
#SBATCH --mem=372g
#SBATCH -o fastq_val_1-2093.std
#SBATCH -e fastq_val_1-2093.err

bash 1.FixBatch1_Filter_each_vcfgz.sh
