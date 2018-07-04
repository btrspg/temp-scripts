use strict;
use File::Basename;

die "perl $0 <pattern> o<outdir> <python> <bed-gc>" unless @ARGV==4;

my $pattern =shift;
my $outdir = shift;
my $python = shift;
my $bed = shift;
system("mkdir -p $outdir");

my @files = glob("$pattern");

my $controls = join(" ",@files);
my $n=0;
foreach my $file(@files){
	my $name = (split /\./,basename($file))[0];
	my $cmd = "$python ~/pipeline/amplicon-cnv/amplicon-cnv.py --case $file --controls $controls --bed-gc $bed --output $outdir/$name.cnv.txt";
	$n++;
	print "$n\n";
	#print "$cmd\n";
	system($cmd);
}
