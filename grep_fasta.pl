#!/usr/bin/perl 

use Bio::Perl;
use Bio::SeqIO;
use IO::String;
use Bio::SearchIO;

#Use this perl script to grep seqs in a fasta file (filename) with their ID (@genes_name), it will output a fasta file (fa) with the selected seqs/contigs.
#you can input you genes' name in the array or read it from other files.

my @genes_name=qw(GeneID1 GeneID2)

my $filename='/users/Genome-proteins.fa';

my $gb = Bio::SeqIO->new(-file   => "<$filename",
                              -format => "fasta");
my $fa = Bio::SeqIO->new(-file   => ">GenID_prot.fa",
                              -format => "fasta",
                              -flush  => 0); # go as fast as we can!

while($seq = $gb->next_seq) { 

    #Sorry! Here would be with problem, if we use this "if (grep {$_=$seq->id} @genes_name;"

    $fa->write_seq($seq) if (grep {$_ eq $seq->id} @genes_name);

}
