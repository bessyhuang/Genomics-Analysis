#!/bin/bash
#SBATCH -A MST109178
#SBATCH -J Merge_CaseControl_vcf
#SBATCH -p ngs384G
#SBATCH -c 56
#SBATCH --mem=372g
#SBATCH -o merge_vcf.std
#SBATCH -e merge_vcf.err

bash 2-1.Merge_all_vcf_for_Separate-Chromosome-and-Merge-Huge-Dataset.sh
