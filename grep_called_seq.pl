use strict;
use warnings FATAL => 'all';
use File::Basename;

die "perl $0 <pattern> <sh>" unless @ARGV == 2;

my $pattern =shift;

my $sh = shift;
open OUT,">$sh" || die $!;
my @files = glob($pattern);
foreach my $file(@files){
    my $out = $file;
    $out =~ s/ModelSegments.called.seg/segment.txt/;
    my $prefix = $file;
    $prefix =~ s/.ModelSegments.called.seg//;
    my $cmd1 = "grep -v \'^\@\' $file | grep -v '^CONTIG' > $out";
    #print OUT "$cmd\n";
    my $dirname = dirname($file);
    my @samples = split /-/,basename(dirname($dirname));
    my $cmd2 = "/usr/bin/perl /home/chenyuelong/pipeline/tumor-analysis-pipeline/other_scripts/vcf2thetain.pl $dirname/*.final.vcf $prefix.purity";
    my $cmd3 = "/home/chenyuelong/venv/py_cosmos2_pipeline/bin/python /home/chenyuelong/pipeline/tumor-analysis-pipeline/other_scripts/createTHetAExomeInput.py -s $out  -t $dirname/../ALIGNMENT/$samples[0].final.bam   -n $dirname/../ALIGNMENT/$samples[1].final.bam  --FA /wes/chenyl/database/human_g1k_v37_modified.fasta  --EXON_FILE /wes/chenyl/database/agilent.bed  --DIR $dirname/ --OUTPUT_PREFIX $samples[0]-$samples[1].theta-input";
    my $cmd4 = "/home/chenyuelong/softwares/git_reps/THetA/bin/RunTHetA interval_count_file $dirname/$samples[0]-$samples[1].theta-input.input --TUMOR_FILE $prefix.purity.tumor.snp.txt --NORMAL_FILE $prefix.purity.normal.snp.txt --DIRECTORY $dirname/../ANALYSIS --OUTPUT_PREFIX $samples[0]-$samples[1].purity"
    print OUT "$cmd1\n$cmd2\n$cmd3\n$cmd4\n";
}
close OUT;
