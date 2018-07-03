use strict;
use File::Basename;

die "perl $0 <sample_pattern> <bams_dir> <output>" unless @ARGV==3;


my $sample_pattern = shift;
my $bam_dir = shift;
my $output = shift;


my %hash;
my @dirs  = glob("$sample_pattern");
foreach my $sample(@dirs){
	my $name = basename($sample);
	my $mean = 0;
	my $n = 1;
	my $sum =0;
	my $max=0;
	my @results = glob("$sample/$name.*.call.cn.cns");
	foreach my $result(@results){
		open IN,$result || die $!;
		<IN>;
		while(<IN>){
			s/[\r\n]+//;
			my @cells  = split /\t/;
			$sum+=abs($cells[4]);
			$max = abs($cells[4]) if $max <abs($cells[4]);
			$n++;		
		}
		close IN;
	}
	$mean = $sum/$n+$max;
	if(exists $hash{$mean}){
		$hash{$mean} = "$hash{$mean},$name";
	}
	else{
		$hash{$mean} = $name;
	}
}


open OUT,">".$output || die $!;

my @normal_dirs;
foreach my $key(sort {$a<=>$b} keys %hash){
	print "$key\t$hash{$key}\n";
	my @names = split /,/,$hash{$key};
	foreach my $name(@names){
		my @nds = glob("$bam_dir/$name/ALIGNMENT/$name.realn.recal.bam");
		push(@normal_dirs,@nds);
	}
	last if @normal_dirs>15;
}
print OUT join(' ',@normal_dirs);
close OUT;
