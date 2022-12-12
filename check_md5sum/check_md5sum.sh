#!/bin/bash

filename=$1
current_dir=$2
target_file=$3
md5sum_file=$4

while IFS='' read -r line || [[ -n "$line" ]]; do
        echo "==> $line"
        echo -e "`ls ${target_file} | grep ${line}`"

	size="$(ls -l ${target_file}${line} | awk '{print $5}')"
        md5sum_hash="$(md5sum ${target_file}${line} | awk '{print $1}')"

        echo -e "$size  $md5sum_hash  $line" >> ${current_dir}${md5sum_file} 
done < $filename
