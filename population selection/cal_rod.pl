use strict;
use warnings;
use Getopt::Long;
use Cwd;

my ($dom, $wild, $outdir, $prefix);
GetOptions(
    "a|domesticated=s" => \$dom,
    "b|wild=s"         => \$wild,
    "o|outdir=s"       => \$outdir,
    "p|prefix=s"       => \$prefix,
) or die "Usage: $0 -a <dom.pi> -b <wild.pi> [-o outdir] [-p prefix]\n";

$outdir = getcwd() unless $outdir;
$prefix = "ROD"      unless $prefix;

die "Error: -a (domesticated) required\n"  unless $dom;
die "Error: -b (wild) required\n"          unless $wild;

system("mkdir -p $outdir") == 0 or die "Error: Cannot create $outdir\n";

my %piA;
open my $fh1, '<', $dom or die "Error: Cannot open $dom\n";
my $h1 = <$fh1>;
$h1 =~ s/\r?\n$//;
my @c1 = split /\t/, $h1;
my %idx1 = map { $c1[$_] => $_ } 0..$#c1;

while (<$fh1>) {
    chomp;
    next if /^\s*$/;
    my @f = split /\t/;
    my $key = "$f[$idx1{CHROM}]_$f[$idx1{BIN_START}]_$f[$idx1{BIN_END}]";
    $piA{$key} = $f[$idx1{PI}];
}
close $fh1;

my @out;
open my $fh2, '<', $wild or die "Error: Cannot open $wild\n";
my $h2 = <$fh2>;
$h2 =~ s/\r?\n$//;
my @c2 = split /\t/, $h2;
my %idx2 = map { $c2[$_] => $_ } 0..$#c2;

while (<$fh2>) {
    chomp;
    next if /^\s*$/;
    my @f = split /\t/;
    my $key = "$f[$idx2{CHROM}]_$f[$idx2{BIN_START}]_$f[$idx2{BIN_END}]";
    
    if (exists $piA{$key}) {
        my $a = $piA{$key};
        my $b = $f[$idx2{PI}];
        my $rod = ($b == 0) ? "NA" : sprintf("%.6f", 1 - $a/$b);
        push @out, [$f[$idx2{CHROM}], $f[$idx2{BIN_START}], $f[$idx2{BIN_END}], $a, $b, $rod];
    }
}
close $fh2;

@out = sort { $a->[0] cmp $b->[0] || $a->[1] <=> $b->[1] } @out;

open my $out, '>', "$outdir/$prefix.txt" or die "Error: Cannot write output\n";
print $out join("\t", "CHROM", "BIN_START", "BIN_END", $dom, $wild, "ROD"), "\n";
print $out join("\t", @$_), "\n" for @out;
close $out;

print "Done. Output: $outdir/$prefix.txt\n";