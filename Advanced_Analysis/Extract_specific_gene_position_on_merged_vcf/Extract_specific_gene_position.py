import os

FilePath = '/staging2/reserve/flagship/chia2831/TEST_2000_genome_VCFgz/Merge_2000_genome_ByChr/merged_recode_vcf/All_chr/FinalResult_here/Replaced_header_vcf/'
Filename = 'new_Genome_2000.merge.vcf'
Disease = 'Genome'
Amount_of_Samples = '2000'


# 擷取特定 chromosome
GeneName = input('Please Enter "GeneName" (e.g. GLA_IVS4)\n > ')
chr_N = input('Please Enter "chromosome" (e.g. chrX)\n > ')
pos = input('Please Enter "position" (e.g. 101399747)\n > ')

Output_FilePath = '/staging2/reserve/flagship/chia2831/TEST_2000_genome_VCFgz/Merge_2000_genome_ByChr/merged_recode_vcf/All_chr/FinalResult_here/Replaced_header_vcf/chrX_10K_up_down/'
os.system('[ ! -d {} ] && mkdir -p {}'.format(Output_FilePath, Output_FilePath))

Output_merge_vcfgz = 'new_{}_{}.merge.vcf.gz'.format(Disease, Amount_of_Samples)
Output_chrN_vcf = '{}_{}.vcf'.format(chr_N, Disease)
Output_gene_pos_vcf = 'new_{}_{}_{}_gene.merge.vcf'.format(Disease, Amount_of_Samples, GeneName)



# 1. 製作 vcf.gz 和 vcf.gz.tbi
os.system("module load biology/Samtools/1.15.1")
os.system("bgzip -c {} > {}".format(FilePath + Filename, Output_FilePath + Output_merge_vcfgz))
os.system("tabix -p vcf {}".format(Output_FilePath + Output_merge_vcfgz))
print("製作 vcf.gz 和 vcf.gz.tbi ==> Finish!")

# 2. 擷取特定 chromosome position
pos_minus_10K = int(pos) - 10000
pos_plus_10K = int(pos) + 10000
print("The range of chromosome positions to be extracted \t=> {} ~ {}".format(pos_minus_10K, pos_plus_10K))


os.system("module load biology/bcftools/1.13")
os.system("bcftools view {} --regions {} -o {} -Ov".format(Output_FilePath + Output_merge_vcfgz, chr_N, Output_FilePath + Output_chrN_vcf))


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
