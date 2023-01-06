#!/bin/bash

filename='takeda.samplelist'
filename_path='/staging2/reserve/flagship/chia2831/TEST_2000_genome_VCFgz/Genomics-Analysis/Basic_Statistic/Genetic_Quality_Assurance/'

bam_path='/staging2/reserve/flagship/chia2831/TEST_2000_genome_VCFgz/BAM/'

## Check for dir, if not found create it using the mkdir ##
create_dir='/staging2/reserve/flagship/chia2831/TEST_2000_genome_VCFgz/Statistic_Data/'
[ ! -d "$create_dir" ] && mkdir -p "$create_dir"
output_path=${create_dir}


while IFS='' read -r line || [[ -n "$line" ]]; do
	# Check file exist or not
        echo "==> $line"
        echo -e "`ls ${bam_path} | grep ${line}`"

	# stats
	/staging/reserve/aging/chia2831/bin/samtools stats --thread 50 ${bam_path}${line}.bam > ${output_path}${line}.stats

	# flagstat
	/staging/reserve/aging/chia2831/bin/samtools flagstat --thread 50 ${bam_path}${line}.bam > ${output_path}${line}.flagstat

	# coverage
	/staging/reserve/aging/chia2831/bin/samtools coverage ${bam_path}${line}.bam > ${output_path}${line}.coverage

	# depth
	/staging/reserve/aging/chia2831/bin/samtools depth --thread 50 ${bam_path}${line}.bam | awk '{sum+=$3; sumsq+=$3*$3} END { print "Average = ",sum/NR; print "Stdev = ",sqrt(sumsq/NR - (sum/NR)**2)}' > ${output_path}${line}.avg_depth

done < ${filename_path}${filename}
