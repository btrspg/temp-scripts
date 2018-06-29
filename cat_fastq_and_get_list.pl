use strict;
use File::Basename;

print "pattern只包含read1，这样会在后续过程中判断是否用read2，如果有则也cat\n";

die "perl $0 '<pattern>' <outdir> <list>" unless @ARGV==3;




my $pattern = shift;
my $outdir = shift;
my $list = shift;

my @files = glob("$pattern");

my %name_hash;
foreach my $file(@files){
	my $name = (split /_/,basename($file))[0];
	$name_hash{$name}=dirname($file)
}

system("mkdir -p $outdir");

open SH,">$outdir/cat.sh" || die $!;
open LIST,">$list" || die $!;

foreach my $nam(keys %name_hash){
	my @read1s = glob("$name_hash{$nam}/$nam*_1.fq.gz");
	my @read2s = glob("$name_hash{$nam}/$nam*_2.fq.gz");
	my $con = "$nam";
	if (@read1s > 0){
		print SH "cat @read1s > $outdir/$nam.R1.fq.gz\n";
		$con = "$con\t$outdir/$nam.R1.fq.gz";
	}
	if (@read2s >0){
		print SH "cat @read2s > $outdir/$nam.R2.fq.gz\n";
		$con = "$con\t$outdir/$nam.R2.fq.gz";
	}
	$con = "$con\n";
	print LIST "$con";
}
close SH;
close LIST;
