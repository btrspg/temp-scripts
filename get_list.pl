use strict;
use File::Basename;
die "perl $0 <dir>" unless @ARGV==1;


my $dir = shift;
my @gzs = glob("$dir/*1.fq.gz");

my $tag = 'fq.gz';
if (@gzs ==0){
	@gzs=glob("$dir/*1.fastq.gz");
	$tag='fastq.gz';
}

foreach my $gz(reverse sort @gzs){
	my $name = (split /_/,basename($gz))[0];
	my $fq2 = $gz;
	$fq2 =~ s/1\.$tag/2\.$tag/;
	print "$name\t$gz\t$fq2\n";
}
