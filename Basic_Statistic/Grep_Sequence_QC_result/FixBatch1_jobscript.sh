#!/bin/bash
#SBATCH -A MST109178
#SBATCH -J 1-70_Reads_info_FD
#SBATCH -p ngs384G
#SBATCH -c 56
#SBATCH --mem=372g
#SBATCH -o fastq_val_1-70.std
#SBATCH -e fastq_val_1-70.err

bash 2.FixBatch1_Get_Reads_info.sh
