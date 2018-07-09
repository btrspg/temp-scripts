use strict;
use File::Basename;

die "perl $0 <pattern> <outdir> <python> <bed-gc> <controls> <bin>" unless @ARGV==6;

my $pattern =shift;
my $outdir = shift;
my $python = shift;
my $bed = shift;
my $cf = shift;
my $bin=shift;
system("mkdir -p $outdir");

my @files = glob("$pattern");

my @tmps;
my $dir = dirname($pattern);
open IN,$cf || die $!;
while(<IN>){
	s/[\r\n]+//;
	#print "$_\n";
	#my $test = "$dir/$_";
	#	print "test:$test\n";
	my @tfs = glob("$dir/$_");
	#	print "@tfs\n";
	push(@tmps,@tfs);
}
close IN;
my $controls = join(" ",@tmps);
#print "$controls\n";
#my $controls = join(" ",@files);
my $n=0;
foreach my $file(@files){
	my $name = (split /\./,basename($file))[0];
	my $cmd = "time $python ~/pipeline/amplicon-cnv/amplicon-cnv.py --case $file --controls $controls --bed-gc $bed --output $outdir/$name.cnv.txt --no-plot --bin $bin";
	$n++;
	print "$n\n";
	print "$cmd\n";
	#last;
	system($cmd);
}
