use strict;

die "perl $0 <knownCanonical> <kgXref> " unless @ARGV==2;

my $kc = shift;
my $kx = shift;


my %hash;
open IN,"less $kc|" || die $!;
while(<IN>){
	s/[\r\n]+//;
	my @cells = split /\t/;
	$hash{$cells[4]} = 1;
}
close IN;

open IN2,"less $kx|" || die $!;
while(<IN2>){
	s/[\r\n]+//;
	my @cells = split /\t/;
	if(exists $hash{$cells[0]}){
		shift @cells;
		print join("\t",@cells)."\n";
	}
}
close IN2;
