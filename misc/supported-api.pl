#!/usr/bin/env perl

use strict;
use warnings;

use 5.10.0;

my $c;

BEGIN {
    $c = $ARGV[0] || 'all';
}

use blib;
use EFL ":$c";

my @api;

foreach (keys(%::)) {
    push(@api, $_) if defined(&{$_});
}

say($_) for (sort(@api));
