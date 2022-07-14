from collections import defaultdict
import os

disease = 'Fabry_Aging'
Amount_of_Samples = '186'
P_value = '0.0001'

#MidOutput_FilePath='/staging/reserve/aging/chia2831/FabryDisease/Merge_Fabry_Aging_total_186/Replaced_header_vcf/HardyWeinberg_result/MiddleOutput_Filtered/'
#os.system("[ ! -d {} ] && mkdir -p {}".format(MidOutput_FilePath, MidOutput_FilePath))
#MidOutput_HWE_filter_prefix="{}_{}_HWE_Filter_p-value_{}".format(disease, Amount_of_Samples, P_value)

CaseControl_table = 'CaseControl_record_table_186.txt'

Input_VCF_FilePath='/staging/reserve/aging/chia2831/FabryDisease/Merge_Fabry_Aging_total_186/Replaced_header_vcf/'
Input_VCF_FileName = 'new_Fabry_Aging_186.merge.vcf'

Input_HWE_FilePath='/staging/reserve/aging/chia2831/FabryDisease/Merge_Fabry_Aging_total_186/Replaced_header_vcf/HardyWeinberg_result/Filter_SNP_Pvalue/'
Input_HWE_filtered_ALL_FileName = "{}_{}_HWE_Filter_p-value_{}_ALL.txt".format(disease, Amount_of_Samples, P_value)
Input_HWE_filtered_AFF_FileName = "{}_{}_HWE_Filter_p-value_{}_AFF.txt".format(disease, Amount_of_Samples, P_value)
Input_HWE_filtered_UNAFF_FileName = "{}_{}_HWE_Filter_p-value_{}_UNAFF.txt".format(disease, Amount_of_Samples, P_value)

Output_FilePath='/staging/reserve/aging/chia2831/FabryDisease/Merge_Fabry_Aging_total_186/Replaced_header_vcf/HardyWeinberg_result/Create_HWE_filtered_VCF/'
os.system("[ ! -d {} ] && mkdir -p {}".format(Output_FilePath, Output_FilePath))
Output_HWE_filtered_VCF_FileName = "{}_{}_HWE_Filtered_p-value_{}.vcf".format(disease, Amount_of_Samples, P_value)
Output_HWE_filtered_bfile_prefix = "{}_{}_HWE_Filtered_{}_bfile".format(disease, Amount_of_Samples, P_value)
Output_PCA_HWE_filtered_prefix = "{}_{}_HWE_Filtered_{}_PCA".format(disease, Amount_of_Samples, P_value)

def HWE_filtered_variants_dict(CaseControl_type, line_list):
	significant_diff_markers_dict = defaultdict(list)
	row_list = list()
	if CaseControl_type == 'ALL_CaseControl':
		for index, line in enumerate(line_list):
			if index != 0:
				row_list = line.strip().split('\t')
				chrN = row_list[0]
				pos = row_list[1]
				significant_diff_markers_dict[chrN].append(pos)
			else:
				pass
	elif CaseControl_type == 'AFF_Case':
		for index, line in enumerate(line_list):
			if index != 0:
				row_line = line.strip().split('\t')
				chrN = row_list[0]
				pos = row_list[1]
				significant_diff_markers_dict[chrN].append(pos)
			else:
				pass
	elif CaseControl_type == 'UNAFF_Control':
		for index, line in enumerate(line_list):
			if index != 0:
				row_line = line.strip().split('\t')
				chrN = row_list[0]
				pos = row_list[1]
				significant_diff_markers_dict[chrN].append(pos)
			else:
				pass
	else:
		pass
	return significant_diff_markers_dict


# Read selected markers file (HWE p-value < 0.0001)
with open(Input_HWE_FilePath + Input_HWE_filtered_ALL_FileName, 'r') as f_in:
	line_list = f_in.readlines()
	ALL_CaseControl_HWE_dict = HWE_filtered_variants_dict('ALL_CaseControl', line_list)		

"""
with open(Input_HWE_FilePath + Input_HWE_filtered_AFF_FileName, 'r') as f_in:
        line_list = f_in.readlines()
        AFF_Case_HWE_dict = HWE_filtered_variants_dict('AFF_Case', line_list)

with open(Input_HWE_FilePath + Input_HWE_filtered_UNAFF_FileName, 'r') as f_in:
        line_list = f_in.readlines()
        UNAFF_Control_HWE_dict = HWE_filtered_variants_dict('UNAFF_Control', line_list)
"""

# Create VCF file (selected markers)
f_out = open(Output_FilePath + Output_HWE_filtered_VCF_FileName, 'w')

with open(Input_VCF_FilePath + Input_VCF_FileName, 'r') as f:
	line = f.readline()
	while line != '':
		if line.startswith('#'):
			f_out.write(line)
		else:
			try:
				line_list = line.split('\t')
				VCF_chrN = line_list[0]
				VCF_pos = line_list[1]

				if VCF_pos in ALL_CaseControl_HWE_dict[VCF_chrN]:
					f_out.write(line)
				else:
					pass 
			except:
				print('Can not split =>', line)
		line = f.readline()

f_out.close()


# Create bfile for PLINK tool as input
os.system("/staging/reserve/aging/chia2831/bin/plink --vcf {} --make-bed --out {}".format(Output_FilePath + Output_HWE_filtered_VCF_FileName, Output_FilePath + Output_HWE_filtered_bfile_prefix))

#----- START:	Modify `.fam` -----#
## $5 (Sex code)		=>	'1' = male
os.system("awk -F ' ' '$5=1' {}{}.fam > {}Modify_SexCode_{}.fam".format(Output_FilePath, Output_HWE_filtered_bfile_prefix, Output_FilePath, Output_HWE_filtered_bfile_prefix))

## $6 (Phenotype value)		=>      '1' = control	;	'2' = case	;	'-9'/'0'/non-numeric = missing data if case/control)
CaseControl_dict = {}
with open(CaseControl_table) as f_in:
	for line in f_in:
		SampleID, Case_or_Control = line.strip().split('\t')
		CaseControl_dict[SampleID] = Case_or_Control

f_out = open(Output_FilePath + Output_HWE_filtered_bfile_prefix + '.fam', 'w')
with open(Output_FilePath + 'Modify_SexCode_' + Output_HWE_filtered_bfile_prefix + '.fam', 'r') as f:
	Modify_SexCode_fam_file = f.readlines()
	
for row in Modify_SexCode_fam_file:
	FamilyID, Within_familyID, father, mother, Sex, Phenotype = row.split(' ')

	Phenotype = CaseControl_dict[FamilyID]
	if Phenotype == 'Case':
		Phenotype = '2'
	elif Phenotype == 'Control':
		Phenotype = '1'
	else:
		Phenotype = '-9'

	f_out.write("{} {} {} {} {} {}\n".format(FamilyID, Within_familyID, father, mother, Sex, Phenotype))
f_out.close()
#----- END:	Modify `.fam` -----#

os.system("/staging/reserve/aging/chia2831/bin/plink --bfile {} --pca --out {}".format(Output_FilePath + Output_HWE_filtered_bfile_prefix, Output_FilePath + Output_PCA_HWE_filtered_prefix))

# Delete MidOutput folder
#os.system("rm -r {}".format(MidOutput_FilePath))
