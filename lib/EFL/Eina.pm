package EFL::Eina;

# ABSTRACT: Perl bindings for Eina from the Enlightenment Foundation Libraries

use 5.10.0;

use strict;
use warnings;


our $VERSION    = '0.501';
our $XS_VERSION = $VERSION;

use Sub::Exporter;

use constant 'EINA_TRUE'  => 1;    ## no critic
use constant 'EINA_FALSE' => 0;    ## no critic

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

include_file:docs/warning.txt

=head1 SYNOPSIS

Import all Eina constants:

    use EFL::Eina qw(:all);

    print(EINA_TRUE);

=head1 EXPORTED API/CONSTANTS

include_cmd:misc/supported-api.pl -header eina

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc EFL::Eina

You can also look for information at:

=over

=item * RT: CPAN's request tracker: L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=EFL>

=item * AnnoCPAN: Annotated CPAN documentation: L<http://annocpan.org/dist/EFL>

=item * CPAN Ratings: L<http://cpanratings.perl.org/d/EFL>

=item * Search CPAN: L<http://search.cpan.org/dist/EFL>

=back

=head1 SEE ALSO

include_file:docs/see_also.pod
