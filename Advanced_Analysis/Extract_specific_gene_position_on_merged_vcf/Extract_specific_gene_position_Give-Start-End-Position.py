import os

FilePath = '/Users/bessyhuang/Downloads/Fabry_stat/'
Filename = 'chrX_Fabry.vcf'
Amount_of_Samples = '93'


# 擷取特定 chromosome
GeneName = input('Please Enter "GeneName" (e.g. GLA_IVS4)\n > ')
chr_N = input('Please Enter "chromosome" (e.g. chrX)\n > ')
pos1 = input('Please Enter "position START" (e.g. 101399744)\n > ')
pos2 = input('Please Enter "position END" (e.g. 101399800)\n > ')

Output_FilePath = '/Users/bessyhuang/Downloads/Fabry_stat/Extract_Specific_Gene_Position/'
os.system('[ ! -d {} ] && mkdir -p {}'.format(Output_FilePath, Output_FilePath))

Output_gene_pos_vcf = 'new_FabryDisease_{}_{}-{}_gene.merge.vcf'.format(GeneName, pos1, pos2)


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
		elif chr_N in line:
			line_list = line.split('\t')
			print(line_list[0], line_list[1])
			if pos_start <= int(line_list[1]) <= pos_end:
				f_out.write(line)
			else:
				pass
		else:
			print(line)
		line = f.readline()
f_out.close()
