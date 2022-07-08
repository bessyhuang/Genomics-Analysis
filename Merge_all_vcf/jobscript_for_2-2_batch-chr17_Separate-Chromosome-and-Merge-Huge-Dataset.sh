#!/bin/bash
#SBATCH -A MST109178
#SBATCH -J chr17_Merge_CaseControl_vcf
#SBATCH -p ngs384G
#SBATCH -c 56
#SBATCH --mem=372g
#SBATCH -o merge_chr17_vcf.std
#SBATCH -e merge_chr17_vcf.err

bash 2-2.FixBatch-chr17_Merge_all_vcf_for_Separate-Chromosome-and-Merge-Huge-Dataset.sh
