#!/bin/bash

Case_list='Case_Fabry_93.txt'
Control_list='Control_Aging_93.txt'
Case_Control_list='merge_case_control.txt'

Case_FilePath='/staging/reserve/aging/chia2831/FabryDisease/Fabry_Data_93/recode_vcf/'
Control_FilePath='/staging/reserve/aging/chia2831/FabryDisease/Aging_HALST_Male_cohort/recode_vcf/'

disease='Fabry_Aging'
Amount_of_Samples='186'


## Check for dir, if not found create it using the mkdir ##
create_dir="/staging/reserve/aging/chia2831/FabryDisease/Merge_Fabry_Aging_total_186/"
[ ! -d "$create_dir" ] && mkdir -p "$create_dir"
Output_FilePath=${create_dir}


cat ${Case_list} ${Control_list} > ${Case_Control_list}

sed -e 's/$/_DP10_MAF21.vcf.recode.vcf/' -i ${Case_Control_list}

# Modify: 需要被取代的路徑
sed -e 's/^/\/staging\/reserve\/aging\/chia2831\/FabryDisease\/Merge_Fabry_Aging_total_186\//' -i ${Case_Control_list}


# Copy .recode.vcf to Output_FilePath
while IFS='' read -r line || [[ -n "$line" ]]; do
	cp ${Case_FilePath}/${line}_DP10_MAF21.vcf.recode.vcf ${Output_FilePath}
done < ${Case_list}

while IFS='' read -r line || [[ -n "$line" ]]; do
	cp ${Control_FilePath}/${line}_DP10_MAF21.vcf.recode.vcf ${Output_FilePath}
done < ${Control_list}


# Merge all vcf
/staging/reserve/aging/chia2831/bin/bcftools merge -0 -l ${Case_Control_list} --threads 50 --force-samples --no-index -Ov -o ${Output_FilePath}${disease}_${Amount_of_Samples}_Case_and_Control.merge.vcf
