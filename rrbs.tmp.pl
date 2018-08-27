use strict;

my $glob= "/wes/chenyl/projects_results/rrbs_analysis_20180716/commercial/cuixiuliang-20180803145726/Nova115-BHML18664-18629A-RRBS*/METHDATA/*methylkitprefix.*.CpG.txt";

my @files = glob("$glob");
my $all_1=0;
my $all_2=0;
my $all_3=0;
my $all_4=0;
my $all_5=0;
my $sum_all=0;
my %hash;
print "contig,percentage,count_percent,sample\n";
foreach my $file(@files){
	open IN,$file || die $!;
	my $name='test';
	if($file =~/\/Nova115-BHML18664-18629A-RRBS-(.+?)\//){
		$name =$1;
	}
	my $f1=0;
	my $f2=0;
	my $f3=0;
	my $f4=0;
	my $f5=0;
	my $sum=0;
	my $contig='';
	while(<IN>){
		s/[\r\n]+//;
		my @cells = split /\t/;
		$contig = $cells[1];
		next if $cells[4] <5;
		if($cells[5]<20){
			$f1++;
			$sum++;
		}
		elsif($cells[5]<40){
			$f2++;
			$sum++;
		}
		elsif($cells[5]<60){
			$f3++;
			$sum++;
		}
		elsif($cells[5]<80){
			$f4++;
			$sum++;
		}
		else{
			$f5++;
			$sum++;
		}
	}
	close IN;
	$hash{$name}{'0-20'} += $f1;
	$hash{$name}{'20-40'} += $f2;
	$hash{$name}{'40-60'} += $f3;
	$hash{$name}{'60-80'} += $f4;
	$hash{$name}{'80-100'} += $f5;
	$hash{$name}{'sum'} += $sum;
	print "$contig,0-20,".($f1/$sum).",$name\n";
	print "$contig,20-40,".($f2/$sum).",$name\n";
	print "$contig,40-60,".($f3/$sum).",$name\n";
	print "$contig,60-80,".($f4/$sum).",$name\n";
	print "$contig,80-100,".($f5/$sum).",$name\n";
}

foreach my $key(keys %hash){
	foreach my $key2(keys %{$hash{$key}}){
	        next if $key2 eq 'sum';
		print "all,$key2,".($hash{$key}{$key2}/$hash{$key}{'sum'}).",$key\n";
	}
}
