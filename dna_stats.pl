#!/usr/bin/perl -w
use strict;

my $input_file = "Av11_pb_v2.fa";
my $output_file = "Av11_pb_v2.fa.freq.txt";

my $count = 0;

open (IN, $input_file) or die "Can't find a file called $input_file! $!\n";
open (OUT, ">$output_file") or die "Can't open $output_file! $!\n";

$/ = ">";

while (<IN>) {
my ($gene, $description, $seq) = ($_ =~ /(.+?)\s+(.+?)\n([aAtTgGcCnN\n]+)/);
next unless ($gene);
$seq =~ s/\n//g;
my $A = ($seq =~ tr/Aa/Aa/);
my $G = ($seq =~ tr/Gg/Gg/);
my $C = ($seq =~ tr/Cc/Cc/);
my $T = ($seq =~ tr/Tt/Tt/);
my $N = ($seq =~ tr/Nn/Nn/);
my $bp = length($seq);
my $gc = sprintf("%0.1f", 100 * (($G + $C)/$bp));
print OUT ">$gene $description\n\tA = $A, G = $G, C = $C, T = $T, N = $N, total bp = $bp, %GC = $gc\n";
$count++;
}

print "Finished $count genes from $input_file\n";
