#!/bin/bash
#SBATCH -A MST109178
#SBATCH -J concat_CaseControl_vcf
#SBATCH -p ngs384G
#SBATCH -c 56
#SBATCH --mem=372g
#SBATCH -o concat_vcf.std
#SBATCH -e concat_vcf.err

bash 2-3.Merge_all_vcf_for_Separate-Chromosome-and-Merge-Huge-Dataset.sh
