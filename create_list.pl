use strict;
use File::Basename;

die "perl $0 <pattern> <outlist> <cnn>" unless @ARGV == 3;

my $pattern = shift;
my $out = shift;
my $cnn = shift;

open OUT,">$out" || die $!;
open OUT2,">$out-cnn" || die $!;
my @files = glob("$pattern");
foreach my $file(@files){
	my $name = (split /\./,basename($file))[0];
	print OUT "$name\t$file\t\tflat\n";
	print OUT2 "$name\t$file\t$cnn\tcnn\n";
}
close OUT;
close OUT2;
