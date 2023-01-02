#!/bin/bash

filename='2000_genome.samplelist'
samplelist_dir='/staging2/reserve/flagship/chia2831/TEST_2000_genome_VCFgz/Genomics-Analysis/Bio-preprocessing/Merge_all_vcf/By_Sample/'

recode_vcf_filename='2000_genome_recode_vcf.samplelist'			# Auto Generate
recode_vcf_samplelist_dir='/staging2/reserve/flagship/chia2831/TEST_2000_genome_VCFgz/Genomics-Analysis/Bio-preprocessing/Merge_all_vcf/By_Sample/'
recode_vcf_dir='/staging2/reserve/flagship/chia2831/TEST_2000_genome_VCFgz/recode_vcf/'


disease='Genome'
Amount_of_Samples='2000'


## Check for dir, if not found create it using the mkdir ##
create_dir='/staging2/reserve/flagship/chia2831/TEST_2000_genome_VCFgz/Merge_2000_genome/'
[ ! -d "$create_dir" ] && mkdir -p "$create_dir"
output_path=${create_dir}


while IFS='' read -r line || [[ -n "$line" ]]; do
	# Check file exist or not
        echo "==> $line"
        echo -e "`ls ${recode_vcf_dir} | grep ${line}`"

	rm ${recode_vcf_dir}${line}_DP10_MAF21.vcf.log
done < ${samplelist_dir}${filename}


ls ${recode_vcf_dir} > ${samplelist_dir}${recode_vcf_filename}
sed "s|^|$recode_vcf_dir|g" -i ${samplelist_dir}${recode_vcf_filename}

# Merge all vcf
/staging/reserve/aging/chia2831/bin/bcftools merge -0 -l ${recode_vcf_samplelist_dir}${recode_vcf_filename} --threads 50 --force-samples --no-index -Ov -o ${output_path}${disease}_${Amount_of_Samples}.merge.vcf
