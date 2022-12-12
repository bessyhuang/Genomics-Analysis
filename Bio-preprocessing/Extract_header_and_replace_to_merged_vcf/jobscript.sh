#!/bin/bash
#SBATCH -A MST109178
#SBATCH -J Replace_header_for_merged_VCF
#SBATCH -p ngs384G
#SBATCH -c 56
#SBATCH --mem=372g
#SBATCH -o fastq_val.std
#SBATCH -e fastq_val.err

bash 3.Extract_header_and_replace_to_merged_vcf.sh
