#!/bin/bash
#SBATCH -A MST109178
#SBATCH -J 4-1.HWE_on_merged_VCF
#SBATCH -p ngs384G
#SBATCH -c 56
#SBATCH --mem=372g
#SBATCH -o HWE_4-1.std
#SBATCH -e HWE_4-1.err

bash 4-1.Use_Plink_run_hwe.sh
