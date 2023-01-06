#!/bin/bash

filename='takeda.samplelist'
filename_path='/staging2/reserve/flagship/chia2831/TEST_2000_genome_VCFgz/Genomics-Analysis/Basic_Statistic/Calculate_Variant_QC_result/'

Input_CNV_cns_dir='/staging2/reserve/flagship/chia2831/TEST_2000_genome_VCFgz/Parabricks_CNVkit_CNV/CNV_cns/'
Output_CNV_dir='/staging2/reserve/flagship/chia2831/TEST_2000_genome_VCFgz/Parabricks_CNVkit_CNV/CNV_cns/CNV_info/'
[ ! -d "$Output_CNV_dir" ] && mkdir -p "$Output_CNV_dir"

Input_SV_VCFgz_dir='/staging2/reserve/flagship/chia2831/TEST_2000_genome_VCFgz/SV/SV_VCFgz/'
Output_SV_dir='/staging2/reserve/flagship/chia2831/TEST_2000_genome_VCFgz/SV/SV_VCFgz/SV_info/'
[ ! -d "$Output_SV_dir" ] && mkdir -p "$Output_SV_dir"


while IFS='' read -r line || [[ -n "$line" ]]; do
        echo "==> $line"

	# VCFgz to VCF
	gunzip ${Input_SV_VCFgz_dir}${line}.candidateSV.vcf.gz


	# CNV: Parabricks use CNVkit
	awk -F '\t' 'NR>1 && $5>0.459 {print "DUP\t"$1,$2,$3,$4,$5,$6,$7,$8}'  OFS="\t" ${Input_CNV_cns_dir}${line}.cns > ${Output_CNV_dir}${line}_DUP_log2_over_0.459.cns
	awk -F '\t' 'NR>1 && $5<-0.678 {print "DEL\t"$1,$2,$3,$4,$5,$6,$7,$8}' OFS="\t" ${Input_CNV_cns_dir}${line}.cns > ${Output_CNV_dir}${line}_DEL_log2_under_-0.678.cns

	DUP_count=`cat ${Output_CNV_dir}${line}_DUP_log2_over_0.459.cns | wc -l` 
	echo -e "$line\t$DUP_count" >> ${Output_CNV_dir}Fabry_CNV_DUP.txt

	DEL_count=`cat ${Output_CNV_dir}${line}_DEL_log2_under_-0.678.cns | wc -l`
        echo -e "$line\t$DEL_count" >> ${Output_CNV_dir}Fabry_CNV_DEL.txt


	# SV: Parabricks use Manta (All CNV results were normalized by Taiwan population CNV reference. => For WGS – using 1921 WGS data)
	grep 'SVTYPE=INS' ${Input_SV_VCFgz_dir}${line}.candidateSV.vcf > ${Output_SV_dir}${line}_INS.txt
	grep 'SVTYPE=DEL' ${Input_SV_VCFgz_dir}${line}.candidateSV.vcf > ${Output_SV_dir}${line}_DEL.txt
	grep 'SVTYPE=BND' ${Input_SV_VCFgz_dir}${line}.candidateSV.vcf > ${Output_SV_dir}${line}_BND.txt
	grep 'SVTYPE=DUP' ${Input_SV_VCFgz_dir}${line}.candidateSV.vcf > ${Output_SV_dir}${line}_DUP.txt
	
	INS_count=`cat ${Output_SV_dir}${line}_INS.txt | wc -l`
        echo -e "$line\t$INS_count" >> ${Output_SV_dir}Fabry_SV_INS.txt

	DEL_count=`cat ${Output_SV_dir}${line}_DEL.txt | wc -l`
        echo -e "$line\t$DEL_count" >> ${Output_SV_dir}Fabry_SV_DEL.txt

	BND_count=`cat ${Output_SV_dir}${line}_BND.txt | wc -l`
        echo -e "$line\t$BND_count" >> ${Output_SV_dir}Fabry_SV_BND.txt

	DUP_count=`cat ${Output_SV_dir}${line}_DUP.txt | wc -l`
        echo -e "$line\t$DUP_count" >> ${Output_SV_dir}Fabry_SV_DUP.txt


	# CNV: Dragen use ???
	#cat ${Input_CNV_VCFgz_dir}${line}.cnv.vcf | grep '<DUP>' | wc -l >> ${Output_CNV_dir}CNV_DUP.txt
	#cat ${Input_CNV_VCFgz_dir}${line}.cnv.vcf | grep '<DEL>' | wc -l >> ${Output_CNV_dir}CNV_DEL.txt

	# SV: Dragen use Manta
	#cat ${Input_SV_VCFgz_dir}${line}.cnv.vcf | grep '<INS>' | wc -l >> ${Output_SV_dir}SV_INS.txt  	
	#cat ${Input_SV_VCFgz_dir}${line}.cnv.vcf | grep '<DEL>' | wc -l >> ${Output_SV_dir}SV_DEL.txt
	#cat ${Input_SV_VCFgz_dir}${line}.cnv.vcf | grep '<BND>' | wc -l >> ${Output_SV_dir}SV_BND.txt
done < ${filename_path}${filename}
