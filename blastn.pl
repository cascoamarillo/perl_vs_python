#!/usr/bin/perl
use strict;
use warnings;

# Check if input arguments are correct
if (@ARGV != 2) {
    die "Usage: ./simple_blast.pl seq1.fa seq2.fa\n";
}

my ($seq1_file, $seq2_file) = @ARGV;

# Read sequences from FASTA files
sub read_fasta {
    my ($filename) = @_;
    open(my $fh, '<', $filename) or die "Could not open file '$filename': $!";
    my $header = <$fh>;  # skip the header line
    my $sequence = '';
    while (my $line = <$fh>) {
        chomp $line;
        $sequence .= $line unless $line =~ /^>/;
    }
    close $fh;
    return $sequence;
}

# Scoring system: match = +5, mismatch = -2
my $match_score = 5;
my $mismatch_score = -2;
my $word_size = 10; # Define word size for the BLAST algorithm

# Find matching words between seq1 and seq2 (seed step)
sub find_word_hits {
    my ($seq1, $seq2, $word_size) = @_;
    my %word_hits;
    
    for (my $i = 0; $i <= length($seq1) - $word_size; $i++) {
        my $word = substr($seq1, $i, $word_size);
        while ((my $j = index($seq2, $word)) != -1) {
            $word_hits{$i} = $j;  # Store positions of matching words
            $seq2 = substr($seq2, 0, $j) . " " . substr($seq2, $j + 1);  # avoid duplicate matches
        }
    }
    return %word_hits;
}

# Extend the alignment around the seed (extend step)
sub extend_alignment {
    my ($seq1, $seq2, $pos1, $pos2) = @_;
    my $alignment_score = 0;
    my $aligned_seq1 = '';
    my $aligned_seq2 = '';
    
    # Extend to the right
    my $i = $pos1;
    my $j = $pos2;
    while ($i < length($seq1) && $j < length($seq2)) {
        my $nuc1 = substr($seq1, $i, 1);
        my $nuc2 = substr($seq2, $j, 1);
        
        if ($nuc1 eq $nuc2) {
            $alignment_score += $match_score;
        } else {
            $alignment_score += $mismatch_score;
        }
        
        $aligned_seq1 .= $nuc1;
        $aligned_seq2 .= $nuc2;
        
        last if $alignment_score < 0;  # Stop extension if score drops below zero
        
        $i++;
        $j++;
    }
    
    # Extend to the left
    $i = $pos1 - 1;
    $j = $pos2 - 1;
    while ($i >= 0 && $j >= 0) {
        my $nuc1 = substr($seq1, $i, 1);
        my $nuc2 = substr($seq2, $j, 1);
        
        if ($nuc1 eq $nuc2) {
            $alignment_score += $match_score;
        } else {
            $alignment_score += $mismatch_score;
        }
        
        $aligned_seq1 = $nuc1 . $aligned_seq1;
        $aligned_seq2 = $nuc2 . $aligned_seq2;
        
        last if $alignment_score < 0;  # Stop extension if score drops below zero
        
        $i--;
        $j--;
    }
    
    return ($alignment_score, $aligned_seq1, $aligned_seq2);
}

# Main program logic
my $seq1 = read_fasta($seq1_file);
my $seq2 = read_fasta($seq2_file);

# Find word hits (seed step)
my %word_hits = find_word_hits($seq1, $seq2, $word_size);

# Extend alignments around each word hit
my $best_score = 0;
my $best_seq1_align = '';
my $best_seq2_align = '';

foreach my $pos1 (keys %word_hits) {
    my $pos2 = $word_hits{$pos1};
    my ($score, $aligned_seq1, $aligned_seq2) = extend_alignment($seq1, $seq2, $pos1, $pos2);
    
    if ($score > $best_score) {
        $best_score = $score;
        $best_seq1_align = $aligned_seq1;
        $best_seq2_align = $aligned_seq2;
    }
}

# Output the best local alignment and score
print "Best local alignment score: $best_score\n";
print "Seq1: $best_seq1_align\n";
print "Seq2: $best_seq2_align\n";
