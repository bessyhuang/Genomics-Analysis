#!/bin/bash
#SBATCH -A MST109178
#SBATCH -J chrM-25_Merge_CaseControl_vcf
#SBATCH -p ngs384G
#SBATCH -c 56
#SBATCH --mem=372g
#SBATCH -o merge_chrM-25_vcf.std
#SBATCH -e merge_chrM-25_vcf.err

bash 2-2.FixBatch-chrM_Merge_all_vcf_for_Separate-Chromosome-and-Merge-Huge-Dataset.sh
