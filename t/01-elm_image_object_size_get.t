
use strict;

use 5.10.0;

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

    $bg = elm_bg_add($win);
    evas_object_size_hint_weight_set($bg, 1.0, 1.0);
    elm_win_resize_object_add($win, $bg);


    my $img = elm_image_add($bg);

    elm_image_file_set($img, "/opt/e17/share/elementary/images/wood_01.jpg", undef);

    evas_object_show($img);

    evas_object_show($bg);
    evas_object_resize($win, 120, 120);
    evas_object_show($win);

    my ($w, $h) = (1, 1);

    elm_image_object_size_get($img, $w, $h);
    say Dump($w), ref($w);
    printf("(w, h) = (%d, %d)\n", $w, $h);

    elm_run();

    elm_exit();

    return 0;
}

exit(main());
