use strict;

my $glob= "/wes/chenyl/projects_results/rrbs_analysis_20180716/commercial/cuixiuliang-20180803145726/Nova115-BHML18664-18629A-RRBS*/METHDATA/*methylkitprefix.*.CpG.txt";
my $bed = "/home/chenyuelong/pipeline/rrbs-analysis-pipeline/database/pos.bed";

my $out = "/wes/chenyl/projects_results/rrbs_analysis_20180716/commercial/cuixiuliang-20180803145726/20180827/statOfPercentage_dif_region_gene.csv";
my %region;

open BED,$bed || die $!;
while(<BED>){
	#	print "$_\n";
	s/[\r\n]+//;
	my @cells = split /\s+/;
	$cells[0]=~s/chr//,$cells[0];
	#	print "$cells[0]\n";
	next if $cells[3] ne '3-UTR' and  $cells[3] ne '5-UTR' and  $cells[3] ne  'CDS' and  $cells[3] ne 'CGI'  and $cells[3] ne 'Promoter' and  $cells[3] ne 'Intron';
	for(my $i=$cells[1];$i<=$cells[2];$i++){
		$region{$cells[0]}{$i}{'region'} = $cells[3];
		if (@cells < 6){
			$region{$cells[0]}{$i}{'gene'} = $cells[4];
		}
		else{
			$region{$cells[0]}{$i}{'gene'}= $cells[6];
		}
	}
}
close BED;

open OUT,">$out" || die $!;
my @files = glob("$glob");
my $all_1=0;
my $all_2=0;
my $all_3=0;
my $all_4=0;
my $all_5=0;
my $sum_all=0;
my %hash;
print OUT "contig,region,gene,level,sample\n";
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
		#print "$contig,$cells[2]\n";
		if(!exists $region{$contig}{$cells[2]}){
			next;
			print OUT "$contig,unknown,unknown,$cells[5],$name\n";
		}
		else{
			print OUT "$contig,$region{$contig}{$cells[2]}{region},$region{$contig}{$cells[2]}{gene},$cells[5],$name\n";
		}
	}
	close IN;
}


