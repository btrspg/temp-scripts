use strict;

die "perl $0 <depth.gz> <filter1,filter2,> <prefix>" unless @ARGV == 3;

my $depth = shift;
my $filter = shift;
my $outdir = shift;

my @fts = split /,/,$filter;

my %hash;
my %locs;

open IN,"less $depth| " || die $!;
while(<IN>){
	s/[\r\n]+//;
	my @cells = split /\t/;
	foreach my $ft(@fts){
		if($cells[2]<$ft){
			$hash{$ft}++;
			$locs{$ft}{$cells[0]}{$cells[1]}=1;
		}
	}
}
close IN;

foreach my $key(sort {$a<=>$b} keys %hash){
	open OUT,">$outdir\_$key.stats" || die $!;
	print "total: $hash{$key} site below $key\n";
	foreach my $v(sort {$a<=>$b} keys %{$locs{$key}}){
		my $last=0;
		my $start=0;
		foreach my $loca(sort {$a<=>$b} keys %{$locs{$key}{$v}}){
			if ($loca == $last+1){
				$last = $loca;
			}
			elsif($last==0){
				$start=$loca;
				$last = $loca;
			}
			else{
				print OUT "$v\t$start\t$last\n";
				$start = $loca;
				$last = $loca;
			}
		}
#		print OUT "$tmps[0]\t$tmps[1]\t".($tmps[1]+1)."\n";
	}
	close OUT
}
