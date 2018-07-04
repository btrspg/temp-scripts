use strict;
use File::Basename;

die "perl $0 <pattern> <outdir> " unless @ARGV==2;

my $pattern = shift;
my $outdir = shift;


my @files = glob("$pattern");
foreach my $file(@files){
	my $name = (split /\./,basename($file))[0];
	if($file =~ /\.fq$/){
		my $cmd = "make -f /wes/chenyl/projects/rd_template_pipeline/makefile CONFIG=/wes/chenyl/projects/rd_template_pipeline/config sample=$name outdir=$outdir fq1=$file  ALL -j2";
		print "-------------------\n";
		print "$cmd\n";
		system("$cmd");
	}
	elsif($file =~ /\.fq\.bz2/){

		my $cmd1 = "bunzip2 $file";
		$file =~ s/\.fq.bz2//;
		my $cmd2 = "make -f /wes/chenyl/projects/rd_template_pipeline/makefile CONFIG=/wes/chenyl/projects/rd_template_pipeline/config sample=$name outdir=$outdir fq1=$file  ALL -j2";
		print "--------------------\n";
		print "$cmd1\n";
		system($cmd1);
		print "$cmd2\n";
		system($cmd2);
	}	
	elsif($file =~ /\.fq\.tar\.bz2/){
		my $cmd1 = "tar -jxvf $file";
		$file =~ s/\.fq\.tar\.bz2//;
		my $cmd2 = "make -f /wes/chenyl/projects/rd_template_pipeline/makefile CONFIG=/wes/chenyl/projects/rd_template_pipeline/config sample=$name outdir=$outdir fq1=$file  ALL -j2";
		print "-------------------\n";
		print "$cmd1\n";
		system($cmd1);
		print "$cmd2\n";
		system($cmd2);
	}
}
