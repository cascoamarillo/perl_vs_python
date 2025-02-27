#!/usr/bin/perl 

use Bio::Perl;
use Bio::SeqIO;
use IO::String;
use Bio::SearchIO;

#Use this perl script to grep seqs in a fasta file (filename) with their ID (@genes_name), it will output a fasta file (fa) with the selected seqs/contigs.
#you can input you genes' name in the array or read it from other files.

my @genes_name=qw(GSADVT00033948001 GSADVT00006712001 GSADVT00009656001 GSADVT00010852001 GSADVT00010869001 GSADVT00017749001 GSADVT00022035001 GSADVT00024510001 GSADVT00033075001 GSADVT00033463001 GSADVT00033948001 GSADVT00036072001 GSADVT00037099001 GSADVT00039413001 GSADVT00043733001 GSADVT00047484001 GSADVT00050594001 GSADVT00052987001 GSADVT00064444001 GSADVT00065605001);


my $filename='/users/frodriguez/Avgenome/Genoscope/Adineta_vaga_v2.0.annot.pep.fa';

my $gb = Bio::SeqIO->new(-file   => "<$filename",
                              -format => "fasta");
my $fa = Bio::SeqIO->new(-file   => ">Av_GenID_piwi.fa",
                              -format => "fasta",
                              -flush  => 0); # go as fast as we can!

while($seq = $gb->next_seq) { 

    #Sorry! Here would be with problem, if we use this "if (grep {$_=$seq->id} @genes_name;"

    $fa->write_seq($seq) if (grep {$_ eq $seq->id} @genes_name);

}
