use strict;

die "perl $0 <refflat> <outbed>" unless @ARGV==2;
my $flat = shift;
my $bed = shift;

open IN,$flat || die $!;
open OUT,">$bed" || die $!;
while(<IN>){
	s/[\r\n]+//;
	my @cells = split /\t/;
	my @starts = split /,/,$cells[9];
	my @ends = split /,/,$cells[10];
	for(my $i=1;$i<=@starts;$i++){
		print OUT "$cells[2]\t".($starts[$i-1]-10)."\t".($ends[$i-1]+10)."\t$cells[0]\n";
	}
}
close IN;
close OUT;
