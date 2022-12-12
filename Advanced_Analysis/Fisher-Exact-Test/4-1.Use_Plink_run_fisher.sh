#!/bin/bash

Input_VCF_FilePath='/staging/reserve/aging/chia2831/FabryDisease/Merge_Fabry_Aging_total_186/HardyWeinberg_result/Extract_Specific_Gene_Position/'
Input_VCF_FileName='new_AgingHALST_186_GLA_IVS4_gene.merge.vcf'

Input_FAM_FilePath='/staging/reserve/aging/chia2831/FabryDisease/Merge_Fabry_Aging_total_186/HardyWeinberg_result/Extract_Specific_Gene_Position/fam_file/'
Input_FAM_prefix='new_FabryAging_186_GLA_IVS4_10K.merge'

disease='Fabry_Aging'
Amount_of_Samples='186'

Output_FilePath='/staging/reserve/aging/chia2831/FabryDisease/Merge_Fabry_Aging_total_186/Fisher_result/'
[ ! -d "$Output_FilePath" ] && mkdir -p "$Output_FilePath"
Output_Fisher_result_prefix="${disease}_${Amount_of_Samples}_HWE"



# ========== START: Hands-on: Prepare .fam & Modify .fam  (4-0.Make_fam_file.py Prepared) ========== #
#| 欄位                       | 備註                                                                             |
#| -------------------------- | -------------------------------------------------------------------------------- |
#| Family ID                  | ('FID')                                                                          |
#| Within-family ID           | ('IID'; cannot be '0')                                                           |
#| Within-family ID of father | ('0' if father isn't in dataset)                                                 |
#| Within-family ID of mother | ('0' if mother isn't in dataset)                                                 |
#| Sex code                   | ('1' = male, '2' = female, '0' = unknown)                                        |
#| Phenotype value            | ('1' = control, '2' = case, '-9'/'0'/non-numeric = missing data if case/control) |

# $ /staging/reserve/aging/chia2831/bin/plink --vcf ${Input_VCF_FilePath}${Input_VCF_FileName} --make-bed --out ${Input_FAM_FilePath}${Output_FAM_prefix}
# ========== END  : Hands-on: Prepare .fam & Modify .fam ========== #


/staging/reserve/aging/chia2831/bin/plink --bfile ${Input_FAM_FilePath}${Input_FAM_prefix} --fisher --out ${Output_FilePath}${Output_Fisher_result_prefix}
