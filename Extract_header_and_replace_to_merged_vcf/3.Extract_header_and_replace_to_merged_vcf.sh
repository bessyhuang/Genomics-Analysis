#!/bin/bash

current_dir='/staging/reserve/aging/chia2831/FabryDisease/Fabry_Data_93/Merge_Fabry_total_93/'
disease='FabryDisease'
Amount_of_Samples='93'



# Extract the VCF header from joint VCF file
awk '{if(/^#/)print;else exit}' ${current_dir}${disease}_${Amount_of_Samples}.merge.vcf > ${current_dir}header_VCF.txt


# Modify header
sed '1,49!d' ${current_dir}header_VCF.txt > ${current_dir}NEW_UP_header_VCF.txt
sed '3391,3393!d' ${current_dir}header_VCF.txt > ${current_dir}NEW_DOWN_header_VCF.txt
cat ${current_dir}NEW_UP_header_VCF.txt ${current_dir}NEW_DOWN_header_VCF.txt > ${current_dir}NEW_header_VCF.txt


# Replace header
create_dir='/staging/reserve/aging/chia2831/FabryDisease/Fabry_Data_93/Merge_Fabry_total_93/Replaced_header_vcf/'
[ ! -d "$create_dir" ] && mkdir -p "$create_dir"
output_path=${create_dir}

/staging/reserve/aging/chia2831/bin/bcftools reheader -h ${current_dir}NEW_header_VCF.txt -o ${output_path}new_${disease}_${Amount_of_Samples}.merge.vcf ${current_dir}${disease}_${Amount_of_Samples}.merge.vcf 
