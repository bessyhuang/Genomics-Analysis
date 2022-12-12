#!/bin/bash
#SBATCH -A MST109178
#SBATCH -J Merge_93_vcf
#SBATCH -p ngs384G
#SBATCH -c 56
#SBATCH --mem=372g
#SBATCH -o fastq_val.std
#SBATCH -e fastq_val.err

bash 2.Merge_all_vcf_for_Whole-Samples-In-One-File.sh
