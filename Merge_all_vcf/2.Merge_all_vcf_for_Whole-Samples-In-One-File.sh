#!/bin/bash

filename='merge_Fabry_93.list'
current_dir='/staging/reserve/aging/chia2831/FabryDisease/Fabry_Data_93/recode_vcf/'


## Check for dir, if not found create it using the mkdir ##
create_dir='/staging/reserve/aging/chia2831/FabryDisease/Fabry_Data_93/Merge_Fabry_total_93/'
[ ! -d "$create_dir" ] && mkdir -p "$create_dir"
output_path=${create_dir}

disease='FabryDisease'
Amount_of_Samples='93'


ls ${current_dir} > ${current_dir}${filename}
sed -e "s/$filename//" -i ${current_dir}${filename}
sed -e 's/^DPFWGS005/\/staging\/reserve\/aging\/chia2831\/FabryDisease\/Fabry_Data_93\/recode_vcf\/DPFWGS005/' -i ${current_dir}${filename}


# Merge all vcf
/staging/reserve/aging/chia2831/bin/bcftools merge -0 -l ${current_dir}${filename} --threads 50 --force-samples --no-index -Ov -o ${output_path}${disease}_${Amount_of_Samples}.merge.vcf
