#!/bin/bash

module load biology/bcftools/1.13
module load biology/Samtools/1.15.1


filename='2000_genome.samplelist'
samplelist_dir='/staging2/reserve/flagship/chia2831/TEST_2000_genome_VCFgz/Genomics-Analysis/Bio-preprocessing/Merge_all_vcf/By_Chromosome/'
recode_vcf_dir='/staging2/reserve/flagship/chia2831/TEST_2000_genome_VCFgz/recode_vcf/'


## Check for dir, if not found create it using the mkdir ##
create_dir='/staging2/reserve/flagship/chia2831/TEST_2000_genome_VCFgz/Merge_2000_genome_ByChr/'
[ ! -d "$create_dir" ] && mkdir -p "$create_dir"
output_path=${create_dir}

Output_VCFgz_FilePath='/staging2/reserve/flagship/chia2831/TEST_2000_genome_VCFgz/Merge_2000_genome_ByChr/recode_VCFgz_tbi/'
[ ! -d "$Output_VCFgz_FilePath" ] && mkdir -p "$Output_VCFgz_FilePath"

Output_FilePath='/staging2/reserve/flagship/chia2831/TEST_2000_genome_VCFgz/Merge_2000_genome_ByChr/merged_recode_vcf/'
[ ! -d "$Output_FilePath" ] && mkdir -p "$Output_FilePath"


disease='Genome'
Amount_of_Samples='2000'


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
	bgzip -c ${recode_vcf_dir}${line}_DP10_MAF21.vcf.recode.vcf > ${Output_VCFgz_FilePath}${line}_DP10_MAF21.vcf.recode.vcf.gz
	tabix -p vcf ${Output_VCFgz_FilePath}${line}_DP10_MAF21.vcf.recode.vcf.gz
done < ${samplelist_dir}${filename}
#----- END:     製作 vcf.gz 和 vcf.gz.tbi -----#


#----- START:   拆 Chromosome -----#
while IFS='' read -r line || [[ -n "$line" ]]; do
	for i in "${chr_array[@]}"; do
		echo ${i}
		Output_FilePath_by_Chr="${Output_FilePath}${i}/"
		Output_chrN_VCF="${line}_${i}.recode.vcf"

		bcftools view ${Output_VCFgz_FilePath}${line}_DP10_MAF21.vcf.recode.vcf.gz --regions ${i} -o ${Output_FilePath_by_Chr}${Output_chrN_VCF} -Ov
	done
done < ${samplelist_dir}${filename}
#----- END:	拆 Chromosome -----#
