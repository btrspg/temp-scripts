use strict;

my $usage = "perl $0 <bam1> <bam2> <samtools>\n";

die "$usage" unless @ARGV ==3;


my $bam1 = shift;
my $bam2 = shift;
my $samtools = shift;

open IN1,"$samtools view $bam1|" || die $!;
open IN2,"$samtools view $bam2|" || die $!;

my $total=0;
my $same = 0;
while(my $line1=<IN1> and my $line2=<IN2>){
	$total++;
	if ($line1 eq $line2){
		$same++;
	}
	else{
		print "------------------------\n";
		print "line1:$line1\n";
		print "line2:$line2\n";
#		print "+++++++++++++++++++++++++++++\n";
		my @cell1s = split /\t/,$line1;
		my @cell2s = split /\t/,$line2;
		for(my $i=0;$i<@cell1s;$i++){
			if($cell1s[$i] ne $cell2s[$i]){
				my @e1s = split //,$cell1s[$i];
				my @e2s = split //,$cell2s[$i];
				my $str1;
				my $str2;
				for(my $j=0;$j<@e1s;$j++){
					if($e1s[$j] eq $e2s[$j]){
						$str1="$str1$e1s[$j]";
						$str2="$str2$e2s[$j]";
					}
					else{
						$str1="$str1\[$e1s[$j]\]";
						$str2="$str2\[$e2s[$j]\]";
					}
				}
				print "1:$str1\n";
				print "2:$str2\n";
			}
		}
#		sleep(5);
	}

}
close IN1;
close IN2;

print "total read:$total\n";
print "same read:$same\n";
