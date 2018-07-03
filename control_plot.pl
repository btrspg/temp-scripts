use strict;
use File::Basename;
my $python='/home/chenyuelong/venv/py_cosmos2_pipeline/bin/python';
my $plotpy='/home/chenyuelong/pipeline/FH_analysis_pipeline/src/plotbed.py';

die "perl $0 <pattern> <outdir>" unless @ARGV==3;

my $pattern = shift;
my $outdir = shift;
my $bed = shift;

system("mkdir -p $outdir");

my @depths = glob("$pattern");
foreach my $depth(@depths){
	my $name = (split /\./,basename($depth))[0];
	my $cmd = "$python $plotpy --depth $depth --depthout $outdir/$name.png --bed $bed";
	system("$cmd");
}
