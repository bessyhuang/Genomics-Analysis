#!/bin/bash
# Topic: Automatically reads TargetGenes.txt and runs stargazer.py for all samples.
# Fix: 
# 1. .txt & .log 檔案名稱改為 [SampleName]_[PGxGene]_stargazer_output
# 2. 去除 Stargazer/[SampleName]/[Stargazer output] 此目錄階層，改為 Stargazer/[Stargazer output]
# 3. 去除 "$Output_path"Stargazer/"$filename_line"_"$PGx_Gene_line".stargazer-genotype.project/ 此目錄


# Set Input directory (include TargetGenes.txt, SampleName_VCFgz.list)
Input_path=$(awk '/^Input_path/{print $3}' autoread_TargetGenes_Stargazer.conf)

# Set Output directory
Output_path=$(awk '/^Output_path/{print $3}' autoread_TargetGenes_Stargazer.conf)
[ ! -d "$Output_path" ] && mkdir -p "$Output_path"

# Get Sample list ([sample name].vcf.gz)
VCFgz_dir=$(awk '/^VCFgz_path/{print $3}' autoread_TargetGenes_Stargazer.conf)


ls ${VCFgz_dir} > ${Input_path}SampleName_VCFgz.list
sed -i 's/.vcf.gz//g' ${Input_path}SampleName_VCFgz.list

SampleName_VCFgz_list_path="$Input_path"SampleName_VCFgz.list


# Read TargetGenes.txt and do data preprocessing
cat "$Input_path"TargetGenes.txt | sed s/", "/"\n"/g > "$Input_path"TargetGenes_new.txt
TargetGenes_path="$Input_path"TargetGenes_new.txt


#--------------------------------------------------------------
filename='TargetGenes_new.txt'
output_stargazer_dir="${Output_path}Stargazer/"                      
[ ! -d "$output_stargazer_dir" ] && mkdir -p "$output_stargazer_dir"

echo -e "\n=============================" >> "$Output_path"autoread_TargetGenes_Stargazer.txt

while read -r filename_line; do
        # Reading each line
	#echo "### $filename_line"

	while IFS='' read -r PGx_Gene_line || [[ -n "$PGx_Gene_line" ]]; do
		#echo "==> $PGx_Gene_line"
		
		#python3 /staging/reserve/aging/chia2831/Stargazer_v1.0.8/stargazer.py genotype -o ./CACNA1S -d wgs -t CACNA1S --vcf /staging/reserve/aging/chia2831/test_HALST_1/HWGS10001.vcf.gz
        	python3 /staging/reserve/aging/chia2831/Stargazer_v1.0.8_fixed_hg38/stargazer.py genotype -o ${output_stargazer_dir}${filename_line}_${PGx_Gene_line} -d wgs -t $PGx_Gene_line --vcf "$VCFgz_dir$filename_line".vcf.gz

		cp -r ${output_stargazer_dir}${filename_line}_${PGx_Gene_line}.stargazer-genotype.project/finalized.vcf ${output_stargazer_dir}${filename_line}_${PGx_Gene_line}_finalized.vcf
		rm -r ${output_stargazer_dir}${filename_line}_${PGx_Gene_line}.stargazer-genotype.project/
	done < "$TargetGenes_path"

	# Check PGx Genes output exist
	tree ${output_stargazer_dir} > ${output_stargazer_dir}${filename_line}_PGx_Genes_output.list

	while IFS='' read -r PGx_Gene_line || [[ -n "$PGx_Gene_line" ]]; do
	        if grep -q $PGx_Gene_line ${output_stargazer_dir}${filename_line}_PGx_Genes_output.list ; then
        	        #:  => 等同 pass
         		echo -e "$filename_line\t$PGx_Gene_line\tOK" >> "$Output_path"autoread_TargetGenes_Stargazer.txt
        	else
           		echo -e "$filename_line\t$PGx_Gene_line\tFailed" >> "$Output_path"autoread_TargetGenes_Stargazer.txt
        	fi
	done < "$TargetGenes_path"
	
	echo -e "\n=============================" >> "$Output_path"autoread_TargetGenes_Stargazer.txt
done < "$Input_path"SampleName_VCFgz.list
