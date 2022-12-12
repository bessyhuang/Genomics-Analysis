#!/bin/bash

Case_Control_list='Case_Control_list.txt'

Input_FilePath='/staging/reserve/aging/chia2831/FabryDisease/Merge_Fabry_Aging_total_186/'

Output_VCFgz_FilePath='/staging/reserve/aging/chia2831/FabryDisease/Merge_Fabry_Aging_total_186/recode_VCFgz_tbi/'
[ ! -d "$Output_VCFgz_FilePath" ] && mkdir -p "$Output_VCFgz_FilePath"

Output_FilePath='/staging/reserve/aging/chia2831/FabryDisease/Merge_Fabry_Aging_total_186/merged_recode_vcf/'
[ ! -d "$Output_FilePath" ] && mkdir -p "$Output_FilePath"

disease='Fabry_Aging'
Amount_of_Samples='186'


## Check for dir, if not found create it using the mkdir ##
chr_array=("chr1" "chr2" "chr3" "chr4" "chr5" "chr6" "chr7" "chr8" "chr9" "chr10" "chr11" "chr12" "chr13" "chr14" "chr15" "chr16" "chr17" "chr18" "chr19" "chr20" "chr21" "chr22" "chrX" "chrY" "chrM")
for i in "${chr_array[@]}"; do
	echo ${i}
	create_dir="${Output_FilePath}${i}/"
	[ ! -d "$create_dir" ] && mkdir -p "$create_dir"
	
	#Output_FilePath_by_Chr=${create_dir}
done


#----- START:	製作 vcf.gz 和 vcf.gz.tbi -----#
while IFS='' read -r line || [[ -n "$line" ]]; do
	/staging/reserve/aging/chia2831/bin/bgzip -c ${Input_FilePath}${line}_DP10_MAF21.vcf.recode.vcf > ${Output_VCFgz_FilePath}${line}_DP10_MAF21.vcf.recode.vcf.gz
	/staging/reserve/aging/chia2831/bin/tabix -p vcf ${Output_VCFgz_FilePath}${line}_DP10_MAF21.vcf.recode.vcf.gz
done < $Case_Control_list
#----- END:     製作 vcf.gz 和 vcf.gz.tbi -----#


#----- START:   拆 Chromosome -----#
while IFS='' read -r line || [[ -n "$line" ]]; do
	for i in "${chr_array[@]}"; do
		echo ${i}
		Output_FilePath_by_Chr="${Output_FilePath}${i}/"
		Output_chrN_VCF="${line}_${i}.recode.vcf"

		/staging/reserve/aging/chia2831/bin/bcftools view ${Output_VCFgz_FilePath}${line}_DP10_MAF21.vcf.recode.vcf.gz --regions ${i} -o ${Output_FilePath_by_Chr}${Output_chrN_VCF} -Ov
	done
done < $Case_Control_list
#----- END:	拆 Chromosome -----#
