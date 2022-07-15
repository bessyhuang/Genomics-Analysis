from collections import defaultdict
import os


MarkersSet_type = input("Please Enter number of `MarkersSet_type` that you want: \n\
e.g. \n\
(1) ALL_markers	\t\
(2) AFF_markers	\t\
(3) UNAFF_markers \t\
(4) AFF_markers (significant) & UNAFF_markers (no significant) \n\
(5) UNAFF_markers (significant) & AFF_markers (no significant) \n\
(6) Total markers (no significant) \n\
(7) No filter any Marker\n\n> ")

disease = 'Fabry_Aging'
Amount_of_Samples = '186'
P_value = '0.0001'

CaseControl_table = 'CaseControl_record_table_186.txt'

Input_VCF_FilePath='/staging/reserve/aging/chia2831/FabryDisease/Merge_Fabry_Aging_total_186/Replaced_header_vcf/'
Input_VCF_FileName = 'new_Fabry_Aging_186.merge.vcf'

Input_HWE_FilePath='/staging/reserve/aging/chia2831/FabryDisease/Merge_Fabry_Aging_total_186/Replaced_header_vcf/HardyWeinberg_result/Filter_SNP_Pvalue/'
Input_HWE_filtered_ALL_FileName = "{}_{}_HWE_Filter_p-value_{}_ALL.txt".format(disease, Amount_of_Samples, P_value)
Input_HWE_filtered_AFF_FileName = "{}_{}_HWE_Filter_p-value_{}_AFF.txt".format(disease, Amount_of_Samples, P_value)
Input_HWE_filtered_UNAFF_FileName = "{}_{}_HWE_Filter_p-value_{}_UNAFF.txt".format(disease, Amount_of_Samples, P_value)

Output_FilePath='/staging/reserve/aging/chia2831/FabryDisease/Merge_Fabry_Aging_total_186/Replaced_header_vcf/HardyWeinberg_result/Create_HWE_filtered_VCF/'
os.system("[ ! -d {} ] && mkdir -p {}".format(Output_FilePath, Output_FilePath))
Output_HWE_filtered_VCF_FileName = "{}_{}_HWE_Filtered_p-value_{}_Expt{}.vcf".format(disease, Amount_of_Samples, P_value, MarkersSet_type)
Output_HWE_filtered_bfile_prefix = "{}_{}_HWE_Filtered_{}_bfile_Expt{}".format(disease, Amount_of_Samples, P_value, MarkersSet_type)
Output_PCA_HWE_filtered_prefix = "{}_{}_HWE_Filtered_{}_PCA_Expt{}".format(disease, Amount_of_Samples, P_value, MarkersSet_type)

def HWE_filtered_variants_dict(CaseControl_type, content_list):
	significant_diff_markers_dict = defaultdict(list)
	row_list = list()
	if CaseControl_type == 'ALL_CaseControl':
		for index, line in enumerate(content_list):
			if index != 0:
				row_list = line.strip().split('\t')
				chrN = row_list[0]
				pos = row_list[1]
				significant_diff_markers_dict[chrN].append(pos)
			else:
				pass
		return significant_diff_markers_dict
	elif CaseControl_type == 'AFF_Case':
		for index, line in enumerate(content_list):
			if index != 0:
				row_list = line.strip().split('\t')
				chrN = row_list[0]
				pos = row_list[1]
				significant_diff_markers_dict[chrN].append(pos)
			else:
				pass
		return significant_diff_markers_dict
	elif CaseControl_type == 'UNAFF_Control':
		for index, line in enumerate(content_list):
			if index != 0:
				row_list = line.strip().split('\t')
				chrN = row_list[0]
				pos = row_list[1]
				significant_diff_markers_dict[chrN].append(pos)
			else:
				pass
		return significant_diff_markers_dict
	else:
		print('--------', row_list)

def Final_selected_markers_dict(MarkersSet_type, HWE_ALL_dict, HWE_AFF_dict, HWE_UNAFF_dict):
	selected_markers_dict = defaultdict(list)
	if MarkersSet_type == 'ALL_markers' or MarkersSet_type == '1':
		return HWE_ALL_dict
	elif MarkersSet_type == 'AFF_markers' or MarkersSet_type == '2':
		return HWE_AFF_dict
	elif MarkersSet_type == 'UNAFF_markers' or MarkersSet_type == '3':
		return HWE_UNAFF_dict
	elif MarkersSet_type == 'AFF_markers (significant) & UNAFF_markers (no significant)' or MarkersSet_type == '4':
		for chrN in HWE_AFF_dict:
			List1 = HWE_AFF_dict[chrN]
			List2 = HWE_UNAFF_dict[chrN]
			# 判斷：List2 內的 data 是否都有在 List1 內出現
			#check = all(item in List1 for item in List2)

			# List1 sig. - List2 sig. => AFF (sig.) and UNAFF (no sig.)
			new_List = list(set(List1) - set(List2))
			selected_markers_dict[chrN] = new_List
		return selected_markers_dict
	elif MarkersSet_type ==	'UNAFF_markers (significant) & AFF_markers (no significant)' or MarkersSet_type == '5':
		for chrN in HWE_UNAFF_dict:
			List1 = HWE_UNAFF_dict[chrN]
			List2 = HWE_AFF_dict[chrN]
			
			# List1	sig. - List2 sig. => UNAFF (sig.) and AFF (no sig.)
			new_List = list(set(List1) - set(List2))
			selected_markers_dict[chrN] = new_List
		return selected_markers_dict
	elif MarkersSet_type == 'Total markers (no significant)' or MarkersSet_type == '6':
		for chrN in HWE_UNAFF_dict:
			List1 = HWE_ALL_dict[chrN]
			List2 = HWE_AFF_dict[chrN]
			List3 = HWE_UNAFF_dict[chrN]

			# List1 sig. + List2 sig. + List2 sig. => ALL (sig.) or AFF (sig.) or UNAFF (sig.)
			new_List = list(set(List1) | set(List2) | set(List3))
			selected_markers_dict[chrN] = new_List
		return selected_markers_dict		
	elif MarkersSet_type == 'No filter any Marker' or MarkersSet_type == '7':
		return None

# Read selected markers file (HWE p-value < 0.0001)
with open(Input_HWE_FilePath + Input_HWE_filtered_ALL_FileName, 'r') as f_in:
	content_list = f_in.readlines()
	ALL_CaseControl_HWE_dict = HWE_filtered_variants_dict('ALL_CaseControl', content_list)		

with open(Input_HWE_FilePath + Input_HWE_filtered_AFF_FileName, 'r') as f_in:
	content_list = f_in.readlines()
	AFF_Case_HWE_dict = HWE_filtered_variants_dict('AFF_Case', content_list)

with open(Input_HWE_FilePath + Input_HWE_filtered_UNAFF_FileName, 'r') as f_in:
	content_list = f_in.readlines()
	UNAFF_Control_HWE_dict = HWE_filtered_variants_dict('UNAFF_Control', content_list)


# Create VCF file (selected markers)
f_out = open(Output_FilePath + Output_HWE_filtered_VCF_FileName, 'w')

Selected_Markers_dict = Final_selected_markers_dict(MarkersSet_type, ALL_CaseControl_HWE_dict, AFF_Case_HWE_dict, UNAFF_Control_HWE_dict)

with open(Input_VCF_FilePath + Input_VCF_FileName, 'r') as f:
	line = f.readline()
	while line != '':
		if line.startswith('#'):
			f_out.write(line)
		elif MarkersSet_type == 'Total markers (no significant)' or MarkersSet_type == '6':
			line_list = line.split('\t')
			VCF_chrN = line_list[0]
			VCF_pos = line_list[1]
			
			# Total markers - [ ALL (sig.) markers or Delete AFF (sig.) markers or Delete UNAFF (sig.) markers ]
			if VCF_pos in Selected_Markers_dict[VCF_chrN]:
				pass
			else:
				f_out.write(line)
		elif MarkersSet_type == 'No filter any Marker' or MarkersSet_type == '7':
			# Equal to `RAW VCF file` (no filter, input all VCF markers then do PCA)
			f_out.write(line)
		else:
			line_list = line.split('\t')
			VCF_chrN = line_list[0]
			VCF_pos = line_list[1]

			if VCF_pos in Selected_Markers_dict[VCF_chrN]:
				f_out.write(line)
			else:
				pass 
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

# Delete MidOutput
os.system("rm -r {}".format(Output_FilePath + 'Modify_SexCode_' + Output_HWE_filtered_bfile_prefix + '.fam'))
