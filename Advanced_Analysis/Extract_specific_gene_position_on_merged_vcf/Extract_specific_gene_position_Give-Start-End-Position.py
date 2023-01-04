import os

FilePath = '/staging2/reserve/flagship/chia2831/TEST_2000_genome_VCFgz/Merge_2000_genome_ByChr/merged_recode_vcf/All_chr/FinalResult_here/Replaced_header_vcf/'
Filename = 'new_Genome_2000.merge.vcf'
Disease = 'Genome'
Amount_of_Samples = '2000'


# 擷取特定 chromosome
GeneName = input('Please Enter "GeneName" (e.g. GLA_IVS4)\n > ')
chr_N = input('Please Enter "chromosome" (e.g. chrX)\n > ')
pos1 = input('Please Enter "position START" (e.g. 101399744)\n > ')
pos2 = input('Please Enter "position END" (e.g. 101399800)\n > ')

Output_FilePath = '/staging2/reserve/flagship/chia2831/TEST_2000_genome_VCFgz/Merge_2000_genome_ByChr/merged_recode_vcf/All_chr/FinalResult_here/Replaced_header_vcf/Extract_Specific_Gene_Position/'
os.system('[ ! -d {} ] && mkdir -p {}'.format(Output_FilePath, Output_FilePath))

Output_gene_pos_vcf = 'new_{}_{}_{}-{}_gene.merge.vcf'.format(Disease, GeneName, pos1, pos2)


# 2. 擷取特定 chromosome position
pos_start = int(pos1)
pos_end = int(pos2)
print("The range of chromosome positions to be extracted \t=> {} ~ {}".format(pos_start, pos_end))


# Read lines in `chrX_Fabry.vcf`
f_out = open(Output_FilePath + Output_gene_pos_vcf, 'w')
with open(FilePath + Filename, 'r') as f:
	line = f.readline()
	
	while line != '':
		if '#' in line:
			f_out.write(line)
		elif str(chr_N + '\t') in line:
			line_list = line.split('\t')
			print(line_list[0], line_list[1])
			if pos_start <= int(line_list[1]) <= pos_end:
				f_out.write(line)
			else:
				pass
		else:
			pass
			#print(line)
		line = f.readline()
f_out.close()
