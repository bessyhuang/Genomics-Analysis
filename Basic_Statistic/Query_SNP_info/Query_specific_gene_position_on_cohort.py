import os


vcf_path = '/staging2/reserve/flagship/chia2831/TEST_2000_genome_VCFgz/VCF/'

filename = 'filename.list'
filename_path = '/staging2/reserve/flagship/chia2831/TEST_2000_genome_VCFgz/Genomics-Analysis/Basic_Statistic/Query_SNP_info/'
Disease = 'Genome'
Amount_of_Samples = '3'


# 擷取特定 chromosome
GeneName = input('Please Enter "GeneName" (e.g. GLA_IVS4)\n > ')
chr_N = input('Please Enter "chromosome" (e.g. chrX)\n > ')
pos = input('Please Enter "position" (e.g. 101399747)\n > ')


Output_FilePath = '/staging2/reserve/flagship/chia2831/TEST_2000_genome_VCFgz/Query_Specific_Gene_Position/'
os.system('[ ! -d {} ] && mkdir -p {}'.format(Output_FilePath, Output_FilePath))

Output_query_result_txt = '{}_{}_{}_{}_gene.txt'.format(Disease, Amount_of_Samples, chr_N, GeneName)


# 擷取特定 chromosome position
f_out = open(Output_FilePath + Output_query_result_txt, 'w')
SampleID_list = [line.strip() for line in open(filename, 'r')]

#for s in SampleID_list:
#	os.system("gunzip {}{}.vcf.gz".format(vcf_path, s))

for s in SampleID_list:
	with open(vcf_path + s + '.vcf' , 'r') as f:
		line = f.readline()
		while line != '':
			if '#' in line:
				pass
			elif str(chr_N + '\t') in line:
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
