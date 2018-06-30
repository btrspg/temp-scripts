use strict;

die "perl $0 <bed> <outbed>" unless @ARGV==2;

my $bed = shift;
my $bedout = shift;

open IN,$bed || die $!;
open OUT,">$bedout" || die $!;

my $chr;
my $start;
my $end;
my $tag;
while(<IN>){
	s/[\r\n]+//;
	my @cells = split /\t/;
	if($chr eq ''){
		$chr = $cells[0];
		$start = $cells[1];
		$end = $cells[2];
		$tag = $cells[3];
	}
	elsif($chr eq $cells[0]){
		if($end >= $cells[1]){
			$end = $cells[2];
			$tag = "$tag,$cells[3]";
		}
		else{
			print OUT "$chr\t$start\t$end\t$tag\n";
			$start = $cells[1];
			$end = $cells[2];
			$tag = $cells[3];
		}
	}
	else{
		print OUT "$chr\t$start\t$end\t$tag\n";
                $start = $cells[1];
                $end = $cells[2];
                $tag = $cells[3];
		$chr = $cells[0]
	}
}
print OUT "$chr\t$start\t$end\t$tag\n";
close IN;
close OUT;
