#!/bin/bash
#SBATCH -A MST109178
#SBATCH -J part00_288
#SBATCH -p ngs384G
#SBATCH -c 56
#SBATCH --mem=372g
#SBATCH -o val_part00.std
#SBATCH -e val_part00.err

source aging_part00.config
#echo $filename
#echo $current_dir

bash check_md5sum.sh $filename $current_dir $target_file $md5sum_file
