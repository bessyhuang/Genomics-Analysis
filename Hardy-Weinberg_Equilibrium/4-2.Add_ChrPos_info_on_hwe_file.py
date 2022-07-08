import os

Input_VCF_FilePath = '/staging/reserve/aging/chia2831/FabryDisease/Merge_Fabry_Aging_total_186/Replaced_header_vcf/'
Input_VCF_FileName = 'new_Fabry_Aging_186.merge.vcf'

Input_HWE_FilePath = '/staging/reserve/aging/chia2831/FabryDisease/Merge_Fabry_Aging_total_186/Replaced_header_vcf/HardyWeinberg_result/'
Input_HWE_FileName = 'Fabry_Aging_186_HWE.hwe'

disease='Fabry_Aging'
Amount_of_Samples='186'

Output_FilePath='/staging/reserve/aging/chia2831/FabryDisease/Merge_Fabry_Aging_total_186/Replaced_header_vcf/HardyWeinberg_result/Add_ChrPos_on_ALL_AFF_UNAFF/'
os.system("[ ! -d {} ] && mkdir -p {}".format(Output_FilePath, Output_FilePath))

Output_ChrPos_FileName = 'HWE_ChrPos_{}_{}.txt'.format(disease, Amount_of_Samples)
Output_ALL_FileName = 'ALL_' + Input_HWE_FileName
Output_AFF_FileName = 'AFF_' + Input_HWE_FileName
Output_UNAFF_FileName = 'UNAFF_' + Input_HWE_FileName


# Read lines from `new_Fabry_Aging_186.merge.vcf`
f_out_ALL = open(Output_FilePath + Output_ALL_FileName, 'w')
f_out_AFF = open(Output_FilePath + Output_AFF_FileName, 'w')
f_out_UNAFF = open(Output_FilePath + Output_UNAFF_FileName, 'w')
f_out_ChrPos = open(Output_FilePath + Output_ChrPos_FileName, 'w')


with open(Input_VCF_FilePath + Input_VCF_FileName, 'r') as f:
	line = f.readline()	
	while line != '':
		if ('#' in line) and ('#CHROM' in line):
			line_list = line.split('\t')
			f_out_ChrPos.write('{}\t{}\n'.format(line_list[0], line_list[1]))
		elif ('#' in line):
			pass
		else:
			line_list = line.split('\t')
			f_out_ChrPos.write('{}\t{}\n'.format(line_list[0], line_list[1]))
		line = f.readline()
f_out_ChrPos.close()


count = 0
with open(Input_HWE_FilePath + Input_HWE_FileName, 'r') as f:
	line = f.readline()

	while line != '':
		if ('ALL' in line) and (count % 3 == 1):
			f_out_ALL.write(line)
		elif ('AFF' in line) and (count % 3 == 2):
			f_out_AFF.write(line)
		elif ('UNAFF' in line) and (count % 3 == 0):
			f_out_UNAFF.write(line)
		elif (count == 0) and ('CHR' in line):
			# header => 'CHR', 'SNP', 'TEST', 'A1', 'A2', 'GENO', 'O(HET)', 'E(HET)', 'P'
			f_out_ALL.write(line)
			f_out_AFF.write(line)
			f_out_UNAFF.write(line)
		else:
			print(line)

		line = f.readline()
		count += 1

f_out_ALL.close()
f_out_AFF.close()
f_out_UNAFF.close()


os.system("paste {} {} > {}".format(Output_FilePath + Output_ChrPos_FileName, Output_FilePath + Output_ALL_FileName, Output_FilePath + 'ALL_HWE_with_ChrPos.txt'))
os.system("paste {} {} > {}".format(Output_FilePath + Output_ChrPos_FileName, Output_FilePath + Output_AFF_FileName, Output_FilePath + 'AFF_HWE_with_ChrPos.txt'))
os.system("paste {} {} > {}".format(Output_FilePath + Output_ChrPos_FileName, Output_FilePath + Output_UNAFF_FileName, Output_FilePath + 'UNAFF_HWE_with_ChrPos.txt'))
