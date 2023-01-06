#!/bin/bash

filename='2000_genome.samplelist'
filename_path='/staging2/reserve/flagship/chia2831/TEST_2000_genome_VCFgz/Basic_Statistic/Grep_Sequence_QC_result/'
stats_dir='/staging2/reserve/flagship/chia2831/TEST_2000_genome_VCFgz/Statistic_Data/'

## Check for dir, if not found create it using the mkdir ##
create_dir="/staging2/reserve/flagship/chia2831/TEST_2000_genome_VCFgz/Reads_info/"
[ ! -d "$create_dir" ] && mkdir -p "$create_dir"
output_path=${create_dir}

vcfgz_path='/staging2/reserve/flagship/chia2831/TEST_2000_genome_VCFgz/VCFgz/'
recode_vcf_path='/staging2/reserve/flagship/chia2831/TEST_2000_genome_VCFgz/recode_vcf/'


while IFS='' read -r line || [[ -n "$line" ]]; do
	echo "==> $line"

	# stats
	## grep 'total length' ==> Total Yield
	Total_Yield=`awk 'NR==24' ${stats_dir}${line}.stats`
	echo -e "$line\t$Total_Yield" >> ${output_path}2_Total_Yield.txt

	## CoverageDist
	grep '^COV' ${stats_dir}${line}.stats | cut -f 2- > ${output_path}grep_${line}_stats_COV_all.txt
	### Reads <= 9 Depth
	head -9 ${output_path}grep_${line}_stats_COV_all.txt | awk '$4=s+=$3' | grep '\[9-9\]' | awk '{print $4}' > ${output_path}${line}_CoverageDist_sum_of_First9_row.txt
	### Reads >  9 Depth
	awk 'NR>9' ${output_path}grep_${line}_stats_COV_all.txt | awk '$4=s+=$3' | grep '\[1000<\]' | awk '{print $4}' > ${output_path}${line}_CoverageDist_sum_of_Over9_row.txt
	### Total Reads Depth
	awk '$4=s+=$3' ${output_path}grep_${line}_stats_COV_all.txt | grep '\[1000<\]' | awk '{print $4}' > ${output_path}${line}_CoverageDist_sum_of_Total_row.txt

	CoverageDist_sum_of_First9_Reads=`cat ${output_path}${line}_CoverageDist_sum_of_First9_row.txt`
	CoverageDist_sum_of_Over9_Reads=`cat ${output_path}${line}_CoverageDist_sum_of_Over9_row.txt`
	CoverageDist_sum_of_Total_Reads=`cat ${output_path}${line}_CoverageDist_sum_of_Total_row.txt`
	#echo -e "$line\tReads <= 9 Depth (Reads <  10 Depth)\t$CoverageDist_sum_of_First9_Reads" >> ${output_path}4_CoverageDist_Reads_Depth.txt
	echo -e "$line\tReads >  9 Depth (Reads >= 10 Depth)\t$CoverageDist_sum_of_Over9_Reads"  >> ${output_path}4_CoverageDist_Reads_Depth.txt
	#echo -e "$line\tTotal Reads Depth\t$CoverageDist_sum_of_Total_Reads" >> ${output_path}4_CoverageDist_Reads_Depth.txt

	test_CoverageDist_sum_of_Over9_Reads=`echo "$CoverageDist_sum_of_Total_Reads - $CoverageDist_sum_of_First9_Reads" | bc`
	echo -e "$test_CoverageDist_sum_of_Over9_Reads    vs.   $CoverageDist_sum_of_Over9_Reads   --------- Look!"
	Ratio_of_CoverageDist_sum_of_Over9_Reads=`echo $CoverageDist_sum_of_Over9_Reads / $CoverageDist_sum_of_Total_Reads | bc -l`
	echo -e "$line\tOver 9 Depth Reads / Total Depth Reads = \t$Ratio_of_CoverageDist_sum_of_Over9_Reads" >> ${output_path}4_CoverageDist_Reads_Depth.txt


	# flagstat
	## grep 'in total'
	RawData_Reads_1=`awk 'NR==1' ${stats_dir}${line}.flagstat`
	RawData_Reads_2=`awk 'NR==2' ${stats_dir}${line}.flagstat`
	echo -e "$line\t$RawData_Reads_1" >> ${output_path}1_RawData_Reads_QC-passed_QC-failed.txt
	echo -e "$line\t$RawData_Reads_2\t(QC-passed reads)" >> ${output_path}1_RawData_Reads_QC-passed.txt

	## grep 'duplicates'
	Duplicates_Reads_PassQC=`awk 'NR==5' ${stats_dir}${line}.flagstat`
	echo -e "$line\t$Duplicates_Reads_PassQC" >> ${output_path}2_Duplicates_Reads_PassQC.txt

	## grep 'mapped'
	Mappable_Reads_PassQC=`awk 'NR==7' ${stats_dir}${line}.flagstat`
	echo -e "$line\t$Mappable_Reads_PassQC" >> ${output_path}2_Mappable_Reads_PassQC.txt


	# coverage
	#/staging/reserve/aging/chia2831/bin/samtools coverage ${bam_path}${line}.bam > ${output_path}${line}.coverage


	# depth
	AvgDepth=`awk 'NR==1' ${stats_dir}${line}.avg_depth`
	Stdev=`awk 'NR==2' ${stats_dir}${line}.avg_depth`
	echo -e "$line\t$AvgDepth\t$Stdev" >> ${output_path}3_AvgDepth_Stdev.txt


	# Total Variants (Raw .vcf.gz)
	gunzip ${vcfgz_path}${line}.vcf.gz
	TotalVariants_with_header=`cat ${vcfgz_path}${line}.vcf | wc -l`
	TotalVariants=`echo "$TotalVariants_with_header - 3390" | bc`
	echo -e "$TotalVariants_with_header = $TotalVariants + 3390"
	echo -e "$line\tTotalVariants\t$TotalVariants" >> ${output_path}5_TotalVariants_no_filter.txt


	# Filter Variants (.recode.vcf)
	FilterVariants_with_header=`cat ${recode_vcf_path}${line}_DP10_MAF21.vcf.recode.vcf | wc -l`
        FilterVariants=`echo "$FilterVariants_with_header - 3390" | bc`
        #echo -e "$FilterVariants_with_header = $FilterVariants + 3390"
        echo -e "$line\tFilterVariants\t$FilterVariants" >> ${output_path}6_FilterVariants_yes_filter.txt	

done < ${filename_path}${filename}
