import os

CaseControl_table = 'CaseControl_record_table_186.txt'

FilePath = '/staging/reserve/aging/chia2831/FabryDisease/Merge_Fabry_Aging_total_186/HardyWeinberg_result/Extract_Specific_Gene_Position/'
Filename = 'new_FabryDisease_186_GLA_IVS4_gene.merge.vcf'

Disease = 'FD_Aging'
Amount_of_Samples = '186'
GeneName = 'GLA_IVS4'
Output_File_prefix = '{}_{}_{}_gene.merge'.format(Disease, Amount_of_Samples, GeneName)


Output_FilePath = '/staging/reserve/aging/chia2831/FabryDisease/Merge_Fabry_Aging_total_186/HardyWeinberg_result/Extract_Specific_Gene_Position/Haploview_input_file/'
Output_Filename = '{}_{}_{}_gene_for_Haploview'.format(Disease, Amount_of_Samples, GeneName)
os.system('[ ! -d {} ] && mkdir -p {}'.format(Output_FilePath, Output_FilePath))


os.system("ln -s /opt/ohpc/Taiwania3/pkg/biology/PLINK/PLINK_v1.90/plink /staging/reserve/aging/chia2831/bin/plink")
os.system("/staging/reserve/aging/chia2831/bin/plink --vcf {} --make-bed --out {}".format(FilePath + Filename, Output_FilePath + Output_File_prefix))


#----- START:	Modify `.fam` -----#
## $5 (Sex code)		=>	'1' = male
os.system("awk -F ' ' '$5=1' {}{}.fam > {}Modify_SexCode_{}.fam".format(Output_FilePath, Output_File_prefix, Output_FilePath, Output_File_prefix))

## $6 (Phenotype value)		=>      '1' = control	;	'2' = case	;	'-9'/'0'/non-numeric = missing data if case/control)
CaseControl_dict = {}
with open(CaseControl_table) as f_in:
	for line in f_in:
		SampleID, Case_or_Control = line.strip().split('\t')
		CaseControl_dict[SampleID] = Case_or_Control

f_out = open(Output_FilePath + Output_File_prefix + '.fam', 'w')
with open(Output_FilePath + 'Modify_SexCode_' + Output_File_prefix + '.fam', 'r') as f:
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


# Generate .ped & .info file [for Haploview]
os.system("/staging/reserve/aging/chia2831/bin/plink --bfile {} --recode HV --snps-only just-acgt --out {}".format(Output_FilePath + Output_File_prefix, Output_FilePath + Output_Filename))
