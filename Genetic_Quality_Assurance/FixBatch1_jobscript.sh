#!/bin/bash
#SBATCH -A MST109178
#SBATCH -J 1-10_Samtools_FD
#SBATCH -p ngs384G
#SBATCH -c 56
#SBATCH --mem=372g
#SBATCH -o fastq_val_1-10.std
#SBATCH -e fastq_val_1-10.err

bash 1.FixBatch1_Samtools_get_stats_flagstat_coverage_depth.sh
