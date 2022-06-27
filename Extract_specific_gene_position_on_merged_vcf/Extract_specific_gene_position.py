import os

FilePath = '/staging/reserve/aging/chia2831/FabryDisease/Fabry_Data_93/Merge_Fabry_total_93/Replaced_header_vcf/'
Filename = 'new_FabryDisease_93.merge.vcf'
Amount_of_Samples = '93'



# 擷取特定 chromosome
GeneName = input('Please Enter "GeneName" (e.g. GLA_IVS4)\n > ')
chr_N = input('Please Enter "chromosome" (e.g. chrX)\n > ')
pos = input('Please Enter "position" (e.g. 101399747)\n > ')


Output_FilePath = '/staging/reserve/aging/chia2831/FabryDisease/Fabry_Data_93/Extract_Specific_Gene_Position/'
os.system('[ ! -d {} ] && mkdir -p {}'.format(Output_FilePath, Output_FilePath))

Output_merge_vcfgz = 'new_FabryDisease_{}.merge.vcf.gz'.format(Amount_of_Samples)
Output_chrN_vcf = '{}_Fabry.vcf'.format(chr_N)
Output_gene_pos_vcf = 'new_FabryDisease_{}_{}_gene.merge.vcf'.format(Amount_of_Samples, GeneName)


# 補充：Extract header
# Method 1
#cat new_FabryDisease_70.merge.vcf | grep '^#' > test_header.txt
# Method 2 `NEW_header_VCF.txt`


# 1. 製作 vcf.gz 和 vcf.gz.tbi
os.system("/staging/reserve/aging/chia2831/bin/bgzip -c {} > {}".format(FilePath + Filename, Output_FilePath + Output_merge_vcfgz))
os.system("/staging/reserve/aging/chia2831/bin/tabix -p vcf {}".format(Output_FilePath + Output_merge_vcfgz))
print("製作 vcf.gz 和 vcf.gz.tbi ==> Finish!")


# 2. 擷取特定 chromosome position
pos_minus_10K = int(pos) - 10000
pos_plus_10K = int(pos) + 10000
print("The range of chromosome positions to be extracted \t=> {} ~ {}".format(pos_minus_10K, pos_plus_10K))


os.system("/staging/reserve/aging/chia2831/bin/bcftools view {} --regions {} -o {} -Ov".format(Output_FilePath + Output_merge_vcfgz, chr_N, Output_FilePath + Output_chrN_vcf))


# Read lines in `chrX_Fabry.vcf`
f_out = open(Output_FilePath + Output_gene_pos_vcf, 'w')
with open(Output_FilePath + Output_chrN_vcf, 'r') as f:
	line = f.readline()
	
	while line != '':
		if '#' in line:
			f_out.write(line)
		elif chr_N in line:
			line_list = line.split('\t')
			print(line_list[0], line_list[1])
			if pos_minus_10K <= int(line_list[1]) <= pos_plus_10K:
				f_out.write(line)
			else:
				pass
		else:
			print(line)
		line = f.readline()
f_out.close()
