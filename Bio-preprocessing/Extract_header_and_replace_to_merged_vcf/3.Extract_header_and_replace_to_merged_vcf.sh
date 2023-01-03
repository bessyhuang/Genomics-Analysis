#!/bin/bash

module load biology/bcftools/1.13

merged_vcf_dir='/staging2/reserve/flagship/chia2831/TEST_2000_genome_VCFgz/Merge_2000_genome/'
disease='Genome'
Amount_of_Samples='2000'


# Extract the VCF header from joint VCF file
awk '{if(/^#/)print;else exit}' ${merged_vcf_dir}${disease}_${Amount_of_Samples}.merge.vcf > ${merged_vcf_dir}header_VCF.txt


# Modify header
sed '1,49!d' ${merged_vcf_dir}header_VCF.txt > ${merged_vcf_dir}NEW_UP_header_VCF.txt

## (1)【 While use bcftools merge 】
sed '3391,3393!d' ${merged_vcf_dir}header_VCF.txt > ${merged_vcf_dir}NEW_DOWN_header_VCF.txt
## (2)【 While use bcftools concat 】
#sed '3391,3397!d' ${merged_vcf_dir}header_VCF.txt > ${merged_vcf_dir}NEW_DOWN_header_VCF.txt

cat ${merged_vcf_dir}NEW_UP_header_VCF.txt ${merged_vcf_dir}NEW_DOWN_header_VCF.txt > ${merged_vcf_dir}NEW_header_VCF.txt


# Replace header
create_dir='/staging2/reserve/flagship/chia2831/TEST_2000_genome_VCFgz/Merge_2000_genome/Replaced_header_vcf/'
[ ! -d "$create_dir" ] && mkdir -p "$create_dir"
output_path=${create_dir}

bcftools reheader -h ${merged_vcf_dir}NEW_header_VCF.txt -o ${output_path}new_${disease}_${Amount_of_Samples}.merge.vcf ${merged_vcf_dir}${disease}_${Amount_of_Samples}.merge.vcf 
