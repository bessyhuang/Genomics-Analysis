import os

Input_FilePath = '/staging/reserve/aging/chia2831/FabryDisease/Merge_Fabry_Aging_total_186/Fisher_result/'
Input_Fisher_FileName = 'Fabry_Aging_186_HWE.assoc.fisher'

disease = 'Fabry_Aging'
Amount_of_Samples = '186'
P_value = '0.05'

#MidOutput_FilePath = '/staging/reserve/aging/chia2831/FabryDisease/Merge_Fabry_Aging_total_186/Fisher_result/MiddleOutput_Filter_SNP_Pvalue/'
#os.system("[ ! -d {} ] && mkdir -p {}".format(MidOutput_FilePath, MidOutput_FilePath))
#MidOutput_HWE_filter_prefix="{}_{}_HWE_Filter_p-value_{}".format(disease, Amount_of_Samples, P_value)

Output_FilePath = '/staging/reserve/aging/chia2831/FabryDisease/Merge_Fabry_Aging_total_186/Fisher_result/Filter_SNP_Pvalue/'
os.system("[ ! -d {} ] && mkdir -p {}".format(Output_FilePath, Output_FilePath))
Output_Fisher_filter_file="{}_{}_Fisher_Filter_p-value_{}.txt".format(disease, Amount_of_Samples, P_value)


# Filter Variants ( p-value < 0.0001 )
# ========== 備註 ========== #
# | 目的                                 | 使用軟體工具       | 軟體工具版本       |
# | ------------------------------------ | ------------------ | ------------------ |
# | 篩選 p-value 小於 0.0001 的 SNP      | Linux Command      |                    |

# | 參數設定              | 參數設定的備註                                         |
# | --------------------- | ------------------------------------------------------ |
# | p-value < 0.0001      | HWE significant different variants (Need to be delete) |

os.system(r"""awk 'NR==1' OFS='\t' %s > %s""" % (Input_FilePath + Input_Fisher_FileName, Output_FilePath + Output_Fisher_filter_file))
os.system(r"""awk '$8<=%s {print $1,$2,$3,$4,$5,$6,$7,$8,$9}' OFS='\t' %s >> %s""" % (P_value, Input_FilePath + Input_Fisher_FileName, Output_FilePath + Output_Fisher_filter_file))


# Write header & Turn '\t' ' ' separator to '\t'
#f_out_ALL = open(Output_FilePath + Output_HWE_filter_prefix + '_ALL.txt', 'w')
#f_out_ALL.write('{}\t{}\t{}\t{}\t{}\t{}\t{}\t{}\t{}\t{}\t{}\t{}\t{}\n'.format('#CHROM', 'POS', 'REF', 'ALT', 'CHR', 'SNP', 'TEST', 'A1', 'A2', 'GENO', 'O(HET)', 'E(HET)', 'P'))

#with open(MidOutput_FilePath + MidOutput_HWE_filter_prefix + '_ALL.txt', 'r') as f:
#	line = f.readline()
#	while line != '':
#		line_list = line.split()
#		f_out_ALL.write('\t'.join(line_list) + '\n')
#		line = f.readline()
#f_out_ALL.close()

# Delete MidOutput folder
#os.system("rm -r {}".format(MidOutput_FilePath))
