#!/bin/bash

module load biology/bcftools/1.13

ChrN='chr10'
disease='Genome'
Amount_of_Samples='2000'

filename="${ChrN}_2000_genome.samplelist"
samplelist_dir='/staging2/reserve/flagship/chia2831/TEST_2000_genome_VCFgz/Genomics-Analysis/Bio-preprocessing/Merge_all_vcf/By_Chromosome/'

Input_FilePath='/staging2/reserve/flagship/chia2831/TEST_2000_genome_VCFgz/Merge_2000_genome_ByChr/merged_recode_vcf/chr10/'
Output_FilePath='/staging2/reserve/flagship/chia2831/TEST_2000_genome_VCFgz/Merge_2000_genome_ByChr/merged_recode_vcf/All_chr/'
[ ! -d "$Output_FilePath" ] && mkdir -p "$Output_FilePath"


ls ${Input_FilePath} > ${samplelist_dir}${filename}
sed "s|^|$Input_FilePath|g" -i ${samplelist_dir}${filename}

# Merge Each chromosome	VCF file
bcftools merge -0 -l ${filename} --threads 50 --force-samples --no-index -Ov -o ${Output_FilePath}${disease}_${Amount_of_Samples}_${ChrN}.merge.vcf
