#!/bin/bash
# Topic: Automatically reads TargetGenes.txt and runs stargazer.py for all samples.
# Fix: 
# 1. .txt & .log 檔案名稱改為 [SampleName]_[PGxGene]_stargazer_output
# 2. 去除 Aldy/[SampleName]/[Aldy output] 此目錄階層，改為 Aldy/[Aldy output]


# Set Input directory (include TargetGenes.txt, SampleName_BAM.list)
Input_path=$(awk '/^Input_path/{print $3}' autoread_TargetGenes_Aldy.conf)

# Set Output directory
Output_path=$(awk '/^Output_path/{print $3}' autoread_TargetGenes_Aldy.conf)

# Get Sample list ([sample name].vcf.gz)
BAM_dir=$(awk '/^BAM_path/{print $3}' autoread_TargetGenes_Aldy.conf)


ls ${BAM_dir}*.bam > ${Input_path}SampleName_BAM.list
sed -i 's/\/staging\/reserve\/aging\/chia2831\/temp_Aldy\/BAM\///g' ${Input_path}SampleName_BAM.list			### 需要修改路徑
sed -i 's/.bam//g' ${Input_path}SampleName_BAM.list

SampleName_BAM_list_path=${Input_path}SampleName_BAM.list


# Read TargetGenes.txt and do data preprocessing
cat "$Input_path"TargetGenes.txt | sed s/", "/"\n"/g > "$Input_path"TargetGenes_new.txt
TargetGenes_path="$Input_path"TargetGenes_new.txt


#--------------------------------------------------------------
filename='TargetGenes_new.txt'
output_aldy_dir="${Output_path}Aldy/" 
[ ! -d "$output_aldy_dir" ] && mkdir -p "$output_aldy_dir"

echo -e "\n=============================" >> "$Output_path"autoread_TargetGenes_Aldy.txt

while read -r filename_line; do
        # Reading each line
	#echo "### $filename_line"


	while IFS='' read -r PGx_Gene_line || [[ -n "$PGx_Gene_line" ]]; do
		#echo "==> $PGx_Gene_line"
		
		#./aldy genotype -p illumina -g CYP1A2 AgingProject_HALST_WGS/HALST_WGS_1/output/hg38/BAM/HWGS10001.bam -o HWGS10001_CYP1A2.aldy
		aldy genotype -p illumina -g ${PGx_Gene_line} ${BAM_dir}${filename_line}.bam -o ${output_aldy_dir}${filename_line}_${PGx_Gene_line}.aldy
	done < "$TargetGenes_path"

	# Check PGx Genes output exist
	tree ${output_aldy_dir} > ${output_aldy_dir}${filename_line}_PGx_Genes_output.list

	while IFS='' read -r PGx_Gene_line || [[ -n "$PGx_Gene_line" ]]; do
	        if grep -q "$filename_line"_"$PGx_Gene_line".aldy ${output_aldy_dir}${filename_line}_PGx_Genes_output.list ; then
        	        #:  => 等同 pass
			# HWGS10001_CFTR.aldy
         		echo -e "$filename_line\t$PGx_Gene_line\tOK" >> "$Output_path"autoread_TargetGenes_Aldy.txt
        	else
           		echo -e "$filename_line\t$PGx_Gene_line\tFailed" >> "$Output_path"autoread_TargetGenes_Aldy.txt
        	fi
	done < "$TargetGenes_path"
	
	echo -e "\n=============================" >> "$Output_path"autoread_TargetGenes_Aldy.txt
done < "$Input_path"SampleName_BAM.list
