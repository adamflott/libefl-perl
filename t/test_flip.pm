package elmt;

use strict;
use warnings;

sub my_fl_1 {
    my ($data) = @_;
    elm_flip_go($$data, ELM_FLIP_ROTATE_Y_CENTER_AXIS);
}

sub my_fl_2 {
    my ($data) = @_;
    elm_flip_go($$data, ELM_FLIP_ROTATE_X_CENTER_AXIS);
}

sub my_fl_3 {
    my ($data) = @_;
    elm_flip_go($$data, ELM_FLIP_ROTATE_XZ_CENTER_AXIS);
}

sub my_fl_4 {
    my ($data) = @_;
    elm_flip_go($$data, ELM_FLIP_ROTATE_YZ_CENTER_AXIS);
}

sub test_flip {
    my ($win, $bg, $bx, $bx2, $fl, $o, $bt, $ly);

    my $package_data_dir = $ENV{'ELM_PACKAGE_DATA_DIR'} || "/opt/e17/share/elementary/";

    $win = elm_win_add(undef, "flip", ELM_WIN_BASIC);
    elm_win_title_set($win, "Flip");
    elm_win_autodel_set($win, 1);

    $bg = elm_bg_add($win);
    elm_win_resize_object_add($win, $bg);
    evas_object_size_hint_weight_set($bg, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
    evas_object_show($bg);

    $bx = elm_box_add($win);
    evas_object_size_hint_weight_set($bx, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
    elm_win_resize_object_add($win, $bx);
    evas_object_show($bx);

    #if 1 // working on it

    $fl = elm_flip_add($win);
    evas_object_size_hint_align_set($fl, EVAS_HINT_FILL, EVAS_HINT_FILL);
    evas_object_size_hint_weight_set($fl, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
    elm_box_pack_end($bx, $fl);

    $o = elm_bg_add($win);
    evas_object_size_hint_align_set($o, EVAS_HINT_FILL, EVAS_HINT_FILL);
    evas_object_size_hint_weight_set($o, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
my $sky = $package_data_dir . 'images/sky_01.jpg';
    elm_bg_file_set($o, $sky, undef);
    elm_flip_content_front_set($fl, $o);
    evas_object_show($o);

    $ly = elm_layout_add($win);
    my $layout = $package_data_dir . 'objects/test.edj';
    elm_layout_file_set($ly, $layout, "layout");
    evas_object_size_hint_align_set($ly, EVAS_HINT_FILL, EVAS_HINT_FILL);
    evas_object_size_hint_weight_set($ly, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
    elm_flip_content_back_set($fl, $ly);

    #   evas_object_show($ly);

    $bt = elm_button_add($win);
    elm_button_label_set($bt, "Button 1");
    elm_layout_content_set($ly, "element1", $bt);
    evas_object_show($bt);

    $bt = elm_button_add($win);
    elm_button_label_set($bt, "Button 2");
    elm_layout_content_set($ly, "element2", $bt);
    evas_object_show($bt);

    $bt = elm_button_add($win);
    elm_button_label_set($bt, "Button 3");
    elm_layout_content_set($ly, "element3", $bt);
    evas_object_show($bt);

    evas_object_show($fl);

    $bx2 = elm_box_add($win);
    elm_box_horizontal_set($bx2, 1);
    evas_object_size_hint_align_set($bx2, EVAS_HINT_FILL, EVAS_HINT_FILL);
    evas_object_size_hint_weight_set($bx2, EVAS_HINT_EXPAND, 0.0);

    $bt = elm_button_add($win);
    elm_button_label_set($bt, "1");
    evas_object_smart_callback_add($bt, "clicked", \&my_fl_1, \$fl);
    evas_object_size_hint_align_set($bt, EVAS_HINT_FILL, EVAS_HINT_FILL);
    evas_object_size_hint_weight_set($bt, EVAS_HINT_EXPAND, 0.0);
    elm_box_pack_end($bx2, $bt);
    evas_object_show($bt);

    $bt = elm_button_add($win);
    elm_button_label_set($bt, "2");
    evas_object_smart_callback_add($bt, "clicked", \&my_fl_2, \$fl);
    evas_object_size_hint_align_set($bt, EVAS_HINT_FILL, EVAS_HINT_FILL);
    evas_object_size_hint_weight_set($bt, EVAS_HINT_EXPAND, 0.0);
    elm_box_pack_end($bx2, $bt);
    evas_object_show($bt);

    $bt = elm_button_add($win);
    elm_button_label_set($bt, "3");
    evas_object_smart_callback_add($bt, "clicked", \&my_fl_3, \$fl);
    evas_object_size_hint_align_set($bt, EVAS_HINT_FILL, EVAS_HINT_FILL);
    evas_object_size_hint_weight_set($bt, EVAS_HINT_EXPAND, 0.0);
    elm_box_pack_end($bx2, $bt);
    evas_object_show($bt);

    $bt = elm_button_add($win);
    elm_button_label_set($bt, "4");
    evas_object_smart_callback_add($bt, "clicked", \&my_fl_4, \$fl);
    evas_object_size_hint_align_set($bt, EVAS_HINT_FILL, EVAS_HINT_FILL);
    evas_object_size_hint_weight_set($bt, EVAS_HINT_EXPAND, 0.0);
    elm_box_pack_end($bx2, $bt);
    evas_object_show($bt);

    elm_box_pack_end($bx, $bx2);
    evas_object_show($bx2);

    evas_object_resize($win, 320, 480);
    evas_object_show($win);
}

1;
