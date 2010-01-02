package EFL::Eina;

# ABSTRACT: Perl bindings for Eina from the Enlightenment Foundation Libraries

use 5.10.0;

use strict;
use warnings;

our $VERSION    = '0.50';
our $XS_VERSION = $VERSION;

use Sub::Exporter;

use constant EINA_TRUE  => 1;
use constant EINA_FALSE => 0;

our @__constants = qw(
  EINA_TRUE
  EINA_FALSE
);

Sub::Exporter::setup_exporter({'exports' => [@__constants]}, 'groups' => {'constants' => \@__constants});

1;

=head1 DESCRIPTION

This module is the Perl bindings for the Enlightenment Foundation Libraries'
(EFL) Eina library. Due to Eina primarily providing data types in C it's
coverage in Perl will be limited. Currently, it only provides constants.

=head1 WARNING

With regards to passing data between Perl and C, the API is not set in stone and
may change in future releases.

=head1 SYNOPSIS

Import all Eina constants:

    use EFL::Eina qw(:all);

    print(EINA_TRUE);

=head1 INCLUDE: EXPORTED API/CONSTANTS

This list is autogenerated from F<misc/supported-api.pl> and does not guarantee
correct behavior.

cmd:misc/supported-api.pl eina

=head1 SEE ALSO

=over

=item * Main Enlightenment page: L<http://www.enlightenment.org>

=item * Eina API: L<http://docs.enlightenment.org/auto/eina/>

=item * EFL Git Web Repository: L<http://git.npjh.com/?p=libefl-perl.git;a=summary>

=back
