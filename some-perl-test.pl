use strict;

my @test;
my %hash;

print [1,45]."\n";

my @ar = [1,5];

print "@ar\n";

for(my $i=11;$i<15;$i++){
	push @{$hash{$i}},[11,22];
}

foreach my $key(keys %hash){
	for(my $i=0;$i<@{$hash{$key}};$i++){
		my $num = @{$hash{$key}};
		print "$key--".$hash{$key}->[$i][0]."--$num--\n";
	}
}
