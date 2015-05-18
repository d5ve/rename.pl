#!/usr/bin/perl -w

use strict;
use warnings;

local $| = 1;

use Data::Dumper;
$Data::Dumper::Sortkeys = 1;
use Getopt::Long;
use Pod::Usage;

my $show_man     = 0;
my $show_help    = 0;
my $doit         = 0;

GetOptions(
    'help|?'  => \$show_help,
    'man'     => \$show_man,
    'doit'    => \$doit,
    );

pod2usage(1)             if $show_help;
pod2usage(-verbose => 2) if $show_man;
pod2usage(1)             unless @ARGV;

my $op = shift or pod2usage(1);

chomp(@ARGV = <STDIN>) unless @ARGV;
for (@ARGV) {
    my $was = $_;
    eval $op;
    die $@ if $@;
    if ( $was ne $_ ) {
        if ( length("$was -> $_") > 80 ) {
            print "$doit - $was -> \n\t\t$_\n";
        }
        else {
            print "$doit - $was -> $_\n";
        }
        if ( $doit ) {
            rename($was,$_) unless $was eq $_;
        }
    }
    else {
        print "No change to $was\n";
    }
}

exit;

__END__

=head1 NAME

rename.pl - perl file renamer

=head1 DESCRIPTION

Rename a list of files based upon perl operations.

Based upon Larry Wall's filename fixer script:
    The Perl Coookbook,
    Chapter 9.9, Renaming Files
    O'Reilly, 1999

=head1 SYNOPSIS

    rename.pl [options] [perl statements] [files]

    Options:
        --debug       verbose mode
        --help        brief help message - default behaviour
        --man         full documentation
        --doit        rename the files - default is to display proposed change

    Examples:

        # Rename all avi files to just show name and episode string.
        rename.pl "s{.*(S\d\dE\d\d).*)}{Lost - \$1.avi}xms" *.avi

        # Format filenames with digits into a zero-padded sortable form. 
        rename.pl 's/-(\d+)/sprintf q{-%03d}, $1/exms' *.jpg
        
=head1 OPTIONS

=over 8

=item B<--debug>

    Print details of all the work being done.

=item B<--help>

    Print a brief help message and exits. This mode is the default behaviour.

=item B<--man>

    Prints the manual page and exits.

=back

=head1 LICENCE

Copyright 2015 Dave Webb

rename.pl is free software. You may use and distribute this script under the
same terms as Perl itself.

=cut
