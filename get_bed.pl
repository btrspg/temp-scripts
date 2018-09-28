use strict;

my $genelist = '/wes/chenyl/database/omim.gene.list';

my %hash;
open IN,$genelist || die $!;
while(<IN>){
	s/[\r\n]+//;
	$hash{$_} = 0;
}
close IN;

my $genebed = '/wes/chenyl/database/all.gene.sort.bed';
open OUT,">/wes/chenyl/database/omim.gene.bed" || die $!;
open IN,$genebed || die $!;
while(<IN>){
	s/[\r\n]+//;
	my @cells = split /\s+/;
	if(exists $hash{$cells[3]}){
		$hash{$cells[3]}++;
		print OUT "$_\n";
	}
}
close IN;


foreach my $key(keys %hash){
	if($hash{$key}< 1){
		print "$key\n";
	}
}
