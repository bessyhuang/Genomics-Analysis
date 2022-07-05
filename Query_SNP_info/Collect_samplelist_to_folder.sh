#!/bin/bash

filename='Aging_Male_list.txt'
Input_dir='/staging/reserve/aging/chia2831/AgingProject_HALST_WGS/HALST_WGS_1/output/hg38/VCF/'
Output_dir='/staging/reserve/aging/chia2831/FabryDisease/Aging_HALST_Male_cohort/'

while IFS='' read -r line || [[ -n "$line" ]]; do
	# 確認檔案是否在目錄下
        echo "==> $line"
        echo -e "`ls ${Input_dir} | grep ${line}.vcf.gz`"

	# Copy
	cp ${Input_dir}${line}.vcf.gz ${Output_dir}
done < $filename
