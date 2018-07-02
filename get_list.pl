use strict;
use File::Basename;
die "perl $0 <dir>" unless @ARGV==1;


my $dir = shift;
my @gzs = glob("$dir/*1.fq.gz");

foreach my $gz(@gzs){
	my $name = (split /_/,basename($gz))[0];
	my $fq2 = $gz;
	$fq2 =~ s/_1\.fq\.gz/_2.fq.gz/;
	print "$name\t$gz\t$fq2\n";
}
