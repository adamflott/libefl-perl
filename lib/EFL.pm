package EFL;

# ABSTRACT: Perl bindings for the Enlightenment Foundation Libraries

use 5.10.0;

use strict;
use warnings;

our $VERSION    = '0.50';
our $XS_VERSION = $VERSION;

use EFL::Eina qw(:all);
use EFL::Ecore qw(:all);
use EFL::Evas qw(:all);
use EFL::Elementary qw(:all);

use Sub::Exporter;

Sub::Exporter::setup_exporter(
    {
        'exports' => [ @EFL::Eina::__constants, @EFL::Ecore::__constants, @EFL::Ecore::__funcs, @EFL::Evas::__funcs, @EFL::Evas::__constants, @EFL::Elementary::__funcs, @EFL::Elementary::__constants ],
        'groups'  => {
            'eina'       => [@EFL::Eina::__constants],
            'ecore'      => [@EFL::Ecore::__constants, @EFL::Ecore::__funcs],
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

include_file:docs/warning.txt

=head1 EVEN MORE WARNINGS

Due to the complexity of EFL and XS, it is very easy to segfault. For instance,

    elm_win_add(undef, "main", ELM_WIN_BASIC);

    ...

Without a leading C<elm_init();> causes a segfault. You've been warned. Although
if you compiled Elementary, Evas, etc with symbols (C<-g> in gcc), you can
easily see where the segfault occured with C<gdb -c core `which perl`>.

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

Currently only the following are supported.

=over

=item * evas

=item * elementary

=back

=head1 PARTIALLY SUPPORTED

Currently only the following are partially supported. With more support coming
in the future.

=over

=item * ecore

=item * eina

=back

=head1 NOT SUPPORTED

What I consider very low priority/no priority. Although I am fully open to patches.

=over

=item * non-Linux/Windows compatiability

=item * Perl threads

=back

=head1 EXPORT

Nothing by default. You can either import the entire API with :all, or only a
subset with the tag name being the EFL group, e.g. C<:elementary>.

Check the EFL API documentation for how to correctly call functions.

To see what functions can be export run C<misc/supported.pl -api <efl-subset>> and
C<misc/supported.pl -tags <efl-subset>> for the Exporter tags available.

=head1 ACKNOWLEDGEMENTS

Some thanks for helping me out.

=over

=item * Everyone that worked on EFL. The API makes sense and was easy to Perl-ize.

=item * L<Audio::XMMSClient> for showing me some XS tricks.

=item * L<Dist::Zilla> and L<Pod::Weaver> for making it easier to manage releases/POD.

=back

=head1 SEE ALSO

include_file:docs/see_also.pod
