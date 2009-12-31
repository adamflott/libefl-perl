use strict;
use warnings;

use 5.10.0;

use Devel::Peek;
use Data::Dumper;

use constant EINA_TRUE => 1;

use EFL::Elementary qw(:all);

elm_init(@ARGV);

my $win = elm_win_add(undef, "main", ELM_WIN_BASIC);

elm_win_title_set($win, "");

evas_object_smart_callback_add($win, "delete,request", sub { elm_exit() }, 1);

my $bg = elm_bg_add($win);
evas_object_size_hint_weight_set($bg, 1.0, 1.0);
elm_win_resize_object_add($win, $bg);

evas_object_show($bg);
evas_object_resize($win, 120, 120);
evas_object_show($win);

my ($x, $y) = (3,3);
elm_win_screen_position_get($win, \$x, \$y);

print("(x, y) = ($x, $y)\n");

elm_run();

elm_exit();
