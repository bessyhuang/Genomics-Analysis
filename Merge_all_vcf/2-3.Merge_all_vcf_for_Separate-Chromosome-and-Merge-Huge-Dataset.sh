#!/bin/bash

disease='Fabry_Aging'
Amount_of_Samples='186'

Input_FilePath='/staging/reserve/aging/chia2831/FabryDisease/Merge_Fabry_Aging_total_186/merged_recode_vcf/All_chr/'
Output_FilePath='/staging/reserve/aging/chia2831/FabryDisease/Merge_Fabry_Aging_total_186/merged_recode_vcf/All_chr/Final_result/'
[ ! -d "$Output_FilePath" ] && mkdir -p "$Output_FilePath"


# Merge Each chromosome	VCF file
/staging/reserve/aging/chia2831/bin/bcftools concat ${Input_FilePath}${disease}_${Amount_of_Samples}_chr{1..25}.merge.vcf -Oz -o  ${Output_FilePath}${disease}_${Amount_of_Samples}_Genome.merge.vcf.gz
