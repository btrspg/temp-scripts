use strict;

die "perl $0 <input> <output>" unless @ARGV==2;


my $file = shift;
my $out = shift;
open IN,$file || die $!;
open OUT,">$out" || die $!;

while(<IN>){
	s/[\r\n]+//;
	s/^chr//;
	print OUT "$_\n";
}

close IN;
close OUT;
