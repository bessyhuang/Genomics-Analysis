#!/bin/bash

ChrN='chr23'
disease='Fabry_Aging'
Amount_of_Samples='186'
Case_Control_list="${ChrN}_Case_Control_list.txt"

Input_FilePath='/staging/reserve/aging/chia2831/FabryDisease/Merge_Fabry_Aging_total_186/merged_recode_vcf/chrX/'
Output_FilePath='/staging/reserve/aging/chia2831/FabryDisease/Merge_Fabry_Aging_total_186/merged_recode_vcf/All_chr/'
[ ! -d "$Output_FilePath" ] && mkdir -p "$Output_FilePath"


ls ${Input_FilePath} > ${Case_Control_list}
sed -e 's/^/\/staging\/reserve\/aging\/chia2831\/FabryDisease\/Merge_Fabry_Aging_total_186\/merged_recode_vcf\/chrX\//' -i ${Case_Control_list}

# Merge Each chromosome	VCF file
/staging/reserve/aging/chia2831/bin/bcftools merge -0 -l ${Case_Control_list} --threads 50 --force-samples --no-index -Ov -o ${Output_FilePath}${disease}_${Amount_of_Samples}_${ChrN}.merge.vcf
