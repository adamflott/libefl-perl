
use 5.10.0;

use strict;
use warnings;

use Devel::Peek;

use EFL::Elementary qw(:all);
use EFL::Evas qw(:all);

sub my_win_del
{
    elm_exit();
}

sub main {
    my ($win, $bg);

    elm_init("asdf");

    $win = elm_win_add(undef, "main", ELM_WIN_BASIC);

    elm_win_title_set($win, "elm_image");

    evas_object_smart_callback_add($win, "delete,request", \&my_win_del, undef);

    my $ck = elm_clock_add($win);

    my ($bx);
    evas_object_resize($win, 120, 120);
    evas_object_show($win);

    $bg = elm_bg_add($win);
    elm_win_resize_object_add($win, $bg);
    evas_object_size_hint_weight_set($bg, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
    evas_object_show($bg);

    $bx = elm_box_add($win);
    evas_object_size_hint_weight_set($bx, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
    elm_win_resize_object_add($win, $bx);
    evas_object_show($bx);

    $ck = elm_clock_add($win);
    elm_clock_edit_set($ck, 1);
    elm_clock_show_seconds_set($ck, 1);
    elm_clock_show_am_pm_set($ck, 1);
    elm_clock_time_set($ck, 1, 1, 1);
    elm_box_pack_end($bx, $ck);
    evas_object_show($ck);

    my ($h, $m, $s) = (5, 5, 5);

    elm_clock_time_get($ck, \$h, \$m, \$s);

    printf("%d:%d:%d\n", $h, $m, $s);

    elm_run();

    elm_exit();

    return 0;
}

exit(main());
