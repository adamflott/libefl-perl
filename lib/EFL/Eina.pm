package EFL::Eina;

use 5.10.0;

use strict;
use warnings;

our $VERSION    = '0.50';
our $XS_VERSION = $VERSION;
$VERSION = eval $VERSION;    ## no critic

use Sub::Exporter;

use constant EINA_TRUE  => 1;
use constant EINA_FALSE => 0;

Sub::Exporter::setup_exporter({'exports' => [qw(EINA_TRUE EINA_FALSE)]});

1;

__END__

=head1 NAME

EFL::Eina - Perl bindings for the Enlightenment Foundation Library Eina


=head1 SYNOPSIS

Import all Eina functions and constants:

    use EFL::Eina qw(:all);

=head1 DESCRIPTION


=head1 SEE ALSO

Main Enlightenment page: L<http://www.enlightenment.org>

Eina API: L<http://docs.enlightenment.org/auto/eina/>

Git Web Repository: L<http://git.npjh.com/?p=libefl-perl.git;a=summary>


=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc EFL::Eina

You can also look for information at:

=over

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/EFL>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/EFL>

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=EFL>

=item * Search CPAN

L<http://search.cpan.org/dist/EFL>

=back


=head1 AUTHOR

Adam Flott, E<lt>adam@npjh.comE<gt>


=head1 COPYRIGHT AND LICENSE

Copyright (C) 2009 by Adam Flott

EFL::Eina will have the same license as Eina itself.

=cut
