use strict;
use warnings;

use 5.10.0;

BEGIN {
    die("\$DISPLAY not set! This test needs X Windows to work!\n") unless ($ENV{'DISPLAY'});
}

use Test::More;
my $tn = 0;

use Devel::Peek;
use Data::Dumper;

my %images = (
    'panel'      => "panel_01.jpg",
    'rock'       => "rock_01.jpg",
    'wood'       => "wood_01.jpg",
    'sky'        => "sky_01.jpg",
    'sky2'       => "sky_02.jpg",
    'sky3'       => "sky_03.jpg",
    'plant'      => "plant_01.jpg",
    'logo'       => "logo.png",
    'logo_small' => "logo_small.png"
);

my $package_data_dir = $ENV{'ELM_PACKAGE_DATA_DIR'} || "/opt/e17/share/elementary/images/";

foreach (keys(%images)) {
    $images{$_} = $package_data_dir . $images{$_};

    die("$images{$_} not found, aborting test suite.\n") unless (-e $images{$_});
}

use EFL qw(:all);

elm_init(@ARGV);

sub basic {
    my $win = elm_win_add(undef, "main", ELM_WIN_BASIC);

    elm_win_title_set($win, "EFL::Elementary");

    evas_object_smart_callback_add($win, "delete,request", sub { elm_exit(); exit(0); }, undef);

    my $bg = elm_bg_add($win);
    evas_object_size_hint_weight_set($bg, 1.0, 1.0);
    elm_win_resize_object_add($win, $bg);
    evas_object_show($bg);

    my $bx = elm_box_add($win);
    evas_object_size_hint_weight_set($bx, 1.0, 1.0);
    elm_win_resize_object_add($win, $bx);
    evas_object_show($bx);

    my $bx2 = elm_box_add($win);
    evas_object_size_hint_weight_set($bx2, 1.0, 1.0);
    elm_win_resize_object_add($win, $bx2);
    elm_box_pack_end($bx, $bx2);
    evas_object_show($bx2);

    my $fr = elm_frame_add($win);
    elm_frame_label_set($fr, "Do you see this?");
    elm_box_pack_end($bx2, $fr);
    evas_object_show($fr);

    my $lb = elm_label_add($win);
    elm_label_label_set($lb, "If you can see this window, then most likely everything compiled correctly.<br>"
                           . "If you'd like test out the Elementary test suite (a port of elementary_test to Perl)<br>"
                           . "click the 'OK' button. Otherwise click 'Cancel' found to Click on the 'OK' button to<br>"
                           . "exit and pass the test.");
    elm_frame_content_set($fr, $lb);
#    elm_object_scale_set($lb, 1.0);
    evas_object_show($lb);

    my $bx3 = elm_box_add($win);
    elm_box_horizontal_set($bx3, 1);
    evas_object_size_hint_weight_set($bx3, 1.0, 1.0);
    elm_win_resize_object_add($win, $bx3);
    elm_box_pack_end($bx, $bx3);
    evas_object_show($bx3);

    my $ok = elm_button_add($win);
    elm_button_label_set($ok, "OK");
    elm_box_pack_end($bx3, $ok);
    evas_object_show($ok);

    my $cancel = elm_button_add($win);
    elm_button_label_set($cancel, "Cancel");
    elm_box_pack_end($bx3, $cancel);
    evas_object_show($cancel);

    evas_object_smart_callback_add($ok, "clicked",
                                   sub {
                                       ok(1, "create basic elementary window and continue...");
                                       $tn++;
                                       elm_exit();
                                       evas_object_hide($win);
                                   }, undef);

    evas_object_smart_callback_add($cancel, "clicked",
                                   sub {
                                       ok(1, "create basic elementary window and done testing...");
                                       $tn++;
                                       elm_exit();
                                       exit(0);
                                   }, undef);

    evas_object_resize($win, 340, 80);
    evas_object_show($win);

    elm_run();
}

END {
    done_testing($tn)
}

basic();

my $win = elm_win_add(undef, "main", ELM_WIN_BASIC);

elm_win_title_set($win, "EFL::Elementary simple window creation");

evas_object_smart_callback_add($win, "delete,request",
                               sub {
                                   ok(1, "Elementary test suite");
                                   $tn++;
                                   elm_exit()
                               }, undef);

my $bg = elm_bg_add($win);
evas_object_size_hint_weight_set($bg, 1.0, 1.0);
elm_win_resize_object_add($win, $bg);

my $bx0 = elm_box_add($win);
evas_object_size_hint_weight_set($bx0, 1.0, 1.0);
elm_win_resize_object_add($win, $bx0);
evas_object_show($bx0);

my $fr = elm_frame_add($win);
elm_frame_label_set($fr, "Information");
elm_box_pack_end($bx0, $fr);
evas_object_show($fr);

my $lb = elm_label_add($win);
elm_label_label_set($lb, "Please select a test from the list below<br>"
                       . "by clicking the test button to show the<br>test window.");
elm_frame_content_set($fr, $lb);
evas_object_show($lb);

my $li = elm_list_add($win);
elm_list_always_select_mode_set($li, 1);
evas_object_size_hint_weight_set($li, 1.0, 1.0);
evas_object_size_hint_fill_set($li, -1.0, -1.0);
elm_box_pack_end($bx0, $li);
evas_object_show($li);

elm_list_item_append($li, "Bg Plain",         undef, undef, \&test_bg_plain,       undef);
elm_list_item_append($li, "Bg Image",         undef, undef, \&test_bg_image,       undef);
elm_list_item_append($li, "Icon Transparent", undef, undef, \&test_icon, undef);
elm_list_item_append($li, "Box Vert",         undef, undef, \&test_box_vert,       undef);
elm_list_item_append($li, "Box Horiz",        undef, undef, \&test_box_horiz,      undef);
elm_list_item_append($li, "Buttons",          undef, undef, \&test_button,         undef);
elm_list_item_append($li, "Toggles",          undef, undef, \&test_toggle,         undef);
elm_list_item_append($li, "Table",            undef, undef, \&test_table,          undef);
elm_list_item_append($li, "Clock",            undef, undef, \&test_clock,          undef);
elm_list_item_append($li, "Layout",           undef, undef, \&test_layout,         undef);
elm_list_item_append($li, "Hover",          undef, undef, \&test_hover,          undef);
elm_list_item_append($li, "Hover 2",        undef, undef, \&test_hover2,         undef);
elm_list_item_append($li, "Entry",          undef, undef, \&test_entry,          undef);
elm_list_item_append($li, "Entry Scrolled", undef, undef, \&test_entry_scrolled, undef);
elm_list_item_append($li, "Notepad",          undef, undef, \&test_notepad,        undef);
# TODO push args on stack elm_list_item_append($li, "Anchorview",       undef, undef, \&test_anchorview,     undef);
# TODO push args on stack elm_list_item_append($li, "Anchorblock",      undef, undef, \&test_anchorblock,    undef);
elm_list_item_append($li, "Toolbar",  undef, undef, \&test_toolbar,  undef);
elm_list_item_append($li, "Hoversel", undef, undef, \&test_hoversel, undef);
elm_list_item_append($li, "List",     undef, undef, \&test_list,     undef);
# TODO push args on stack elm_list_item_append($li, "List 2",           undef, undef, \&test_list2,          undef);
elm_list_item_append($li, "List 3",   undef, undef, \&test_list3,    undef);
elm_list_item_append($li, "Carousel", undef, undef, \&test_carousel, undef);
elm_list_item_append($li, "Inwin",    undef, undef, \&test_inwin,    undef);
elm_list_item_append($li, "Inwin 2",  undef, undef, \&test_inwin2,   undef);
elm_list_item_append($li, "Scaling",          undef, undef, \&test_scaling,        undef);
elm_list_item_append($li, "Scaling 2",        undef, undef, \&test_scaling2,       undef);
elm_list_item_append($li, "Slider",           undef, undef, \&test_slider,         undef);
elm_list_item_append($li, "Genlist",          undef, undef, \&test_genlist,        undef);
# TODO ...
# elm_list_item_append($li, "Genlist 2",        undef, undef, \&test_genlist2,       undef);
# elm_list_item_append($li, "Genlist 3",        undef, undef, \&test_genlist3,       undef);
# elm_list_item_append($li, "Genlist 4",        undef, undef, \&test_genlist4,       undef);
# elm_list_item_append($li, "Genlist 5",        undef, undef, \&test_genlist5,       undef);
# elm_list_item_append($li, "Genlist Tree",     undef, undef, \&test_genlist6,       undef);
# elm_list_item_append($li, "Checks",           undef, undef, \&test_check,          undef);
# elm_list_item_append($li, "Radios",           undef, undef, \&test_radio,          undef);
elm_list_item_append($li, "Pager",         undef, undef, \&test_pager,     undef);
elm_list_item_append($li, "Window States", undef, undef, \&test_win_state, undef);
elm_list_item_append($li, "Progressbar",      undef, undef, \&test_progressbar,    undef);
# TODO ...
# elm_list_item_append($li, "File Selector",    undef, undef, \&test_fileselector,   undef);
# elm_list_item_append($li, "Separator",        undef, undef, \&test_separator,      undef);
# elm_list_item_append($li, "Scroller",         undef, undef, \&test_scroller,       undef);
# elm_list_item_append($li, "Spinner",          undef, undef, \&test_spinner,        undef);
# elm_list_item_append($li, "Index",            undef, undef, \&test_index,          undef);
# elm_list_item_append($li, "Photocam",         undef, undef, \&test_photocam,       undef);
# elm_list_item_append($li, "Photo",            undef, undef, \&test_photo,          undef);
# elm_list_item_append($li, "Icon Desktops",    undef, undef, \&test_icon_desktops,  undef);
# elm_list_item_append($li, "Notify",           undef, undef, \&test_notify,         undef);
# elm_list_item_append($li, "Slideshow",        undef, undef, \&test_slideshow,      undef);
# elm_list_item_append($li, "Menu",             undef, undef, \&test_menu,           undef);
# elm_list_item_append($li, "Panel",            undef, undef, \&test_panel,          undef);
# elm_list_item_append($li, "Map",              undef, undef, \&test_map,            undef);
# elm_list_item_append($li, "Weather",          undef, undef, \&test_weather,        undef);
# elm_list_item_append($li, "Flip",             undef, undef, \&test_flip,           undef);

elm_list_go($li);

evas_object_show($bg);
evas_object_resize($win, 240, 480);
evas_object_show($win);

elm_run();

elm_exit();

sub test_bg_plain {
    my ($data, $evas_obj, $event_info) = @_;

    my ($win, $bg);

    $win = elm_win_add(undef, "bg-plain", ELM_WIN_BASIC);
    elm_win_title_set($win, "Bg Plain");
    elm_win_autodel_set($win, 1);

    $bg = elm_bg_add($win);

    evas_object_size_hint_weight_set($bg, 1.0, 1.0);
    elm_win_resize_object_add($win, $bg);
    evas_object_show($bg);

    evas_object_size_hint_min_set($bg, 160, 160);
    evas_object_size_hint_max_set($bg, 640, 640);

    evas_object_resize($win, 320, 320);

    evas_object_show($win);
}

sub test_bg_image {
    my ($win, $bg);

    $win = elm_win_add(undef, "bg-image", ELM_WIN_BASIC);
    elm_win_title_set($win, "Bg Image");
    elm_win_autodel_set($win, 1);

    $bg = elm_bg_add($win);
    elm_bg_file_set($bg, $images{'plant'}, undef);
    evas_object_size_hint_weight_set($bg, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
    elm_win_resize_object_add($win, $bg);
    evas_object_show($bg);

    evas_object_size_hint_min_set($bg, 160, 160);
    evas_object_size_hint_max_set($bg, 640, 640);
    evas_object_resize($win, 320, 320);
    evas_object_show($win);
}

sub icon_clicked {
    print(STDERR Dumper(\@_));
    my ($win) = @_;
    printf(STDERR "clicked!\n");
    evas_object_hide($$win);
}

sub test_icon {
    my ($win, $bg, $ic);

    $win = elm_win_add(undef, "icon-transparent", ELM_WIN_BASIC);
    elm_win_title_set($win, "Icon Transparent");
    elm_win_autodel_set($win, 1);
    elm_win_alpha_set($win, 1);

    $ic = elm_icon_add($win);
    elm_icon_file_set($ic, $images{'logo'}, undef);
    elm_icon_scale_set($ic, 0, 0);
    elm_win_resize_object_add($win, $ic);
    evas_object_show($ic);

    evas_object_smart_callback_add($ic, "clicked", \&icon_clicked, \$win);

    evas_object_show($win);
}

sub test_box_vert {
    my ($win, $bg, $bx, $ic);

    $win = elm_win_add(undef, "box-vert", ELM_WIN_BASIC);
    elm_win_title_set($win, "Box Vert");
    elm_win_autodel_set($win, 1);

    $bg = elm_bg_add($win);
    elm_win_resize_object_add($win, $bg);
    evas_object_size_hint_weight_set($bg, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
    evas_object_show($bg);

    $bx = elm_box_add($win);
    elm_win_resize_object_add($win, $bx);
    evas_object_size_hint_weight_set($bx, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
    evas_object_show($bx);

    $ic = elm_icon_add($win);
    elm_icon_file_set($ic, $images{'logo_small'}, undef);
    elm_icon_scale_set($ic, 0, 0);
    evas_object_size_hint_align_set($ic, 0.5, 0.5);
    elm_box_pack_end($bx, $ic);
    evas_object_show($ic);

    $ic = elm_icon_add($win);
    elm_icon_file_set($ic, $images{'logo_small'}, undef);
    elm_icon_scale_set($ic, 0, 0);
    evas_object_size_hint_align_set($ic, 0.0, 0.5);
    elm_box_pack_end($bx, $ic);
    evas_object_show($ic);

    $ic = elm_icon_add($win);
    elm_icon_file_set($ic, $images{'logo_small'}, undef);
    elm_icon_scale_set($ic, 0, 0);
    evas_object_size_hint_align_set($ic, EVAS_HINT_EXPAND, 0.5);
    elm_box_pack_end($bx, $ic);
    evas_object_show($ic);

    evas_object_show($win);
}

sub test_box_horiz {
    my ($win, $bg, $bx, $ic);

    $win = elm_win_add(undef, "box-horiz", ELM_WIN_BASIC);
    elm_win_title_set($win, "Box Horiz");
    elm_win_autodel_set($win, 1);

    $bg = elm_bg_add($win);
    elm_win_resize_object_add($win, $bg);
    evas_object_size_hint_weight_set($bg, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
    evas_object_show($bg);

    $bx = elm_box_add($win);
    elm_box_horizontal_set($bx, 1);
    elm_win_resize_object_add($win, $bx);
    evas_object_size_hint_weight_set($bx, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
    evas_object_show($bx);

    $ic = elm_icon_add($win);
    elm_icon_file_set($ic, $images{'logo_small'}, undef);
    elm_icon_scale_set($ic, 0, 0);
    evas_object_size_hint_align_set($ic, 0.5, 0.5);
    elm_box_pack_end($bx, $ic);
    evas_object_show($ic);

    $ic = elm_icon_add($win);
    elm_icon_file_set($ic, $images{'logo_small'}, undef);
    elm_icon_scale_set($ic, 0, 0);
    evas_object_size_hint_align_set($ic, 0.5, 0.0);
    elm_box_pack_end($bx, $ic);
    evas_object_show($ic);

    $ic = elm_icon_add($win);
    elm_icon_file_set($ic, $images{'logo_small'}, undef);
    elm_icon_scale_set($ic, 0, 0);
    evas_object_size_hint_align_set($ic, 0.0, EVAS_HINT_EXPAND);
    elm_box_pack_end($bx, $ic);
    evas_object_show($ic);

    evas_object_show($win);
}

sub test_button {
    my ($win, $bg, $bx, $ic, $bt);

    $win = elm_win_add(undef, "buttons", ELM_WIN_BASIC);
    elm_win_title_set($win, "Buttons");
    elm_win_autodel_set($win, 1);

    $bg = elm_bg_add($win);
    elm_win_resize_object_add($win, $bg);
    evas_object_size_hint_weight_set($bg, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
    evas_object_show($bg);

    $bx = elm_box_add($win);
    evas_object_size_hint_weight_set($bx, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
    elm_win_resize_object_add($win, $bx);
    evas_object_show($bx);

    $ic = elm_icon_add($win);
    elm_icon_file_set($ic, $images{'logo_small'}, undef);
    evas_object_size_hint_aspect_set($ic, EVAS_ASPECT_CONTROL_VERTICAL, 1, 1);
    $bt = elm_button_add($win);
    elm_button_label_set($bt, "Icon sized to button");
    elm_button_icon_set($bt, $ic);
    elm_box_pack_end($bx, $bt);
    evas_object_show($bt);
    evas_object_show($ic);

    $ic = elm_icon_add($win);
    elm_icon_file_set($ic, $images{'logo_small'}, undef);
    elm_icon_scale_set($ic, 0, 0);
    $bt = elm_button_add($win);
    elm_button_label_set($bt, "Icon no scale");
    elm_button_icon_set($bt, $ic);
    elm_box_pack_end($bx, $bt);
    evas_object_show($bt);
    evas_object_show($ic);

    $ic = elm_icon_add($win);
    elm_icon_file_set($ic, $images{'logo_small'}, undef);
    evas_object_size_hint_aspect_set($ic, EVAS_ASPECT_CONTROL_VERTICAL, 1, 1);
    $bt = elm_button_add($win);
    elm_button_label_set($bt, "Disabled Button");
    elm_button_icon_set($bt, $ic);
    elm_object_disabled_set($bt, 1);
    elm_box_pack_end($bx, $bt);
    evas_object_show($bt);
    evas_object_show($ic);

    $ic = elm_icon_add($win);
    elm_icon_file_set($ic, $images{'logo_small'}, undef);
    evas_object_size_hint_aspect_set($ic, EVAS_ASPECT_CONTROL_VERTICAL, 1, 1);
    $bt = elm_button_add($win);
    elm_button_icon_set($bt, $ic);
    elm_object_disabled_set($bt, 1);
    elm_box_pack_end($bx, $bt);
    evas_object_show($bt);
    evas_object_show($ic);

    $bt = elm_button_add($win);
    elm_button_label_set($bt, "Label Only");
    elm_box_pack_end($bx, $bt);
    evas_object_show($bt);

    $ic = elm_icon_add($win);
    elm_icon_file_set($ic, $images{'logo_small'}, undef);
    elm_icon_scale_set($ic, 0, 0);
    $bt = elm_button_add($win);
    elm_button_icon_set($bt, $ic);
    elm_box_pack_end($bx, $bt);
    evas_object_show($bt);
    evas_object_show($ic);

    $bt = elm_button_add($win);
    elm_object_style_set($bt, "anchor");
    elm_button_label_set($bt, "Anchor style");
    elm_box_pack_end($bx, $bt);
    evas_object_show($bt);

    $ic = elm_icon_add($win);
    elm_icon_file_set($ic, $images{'logo_small'}, undef);
    evas_object_size_hint_aspect_set($ic, EVAS_ASPECT_CONTROL_VERTICAL, 1, 1);
    $bt = elm_button_add($win);
    elm_object_style_set($bt, "anchor");
    elm_button_icon_set($bt, $ic);
    elm_box_pack_end($bx, $bt);
    evas_object_show($bt);
    evas_object_show($ic);

    $ic = elm_icon_add($win);
    elm_icon_file_set($ic, $images{'logo_small'}, undef);
    evas_object_size_hint_aspect_set($ic, EVAS_ASPECT_CONTROL_VERTICAL, 1, 1);
    $bt = elm_button_add($win);
    elm_object_style_set($bt, "anchor");
    elm_button_icon_set($bt, $ic);
    elm_object_disabled_set($bt, 1);
    elm_box_pack_end($bx, $bt);
    evas_object_show($bt);
    evas_object_show($ic);

    evas_object_show($win);
}

sub test_toggle {
    my ($win, $bg, $bx, $ic, $tg);

    $win = elm_win_add(undef, "toggles", ELM_WIN_BASIC);
    elm_win_title_set($win, "Toggles");
    elm_win_autodel_set($win, 1);

    $bg = elm_bg_add($win);
    elm_win_resize_object_add($win, $bg);
    evas_object_size_hint_weight_set($bg, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
    evas_object_show($bg);

    $bx = elm_box_add($win);
    evas_object_size_hint_weight_set($bx, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
    elm_win_resize_object_add($win, $bx);
    evas_object_show($bx);

    $ic = elm_icon_add($win);
    elm_icon_file_set($ic, $images{'logo_small'}, undef);
    evas_object_size_hint_aspect_set($ic, EVAS_ASPECT_CONTROL_VERTICAL, 1, 1);

    $tg = elm_toggle_add($win);
    evas_object_size_hint_weight_set($tg, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
    evas_object_size_hint_align_set($tg, EVAS_HINT_FILL, 0.5);
    elm_toggle_label_set($tg, "Icon sized to toggle");
    elm_toggle_icon_set($tg, $ic);
    elm_toggle_state_set($tg, 1);
    elm_toggle_states_labels_set($tg, "Yes", "No");
    elm_box_pack_end($bx, $tg);
    evas_object_show($tg);
    evas_object_show($ic);

    $ic = elm_icon_add($win);
    elm_icon_file_set($ic, $images{'logo_small'}, undef);
    elm_icon_scale_set($ic, 0, 0);

    $tg = elm_toggle_add($win);
    elm_toggle_label_set($tg, "Icon no scale");
    elm_toggle_icon_set($tg, $ic);
    elm_box_pack_end($bx, $tg);
    evas_object_show($tg);
    evas_object_show($ic);

    $ic = elm_icon_add($win);
    elm_icon_file_set($ic, $images{'logo_small'}, undef);
    elm_icon_scale_set($ic, 0, 0);

    $tg = elm_toggle_add($win);
    elm_toggle_label_set($tg, "Icon no scale");
    elm_toggle_icon_set($tg, $ic);
    elm_object_disabled_set($tg, 1);
    elm_box_pack_end($bx, $tg);
    evas_object_show($tg);
    evas_object_show($ic);

    $tg = elm_toggle_add($win);
    elm_toggle_label_set($tg, "Label Only");
    elm_toggle_states_labels_set($tg, "Big long fun times label", "Small long happy fun label");
    elm_box_pack_end($bx, $tg);
    evas_object_show($tg);

    $ic = elm_icon_add($win);
    elm_icon_file_set($ic, $images{'logo_small'}, undef);
    elm_icon_scale_set($ic, 0, 0);

    $tg = elm_toggle_add($win);
    elm_toggle_icon_set($tg, $ic);
    elm_box_pack_end($bx, $tg);
    evas_object_show($tg);
    evas_object_show($ic);

    evas_object_show($win);
}

sub test_table {
    my ($win, $bg, $tb, $bt);

    $win = elm_win_add(undef, "table", ELM_WIN_BASIC);
    elm_win_title_set($win, "Table");
    elm_win_autodel_set($win, 1);

    $bg = elm_bg_add($win);
    evas_object_size_hint_weight_set($bg, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
    elm_win_resize_object_add($win, $bg);
    evas_object_show($bg);

    $tb = elm_table_add($win);
    elm_win_resize_object_add($win, $tb);
    evas_object_size_hint_weight_set($tb, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
    evas_object_show($tb);

    $bt = elm_button_add($win);
    elm_button_label_set($bt, "Button 1");
    evas_object_size_hint_weight_set($bt, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
    evas_object_size_hint_align_set($bt, EVAS_HINT_FILL, EVAS_HINT_FILL);
    elm_table_pack($tb, $bt, 0, 0, 1, 1);
    evas_object_show($bt);

    $bt = elm_button_add($win);
    elm_button_label_set($bt, "Button 2");
    evas_object_size_hint_weight_set($bt, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
    evas_object_size_hint_align_set($bt, EVAS_HINT_FILL, EVAS_HINT_FILL);
    elm_table_pack($tb, $bt, 1, 0, 1, 1);
    evas_object_show($bt);

    $bt = elm_button_add($win);
    elm_button_label_set($bt, "Button 3");
    evas_object_size_hint_weight_set($bt, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
    evas_object_size_hint_align_set($bt, EVAS_HINT_FILL, EVAS_HINT_FILL);
    elm_table_pack($tb, $bt, 2, 0, 1, 1);
    evas_object_show($bt);

    $bt = elm_button_add($win);
    elm_button_label_set($bt, "Button 4");
    evas_object_size_hint_weight_set($bt, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
    evas_object_size_hint_align_set($bt, EVAS_HINT_FILL, EVAS_HINT_FILL);
    elm_table_pack($tb, $bt, 0, 1, 2, 1);
    evas_object_show($bt);

    $bt = elm_button_add($win);
    elm_button_label_set($bt, "Button 5");
    evas_object_size_hint_weight_set($bt, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
    evas_object_size_hint_align_set($bt, EVAS_HINT_FILL, EVAS_HINT_FILL);
    elm_table_pack($tb, $bt, 2, 1, 1, 3);
    evas_object_show($bt);

    $bt = elm_button_add($win);
    elm_button_label_set($bt, "Button 6");
    evas_object_size_hint_weight_set($bt, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
    evas_object_size_hint_align_set($bt, EVAS_HINT_FILL, EVAS_HINT_FILL);
    elm_table_pack($tb, $bt, 0, 2, 2, 2);
    evas_object_show($bt);

    evas_object_show($win);
}

sub test_clock {
    my ($win, $bg, $bx, $ck);

    $win = elm_win_add(undef, "clock", ELM_WIN_BASIC);
    elm_win_title_set($win, "Clock");
    elm_win_autodel_set($win, 1);

    $bg = elm_bg_add($win);
    elm_win_resize_object_add($win, $bg);
    evas_object_size_hint_weight_set($bg, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
    evas_object_show($bg);

    $bx = elm_box_add($win);
    evas_object_size_hint_weight_set($bx, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
    elm_win_resize_object_add($win, $bx);
    evas_object_show($bx);

    $ck = elm_clock_add($win);
    elm_box_pack_end($bx, $ck);
    evas_object_show($ck);

    $ck = elm_clock_add($win);
    elm_clock_show_am_pm_set($ck, 1);
    elm_box_pack_end($bx, $ck);
    evas_object_show($ck);

    $ck = elm_clock_add($win);
    elm_clock_show_seconds_set($ck, 1);
    elm_box_pack_end($bx, $ck);
    evas_object_show($ck);

    $ck = elm_clock_add($win);
    elm_clock_show_seconds_set($ck, 1);
    elm_clock_show_am_pm_set($ck, 1);
    elm_box_pack_end($bx, $ck);
    evas_object_show($ck);

    $ck = elm_clock_add($win);
    elm_clock_edit_set($ck, 1);
    elm_clock_show_seconds_set($ck, 1);
    elm_clock_show_am_pm_set($ck, 1);
    elm_clock_time_set($ck, 10, 11, 12);
    elm_box_pack_end($bx, $ck);
    evas_object_show($ck);

    evas_object_show($win);
}

sub test_layout {
    my ($win, $bg, $ly, $bt);

    $win = elm_win_add(undef, "layout", ELM_WIN_BASIC);
    elm_win_title_set($win, "Layout");
    elm_win_autodel_set($win, 1);

    $bg = elm_bg_add($win);
    elm_win_resize_object_add($win, $bg);
    evas_object_size_hint_weight_set($bg, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
    evas_object_show($bg);

    $ly = elm_layout_add($win);
    elm_layout_file_set($ly, "/home/adam/test.edj", "layout");
    evas_object_size_hint_weight_set($ly, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
    elm_win_resize_object_add($win, $ly);
    evas_object_show($ly);

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

    evas_object_show($win);
}

sub my_hover_bt {
    my ($hv) = @_;

    evas_object_show($$hv);
}

sub test_hover {
    my ($win, $bg, $bx, $bt, $hv, $ic);

    $win = elm_win_add(undef, "hover", ELM_WIN_BASIC);
    elm_win_title_set($win, "Hover");
    elm_win_autodel_set($win, 1);

    $bg = elm_bg_add($win);
    elm_win_resize_object_add($win, $bg);
    evas_object_size_hint_weight_set($bg, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
    evas_object_show($bg);

    $bx = elm_box_add($win);
    evas_object_size_hint_weight_set($bx, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
    elm_win_resize_object_add($win, $bx);
    evas_object_show($bx);

    $hv = elm_hover_add($win);

    $bt = elm_button_add($win);
    elm_button_label_set($bt, "Button");

    evas_object_smart_callback_add($bt, "clicked", \&my_hover_bt, \$hv);
    elm_box_pack_end($bx, $bt);
    evas_object_show($bt);
    elm_hover_parent_set($hv, $win);
    elm_hover_target_set($hv, $bt);

    $bt = elm_button_add($win);
    elm_button_label_set($bt, "Popup");
    elm_hover_content_set($hv, "middle", $bt);
    evas_object_show($bt);

    $bx = elm_box_add($win);

    $ic = elm_icon_add($win);
    elm_icon_file_set($ic, $images{'logo_small'}, undef);
    elm_icon_scale_set($ic, 0, 0);
    elm_box_pack_end($bx, $ic);
    evas_object_show($ic);

    $bt = elm_button_add($win);
    elm_button_label_set($bt, "Top 1");
    elm_box_pack_end($bx, $bt);
    evas_object_show($bt);
    $bt = elm_button_add($win);
    elm_button_label_set($bt, "Top 2");
    elm_box_pack_end($bx, $bt);
    evas_object_show($bt);
    $bt = elm_button_add($win);
    elm_button_label_set($bt, "Top 3");
    elm_box_pack_end($bx, $bt);
    evas_object_show($bt);

    evas_object_show($bx);
    elm_hover_content_set($hv, "top", $bx);

    $bt = elm_button_add($win);
    elm_button_label_set($bt, "Bottom");
    elm_hover_content_set($hv, "bottom", $bt);
    evas_object_show($bt);

    $bt = elm_button_add($win);
    elm_button_label_set($bt, "Left");
    elm_hover_content_set($hv, "left", $bt);
    evas_object_show($bt);

    $bt = elm_button_add($win);
    elm_button_label_set($bt, "Right");
    elm_hover_content_set($hv, "right", $bt);
    evas_object_show($bt);

    evas_object_size_hint_min_set($bg, 160, 160);
    evas_object_size_hint_max_set($bg, 640, 640);
    evas_object_resize($win, 320, 320);
    evas_object_show($win);
}

sub test_hover2 {
    my ($win, $bg, $bx, $bt, $hv, $ic);

    $win = elm_win_add(undef, "hover2", ELM_WIN_BASIC);
    elm_win_title_set($win, "Hover 2");
    elm_win_autodel_set($win, 1);

    $bg = elm_bg_add($win);
    elm_win_resize_object_add($win, $bg);
    evas_object_size_hint_weight_set($bg, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
    evas_object_show($bg);

    $bx = elm_box_add($win);
    evas_object_size_hint_weight_set($bx, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
    elm_win_resize_object_add($win, $bx);
    evas_object_show($bx);

    $hv = elm_hover_add($win);
    elm_object_style_set($hv, "popout");

    $bt = elm_button_add($win);
    elm_button_label_set($bt, "Button");

    evas_object_smart_callback_add($bt, "clicked", \&my_hover_bt, \$hv);
    elm_box_pack_end($bx, $bt);
    evas_object_show($bt);
    elm_hover_parent_set($hv, $win);
    elm_hover_target_set($hv, $bt);

    $bt = elm_button_add($win);
    elm_button_label_set($bt, "Popup");
    elm_hover_content_set($hv, "middle", $bt);
    evas_object_show($bt);

    $bx = elm_box_add($win);

    $ic = elm_icon_add($win);
    elm_icon_file_set($ic, $images{'logo_small'}, undef);
    elm_icon_scale_set($ic, 0, 0);
    elm_box_pack_end($bx, $ic);
    evas_object_show($ic);
    $bt = elm_button_add($win);
    elm_button_label_set($bt, "Top 1");
    elm_box_pack_end($bx, $bt);
    evas_object_show($bt);
    $bt = elm_button_add($win);
    elm_button_label_set($bt, "Top 2");
    elm_box_pack_end($bx, $bt);
    evas_object_show($bt);
    $bt = elm_button_add($win);
    elm_button_label_set($bt, "Top 3");
    elm_box_pack_end($bx, $bt);
    evas_object_show($bt);
    evas_object_show($bx);
    elm_hover_content_set($hv, "top", $bx);

    $bt = elm_button_add($win);
    elm_button_label_set($bt, "Bot");
    elm_hover_content_set($hv, "bottom", $bt);
    evas_object_show($bt);

    $bt = elm_button_add($win);
    elm_button_label_set($bt, "Left");
    elm_hover_content_set($hv, "left", $bt);
    evas_object_show($bt);

    $bt = elm_button_add($win);
    elm_button_label_set($bt, "Right");
    elm_hover_content_set($hv, "right", $bt);

    evas_object_size_hint_min_set($bg, 160, 160);
    evas_object_size_hint_max_set($bg, 640, 640);
    evas_object_resize($win, 320, 320);
    evas_object_show($win);
}

#TODO
sub my_entry_bt_1 {
    my ($en) = @_;
    elm_entry_entry_set($$en, "");
}

sub my_entry_bt_2 {
    my ($en) = @_;
    my $s = elm_entry_entry_get($$en);
    printf("ENTRY:\n");
    if ($s) {
        printf("%s\n", $s);
    }
}

sub my_entry_bt_3 {
    my ($en) = @_;
    my $s = elm_entry_selection_get($$en);
    printf("SELECTION:\n");
    if ($s) { printf("%s\n", $s); }
}

sub my_entry_bt_4 {
    my ($en) = @_;
    elm_entry_entry_insert($$en, "Insert some <b>BOLD</> text");
}

sub my_entry_bt_5 {
    my ($en) = @_;
    my $s = elm_entry_entry_get($$en);
    printf("PASSWORD: '%s'\n", $s ? $s : "");
}

sub anchor_test {
    my ($en) = @_;
    elm_entry_entry_insert($$en, "ANCHOR CLICKED");
}

sub test_entry {
    my ($win, $bg, $bx, $bx2, $bt, $en);

    $win = elm_win_add(undef, "entry", ELM_WIN_BASIC);
    elm_win_title_set($win, "Entry");
    elm_win_autodel_set($win, 1);

    $bg = elm_bg_add($win);
    elm_win_resize_object_add($win, $bg);
    evas_object_size_hint_weight_set($bg, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
    evas_object_show($bg);

    $bx = elm_box_add($win);
    evas_object_size_hint_weight_set($bx, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
    elm_win_resize_object_add($win, $bx);
    evas_object_show($bx);

    $en = elm_entry_add($win);
    elm_entry_line_wrap_set($en, 0);
    elm_entry_entry_set($en,
            "This is an entry widget in this window that<br>"
          . "uses markup <b>like this</> for styling and<br>"
          . "formatting <em>like this</>, as well as<br>"
          . "<a href=X><link>links in the text</></a>, so enter text<br>"
          . "in here to edit it. By the way, links are<br>"
          . "called <a href=anc-02>Anchors</a> so you will need<br>"
          . "to refer to them this way.");
    evas_object_size_hint_weight_set($en, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
    evas_object_size_hint_align_set($en, EVAS_HINT_FILL, EVAS_HINT_FILL);
    elm_box_pack_end($bx, $en);
    evas_object_show($en);

    $bx2 = elm_box_add($win);
    elm_box_horizontal_set($bx2, 1);
    evas_object_size_hint_weight_set($bx2, EVAS_HINT_EXPAND, 0.0);
    evas_object_size_hint_align_set($bx2, EVAS_HINT_FILL, EVAS_HINT_FILL);

    $bt = elm_button_add($win);
    elm_button_label_set($bt, "Clear");

    evas_object_smart_callback_add($bt, "clicked", \&my_entry_bt_1, \$en);
    evas_object_size_hint_align_set($bt, EVAS_HINT_FILL, EVAS_HINT_FILL);
    evas_object_size_hint_weight_set($bt, EVAS_HINT_EXPAND, 0.0);
    elm_box_pack_end($bx2, $bt);
    elm_object_focus_allow_set($bt, 0);
    evas_object_show($bt);

    $bt = elm_button_add($win);
    elm_button_label_set($bt, "Print");

    evas_object_smart_callback_add($bt, "clicked", \&my_entry_bt_2, \$en);
    evas_object_size_hint_align_set($bt, EVAS_HINT_FILL, EVAS_HINT_FILL);
    evas_object_size_hint_weight_set($bt, EVAS_HINT_EXPAND, 0.0);
    elm_box_pack_end($bx2, $bt);
    elm_object_focus_allow_set($bt, 0);
    evas_object_show($bt);

    $bt = elm_button_add($win);
    elm_button_label_set($bt, "Selection");

    evas_object_smart_callback_add($bt, "clicked", \&my_entry_bt_3, \$en);
    evas_object_size_hint_align_set($bt, EVAS_HINT_FILL, EVAS_HINT_FILL);
    evas_object_size_hint_weight_set($bt, EVAS_HINT_EXPAND, 0.0);
    elm_box_pack_end($bx2, $bt);
    elm_object_focus_allow_set($bt, 0);
    evas_object_show($bt);

    $bt = elm_button_add($win);
    elm_button_label_set($bt, "Insert");

    evas_object_smart_callback_add($bt, "clicked", \&my_entry_bt_4, \$en);
    evas_object_size_hint_align_set($bt, EVAS_HINT_FILL, EVAS_HINT_FILL);
    evas_object_size_hint_weight_set($bt, EVAS_HINT_EXPAND, 0.0);
    elm_box_pack_end($bx2, $bt);
    elm_object_focus_allow_set($bt, 0);
    evas_object_show($bt);

    elm_box_pack_end($bx, $bx2);
    evas_object_show($bx2);

    elm_object_focus($en);
    evas_object_show($win);
}

sub test_entry_scrolled {
    my ($win, $bg, $bx, $bx2, $bt, $en, $en_p, $sc, $sp);

    $win = elm_win_add(undef, "entry-scrolled", ELM_WIN_BASIC);
    elm_win_title_set($win, "Entry Scrolled");
    elm_win_autodel_set($win, 1);

    $bg = elm_bg_add($win);
    elm_win_resize_object_add($win, $bg);
    evas_object_size_hint_weight_set($bg, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
    evas_object_show($bg);

    $bx = elm_box_add($win);
    evas_object_size_hint_weight_set($bx, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
    elm_win_resize_object_add($win, $bx);
    evas_object_show($bx);

    $sc = elm_scroller_add($win);
    elm_scroller_content_min_limit($sc, 0, 1);
    elm_scroller_policy_set($sc, ELM_SCROLLER_POLICY_OFF, ELM_SCROLLER_POLICY_OFF);
    elm_scroller_bounce_set($sc, 0, 0);
    evas_object_size_hint_weight_set($sc, EVAS_HINT_EXPAND, 0.0);
    evas_object_size_hint_align_set($sc, EVAS_HINT_FILL, EVAS_HINT_FILL);
    elm_box_pack_end($bx, $sc);

    $en = elm_entry_add($win);
    elm_entry_single_line_set($en, 1);
    elm_entry_entry_set($en, "Disabled entry");
    evas_object_size_hint_weight_set($en, EVAS_HINT_EXPAND, 0.0);
    evas_object_size_hint_align_set($en, EVAS_HINT_FILL, 0.5);
    elm_object_disabled_set($en, 1);
    elm_scroller_content_set($sc, $en);
    evas_object_show($en);

    evas_object_show($sc);

    $sc = elm_scroller_add($win);
    elm_scroller_content_min_limit($sc, 0, 1);
    elm_scroller_policy_set($sc, ELM_SCROLLER_POLICY_OFF, ELM_SCROLLER_POLICY_OFF);
    elm_scroller_bounce_set($sc, 0, 0);
    evas_object_size_hint_weight_set($sc, EVAS_HINT_EXPAND, 0.0);
    evas_object_size_hint_align_set($sc, EVAS_HINT_FILL, EVAS_HINT_FILL);
    elm_box_pack_end($bx, $sc);

    $en = elm_entry_add($win);
    elm_entry_password_set($en, 1);
    elm_entry_entry_set($en, "Access denied, give up!");
    evas_object_size_hint_weight_set($en, EVAS_HINT_EXPAND, 0.0);
    evas_object_size_hint_align_set($en, EVAS_HINT_FILL, 0.5);
    elm_object_disabled_set($en, 1);
    elm_scroller_content_set($sc, $en);
    evas_object_show($en);

    evas_object_show($sc);

    $sc = elm_scroller_add($win);
    evas_object_size_hint_weight_set($sc, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
    evas_object_size_hint_align_set($sc, EVAS_HINT_FILL, EVAS_HINT_FILL);
    elm_scroller_policy_set($sc, ELM_SCROLLER_POLICY_ON, ELM_SCROLLER_POLICY_ON);
    elm_scroller_bounce_set($sc, 0, 1);
    elm_box_pack_end($bx, $sc);

    $en = elm_entry_add($win);
    elm_entry_context_menu_item_add($en, "Hello", undef, ELM_ICON_NONE, undef, undef);
    elm_entry_context_menu_item_add($en, "World", undef, ELM_ICON_NONE, undef, undef);
    elm_entry_entry_set($en,
            "Multi-line disabled entry widget :)<br>"
          . "We can use markup <b>like this</> for styling and<br>"
          . "formatting <em>like this</>, as well as<br>"
          . "<a href=X><link>links in the text</></a>, but it won't be editable or clickable.");
    evas_object_size_hint_weight_set($en, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
    evas_object_size_hint_align_set($en, EVAS_HINT_FILL, EVAS_HINT_FILL);
    elm_object_disabled_set($en, 1);
    elm_scroller_content_set($sc, $en);
    evas_object_show($en);

    evas_object_show($sc);

    $sp = elm_separator_add($win);
    elm_separator_horizontal_set($sp, 1);
    elm_box_pack_end($bx, $sp);
    evas_object_show($sp);

    $sc = elm_scroller_add($win);
    elm_scroller_content_min_limit($sc, 0, 1);
    elm_scroller_policy_set($sc, ELM_SCROLLER_POLICY_OFF, ELM_SCROLLER_POLICY_OFF);
    elm_scroller_bounce_set($sc, 0, 0);
    evas_object_size_hint_weight_set($sc, EVAS_HINT_EXPAND, 0.0);
    evas_object_size_hint_align_set($sc, EVAS_HINT_FILL, EVAS_HINT_FILL);
    elm_box_pack_end($bx, $sc);

    $en = elm_entry_add($win);
    elm_entry_single_line_set($en, 1);
    elm_entry_entry_set($en, "This is a single line");
    evas_object_size_hint_weight_set($en, EVAS_HINT_EXPAND, 0.0);
    evas_object_size_hint_align_set($en, EVAS_HINT_FILL, 0.5);
    elm_entry_select_all($en);
    elm_scroller_content_set($sc, $en);
    evas_object_show($en);

    evas_object_show($sc);

    $sc = elm_scroller_add($win);
    elm_scroller_content_min_limit($sc, 0, 1);
    elm_scroller_policy_set($sc, ELM_SCROLLER_POLICY_OFF, ELM_SCROLLER_POLICY_OFF);
    elm_scroller_bounce_set($sc, 0, 0);
    evas_object_size_hint_weight_set($sc, EVAS_HINT_EXPAND, 0.0);
    evas_object_size_hint_align_set($sc, EVAS_HINT_FILL, EVAS_HINT_FILL);
    elm_box_pack_end($bx, $sc);

    $en_p = elm_entry_add($win);
    elm_entry_password_set($en_p, 1);
    elm_entry_entry_set($en_p, "Password here");
    evas_object_size_hint_weight_set($en_p, EVAS_HINT_EXPAND, 0.0);
    evas_object_size_hint_align_set($en_p, EVAS_HINT_FILL, 0.0);
    elm_scroller_content_set($sc, $en_p);
    evas_object_show($en_p);

    evas_object_show($sc);

    $sc = elm_scroller_add($win);
    evas_object_size_hint_weight_set($sc, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
    evas_object_size_hint_align_set($sc, EVAS_HINT_FILL, EVAS_HINT_FILL);
    elm_scroller_policy_set($sc, ELM_SCROLLER_POLICY_ON, ELM_SCROLLER_POLICY_ON);
    elm_scroller_bounce_set($sc, 0, 1);
    elm_box_pack_end($bx, $sc);

    $en = elm_entry_add($win);
    elm_entry_entry_set($en,
            "This is an entry widget in this window that<br>"
          . "uses markup <b>like this</> for styling and<br>"
          . "formatting <em>like this</>, as well as<br>"
          . "<a href=X><link>links in the text</></a>, so enter text<br>"
          . "in here to edit it. By the way, links are<br>"
          . "called <a href=anc-02>Anchors</a> so you will need<br>"
          . "to refer to them this way. At the end here is a really long line to test line wrapping to see if it works. But just in case this line is not long enough I will add more here to really test it out, as Elementary really needs some good testing to see if entry widgets work as advertised."
    );

    evas_object_smart_callback_add($en, "anchor,clicked", \&anchor_test, \$en);
    evas_object_size_hint_weight_set($en, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
    evas_object_size_hint_align_set($en, EVAS_HINT_FILL, EVAS_HINT_FILL);
    elm_scroller_content_set($sc, $en);
    evas_object_show($en);

    evas_object_show($sc);

    $bx2 = elm_box_add($win);
    elm_box_horizontal_set($bx2, 1);
    evas_object_size_hint_weight_set($bx2, EVAS_HINT_EXPAND, 0.0);
    evas_object_size_hint_align_set($bx2, EVAS_HINT_FILL, EVAS_HINT_FILL);

    $bt = elm_button_add($win);
    elm_button_label_set($bt, "Clear");

    evas_object_smart_callback_add($bt, "clicked", \&my_entry_bt_1, \$en);
    evas_object_size_hint_align_set($bt, EVAS_HINT_FILL, EVAS_HINT_FILL);
    evas_object_size_hint_weight_set($bt, EVAS_HINT_EXPAND, 0.0);
    elm_box_pack_end($bx2, $bt);
    evas_object_show($bt);

    $bt = elm_button_add($win);
    elm_button_label_set($bt, "Print");

    evas_object_smart_callback_add($bt, "clicked", \&my_entry_bt_2, \$en);
    evas_object_size_hint_align_set($bt, EVAS_HINT_FILL, EVAS_HINT_FILL);
    evas_object_size_hint_weight_set($bt, EVAS_HINT_EXPAND, 0.0);
    elm_box_pack_end($bx2, $bt);
    evas_object_show($bt);

    $bt = elm_button_add($win);
    elm_button_label_set($bt, "Print pwd");

    evas_object_smart_callback_add($bt, "clicked", \&my_entry_bt_5, \$en_p);
    evas_object_size_hint_align_set($bt, EVAS_HINT_FILL, EVAS_HINT_FILL);
    evas_object_size_hint_weight_set($bt, EVAS_HINT_EXPAND, 0.0);
    elm_box_pack_end($bx2, $bt);
    evas_object_show($bt);

    $bt = elm_button_add($win);
    elm_button_label_set($bt, "Selection");

    evas_object_smart_callback_add($bt, "clicked", \&my_entry_bt_3, \$en);
    evas_object_size_hint_align_set($bt, EVAS_HINT_FILL, EVAS_HINT_FILL);
    evas_object_size_hint_weight_set($bt, EVAS_HINT_EXPAND, 0.0);
    elm_box_pack_end($bx2, $bt);
    evas_object_show($bt);

    $bt = elm_button_add($win);
    elm_button_label_set($bt, "Insert");

    evas_object_smart_callback_add($bt, "clicked", \&my_entry_bt_4, \$en);
    evas_object_size_hint_align_set($bt, EVAS_HINT_FILL, EVAS_HINT_FILL);
    evas_object_size_hint_weight_set($bt, EVAS_HINT_EXPAND, 0.0);
    elm_box_pack_end($bx2, $bt);
    evas_object_show($bt);

    elm_box_pack_end($bx, $bx2);
    evas_object_resize($win, 320, 300);

    elm_object_focus($win);
    evas_object_show($win);
}

sub my_notepad_bt_1 {
}

sub my_notepad_bt_2 {
}

sub my_notepad_bt_3 {
}

sub test_notepad {
    my ($win, $bg, $bx, $bx2, $bt, $ic, $np);

    $win = elm_win_add(undef, "notepad", ELM_WIN_BASIC);
    elm_win_title_set($win, "Notepad");
    elm_win_autodel_set($win, 1);

    $bg = elm_bg_add($win);
    elm_win_resize_object_add($win, $bg);
    evas_object_size_hint_weight_set($bg, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
    evas_object_show($bg);

    $bx = elm_box_add($win);
    evas_object_size_hint_weight_set($bx, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
    elm_win_resize_object_add($win, $bx);
    evas_object_show($bx);

    $np = elm_notepad_add($win);
    elm_notepad_file_set($np, "note.txt", ELM_TEXT_FORMAT_PLAIN_UTF8);
    evas_object_size_hint_weight_set($np, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
    evas_object_size_hint_align_set($np, EVAS_HINT_FILL, EVAS_HINT_FILL);
    elm_box_pack_end($bx, $np);
    evas_object_show($np);

    $bx2 = elm_box_add($win);
    elm_box_horizontal_set($bx2, 1);
    elm_box_homogenous_set($bx2, 1);
    evas_object_size_hint_weight_set($bx2, EVAS_HINT_EXPAND, 0.0);
    evas_object_size_hint_align_set($bx2, EVAS_HINT_FILL, EVAS_HINT_FILL);

    $bt = elm_button_add($win);
    $ic = elm_icon_add($win);
    elm_icon_standard_set($ic, "arrow_left");
    elm_icon_scale_set($ic, 1, 0);
    elm_button_icon_set($bt, $ic);
    evas_object_show($ic);

    evas_object_smart_callback_add($bt, "clicked", \&my_notepad_bt_1, \$np);
    evas_object_size_hint_align_set($bt, EVAS_HINT_FILL, EVAS_HINT_FILL);
    evas_object_size_hint_weight_set($bt, EVAS_HINT_EXPAND, 0.0);
    elm_box_pack_end($bx2, $bt);
    evas_object_show($bt);

    $bt = elm_button_add($win);
    $ic = elm_icon_add($win);
    elm_icon_standard_set($ic, "close");
    elm_icon_scale_set($ic, 1, 0);
    elm_button_icon_set($bt, $ic);
    evas_object_show($ic);

    evas_object_smart_callback_add($bt, "clicked", \&my_notepad_bt_2, \$np);
    evas_object_size_hint_align_set($bt, EVAS_HINT_FILL, EVAS_HINT_FILL);
    evas_object_size_hint_weight_set($bt, EVAS_HINT_EXPAND, 0.0);
    elm_box_pack_end($bx2, $bt);
    evas_object_show($bt);

    $bt = elm_button_add($win);
    $ic = elm_icon_add($win);
    elm_icon_standard_set($ic, "arrow_right");
    elm_icon_scale_set($ic, 1, 0);
    elm_button_icon_set($bt, $ic);
    evas_object_show($ic);

    evas_object_smart_callback_add($bt, "clicked", \&my_notepad_bt_3, \$np);
    evas_object_size_hint_align_set($bt, EVAS_HINT_FILL, EVAS_HINT_FILL);
    evas_object_size_hint_weight_set($bt, EVAS_HINT_EXPAND, 0.0);
    elm_box_pack_end($bx2, $bt);
    evas_object_show($bt);

    elm_box_pack_end($bx, $bx2);
    evas_object_show($bx2);

    evas_object_resize($win, 320, 300);

    elm_object_focus($win);
    evas_object_show($win);
}

sub my_anchorview_bt {

    #    Evas_Object *av = data;
    #    elm_anchorview_hover_end(av);
}

sub my_anchorview_anchor {

    #(void *data, Evas_Object *obj, void *event_info)
    #    Evas_Object *av = data;
    #    Elm_Entry_Anchorview_Info *ei = event_info;
    #    Evas_Object *bt, *bx;
    #
    #    bt = elm_button_add(obj);
    #    elm_button_label_set(bt, ei->name);
    #    elm_hover_content_set(ei->hover, "middle", bt);
    #    evas_object_show(bt);
    #
    #    // hints as to where we probably should put hover contents (buttons etc.).
    #    if (ei->hover_top)
    #      {
    # 	bx = elm_box_add(obj);
    # 	bt = elm_button_add(obj);
    # 	elm_button_label_set(bt, "Top 1");
    # 	elm_box_pack_end(bx, bt);
    # 	evas_object_smart_callback_add(bt, "clicked", my_anchorview_bt, av);
    # 	evas_object_show(bt);
    # 	bt = elm_button_add(obj);
    # 	elm_button_label_set(bt, "Top 2");
    # 	elm_box_pack_end(bx, bt);
    # 	evas_object_smart_callback_add(bt, "clicked", my_anchorview_bt, av);
    # 	evas_object_show(bt);
    # 	bt = elm_button_add(obj);
    # 	elm_button_label_set(bt, "Top 3");
    # 	elm_box_pack_end(bx, bt);
    # 	evas_object_smart_callback_add(bt, "clicked", my_anchorview_bt, av);
    # 	evas_object_show(bt);
    # 	elm_hover_content_set(ei->hover, "top", bx);
    # 	evas_object_show(bx);
    #      }
    #    if (ei->hover_bottom)
    #      {
    # 	bt = elm_button_add(obj);
    # 	elm_button_label_set(bt, "Bot");
    # 	elm_hover_content_set(ei->hover, "bottom", bt);
    # 	evas_object_smart_callback_add(bt, "clicked", my_anchorview_bt, av);
    # 	evas_object_show(bt);
    #      }
    #    if (ei->hover_left)
    #      {
    # 	bt = elm_button_add(obj);
    # 	elm_button_label_set(bt, "Left");
    # 	elm_hover_content_set(ei->hover, "left", bt);
    # 	evas_object_smart_callback_add(bt, "clicked", my_anchorview_bt, av);
    # 	evas_object_show(bt);
    #      }
    #    if (ei->hover_right)
    #      {
    # 	bt = elm_button_add(obj);
    # 	elm_button_label_set(bt, "Right");
    # 	elm_hover_content_set(ei->hover, "right", bt);
    # 	evas_object_smart_callback_add(bt, "clicked", my_anchorview_bt, av);
    # 	evas_object_show(bt);
    #      }
}

sub test_anchorview {
    my ($win, $bg, $av);

    $win = elm_win_add(undef, "anchorview", ELM_WIN_BASIC);
    elm_win_title_set($win, "Anchorview");
    elm_win_autodel_set($win, 1);

    $bg = elm_bg_add($win);
    elm_win_resize_object_add($win, $bg);
    evas_object_size_hint_weight_set($bg, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
    evas_object_show($bg);

    $av = elm_anchorview_add($win);
    elm_anchorview_hover_style_set($av, "popout");
    elm_anchorview_hover_parent_set($av, $win);
    elm_anchorview_text_set($av,
            "This is an entry widget in this window that<br>"
          . "uses markup <b>like this</> for styling and<br>"
          . "formatting <em>like this</>, as well as<br>"
          . "<a href=X><link>links in the text</></a>, so enter text<br>"
          . "in here to edit it. By the way, links are<br>"
          . "called <a href=anc-02>Anchors</a> so you will need<br>"
          . "to refer to them this way.");
    evas_object_size_hint_weight_set($av, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);

    evas_object_smart_callback_add($av, "anchor,clicked", \&my_anchorview_anchor, $av);
    elm_win_resize_object_add($win, $av);
    evas_object_show($av);

    evas_object_resize($win, 320, 300);

    elm_object_focus($win);
    evas_object_show($win);
}

sub my_anchorblock_bt {

    #    Evas_Object *av = data;
    #    elm_anchorblock_hover_end(av);
}

sub my_anchorblock_anchor {

    #    Evas_Object *av = data;
    #    Elm_Entry_Anchorblock_Info *ei = event_info;
    #    Evas_Object *bt, *bx;
    #
    #    bt = elm_button_add(obj);
    #    elm_button_label_set(bt, ei->name);
    #    elm_hover_content_set(ei->hover, "middle", bt);
    #    evas_object_show(bt);
    #
    #    // hints as to where we probably should put hover contents (buttons etc.).
    #    if (ei->hover_top)
    #      {
    # 	bx = elm_box_add(obj);
    # 	bt = elm_button_add(obj);
    # 	elm_button_label_set(bt, "Top 1");
    # 	elm_box_pack_end(bx, bt);
    # 	evas_object_smart_callback_add(bt, "clicked", my_anchorblock_bt, av);
    # 	evas_object_show(bt);
    # 	bt = elm_button_add(obj);
    # 	elm_button_label_set(bt, "Top 2");
    # 	elm_box_pack_end(bx, bt);
    # 	evas_object_smart_callback_add(bt, "clicked", my_anchorblock_bt, av);
    # 	evas_object_show(bt);
    # 	bt = elm_button_add(obj);
    # 	elm_button_label_set(bt, "Top 3");
    # 	elm_box_pack_end(bx, bt);
    # 	evas_object_smart_callback_add(bt, "clicked", my_anchorblock_bt, av);
    # 	evas_object_show(bt);
    # 	elm_hover_content_set(ei->hover, "top", bx);
    # 	evas_object_show(bx);
    #      }
    #    if (ei->hover_bottom)
    #      {
    # 	bt = elm_button_add(obj);
    # 	elm_button_label_set(bt, "Bot");
    # 	elm_hover_content_set(ei->hover, "bottom", bt);
    # 	evas_object_smart_callback_add(bt, "clicked", my_anchorblock_bt, av);
    # 	evas_object_show(bt);
    #      }
    #    if (ei->hover_left)
    #      {
    # 	bt = elm_button_add(obj);
    # 	elm_button_label_set(bt, "Left");
    # 	elm_hover_content_set(ei->hover, "left", bt);
    # 	evas_object_smart_callback_add(bt, "clicked", my_anchorblock_bt, av);
    # 	evas_object_show(bt);
    #      }
    #    if (ei->hover_right)
    #      {
    # 	bt = elm_button_add(obj);
    # 	elm_button_label_set(bt, "Right");
    # 	elm_hover_content_set(ei->hover, "right", bt);
    # 	evas_object_smart_callback_add(bt, "clicked", my_anchorblock_bt, av);
    # 	evas_object_show(bt);
    #      }
}

sub my_anchorblock_edge_left {
    printf("left\n");
}

sub my_anchorblock_edge_right {
    printf("right\n");
}

sub my_anchorblock_edge_top {
    printf("top\n");
}

sub my_anchorblock_edge_bottom {
    printf("bottom\n");
}

sub my_anchorblock_scroll {

    #    Evas_Coord x, y, w, h, vw, vh;
    #
    #    elm_scroller_region_get(obj, &x, &y, &w, &h);
    #    elm_scroller_child_size_get(obj, &vw, &vh);
    #    printf("scroll %ix%i +%i+%i in %ix%i\n", w, h, x, y, vw, vh);
}

sub test_anchorblock {
    my ($win, $bg, $av, $sc, $bx, $bb, $ic);

    $win = elm_win_add(undef, "anchorblock", ELM_WIN_BASIC);
    elm_win_title_set($win, "Anchorblock");
    elm_win_autodel_set($win, 1);

    $bg = elm_bg_add($win);
    elm_win_resize_object_add($win, $bg);
    evas_object_size_hint_weight_set($bg, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
    evas_object_show($bg);

    $sc = elm_scroller_add($win);
    evas_object_size_hint_weight_set($sc, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
    elm_win_resize_object_add($win, $sc);

    evas_object_smart_callback_add($sc, "edge_left",   \&my_anchorblock_edge_left,   undef);
    evas_object_smart_callback_add($sc, "edge_right",  \&my_anchorblock_edge_right,  undef);
    evas_object_smart_callback_add($sc, "edge_top",    \&my_anchorblock_edge_top,    undef);
    evas_object_smart_callback_add($sc, "edge_bottom", \&my_anchorblock_edge_bottom, undef);
    evas_object_smart_callback_add($sc, "scroll",      \&my_anchorblock_scroll,      undef);

    $bx = elm_box_add($win);
    evas_object_size_hint_weight_set($bx, EVAS_HINT_EXPAND, 0.0);
    evas_object_size_hint_align_set($bx, EVAS_HINT_FILL, EVAS_HINT_FILL);

    $ic = elm_icon_add($win);
    elm_icon_file_set($ic, $images{'logo_small'}, undef);
    elm_icon_scale_set($ic, 0, 0);
    evas_object_size_hint_aspect_set($ic, EVAS_ASPECT_CONTROL_VERTICAL, 1, 1);

    $bb = elm_bubble_add($win);
    elm_bubble_label_set($bb, "Message 3");
    elm_bubble_info_set($bb, "10:32 4/11/2008");
    elm_bubble_icon_set($bb, $ic);
    evas_object_show($ic);
    evas_object_size_hint_weight_set($bb, EVAS_HINT_EXPAND, 0.0);
    evas_object_size_hint_align_set($bb, EVAS_HINT_FILL, EVAS_HINT_FILL);
    $av = elm_anchorblock_add($win);
    elm_anchorblock_hover_style_set($av, "popout");
    elm_anchorblock_hover_parent_set($av, $win);
    elm_anchorblock_text_set($av, "Hi there. This is the most recent message in the " . "list of messages. It has one <a href=tel:+614321234>+61 432 1234</a> " . "(phone number) to click on.");

    evas_object_smart_callback_add($av, "anchor,clicked", \&my_anchorblock_anchor, $av);
    elm_bubble_content_set($bb, $av);
    evas_object_show($av);
    elm_box_pack_end($bx, $bb);
    evas_object_show($bb);

    $ic = elm_icon_add($win);
    elm_icon_file_set($ic, $images{'logo_small'}, undef);
    evas_object_size_hint_aspect_set($ic, EVAS_ASPECT_CONTROL_VERTICAL, 1, 1);

    $bb = elm_bubble_add($win);
    elm_bubble_label_set($bb, "Message 2");
    elm_bubble_info_set($bb, "7:16 27/10/2008");
    elm_bubble_icon_set($bb, $ic);
    evas_object_show($ic);
    evas_object_size_hint_weight_set($bb, EVAS_HINT_EXPAND, 0.0);
    evas_object_size_hint_align_set($bb, EVAS_HINT_FILL, EVAS_HINT_FILL);
    $av = elm_anchorblock_add($win);
    elm_anchorblock_hover_style_set($av, "popout");
    elm_anchorblock_hover_parent_set($av, $win);
    elm_anchorblock_text_set($av,
            "Hey what are you doing? This is the second last message "
          . "Hi there. This is the most recent message in the "
          . "list. It's a longer one so it can wrap more and "
          . "contains a <a href=contact:john>John</a> contact "
          . "link in it to test popups on links. The idea is that "
          . "all SMS's are scanned for things that look like phone "
          . "numbers or names that are in your contacts list, and "
          . "if they are, they become clickable links that pop up "
          . "a menus of obvious actions to perform on this piece "
          . "of information. This of course can be later explicitly "
          . "done by links maybe running local apps or even being "
          . "web URL's too that launch the web browser and point it "
          . "to that URL.");

    evas_object_smart_callback_add($av, "anchor,clicked", \&my_anchorblock_anchor, $av);
    elm_bubble_content_set($bb, $av);
    evas_object_show($av);
    elm_box_pack_end($bx, $bb);
    evas_object_show($bb);

    $ic = elm_icon_add($win);
    elm_icon_file_set($ic, $images{'logo_small'}, undef);
    elm_icon_scale_set($ic, 0, 0);
    evas_object_size_hint_aspect_set($ic, EVAS_ASPECT_CONTROL_VERTICAL, 1, 1);

    $bb = elm_bubble_add($win);
    elm_bubble_label_set($bb, "Message 1");
    elm_bubble_info_set($bb, "20:47 18/6/2008");
    elm_bubble_icon_set($bb, $ic);
    evas_object_show($ic);
    evas_object_size_hint_weight_set($bb, EVAS_HINT_EXPAND, 0.0);
    evas_object_size_hint_align_set($bb, EVAS_HINT_FILL, EVAS_HINT_FILL);

    $av = elm_anchorblock_add($win);
    elm_anchorblock_hover_style_set($av, "popout");
    elm_anchorblock_hover_parent_set($av, $win);
    elm_anchorblock_text_set($av, "This is a short message");

    evas_object_smart_callback_add($av, "anchor,clicked", \&my_anchorblock_anchor, $av);
    elm_bubble_content_set($bb, $av);
    evas_object_show($av);
    elm_box_pack_end($bx, $bb);
    evas_object_show($bb);

    elm_scroller_content_set($sc, $bx);
    evas_object_show($bx);

    evas_object_show($sc);

    evas_object_resize($win, 320, 300);

    elm_object_focus($win);
    evas_object_show($win);
}

sub tb_1 {
    my ($data) = @_;
    elm_photo_file_set($$data, $images{'panel'});
}

sub tb_2 {
    my ($data) = @_;
    elm_photo_file_set($$data, $images{'rock'});
}

sub tb_3 {
    my ($data) = @_;
    elm_photo_file_set($$data, $images{'wood'});
}

sub tb_4 {
    my ($data) = @_;
    elm_photo_file_set($$data, $images{'sky'});
}

sub tb_5 {
    my ($data) = @_;
    elm_photo_file_set($$data, undef);
}

sub test_toolbar {
    my ($win, $bg, $bx, $tb, $ic, $ph, $menu);
    my ($ph1, $ph2, $ph3, $ph4);

    my $item;
    my $menu_item;

    $win = elm_win_add(undef, "toolbar", ELM_WIN_BASIC);
    elm_win_title_set($win, "Toolbar");
    elm_win_autodel_set($win, 1);

    $bg = elm_bg_add($win);
    elm_win_resize_object_add($win, $bg);
    evas_object_size_hint_weight_set($bg, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
    evas_object_show($bg);

    $bx = elm_box_add($win);
    elm_win_resize_object_add($win, $bx);
    evas_object_size_hint_weight_set($bx, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
    evas_object_show($bx);

    $tb = elm_toolbar_add($win);
    elm_toolbar_homogenous_set($tb, 0);
    evas_object_size_hint_weight_set($tb, 0.0, 0.0);
    evas_object_size_hint_align_set($tb, EVAS_HINT_FILL, 0.0);

    $ph1 = elm_photo_add($win);
    $ph2 = elm_photo_add($win);
    $ph3 = elm_photo_add($win);
    $ph4 = elm_photo_add($win);

    $ic = elm_icon_add($win);
    elm_icon_file_set($ic, $images{'logo_small'}, undef);

    $item = elm_toolbar_item_add($tb, $ic, "Hello", \&tb_1, \$ph1);
    elm_toolbar_item_disabled_set($item, EINA_TRUE);

    $ic = elm_icon_add($win);
    elm_icon_file_set($ic, $images{'logo_small'}, undef);
    elm_toolbar_item_add($tb, $ic, "World", \&tb_2, \$ph1);

    $ic = elm_icon_add($win);
    elm_icon_file_set($ic, $images{'logo_small'}, undef);
    elm_toolbar_item_add($tb, $ic, "H", \&tb_3, \$ph4);

    $ic = elm_icon_add($win);
    elm_icon_file_set($ic, $images{'logo_small'}, undef);
    elm_toolbar_item_add($tb, $ic, "Comes", \&tb_4, \$ph4);

    $ic = elm_icon_add($win);
    elm_icon_file_set($ic, $images{'logo_small'}, undef);
    elm_toolbar_item_add($tb, $ic, "Elementary", \&tb_5, \$ph4);

    $ic = elm_icon_add($win);
    elm_icon_file_set($ic, $images{'logo_small'}, undef);
    $item = elm_toolbar_item_add($tb, $ic, "Menu", undef, undef);
    elm_toolbar_item_menu_set($item, 1);
    elm_toolbar_menu_parent_set($tb, $win);
    $menu = elm_toolbar_item_menu_get($item);

    $ic = elm_icon_add($win);
    elm_icon_file_set($ic, $images{'logo_small'}, undef);
    elm_menu_item_add($menu, undef, $ic, "Here", \&tb_3, \$ph4);

    $ic = elm_icon_add($win);
    elm_icon_file_set($ic, $images{'logo_small'}, undef);
    $menu_item = elm_menu_item_add($menu, undef, $ic, "Comes", \&tb_4, \$ph4);

    $ic = elm_icon_add($win);
    elm_icon_file_set($ic, $images{'logo_small'}, undef);
    elm_menu_item_add($menu, $menu_item, $ic, "hey ho", \&tb_4, \$ph4);

    $ic = elm_icon_add($win);
    elm_icon_file_set($ic, $images{'logo_small'}, undef);
    $menu_item = elm_menu_item_add($menu, undef, $ic, "Elementary", \&tb_5, \$ph4);

    elm_box_pack_end($bx, $tb);
    evas_object_show($tb);

    $tb = elm_table_add($win);

    #elm_table_homogenous_set($tb, 1);
    evas_object_size_hint_weight_set($tb, 0.0, EVAS_HINT_EXPAND);
    evas_object_size_hint_fill_set($tb, EVAS_HINT_FILL, EVAS_HINT_FILL);

    $ph = $ph1;
    elm_photo_size_set($ph, 40);
    elm_photo_file_set($ph, $images{'plant'});
    evas_object_size_hint_weight_set($ph, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
    evas_object_size_hint_align_set($ph, 0.5, 0.5);
    elm_table_pack($tb, $ph, 0, 0, 1, 1);
    evas_object_show($ph);

    $ph = $ph2;
    elm_photo_size_set($ph, 80);
    evas_object_size_hint_weight_set($ph, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
    evas_object_size_hint_align_set($ph, 0.5, 0.5);
    elm_table_pack($tb, $ph, 1, 0, 1, 1);
    evas_object_show($ph);

    $ph = $ph3;
    elm_photo_size_set($ph, 20);
    elm_photo_file_set($ph, $images{'sky'});
    evas_object_size_hint_weight_set($ph, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
    evas_object_size_hint_align_set($ph, 0.5, 0.5);
    elm_table_pack($tb, $ph, 0, 1, 1, 1);
    evas_object_show($ph);

    $ph = $ph4;
    elm_photo_size_set($ph, 60);
    elm_photo_file_set($ph, $images{'sky2'});
    evas_object_size_hint_weight_set($ph, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
    evas_object_size_hint_align_set($ph, 0.5, 0.5);
    elm_table_pack($tb, $ph, 1, 1, 1, 1);
    evas_object_show($ph);

    elm_box_pack_end($bx, $tb);
    evas_object_show($tb);

    evas_object_resize($win, 320, 300);

    evas_object_show($win);
}

sub test_hoversel {
    my ($win, $bg, $bx, $bt, $ic);

    $win = elm_win_add(undef, "hoversel", ELM_WIN_BASIC);
    elm_win_title_set($win, "Hoversel");
    elm_win_autodel_set($win, 1);

    $bg = elm_bg_add($win);
    elm_win_resize_object_add($win, $bg);
    evas_object_size_hint_weight_set($bg, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
    evas_object_show($bg);

    $bx = elm_box_add($win);
    elm_win_resize_object_add($win, $bx);
    evas_object_size_hint_weight_set($bx, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
    evas_object_show($bx);

    $bt = elm_hoversel_add($win);
    elm_hoversel_hover_parent_set($bt, $win);
    elm_hoversel_label_set($bt, "Labels");
    elm_hoversel_item_add($bt, "Item 1",                   undef, ELM_ICON_NONE, undef, undef);
    elm_hoversel_item_add($bt, "Item 2",                   undef, ELM_ICON_NONE, undef, undef);
    elm_hoversel_item_add($bt, "Item 3",                   undef, ELM_ICON_NONE, undef, undef);
    elm_hoversel_item_add($bt, "Item 4 - Long Label Here", undef, ELM_ICON_NONE, undef, undef);
    evas_object_size_hint_weight_set($bt, 0.0, 0.0);
    evas_object_size_hint_align_set($bt, 0.5, 0.5);
    elm_box_pack_end($bx, $bt);
    evas_object_show($bt);

    $bt = elm_hoversel_add($win);
    elm_hoversel_hover_parent_set($bt, $win);
    elm_hoversel_label_set($bt, "Some Icons");
    elm_hoversel_item_add($bt, "Item 1", undef,   ELM_ICON_NONE,     undef, undef);
    elm_hoversel_item_add($bt, "Item 2", undef,   ELM_ICON_NONE,     undef, undef);
    elm_hoversel_item_add($bt, "Item 3", "home",  ELM_ICON_STANDARD, undef, undef);
    elm_hoversel_item_add($bt, "Item 4", "close", ELM_ICON_STANDARD, undef, undef);
    evas_object_size_hint_weight_set($bt, 0.0, 0.0);
    evas_object_size_hint_align_set($bt, 0.5, 0.5);
    elm_box_pack_end($bx, $bt);
    evas_object_show($bt);

    $bt = elm_hoversel_add($win);
    elm_hoversel_hover_parent_set($bt, $win);
    elm_hoversel_label_set($bt, "All Icons");
    elm_hoversel_item_add($bt, "Item 1", "apps",       ELM_ICON_STANDARD, undef, undef);
    elm_hoversel_item_add($bt, "Item 2", "arrow_down", ELM_ICON_STANDARD, undef, undef);
    elm_hoversel_item_add($bt, "Item 3", "home",       ELM_ICON_STANDARD, undef, undef);
    elm_hoversel_item_add($bt, "Item 4", "close",      ELM_ICON_STANDARD, undef, undef);
    evas_object_size_hint_weight_set($bt, 0.0, 0.0);
    evas_object_size_hint_align_set($bt, 0.5, 0.5);
    elm_box_pack_end($bx, $bt);
    evas_object_show($bt);

    $bt = elm_hoversel_add($win);
    elm_hoversel_hover_parent_set($bt, $win);
    elm_hoversel_label_set($bt, "All Icons");
    elm_hoversel_item_add($bt, "Item 1", "apps",         ELM_ICON_STANDARD, undef, undef);
    elm_hoversel_item_add($bt, "Item 2", $images{'sky'}, ELM_ICON_FILE,     undef, undef);
    elm_hoversel_item_add($bt, "Item 3", "home",         ELM_ICON_STANDARD, undef, undef);
    elm_hoversel_item_add($bt, "Item 4", "close",        ELM_ICON_STANDARD, undef, undef);
    evas_object_size_hint_weight_set($bt, 0.0, 0.0);
    evas_object_size_hint_align_set($bt, 0.5, 0.5);
    elm_box_pack_end($bx, $bt);
    evas_object_show($bt);

    $bt = elm_hoversel_add($win);
    elm_hoversel_hover_parent_set($bt, $win);
    elm_hoversel_label_set($bt, "Disabled Hoversel");
    elm_hoversel_item_add($bt, "Item 1", "apps",  ELM_ICON_STANDARD, undef, undef);
    elm_hoversel_item_add($bt, "Item 2", "close", ELM_ICON_STANDARD, undef, undef);
    elm_object_disabled_set($bt, 1);
    evas_object_size_hint_weight_set($bt, 0.0, 0.0);
    evas_object_size_hint_align_set($bt, 0.5, 0.5);
    elm_box_pack_end($bx, $bt);
    evas_object_show($bt);

    $bt = elm_hoversel_add($win);
    elm_hoversel_hover_parent_set($bt, $win);
    elm_hoversel_label_set($bt, "Icon + Label");

    $ic = elm_icon_add($win);
    elm_icon_file_set($ic, $images{'sky'}, undef);
    elm_hoversel_icon_set($bt, $ic);
    evas_object_show($ic);

    elm_hoversel_item_add($bt, "Item 1", "apps",       ELM_ICON_STANDARD, undef, undef);
    elm_hoversel_item_add($bt, "Item 2", "arrow_down", ELM_ICON_STANDARD, undef, undef);
    elm_hoversel_item_add($bt, "Item 3", "home",       ELM_ICON_STANDARD, undef, undef);
    elm_hoversel_item_add($bt, "Item 4", "close",      ELM_ICON_STANDARD, undef, undef);
    evas_object_size_hint_weight_set($bt, 0.0, 0.0);
    evas_object_size_hint_align_set($bt, 0.5, 0.5);
    elm_box_pack_end($bx, $bt);
    evas_object_show($bt);

    evas_object_resize($win, 320, 300);

    evas_object_show($win);
}

sub my_show_it {
    my ($data) = @_;
    elm_list_item_show($$data);
}

sub test_list {
    my ($win, $bg, $li, $ic, $ic2, $bx, $tb2, $bt);
    my ($it1, $it2, $it3, $it4, $it5);

    $win = elm_win_add(undef, "list", ELM_WIN_BASIC);
    elm_win_title_set($win, "List");
    elm_win_autodel_set($win, 1);

    $bg = elm_bg_add($win);
    elm_win_resize_object_add($win, $bg);
    evas_object_size_hint_weight_set($bg, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
    evas_object_show($bg);

    $li = elm_list_add($win);
    elm_win_resize_object_add($win, $li);
    evas_object_size_hint_weight_set($li, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);

    $ic = elm_icon_add($win);
    elm_icon_file_set($ic, $images{'logo_small'}, undef);
    elm_icon_scale_set($ic, 1, 1);
    $it1 = elm_list_item_append($li, "Hello", $ic, undef, undef, undef);
    $ic = elm_icon_add($win);
    elm_icon_scale_set($ic, 0, 0);
    elm_icon_file_set($ic, $images{'logo_small'}, undef);
    elm_list_item_append($li, "world", $ic, undef, undef, undef);
    $ic = elm_icon_add($win);
    elm_icon_standard_set($ic, "edit");
    elm_icon_scale_set($ic, 0, 0);
    elm_list_item_append($li, ".", $ic, undef, undef, undef);

    $ic = elm_icon_add($win);
    elm_icon_standard_set($ic, "delete");
    elm_icon_scale_set($ic, 0, 0);
    $ic2 = elm_icon_add($win);
    elm_icon_standard_set($ic2, "clock");
    elm_icon_scale_set($ic2, 0, 0);
    $it2 = elm_list_item_append($li, "How", $ic, $ic2, undef, undef);

    $bx = elm_box_add($win);
    elm_box_horizontal_set($bx, 1);

    $ic = elm_icon_add($win);
    elm_icon_file_set($ic, $images{'logo_small'}, undef);
    elm_icon_scale_set($ic, 0, 0);
    evas_object_size_hint_align_set($ic, 0.5, 0.5);
    elm_box_pack_end($bx, $ic);
    evas_object_show($ic);

    $ic = elm_icon_add($win);
    elm_icon_file_set($ic, $images{'logo_small'}, undef);
    elm_icon_scale_set($ic, 0, 0);
    evas_object_size_hint_align_set($ic, 0.5, 0.0);
    elm_box_pack_end($bx, $ic);
    evas_object_show($ic);

    $ic = elm_icon_add($win);
    elm_icon_file_set($ic, $images{'logo_small'}, undef);
    elm_icon_scale_set($ic, 0, 0);
    evas_object_size_hint_align_set($ic, 0.0, EVAS_HINT_EXPAND);
    elm_box_pack_end($bx, $ic);
    evas_object_show($ic);
    elm_list_item_append($li, "are", $bx, undef, undef, undef);

    elm_list_item_append($li, "you", undef, undef, undef, undef);
    $it3 = elm_list_item_append($li, "doing", undef, undef, undef, undef);
    elm_list_item_append($li, "out",   undef, undef, undef, undef);
    elm_list_item_append($li, "there", undef, undef, undef, undef);
    elm_list_item_append($li, "today", undef, undef, undef, undef);
    elm_list_item_append($li, "?",     undef, undef, undef, undef);
    $it4 = elm_list_item_append($li, "Here", undef, undef, undef, undef);
    elm_list_item_append($li, "are",                        undef, undef, undef, undef);
    elm_list_item_append($li, "some",                       undef, undef, undef, undef);
    elm_list_item_append($li, "more",                       undef, undef, undef, undef);
    elm_list_item_append($li, "items",                      undef, undef, undef, undef);
    elm_list_item_append($li, "Is this label long enough?", undef, undef, undef, undef);
    $it5 = elm_list_item_append($li, "Maybe this one is even longer so we can test long long items.", undef, undef, undef, undef);

    elm_list_go($li);

    evas_object_show($li);

    $tb2 = elm_table_add($win);
    evas_object_size_hint_weight_set($tb2, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
    elm_win_resize_object_add($win, $tb2);

    $bt = elm_button_add($win);
    elm_button_label_set($bt, "Hello");
    evas_object_smart_callback_add($bt, "clicked", \&my_show_it, \$it1);
    evas_object_size_hint_weight_set($bt, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
    evas_object_size_hint_align_set($bt, 0.9, 0.5);
    elm_table_pack($tb2, $bt, 0, 0, 1, 1);
    evas_object_show($bt);

    $bt = elm_button_add($win);
    elm_button_label_set($bt, "How");
    evas_object_smart_callback_add($bt, "clicked", \&my_show_it, \$it2);
    evas_object_size_hint_weight_set($bt, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
    evas_object_size_hint_align_set($bt, 0.9, 0.5);
    elm_table_pack($tb2, $bt, 0, 1, 1, 1);
    evas_object_show($bt);

    $bt = elm_button_add($win);
    elm_button_label_set($bt, "doing");
    evas_object_smart_callback_add($bt, "clicked", \&my_show_it, \$it3);
    evas_object_size_hint_weight_set($bt, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
    evas_object_size_hint_align_set($bt, 0.9, 0.5);
    elm_table_pack($tb2, $bt, 0, 2, 1, 1);
    evas_object_show($bt);

    $bt = elm_button_add($win);
    elm_button_label_set($bt, "Here");
    evas_object_smart_callback_add($bt, "clicked", \&my_show_it, \$it4);
    evas_object_size_hint_weight_set($bt, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
    evas_object_size_hint_align_set($bt, 0.9, 0.5);
    elm_table_pack($tb2, $bt, 0, 3, 1, 1);
    evas_object_show($bt);

    $bt = elm_button_add($win);
    elm_button_label_set($bt, "Maybe this...");
    evas_object_smart_callback_add($bt, "clicked", \&my_show_it, \$it5);
    evas_object_size_hint_weight_set($bt, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
    evas_object_size_hint_align_set($bt, 0.9, 0.5);
    elm_table_pack($tb2, $bt, 0, 4, 1, 1);
    evas_object_show($bt);

    evas_object_show($tb2);

    evas_object_resize($win, 320, 300);
    evas_object_show($win);
}

sub my_li2_clear {
    my ($data) = @_;
    elm_list_clear($$data);
}

sub my_li2_sel {

    #Elm_List_Item *it = elm_list_selected_item_get(obj);
    #elm_list_item_selected_set(it, 0);
    #   elm_list_item_selected_set(event_info, 0);
}

sub test_list2 {
    my ($win, $bg, $li, $ic, $ic2, $bx, $bx2, $bt);
    my $it;

    $win = elm_win_add(undef, "list-2", ELM_WIN_BASIC);
    elm_win_title_set($win, "List 2");
    elm_win_autodel_set($win, 1);

    $bg = elm_bg_add($win);
    elm_bg_file_set($bg, $images{'plant'}, undef);
    elm_win_resize_object_add($win, $bg);
    evas_object_size_hint_weight_set($bg, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
    evas_object_show($bg);

    $bx = elm_box_add($win);
    evas_object_size_hint_weight_set($bx, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
    elm_win_resize_object_add($win, $bx);
    evas_object_show($bx);

    $li = elm_list_add($win);
    evas_object_size_hint_align_set($li, EVAS_HINT_FILL, EVAS_HINT_FILL);
    evas_object_size_hint_weight_set($li, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
    elm_list_horizontal_mode_set($li, ELM_LIST_LIMIT);

    #   elm_list_multi_select_set($li, 1);

    $ic = elm_icon_add($win);
    elm_icon_file_set($ic, $images{'logo_small'}, undef);
    $it = elm_list_item_append($li, "Hello", $ic, undef, \&my_li2_sel, undef);
    elm_list_item_selected_set($it, 1);
    $ic = elm_icon_add($win);
    elm_icon_scale_set($ic, 0, 0);
    elm_icon_file_set($ic, $images{'logo_small'}, undef);
    elm_list_item_append($li, "world", $ic, undef, undef, undef);
    $ic = elm_icon_add($win);
    elm_icon_standard_set($ic, "edit");
    elm_icon_scale_set($ic, 0, 0);
    elm_list_item_append($li, ".", $ic, undef, undef, undef);

    $ic = elm_icon_add($win);
    elm_icon_standard_set($ic, "delete");
    elm_icon_scale_set($ic, 0, 0);
    $ic2 = elm_icon_add($win);
    elm_icon_standard_set($ic2, "clock");
    elm_icon_scale_set($ic2, 0, 0);
    elm_list_item_append($li, "How", $ic, $ic2, undef, undef);

    $bx2 = elm_box_add($win);
    elm_box_horizontal_set($bx2, 1);

    $ic = elm_icon_add($win);
    elm_icon_file_set($ic, $images{'logo_small'}, undef);
    elm_icon_scale_set($ic, 0, 0);
    evas_object_size_hint_align_set($ic, 0.5, 0.5);
    elm_box_pack_end($bx2, $ic);
    evas_object_show($ic);

    $ic = elm_icon_add($win);
    elm_icon_file_set($ic, $images{'logo_small'}, undef);
    elm_icon_scale_set($ic, 0, 0);
    evas_object_size_hint_align_set($ic, 0.5, 0.0);
    elm_box_pack_end($bx2, $ic);
    evas_object_show($ic);
    elm_list_item_append($li, "are", $bx2, undef, undef, undef);

    elm_list_item_append($li, "you",           undef, undef, undef, undef);
    elm_list_item_append($li, "doing",         undef, undef, undef, undef);
    elm_list_item_append($li, "out",           undef, undef, undef, undef);
    elm_list_item_append($li, "there",         undef, undef, undef, undef);
    elm_list_item_append($li, "today",         undef, undef, undef, undef);
    elm_list_item_append($li, "?",             undef, undef, undef, undef);
    elm_list_item_append($li, "Here",          undef, undef, undef, undef);
    elm_list_item_append($li, "are",           undef, undef, undef, undef);
    elm_list_item_append($li, "some",          undef, undef, undef, undef);
    elm_list_item_append($li, "more",          undef, undef, undef, undef);
    elm_list_item_append($li, "items",         undef, undef, undef, undef);
    elm_list_item_append($li, "Longer label.", undef, undef, undef, undef);

    elm_list_go($li);

    elm_box_pack_end($bx, $li);
    evas_object_show($li);

    $bx2 = elm_box_add($win);
    elm_box_horizontal_set($bx2, 1);
    elm_box_homogenous_set($bx2, 1);
    evas_object_size_hint_weight_set($bx2, EVAS_HINT_EXPAND, 0.0);
    evas_object_size_hint_align_set($bx2, EVAS_HINT_FILL, EVAS_HINT_FILL);

    $bt = elm_button_add($win);
    elm_button_label_set($bt, "Clear");
    evas_object_smart_callback_add($bt, "clicked", \&my_li2_clear, \$li);
    evas_object_size_hint_align_set($bt, EVAS_HINT_FILL, EVAS_HINT_FILL);
    evas_object_size_hint_weight_set($bt, EVAS_HINT_EXPAND, 0.0);
    elm_box_pack_end($bx2, $bt);
    evas_object_show($bt);

    elm_box_pack_end($bx, $bx2);
    evas_object_show($bx2);

    evas_object_resize($win, 320, 300);
    evas_object_show($win);
}

sub test_list3 {
    my ($win, $bg, $li, $ic, $ic2, $bx);

    $win = elm_win_add(undef, "list-3", ELM_WIN_BASIC);
    elm_win_title_set($win, "List 3");
    elm_win_autodel_set($win, 1);

    $bg = elm_bg_add($win);
    elm_win_resize_object_add($win, $bg);
    evas_object_size_hint_weight_set($bg, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
    evas_object_show($bg);

    $li = elm_list_add($win);
    elm_win_resize_object_add($win, $li);
    evas_object_size_hint_weight_set($li, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
    elm_list_horizontal_mode_set($li, ELM_LIST_COMPRESS);

    $ic = elm_icon_add($win);
    elm_icon_file_set($ic, $images{'logo_small'}, undef);
    elm_list_item_append($li, "Hello", $ic, undef, undef, undef);
    $ic = elm_icon_add($win);
    elm_icon_scale_set($ic, 0, 0);
    elm_icon_file_set($ic, $images{'logo_small'}, undef);
    elm_list_item_append($li, "world", $ic, undef, undef, undef);
    $ic = elm_icon_add($win);
    elm_icon_standard_set($ic, "edit");
    elm_icon_scale_set($ic, 0, 0);
    elm_list_item_append($li, ".", $ic, undef, undef, undef);

    $ic = elm_icon_add($win);
    elm_icon_standard_set($ic, "delete");
    elm_icon_scale_set($ic, 0, 0);
    $ic2 = elm_icon_add($win);
    elm_icon_standard_set($ic2, "clock");
    elm_icon_scale_set($ic2, 0, 0);
    elm_list_item_append($li, "How", $ic, $ic2, undef, undef);

    $bx = elm_box_add($win);
    elm_box_horizontal_set($bx, 1);

    $ic = elm_icon_add($win);
    elm_icon_file_set($ic, $images{'logo_small'}, undef);
    elm_icon_scale_set($ic, 0, 0);
    evas_object_size_hint_align_set($ic, 0.5, 0.5);
    elm_box_pack_end($bx, $ic);
    evas_object_show($ic);

    $ic = elm_icon_add($win);
    elm_icon_file_set($ic, $images{'logo_small'}, undef);
    elm_icon_scale_set($ic, 0, 0);
    evas_object_size_hint_align_set($ic, 0.5, 0.0);
    elm_box_pack_end($bx, $ic);
    evas_object_show($ic);

    $ic = elm_icon_add($win);
    elm_icon_file_set($ic, $images{'logo_small'}, undef);
    elm_icon_scale_set($ic, 0, 0);
    evas_object_size_hint_align_set($ic, 0.0, EVAS_HINT_EXPAND);
    elm_box_pack_end($bx, $ic);
    evas_object_show($ic);

    elm_list_item_append($li, "are",                                                           $bx,   undef, undef, undef);
    elm_list_item_append($li, "you",                                                           undef, undef, undef, undef);
    elm_list_item_append($li, "doing",                                                         undef, undef, undef, undef);
    elm_list_item_append($li, "out",                                                           undef, undef, undef, undef);
    elm_list_item_append($li, "there",                                                         undef, undef, undef, undef);
    elm_list_item_append($li, "today",                                                         undef, undef, undef, undef);
    elm_list_item_append($li, "?",                                                             undef, undef, undef, undef);
    elm_list_item_append($li, "Here",                                                          undef, undef, undef, undef);
    elm_list_item_append($li, "are",                                                           undef, undef, undef, undef);
    elm_list_item_append($li, "some",                                                          undef, undef, undef, undef);
    elm_list_item_append($li, "more",                                                          undef, undef, undef, undef);
    elm_list_item_append($li, "items",                                                         undef, undef, undef, undef);
    elm_list_item_append($li, "Is this label long enough?",                                    undef, undef, undef, undef);
    elm_list_item_append($li, "Maybe this one is even longer so we can test long long items.", undef, undef, undef, undef);

    elm_list_go($li);

    evas_object_show($li);

    evas_object_resize($win, 320, 300);
    evas_object_show($win);
}

sub test_carousel {
    my ($win, $bg);

    $win = elm_win_add(undef, "carousel", ELM_WIN_BASIC);
    elm_win_title_set($win, "Carousel");
    elm_win_autodel_set($win, 1);

    $bg = elm_bg_add($win);
    elm_win_resize_object_add($win, $bg);
    evas_object_size_hint_weight_set($bg, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
    evas_object_show($bg);

    evas_object_resize($win, 320, 240);
    evas_object_show($win);
}

sub test_inwin {
    my ($win, $bg, $inwin, $lb);

    $win = elm_win_add(undef, "inwin", ELM_WIN_BASIC);
    elm_win_title_set($win, "Inwin");
    elm_win_autodel_set($win, 1);

    $bg = elm_bg_add($win);
    elm_win_resize_object_add($win, $bg);
    evas_object_size_hint_weight_set($bg, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
    evas_object_show($bg);

    $inwin = elm_win_inwin_add($win);
    evas_object_show($inwin);

    $lb = elm_label_add($win);
    elm_label_label_set($lb,
            "This is an \"inwin\" - a window in a<br>"
          . "window. This is handy for quick popups<br>"
          . "you want centered, taking over the window<br>"
          . "until dismissed somehow. Unlike hovers they<br>"
          . "don't hover over their target.");
    elm_win_inwin_content_set($inwin, $lb);
    evas_object_show($lb);

    evas_object_resize($win, 320, 240);
    evas_object_show($win);
}

sub test_inwin2 {
    my ($win, $bg, $inwin, $lb);

    $win = elm_win_add(undef, "inwin", ELM_WIN_BASIC);
    elm_win_title_set($win, "Inwin");
    elm_win_autodel_set($win, 1);

    $bg = elm_bg_add($win);
    elm_win_resize_object_add($win, $bg);
    evas_object_size_hint_weight_set($bg, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
    evas_object_show($bg);

    $inwin = elm_win_inwin_add($win);
    elm_object_style_set($inwin, "minimal_vertical");
    evas_object_show($inwin);

    $lb = elm_label_add($win);
    elm_label_label_set($lb,
            "This is an \"inwin\" - a window in a<br>"
          . "window. This is handy for quick popups<br>"
          . "you want centered, taking over the window<br>"
          . "until dismissed somehow. Unlike hovers they<br>"
          . "don't hover over their target.<br>" . "<br>"
          . "This inwin style compacts itself vertically<br>"
          . "to the size of its contents minimum size.");
    elm_win_inwin_content_set($inwin, $lb);
    evas_object_show($lb);

    evas_object_resize($win, 320, 240);
    evas_object_show($win);
}

sub test_scaling {
    my ($win, $bg, $bx, $bt);

    $win = elm_win_add(undef, "scaling", ELM_WIN_BASIC);
    elm_win_title_set($win, "Scaling");
    elm_win_autodel_set($win, 1);

    $bg = elm_bg_add($win);
    elm_win_resize_object_add($win, $bg);
    evas_object_size_hint_weight_set($bg, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
    evas_object_show($bg);

    $bx = elm_box_add($win);
    evas_object_size_hint_weight_set($bx, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
    elm_win_resize_object_add($win, $bx);
    evas_object_show($bx);

    $bt = elm_button_add($win);
    elm_button_label_set($bt, "Scale: 0.5");
    elm_object_scale_set($bt, 0.5);
    elm_box_pack_end($bx, $bt);
    evas_object_show($bt);

    $bt = elm_button_add($win);
    elm_button_label_set($bt, "Scale: 0.75");
    elm_object_scale_set($bt, 0.75);
    elm_box_pack_end($bx, $bt);
    evas_object_show($bt);

    $bt = elm_button_add($win);
    elm_button_label_set($bt, "Scale: 1.0");
    elm_object_scale_set($bt, 1.0);
    elm_box_pack_end($bx, $bt);
    evas_object_show($bt);

    $bt = elm_button_add($win);
    elm_button_label_set($bt, "Scale: 1.5");
    elm_object_scale_set($bt, 1.5);
    elm_box_pack_end($bx, $bt);
    evas_object_show($bt);

    $bt = elm_button_add($win);
    elm_button_label_set($bt, "Scale: 2.0");
    elm_object_scale_set($bt, 2.0);
    elm_box_pack_end($bx, $bt);
    evas_object_show($bt);

    $bt = elm_button_add($win);
    elm_button_label_set($bt, "Scale: 3.0");
    elm_object_scale_set($bt, 3.0);
    elm_box_pack_end($bx, $bt);
    evas_object_show($bt);

    evas_object_resize($win, 320, 320);
    evas_object_show($win);
}

sub test_scaling2 {
    my ($win, $bg, $bx, $fr, $lb);

    $win = elm_win_add(undef, "scaling-2", ELM_WIN_BASIC);
    elm_win_title_set($win, "Scaling 2");
    elm_win_autodel_set($win, 1);

    $bg = elm_bg_add($win);
    elm_win_resize_object_add($win, $bg);
    evas_object_size_hint_weight_set($bg, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
    evas_object_show($bg);

    $bx = elm_box_add($win);
    evas_object_size_hint_weight_set($bx, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
    elm_win_resize_object_add($win, $bx);
    evas_object_show($bx);

    $fr = elm_frame_add($win);
    elm_object_scale_set($fr, 0.5);
    elm_frame_label_set($fr, "Scale: 0.5");
    $lb = elm_label_add($win);
    elm_label_label_set($lb, "Parent frame scale<br>" . "is 0.5. Child should<br>" . "inherit it.");
    elm_frame_content_set($fr, $lb);
    evas_object_show($lb);
    elm_box_pack_end($bx, $fr);
    evas_object_show($fr);

    $fr = elm_frame_add($win);
    elm_frame_label_set($fr, "Scale: 1.0");
    $lb = elm_label_add($win);
    elm_label_label_set($lb, "Parent frame scale<br>" . "is 1.0. Child should<br>" . "inherit it.");
    elm_frame_content_set($fr, $lb);
    evas_object_show($lb);
    elm_object_scale_set($fr, 1.0);
    elm_box_pack_end($bx, $fr);
    evas_object_show($fr);

    $fr = elm_frame_add($win);
    elm_frame_label_set($fr, "Scale: 2.0");
    $lb = elm_label_add($win);
    elm_label_label_set($lb, "Parent frame scale<br>" . "is 2.0. Child should<br>" . "inherit it.");
    elm_frame_content_set($fr, $lb);
    evas_object_show($lb);
    elm_object_scale_set($fr, 2.0);
    elm_box_pack_end($bx, $fr);
    evas_object_show($fr);

    evas_object_resize($win, 320, 320);
    evas_object_show($win);
}

sub test_slider {
    my ($win, $bg, $bx, $sl, $ic);

    $win = elm_win_add(undef, "slider", ELM_WIN_BASIC);
    elm_win_title_set($win, "Slider");
    elm_win_autodel_set($win, 1);

    $bg = elm_bg_add($win);
    elm_win_resize_object_add($win, $bg);
    evas_object_size_hint_weight_set($bg, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
    evas_object_show($bg);

    $bx = elm_box_add($win);
    evas_object_size_hint_weight_set($bx, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
    elm_win_resize_object_add($win, $bx);
    evas_object_show($bx);

    $ic = elm_icon_add($win);
    elm_icon_file_set($ic, $images{'logo_small'}, undef);
    evas_object_size_hint_aspect_set($ic, EVAS_ASPECT_CONTROL_VERTICAL, 1, 1);

    $sl = elm_slider_add($win);
    elm_slider_label_set($sl, "Label");
    elm_slider_icon_set($sl, $ic);
    elm_slider_unit_format_set($sl, "%1.1f units");
    elm_slider_span_size_set($sl, 120);
    evas_object_size_hint_align_set($sl, EVAS_HINT_FILL, 0.5);
    evas_object_size_hint_weight_set($sl, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
    elm_box_pack_end($bx, $sl);
    evas_object_show($ic);
    evas_object_show($sl);

    $sl = elm_slider_add($win);
    elm_slider_label_set($sl, "Label 2");
    elm_slider_span_size_set($sl, 80);
    evas_object_size_hint_align_set($sl, EVAS_HINT_FILL, 0.5);
    evas_object_size_hint_weight_set($sl, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
    elm_slider_indicator_format_set($sl, "%3.0f");
    elm_slider_min_max_set($sl, 50, 150);
    elm_slider_value_set($sl, 80);
    elm_slider_inverted_set($sl, 1);
    evas_object_size_hint_align_set($sl, 0.5, 0.5);
    evas_object_size_hint_weight_set($sl, 0.0, 0.0);
    elm_box_pack_end($bx, $sl);
    evas_object_show($ic);
    evas_object_show($sl);

    $sl = elm_slider_add($win);
    elm_slider_label_set($sl, "Label 3");
    elm_slider_unit_format_set($sl, "units");
    elm_slider_span_size_set($sl, 40);
    evas_object_size_hint_align_set($sl, EVAS_HINT_FILL, 0.5);
    evas_object_size_hint_weight_set($sl, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
    elm_slider_indicator_format_set($sl, "%3.0f");
    elm_slider_min_max_set($sl, 50, 150);
    elm_slider_value_set($sl, 80);
    elm_slider_inverted_set($sl, 1);
    elm_object_scale_set($sl, 2.0);
    elm_box_pack_end($bx, $sl);
    evas_object_show($ic);
    evas_object_show($sl);

    $ic = elm_icon_add($win);
    elm_icon_file_set($ic, $images{'small_logo'}, undef);
    evas_object_size_hint_aspect_set($ic, EVAS_ASPECT_CONTROL_HORIZONTAL, 1, 1);

    $sl = elm_slider_add($win);
    elm_slider_icon_set($sl, $ic);
    elm_slider_label_set($sl, "Label 4");
    elm_slider_unit_format_set($sl, "units");
    elm_slider_span_size_set($sl, 60);
    evas_object_size_hint_align_set($sl, 0.5, EVAS_HINT_FILL);
    evas_object_size_hint_weight_set($sl, 0.0, EVAS_HINT_EXPAND);
    elm_slider_indicator_format_set($sl, "%1.1f");
    elm_slider_value_set($sl, 0.2);
    elm_object_scale_set($sl, 1.0);
    elm_slider_horizontal_set($sl, 0);
    elm_box_pack_end($bx, $sl);
    evas_object_show($ic);
    evas_object_show($sl);

    evas_object_show($win);
}

=pod

typedef struct _Testitem
{
   Elm_Genlist_Item *item;
   int mode;
   int onoff;
} Testitem;


static Elm_Genlist_Item_Class itc1;
char *gl_label_get(const void *data, Evas_Object *obj, const char *part)
{
   char buf[256];
   snprintf(buf, sizeof(buf), "Item # %i", (int)data);
   return strdup(buf);
}

Evas_Object *gl_icon_get(const void *data, Evas_Object *obj, const char *part)
{
   char buf[PATH_MAX];
   Evas_Object *ic = elm_icon_add(obj);
   snprintf(buf, sizeof(buf), "%s/images/logo_small.png", PACKAGE_DATA_DIR);
   elm_icon_file_set(ic, buf, NULL);
   evas_object_size_hint_aspect_set(ic, EVAS_ASPECT_CONTROL_VERTICAL, 1, 1);
   return ic;
}
Eina_Bool gl_state_get(const void *data, Evas_Object *obj, const char *part)
{
   return EINA_FALSE;
}
void gl_del(const void *data, Evas_Object *obj)
{
}

static void
gl_sel(void *data, Evas_Object *obj, void *event_info)
{
   printf("sel item data [%p] on genlist obj [%p], item pointer [%p]\n", data, obj, event_info);
}

=cut

sub _move {
    my ($gl, $obj, $ev) = @_;

    #   Evas_Event_Mouse_Move *ev = event_info;
    my $where = 0;

    #   Elm_Genlist_Item *gli;
    #   gli = elm_genlist_at_xy_item_get(gl, ev->cur.canvas.x, ev->cur.canvas.y, &where);
    #   if (gli)
    #     printf("over %p, where %i\n", elm_genlist_item_data_get(gli), where);
    #   else
    #     printf("over none, where %i\n", where);
}

sub _bt50_cb {
    my ($data) = @_;
    elm_genlist_item_bring_in($$data);
}

sub _bt1500_cb {
    my ($data) = @_;
    elm_genlist_item_middle_bring_in($$data);
}

sub test_genlist {
    my ($win, $bg, $gl, $bt_50, $bt_1500, $bx);
    my $over;
    my $gli;
    my $i;

    $win = elm_win_add(undef, "genlist", ELM_WIN_BASIC);
    elm_win_title_set($win, "Genlist");
    elm_win_autodel_set($win, 1);

    $bg = elm_bg_add($win);
    elm_win_resize_object_add($win, $bg);
    evas_object_size_hint_weight_set($bg, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
    evas_object_show($bg);


    $bx = elm_box_add($win);
    evas_object_size_hint_weight_set($bx, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
    elm_win_resize_object_add($win, $bx);
    evas_object_show($bx);

    $gl = elm_genlist_add($win);

    # FIXME: This causes genlist to resize the horiz axis very slowly :(
    # Reenable this and resize the window horizontally, then try to resize it back
    #elm_genlist_horizontal_mode_set(gl, ELM_LIST_LIMIT);
    evas_object_size_hint_weight_set($gl, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
    evas_object_size_hint_align_set($gl, EVAS_HINT_FILL, EVAS_HINT_FILL);
    elm_box_pack_end($bx, $gl);
    evas_object_show($gl);

    $over = evas_object_rectangle_add(evas_object_evas_get($win));
    evas_object_color_set($over, 0, 0, 0, 0);
    evas_object_event_callback_add($over, EVAS_CALLBACK_MOUSE_MOVE, \&_move, \$gl);
    evas_object_repeat_events_set($over, 1);
    evas_object_show($over);
    evas_object_size_hint_weight_set($over, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
    elm_win_resize_object_add($win, $over);

    #itc1.item_style     = "default";
    #itc1.func.label_get = gl_label_get;
    #itc1.func.icon_get  = gl_icon_get;
    #itc1.func.state_get = gl_state_get;
    #itc1.func.del       = gl_del;

    $bt_50 = elm_button_add($win);
    elm_button_label_set($bt_50, "Go to 50");
    evas_object_show($bt_50);
    elm_box_pack_end($bx, $bt_50);

    $bt_1500 = elm_button_add($win);
    elm_button_label_set($bt_1500, "Go to 1500");
    evas_object_show($bt_1500);
    elm_box_pack_end($bx, $bt_1500);

    for ($i = 0; $i < 2000; $i++) {

        #         gli = elm_genlist_item_append(gl, &itc1,
        my $j = $i * 10;
        $gli = elm_genlist_item_append($gl, undef, $i, undef, ELM_GENLIST_ITEM_NONE, \&gl_sel, \($i * 10));

        if ($i == 50) {
            evas_object_smart_callback_add($bt_50, "clicked", \&_bt50_cb, \$gli);
        }
        elsif ($i == 1500) {
            evas_object_smart_callback_add($bt_1500, "clicked", \&_bt1500_cb, \$gli);
        }
    }

    evas_object_resize($win, 480, 800);
    evas_object_show($win);

}

=pod

/*************/

static void
my_gl_clear(void *data, Evas_Object *obj, void *event_info)
{
   Evas_Object *gl = data;
   elm_genlist_clear(gl);
}

static void
my_gl_add(void *data, Evas_Object *obj, void *event_info)
{
   Evas_Object *gl = data;
   Elm_Genlist_Item *gli;
   static int i = 0;

   itc1.item_style     = "default";
   itc1.func.label_get = gl_label_get;
   itc1.func.icon_get  = gl_icon_get;
   itc1.func.state_get = gl_state_get;
   itc1.func.del       = gl_del;

   gli = elm_genlist_item_append(gl, &itc1,
				 (void *)i/* item data */,
				 undef/* parent */,
				 ELM_GENLIST_ITEM_NONE,
				 gl_sel/* func */,
				 (void *)(i * 10)/* func data */);
   i++;
}

static void
my_gl_insert_before(void *data, Evas_Object *obj, void *event_info)
{
   Evas_Object *gl = data;
   Elm_Genlist_Item *gli;
   static int i = 0;
   Elm_Genlist_Item *gli_selected;

   itc1.item_style     = "default";
   itc1.func.label_get = gl_label_get;
   itc1.func.icon_get  = gl_icon_get;
   itc1.func.state_get = gl_state_get;
   itc1.func.del       = gl_del;

   gli_selected = elm_genlist_selected_item_get(gl);
   if(!gli_selected)
   {
       printf("no item selected\n");
       return ;
   }

   gli = elm_genlist_item_insert_before(gl, &itc1,
				 (void *)i/* item data */,
				 gli_selected /* item before */,
				 ELM_GENLIST_ITEM_NONE,
				 gl_sel/* func */,
				 (void *)(i * 10)/* func data */);
   i++;
}

static void
my_gl_insert_after(void *data, Evas_Object *obj, void *event_info)
{
   Evas_Object *gl = data;
   Elm_Genlist_Item *gli;
   static int i = 0;
   Elm_Genlist_Item *gli_selected;

   itc1.item_style     = "default";
   itc1.func.label_get = gl_label_get;
   itc1.func.icon_get  = gl_icon_get;
   itc1.func.state_get = gl_state_get;
   itc1.func.del       = gl_del;

   gli_selected = elm_genlist_selected_item_get(gl);
   if(!gli_selected)
   {
       printf("no item selected\n");
       return ;
   }

   gli = elm_genlist_item_insert_after(gl, &itc1,
				 (void *)i/* item data */,
				 gli_selected /* item after */,
				 ELM_GENLIST_ITEM_NONE,
				 gl_sel/* func */,
				 (void *)(i * 10)/* func data */);
   i++;
}

static void
my_gl_del(void *data, Evas_Object *obj, void *event_info)
{
   Evas_Object *gl = data;
   Elm_Genlist_Item *gli = elm_genlist_selected_item_get(gl);
   if (!gli)
     {
	printf("no item selected\n");
	return;
     }
   elm_genlist_item_del(gli);
}

static void
my_gl_disable(void *data, Evas_Object *obj, void *event_info)
{
   Evas_Object *gl = data;
   Elm_Genlist_Item *gli = elm_genlist_selected_item_get(gl);
   if (!gli)
     {
	printf("no item selected\n");
	return;
     }
   elm_genlist_item_disabled_set(gli, 1);
   elm_genlist_item_selected_set(gli, 0);
   elm_genlist_item_update(gli);
}

static void
my_gl_update_all(void *data, Evas_Object *obj, void *event_info)
{
   Evas_Object *gl = data;
   int i = 0;
   Elm_Genlist_Item *it = elm_genlist_first_item_get(gl);
   while (it)
     {
	elm_genlist_item_update(it);
	printf("%i\n", i);
	i++;
	it = elm_genlist_item_next_get(it);
     }
}

static void
my_gl_first(void *data, Evas_Object *obj, void *event_info)
{
   Evas_Object *gl = data;
   Elm_Genlist_Item *gli = elm_genlist_first_item_get(gl);
   if (!gli) return;
   elm_genlist_item_show(gli);
   elm_genlist_item_selected_set(gli, 1);
}

static void
my_gl_last(void *data, Evas_Object *obj, void *event_info)
{
   Evas_Object *gl = data;
   Elm_Genlist_Item *gli = elm_genlist_last_item_get(gl);
   if (!gli) return;
   elm_genlist_item_show(gli);
   elm_genlist_item_selected_set(gli, 1);
}

void
test_genlist2(void *data, Evas_Object *obj, void *event_info)
{
   Evas_Object *win, *bg, *gl, *bx, *bx2, *bx3, *bt;
   Elm_Genlist_Item *gli[10];
   char buf[PATH_MAX];
   int i;

   win = elm_win_add(undef, "genlist-2", ELM_WIN_BASIC);
   elm_win_title_set(win, "Genlist 2");
   elm_win_autodel_set(win, 1);

   bg = elm_bg_add(win);
   snprintf(buf, sizeof(buf), "%s/images/plant_01.jpg", PACKAGE_DATA_DIR);
   elm_bg_file_set(bg, buf, undef);
   elm_win_resize_object_add(win, bg);
   evas_object_size_hint_weight_set(bg, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
   evas_object_show(bg);

   bx = elm_box_add(win);
   evas_object_size_hint_weight_set(bx, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
   elm_win_resize_object_add(win, bx);
   evas_object_show(bx);

   gl = elm_genlist_add(win);
   evas_object_size_hint_align_set(gl, EVAS_HINT_FILL, EVAS_HINT_FILL);
   evas_object_size_hint_weight_set(gl, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
   evas_object_show(gl);

   itc1.item_style     = "default";
   itc1.func.label_get = gl_label_get;
   itc1.func.icon_get  = gl_icon_get;
   itc1.func.state_get = gl_state_get;
   itc1.func.del       = gl_del;

   gli[0] = elm_genlist_item_append(gl, &itc1,
				    (void *)1001/* item data */, undef/* parent */, ELM_GENLIST_ITEM_NONE, gl_sel/* func */,
				    (void *)1001/* func data */);
   gli[1] = elm_genlist_item_append(gl, &itc1,
				    (void *)1002/* item data */, undef/* parent */, ELM_GENLIST_ITEM_NONE, gl_sel/* func */,
				    (void *)1002/* func data */);
   gli[2] = elm_genlist_item_append(gl, &itc1,
				    (void *)1003/* item data */, undef/* parent */, ELM_GENLIST_ITEM_NONE, gl_sel/* func */,
				    (void *)1003/* func data */);
   gli[3] = elm_genlist_item_prepend(gl, &itc1,
				     (void *)1004/* item data */, undef/* parent */, ELM_GENLIST_ITEM_NONE, gl_sel/* func */,
				     (void *)1004/* func data */);
   gli[4] = elm_genlist_item_prepend(gl, &itc1,
				     (void *)1005/* item data */, undef/* parent */, ELM_GENLIST_ITEM_NONE, gl_sel/* func */,
				     (void *)1005/* func data */);
   gli[5] = elm_genlist_item_insert_before(gl, &itc1,
					   (void *)1006/* item data */, gli[2]/* rel */, ELM_GENLIST_ITEM_NONE, gl_sel/* func */,
					   (void *)1006/* func data */);
   gli[6] = elm_genlist_item_insert_after(gl, &itc1,
					  (void *)1007/* item data */, gli[2]/* rel */, ELM_GENLIST_ITEM_NONE, gl_sel/* func */,
					  (void *)1007/* func data */);

   elm_box_pack_end(bx, gl);

   bx2 = elm_box_add(win);
   elm_box_horizontal_set(bx2, 1);
   elm_box_homogenous_set(bx2, 1);
   evas_object_size_hint_weight_set(bx2, EVAS_HINT_EXPAND, 0.0);
   evas_object_size_hint_align_set(bx2, EVAS_HINT_FILL, EVAS_HINT_FILL);

   bt = elm_button_add(win);
   elm_button_label_set(bt, "/\\");
   evas_object_smart_callback_add(bt, "clicked", my_gl_first, gl);
   evas_object_size_hint_align_set(bt, EVAS_HINT_FILL, EVAS_HINT_FILL);
   evas_object_size_hint_weight_set(bt, EVAS_HINT_EXPAND, 0.0);
   elm_box_pack_end(bx2, bt);
   evas_object_show(bt);

   bt = elm_button_add(win);
   elm_button_label_set(bt, "\\/");
   evas_object_smart_callback_add(bt, "clicked", my_gl_last, gl);
   evas_object_size_hint_align_set(bt, EVAS_HINT_FILL, EVAS_HINT_FILL);
   evas_object_size_hint_weight_set(bt, EVAS_HINT_EXPAND, 0.0);
   elm_box_pack_end(bx2, bt);
   evas_object_show(bt);

   bt = elm_button_add(win);
   elm_button_label_set(bt, "#");
   evas_object_smart_callback_add(bt, "clicked", my_gl_disable, gl);
   evas_object_size_hint_align_set(bt, EVAS_HINT_FILL, EVAS_HINT_FILL);
   evas_object_size_hint_weight_set(bt, EVAS_HINT_EXPAND, 0.0);
   elm_box_pack_end(bx2, bt);
   evas_object_show(bt);

   bt = elm_button_add(win);
   elm_button_label_set(bt, "U");
   evas_object_smart_callback_add(bt, "clicked", my_gl_update_all, gl);
   evas_object_size_hint_align_set(bt, EVAS_HINT_FILL, EVAS_HINT_FILL);
   evas_object_size_hint_weight_set(bt, EVAS_HINT_EXPAND, 0.0);
   elm_box_pack_end(bx2, bt);
   evas_object_show(bt);

   elm_box_pack_end(bx, bx2);
   evas_object_show(bx2);

   bx2 = elm_box_add(win);
   elm_box_horizontal_set(bx2, 1);
   elm_box_homogenous_set(bx2, 1);
   evas_object_size_hint_weight_set(bx2, EVAS_HINT_EXPAND, 0.0);
   evas_object_size_hint_align_set(bx2, EVAS_HINT_FILL, EVAS_HINT_FILL);

   bt = elm_button_add(win);
   elm_button_label_set(bt, "X");
   evas_object_smart_callback_add(bt, "clicked", my_gl_clear, gl);
   evas_object_size_hint_align_set(bt, EVAS_HINT_FILL, EVAS_HINT_FILL);
   evas_object_size_hint_weight_set(bt, EVAS_HINT_EXPAND, 0.0);
   elm_box_pack_end(bx2, bt);
   evas_object_show(bt);

   bt = elm_button_add(win);
   elm_button_label_set(bt, "+");
   evas_object_smart_callback_add(bt, "clicked", my_gl_add, gl);
   evas_object_size_hint_align_set(bt, EVAS_HINT_FILL, EVAS_HINT_FILL);
   evas_object_size_hint_weight_set(bt, EVAS_HINT_EXPAND, 0.0);
   elm_box_pack_end(bx2, bt);
   evas_object_show(bt);

   bt = elm_button_add(win);
   elm_button_label_set(bt, "-");
   evas_object_smart_callback_add(bt, "clicked", my_gl_del, gl);
   evas_object_size_hint_align_set(bt, EVAS_HINT_FILL, EVAS_HINT_FILL);
   evas_object_size_hint_weight_set(bt, EVAS_HINT_EXPAND, 0.0);
   elm_box_pack_end(bx2, bt);
   evas_object_show(bt);

   elm_box_pack_end(bx, bx2);
   evas_object_show(bx2);

   bx3 = elm_box_add(win);
   elm_box_horizontal_set(bx3, 1);
   elm_box_homogenous_set(bx3, 1);
   evas_object_size_hint_weight_set(bx3, EVAS_HINT_EXPAND, 0.0);
   evas_object_size_hint_align_set(bx3, EVAS_HINT_FILL, EVAS_HINT_FILL);

   bt = elm_button_add(win);
   elm_button_label_set(bt, "+ before");
   evas_object_smart_callback_add(bt, "clicked", my_gl_insert_before, gl);
   evas_object_size_hint_align_set(bt, EVAS_HINT_FILL, EVAS_HINT_FILL);
   evas_object_size_hint_weight_set(bt, EVAS_HINT_EXPAND, 0.0);
   elm_box_pack_end(bx3, bt);
   evas_object_show(bt);

   bt = elm_button_add(win);
   elm_button_label_set(bt, "+ after");
   evas_object_smart_callback_add(bt, "clicked", my_gl_insert_after, gl);
   evas_object_size_hint_align_set(bt, EVAS_HINT_FILL, EVAS_HINT_FILL);
   evas_object_size_hint_weight_set(bt, EVAS_HINT_EXPAND, 0.0);
   elm_box_pack_end(bx3, bt);
   evas_object_show(bt);

   elm_box_pack_end(bx, bx3);
   evas_object_show(bx3);


   evas_object_resize(win, 320, 320);
   evas_object_show(win);
}

/*************/

static Elm_Genlist_Item_Class itc2;
char *gl2_label_get(const void *data, Evas_Object *obj, const char *part)
{
   const Testitem *tit = data;
   char buf[256];
   snprintf(buf, sizeof(buf), "Item mode %i", tit->mode);
   return strdup(buf);
}
Evas_Object *gl2_icon_get(const void *data, Evas_Object *obj, const char *part)
{
   const Testitem *tit = data;
   char buf[PATH_MAX];
   Evas_Object *ic = elm_icon_add(obj);
   if (!strcmp(part, "elm.swallow.icon"))
     {
	if ((tit->mode & 0x3) == 0)
	  snprintf(buf, sizeof(buf), "%s/images/logo_small.png", PACKAGE_DATA_DIR);
	else if ((tit->mode & 0x3) == 1)
	  snprintf(buf, sizeof(buf), "%s/images/logo.png", PACKAGE_DATA_DIR);
	else if ((tit->mode & 0x3) == 2)
	  snprintf(buf, sizeof(buf), "%s/images/panel_01.jpg", PACKAGE_DATA_DIR);
	else if ((tit->mode & 0x3) == 3)
	  snprintf(buf, sizeof(buf), "%s/images/rock_01.jpg", PACKAGE_DATA_DIR);
	elm_icon_file_set(ic, buf, undef);
     }
   else if (!strcmp(part, "elm.swallow.end"))
     {
	if ((tit->mode & 0x3) == 0)
	  snprintf(buf, sizeof(buf), "%s/images/sky_01.jpg", PACKAGE_DATA_DIR);
	else if ((tit->mode & 0x3) == 1)
	  snprintf(buf, sizeof(buf), "%s/images/sky_02.jpg", PACKAGE_DATA_DIR);
	else if ((tit->mode & 0x3) == 2)
	  snprintf(buf, sizeof(buf), "%s/images/sky_03.jpg", PACKAGE_DATA_DIR);
	else if ((tit->mode & 0x3) == 3)
	  snprintf(buf, sizeof(buf), "%s/images/sky_04.jpg", PACKAGE_DATA_DIR);
	elm_icon_file_set(ic, buf, undef);
     }
   evas_object_size_hint_aspect_set(ic, EVAS_ASPECT_CONTROL_VERTICAL, 1, 1);
   return ic;
}
Eina_Bool gl2_state_get(const void *data, Evas_Object *obj, const char *part)
{
   return EINA_FALSE;
}
void gl2_del(const void *data, Evas_Object *obj)
{
}

static void
my_gl_update(void *data, Evas_Object *obj, void *event_info)
{
   Testitem *tit = data;
   tit->mode++;
   elm_genlist_item_update(tit->item);
}

void
test_genlist3(void *data, Evas_Object *obj, void *event_info)
{
   Evas_Object *win, *bg, *gl, *bx, *bx2, *bt;
   static Testitem tit[3];
   int i;

   win = elm_win_add(undef, "genlist-3", ELM_WIN_BASIC);
   elm_win_title_set(win, "Genlist 3");
   elm_win_autodel_set(win, 1);

   bg = elm_bg_add(win);
   elm_win_resize_object_add(win, bg);
   evas_object_size_hint_weight_set(bg, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
   evas_object_show(bg);

   bx = elm_box_add(win);
   evas_object_size_hint_weight_set(bx, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
   elm_win_resize_object_add(win, bx);
   evas_object_show(bx);

   gl = elm_genlist_add(win);
   evas_object_size_hint_align_set(gl, EVAS_HINT_FILL, EVAS_HINT_FILL);
   evas_object_size_hint_weight_set(gl, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
   evas_object_show(gl);

   itc2.item_style     = "default";
   itc2.func.label_get = gl2_label_get;
   itc2.func.icon_get  = gl2_icon_get;
   itc2.func.state_get = gl2_state_get;
   itc2.func.del       = gl2_del;

   tit[0].mode = 0;
   tit[0].item = elm_genlist_item_append(gl, &itc2,
					 &(tit[0])/* item data */, undef/* parent */, ELM_GENLIST_ITEM_NONE, gl_sel/* func */,
					 undef/* func data */);
   tit[1].mode = 1;
   tit[1].item = elm_genlist_item_append(gl, &itc2,
					 &(tit[1])/* item data */, undef/* parent */, ELM_GENLIST_ITEM_NONE, gl_sel/* func */,
					 undef/* func data */);
   tit[2].mode = 2;
   tit[2].item = elm_genlist_item_append(gl, &itc2,
					 &(tit[2])/* item data */, undef/* parent */, ELM_GENLIST_ITEM_NONE, gl_sel/* func */,
					 undef/* func data */);

   elm_box_pack_end(bx, gl);
   evas_object_show(bx2);

   bx2 = elm_box_add(win);
   elm_box_horizontal_set(bx2, 1);
   elm_box_homogenous_set(bx2, 1);
   evas_object_size_hint_weight_set(bx2, EVAS_HINT_EXPAND, 0.0);
   evas_object_size_hint_align_set(bx2, EVAS_HINT_FILL, EVAS_HINT_FILL);

   bt = elm_button_add(win);
   elm_button_label_set(bt, "[1]");
   evas_object_smart_callback_add(bt, "clicked", my_gl_update, &(tit[0]));
   evas_object_size_hint_align_set(bt, EVAS_HINT_FILL, EVAS_HINT_FILL);
   evas_object_size_hint_weight_set(bt, EVAS_HINT_EXPAND, 0.0);
   elm_box_pack_end(bx2, bt);
   evas_object_show(bt);

   bt = elm_button_add(win);
   elm_button_label_set(bt, "[2]");
   evas_object_smart_callback_add(bt, "clicked", my_gl_update, &(tit[1]));
   evas_object_size_hint_align_set(bt, EVAS_HINT_FILL, EVAS_HINT_FILL);
   evas_object_size_hint_weight_set(bt, EVAS_HINT_EXPAND, 0.0);
   elm_box_pack_end(bx2, bt);
   evas_object_show(bt);

   bt = elm_button_add(win);
   elm_button_label_set(bt, "[3]");
   evas_object_smart_callback_add(bt, "clicked", my_gl_update, &(tit[2]));
   evas_object_size_hint_align_set(bt, EVAS_HINT_FILL, EVAS_HINT_FILL);
   evas_object_size_hint_weight_set(bt, EVAS_HINT_EXPAND, 0.0);
   elm_box_pack_end(bx2, bt);
   evas_object_show(bt);

   elm_box_pack_end(bx, bx2);
   evas_object_show(bx2);

   evas_object_resize(win, 320, 320);
   evas_object_show(win);
}

/*************/

static void
my_gl_item_check_changed(void *data, Evas_Object *obj, void *event_info)
{
   Testitem *tit = data;
   tit->onoff = elm_check_state_get(obj);
   printf("item %p onoff = %i\n", tit, tit->onoff);
}

static Elm_Genlist_Item_Class itc3;
char *gl3_label_get(const void *data, Evas_Object *obj, const char *part)
{
   const Testitem *tit = data;
   char buf[256];
   snprintf(buf, sizeof(buf), "Item mode %i", tit->mode);
   return strdup(buf);
}
Evas_Object *gl3_icon_get(const void *data, Evas_Object *obj, const char *part)
{
   const Testitem *tit = data;
   char buf[PATH_MAX];
   if (!strcmp(part, "elm.swallow.icon"))
     {
	Evas_Object *bx = elm_box_add(obj);
	Evas_Object *ic;
	ic = elm_icon_add(obj);
	snprintf(buf, sizeof(buf), "%s/images/logo_small.png", PACKAGE_DATA_DIR);
	elm_icon_file_set(ic, buf, undef);
	elm_icon_scale_set(ic, 0, 0);
	evas_object_show(ic);
	elm_box_pack_end(bx, ic);
	ic = elm_icon_add(obj);
	elm_icon_file_set(ic, buf, undef);
	elm_icon_scale_set(ic, 0, 0);
	evas_object_show(ic);
	elm_box_pack_end(bx, ic);
        elm_box_horizontal_set(bx, 1);
	evas_object_show(bx);
	return bx;
     }
   else if (!strcmp(part, "elm.swallow.end"))
     {
	Evas_Object *ck;
	ck = elm_check_add(obj);
	evas_object_propagate_events_set(ck, 0);
	elm_check_state_set(ck, tit->onoff);
	evas_object_smart_callback_add(ck, "changed", my_gl_item_check_changed, data);
	evas_object_show(ck);
	return ck;
     }
   return undef;
}
Eina_Bool gl3_state_get(const void *data, Evas_Object *obj, const char *part)
{
   return EINA_FALSE;
}
void gl3_del(const void *data, Evas_Object *obj)
{
}

void
test_genlist4(void *data, Evas_Object *obj, void *event_info)
{
   Evas_Object *win, *bg, *gl, *bx, *bx2, *bt;
   static Testitem tit[3];
   int i;

   win = elm_win_add(undef, "genlist-4", ELM_WIN_BASIC);
   elm_win_title_set(win, "Genlist 4");
   elm_win_autodel_set(win, 1);

   bg = elm_bg_add(win);
   elm_win_resize_object_add(win, bg);
   evas_object_size_hint_weight_set(bg, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
   evas_object_show(bg);

   bx = elm_box_add(win);
   evas_object_size_hint_weight_set(bx, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
   elm_win_resize_object_add(win, bx);
   evas_object_show(bx);

   gl = elm_genlist_add(win);
   elm_genlist_multi_select_set(gl, 1);
   evas_object_size_hint_align_set(gl, EVAS_HINT_FILL, EVAS_HINT_FILL);
   evas_object_size_hint_weight_set(gl, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
   evas_object_show(gl);

   itc3.item_style     = "default";
   itc3.func.label_get = gl3_label_get;
   itc3.func.icon_get  = gl3_icon_get;
   itc3.func.state_get = gl3_state_get;
   itc3.func.del       = gl3_del;

   tit[0].mode = 0;
   tit[0].item = elm_genlist_item_append(gl, &itc3,
					 &(tit[0])/* item data */, undef/* parent */, ELM_GENLIST_ITEM_NONE, gl_sel/* func */,
					 undef/* func data */);
   tit[1].mode = 1;
   tit[1].item = elm_genlist_item_append(gl, &itc3,
					 &(tit[1])/* item data */, undef/* parent */, ELM_GENLIST_ITEM_NONE, gl_sel/* func */,
					 undef/* func data */);
   tit[2].mode = 2;
   tit[2].item = elm_genlist_item_append(gl, &itc3,
					 &(tit[2])/* item data */, undef/* parent */, ELM_GENLIST_ITEM_NONE, gl_sel/* func */,
					 undef/* func data */);

   elm_box_pack_end(bx, gl);
   evas_object_show(bx2);

   bx2 = elm_box_add(win);
   elm_box_horizontal_set(bx2, 1);
   elm_box_homogenous_set(bx2, 1);
   evas_object_size_hint_weight_set(bx2, EVAS_HINT_EXPAND, 0.0);
   evas_object_size_hint_align_set(bx2, EVAS_HINT_FILL, EVAS_HINT_FILL);

   bt = elm_button_add(win);
   elm_button_label_set(bt, "[1]");
   evas_object_smart_callback_add(bt, "clicked", my_gl_update, &(tit[0]));
   evas_object_size_hint_align_set(bt, EVAS_HINT_FILL, EVAS_HINT_FILL);
   evas_object_size_hint_weight_set(bt, EVAS_HINT_EXPAND, 0.0);
   elm_box_pack_end(bx2, bt);
   evas_object_show(bt);

   bt = elm_button_add(win);
   elm_button_label_set(bt, "[2]");
   evas_object_smart_callback_add(bt, "clicked", my_gl_update, &(tit[1]));
   evas_object_size_hint_align_set(bt, EVAS_HINT_FILL, EVAS_HINT_FILL);
   evas_object_size_hint_weight_set(bt, EVAS_HINT_EXPAND, 0.0);
   elm_box_pack_end(bx2, bt);
   evas_object_show(bt);

   bt = elm_button_add(win);
   elm_button_label_set(bt, "[3]");
   evas_object_smart_callback_add(bt, "clicked", my_gl_update, &(tit[2]));
   evas_object_size_hint_align_set(bt, EVAS_HINT_FILL, EVAS_HINT_FILL);
   evas_object_size_hint_weight_set(bt, EVAS_HINT_EXPAND, 0.0);
   elm_box_pack_end(bx2, bt);
   evas_object_show(bt);

   elm_box_pack_end(bx, bx2);
   evas_object_show(bx2);

   evas_object_resize(win, 320, 320);
   evas_object_show(win);
}


/*************/
static void
my_gl_item_check_changed2(void *data, Evas_Object *obj, void *event_info)
{
   Testitem *tit = data;
   tit->onoff = elm_check_state_get(obj);
   printf("item %p onoff = %i\n", tit, tit->onoff);
}

static Elm_Genlist_Item_Class itc5;
char *gl5_label_get(const void *data, Evas_Object *obj, const char *part)
{
   const Testitem *tit = data;
   char buf[256];
   if (!strcmp(part, "elm.text"))
     {
	snprintf(buf, sizeof(buf), "Item mode %i", tit->mode);
     }
   else if (!strcmp(part, "elm.text.sub"))
     {
	snprintf(buf, sizeof(buf), "%i bottles on the wall", tit->mode);
     }
   return strdup(buf);
}
Evas_Object *gl5_icon_get(const void *data, Evas_Object *obj, const char *part)
{
   const Testitem *tit = data;
   char buf[PATH_MAX];
   if (!strcmp(part, "elm.swallow.icon"))
     {
	Evas_Object *bx = elm_box_add(obj);
	Evas_Object *ic;
	elm_box_horizontal_set(bx, 1);
	ic = elm_icon_add(obj);
	snprintf(buf, sizeof(buf), "%s/images/logo_small.png", PACKAGE_DATA_DIR);
	elm_icon_file_set(ic, buf, undef);
	elm_icon_scale_set(ic, 0, 0);
	evas_object_show(ic);
	elm_box_pack_end(bx, ic);
	ic = elm_icon_add(obj);
	elm_icon_file_set(ic, buf, undef);
	elm_icon_scale_set(ic, 0, 0);
	evas_object_show(ic);
	elm_box_pack_end(bx, ic);
        elm_box_horizontal_set(bx, 1);
	evas_object_show(bx);
	return bx;
     }
   else if (!strcmp(part, "elm.swallow.end"))
     {
	Evas_Object *ck;
	ck = elm_check_add(obj);
	evas_object_propagate_events_set(ck, 0);
	elm_check_state_set(ck, tit->onoff);
	evas_object_smart_callback_add(ck, "changed", my_gl_item_check_changed2, data);
	evas_object_show(ck);
	return ck;
     }
   return undef;
}
Eina_Bool gl5_state_get(const void *data, Evas_Object *obj, const char *part)
{
   return EINA_FALSE;
}
void gl5_del(const void *data, Evas_Object *obj)
{
}

static void
item_drag_up(void *data, Evas_Object *obj, void *event_info)
{
   printf("drag up\n");
}

static void
item_drag_down(void *data, Evas_Object *obj, void *event_info)
{
   printf("drag down\n");
}

static void
item_drag_left(void *data, Evas_Object *obj, void *event_info)
{
   printf("drag left\n");
}

static void
item_drag_right(void *data, Evas_Object *obj, void *event_info)
{
   printf("drag right\n");
}

static void
item_drag(void *data, Evas_Object *obj, void *event_info)
{
   printf("drag\n");
}

static void
item_drag_stop(void *data, Evas_Object *obj, void *event_info)
{
   printf("drag stop\n");
}

void
test_genlist5(void *data, Evas_Object *obj, void *event_info)
{
   Evas_Object *win, *bg, *gl, *bx, *bx2, *bt;
   static Testitem tit[3];
   int i;

   win = elm_win_add(undef, "genlist-5", ELM_WIN_BASIC);
   elm_win_title_set(win, "Genlist 5");
   elm_win_autodel_set(win, 1);

   bg = elm_bg_add(win);
   elm_win_resize_object_add(win, bg);
   evas_object_size_hint_weight_set(bg, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
   evas_object_show(bg);

   bx = elm_box_add(win);
   evas_object_size_hint_weight_set(bx, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
   elm_win_resize_object_add(win, bx);
   evas_object_show(bx);

   gl = elm_genlist_add(win);
   elm_genlist_always_select_mode_set(gl, 1);
   evas_object_size_hint_align_set(gl, EVAS_HINT_FILL, EVAS_HINT_FILL);
   evas_object_size_hint_weight_set(gl, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
   evas_object_show(gl);
   itc5.item_style     = "double_label";
   itc5.func.label_get = gl5_label_get;
   itc5.func.icon_get  = gl5_icon_get;
   itc5.func.state_get = gl5_state_get;
   itc5.func.del       = gl5_del;

   tit[0].mode = 0;
   tit[0].item = elm_genlist_item_append(gl, &itc5,
					 &(tit[0])/* item data */, undef/* parent */, ELM_GENLIST_ITEM_NONE, gl_sel/* func */,
					 undef/* func data */);
   tit[1].mode = 1;
   tit[1].item = elm_genlist_item_append(gl, &itc5,
					 &(tit[1])/* item data */, undef/* parent */, ELM_GENLIST_ITEM_NONE, gl_sel/* func */,
					 undef/* func data */);
   tit[2].mode = 2;
   tit[2].item = elm_genlist_item_append(gl, &itc5,
					 &(tit[2])/* item data */, undef/* parent */, ELM_GENLIST_ITEM_NONE, gl_sel/* func */,
					 undef/* func data */);

   elm_box_pack_end(bx, gl);
   evas_object_show(bx2);

   evas_object_smart_callback_add(gl, "drag,start,up", item_drag_up, undef);
   evas_object_smart_callback_add(gl, "drag,start,down", item_drag_down, undef);
   evas_object_smart_callback_add(gl, "drag,start,left", item_drag_left, undef);
   evas_object_smart_callback_add(gl, "drag,start,right", item_drag_right, undef);
   evas_object_smart_callback_add(gl, "drag", item_drag, undef);
   evas_object_smart_callback_add(gl, "drag,stop", item_drag_stop, undef);

   bx2 = elm_box_add(win);
   elm_box_horizontal_set(bx2, 1);
   elm_box_homogenous_set(bx2, 1);
   evas_object_size_hint_weight_set(bx2, EVAS_HINT_EXPAND, 0.0);
   evas_object_size_hint_align_set(bx2, EVAS_HINT_FILL, EVAS_HINT_FILL);

   bt = elm_button_add(win);
   elm_button_label_set(bt, "[1]");
   evas_object_smart_callback_add(bt, "clicked", my_gl_update, &(tit[0]));
   evas_object_size_hint_align_set(bt, EVAS_HINT_FILL, EVAS_HINT_FILL);
   evas_object_size_hint_weight_set(bt, EVAS_HINT_EXPAND, 0.0);
   elm_box_pack_end(bx2, bt);
   evas_object_show(bt);

   bt = elm_button_add(win);
   elm_button_label_set(bt, "[2]");
   evas_object_smart_callback_add(bt, "clicked", my_gl_update, &(tit[1]));
   evas_object_size_hint_align_set(bt, EVAS_HINT_FILL, EVAS_HINT_FILL);
   evas_object_size_hint_weight_set(bt, EVAS_HINT_EXPAND, 0.0);
   elm_box_pack_end(bx2, bt);
   evas_object_show(bt);

   bt = elm_button_add(win);
   elm_button_label_set(bt, "[3]");
   evas_object_smart_callback_add(bt, "clicked", my_gl_update, &(tit[2]));
   evas_object_size_hint_align_set(bt, EVAS_HINT_FILL, EVAS_HINT_FILL);
   evas_object_size_hint_weight_set(bt, EVAS_HINT_EXPAND, 0.0);
   elm_box_pack_end(bx2, bt);
   evas_object_show(bt);

   elm_box_pack_end(bx, bx2);
   evas_object_show(bx2);

   evas_object_resize(win, 320, 320);
   evas_object_show(win);
}

/*************/

static Elm_Genlist_Item_Class itc4;

static void
gl4_sel(void *data, Evas_Object *obj, void *event_info)
{
}
static void
gl4_exp(void *data, Evas_Object *obj, void *event_info)
{
   Elm_Genlist_Item *it = event_info;
   Evas_Object *gl = elm_genlist_item_genlist_get(it);
   int val = (int)elm_genlist_item_data_get(it);
   val *= 10;
   elm_genlist_item_append(gl, &itc4,
			   (void *)(val + 1)/* item data */, it/* parent */, ELM_GENLIST_ITEM_NONE, gl4_sel/* func */,
			   undef/* func data */);
   elm_genlist_item_append(gl, &itc4,
			   (void *)(val + 2)/* item data */, it/* parent */, ELM_GENLIST_ITEM_NONE, gl4_sel/* func */,
			   undef/* func data */);
   elm_genlist_item_append(gl, &itc4,
			   (void *)(val + 3)/* item data */, it/* parent */, ELM_GENLIST_ITEM_SUBITEMS, gl4_sel/* func */,
			   undef/* func data */);
}
static void
gl4_con(void *data, Evas_Object *obj, void *event_info)
{
   Elm_Genlist_Item *it = event_info;
   elm_genlist_item_subitems_clear(it);
}

static void
gl4_exp_req(void *data, Evas_Object *obj, void *event_info)
{
   Elm_Genlist_Item *it = event_info;
   elm_genlist_item_expanded_set(it, 1);
}
static void
gl4_con_req(void *data, Evas_Object *obj, void *event_info)
{
   Elm_Genlist_Item *it = event_info;
   elm_genlist_item_expanded_set(it, 0);
}

char *gl4_label_get(const void *data, Evas_Object *obj, const char *part)
{
   char buf[256];
   snprintf(buf, sizeof(buf), "Item mode %i", (int)data);
   return strdup(buf);
}
Evas_Object *gl4_icon_get(const void *data, Evas_Object *obj, const char *part)
{
   char buf[PATH_MAX];
   if (!strcmp(part, "elm.swallow.icon"))
     {
	Evas_Object *ic = elm_icon_add(obj);
	snprintf(buf, sizeof(buf), "%s/images/logo_small.png", PACKAGE_DATA_DIR);
	elm_icon_file_set(ic, buf, undef);
	evas_object_size_hint_aspect_set(ic, EVAS_ASPECT_CONTROL_VERTICAL, 1, 1);
	evas_object_show(ic);
	return ic;
     }
   else if (!strcmp(part, "elm.swallow.end"))
     {
	Evas_Object *ck;
	ck = elm_check_add(obj);
	evas_object_show(ck);
	return ck;
     }
   return undef;
}
Eina_Bool gl4_state_get(const void *data, Evas_Object *obj, const char *part)
{
   return EINA_FALSE;
}
void gl4_del(const void *data, Evas_Object *obj)
{
}

void
test_genlist6(void *data, Evas_Object *obj, void *event_info)
{
   Evas_Object *win, *bg, *gl, *bx, *bx2, *bt;

   win = elm_win_add(undef, "genlist-tree", ELM_WIN_BASIC);
   elm_win_title_set(win, "Genlist Tree");
   elm_win_autodel_set(win, 1);

   bg = elm_bg_add(win);
   elm_win_resize_object_add(win, bg);
   evas_object_size_hint_weight_set(bg, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
   evas_object_show(bg);

   bx = elm_box_add(win);
   evas_object_size_hint_weight_set(bx, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
   elm_win_resize_object_add(win, bx);
   evas_object_show(bx);

   gl = elm_genlist_add(win);
   evas_object_size_hint_align_set(gl, EVAS_HINT_FILL, EVAS_HINT_FILL);
   evas_object_size_hint_weight_set(gl, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
   evas_object_show(gl);

   itc4.item_style     = "default";
   itc4.func.label_get = gl4_label_get;
   itc4.func.icon_get  = gl4_icon_get;
   itc4.func.state_get = gl4_state_get;
   itc4.func.del       = gl4_del;

   elm_genlist_item_append(gl, &itc4,
			   (void *)1/* item data */, undef/* parent */, ELM_GENLIST_ITEM_SUBITEMS, gl4_sel/* func */,
			   undef/* func data */);
   elm_genlist_item_append(gl, &itc4,
			   (void *)2/* item data */, undef/* parent */, ELM_GENLIST_ITEM_SUBITEMS, gl4_sel/* func */,
			   undef/* func data */);
   elm_genlist_item_append(gl, &itc4,
			   (void *)3/* item data */, undef/* parent */, ELM_GENLIST_ITEM_NONE, gl4_sel/* func */,
			   undef/* func data */);

   evas_object_smart_callback_add(gl, "expand,request", gl4_exp_req, gl);
   evas_object_smart_callback_add(gl, "contract,request", gl4_con_req, gl);
   evas_object_smart_callback_add(gl, "expanded", gl4_exp, gl);
   evas_object_smart_callback_add(gl, "contracted", gl4_con, gl);

   elm_box_pack_end(bx, gl);
   evas_object_show(bx2);

   bx2 = elm_box_add(win);
   elm_box_horizontal_set(bx2, 1);
   elm_box_homogenous_set(bx2, 1);
   evas_object_size_hint_weight_set(bx2, EVAS_HINT_EXPAND, 0.0);
   evas_object_size_hint_align_set(bx2, EVAS_HINT_FILL, EVAS_HINT_FILL);

   bt = elm_button_add(win);
   elm_button_label_set(bt, "[1]");
//   evas_object_smart_callback_add(bt, "clicked", my_gl_update, &(tit[0]));
   evas_object_size_hint_align_set(bt, EVAS_HINT_FILL, EVAS_HINT_FILL);
   evas_object_size_hint_weight_set(bt, EVAS_HINT_EXPAND, 0.0);
   elm_box_pack_end(bx2, bt);
   evas_object_show(bt);

   bt = elm_button_add(win);
   elm_button_label_set(bt, "[2]");
//   evas_object_smart_callback_add(bt, "clicked", my_gl_update, &(tit[1]));
   evas_object_size_hint_align_set(bt, EVAS_HINT_FILL, EVAS_HINT_FILL);
   evas_object_size_hint_weight_set(bt, EVAS_HINT_EXPAND, 0.0);
   elm_box_pack_end(bx2, bt);
   evas_object_show(bt);

   bt = elm_button_add(win);
   elm_button_label_set(bt, "[3]");
//   evas_object_smart_callback_add(bt, "clicked", my_gl_update, &(tit[2]));
   evas_object_size_hint_align_set(bt, EVAS_HINT_FILL, EVAS_HINT_FILL);
   evas_object_size_hint_weight_set(bt, EVAS_HINT_EXPAND, 0.0);
   elm_box_pack_end(bx2, bt);
   evas_object_show(bt);

   elm_box_pack_end(bx, bx2);
   evas_object_show(bx2);

   evas_object_resize(win, 320, 320);
   evas_object_show(win);
}

=cut

sub test_check {
    my ($win, $bg, $bx, $ic, $ck);

    $win = elm_win_add(undef, "check", ELM_WIN_BASIC);
    elm_win_title_set($win, "Checks");
    elm_win_autodel_set($win, 1);

    $bg = elm_bg_add($win);
    elm_win_resize_object_add($win, $bg);
    evas_object_size_hint_weight_set($bg, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
    evas_object_show($bg);

    $bx = elm_box_add($win);
    evas_object_size_hint_weight_set($bx, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
    elm_win_resize_object_add($win, $bx);
    evas_object_show($bx);

    $ic = elm_icon_add($win);
    elm_icon_file_set($ic, $images{'logo_small'}, undef);
    evas_object_size_hint_aspect_set($ic, EVAS_ASPECT_CONTROL_VERTICAL, 1, 1);
    $ck = elm_check_add($win);
    evas_object_size_hint_weight_set($ck, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
    evas_object_size_hint_align_set($ck, EVAS_HINT_FILL, 0.5);
    elm_check_label_set($ck, "Icon sized to check");
    elm_check_icon_set($ck, $ic);
    elm_check_state_set($ck, 1);
    elm_box_pack_end($bx, $ck);
    evas_object_show($ck);
    evas_object_show($ic);

    $ic = elm_icon_add($win);
    elm_icon_file_set($ic, $images{'logo_small'}, undef);
    elm_icon_scale_set($ic, 0, 0);
    $ck = elm_check_add($win);
    elm_check_label_set($ck, "Icon no scale");
    elm_check_icon_set($ck, $ic);
    elm_box_pack_end($bx, $ck);
    evas_object_show($ck);
    evas_object_show($ic);

    $ck = elm_check_add($win);
    elm_check_label_set($ck, "Label Only");
    elm_box_pack_end($bx, $ck);
    evas_object_show($ck);

    $ic = elm_icon_add($win);
    elm_icon_file_set($ic, $images{'logo_small'}, undef);
    evas_object_size_hint_aspect_set($ic, EVAS_ASPECT_CONTROL_VERTICAL, 1, 1);
    $ck = elm_check_add($win);
    evas_object_size_hint_weight_set($ck, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
    evas_object_size_hint_align_set($ck, EVAS_HINT_FILL, 0.5);
    elm_check_label_set($ck, "Disabled check");
    elm_check_icon_set($ck, $ic);
    elm_check_state_set($ck, 1);
    elm_box_pack_end($bx, $ck);
    elm_object_disabled_set($ck, 1);
    evas_object_show($ck);
    evas_object_show($ic);

    $ic = elm_icon_add($win);
    elm_icon_file_set($ic, $images{'logo_small'}, undef);
    elm_icon_scale_set($ic, 0, 0);
    $ck = elm_check_add($win);
    elm_check_icon_set($ck, $ic);
    elm_box_pack_end($bx, $ck);
    evas_object_show($ck);
    evas_object_show($ic);

    evas_object_show($win);
}

sub test_radio {
    my ($win, $bg, $bx, $ic, $rd, $rdg);

    $win = elm_win_add(undef, "radio", ELM_WIN_BASIC);
    elm_win_title_set($win, "Radios");
    elm_win_autodel_set($win, 1);

    $bg = elm_bg_add($win);
    elm_win_resize_object_add($win, $bg);
    evas_object_size_hint_weight_set($bg, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
    evas_object_show($bg);

    $bx = elm_box_add($win);
    evas_object_size_hint_weight_set($bx, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
    elm_win_resize_object_add($win, $bx);
    evas_object_show($bx);

    $ic = elm_icon_add($win);
    elm_icon_file_set($ic, $images{'logo_small'}, undef);
    evas_object_size_hint_aspect_set($ic, EVAS_ASPECT_CONTROL_VERTICAL, 1, 1);

    $rd = elm_radio_add($win);
    elm_radio_state_value_set($rd, 0);
    evas_object_size_hint_weight_set($rd, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
    evas_object_size_hint_align_set($rd, EVAS_HINT_FILL, 0.5);
    elm_radio_label_set($rd, "Icon sized to radio");
    elm_radio_icon_set($rd, $ic);
    elm_box_pack_end($bx, $rd);
    evas_object_show($rd);
    evas_object_show($ic);
    $rdg = $rd;

    $ic = elm_icon_add($win);
    elm_icon_file_set($ic, $images{'logo_small'}, undef);
    elm_icon_scale_set($ic, 0, 0);

    $rd = elm_radio_add($win);
    elm_radio_state_value_set($rd, 1);
    elm_radio_group_add($rd, $rdg);
    elm_radio_label_set($rd, "Icon no scale");
    elm_radio_icon_set($rd, $ic);
    elm_box_pack_end($bx, $rd);
    evas_object_show($rd);
    evas_object_show($ic);

    $rd = elm_radio_add($win);
    elm_radio_state_value_set($rd, 2);
    elm_radio_group_add($rd, $rdg);
    elm_radio_label_set($rd, "Label Only");
    elm_box_pack_end($bx, $rd);
    evas_object_show($rd);

    $rd = elm_radio_add($win);
    elm_radio_state_value_set($rd, 3);
    elm_radio_group_add($rd, $rdg);
    elm_radio_label_set($rd, "Disabled");
    elm_object_disabled_set($rd, 1);
    elm_box_pack_end($bx, $rd);
    evas_object_show($rd);

    $ic = elm_icon_add($win);
    elm_icon_file_set($ic, $images{'logo_small'}, undef);
    elm_icon_scale_set($ic, 0, 0);

    $rd = elm_radio_add($win);
    elm_radio_state_value_set($rd, 4);
    elm_radio_group_add($rd, $rdg);
    elm_radio_icon_set($rd, $ic);
    elm_box_pack_end($bx, $rd);
    evas_object_show($rd);
    evas_object_show($ic);

    $ic = elm_icon_add($win);
    elm_icon_file_set($ic, $images{'logo_small'}, undef);
    elm_icon_scale_set($ic, 0, 0);

    $rd = elm_radio_add($win);
    elm_radio_state_value_set($rd, 5);
    elm_radio_group_add($rd, $rdg);
    elm_radio_icon_set($rd, $ic);
    elm_object_disabled_set($rd, 1);
    elm_box_pack_end($bx, $rd);
    evas_object_show($rd);
    evas_object_show($ic);

    elm_radio_value_set($rdg, 2);

    evas_object_show($win);
}

sub my_pager_1 {

    #Pginfo *info = data;
    #elm_pager_content_promote(info->pager, info->pg2);
}

sub my_pager_2 {

    #Pginfo *info = data;
    #elm_pager_content_promote(info->pager, info->pg3);
}

sub my_pager_3 {

    #Pginfo *info = data;
    #elm_pager_content_promote(info->pager, info->pg1);
}

sub my_pager_pop {

    #Pginfo *info = data;
    #elm_pager_content_pop(info->pager);
}

sub test_pager {
    my ($win, $bg, $pg, $bx, $lb, $bt);

    my %info;

    $win = elm_win_add(undef, "pager", ELM_WIN_BASIC);
    elm_win_title_set($win, "Pager");
    elm_win_autodel_set($win, 1);

    $bg = elm_bg_add($win);
    elm_win_resize_object_add($win, $bg);
    evas_object_size_hint_weight_set($bg, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
    evas_object_show($bg);

    $pg = elm_pager_add($win);
    elm_win_resize_object_add($win, $pg);
    evas_object_show($pg);

    $info{'pager'} = $pg;

    $bx = elm_box_add($win);
    evas_object_size_hint_weight_set($bx, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
    evas_object_show($bx);

    $lb = elm_label_add($win);
    elm_label_label_set($lb,
            "This is page 1 in a pager stack.<br>" . "<br>"
          . "So what is a pager stack? It is a stack<br>"
          . "of pages that hold widgets in it. The<br>"
          . "pages can be pushed and popped on and<br>"
          . "off the stack, activated and otherwise<br>"
          . "activated if already in the stack<br>"
          . "(activated means promoted to the top of<br>"
          . "the stack).<br>" . "<br>"
          . "The theme may define the animation how<br>"
          . "show and hide of pages.");
    elm_box_pack_end($bx, $lb);
    evas_object_show($lb);

    $bt = elm_button_add($win);
    elm_button_label_set($bt, "Flip to 2");
    evas_object_smart_callback_add($bt, "clicked", \&my_pager_1, \%info);
    elm_box_pack_end($bx, $bt);
    evas_object_show($bt);

    $bt = elm_button_add($win);
    elm_button_label_set($bt, "Popme");
    evas_object_smart_callback_add($bt, "clicked", \&my_pager_pop, \%info);
    elm_box_pack_end($bx, $bt);
    evas_object_show($bt);
    elm_pager_content_push($pg, $bx);
    $info{'pg1'} = $bx;

    $bx = elm_box_add($win);
    evas_object_size_hint_weight_set($bx, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
    evas_object_show($bx);

    $lb = elm_label_add($win);
    elm_label_label_set($lb, "This is page 2 in a pager stack.<br>" . "<br>" . "This is just like the previous page in<br>" . "the pager stack.");
    elm_box_pack_end($bx, $lb);
    evas_object_show($lb);

    $bt = elm_button_add($win);
    elm_button_label_set($bt, "Flip to 3");
    evas_object_smart_callback_add($bt, "clicked", \&my_pager_2, \%info);
    elm_box_pack_end($bx, $bt);
    evas_object_show($bt);

    $bt = elm_button_add($win);
    elm_button_label_set($bt, "Popme");
    evas_object_smart_callback_add($bt, "clicked", \&my_pager_pop, \%info);
    elm_box_pack_end($bx, $bt);
    evas_object_show($bt);
    elm_pager_content_push($pg, $bx);
    $info{'pg2'} = $bx;

    $bx = elm_box_add($win);
    evas_object_size_hint_weight_set($bx, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
    evas_object_show($bx);

    $lb = elm_label_add($win);
    elm_label_label_set($lb, "This is page 3 in a pager stack.<br>" . "<br>" . "This is just like the previous page in<br>" . "the pager stack.");
    elm_box_pack_end($bx, $lb);
    evas_object_show($lb);

    $bt = elm_button_add($win);
    elm_button_label_set($bt, "Flip to 1");
    evas_object_smart_callback_add($bt, "clicked", \&my_pager_3, \%info);
    elm_box_pack_end($bx, $bt);
    evas_object_show($bt);

    $bt = elm_button_add($win);
    elm_button_label_set($bt, "Popme");
    evas_object_smart_callback_add($bt, "clicked", \&my_pager_pop, \%info);
    elm_box_pack_end($bx, $bt);
    evas_object_show($bt);
    elm_pager_content_push($pg, $bx);
    $info{'pg3'} = $bx;

    evas_object_show($win);
}

=pod

typedef struct _Testitem
{
   Elm_Genlist_Item *item;
   int mode, onoff;
} Testitem;

=cut

sub my_bt_38_alpha_on
{
    my ($win) = @_;
    my $bg = evas_object_data_get($$win, "bg");
    evas_object_hide($bg);
    elm_win_alpha_set($$win, 1);
}

sub my_bt_38_alpha_off
{
   my ($win) = @_;
   my $bg = evas_object_data_get($$win, "bg");
   evas_object_show($bg);
   elm_win_alpha_set($$win, 0);
}

sub my_bt_38_rot_0
{
my ($win) = @_;
   my $bg = evas_object_data_get($$win, "bg");
   elm_win_rotation_set($$win, 0);
}

sub my_bt_38_rot_90
{
    my ($win) = @_;
    my $bg = evas_object_data_get($$win, "bg");
   elm_win_rotation_set($$win, 90);
}

sub my_bt_38_rot_180
{
    my ($win) = @_;
    my $bg = evas_object_data_get($$win, "bg");
   elm_win_rotation_set($$win, 180);
}

sub my_bt_38_rot_270
{
    my  ($win) = @_;
    my $bg = evas_object_data_get($$win, "bg");
   elm_win_rotation_set($$win, 270);
}

sub my_win_move
{
    my (undef, $obj) = @_;
    my ($x, $y);
    
# TODO
  # elm_win_screen_position_get(obj, &x, &y);
   #printf("MOVE - win geom: %4i %4i\n", x, y);
}

sub
_win_resize
{
    my (undef, $obj) = @_;
   my ($w, $h);
# TODO
#   evas_object_geometry_get(obj, undef, undef, &w, &h);
#   printf("RESIZE - win geom: %4ix%4i\n", w, h);
}

sub test_win_state
{
   my ($win, $bg, $sl, $bx, $bx2, $bt);
   my $i;

   $win = elm_win_add(undef, "window-state", ELM_WIN_BASIC);
   elm_win_title_set($win, "Window States");
   evas_object_smart_callback_add($win, "moved", \&my_win_move, undef);
   evas_object_event_callback_add($win, EVAS_CALLBACK_RESIZE, \&_win_resize, undef);
   elm_win_autodel_set($win, 1);

   $bg = elm_bg_add($win);
   elm_win_resize_object_add($win, $bg);
   evas_object_size_hint_weight_set($bg, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
   evas_object_show($bg);
   evas_object_data_set($win, "bg", $bg);

   $bx = elm_box_add($win);
   evas_object_size_hint_weight_set($bx, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
   elm_win_resize_object_add($win, $bx);
   evas_object_show($bx);

   $bx2 = elm_box_add($win);
   elm_box_horizontal_set($bx2, 1);
   elm_box_homogenous_set($bx2, 1);
   evas_object_size_hint_weight_set($bx2, EVAS_HINT_EXPAND, 0.0);
   evas_object_size_hint_fill_set($bx2, EVAS_HINT_FILL, EVAS_HINT_FILL);

   $bt = elm_button_add($win);
   elm_button_label_set($bt, "Alpha On");
   evas_object_smart_callback_add($bt, "clicked", \&my_bt_38_alpha_on, \$win);
   evas_object_size_hint_fill_set($bt, EVAS_HINT_FILL, EVAS_HINT_FILL);
   evas_object_size_hint_weight_set($bt, EVAS_HINT_EXPAND, 0.0);
   elm_box_pack_end($bx2, $bt);
   evas_object_show($bt);

   $bt = elm_button_add($win);
   elm_button_label_set($bt, "Alpha Off");
   evas_object_smart_callback_add($bt, "clicked",\&my_bt_38_alpha_off, \$win);
   evas_object_size_hint_fill_set($bt, EVAS_HINT_FILL, EVAS_HINT_FILL);
   evas_object_size_hint_weight_set($bt, EVAS_HINT_EXPAND, 0.0);
   elm_box_pack_end($bx2, $bt);
   evas_object_show($bt);

   elm_box_pack_end($bx, $bx2);
   evas_object_show($bx2);

   $bx2 = elm_box_add($win);
   elm_box_horizontal_set($bx2, 1);
   elm_box_homogenous_set($bx2, 1);
   evas_object_size_hint_weight_set($bx2, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
   evas_object_size_hint_fill_set($bx2, EVAS_HINT_FILL, EVAS_HINT_FILL);

   $sl = elm_slider_add($win);
   elm_slider_label_set($sl, "Test");
   elm_slider_span_size_set($sl, 100);
   evas_object_size_hint_align_set($sl, 0.5, 0.5);
   evas_object_size_hint_weight_set($sl, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
   elm_slider_indicator_format_set($sl, "%3.0f");
   elm_slider_min_max_set($sl, 50, 150);
   elm_slider_value_set($sl, 50);
   elm_slider_inverted_set($sl, 1);
   elm_box_pack_end($bx2, $sl);
   evas_object_show($sl);

   elm_box_pack_end($bx, $bx2);
   evas_object_show($bx2);

   $bx2 = elm_box_add($win);
   elm_box_horizontal_set($bx2, 1);
   elm_box_homogenous_set($bx2, 1);
   evas_object_size_hint_weight_set($bx2, EVAS_HINT_EXPAND, 0.0);
   evas_object_size_hint_fill_set($bx2, EVAS_HINT_FILL, EVAS_HINT_FILL);

   $bt = elm_button_add($win);
   elm_button_label_set($bt, "Rot 0");
   evas_object_smart_callback_add($bt, "clicked", \&my_bt_38_rot_0, \$win);
   evas_object_size_hint_fill_set($bt, EVAS_HINT_FILL, EVAS_HINT_FILL);
   evas_object_size_hint_weight_set($bt, EVAS_HINT_EXPAND, 0.0);
   elm_box_pack_end($bx2, $bt);
   evas_object_show($bt);

   $bt = elm_button_add($win);
   elm_button_label_set($bt, "Rot 90");
   evas_object_smart_callback_add($bt, "clicked", \&my_bt_38_rot_90, \$win);
   evas_object_size_hint_fill_set($bt, EVAS_HINT_FILL, EVAS_HINT_FILL);
   evas_object_size_hint_weight_set($bt, EVAS_HINT_EXPAND, 0.0);
   elm_box_pack_end($bx2, $bt);
   evas_object_show($bt);

   $bt = elm_button_add($win);
   elm_button_label_set($bt, "Rot 180");
   evas_object_smart_callback_add($bt, "clicked", \&my_bt_38_rot_180, \$win);
   evas_object_size_hint_fill_set($bt, EVAS_HINT_FILL, EVAS_HINT_FILL);
   evas_object_size_hint_weight_set($bt, EVAS_HINT_EXPAND, 0.0);
   elm_box_pack_end($bx2, $bt);
   evas_object_show($bt);

   $bt = elm_button_add($win);
   elm_button_label_set($bt, "Rot 270");
   evas_object_smart_callback_add($bt, "clicked", \&my_bt_38_rot_270, \$win);
   evas_object_size_hint_fill_set($bt, EVAS_HINT_FILL, EVAS_HINT_FILL);
   evas_object_size_hint_weight_set($bt, EVAS_HINT_EXPAND, 0.0);
   elm_box_pack_end($bx2, $bt);
   evas_object_show($bt);

   elm_box_pack_end($bx, $bx2);
   evas_object_show($bx2);

   evas_object_resize($win, 280, 400);
   evas_object_show($win);
}

my %_test_progressbar = (
    pb1 => undef,
    pb2 => undef,
    pb3 => undef,
    pb4 => undef,
    pb5 => undef,
    pb6 => undef,
    pb7 => undef,
    rub => 0,
    timer => undef
);

sub _my_progressbar_value_set
{
   my $progress = elm_progressbar_value_get ($_test_progressbar{'pb1'});
   if ($progress < 1.0) {
       $progress += 0.0123;
   }
   else {
       $progress = 0.0;
   }
   elm_progressbar_value_set($_test_progressbar{pb1}, $progress);
   elm_progressbar_value_set($_test_progressbar{pb4}, $progress);
   elm_progressbar_value_set($_test_progressbar{pb3}, $progress);
   elm_progressbar_value_set($_test_progressbar{pb6}, $progress);
   if ($progress < 1.0) { 
       return ECORE_CALLBACK_RENEW;
   }
   $_test_progressbar{run} = 0;

   return ECORE_CALLBACK_CANCEL;
}

sub my_progressbar_test_start
{
   elm_progressbar_pulse($_test_progressbar{pb2}, EINA_TRUE);
   elm_progressbar_pulse($_test_progressbar{pb5}, EINA_TRUE);
   elm_progressbar_pulse($_test_progressbar{pb7}, EINA_TRUE);
   if (!$_test_progressbar{run})
     {
#        $_test_progressbar{timer} =
            ecore_timer_add(0.1, \&_my_progressbar_value_set, undef);
        $_test_progressbar{run} = EINA_TRUE;
     }
}

sub my_progressbar_test_stop
{
   elm_progressbar_pulse($_test_progressbar{pb2}, EINA_FALSE);
   elm_progressbar_pulse($_test_progressbar{pb5}, EINA_FALSE);
   elm_progressbar_pulse($_test_progressbar{pb7}, EINA_FALSE);
   if ($_test_progressbar{run})
     {
        #ecore_timer_del($_test_progressbar{timer});
        $_test_progressbar{run} = EINA_FALSE;
     }
}

sub my_progressbar_destroy
{
    my (undef, $obj) = @_;
   my_progressbar_test_stop(undef, undef, undef);
#   evas_object_del($$obj);
}

sub test_progressbar
{
   my ($win, $bg, $pb, $bx, $pbx, $hbx, $bt, $bt_bx, $ic1, $ic2);
   my $test;

   $win = elm_win_add(undef, "progressbar", ELM_WIN_BASIC);
   elm_win_title_set($win, "Progressbar");
   evas_object_smart_callback_add($win, "delete,request", 
                                  \&my_progressbar_destroy, \$test);

   $bg = elm_bg_add($win);
   elm_win_resize_object_add($win, $bg);
   evas_object_size_hint_weight_set($bg, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
   evas_object_show($bg);

   $bx = elm_box_add($win);
   elm_win_resize_object_add($win, $bx);
   evas_object_size_hint_weight_set($bx, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
   evas_object_show($bx);

   $pb = elm_progressbar_add($win);
   evas_object_size_hint_weight_set($pb, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
   evas_object_size_hint_align_set($pb, EVAS_HINT_FILL, 0.5);
   elm_box_pack_end($bx, $pb);
#   elm_progressbar_horizontal_set(pb, EINA_TRUE);
#   elm_progressbar_label_set(pb, "Progression %");
#   elm_progressbar_unit_format_set(pb, undef);
   evas_object_show($pb);
   $_test_progressbar{pb1} = $pb;

   $pb = elm_progressbar_add($win);
   evas_object_size_hint_align_set($pb, EVAS_HINT_FILL, 0.5);
   evas_object_size_hint_weight_set($pb, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
   elm_progressbar_label_set($pb, "Infinite bounce");
   elm_progressbar_pulse_set($pb, EINA_TRUE);
   elm_box_pack_end($bx, $pb);
   evas_object_show($pb);
   $_test_progressbar{pb2} = $pb;

   $ic1 = elm_icon_add($win);
   elm_icon_file_set($ic1, $images{'logo_small'}, undef);
   evas_object_size_hint_aspect_set($ic1, EVAS_ASPECT_CONTROL_VERTICAL, 1, 1);

   $pb = elm_progressbar_add($win);
   elm_progressbar_label_set($pb, "Label");
   elm_progressbar_icon_set($pb, $ic1);
   elm_progressbar_inverted_set($pb, 1);
   elm_progressbar_unit_format_set($pb, "%1.1f units");
   elm_progressbar_span_size_set($pb, 200);
   evas_object_size_hint_align_set($pb, EVAS_HINT_FILL, 0.5);
   evas_object_size_hint_weight_set($pb, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
   elm_box_pack_end($bx, $pb);
   evas_object_show($ic1);
   evas_object_show($pb);
   $_test_progressbar{pb3} = $pb;

   $hbx = elm_box_add($win);
   elm_box_horizontal_set($hbx, EINA_TRUE);
   evas_object_size_hint_weight_set($hbx, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
   evas_object_size_hint_align_set($hbx, EVAS_HINT_FILL, EVAS_HINT_FILL);
   elm_box_pack_end($bx, $hbx);
   evas_object_show($hbx);

   $pb = elm_progressbar_add($win);
   elm_progressbar_horizontal_set($pb, EINA_FALSE);
   evas_object_size_hint_align_set($pb, EVAS_HINT_FILL, EVAS_HINT_FILL);
   evas_object_size_hint_weight_set($pb, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
   elm_box_pack_end($hbx, $pb);
   elm_progressbar_span_size_set($pb, 60);
   elm_progressbar_label_set($pb, "percent");
   evas_object_show($pb);
   $_test_progressbar{pb4} = $pb;

   $pb = elm_progressbar_add($win);
   elm_progressbar_horizontal_set($pb, EINA_FALSE);
   evas_object_size_hint_align_set($pb, EVAS_HINT_FILL, 0.5);
   evas_object_size_hint_weight_set($pb, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
   elm_progressbar_span_size_set($pb, 80);
   elm_progressbar_pulse_set($pb, EINA_TRUE);
   elm_progressbar_unit_format_set($pb, undef);
   elm_progressbar_label_set($pb, "Infinite bounce");
   elm_box_pack_end($hbx, $pb);
   evas_object_show($pb);
   $_test_progressbar{pb5} = $pb;

   $ic2 = elm_icon_add($win);
   elm_icon_file_set($ic2, $images{'logo_small'}, undef);
   evas_object_size_hint_aspect_set($ic2, EVAS_ASPECT_CONTROL_HORIZONTAL, 1, 1);

   $pb = elm_progressbar_add($win);
   elm_progressbar_horizontal_set($pb, EINA_FALSE);
   elm_progressbar_label_set($pb, "Label");
   elm_progressbar_icon_set($pb, $ic2);
   elm_progressbar_inverted_set($pb, 1);
   elm_progressbar_unit_format_set($pb, "%1.2f%%");
   elm_progressbar_span_size_set($pb, 200);
   evas_object_size_hint_align_set($pb, EVAS_HINT_FILL, 0.5);
   evas_object_size_hint_weight_set($pb, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
   elm_box_pack_end($hbx, $pb);
   evas_object_show($ic2);
   evas_object_show($pb);
   $_test_progressbar{pb6} = $pb;

   $pb = elm_progressbar_add($win);
   elm_object_style_set($pb, "wheel");
   elm_progressbar_label_set($pb, "Style: wheel");
   evas_object_size_hint_align_set($pb, EVAS_HINT_FILL, 0.5);
   evas_object_size_hint_weight_set($pb, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
   elm_box_pack_end($bx, $pb);
   evas_object_show($pb);
   $_test_progressbar{pb7} = $pb;

   $bt_bx = elm_box_add($win);
   elm_box_horizontal_set($bt_bx, 1);
   evas_object_size_hint_weight_set($bt_bx, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
   elm_box_pack_end($bx, $bt_bx);
   evas_object_show($bt_bx);

   $bt = elm_button_add($win);
   elm_button_label_set($bt, "Start");
   evas_object_smart_callback_add($bt, "clicked", \&my_progressbar_test_start, undef);
   elm_box_pack_end($bt_bx, $bt);
   evas_object_show($bt);

   $bt = elm_button_add($win);
   elm_button_label_set($bt, "Stop");
   evas_object_smart_callback_add($bt, "clicked", \&my_progressbar_test_stop, undef);
   elm_box_pack_end($bt_bx, $bt);
   evas_object_show($bt);

   evas_object_show($win);
}

__END__

#endif
#include <Elementary.h>
#ifndef ELM_LIB_QUICKLAUNCH
static void
my_fileselector_done(void *data, Evas_Object *obj, void *event_info)
{
   /* event_info conatin the full path of the selected file
    * or undef if none is selected or cancel is pressed */
   const char *selected = event_info;

   if (selected)
     printf("Selected file: %s\n", selected);
   else
     evas_object_del(data); /* delete the test window */
}

static void
my_fileselector_selected(void *data, Evas_Object *obj, void *event_info)
{
   /* event_info conatin the full path of the selected file */
   const char *selected = event_info;
   printf("Selected file: %s\n", selected);

   /* or you can query the selection */
   printf("or: %s\n", elm_fileselector_selected_get(obj));
}

static void
_is_save_clicked(void *data, Evas_Object *obj, void *event_info)
{
   Evas_Object *fs = data;
   printf("Toggle Is save\n");
   if (elm_fileselector_is_save_get(fs))
      elm_fileselector_is_save_set(fs, EINA_FALSE);
   else
      elm_fileselector_is_save_set(fs, EINA_TRUE);
}

static void
_sel_get_clicked(void *data, Evas_Object *obj, void *event_info)
{
   Evas_Object *fs = data;
   printf("Get Selected: %s\n", elm_fileselector_selected_get(fs));
}

void
test_fileselector(void *data, Evas_Object *obj, void *event_info)
{
   Evas_Object *win, *fs, *bg, *vbox, *hbox, *bt;
   char buf[PATH_MAX];

   /* Set the locale according to the system pref.
    * If you dont do so the file selector will order the files list in
    * a case sensitive manner
    */
   setlocale(LC_ALL, "");

   win = elm_win_add(undef, "fileselector", ELM_WIN_BASIC);
   elm_win_title_set(win, "File Selector");
   elm_win_autodel_set(win, 1);

   bg = elm_bg_add(win);
   elm_win_resize_object_add(win, bg);
   evas_object_size_hint_weight_set(bg, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
   evas_object_show(bg);

   vbox = elm_box_add(win);
   elm_win_resize_object_add(win, vbox);
   evas_object_size_hint_weight_set(vbox, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
   evas_object_show(vbox);

   fs = elm_fileselector_add(win);
   /* enable the fs file name entry */
   elm_fileselector_is_save_set(fs, EINA_TRUE);
   /* make the file list a tree with dir expandable in place */
   elm_fileselector_expandable_set(fs, EINA_FALSE);
   /* start the fileselector in the home dir */
   elm_fileselector_path_set(fs, getenv("HOME"));
   /* allow fs to expand in x & y */
   evas_object_size_hint_weight_set(fs, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
   evas_object_size_hint_align_set(fs, EVAS_HINT_FILL, EVAS_HINT_FILL);
   elm_box_pack_end(vbox, fs);
   evas_object_show(fs); // TODO fix this is the widget
   
   /* the 'done' cb is called when the user press ok/cancel */
   evas_object_smart_callback_add(fs, "done", my_fileselector_done, win);
   /* the 'selected' cb is called when the user click on a file/dir */
   evas_object_smart_callback_add(fs, "selected", my_fileselector_selected, win);
   
   /* test buttons */
   hbox = elm_box_add(win);
   elm_box_horizontal_set(hbox, EINA_TRUE);
   elm_box_pack_end(vbox, hbox);
   evas_object_show(hbox);
   
   bt = elm_button_add(win);
   elm_button_label_set(bt, "Toggle is_save");
   evas_object_smart_callback_add(bt, "clicked", _is_save_clicked, fs);
   elm_box_pack_end(hbox, bt);
   evas_object_show(bt);
   
   bt = elm_button_add(win);
   elm_button_label_set(bt, "sel get");
   evas_object_smart_callback_add(bt, "clicked", _sel_get_clicked, fs);
   elm_box_pack_end(hbox, bt);
   evas_object_show(bt);

   evas_object_resize(win, 240, 350);
   evas_object_show(win);
}
#endif

#include <Elementary.h>
#ifndef ELM_LIB_QUICKLAUNCH
void
test_separator(void *data, Evas_Object *obj, void *event_info)
{
   Evas_Object *win, *bg, *bx0, *bx, *bt, *sp;
   char buf[PATH_MAX];

   win = elm_win_add(undef, "separators", ELM_WIN_BASIC);
   elm_win_title_set(win, "Separators");
   elm_win_autodel_set(win, 1);

   bg = elm_bg_add(win);
   elm_win_resize_object_add(win, bg);
   evas_object_size_hint_weight_set(bg, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
   evas_object_show(bg);

   bx0 = elm_box_add(win);
   evas_object_size_hint_weight_set(bx0, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
   elm_box_horizontal_set(bx0, 1);
   elm_win_resize_object_add(win, bx0);
   evas_object_show(bx0);

   bx = elm_box_add(win);
   evas_object_size_hint_weight_set(bx, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
   elm_box_pack_end(bx0, bx);
   evas_object_show(bx);

   bt = elm_button_add(win);
   elm_button_label_set(bt, "Left upper corner");
   elm_box_pack_end(bx, bt);
   evas_object_show(bt);

   sp = elm_separator_add(win);
   elm_separator_horizontal_set(sp, 1); // by default, separator is vertical, we must set it horizontal
   elm_box_pack_end(bx, sp);
   evas_object_show(sp);

   bt = elm_button_add(win);
   elm_button_label_set(bt, "Left lower corner");
   elm_object_disabled_set(bt, 1);
   elm_box_pack_end(bx, bt);
   evas_object_show(bt);

   sp = elm_separator_add(win); // now we need vertical separator
   elm_box_pack_end(bx0, sp);
   evas_object_show(sp);

   bx = elm_box_add(win);
   evas_object_size_hint_weight_set(bx, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
   elm_box_pack_end(bx0, bx);
   evas_object_show(bx);

   bt = elm_button_add(win);
   elm_button_label_set(bt, "Right upper corner");
   elm_object_disabled_set(bt, 1);
   elm_box_pack_end(bx, bt);
   evas_object_show(bt);

   sp = elm_separator_add(win);
   elm_separator_horizontal_set(sp, 1);
   elm_box_pack_end(bx, sp);
   evas_object_show(sp);

   bt = elm_button_add(win);
   elm_button_label_set(bt, "Right lower corner");
   elm_box_pack_end(bx, bt);
   evas_object_show(bt);

   evas_object_show(win);
}
#endif


#include <Elementary.h>
#ifndef ELM_LIB_QUICKLAUNCH
void
my_bt_go_300_300(void *data, Evas_Object *obj, void *event_info)
{
   elm_scroller_region_bring_in((Evas_Object *)data, 300, 300, 318, 318);
}

void
my_bt_go_900_300(void *data, Evas_Object *obj, void *event_info)
{
   elm_scroller_region_bring_in((Evas_Object *)data, 900, 300, 318, 318);
}

void
my_bt_go_300_900(void *data, Evas_Object *obj, void *event_info)
{
   elm_scroller_region_bring_in((Evas_Object *)data, 300, 900, 318, 318);
}

void
my_bt_go_900_900(void *data, Evas_Object *obj, void *event_info)
{
   elm_scroller_region_bring_in((Evas_Object *)data, 900, 900, 318, 318);
}

void
test_scroller(void *data, Evas_Object *obj, void *event_info)
{
   Evas_Object *win, *bg2, *tb, *tb2, *bg, *sc, *bt;
   int i, j, n;
   char buf[PATH_MAX];
   const char *img[9] =
     {
        "panel_01.jpg", 
          "plant_01.jpg", 
          "rock_01.jpg", 
          "rock_02.jpg",
          "sky_01.jpg", 
          "sky_02.jpg", 
          "sky_03.jpg", 
          "sky_04.jpg",
          "wood_01.jpg"
     };

   win = elm_win_add(undef, "scroller", ELM_WIN_BASIC);
   elm_win_title_set(win, "Scroller");
   elm_win_autodel_set(win, 1);

   bg = elm_bg_add(win);
   evas_object_size_hint_weight_set(bg, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
   elm_win_resize_object_add(win, bg);
   evas_object_show(bg);

   tb = elm_table_add(win);
   evas_object_size_hint_weight_set(tb, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);

   n = 0;
   for (j = 0; j < 12; j++)
     {
        for (i = 0; i < 12; i++)
          {
             bg2 = elm_bg_add(win);
             snprintf(buf, sizeof(buf), "%s/images/%s", 
                      PACKAGE_DATA_DIR, img[n]);
             n++;
             if (n >= 9) n = 0;
             elm_bg_file_set(bg2, buf, undef);
             evas_object_size_hint_weight_set(bg2, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
             evas_object_size_hint_align_set(bg2, EVAS_HINT_FILL, EVAS_HINT_FILL);
             evas_object_size_hint_min_set(bg2, 318, 318);
             elm_table_pack(tb, bg2, i, j, 1, 1);
             evas_object_show(bg2);
          }
     }
   
   sc = elm_scroller_add(win);
   evas_object_size_hint_weight_set(sc, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
   elm_win_resize_object_add(win, sc);

   elm_scroller_content_set(sc, tb);
   evas_object_show(tb);

   elm_scroller_page_relative_set(sc, 1.0, 1.0);
//   elm_scroller_page_size_set(sc, 200, 200);
   evas_object_show(sc);

   tb2 = elm_table_add(win);
   evas_object_size_hint_weight_set(tb2, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
   elm_win_resize_object_add(win, tb2);

   bt = elm_button_add(win);
   elm_button_label_set(bt, "to 300 300");
   evas_object_smart_callback_add(bt, "clicked", my_bt_go_300_300, sc);
   evas_object_size_hint_weight_set(bt, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
   evas_object_size_hint_align_set(bt, 0.1, 0.1);
   elm_table_pack(tb2, bt, 0, 0, 1, 1);
   evas_object_show(bt);
   
   bt = elm_button_add(win);
   elm_button_label_set(bt, "to 900 300");
   evas_object_smart_callback_add(bt, "clicked", my_bt_go_900_300, sc);
   evas_object_size_hint_weight_set(bt, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
   evas_object_size_hint_align_set(bt, 0.9, 0.1);
   elm_table_pack(tb2, bt, 1, 0, 1, 1);
   evas_object_show(bt);
   
   bt = elm_button_add(win);
   elm_button_label_set(bt, "to 300 900");
   evas_object_smart_callback_add(bt, "clicked", my_bt_go_300_900, sc);
   evas_object_size_hint_weight_set(bt, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
   evas_object_size_hint_align_set(bt, 0.1, 0.9);
   elm_table_pack(tb2, bt, 0, 1, 1, 1);
   evas_object_show(bt);
   
   bt = elm_button_add(win);
   elm_button_label_set(bt, "to 900 900");
   evas_object_smart_callback_add(bt, "clicked", my_bt_go_900_900, sc);
   evas_object_size_hint_weight_set(bt, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
   evas_object_size_hint_align_set(bt, 0.9, 0.9);
   elm_table_pack(tb2, bt, 1, 1, 1, 1);
   evas_object_show(bt);
   
   evas_object_show(tb2);
   
   evas_object_resize(win, 320, 320);
   evas_object_show(win);
}
#endif

#include <Elementary.h>
#ifndef ELM_LIB_QUICKLAUNCH
void
test_spinner(void *data, Evas_Object *obj, void *event_info)
{
   Evas_Object *win, *bg, *bx, *sp;

   win = elm_win_add(undef, "spinner", ELM_WIN_BASIC);
   elm_win_title_set(win, "Spinner");
   elm_win_autodel_set(win, 1);

   bg = elm_bg_add(win);
   elm_win_resize_object_add(win, bg);
   evas_object_size_hint_weight_set(bg, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
   evas_object_show(bg);

   bx = elm_box_add(win);
   evas_object_size_hint_weight_set(bx, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
   elm_win_resize_object_add(win, bx);
   evas_object_show(bx);

   sp = elm_spinner_add(win);
   elm_spinner_label_format_set(sp, "%1.1f units");
   elm_spinner_step_set(sp, 1.3);
   elm_spinner_wrap_set(sp, 1);
   elm_spinner_min_max_set(sp, -50.0, 250.0);
   evas_object_size_hint_align_set(sp, EVAS_HINT_FILL, 0.5);
   evas_object_size_hint_weight_set(sp, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
   elm_box_pack_end(bx, sp);
   evas_object_show(sp);

   sp = elm_spinner_add(win);
   elm_spinner_label_format_set(sp, "%1.1f units");
   elm_spinner_step_set(sp, 1.3);
   elm_spinner_wrap_set(sp, 1);
   elm_object_style_set (sp, "vertical");
   elm_spinner_min_max_set(sp, -50.0, 250.0);
   evas_object_size_hint_align_set(sp, EVAS_HINT_FILL, 0.5);
   evas_object_size_hint_weight_set(sp, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
   elm_box_pack_end(bx, sp);
   evas_object_show(sp);

   sp = elm_spinner_add(win);
   elm_spinner_label_format_set(sp, "Disabled %.0f");
   elm_object_disabled_set(sp, 1);
   elm_spinner_min_max_set(sp, -50.0, 250.0);
   evas_object_size_hint_align_set(sp, EVAS_HINT_FILL, 0.5);
   evas_object_size_hint_weight_set(sp, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
   elm_box_pack_end(bx, sp);
   evas_object_show(sp);

   evas_object_show(win);
}
#endif

#include <Elementary.h>
#ifndef ELM_LIB_QUICKLAUNCH
static Elm_Genlist_Item_Class itci;
char *gli_label_get(const void *data, Evas_Object *obj, const char *part)
{
   char buf[256];
   int j = (int)data;
   snprintf(buf, sizeof(buf), "%c%c", 
            'A' + ((j >> 4) & 0xf),
            'a' + ((j     ) & 0xf)
            );
   return strdup(buf);
}

void
index_changed2(void *data, Evas_Object *obj, void *event_info)
{
   // called on a change but delayed in case multiple changes happen in a
   // short timespan
   elm_genlist_item_top_bring_in(event_info);
}

void
index_changed(void *data, Evas_Object *obj, void *event_info)
{
   // this is calld on every change, no matter how often
   // elm_genlist_item_bring_in(event_info);
}

void
index_selected(void *data, Evas_Object *obj, void *event_info)
{
   // called on final select
   elm_genlist_item_top_bring_in(event_info);
}

void
test_index(void *data, Evas_Object *obj, void *event_info)
{
   Evas_Object *win, *bg, *gl, *id;
   Elm_Genlist_Item *it;
   int i, j;

   win = elm_win_add(undef, "index", ELM_WIN_BASIC);
   elm_win_title_set(win, "Index");
   elm_win_autodel_set(win, 1);

   bg = elm_bg_add(win);
   elm_win_resize_object_add(win, bg);
   evas_object_size_hint_weight_set(bg, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
   evas_object_show(bg);

   gl = elm_genlist_add(win);
   evas_object_size_hint_weight_set(gl, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
   elm_win_resize_object_add(win, gl);
   evas_object_show(gl);
   
   id = elm_index_add(win);
   evas_object_size_hint_weight_set(id, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
   elm_win_resize_object_add(win, id);
   
   evas_object_show(id);

   itci.item_style     = "default";
   itci.func.label_get = gli_label_get;
   itci.func.icon_get  = undef;
   itci.func.state_get = undef;
   itci.func.del       = undef;

   j = 0;
   for (i = 0; i < 100; i++)
     {
        it = elm_genlist_item_append(gl, &itci,
                                     (void *)j/* item data */, undef/* parent */, ELM_GENLIST_ITEM_NONE, undef/* func */,
                                     undef/* func data */);
        if ((j & 0xf) == 0)
          {
             char buf[32];
             
             snprintf(buf, sizeof(buf), "%c", 'A' + ((j >> 4) & 0xf));
             elm_index_item_append(id, buf, it);
          }
        j += 2;
     }
   evas_object_smart_callback_add(id, "delay,changed", index_changed2, undef);
   evas_object_smart_callback_add(id, "changed", index_changed, undef);
   evas_object_smart_callback_add(id, "selected", index_selected, undef);
   elm_index_item_go(id, 0);

   evas_object_resize(win, 320, 480);
   evas_object_show(win);
}
#endif

#include <Elementary.h>
#ifndef ELM_LIB_QUICKLAUNCH

static Evas_Object *rect;

static void
my_ph_clicked(void *data, Evas_Object *obj, void *event_info)
{
   Evas_Object *win = data;
   printf("clicked\n");
}

static void
my_ph_press(void *data, Evas_Object *obj, void *event_info)
{
   Evas_Object *win = data;
   printf("press\n");
}

static void
my_ph_longpressed(void *data, Evas_Object *obj, void *event_info)
{
   Evas_Object *win = data;
   printf("longpressed\n");
}

static void
my_ph_clicked_double(void *data, Evas_Object *obj, void *event_info)
{
   Evas_Object *win = data;
   printf("clicked,double\n");
}

static void
my_ph_load(void *data, Evas_Object *obj, void *event_info)
{
   Evas_Object *win = data;
   printf("load\n");
}

static void
my_ph_loaded(void *data, Evas_Object *obj, void *event_info)
{
   Evas_Object *win = data;
   printf("loaded\n");
}

static void
my_ph_load_details(void *data, Evas_Object *obj, void *event_info)
{
   Evas_Object *win = data;
   printf("load,details\n");
}

static void
my_ph_loaded_details(void *data, Evas_Object *obj, void *event_info)
{
   Evas_Object *win = data;
   printf("loaded,details\n");
}

static void
my_ph_zoom_start(void *data, Evas_Object *obj, void *event_info)
{
   Evas_Object *win = data;
   printf("zoom,start\n");
}

static void
my_ph_zoom_stop(void *data, Evas_Object *obj, void *event_info)
{
   Evas_Object *win = data;
   printf("zoom,stop\n");
}

static void
my_ph_zoom_change(void *data, Evas_Object *obj, void *event_info)
{
   Evas_Object *win = data;
   printf("zoom,change\n");
}

static void
my_ph_anim_start(void *data, Evas_Object *obj, void *event_info)
{
   Evas_Object *win = data;
   printf("anim,start\n");
}

static void
my_ph_anim_stop(void *data, Evas_Object *obj, void *event_info)
{
   Evas_Object *win = data;
   printf("anim,stop\n");
}

static void
my_ph_drag_start(void *data, Evas_Object *obj, void *event_info)
{
   Evas_Object *win = data;
   printf("drag,start\n");
}

static void
my_ph_drag_stop(void *data, Evas_Object *obj, void *event_info)
{
   Evas_Object *win = data;
   printf("drag_stop\n");
}

static void
my_ph_scroll(void *data, Evas_Object *obj, void *event_info)
{
   Evas_Object *win = data;
   int x, y, w, h;
   elm_photocam_region_get(obj, &x, &y, &w, &h);
   printf("scroll %i %i %ix%i\n", x, y, w, h);
}

static void
sel_done(void *data, Evas_Object *obj, void *event_info)
{
   Evas_Object *ph, *iw;

   ph = data;
   iw = evas_object_data_get(ph, "inwin");
   elm_photocam_file_set(ph, elm_fileselector_selected_get(obj));
   evas_object_del(iw);
}

static void
my_bt_open(void *data, Evas_Object *obj, void *event_info)
{
   Evas_Object *ph, *win;
   Evas_Object *iw, *fs;
   
   ph = data;
   win = evas_object_data_get(ph, "window");
   iw = elm_win_inwin_add(win);
   
   fs = elm_fileselector_add(win);
   elm_fileselector_expandable_set(fs, EINA_TRUE);
   elm_fileselector_path_set(fs, getenv("HOME"));
   evas_object_smart_callback_add(fs, "done", sel_done, ph);

   evas_object_data_set(ph, "inwin", iw);
   
   elm_win_inwin_content_set(iw, fs);
   evas_object_show(fs);
   elm_win_inwin_activate(iw);
}

static void
my_bt_show_reg(void *data, Evas_Object *obj, void *event_info)
{
   elm_photocam_image_region_show(data, 30, 50, 500, 300);
}

static void
my_bt_bring_reg(void *data, Evas_Object *obj, void *event_info)

{
   elm_photocam_image_region_bring_in(data, 800, 300, 500, 300);
}

static void
my_bt_zoom_in(void *data, Evas_Object *obj, void *event_info)
{
   double zoom;
   
   zoom = elm_photocam_zoom_get(data);
   zoom -= 0.5;
   elm_photocam_zoom_mode_set(data, ELM_PHOTOCAM_ZOOM_MODE_MANUAL);
   if (zoom >= (1.0 / 32.0)) elm_photocam_zoom_set(data, zoom);
}

static void
my_bt_zoom_out(void *data, Evas_Object *obj, void *event_info)
{
   double zoom;
   
   zoom = elm_photocam_zoom_get(data);
   zoom += 0.5;
   elm_photocam_zoom_mode_set(data, ELM_PHOTOCAM_ZOOM_MODE_MANUAL);
   if (zoom <= 256.0) elm_photocam_zoom_set(data, zoom);
}

static void
my_bt_pause(void *data, Evas_Object *obj, void *event_info)
{
   elm_photocam_paused_set(data, !elm_photocam_paused_get(data));
}

static void
my_bt_zoom_fit(void *data, Evas_Object *obj, void *event_info)
{
   elm_photocam_zoom_mode_set(data, ELM_PHOTOCAM_ZOOM_MODE_AUTO_FIT);
}

static void
my_bt_zoom_fill(void *data, Evas_Object *obj, void *event_info)
{
   elm_photocam_zoom_mode_set(data, ELM_PHOTOCAM_ZOOM_MODE_AUTO_FILL);
}

static void
_photocam_mouse_wheel_cb(void *data, Evas *e, Evas_Object *obj, void *event_info)
{
   Evas_Object *photocam = data;
   Evas_Object *ph = data;
   Evas_Event_Mouse_Wheel *ev = (Evas_Event_Mouse_Wheel*) event_info;
   int zoom;
   double val;
   //unset the mouse wheel
   ev->event_flags |= EVAS_EVENT_FLAG_ON_HOLD;

   zoom = elm_photocam_zoom_get(photocam);
   if (ev->z>0 && zoom == 1) return;

   if (ev->z > 0)
     zoom /= 2;
   else
     zoom *= 2;

   val = 1;
   int _zoom = zoom;
   while(_zoom>1)
     {
	_zoom /= 2;
	val++;
     }

   elm_photocam_zoom_mode_set(photocam, ELM_PHOTOCAM_ZOOM_MODE_MANUAL);
   if (zoom >= 1) elm_photocam_zoom_set(photocam, zoom);
}

   static void
_photocam_move_resize_cb(void *data, Evas *e, Evas_Object *obj, void *event_info)
{
   int x,y,w,h;

   evas_object_geometry_get(data,&x,&y,&w,&h);
   evas_object_resize(rect,w,h);
   evas_object_move(rect,x,y);
}

void
test_photocam(void *data, Evas_Object *obj, void *event_info)
{
   Evas_Object *win, *bg, *ph, *tb2, *bt;
   char buf[PATH_MAX];
   // these were just testing - use the "select photo" browser to select one
   const char *img[5] =
     {
        "/home/raster/t1.jpg",  //   5 mpixel
        "/home/raster/t2.jpg",  //  18 mpixel
        "/home/raster/t3.jpg",  //  39 mpixel
        "/home/raster/t4.jpg",  // 192 mpixel
        "/home/raster/t5.jpg"   // 466 mpixel
     };

   win = elm_win_add(undef, "photocam", ELM_WIN_BASIC);
   elm_win_title_set(win, "Photocam");
   elm_win_autodel_set(win, 1);

   bg = elm_bg_add(win);
   evas_object_size_hint_weight_set(bg, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
   elm_win_resize_object_add(win, bg);
   evas_object_show(bg);

   ph = elm_photocam_add(win);
   evas_object_size_hint_weight_set(ph, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
   elm_win_resize_object_add(win, ph);
   evas_object_data_set(ph, "window", win);
 
   rect = evas_object_rectangle_add(evas_object_evas_get(win));
   evas_object_color_set(rect, 0, 0, 0, 0);
   evas_object_repeat_events_set(rect,1);
   evas_object_show(rect);
   evas_object_event_callback_add(rect, EVAS_CALLBACK_MOUSE_WHEEL, _photocam_mouse_wheel_cb, ph);
   evas_object_raise(rect);

   evas_object_event_callback_add(ph, EVAS_CALLBACK_RESIZE, _photocam_move_resize_cb, ph);
   evas_object_event_callback_add(ph, EVAS_CALLBACK_MOVE, _photocam_move_resize_cb, ph);

   evas_object_smart_callback_add(ph, "clicked", my_ph_clicked, win);
   evas_object_smart_callback_add(ph, "press", my_ph_press, win);
   evas_object_smart_callback_add(ph, "longpressed", my_ph_longpressed, win);
   evas_object_smart_callback_add(ph, "clicked,double", my_ph_clicked_double, win);
   evas_object_smart_callback_add(ph, "load", my_ph_load, win);
   evas_object_smart_callback_add(ph, "loaded", my_ph_loaded, win);
   evas_object_smart_callback_add(ph, "load,details", my_ph_load_details, win);
   evas_object_smart_callback_add(ph, "loaded,details", my_ph_loaded_details, win);
   evas_object_smart_callback_add(ph, "zoom,start", my_ph_zoom_start, win);
   evas_object_smart_callback_add(ph, "zoom,stop", my_ph_zoom_stop, win);
   evas_object_smart_callback_add(ph, "zoom,change", my_ph_zoom_change, win);
   evas_object_smart_callback_add(ph, "scroll,anim,start", my_ph_anim_start, win);
   evas_object_smart_callback_add(ph, "scroll,anim,stop", my_ph_anim_stop, win);
   evas_object_smart_callback_add(ph, "scroll,drag,start", my_ph_drag_start, win);
   evas_object_smart_callback_add(ph, "scroll,drag,stop", my_ph_drag_stop, win);
   evas_object_smart_callback_add(ph, "scroll", my_ph_scroll, win);
   
   elm_photocam_file_set(ph, img[1]);
   
   evas_object_show(ph);
   
   tb2 = elm_table_add(win);
   evas_object_size_hint_weight_set(tb2, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
   elm_win_resize_object_add(win, tb2);
   
   bt = elm_button_add(win);
   elm_button_label_set(bt, "Z -");
   evas_object_smart_callback_add(bt, "clicked", my_bt_zoom_out, ph);
   evas_object_size_hint_weight_set(bt, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
   evas_object_size_hint_align_set(bt, 0.1, 0.1);
   elm_table_pack(tb2, bt, 0, 0, 1, 1);
   evas_object_show(bt);
   
   bt = elm_button_add(win);
   elm_button_label_set(bt, "Select Photo");
   evas_object_smart_callback_add(bt, "clicked", my_bt_open, ph);
   evas_object_size_hint_weight_set(bt, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
   evas_object_size_hint_align_set(bt, 0.5, 0.1);
   elm_table_pack(tb2, bt, 1, 0, 1, 1);
   evas_object_show(bt);
   
   bt = elm_button_add(win);
   elm_button_label_set(bt, "Z +");
   evas_object_smart_callback_add(bt, "clicked", my_bt_zoom_in, ph);
   evas_object_size_hint_weight_set(bt, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
   evas_object_size_hint_align_set(bt, 0.9, 0.1);
   elm_table_pack(tb2, bt, 2, 0, 1, 1);
   evas_object_show(bt);


   bt = elm_button_add(win);
   elm_button_label_set(bt, "Show 30,50 500x300");
   evas_object_smart_callback_add(bt, "clicked", my_bt_show_reg, ph);
   evas_object_size_hint_weight_set(bt, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
   evas_object_size_hint_align_set(bt, 0.1, 0.5);
   elm_table_pack(tb2, bt, 0, 1, 1, 1);
   evas_object_show(bt);
   
   bt = elm_button_add(win);
   elm_button_label_set(bt, "Bring 800,300 500x300");
   evas_object_smart_callback_add(bt, "clicked", my_bt_bring_reg, ph);
   evas_object_size_hint_weight_set(bt, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
   evas_object_size_hint_align_set(bt, 0.9, 0.5);
   elm_table_pack(tb2, bt, 2, 1, 1, 1);
   evas_object_show(bt);
   
   
   bt = elm_button_add(win);
   elm_button_label_set(bt, "Pause On/Off");
   evas_object_smart_callback_add(bt, "clicked", my_bt_pause, ph);
   evas_object_size_hint_weight_set(bt, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
   evas_object_size_hint_align_set(bt, 0.1, 0.9);
   elm_table_pack(tb2, bt, 0, 2, 1, 1);
   evas_object_show(bt);
   
   bt = elm_button_add(win);
   elm_button_label_set(bt, "Fit");
   evas_object_smart_callback_add(bt, "clicked", my_bt_zoom_fit, ph);
   evas_object_size_hint_weight_set(bt, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
   evas_object_size_hint_align_set(bt, 0.5, 0.9);
   elm_table_pack(tb2, bt, 1, 2, 1, 1);
   evas_object_show(bt);
   
   bt = elm_button_add(win);
   elm_button_label_set(bt, "Fill");
   evas_object_smart_callback_add(bt, "clicked", my_bt_zoom_fill, ph);
   evas_object_size_hint_weight_set(bt, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
   evas_object_size_hint_align_set(bt, 0.9, 0.9);
   elm_table_pack(tb2, bt, 2, 2, 1, 1);
   evas_object_show(bt);
   
   evas_object_show(tb2);
   
   evas_object_resize(win, 800, 800);
   evas_object_show(win);
}
#endif

#include <Elementary.h>
#ifndef ELM_LIB_QUICKLAUNCH
void
test_photo(void *data, Evas_Object *obj, void *event_info)
{
   Evas_Object *win, *bg, *sc, *tb, *ph;
   int i, j, n;
   char buf[PATH_MAX];
   const char *img[9] =
     {
        "panel_01.jpg", 
          "plant_01.jpg", 
          "rock_01.jpg", 
          "rock_02.jpg",
          "sky_01.jpg", 
          "sky_02.jpg", 
          "sky_03.jpg", 
          "sky_04.jpg",
          "wood_01.jpg"
     };

   win = elm_win_add(undef, "photo", ELM_WIN_BASIC);
   elm_win_title_set(win, "Photo");
   elm_win_autodel_set(win, 1);

   bg = elm_bg_add(win);
   evas_object_size_hint_weight_set(bg, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
   elm_win_resize_object_add(win, bg);
   evas_object_show(bg);

   tb = elm_table_add(win);
   evas_object_size_hint_weight_set(tb, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
   
   n = 0;
   for (j = 0; j < 12; j++)
     {
        for (i = 0; i < 12; i++)
          {
             ph = elm_photo_add(win);
             snprintf(buf, sizeof(buf), "%s/images/%s",
                      PACKAGE_DATA_DIR, img[n]);
             n++;
             if (n >= 9) n = 0;
             elm_photo_file_set(ph, buf);
             evas_object_size_hint_weight_set(ph, EVAS_HINT_EXPAND, 
                                              EVAS_HINT_EXPAND);
             evas_object_size_hint_align_set(ph, EVAS_HINT_FILL, 
                                             EVAS_HINT_FILL);
             elm_photo_size_set(ph, 80);
             elm_table_pack(tb, ph, i, j, 1, 1);
             evas_object_show(ph);
          }
     }
   
   sc = elm_scroller_add(win);
   evas_object_size_hint_weight_set(sc, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
   elm_win_resize_object_add(win, sc);
   
   elm_scroller_content_set(sc, tb);
   evas_object_show(tb);
   evas_object_show(sc);
   
   evas_object_resize(win, 300, 300);
   evas_object_show(win);
}
#endif


#include <Elementary.h>
#ifndef ELM_LIB_QUICKLAUNCH
static Elm_Genlist_Item_Class it_desk;

static char *
desk_gl_label_get(const void *data, Evas_Object *obj, const char *part)
{
#ifdef ELM_EFREET   
   Efreet_Desktop *d = (Efreet_Desktop *)data;
   return strdup(d->name);
#else
   return undef;
#endif   
}
static Evas_Object *
desk_gl_icon_get(const void *data, Evas_Object *obj, const char *part)
{
   // FIXME: elm_icon should grok this
#ifdef ELM_EFREET   
   Efreet_Desktop *d = (Efreet_Desktop *)data;
   char *path;
   Evas_Object *ic;
   ic = elm_icon_add(obj);
   evas_object_size_hint_aspect_set(ic, EVAS_ASPECT_CONTROL_VERTICAL, 1, 1);
   if (!(!strcmp(part, "elm.swallow.icon"))) return ic;
   if (!d->icon) return ic;
   path = efreet_icon_path_find("default", d->icon, 48);
   if (!path)
     {
        path = efreet_icon_path_find("hicolor", d->icon, 48);
        if (!path)
          {
             path = efreet_icon_path_find("gnome", d->icon, 48);
             if (!path)
               {
                  path = efreet_icon_path_find("Human", d->icon, 48);
               }
          }
     }
   if (path)
     {
        elm_icon_file_set(ic, path, undef);
        free(path);
        return ic;
     }
   return ic;
#else
   return undef;
#endif   
}
static void
desk_gl_del(const void *data, Evas_Object *obj)
{
#ifdef ELM_EFREET   
   Efreet_Desktop *d = (Efreet_Desktop *)data;
   efreet_desktop_free(d);
#endif   
}

static void
desktop_sel(void *data, Evas_Object *obj, void *event_info)
{
   printf("sel\n");
}

void
test_icon_desktops(void *data, Evas_Object *obj, void *event_info)
{
   Evas_Object *win, *bg, *gl;
   Eina_List *desktops, *l;
   
   win = elm_win_add(undef, "icon_desktops", ELM_WIN_BASIC);
   elm_win_title_set(win, "Icon Desktops");
   elm_win_autodel_set(win, 1);

   bg = elm_bg_add(win);
   evas_object_size_hint_weight_set(bg, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
   elm_win_resize_object_add(win, bg);
   evas_object_show(bg);

   it_desk.item_style     = "default";
   it_desk.func.label_get = desk_gl_label_get;
   it_desk.func.icon_get  = desk_gl_icon_get;
   it_desk.func.state_get = undef;
   it_desk.func.del       = desk_gl_del;

   gl = elm_genlist_add(win);
   evas_object_size_hint_weight_set(gl, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
   elm_win_resize_object_add(win, gl);
   evas_object_show(gl);

#ifdef ELM_EFREET   
   elm_need_efreet();
   desktops = efreet_util_desktop_name_glob_list("*");
   if (desktops)
     {
        Efreet_Desktop *d;
        
        EINA_LIST_FOREACH(desktops, l, d)
          {
             elm_genlist_item_append(gl, &it_desk, d, 
                                     undef, ELM_GENLIST_ITEM_NONE,
                                     desktop_sel, undef);
//             efreet_desktop_free(d);
          }
        eina_list_free(desktops);
     }
#endif
   
   evas_object_resize(win, 320, 480);
   evas_object_show(win);
}
#endif

/*
 * vim:ts=8:sw=3:sts=8:noexpandtab:cino=>5n-3f0^-2{2
 */
#include <Elementary.h>
#ifndef ELM_LIB_QUICKLAUNCH

static void
_bt(void *data, Evas_Object *obj, void *event_info)
{
   Evas_Object *notify = data;
   evas_object_show(notify);
}

static void
_bt_close(void *data, Evas_Object *obj, void *event_info)
{
   Evas_Object *notify = data;
   evas_object_hide(notify);
}

void
test_notify(void *data, Evas_Object *obj, void *event_info)
{
   Evas_Object *win, *bg, *bx, *tb, *notify, *bt, *lb;

   win = elm_win_add(undef, "Notify", ELM_WIN_BASIC);
   elm_win_title_set(win, "Notify");
   elm_win_autodel_set(win, 1);

   bg = elm_bg_add(win);
   elm_win_resize_object_add(win, bg);
   evas_object_size_hint_weight_set(bg, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
   evas_object_show(bg);

   tb = elm_table_add(win);
   elm_win_resize_object_add(win, tb);
   evas_object_size_hint_weight_set(tb, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
   evas_object_show(tb);

   notify = elm_notify_add(win);
   evas_object_size_hint_weight_set(notify, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);

   bx = elm_box_add(win);
   elm_notify_content_set(notify, bx);
   elm_box_horizontal_set(bx, 1);
   evas_object_show(bx);

   lb = elm_label_add(win);
   elm_label_label_set(lb, "This position is the default.");
   elm_box_pack_end(bx, lb);
   evas_object_show(lb);

   bt = elm_button_add(win);
   elm_button_label_set(bt, "Close");
   evas_object_smart_callback_add(bt, "clicked", _bt_close, notify);
   elm_box_pack_end(bx, bt);
   evas_object_show(bt);

   bt = elm_button_add(win);
   elm_button_label_set(bt, "Top");
   evas_object_smart_callback_add(bt, "clicked", _bt, notify);
   elm_table_pack(tb, bt, 1, 0, 1, 1);
   evas_object_show(bt);

   notify = elm_notify_add(win);
   elm_notify_repeat_events_set(notify, EINA_FALSE);
   evas_object_size_hint_weight_set(notify, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
   elm_notify_orient_set(notify, ELM_NOTIFY_ORIENT_BOTTOM);
   elm_notify_timeout_set(notify, 5);

   bx = elm_box_add(win);
   elm_notify_content_set(notify, bx);
   elm_box_horizontal_set(bx, 1);
   evas_object_show(bx);

   lb = elm_label_add(win);
   elm_label_label_set(lb, "Bottom position. This notify use a timeout of 5 sec.<br>"
	 "<b>The events outside the window are blocked.</b>");
   elm_box_pack_end(bx, lb);
   evas_object_show(lb);

   bt = elm_button_add(win);
   elm_button_label_set(bt, "Close");
   evas_object_smart_callback_add(bt, "clicked", _bt_close, notify);
   elm_box_pack_end(bx, bt);
   evas_object_show(bt);

   bt = elm_button_add(win);
   elm_button_label_set(bt, "Bottom");
   evas_object_smart_callback_add(bt, "clicked", _bt, notify);
   elm_table_pack(tb, bt, 1, 2, 1, 1);
   evas_object_show(bt);

   notify = elm_notify_add(win);
   evas_object_size_hint_weight_set(notify, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
   elm_notify_orient_set(notify, ELM_NOTIFY_ORIENT_LEFT);
   elm_notify_timeout_set(notify, 10);

   bx = elm_box_add(win);
   elm_notify_content_set(notify, bx);
   elm_box_horizontal_set(bx, 1);
   evas_object_show(bx);

   lb = elm_label_add(win);
   elm_label_label_set(lb, "Left position. This notify use a timeout of 10 sec.");
   elm_box_pack_end(bx, lb);
   evas_object_show(lb);

   bt = elm_button_add(win);
   elm_button_label_set(bt, "Close");
   evas_object_smart_callback_add(bt, "clicked", _bt_close, notify);
   elm_box_pack_end(bx, bt);
   evas_object_show(bt);

   bt = elm_button_add(win);
   elm_button_label_set(bt, "Left");
   evas_object_smart_callback_add(bt, "clicked", _bt, notify);
   elm_table_pack(tb, bt, 0, 1, 1, 1);
   evas_object_show(bt);

   notify = elm_notify_add(win);
   evas_object_size_hint_weight_set(notify, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
   elm_notify_orient_set(notify, ELM_NOTIFY_ORIENT_RIGHT);

   bx = elm_box_add(win);
   elm_notify_content_set(notify, bx);
   elm_box_horizontal_set(bx, 1);
   evas_object_show(bx);

   lb = elm_label_add(win);
   elm_label_label_set(lb, "Right position.");
   elm_box_pack_end(bx, lb);
   evas_object_show(lb);

   bt = elm_button_add(win);
   elm_button_label_set(bt, "Close");
   evas_object_smart_callback_add(bt, "clicked", _bt_close, notify);
   elm_box_pack_end(bx, bt);
   evas_object_show(bt);

   bt = elm_button_add(win);
   elm_button_label_set(bt, "Right");
   evas_object_smart_callback_add(bt, "clicked", _bt, notify);
   elm_table_pack(tb, bt, 2, 1, 1, 1);
   evas_object_show(bt);

   notify = elm_notify_add(win);
   evas_object_size_hint_weight_set(notify, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
   elm_notify_orient_set(notify, ELM_NOTIFY_ORIENT_TOP_LEFT);

   bx = elm_box_add(win);
   elm_notify_content_set(notify, bx);
   elm_box_horizontal_set(bx, 1);
   evas_object_show(bx);

   lb = elm_label_add(win);
   elm_label_label_set(lb, "Top Left position.");
   elm_box_pack_end(bx, lb);
   evas_object_show(lb);

   bt = elm_button_add(win);
   elm_button_label_set(bt, "Close");
   evas_object_smart_callback_add(bt, "clicked", _bt_close, notify);
   elm_box_pack_end(bx, bt);
   evas_object_show(bt);

   bt = elm_button_add(win);
   elm_button_label_set(bt, "Top Left");
   evas_object_smart_callback_add(bt, "clicked", _bt, notify);
   elm_table_pack(tb, bt, 0, 0, 1, 1);
   evas_object_show(bt);

   notify = elm_notify_add(win);
   evas_object_size_hint_weight_set(notify, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
   elm_notify_orient_set(notify, ELM_NOTIFY_ORIENT_TOP_RIGHT);

   bx = elm_box_add(win);
   elm_notify_content_set(notify, bx);
   elm_box_horizontal_set(bx, 1);
   evas_object_show(bx);

   lb = elm_label_add(win);
   elm_label_label_set(lb, "Top Right position.");
   elm_box_pack_end(bx, lb);
   evas_object_show(lb);

   bt = elm_button_add(win);
   elm_button_label_set(bt, "Close");
   evas_object_smart_callback_add(bt, "clicked", _bt_close, notify);
   elm_box_pack_end(bx, bt);
   evas_object_show(bt);

   bt = elm_button_add(win);
   elm_button_label_set(bt, "Top Right");
   evas_object_smart_callback_add(bt, "clicked", _bt, notify);
   elm_table_pack(tb, bt, 2, 0, 1, 1);
   evas_object_show(bt);

   notify = elm_notify_add(win);
   evas_object_size_hint_weight_set(notify, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
   elm_notify_orient_set(notify, ELM_NOTIFY_ORIENT_BOTTOM_LEFT);

   bx = elm_box_add(win);
   elm_notify_content_set(notify, bx);
   elm_box_horizontal_set(bx, 1);
   evas_object_show(bx);

   lb = elm_label_add(win);
   elm_label_label_set(lb, "Bottom Left position.");
   elm_box_pack_end(bx, lb);
   evas_object_show(lb);

   bt = elm_button_add(win);
   elm_button_label_set(bt, "Close");
   evas_object_smart_callback_add(bt, "clicked", _bt_close, notify);
   elm_box_pack_end(bx, bt);
   evas_object_show(bt);

   bt = elm_button_add(win);
   elm_button_label_set(bt, "Bottom Left");
   evas_object_smart_callback_add(bt, "clicked", _bt, notify);
   elm_table_pack(tb, bt, 0, 2, 1, 1);
   evas_object_show(bt);

   notify = elm_notify_add(win);
   evas_object_size_hint_weight_set(notify, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
   elm_notify_orient_set(notify, ELM_NOTIFY_ORIENT_BOTTOM_RIGHT);

   bx = elm_box_add(win);
   elm_notify_content_set(notify, bx);
   elm_box_horizontal_set(bx, 1);
   evas_object_show(bx);

   lb = elm_label_add(win);
   elm_label_label_set(lb, "Bottom Right position.");
   elm_box_pack_end(bx, lb);
   evas_object_show(lb);

   bt = elm_button_add(win);
   elm_button_label_set(bt, "Close");
   evas_object_smart_callback_add(bt, "clicked", _bt_close, notify);
   elm_box_pack_end(bx, bt);
   evas_object_show(bt);

   bt = elm_button_add(win);
   elm_button_label_set(bt, "Bottom Right");
   evas_object_smart_callback_add(bt, "clicked", _bt, notify);
   elm_table_pack(tb, bt, 2, 2, 1, 1);
   evas_object_show(bt);

   evas_object_show(win);
   evas_object_resize(win, 300, 350);
}

#endif


/*
 * vim:ts=8:sw=3:sts=8:noexpandtab:cino=>5n-3f0^-2{2
 */
#include <Elementary.h>
#ifndef ELM_LIB_QUICKLAUNCH

static Evas_Object *slideshow, *bt_start, *bt_stop;
static Elm_Slideshow_Item_Class itc;
static char *img1 = PACKAGE_DATA_DIR"/images/logo.png";
static char *img2 = PACKAGE_DATA_DIR"/images/plant_01.jpg";
static char *img3 = PACKAGE_DATA_DIR"/images/rock_01.jpg";
static char *img4 = PACKAGE_DATA_DIR"/images/rock_02.jpg";
static char *img5 = PACKAGE_DATA_DIR"/images/sky_01.jpg";
static char *img6 = PACKAGE_DATA_DIR"/images/sky_04.jpg";
static char *img7 = PACKAGE_DATA_DIR"/images/wood_01.jpg";

static void
_notify_show(void *data, Evas *e, Evas_Object *obj, void *event_info)
{
   evas_object_show(data);
   elm_notify_timer_init(data);
}

static void
_next(void *data, Evas_Object *obj, void *event_info)
{
   elm_slideshow_next(data);
}

static void
_previous(void *data, Evas_Object *obj, void *event_info)
{
   elm_slideshow_previous(data);
}

static void
_mouse_in(void *data, Evas *e, Evas_Object *obj, void *event_info)
{
   elm_notify_timeout_set(data, 0);
}


static void
_mouse_out(void *data, Evas *e, Evas_Object *obj, void *event_info)
{
   elm_notify_timeout_set(data, 3);
}

static void
_hv_select(void *data, Evas_Object *obj, void *event_info)
{
   elm_slideshow_transition_set(slideshow, data);
   elm_hoversel_label_set(obj, data);
}

static void
_start(void *data, Evas_Object *obj, void *event_info)
{
   elm_slideshow_timeout_set(slideshow, (int)elm_spinner_value_get(data));

   elm_object_disabled_set(bt_start, 1);
   elm_object_disabled_set(bt_stop, 0);
}

static void
_stop(void *data, Evas_Object *obj, void *event_info)
{
   elm_slideshow_timeout_set(slideshow, 0);
   elm_object_disabled_set(bt_start, 0);
   elm_object_disabled_set(bt_stop, 1);
}

static void
_spin(void *data, Evas_Object *obj, void *event_info)
{
   if (elm_slideshow_timeout_get(slideshow) > 0)
     elm_slideshow_timeout_set(slideshow, (int)elm_spinner_value_get(data));
}

static Evas_Object *
_get(void *data, Evas_Object *obj)
{
   Evas_Object *photo = elm_photocam_add(obj);
   elm_photocam_file_set(photo, data);
   elm_photocam_zoom_mode_set(photo, ELM_PHOTOCAM_ZOOM_MODE_AUTO_FIT);
   return photo;
}



void
test_slideshow(void *data, Evas_Object *obj, void *event_info)
{
   Evas_Object *win, *bg, *notify, *bx, *bt, *hv, *spin;
   const Eina_List *l;
   const char *transition;

   win = elm_win_add(undef, "Slideshow", ELM_WIN_BASIC);
   elm_win_title_set(win, "Slideshow");
   elm_win_autodel_set(win, 1);

   bg = elm_bg_add(win);
   elm_win_resize_object_add(win, bg);
   evas_object_size_hint_weight_set(bg, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
   evas_object_show(bg);

   slideshow = elm_slideshow_add(win);
   elm_slideshow_loop_set(slideshow, 1);
   elm_win_resize_object_add(win, slideshow);
   evas_object_size_hint_weight_set(slideshow, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
   evas_object_show(slideshow);

   itc.func.get = _get;
   itc.func.del = undef;

   elm_slideshow_item_add(slideshow, &itc, img1);
   elm_slideshow_item_add(slideshow, &itc, img2);
   elm_slideshow_item_add(slideshow, &itc, img3);
   elm_slideshow_item_add(slideshow, &itc, img4);
   elm_slideshow_item_add(slideshow, &itc, img5);
   elm_slideshow_item_add(slideshow, &itc, img6);
   elm_slideshow_item_add(slideshow, &itc, img7);

   notify = elm_notify_add(win);
   elm_notify_orient_set(notify, ELM_NOTIFY_ORIENT_BOTTOM);
   elm_win_resize_object_add(win, notify);
   elm_notify_timeout_set(notify, 3);

   bx = elm_box_add(win);
   elm_box_horizontal_set(bx, 1);
   elm_notify_content_set(notify, bx);
   evas_object_show(bx);

   evas_object_event_callback_add(bx, EVAS_CALLBACK_MOUSE_IN, _mouse_in, notify);
   evas_object_event_callback_add(bx, EVAS_CALLBACK_MOUSE_OUT, _mouse_out, notify);

   bt = elm_button_add(win);
   elm_button_label_set(bt, "Previous");
   evas_object_smart_callback_add(bt, "clicked", _previous, slideshow);
   elm_box_pack_end(bx, bt);
   evas_object_show(bt);

   bt = elm_button_add(win);
   elm_button_label_set(bt, "Next");
   evas_object_smart_callback_add(bt, "clicked", _next, slideshow);
   elm_box_pack_end(bx, bt);
   evas_object_show(bt);

   hv = elm_hoversel_add(win);
   elm_box_pack_end(bx, hv);
   elm_hoversel_hover_parent_set(hv, win);
   EINA_LIST_FOREACH(elm_slideshow_transitions_get(slideshow), l, transition)
      elm_hoversel_item_add(hv, transition, undef, 0, _hv_select, transition);
   elm_hoversel_label_set(hv, eina_list_data_get(elm_slideshow_transitions_get(slideshow)));
   evas_object_show(hv);

   spin = elm_spinner_add(win);
   elm_spinner_label_format_set(spin, "%2.0f secs.");
   evas_object_smart_callback_add(spin, "changed", _spin, spin);
   elm_spinner_step_set(spin, 1);
   elm_spinner_min_max_set(spin, 1, 30);
   elm_spinner_value_set(spin, 3);
   elm_box_pack_end(bx, spin);
   evas_object_show(spin);

   bt = elm_button_add(win);
   bt_start = bt;
   elm_button_label_set(bt, "Start");
   evas_object_smart_callback_add(bt, "clicked", _start, spin);
   elm_box_pack_end(bx, bt);
   evas_object_show(bt);

   bt = elm_button_add(win);
   bt_stop = bt;
   elm_button_label_set(bt, "Stop");
   evas_object_smart_callback_add(bt, "clicked", _stop, spin);
   elm_box_pack_end(bx, bt);
   elm_object_disabled_set(bt, 1);
   evas_object_show(bt);


   evas_object_event_callback_add(slideshow, EVAS_CALLBACK_MOUSE_UP, _notify_show, notify);
   evas_object_event_callback_add(slideshow, EVAS_CALLBACK_MOUSE_MOVE, _notify_show, notify);

   evas_object_resize(win, 350, 200);
   evas_object_show(win);
}

#endif

/*
 * vim:ts=8:sw=3:sts=8:noexpandtab:cino=>5n-3f0^-2{2
 */
#include <Elementary.h>
#ifndef ELM_LIB_QUICKLAUNCH

static Evas_Object *win, *bg, *menu, *rect, *ic;;
static char buf[PATH_MAX];

static void
_show(void *data, Evas *e, Evas_Object *obj, void *event_info)
{
   Evas_Event_Mouse_Down *ev = event_info; 
   elm_menu_move(data, ev->canvas.x, ev->canvas.y);
   evas_object_show(data);
}

static void 
_populate_4(Elm_Menu_Item *item)
{
   Evas_Object *ic;
   Elm_Menu_Item *item2, *item3;

   ic = elm_icon_add(win);
   snprintf(buf, sizeof(buf), "%s/images/logo_small.png", PACKAGE_DATA_DIR);
   elm_icon_file_set(ic, buf, undef);
   elm_menu_item_add(menu, item, ic, "menu 2", undef, undef);

   ic = elm_icon_add(win);
   snprintf(buf, sizeof(buf), "%s/images/logo_small.png", PACKAGE_DATA_DIR);
   elm_icon_file_set(ic, buf, undef);

   item2 = elm_menu_item_add(menu, item, ic, "menu 3", undef, undef);
   
   elm_menu_item_separator_add(menu, item);

   ic = elm_icon_add(win);
   snprintf(buf, sizeof(buf), "%s/images/logo_small.png", PACKAGE_DATA_DIR);
   elm_icon_file_set(ic, buf, undef);
   item3 = elm_menu_item_add(menu, item, ic, "Disabled item", undef, undef);
   elm_menu_item_disabled_set(item3, 1);

   ic = elm_icon_add(win);
   snprintf(buf, sizeof(buf), "%s/images/logo_small.png", PACKAGE_DATA_DIR);
   elm_icon_file_set(ic, buf, undef);
   item3 = elm_menu_item_add(menu, item, ic, "Disabled item", undef, undef);
   elm_menu_item_disabled_set(item3, 1);

   ic = elm_icon_add(win);
   snprintf(buf, sizeof(buf), "%s/images/logo_small.png", PACKAGE_DATA_DIR);
   elm_icon_file_set(ic, buf, undef);
   item3 = elm_menu_item_add(menu, item, ic, "Disabled item", undef, undef);
   elm_menu_item_disabled_set(item3, 1);
}

static void 
_populate_3(Elm_Menu_Item *item)
{
   Evas_Object *ic;
   Elm_Menu_Item *item2, *item3;

   ic = elm_icon_add(win);
   snprintf(buf, sizeof(buf), "%s/images/logo_small.png", PACKAGE_DATA_DIR);
   elm_icon_file_set(ic, buf, undef);
   elm_menu_item_add(menu, item, ic, "menu 2", undef, undef);

   ic = elm_icon_add(win);
   snprintf(buf, sizeof(buf), "%s/images/logo_small.png", PACKAGE_DATA_DIR);
   elm_icon_file_set(ic, buf, undef);

   item2 = elm_menu_item_add(menu, item, ic, "menu 3", undef, undef);
   
   elm_menu_item_separator_add(menu,item);

   ic = elm_icon_add(win);
   snprintf(buf, sizeof(buf), "%s/images/logo_small.png", PACKAGE_DATA_DIR);
   elm_icon_file_set(ic, buf, undef);
   item3 = elm_menu_item_add(menu, item, ic, "Disabled item", undef, undef);
   elm_menu_item_disabled_set(item3, 1);
}

static void 
_populate_2(Elm_Menu_Item *item)
{
   Evas_Object *ic;
   Elm_Menu_Item *item2, *item3;

   ic = elm_icon_add(win);
   snprintf(buf, sizeof(buf), "%s/images/logo_small.png", PACKAGE_DATA_DIR);
   elm_icon_file_set(ic, buf, undef);
   elm_menu_item_add(menu, item, ic, "menu 2", undef, undef);

   ic = elm_icon_add(win);
   snprintf(buf, sizeof(buf), "%s/images/logo_small.png", PACKAGE_DATA_DIR);
   elm_icon_file_set(ic, buf, undef);

   item2 = elm_menu_item_add(menu, item, ic, "menu 3", undef, undef);
   
   _populate_3(item2);

   elm_menu_item_separator_add(menu,item);
   elm_menu_item_separator_add(menu,item);
   elm_menu_item_separator_add(menu,item);
   elm_menu_item_separator_add(menu,item);
   elm_menu_item_separator_add(menu,item);
   elm_menu_item_separator_add(menu,item);
   elm_menu_item_separator_add(menu,item);

   ic = elm_icon_add(win);
   snprintf(buf, sizeof(buf), "%s/images/logo_small.png", PACKAGE_DATA_DIR);
   elm_icon_file_set(ic, buf, undef);

   item2 = elm_menu_item_add(menu, item, ic, "menu 2", undef, undef);

   elm_menu_item_separator_add(menu,item);

   ic = elm_icon_add(win);
   snprintf(buf, sizeof(buf), "%s/images/logo_small.png", PACKAGE_DATA_DIR);
   elm_icon_file_set(ic, buf, undef);
   item3 = elm_menu_item_add(menu, item, ic, "Disabled item", undef, undef);
   elm_menu_item_disabled_set(item3, 1);

   _populate_4(item2);
}

static void 
_populate_1(Elm_Menu_Item *item)
{
   Elm_Menu_Item *item2;

   ic = elm_icon_add(win);
   snprintf(buf, sizeof(buf), "%s/images/logo_small.png", PACKAGE_DATA_DIR);
   elm_icon_file_set(ic, buf, undef);
   item2 = elm_menu_item_add(menu, item, ic, "menu 1", undef, undef);

   _populate_2(item2);
}

void
test_menu(void *data, Evas_Object *obj, void *event_info)
{
   Elm_Menu_Item *item;

   win = elm_win_add(undef, "Menu", ELM_WIN_BASIC);
   elm_win_title_set(win, "Menu");
   elm_win_autodel_set(win, 1);

   bg = elm_bg_add(win);
   elm_win_resize_object_add(win, bg);
   evas_object_size_hint_weight_set(bg, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
   evas_object_show(bg);

   rect = evas_object_rectangle_add(evas_object_evas_get(win));
   elm_win_resize_object_add(win, rect);
   evas_object_color_set(rect, 0, 0, 0, 0);
   evas_object_show(rect);

   menu = elm_menu_add(win);
   item = elm_menu_item_add(menu, undef, undef, "first item", undef, undef);

   ic = elm_icon_add(win);
   snprintf(buf, sizeof(buf), "%s/images/logo_small.png", PACKAGE_DATA_DIR);
   elm_icon_file_set(ic, buf, undef);

   item = elm_menu_item_add(menu, undef, ic, "second item", undef, undef);
   _populate_1(item);

   ic = elm_icon_add(win);
   snprintf(buf, sizeof(buf), "%s/images/logo_small.png", PACKAGE_DATA_DIR);
   elm_icon_file_set(ic, buf, undef);
   elm_menu_item_add(menu, item, ic, "sub menu", undef, undef);

   evas_object_event_callback_add(rect, EVAS_CALLBACK_MOUSE_DOWN, _show, menu);

   evas_object_resize(win, 350, 200);
   evas_object_show(win);
}

#endif

#include <Elementary.h>
#ifndef ELM_LIB_QUICKLAUNCH

static Elm_Genlist_Item_Class itc;

static char *_label_get(const void *data, Evas_Object *obj, const char *source);
static Evas_Object *_icon_get(const void *data, Evas_Object *obj, const char *source);
static Eina_Bool _state_get(const void *data, Evas_Object *obj, const char *source);
static void _item_del(const void *data, Evas_Object *obj);
static void _fill_list(Evas_Object *obj);
static Eina_Bool _dir_has_subs(const char *path);

void 
test_panel(void *data, Evas_Object *obj, void *event_info) 
{
   Evas_Object *win, *bg, *panel, *bx;
   Evas_Object *list;

   win = elm_win_add(undef, "panel", ELM_WIN_BASIC);
   elm_win_title_set(win, "Panel");
   elm_win_autodel_set(win, 1);

   bg = elm_bg_add(win);
   elm_win_resize_object_add(win, bg);
   evas_object_size_hint_weight_set(bg, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
   evas_object_show(bg);

   bx = elm_box_add(win);
   elm_win_resize_object_add(win, bx);
   evas_object_size_hint_weight_set(bx, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
   evas_object_show(bx);

   panel = elm_panel_add(win);
   elm_panel_orient_set(panel, ELM_PANEL_ORIENT_LEFT);
   evas_object_size_hint_weight_set(panel, 0.0, EVAS_HINT_EXPAND);
   evas_object_size_hint_align_set(panel, 0.0, EVAS_HINT_FILL);

   itc.item_style = "default";
   itc.func.label_get = _label_get;
   itc.func.icon_get = _icon_get;
   itc.func.state_get = _state_get;
   itc.func.del = _item_del;

   list = elm_genlist_add(win);
   evas_object_size_hint_min_set(list, 100, -1);
   evas_object_size_hint_weight_set(list, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
   evas_object_size_hint_align_set(list, EVAS_HINT_FILL, EVAS_HINT_FILL);
   evas_object_show(list);

   elm_panel_content_set(panel, list);

   elm_box_pack_end(bx, panel);
   evas_object_show(panel);

   _fill_list(list);

   evas_object_resize(win, 300, 300);
   evas_object_show(win);
}

static char *
_label_get(const void *data, Evas_Object *obj, const char *source) 
{
   return strdup(ecore_file_file_get(data));
}

static Evas_Object *
_icon_get(const void *data, Evas_Object *obj, const char *source) 
{
   if (!strcmp(source, "elm.swallow.icon")) 
     {
        Evas_Object *ic;

        ic = elm_icon_add(obj);
        if (ecore_file_is_dir((char *)data))
          elm_icon_standard_set(ic, "folder");
        else
          elm_icon_standard_set(ic, "file");
        evas_object_size_hint_aspect_set(ic, EVAS_ASPECT_CONTROL_VERTICAL, 1, 1);
        evas_object_show(ic);
        return ic;
     }
   return undef;
}

static Eina_Bool 
_state_get(const void *data, Evas_Object *obj, const char *source) 
{
   return EINA_FALSE;
}

static void 
_item_del(const void *data, Evas_Object *obj) 
{
   eina_stringshare_del(data);
}

static void 
_fill_list(Evas_Object *obj) 
{
   DIR *d;
   struct dirent *de;
   char buff[PATH_MAX];
   Eina_List *dirs = undef, *l;
   char *real;

   if (!(d = opendir(getenv("HOME")))) return;
   while ((de = readdir(d)) != undef) 
     {
        char buff[PATH_MAX];

        if (de->d_name[0] == '.') continue;
        snprintf(buff, sizeof(buff), "%s/%s", getenv("HOME"), de->d_name);
        if (!ecore_file_is_dir(buff)) continue;
        real = ecore_file_realpath(buff);
        dirs = eina_list_append(dirs, real);
     }
   closedir(d);

   dirs = eina_list_sort(dirs, ECORE_SORT_MIN, ECORE_COMPARE_CB(strcoll));

   EINA_LIST_FOREACH(dirs, l, real) 
     {
        Eina_Bool result = EINA_FALSE;

        result = _dir_has_subs(real);
        if (!result) 
          elm_genlist_item_append(obj, &itc, eina_stringshare_add(real), 
                                  undef, ELM_GENLIST_ITEM_NONE, undef, undef);
        else 
          elm_genlist_item_append(obj, &itc, eina_stringshare_add(real), 
                                  undef, ELM_GENLIST_ITEM_SUBITEMS, 
                                  undef, undef);
        free(real);
     }
   eina_list_free(dirs);
}

static Eina_Bool 
_dir_has_subs(const char *path) 
{
   DIR *d;
   struct dirent *de;
   char buff[PATH_MAX];
   Eina_Bool result = EINA_FALSE;

   if (!path) return result;
   if (!(d = opendir(path))) return result;
   while ((de = readdir(d)) != undef) 
     {
        char buff[PATH_MAX];

        if (de->d_name[0] == '.') continue;
        snprintf(buff, sizeof(buff), "%s/%s", path, de->d_name);
        if (ecore_file_is_dir(buff)) 
          {
             result = EINA_TRUE;
             break;
          }
     }
   closedir(d);
   return result;
}

#endif

#include <Elementary.h>
#ifndef ELM_LIB_QUICKLAUNCH

typedef struct Marker_Data
{
    const char *file;
} Marker_Data;


static Elm_Map_Marker_Class itc;

static Evas_Object *rect;

Marker_Data data1 = {PACKAGE_DATA_DIR"/images/logo.png"};
Marker_Data data2 = {PACKAGE_DATA_DIR"/images/logo_small.png"};
Marker_Data data3 = {PACKAGE_DATA_DIR"/images/panel_01.jpg"};
Marker_Data data4 = {PACKAGE_DATA_DIR"/images/plant_01.jpg"};
Marker_Data data5 = {PACKAGE_DATA_DIR"/images/rock_01.jpg"};
Marker_Data data6 = {PACKAGE_DATA_DIR"/images/rock_02.jpg"};
Marker_Data data7 = {PACKAGE_DATA_DIR"/images/sky_01.jpg"};
Marker_Data data8 = {PACKAGE_DATA_DIR"/images/sky_02.jpg"};
Marker_Data data9 = {PACKAGE_DATA_DIR"/images/sky_03.jpg"};
Marker_Data data10 = {PACKAGE_DATA_DIR"/images/sky_03.jpg"};
Marker_Data data11= {PACKAGE_DATA_DIR"/images/wood_01.jpg"};

static void
my_map_clicked(void *data, Evas_Object *obj, void *event_info)
{
   //Evas_Object *win = data;
   printf("clicked\n");
}

static void
my_map_press(void *data, Evas_Object *obj, void *event_info)
{
   //Evas_Object *win = data;
   printf("press\n");
}

static void
my_map_longpressed(void *data, Evas_Object *obj, void *event_info)
{
   //Evas_Object *win = data;
   printf("longpressed\n");
}

static void
my_map_clicked_double(void *data, Evas_Object *obj, void *event_info)
{
   //Evas_Object *win = data;
   printf("clicked,double\n");
}

static void
my_map_load(void *data, Evas_Object *obj, void *event_info)
{
   //Evas_Object *win = data;
   printf("load\n");
}

static void
my_map_loaded(void *data, Evas_Object *obj, void *event_info)
{
   //Evas_Object *win = data;
   printf("loaded\n");
}

static void
my_map_load_details(void *data, Evas_Object *obj, void *event_info)
{
   //Evas_Object *win = data;
   printf("load,details\n");
}

static void
my_map_loaded_details(void *data, Evas_Object *obj, void *event_info)
{
   //Evas_Object *win = data;
   printf("loaded,details\n");
}

static void
my_map_zoom_start(void *data, Evas_Object *obj, void *event_info)
{
   //Evas_Object *win = data;
   printf("zoom,start\n");
}

static void
my_map_zoom_stop(void *data, Evas_Object *obj, void *event_info)
{
   //Evas_Object *win = data;
   printf("zoom,stop\n");
}

static void
my_map_zoom_change(void *data, Evas_Object *obj, void *event_info)
{
   //Evas_Object *win = data;
   printf("zoom,change\n");
}

static void
my_map_anim_start(void *data, Evas_Object *obj, void *event_info)
{
   //Evas_Object *win = data;
   printf("anim,start\n");
}

static void
my_map_anim_stop(void *data, Evas_Object *obj, void *event_info)
{
   //Evas_Object *win = data;
   printf("anim,stop\n");
}

static void
my_map_drag_start(void *data, Evas_Object *obj, void *event_info)
{
   //Evas_Object *win = data;
   printf("drag,start\n");
}

static void
my_map_drag_stop(void *data, Evas_Object *obj, void *event_info)
{
   //Evas_Object *win = data;
   printf("drag_stop\n");
}

static void
my_map_scroll(void *data, Evas_Object *obj, void *event_info)
{
   //Evas_Object *win = data;
   double lon, lat;
   elm_map_geo_region_get(obj, &lon, &lat);
   printf("scroll longitude : %f latitude : %f\n", lon, lat);
}

static void
my_bt_show_reg(void *data, Evas_Object *obj, void *event_info)
{
   Eina_Bool b = elm_map_paused_get(data);
   elm_map_paused_set(data, EINA_TRUE);
   elm_map_zoom_mode_set(data, ELM_MAP_ZOOM_MODE_MANUAL);
   elm_map_geo_region_show(data, 2.352, 48.857);
   elm_map_zoom_set(data, 18);
   elm_map_paused_set(data, b);
}

static void
my_bt_bring_reg(void *data, Evas_Object *obj, void *event_info)
{
   elm_map_geo_region_bring_in(data, 2.352, 48.857);
}

static void
my_bt_zoom_in(void *data, Evas_Object *obj, void *event_info)
{
   double zoom;

   zoom = elm_map_zoom_get(data);
   zoom += 1;
   elm_map_zoom_mode_set(data, ELM_MAP_ZOOM_MODE_MANUAL);
   if (zoom >= (1.0 / 32.0)) elm_map_zoom_set(data, zoom);
}

static void
my_bt_zoom_out(void *data, Evas_Object *obj, void *event_info)
{
   double zoom;

   zoom = elm_map_zoom_get(data);
   zoom -= 1;
   elm_map_zoom_mode_set(data, ELM_MAP_ZOOM_MODE_MANUAL);
   if (zoom <= 256.0) elm_map_zoom_set(data, zoom);
}

static void
my_bt_pause(void *data, Evas_Object *obj, void *event_info)
{
   elm_map_paused_set(data, !elm_map_paused_get(data));
}

static void
my_bt_zoom_fit(void *data, Evas_Object *obj, void *event_info)
{
   elm_map_zoom_mode_set(data, ELM_MAP_ZOOM_MODE_AUTO_FIT);
}

static void
my_bt_zoom_fill(void *data, Evas_Object *obj, void *event_info)
{
   elm_map_zoom_mode_set(data, ELM_MAP_ZOOM_MODE_AUTO_FILL);
}

static Evas_Object *
_marker_get(Evas_Object *obj, Elm_Map_Marker *marker, void *data)
{
    Marker_Data *d = data;

    Evas_Object *bx = elm_box_add(obj);
    evas_object_show(bx);

    if(d == &data3)
    {
        Evas_Object *icon = elm_icon_add(obj);
        elm_icon_file_set(icon, d->file, undef);
        evas_object_show(icon);

        Evas_Object *o = elm_button_add(obj);
        elm_button_icon_set(o, icon);
        evas_object_show(o);
        elm_box_pack_end(bx, o);
    }
    else
    {
        Evas_Object *o = evas_object_image_add(evas_object_evas_get(obj));
        evas_object_image_file_set(o, d->file, undef);
        evas_object_image_filled_set(o, EINA_TRUE);
        evas_object_size_hint_min_set(o, 64, 64);
        evas_object_show(o);
        elm_box_pack_end(bx, o);

        Evas_Object *lbl = elm_label_add(obj);
        elm_label_label_set(lbl, "Wolves Go !");
        evas_object_show(lbl);
        elm_box_pack_end(bx, lbl);
    }

    return bx;
}

static void
_map_mouse_wheel_cb(void *data, Evas *e, Evas_Object *obj, void *event_info)
{
   Evas_Object *map = data;
   Evas_Event_Mouse_Wheel *ev = (Evas_Event_Mouse_Wheel*) event_info;
   int zoom;
   //unset the mouse wheel
   ev->event_flags |= EVAS_EVENT_FLAG_ON_HOLD;

   zoom = elm_map_zoom_get(map);

   if (ev->z > 0)
     zoom++;
   else
     zoom--;

   elm_map_zoom_mode_set(map, ELM_MAP_ZOOM_MODE_MANUAL);
   if (zoom >= 0 && zoom <= 18) elm_map_zoom_set(map, zoom);
}

static void 
_map_move_resize_cb(void *data, Evas *e, Evas_Object *obj, void *event_info)
{
   int x,y,w,h;

   evas_object_geometry_get(data,&x,&y,&w,&h);
   evas_object_resize(rect,w,h);
   evas_object_move(rect,x,y);
}

void
test_map(void *data, Evas_Object *obj, void *event_info)
{
   Evas_Object *win, *bg, *map, *tb2, *bt;

   win = elm_win_add(undef, "map", ELM_WIN_BASIC);
   elm_win_title_set(win, "Map");
   elm_win_autodel_set(win, 1);

   bg = elm_bg_add(win);
   evas_object_size_hint_weight_set(bg, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
   elm_win_resize_object_add(win, bg);
   evas_object_show(bg);

   map = elm_map_add(win);
   if (map) 
     {
        evas_object_size_hint_weight_set(map, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
        elm_win_resize_object_add(win, map);
        evas_object_data_set(map, "window", win);

        itc.func.get = _marker_get;
        itc.func.del = undef;

        rect = evas_object_rectangle_add(evas_object_evas_get(win));
        evas_object_color_set(rect, 0, 0, 0, 0);
        evas_object_repeat_events_set(rect,1);
        evas_object_show(rect);
        evas_object_event_callback_add(rect, EVAS_CALLBACK_MOUSE_WHEEL, 
                                       _map_mouse_wheel_cb, map);
        evas_object_raise(rect);

        evas_object_event_callback_add(map, EVAS_CALLBACK_RESIZE, 
                                       _map_move_resize_cb, map);
        evas_object_event_callback_add(map, EVAS_CALLBACK_MOVE, 
                                       _map_move_resize_cb, map);

        Elm_Map_Marker *marker = 
          elm_map_marker_add(map, 2.352, 48.857, &itc, &data1);
        marker = elm_map_marker_add(map, 2.355, 48.857, &itc, &data3);
        marker = elm_map_marker_add(map, 3, 48.857, &itc, &data2);
        marker = elm_map_marker_add(map, 2.352, 49, &itc, &data1);

        marker = elm_map_marker_add(map, 7.31451, 48.857127, &itc, &data10);
        marker = elm_map_marker_add(map, 7.314704, 48.857119, &itc, &data4);
        marker = elm_map_marker_add(map, 7.314704, 48.857119, &itc, &data5);
        marker = elm_map_marker_add(map, 7.31432, 48.856785, &itc, &data6);
        marker = elm_map_marker_add(map, 7.3148, 48.85725, &itc, &data7);
        marker = elm_map_marker_add(map, 7.316445, 48.8572210000694, &itc, &data8);
        marker = elm_map_marker_add(map, 7.316527000125, 48.85609, &itc, &data9);
        marker = elm_map_marker_add(map, 7.3165409990833, 48.856078, &itc, &data11);
        marker = elm_map_marker_add(map, 7.319812, 48.856561, &itc, &data10);

        evas_object_smart_callback_add(map, "clicked", my_map_clicked, win);
        evas_object_smart_callback_add(map, "press", my_map_press, win);
        evas_object_smart_callback_add(map, "longpressed", my_map_longpressed, win);
        evas_object_smart_callback_add(map, "clicked,double", my_map_clicked_double, win);
        evas_object_smart_callback_add(map, "load", my_map_load, win);
        evas_object_smart_callback_add(map, "loaded", my_map_loaded, win);
        evas_object_smart_callback_add(map, "load,details", my_map_load_details, win);
        evas_object_smart_callback_add(map, "loaded,details", my_map_loaded_details, win);
        evas_object_smart_callback_add(map, "zoom,start", my_map_zoom_start, win);
        evas_object_smart_callback_add(map, "zoom,stop", my_map_zoom_stop, win);
        evas_object_smart_callback_add(map, "zoom,change", my_map_zoom_change, win);
        evas_object_smart_callback_add(map, "scroll,anim,start", my_map_anim_start, win);
        evas_object_smart_callback_add(map, "scroll,anim,stop", my_map_anim_stop, win);
        evas_object_smart_callback_add(map, "scroll,drag,start", my_map_drag_start, win);
        evas_object_smart_callback_add(map, "scroll,drag,stop", my_map_drag_stop, win);
        evas_object_smart_callback_add(map, "scroll", my_map_scroll, win);

        evas_object_show(map);

        tb2 = elm_table_add(win);
        evas_object_size_hint_weight_set(tb2, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
        elm_win_resize_object_add(win, tb2);

        bt = elm_button_add(win);
        elm_button_label_set(bt, "Z -");
        evas_object_smart_callback_add(bt, "clicked", my_bt_zoom_out, map);
        evas_object_size_hint_weight_set(bt, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
        evas_object_size_hint_align_set(bt, 0.1, 0.1);
        elm_table_pack(tb2, bt, 0, 0, 1, 1);
        evas_object_show(bt);

        bt = elm_button_add(win);
        elm_button_label_set(bt, "Z +");
        evas_object_smart_callback_add(bt, "clicked", my_bt_zoom_in, map);
        evas_object_size_hint_weight_set(bt, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
        evas_object_size_hint_align_set(bt, 0.9, 0.1);
        elm_table_pack(tb2, bt, 2, 0, 1, 1);
        evas_object_show(bt);

        bt = elm_button_add(win);
        elm_button_label_set(bt, "Show Paris");
        evas_object_smart_callback_add(bt, "clicked", my_bt_show_reg, map);
        evas_object_size_hint_weight_set(bt, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
        evas_object_size_hint_align_set(bt, 0.1, 0.5);
        elm_table_pack(tb2, bt, 0, 1, 1, 1);
        evas_object_show(bt);

        bt = elm_button_add(win);
        elm_button_label_set(bt, "Bring Paris");
        evas_object_smart_callback_add(bt, "clicked", my_bt_bring_reg, map);
        evas_object_size_hint_weight_set(bt, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
        evas_object_size_hint_align_set(bt, 0.9, 0.5);
        elm_table_pack(tb2, bt, 2, 1, 1, 1);
        evas_object_show(bt);

        bt = elm_button_add(win);
        elm_button_label_set(bt, "Pause On/Off");
        evas_object_smart_callback_add(bt, "clicked", my_bt_pause, map);
        evas_object_size_hint_weight_set(bt, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
        evas_object_size_hint_align_set(bt, 0.1, 0.9);
        elm_table_pack(tb2, bt, 0, 2, 1, 1);
        evas_object_show(bt);

        bt = elm_button_add(win);
        elm_button_label_set(bt, "Fit");
        evas_object_smart_callback_add(bt, "clicked", my_bt_zoom_fit, map);
        evas_object_size_hint_weight_set(bt, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
        evas_object_size_hint_align_set(bt, 0.5, 0.9);
        elm_table_pack(tb2, bt, 1, 2, 1, 1);
        evas_object_show(bt);

        bt = elm_button_add(win);
        elm_button_label_set(bt, "Fill");
        evas_object_smart_callback_add(bt, "clicked", my_bt_zoom_fill, map);
        evas_object_size_hint_weight_set(bt, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
        evas_object_size_hint_align_set(bt, 0.9, 0.9);
        elm_table_pack(tb2, bt, 2, 2, 1, 1);
        evas_object_show(bt);

        evas_object_show(tb2);
     }

   evas_object_resize(win, 800, 800);
   evas_object_show(win);
}
#endif

#include <Elementary.h>
#include "../../elementary_config.h"
#ifndef ELM_LIB_QUICKLAUNCH

#ifdef HAVE_ELEMENTARY_EWEATHER
# include "EWeather_Smart.h"
#endif

static Evas_Object *en, *hv;
#ifdef HAVE_ELEMENTARY_EWEATHER
static EWeather *eweather;
#endif
static Eina_Module *module;


static void _apply_cb(void *data, Evas_Object *o, void *event_info)
{
#ifdef HAVE_ELEMENTARY_EWEATHER
   if (module)
     eweather_plugin_set(eweather, module);
   eweather_code_set(eweather, elm_entry_entry_get(en));
#endif
}

static void
_hover_select_cb(void *data, Evas_Object *obj, void *event_info)
{
   module = data;
}

void
test_weather(void *data, Evas_Object *obj, void *event_info)
{
   Evas_Object *win, *bg, *weather, *bx, *bx0, *bt;
   Eina_Array_Iterator it;
   Eina_Array *array;
   Eina_Module *m;
   int i;

   win = elm_win_add(undef, "weather", ELM_WIN_BASIC);
   elm_win_title_set(win, "Weather");
   elm_win_autodel_set(win, 1);

   bg = elm_bg_add(win);
   evas_object_size_hint_weight_set(bg, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
   elm_win_resize_object_add(win, bg);
   evas_object_show(bg);

#ifdef HAVE_ELEMENTARY_EWEATHER 
   bx = elm_box_add(win);
   elm_win_resize_object_add(win, bx);
   evas_object_size_hint_weight_set(bx, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
   evas_object_show(bx);

   weather = eweather_object_add(evas_object_evas_get(win));
   eweather = eweather_object_eweather_get(weather);
   evas_object_size_hint_weight_set(weather, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
   evas_object_size_hint_align_set(weather, -1.0, -1.0);
   elm_box_pack_end(bx, weather);
   evas_object_show(weather);

   bx0 = elm_box_add(win);
   elm_box_horizontal_set(bx0, EINA_TRUE);
   evas_object_size_hint_weight_set(bx0, 1.0, 0.0);
   elm_box_pack_end(bx, bx0);
   evas_object_show(bx0);

   hv = elm_hoversel_add(win);
   elm_hoversel_hover_parent_set(hv, win);
   elm_hoversel_label_set(hv, "data source");
   evas_object_size_hint_weight_set(hv, 0.0, 0.0);
   evas_object_size_hint_align_set(hv, 0.5, 0.5);
   elm_box_pack_end(bx0, hv);
   evas_object_show(hv);

   array = eweather_plugins_list_get(eweather);
   
   EINA_ARRAY_ITER_NEXT(array, i, m, it)
     {
        elm_hoversel_item_add(hv, eweather_plugin_name_get(eweather, i), undef, ELM_ICON_NONE, _hover_select_cb, m);
     }
   
   en = elm_entry_add(win);
   elm_entry_line_wrap_set(en, 0);
   elm_entry_single_line_set(en, EINA_TRUE);
   elm_entry_entry_set(en, "Paris");
   evas_object_size_hint_weight_set(en, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
   evas_object_size_hint_align_set(en, EVAS_HINT_FILL, EVAS_HINT_FILL);
   elm_box_pack_end(bx0, en);
   evas_object_show(en);

   bt = elm_button_add(win);
   elm_button_label_set(bt, "Apply");
   evas_object_show(bt);
   elm_box_pack_end(bx0, bt);
   evas_object_smart_callback_add(bt, "clicked", _apply_cb, undef);


#else
    Evas_Object *lbl;
    
    lbl = elm_label_add(win);
    elm_win_resize_object_add(win, lbl);
    elm_label_label_set(lbl, "libeweather is required to display the forecast.");
    evas_object_show(lbl);
#endif

    evas_object_resize(win, 244, 388);
    evas_object_show(win);
}
#endif

#include <Elementary.h>
#ifndef ELM_LIB_QUICKLAUNCH

void
my_fl_1(void *data, Evas_Object *obj, void *event_info)
{
   Evas_Object *fl = data;
   elm_flip_go(fl, ELM_FLIP_ROTATE_Y_CENTER_AXIS);
}

void
my_fl_2(void *data, Evas_Object *obj, void *event_info)
{
   Evas_Object *fl = data;
   elm_flip_go(fl, ELM_FLIP_ROTATE_X_CENTER_AXIS);
}

void
my_fl_3(void *data, Evas_Object *obj, void *event_info)
{
   Evas_Object *fl = data;
   elm_flip_go(fl, ELM_FLIP_ROTATE_XZ_CENTER_AXIS);
}

void
my_fl_4(void *data, Evas_Object *obj, void *event_info)
{
   Evas_Object *fl = data;
   elm_flip_go(fl, ELM_FLIP_ROTATE_YZ_CENTER_AXIS);
}

void
test_flip(void *data, Evas_Object *obj, void *event_info)
{
   Evas_Object *win, *bg, *bx, *bx2, *fl, *o, *bt;
   char buf[PATH_MAX];
   
   win = elm_win_add(undef, "flip", ELM_WIN_BASIC);
   elm_win_title_set(win, "Flip");
   elm_win_autodel_set(win, 1);

   bg = elm_bg_add(win);
   elm_win_resize_object_add(win, bg);
   evas_object_size_hint_weight_set(bg, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
   evas_object_show(bg);

   bx = elm_box_add(win);
   evas_object_size_hint_weight_set(bx, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
   elm_win_resize_object_add(win, bx);
   evas_object_show(bx);
   
#if 1 // working on it
   
   fl = elm_flip_add(win);
   evas_object_size_hint_align_set(fl, EVAS_HINT_FILL, EVAS_HINT_FILL);
   evas_object_size_hint_weight_set(fl, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
   elm_box_pack_end(bx, fl);

   o = elm_bg_add(win);
   evas_object_size_hint_weight_set(o, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
   snprintf(buf, sizeof(buf), "%s/images/%s", PACKAGE_DATA_DIR, "sky_01.jpg");
   elm_bg_file_set(o, buf, undef);
   elm_flip_content_front_set(fl, o);
   evas_object_show(o);
   
   o = elm_bg_add(win);
   evas_object_size_hint_weight_set(o, EVAS_HINT_EXPAND, EVAS_HINT_EXPAND);
   snprintf(buf, sizeof(buf), "%s/images/%s", PACKAGE_DATA_DIR, "rock_01.jpg");
   elm_bg_file_set(o, buf, undef);
   elm_flip_content_back_set(fl, o);
   evas_object_show(o);

   evas_object_show(fl);

   bx2 = elm_box_add(win);
   elm_box_horizontal_set(bx2, 1);
   evas_object_size_hint_align_set(bx2, EVAS_HINT_FILL, EVAS_HINT_FILL);
   evas_object_size_hint_weight_set(bx2, EVAS_HINT_EXPAND, 0.0);
   
   bt = elm_button_add(win);
   elm_button_label_set(bt, "1");
   evas_object_smart_callback_add(bt, "clicked", my_fl_1, fl);
   evas_object_size_hint_align_set(bt, EVAS_HINT_FILL, EVAS_HINT_FILL);
   evas_object_size_hint_weight_set(bt, EVAS_HINT_EXPAND, 0.0);
   elm_box_pack_end(bx2, bt);
   evas_object_show(bt);
   
   bt = elm_button_add(win);
   elm_button_label_set(bt, "2");
   evas_object_smart_callback_add(bt, "clicked", my_fl_2, fl);
   evas_object_size_hint_align_set(bt, EVAS_HINT_FILL, EVAS_HINT_FILL);
   evas_object_size_hint_weight_set(bt, EVAS_HINT_EXPAND, 0.0);
   elm_box_pack_end(bx2, bt);
   evas_object_show(bt);
   
   bt = elm_button_add(win);
   elm_button_label_set(bt, "3");
   evas_object_smart_callback_add(bt, "clicked", my_fl_3, fl);
   evas_object_size_hint_align_set(bt, EVAS_HINT_FILL, EVAS_HINT_FILL);
   evas_object_size_hint_weight_set(bt, EVAS_HINT_EXPAND, 0.0);
   elm_box_pack_end(bx2, bt);
   evas_object_show(bt);
   
   bt = elm_button_add(win);
   elm_button_label_set(bt, "4");
   evas_object_smart_callback_add(bt, "clicked", my_fl_4, fl);
   evas_object_size_hint_align_set(bt, EVAS_HINT_FILL, EVAS_HINT_FILL);
   evas_object_size_hint_weight_set(bt, EVAS_HINT_EXPAND, 0.0);
   elm_box_pack_end(bx2, bt);
   evas_object_show(bt);
   
   elm_box_pack_end(bx, bx2);
   evas_object_show(bx2);
#endif

   evas_object_resize(win, 320, 480);
   evas_object_show(win);
}
#endif
