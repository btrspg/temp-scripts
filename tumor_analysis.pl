use strict;
use warnings;

die "perl $0 <dir> <input_list> <sh>" unless @ARGV==3;


my %paras = get_paras();


my $dir = shift;
my $input_list =shift;
my $sh = shift;

open IL,$input_list || die $!;
open SH,">$sh" || die $!;

system("mkdir -p $dir/ANALYSIS");

my @call_cmds;
my @normal_cnvs;
while(<IL>){
    s/[\r\n]+//;
    my @cells = split /\t/;
    my $tumor = $cells[0];
    my $normal = $cells[3];
    my $cmd1 = "$paras{gatk4} CollectReadCounts \
    -I $dir/$tumor-$normal/ALIGNMENT/$tumor.final.bam \
    -L $paras{interval_list} \
    --interval-merging-rule OVERLAPPING_ONLY \
    -O $dir/ANALYSIS/$tumor.counts.hdf5";
    my $cmd2 = "$paras{gatk4} CollectReadCounts \
    -I $dir/$tumor-$normal/ALIGNMENT/$normal.final.bam \
    -L $paras{interval_list} \
    --interval-merging-rule OVERLAPPING_ONLY \
    -O $dir/ANALYSIS/$normal.counts.hdf5";

    push @normal_cnvs,"-I $dir/ANALYSIS/$normal.counts.hdf5 ";

    my $cmd3 ="$paras{gatk4} CollectAllelicCounts \
    -I $dir/$tumor-$normal/ALIGNMENT/$tumor.final.bam \
    -R $paras{reference} \
    -L $dir/$tumor-$normal/VARIANT/$tumor-$normal.final.vcf \
    -O $dir/ANALYSIS/$tumor.tumor.allelicCounts.tsv";
    my $cmd4 ="$paras{gatk4} CollectAllelicCounts \
    -I $dir/$tumor-$normal/ALIGNMENT/$normal.final.bam \
    -R $paras{reference} \
    -L $dir/$tumor-$normal/VARIANT/$tumor-$normal.final.vcf \
    -O $dir/ANALYSIS/$normal.normal.allelicCounts.tsv";
    my $cmd5 ="$paras{gatk4} DenoiseReadCounts \
    -I $dir/ANALYSIS/$tumor.counts.hdf5 \
    --count-panel-of-normals $dir/ANALYSIS/cnv.pon.hdf5 \
    --standardized-copy-ratios $dir/ANALYSIS/$tumor.standardizedCR.tsv \
    --denoised-copy-ratios $dir/ANALYSIS/$tumor.denoisedCR.tsv \
    --annotated-intervals $paras{annotated_intervals}
    $paras{gatk4} ModelSegments \
    --denoised-copy-ratios $dir/ANALYSIS/$tumor.denoisedCR.tsv \
    --allelic-counts $dir/ANALYSIS/$tumor.tumor.allelicCounts.tsv \
    --normal-allelic-counts $dir/ANALYSIS/$normal.normal.allelicCounts.tsv \
    --output-prefix $tumor.CNV \
    -O $dir/ANALYSIS/
    $paras{gatk4} CallCopyRatioSegments \
    -I $dir/ANALYSIS/$tumor.CNV.cr.seg \
    -O $dir/ANALYSIS/$tumor.CNV.ModelSegments.called.seg
    grep -v '^\@' $dir/ANALYSIS/$tumor.CNV.ModelSegments.called.seg | grep -v '^CONTIG' > $dir/ANALYSIS/$tumor.CNV.segment.txt";

    my $cmd6 = "$paras{gatk4} PlotDenoisedCopyRatios \
    --standardized-copy-ratios $dir/ANALYSIS/$tumor.standardizedCR.tsv \
    --denoised-copy-ratios  $dir/ANALYSIS/$tumor.denoisedCR.tsv \
    --sequence-dictionary $paras{plot_dict}  \
    --minimum-contig-length 46709983 \
    --output $dir/ANALYSIS/ --output-prefix $tumor.tumorpre.plot
    $paras{gatk4} PlotModeledSegments \
    --denoised-copy-ratios $dir/ANALYSIS/$tumor.denoisedCR.tsv \
    --allelic-counts $dir/ANALYSIS/$tumor.CNV.hets.tsv \
    --segments $dir/ANALYSIS/$tumor.CNV.modelFinal.seg \
    --sequence-dictionary $paras{plot_dict} \
    --output-prefix $tumor.CNV.plot \
    -O $dir/ANALYSIS";

    my $cmd7 = "$paras{perl} $paras{vcf2thetain} $dir/$tumor-$normal/VARIANT/$tumor-$normal.final.vcf \
    $dir/ANALYSIS/$tumor-$normal.purity
    $paras{python3} $paras{createthetaexomeinput} \
    -s $dir/ANALYSIS/$tumor.CNV.segment.txt \
    -t $dir/$tumor-$normal/ALIGNMENT/$tumor.final.bam  \
    -n $dir/$tumor-$normal/ALIGNMENT/$normal.final.bam \
    --FA $paras{reference} \
    --EXON_FILE $paras{target_bed} \
    --DIR $dir/ANALYSIS --OUTPUT_PREFIX $tumor.theta-input
    $paras{theta} $dir/ANALYSIS/$tumor.theta-input.input \
    --TUMOR_FILE $dir/ANALYSIS/$tumor-$normal.purity.tumor.snp.txt \
    --NORMAL_FILE $dir/ANALYSIS/$tumor-$normal.purity.normal.snp.txt \
    --DIRECTORY $dir/ANALYSIS \
    --OUTPUT_PREFIX $tumor-$normal.purity";

    my $cmd8 = "$paras{python3} $paras{generate_pyclone_input} \
    --cnv-type gatk \
    --cnv $dir/ANALYSIS/$tumor.CNV.ModelSegments.called.seg \
    --variant $dir/$tumor-$normal/ANNOTATION/$tumor-$normal.vep.annotation.txt \
    --threshold 20 \
    --prefix $dir/ANALYSIS/$tumor.subclone \
    --target pyclone
    $paras{pyclone} setup_analysis \
    --in_files $dir/ANALYSIS/$tumor.subclone.pyclone.tsv \
    --working_dir $dir/ANALYSIS/$tumor \
    --samples $tumor \
    --prior total_copy_number
    $paras{pyclone} run_analysis \
    --config_file $dir/ANALYSIS/$tumor/config.yaml
    $paras{pyclone} build_table \
    --config_file $dir/ANALYSIS/$tumor/config.yaml \
    --out_file $dir/ANALYSIS/$tumor.old-style \
    --table_type old_style
    $paras{python3} $paras{subclone2fish} -i $dir/ANALYSIS/$tumor.old-style -o $dir/ANALYSIS/$tumor.finalinput.txt
    $paras{rscript} $paras{fishplot} $dir/ANALYSIS/$tumor.finalinput.txt $dir/ANALYSIS/$tumor/";

    print SH $cmd2."\n";
    print SH $cmd1."\n";
    print SH $cmd3."\n";
    print SH $cmd4."\n";
    push @call_cmds,$cmd5;
    push @call_cmds,$cmd6;
    push @call_cmds,$cmd7;
    push @call_cmds,$cmd8;
}
my $normals = join(' ',@normal_cnvs);
print SH "$paras{gatk4} CreateReadCountPanelOfNormals \
$normals \
--annotated-intervals $paras{annotated_intervals} \
-O $dir/ANALYSIS/cnv.pon.hdf5";

foreach my $cmd(@call_cmds){
    print SH "$cmd\n";
}
close SH;



sub get_paras{
    my %hash;
    $hash{'gatk4'}='/wes/chenyl/softwares/gatk-4.0.4.0/gatk';
    $hash{'samtools'}='/home/chenyuelong/softwares/samtools/bin/samtools';
    $hash{'fastp'}='/wes/chenyl/softwares/bin/fastp';
    $hash{'python3'}='/home/chenyuelong/venv/py_cosmos2_pipeline/bin/python';
    $hash{'bamqc'}='/wes/chenyl/softwares/qualimap_v2.2.1/qualimap';
    $hash{'contest'}='/home/chenyuelong/softwares/java/jdk1.8.0_171/bin/java -XX:ParallelGCThreads=8 -jar /wes/chenyl/softwares/jarlibs/GenomeAnalysisTK.jar -T ContEst';
    $hash{'bwa'}='/wes/chenyl/softwares/bin/bwa';
    $hash{'vep'}='/home/chenyuelong/softwares/ensembl-vep/vep';
    $hash{'pyclone'}='/home/chenyuelong/venv/py_pyclone/bin/PyClone';
    $hash{'rscript'}='/home/chenyuelong/conda/epi_r/bin/Rscript';
    $hash{'python2'}='/home/chenyuelong/venv/py_pyclone/bin/python';
    $hash{'perl'}='/usr/bin/perl';
    $hash{'theta'}='/home/chenyuelong/softwares/git_reps/THetA/bin/RunTHetA';
    $hash{'interval_list'}='/wes/chenyl/database/interval_list_annotation/agilent.interval_list';
    $hash{'annotated_intervals'}='/wes/chenyl/database/interval_list_annotation/agilent.annotated_intervals.tsv';
    $hash{'reference'}='/wes/chenyl/database/human_g1k_v37_modified.fasta';
    return %hash;
}