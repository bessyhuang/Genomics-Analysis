#!/usr/bin/perl
#20211130
#Yung-Feng Lin

#$numArgs = $#ARGV + 1;
#ARGV[0]: *.conf

foreach $argnum (0 .. $#ARGV)
{
	my $name = $ARGV[$argnum];
}

#Loading configure file
open LIST, "< $ARGV[0]";
while(<LIST>)
{
	chomp;
	@array_list = split("=","$_");
	my $tag = $array_list[0];
	my $arg = $array_list[1];
	if($tag eq "project_name"){
		$project_name = $arg;
		}
	if($tag eq "fastq_path"){
		$fastq_path = $arg;
		}
	if($tag eq "gzip_check_path"){
		$gzip_check_path = $arg;
		}
	if($tag eq "output_path"){
		$output_path = $arg;
		}
}
close LIST;

#create check output folder
system("mkdir $output_path/$project_name.check");

#Check fastq.gz validity by gzip
chdir("$fastq_path");
@list = glob("*fastq.gz");
for my $i(0..$#list){
	system("gzip -v -t $fastq_path/$list[$i] &> $output_path/$project_name.check/$list[$i].out");
	}

#Extract gzip check results
chdir("$output_path");
open OUTPUT, "> $project_name.gzip_check";

chdir("$output_path/$project_name.check");
@list = glob("*.gz.out");
for my $i(0..$#list){
	$check = qx/tail -n 1 $list[$i]/;
	print OUTPUT "$list[$i]\t$check";
	}
close OUTPUT;