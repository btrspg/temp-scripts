use strict;

die "perl $0 <bed>" unless @ARGV == 1;

my $bed = shift;

open IN,$bed || die $!;
my $total=0;
while(<IN>){
	s/[\r\n]+//;
	my @cells = split /\t/;
	$total += $cells[2]-$cells[1];
}
close IN;

if($total > 1000000000){
	print "".($total/1000000000)."GB\n";
}
elsif($total > 1000000){
	print "".($total/1000000)."MB\n";
}
else{
	print "".($total/1000)."KB\n";
}
