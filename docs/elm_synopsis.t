use EFL::Elementary qw(:all);
use EFL::Evas qw(:all);

elm_init();
my $win = elm_win_add(undef, "main", ELM_WIN_BASIC);

elm_win_title_set($win, "my first window");

evas_object_smart_callback_add($win, "delete,request", sub { elm_exit() }, undef);

my $bg = elm_bg_add($win);
evas_object_size_hint_weight_set($bg, 1.0, 1.0);
elm_win_resize_object_add($win, $bg);
evas_object_show($bg);

evas_object_resize($win, 100, 100);
evas_object_show($win);

elm_run();

elm_exit();
