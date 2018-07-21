use strict;

die "perl $0 <input> <output>" unless @ARGV==2;

my $file =shift;
my $out = shift;

open IN,"$file" || die $!;
open OUT,">$out" || die $!;

while(<IN>){
	s/[\r\n]+//;
	next if /^#/;
	my @cells = split /\t/;
	next if $cells[2] ne 'exon';
	print OUT "$cells[0]\t$cells[3]\t$cells[4]\n";
}
close IN;
close OUT;
