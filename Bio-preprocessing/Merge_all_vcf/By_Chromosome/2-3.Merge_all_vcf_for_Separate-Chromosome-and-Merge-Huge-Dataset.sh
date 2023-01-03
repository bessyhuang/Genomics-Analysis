#!/bin/bash

module load biology/bcftools/1.13

disease='Genome'
Amount_of_Samples='2000'

Input_FilePath='/staging2/reserve/flagship/chia2831/TEST_2000_genome_VCFgz/Merge_2000_genome_ByChr/merged_recode_vcf/All_chr/'
Output_FilePath='/staging2/reserve/flagship/chia2831/TEST_2000_genome_VCFgz/Merge_2000_genome_ByChr/merged_recode_vcf/All_chr/FinalResult_here/'
[ ! -d "$Output_FilePath" ] && mkdir -p "$Output_FilePath"


# Merge Each chromosome	VCF file
bcftools concat ${Input_FilePath}${disease}_${Amount_of_Samples}_chr{1..25}.merge.vcf -Oz -o  ${Output_FilePath}${disease}_${Amount_of_Samples}_Genome.merge.vcf.gz
