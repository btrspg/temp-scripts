use strict;

die "usage:perl $0 test" unless ($ARGV[0] eq 'test' and @ARGV==1);

my $dir = "/wes/chenyl/projects_results/rrbs_analysis_20180716/commercial/cuixiuliang-20180803145726/Nova115-BHML18664-18629A-RRBS-C--18R10256/METHDATA/Nova115-BHML18664-18629A-RRBS-C--18R10256.methylkitprefix.*.CpG.txt";

my @files = glob($dir);
#foreach my $file(@files){
#	print "$file\n";
#}

my $glob_sample = "Nova115-BHML18664-18629A-RRBS-C--18R10256";

my @cases=("Nova115-BHML18664-18629A-RRBS-C--18R10256","Nova115-BHML18664-18629A-RRBS-A--18R10255","Nova115-BHML18664-18629A-RRBS-A--18R10259");
my @controls=("Nova115-BHML18664-18629A-RRBS-C--18R10257","Nova115-BHML18664-18629A-RRBS-C--18R10258");

my @case_names=("C--18R10256","A--18R10255","A--18R10259");
my @control_names=("C--18R10257","C--18R10258");

foreach my $file(@files){
	my $chr = '';
	if($file=~/Nova115-BHML18664-18629A-RRBS-C--18R10256\.methylkitprefix\.(.+?)\.CpG.txt/){
		$chr = $1;
	}
	my @casefiles;
	my @controlfiles;	
	foreach my $case(@cases){
		my $tmp = $file;
		$tmp =~s/$glob_sample/$case/g;
		push(@casefiles,$tmp);	
	}
	foreach my $control(@controls){
		my $tmp = $file;
		$tmp =~s/$glob_sample/$control/g;
		push(@controlfiles,$tmp);
	}
	my $cmd = "/home/chenyuelong/conda/epi_r/bin/Rscript /home/chenyuelong/pipeline/rrbs-analysis-pipeline/R_src/DMR.r ".join(",",@case_names)." ".join(",",@control_names)." CASE:CONTROL ".join(",",@casefiles)." ".join(",",@controlfiles)." hg19 CpG $chr /wes/chenyl/projects_results/rrbs_analysis_20180716/commercial/cuixiuliang-20180803145726/METHYLDIFF";
	print "$cmd\n";
}
