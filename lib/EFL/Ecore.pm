package EFL::Ecore;

# ABSTRACT: Perl bindings for Ecore from the Enlightenment Foundation Libraries

use 5.10.0;

use strict;
use warnings;

our $VERSION    = '0.501';
our $XS_VERSION = $VERSION;

use Sub::Exporter;


sub can {
    my ($class, $name) = @_;

    return \&{$class . '::' . $name} if (defined(&{$name}));

    return if ($name eq 'constant');
    my ($error, $val) = constant($name);

    return if ($error);
    my $sub = sub () { $val };

    {
        no strict 'refs';    ## no critic
        *{$class . '::' . $name} = $sub;
    }

    return $sub;
}

our @__constants = qw(
  ECORE_CALLBACK_CANCEL
  ECORE_CALLBACK_RENEW
  ECORE_EVENT_COUNT
  ECORE_EVENT_NONE
  ECORE_EVENT_SIGNAL_EXIT
  ECORE_EVENT_SIGNAL_HUP
  ECORE_EVENT_SIGNAL_POWER
  ECORE_EVENT_SIGNAL_REALTIME
  ECORE_EVENT_SIGNAL_USER
  ECORE_EXE_NOT_LEADER
  ECORE_EXE_PIPE_AUTO
  ECORE_EXE_PIPE_ERROR
  ECORE_EXE_PIPE_ERROR_LINE_BUFFERED
  ECORE_EXE_PIPE_READ
  ECORE_EXE_PIPE_READ_LINE_BUFFERED
  ECORE_EXE_PIPE_WRITE
  ECORE_EXE_PRIORITY_INHERIT
  ECORE_EXE_RESPAWN
  ECORE_EXE_USE_SH
  ECORE_FD_ERROR
  ECORE_FD_READ
  ECORE_FD_WRITE
  ECORE_POLLER_CORE
);

our @__funcs = qw(
  ecore_timer_add
  ecore_timer_del
);


Sub::Exporter::setup_exporter({'exports' => [ @__constants, @__funcs ]}, 'groups' => {'constants' => \@__constants, 'funcs' => \@__funcs});

require XSLoader;
XSLoader::load('EFL::Ecore', $VERSION);

1;

=head1 DESCRIPTION

Perl bindings for the Enlightenment Foundation Libraries (EFL) Elementary
library.

=head1 WARNING

include_file:docs/warning.txt

=head1 SYNOPSIS

    use EFL::Ecore qw(:all);

    ...

=head1 EXPORTED API/CONSTANTS

include_cmd:    misc/supported-api.pl -header ecore

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc EFL::Ecore

You can also look for information at:

=over

=item * RT: CPAN's request tracker: L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=EFL>

=item * AnnoCPAN: Annotated CPAN documentation: L<http://annocpan.org/dist/EFL>

=item * CPAN Ratings: L<http://cpanratings.perl.org/d/EFL>

=item * Search CPAN: L<http://search.cpan.org/dist/EFL>

=back

=head1 SEE ALSO

include_file:docs/see_also.pod
