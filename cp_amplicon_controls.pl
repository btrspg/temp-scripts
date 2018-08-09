use strict;
use File::Basename;

die "perl $0 <dir> <controls> <bin>" unless @ARGV==2;

my $dir = shift;
my $cf = shift;
my @tmps;
open IN,$cf || die $!;
while(<IN>){
	s/[\r\n]+//;
	#print "$_\n";
	#my $test = "$dir/$_";
	#	print "test:$test\n";
	my @tfs = glob("$dir/$_");
	#	print "@tfs\n";
	push(@tmps,@tfs);
}
my $controls = join(" ",@tmps);

print "$controls\n";
