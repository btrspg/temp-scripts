use strict;
use File::Basename;

die "perl $0 <pattern> <outdir>" unless @ARGV == 2;

my $pattern = shift;
my $outdir = shift;



my $bgzip="/home/chenyuelong/bin/bgzip";
my $tabix="/home/chenyuelong/bin/tabix";
my $vcf_merge="/home/chenyuelong/softwares/vcftools/bin/vcf-merge";
my $vcftools = "/home/chenyuelong/softwares/vcftools/bin/vcftools";
my $r_plot="/wes/chenyl/projects/temp_scripts/ped_plot.R";
my $plink="/home/chenyuelong/bin/plink";

my @files = glob($pattern);
my @vcf_gzs;
foreach my $file(@files){
	my $name = basename($file);
	my $cmd1 = "$bgzip -c $file > $outdir/$name.gz";
	my $cmd2 = "$tabix $outdir/$name.gz";
	push(@vcf_gzs,"$outdir/$name.gz");
	print "$cmd1\n$cmd2\n";
}

my $cmd3 = "$vcf_merge @vcf_gzs | $bgzip -c > $outdir/merge.vcf.gz";
print "$cmd3\n";

my $cmd4 = "$vcftools --gzvcf $outdir/merge.vcf.gz --out $outdir/for_plink  --remove-filtered-all --plink-tped";
print "$cmd4\n";

my $cmd5="$plink --tfile $outdir/for_plink --cluster --matrix --out $outdir/plink_out_mibs";
print "$cmd5\n";

my $cmd6="$plink --tfile $outdir/for_plink --cluster --mds-plot 10 --out $outdir/plink_mds";
print "$cmd6\n";

my $cmd7 = "Rscript $r_plot $outdir/plink_mds.mds $outdir/plink_mds.mds.pdf";
print "$cmd7\n";
