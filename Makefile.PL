use strict;
use warnings;

use 5.10.0;

use File::Copy;
use File::Spec::Functions;
use FindBin qw($Bin);

use ExtUtils::MakeMaker;


foreach (qw(evas elementary)) {
    die("$_ not found in PKG_CONFIG_PATH\n") unless (qx(pkg-config --cflags $_));
}

# TODO get rid of this ugly hack
foreach (<common.[ch]>) {
    printf("Copying %s to %s\n", catfile($Bin, $_), catfile($Bin, "Evas", $_));
    copy(catfile($Bin, $_), catfile($Bin, "Evas", $_)) || die("copy() failed: $!");
    printf("Copying %s to %s\n", catfile($Bin, $_), catfile($Bin, "Elementary", $_));
    copy(catfile($Bin, $_), catfile($Bin, "Elementary", $_)) || die("copy() failed: $!");
}

# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    NAME         => 'EFL',
    AUTHOR        => 'Adam Flott <adam@npjh.com>',
    VERSION_FROM => 'lib/EFL.pm',
    PREREQ_PM    => {    },
    ABSTRACT_FROM => 'lib/EFL.pm',
    # These 3 lines prevent ExtUtils::MakeMaker from building EFL.so
    OBJECT        => "",
    XS            => {},
    C             => [],

);
