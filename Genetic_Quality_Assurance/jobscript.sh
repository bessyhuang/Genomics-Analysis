#!/bin/bash
#SBATCH -A MST109178
#SBATCH -J Samtools_FD
#SBATCH -p ngs384G
#SBATCH -c 56
#SBATCH --mem=372g
#SBATCH -o fastq_val.std
#SBATCH -e fastq_val.err

bash 1.Samtools_get_stats_flagstat_coverage_depth.sh
