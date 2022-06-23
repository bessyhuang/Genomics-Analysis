#!/bin/bash

filename='CaseControl_70.list'
DirName='Merge_Fabry_total_70'
current_dir='/staging/reserve/aging/chia2831/FabryDisease/Merge_Fabry_total_70/'

mkdir /staging/reserve/aging/chia2831/FabryDisease/Merge_Fabry_total_70/Statistic_Data/

bam_path='/staging/reserve/aging/chia2831/FabryDisease/Output/hg38/BAM/'
output_path='/staging/reserve/aging/chia2831/FabryDisease/Merge_Fabry_total_70/Statistic_Data/'

while IFS='' read -r line || [[ -n "$line" ]]; do
	# Check file exist or not
        echo "==> $line"
        echo -e "`ls ${current_dir} | grep ${line}`"

	# stats
	/staging/reserve/aging/chia2831/bin/samtools stats --thread 50 ${bam_path}${line}.bam > ${output_path}${line}.stats

	# flagstat
	/staging/reserve/aging/chia2831/bin/samtools flagstat --thread 50 ${bam_path}${line}.bam > ${output_path}${line}.flagstat

	# coverage
	/staging/reserve/aging/chia2831/bin/samtools coverage ${bam_path}${line}.bam > ${output_path}${line}.coverage

	# depth
	/staging/reserve/aging/chia2831/bin/samtools depth --thread 50 ${bam_path}${line}.bam | awk '{sum+=$3; sumsq+=$3*$3} END { print "Average = ",sum/NR; print "Stdev = ",sqrt(sumsq/NR - (sum/NR)**2)}' > ${output_path}${line}.avg_depth

done < $filename
