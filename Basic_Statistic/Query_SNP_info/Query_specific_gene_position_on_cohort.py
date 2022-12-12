import os

FilePath = '/staging/reserve/aging/chia2831/FabryDisease/Aging_HALST_Male_cohort/'
Cohort_Filename = 'Aging_Male_list.txt'
Amount_of_Samples = '148'


# 擷取特定 chromosome
GeneName = input('Please Enter "GeneName" (e.g. GLA_IVS4)\n > ')
chr_N = input('Please Enter "chromosome" (e.g. chrX)\n > ')
pos = input('Please Enter "position" (e.g. 101399747)\n > ')


Output_FilePath = '/staging/reserve/aging/chia2831/FabryDisease/Aging_HALST_Male_cohort/Query_Specific_Gene_Position/'
os.system('[ ! -d {} ] && mkdir -p {}'.format(Output_FilePath, Output_FilePath))


Output_query_result_txt = 'Aging_{}_{}_{}_gene.txt'.format(Amount_of_Samples, chr_N, GeneName)


# 擷取特定 chromosome position
f_out = open(Output_FilePath + Output_query_result_txt, 'w')
SampleID_list = [line.strip() for line in open(Cohort_Filename, 'r')]

#for s in SampleID_list:
#	os.system("gunzip {}{}.vcf.gz".format(FilePath, s))

for s in SampleID_list:
	with open(FilePath + s + '.vcf' , 'r') as f:
		line = f.readline()
		while line != '':
			if '#' in line:
				pass
			elif chr_N in line:
				line_list = line.split('\t')
				if pos == line_list[1]:
					f_out.write(s + '\t' + line)
					print(line_list[0], line_list[1])
				else:
					pass
			else:
				pass

			line = f.readline()
f_out.close()
