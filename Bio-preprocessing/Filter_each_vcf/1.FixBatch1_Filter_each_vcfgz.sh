#!/bin/bash

filename='2000_genome.samplelist'
samplelist_dir='/staging2/reserve/flagship/chia2831/TEST_2000_genome_VCFgz/Genomics-Analysis/Bio-preprocessing/Filter_each_vcf/'
VCFgz_dir='/staging2/reserve/flagship/chia2831/TEST_2000_genome_VCFgz/VCFgz/'

## Check for dir, if not found create it using the mkdir ##
create_dir='/staging2/reserve/flagship/chia2831/TEST_2000_genome_VCFgz/recode_vcf/'
[ ! -d "$create_dir" ] && mkdir -p "$create_dir"
output_path=${create_dir}

while IFS='' read -r line || [[ -n "$line" ]]; do
	# Check file exist or not
        echo "==> $line"
        echo -e "`ls ${VCFgz_dir} | grep ${line}`"

	
	# Modify : --gzvcf
	/staging/reserve/aging/chia2831/bin/vcftools --gzvcf "${VCFgz_dir}${line}".vcf.gz --recode --recode-INFO-all \
		--out ${output_path}${line}_DP10_MAF21.vcf \
		--chr chr1 --chr chr2 --chr chr3 --chr chr4 --chr chr5 --chr chr6 --chr chr7 --chr chr8 --chr chr9 --chr chr10 --chr chr11 --chr chr12 --chr chr13 --chr chr14 --chr chr15 --chr chr16 --chr chr17 --chr chr18 --chr chr19 --chr chr20 --chr chr21 --chr chr22 --chr chrX --chr chrY --chr chrM \
		--min-meanDP 10 \
		--non-ref-af-any 0.21
done < ${samplelist_dir}${filename}
