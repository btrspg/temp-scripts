use strict;
use File::Basename;

die "perl $0 <pattern> <region>" unless @ARGV==2;
my $pattern =shift;
my $region = shift;


my %hash;
open RG,$region || die $!;
while(<RG>){
	s/[\r\n]+//;
	my @cells = split /\t/;
	$hash{$_}='';
}
close RG;

my @files = glob($pattern);
foreach my $file(@files){
	open IN,$file || die $!;
	while(<IN>){
		s/[\r\n]+//;
		my @cells = split /\t/;
		if(exists $hash{$cells[0]}){
			$hash{$cells[0]} .="\t$cells[2]";
		}
	}
	close IN;
}

foreach my $key(keys %hash){
	print "$key$hash{$key}\n";
}
