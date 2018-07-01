use strict;
use File::Basename;

die "perl $0 <pattern> <samtools>" unless @ARGV == 2;

my $pattern = shift;
my $samtools = shift;

my @files = glob("$pattern");
foreach my $file(@files){
	print "$samtools index $file\n";
}
