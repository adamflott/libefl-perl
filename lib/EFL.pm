package EFL;

# ABSTRACT: Perl bindings for the Enlightenment Foundation Libraries

use 5.10.0;

use strict;
use warnings;

our $VERSION    = '0.50';
our $XS_VERSION = $VERSION;

use EFL::Eina qw(:all);
use EFL::Evas qw(:all);
use EFL::Elementary qw(:all);

use Sub::Exporter;

Sub::Exporter::setup_exporter(
    {
        'exports' => [ @EFL::Eina::__constants, @EFL::Evas::__funcs, @EFL::Evas::__constants, @EFL::Elementary::__func, @EFL::Elementary::__constants ],
        'groups'  => {
            'eina'       => [@EFL::Eina::__constants],
            'evas'       => [ @EFL::Evas::__funcs, @EFL::Evas::__constants ],
            'elementary' => [ @EFL::Elementary::__funcs, @EFL::Elementary::__constants ]
        }
    }
);

1;

=head1 SYNOPSIS

Import all EFL functions from EFL::*:

    use EFL qw(:all);

Or only a subset:

    use EFL qw(:evas :elementary);

=head1 DESCRIPTION

Perl bindings for the Enlightenment Foundation Libraries (EFL) Elementary
library. The API was deliberatly kept as close to 1-to-1 mapping of the
Elementary API as possible. Function parameters types and position are the same
as you would in C (deviations are documented), Evas_Object pointers are just
scalars, #defines are Perl constants, etc.

For example, the C way:

    elm_win_screen_position_get(Evas_Object *obj, int *x, int *y);

This will be translated into the Perlish-C way as:

    elm_win_screen_position_get($obj, \$x, \$y);

As opposed to the Perl way:

    my ($x, $y) = elm_win_screen_position_get($obj);

This was intentional as the desired goal will to aid in porting to pure-C. But
with the power of Perl and CPAN, it will be easier for rapid development and
prototyping.

=head1 WARNING

The API is not set in stone and may change in future releases.

=head1 REQUIRES

=over

=item * Perl 5.10.0+ (I haven't tried 5.8.x yet)

=item * Linux (untested on non-Linux platforms)

=item * gcc

=item * C<pkg-config> can find the F<evas.pc> and F<elementary.pm> files (if not
set C<PKG_CONFIG_PATH>)

=item * evas and elmentary compiled successfully

=item * linkable with -levas and -lelementary

=back

=head1 SUPPORTED

Currently only the following are supported:

=over

=item * evas

=item * elementary

=back

As I need more, I'll add them. Probably ecore, eina (may or may not
apply), eet.

=head1 NOT SUPPORTED

What I consider very low priority/no priority. Although I am fully open to patches.

=over

=item * Windows compatiability

=item * threads

=back

=head1 EXPORT

Nothing by default. You can either import the entire API with :all, or only a
subset with the tag name being the EFL group, e.g. C<:elementary>.

Check the EFL API documentation for how to correctly call functions.

To see what functions can be export run C<misc/supported.pl -api <efl-subset>> and
C<misc/supported.pl -tags <efl-subset>> for the Exporter tags available.

=head1 SEE ALSO

Main Enlightenment page: L<http://www.enlightenment.org>

Elementary API: L<http://docs.enlightenment.org/auto/elementary/>

Git Web Repository: L<http://git.npjh.com/?p=libefl-perl.git;a=summary>

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc EFL

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
