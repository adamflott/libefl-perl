package EFL::Evas;

# ABSTRACT: Perl bindings for Evas from the Enlightenment Foundation Libraries

use 5.10.0;

use strict;
use warnings;

our $VERSION = '0.50';
$VERSION = eval $VERSION;    ## no critic
our $XS_VERSION = $VERSION;

use Carp;

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
  EVAS_ALLOC_ERROR_FATAL
  EVAS_ALLOC_ERROR_NONE
  EVAS_ALLOC_ERROR_RECOVERED
  EVAS_ASPECT_CONTROL_BOTH
  EVAS_ASPECT_CONTROL_HORIZONTAL
  EVAS_ASPECT_CONTROL_NEITHER
  EVAS_ASPECT_CONTROL_NONE
  EVAS_ASPECT_CONTROL_VERTICAL
  EVAS_BORDER_FILL_DEFAULT
  EVAS_BORDER_FILL_NONE
  EVAS_BORDER_FILL_SOLID
  EVAS_BUTTON_DOUBLE_CLICK
  EVAS_BUTTON_NONE
  EVAS_BUTTON_TRIPLE_CLICK
  EVAS_CALLBACK_CHANGED_SIZE_HINTS
  EVAS_CALLBACK_DEL
  EVAS_CALLBACK_FOCUS_IN
  EVAS_CALLBACK_FOCUS_OUT
  EVAS_CALLBACK_FREE
  EVAS_CALLBACK_HIDE
  EVAS_CALLBACK_HOLD
  EVAS_CALLBACK_IMAGE_PRELOADED
  EVAS_CALLBACK_KEY_DOWN
  EVAS_CALLBACK_KEY_UP
  EVAS_CALLBACK_MOUSE_DOWN
  EVAS_CALLBACK_MOUSE_IN
  EVAS_CALLBACK_MOUSE_MOVE
  EVAS_CALLBACK_MOUSE_OUT
  EVAS_CALLBACK_MOUSE_UP
  EVAS_CALLBACK_MOUSE_WHEEL
  EVAS_CALLBACK_MOVE
  EVAS_CALLBACK_RESIZE
  EVAS_CALLBACK_RESTACK
  EVAS_CALLBACK_SHOW
  EVAS_COLORSPACE_ARGB8888
  EVAS_COLORSPACE_RGB565_A5P
  EVAS_COLORSPACE_YCBCR422P601_PL
  EVAS_COLORSPACE_YCBCR422P709_PL
  EVAS_COLOR_SPACE_AHSV
  EVAS_COLOR_SPACE_ARGB
  EVAS_EVENT_FLAG_NONE
  EVAS_EVENT_FLAG_ON_HOLD
  EVAS_FONT_HINTING_AUTO
  EVAS_FONT_HINTING_BYTECODE
  EVAS_FONT_HINTING_NONE
  EVAS_HINT_EXPAND
  EVAS_HINT_FILL
  EVAS_IMAGE_SCALE_HINT_DYNAMIC
  EVAS_IMAGE_SCALE_HINT_NONE
  EVAS_IMAGE_SCALE_HINT_STATIC
  EVAS_LAYER_MAX
  EVAS_LAYER_MIN
  EVAS_LOAD_ERROR_CORRUPT_FILE
  EVAS_LOAD_ERROR_DOES_NOT_EXIST
  EVAS_LOAD_ERROR_GENERIC
  EVAS_LOAD_ERROR_NONE
  EVAS_LOAD_ERROR_PERMISSION_DENIED
  EVAS_LOAD_ERROR_RESOURCE_ALLOCATION_FAILED
  EVAS_LOAD_ERROR_UNKNOWN_FORMAT
  EVAS_OBJECT_BOX_API_VERSION
  EVAS_OBJECT_POINTER_MODE_AUTOGRAB
  EVAS_OBJECT_POINTER_MODE_NOGRAB
  EVAS_OBJECT_TABLE_HOMOGENEOUS_ITEM
  EVAS_OBJECT_TABLE_HOMOGENEOUS_NONE
  EVAS_OBJECT_TABLE_HOMOGENEOUS_TABLE
  EVAS_PIXEL_FORMAT_ARGB32
  EVAS_PIXEL_FORMAT_NONE
  EVAS_PIXEL_FORMAT_YUV420P_601
  EVAS_RENDER_ADD
  EVAS_RENDER_ADD_REL
  EVAS_RENDER_BLEND
  EVAS_RENDER_BLEND_REL
  EVAS_RENDER_COPY
  EVAS_RENDER_COPY_REL
  EVAS_RENDER_MASK
  EVAS_RENDER_MUL
  EVAS_RENDER_SUB
  EVAS_RENDER_SUB_REL
  EVAS_RENDER_TINT
  EVAS_RENDER_TINT_REL
  EVAS_SMART_CLASS_VERSION
  EVAS_TEXTBLOCK_TEXT_MARKUP
  EVAS_TEXTBLOCK_TEXT_PLAIN
  EVAS_TEXTBLOCK_TEXT_RAW
  EVAS_TEXTURE_PAD
  EVAS_TEXTURE_REFLECT
  EVAS_TEXTURE_REPEAT
  EVAS_TEXTURE_RESTRICT
  EVAS_TEXTURE_RESTRICT_REFLECT
  EVAS_TEXTURE_RESTRICT_REPEAT
  EVAS_TEXT_INVALID
  EVAS_TEXT_SPECIAL
  EVAS_TEXT_STYLE_FAR_SHADOW
  EVAS_TEXT_STYLE_FAR_SOFT_SHADOW
  EVAS_TEXT_STYLE_GLOW
  EVAS_TEXT_STYLE_OUTLINE
  EVAS_TEXT_STYLE_OUTLINE_SHADOW
  EVAS_TEXT_STYLE_OUTLINE_SOFT_SHADOW
  EVAS_TEXT_STYLE_PLAIN
  EVAS_TEXT_STYLE_SHADOW
  EVAS_TEXT_STYLE_SOFT_OUTLINE
  EVAS_TEXT_STYLE_SOFT_SHADOW
);

our @__funcs = qw(
  evas_alloc_error
  evas_async_events_fd_get
  evas_async_events_process
  evas_color_argb_premul
  evas_color_argb_unpremul
  evas_color_hsv_to_rgb
  evas_color_rgb_to_hsv
  evas_coord_screen_x_to_world
  evas_coord_screen_y_to_world
  evas_coord_world_x_to_screen
  evas_coord_world_y_to_screen
  evas_damage_rectangle_add
  evas_data_argb_premul
  evas_data_argb_unpremul
  evas_data_attach_get
  evas_data_attach_set
  evas_engine_info_get
  evas_engine_info_set
  evas_event_feed_hold
  evas_event_feed_key_down
  evas_event_feed_key_up
  evas_event_feed_mouse_cancel
  evas_event_feed_mouse_down
  evas_event_feed_mouse_in
  evas_event_feed_mouse_move
  evas_event_feed_mouse_out
  evas_event_feed_mouse_up
  evas_event_feed_mouse_wheel
  evas_event_freeze
  evas_event_freeze_get
  evas_event_thaw
  evas_focus_get
  evas_font_available_list
  evas_font_available_list_free
  evas_font_cache_flush
  evas_font_cache_get
  evas_font_cache_set
  evas_font_hinting_can_hint
  evas_font_hinting_get
  evas_font_hinting_set
  evas_font_path_append
  evas_font_path_clear
  evas_font_path_list
  evas_font_path_prepend
  evas_free
  evas_image_cache_flush
  evas_image_cache_get
  evas_image_cache_reload
  evas_image_cache_set
  evas_imaging_font_ascent_get
  evas_imaging_font_cache_get
  evas_imaging_font_cache_set
  evas_imaging_font_descent_get
  evas_imaging_font_free
  evas_imaging_font_hinting_can_hint
  evas_imaging_font_hinting_get
  evas_imaging_font_hinting_set
  evas_imaging_font_line_advance_get
  evas_imaging_font_load
  evas_imaging_font_max_ascent_get
  evas_imaging_font_max_descent_get
  evas_imaging_font_string_advance_get
  evas_imaging_font_string_char_at_coords_get
  evas_imaging_font_string_char_coords_get
  evas_imaging_font_string_inset_get
  evas_imaging_font_string_size_query
  evas_imaging_image_alpha_get
  evas_imaging_image_cache_get
  evas_imaging_image_cache_set
  evas_imaging_image_free
  evas_imaging_image_load
  evas_imaging_image_size_get
  evas_init
  evas_key_lock_add
  evas_key_lock_del
  evas_key_lock_get
  evas_key_lock_is_set
  evas_key_lock_off
  evas_key_lock_on
  evas_key_modifier_add
  evas_key_modifier_del
  evas_key_modifier_get
  evas_key_modifier_is_set
  evas_key_modifier_mask_get
  evas_key_modifier_off
  evas_key_modifier_on
  evas_load_error_str
  evas_map_alpha_get
  evas_map_alpha_set
  evas_map_dup
  evas_map_free
  evas_map_new
  evas_map_point_color_get
  evas_map_point_color_set
  evas_map_point_coord_get
  evas_map_point_coord_set
  evas_map_point_image_uv_get
  evas_map_point_image_uv_set
  evas_map_smooth_get
  evas_map_smooth_set
  evas_map_util_3d_lighting
  evas_map_util_3d_perspective
  evas_map_util_3d_rotate
  evas_map_util_clockwise_get
  evas_map_util_points_color_set
  evas_map_util_points_populate_from_geometry
  evas_map_util_points_populate_from_object
  evas_map_util_points_populate_from_object_full
  evas_map_util_rotate
  evas_map_util_zoom
  evas_new
  evas_norender
  evas_object_above_get
  evas_object_anti_alias_get
  evas_object_anti_alias_set
  evas_object_below_get
  evas_object_bottom_get
  evas_object_box_accessor_new
  evas_object_box_add
  evas_object_box_add_to
  evas_object_box_align_get
  evas_object_box_align_set
  evas_object_box_append
  evas_object_box_children_get
  evas_object_box_insert_after
  evas_object_box_insert_at
  evas_object_box_insert_before
  evas_object_box_iterator_new
  evas_object_box_layout_flow_horizontal
  evas_object_box_layout_flow_vertical
  evas_object_box_layout_homogeneous_horizontal
  evas_object_box_layout_homogeneous_max_size_horizontal
  evas_object_box_layout_homogeneous_max_size_vertical
  evas_object_box_layout_homogeneous_vertical
  evas_object_box_layout_horizontal
  evas_object_box_layout_stack
  evas_object_box_layout_vertical
  evas_object_box_option_property_id_get
  evas_object_box_option_property_name_get
  evas_object_box_option_property_set
  evas_object_box_padding_get
  evas_object_box_padding_set
  evas_object_box_prepend
  evas_object_box_remove
  evas_object_box_remove_all
  evas_object_box_remove_at
  evas_object_box_smart_set
  evas_object_clip_get
  evas_object_clip_set
  evas_object_clip_unset
  evas_object_clipees_get
  evas_object_color_get
  evas_object_color_interpolation_get
  evas_object_color_interpolation_set
  evas_object_color_set
  evas_object_data_del
  evas_object_data_get
  evas_object_data_set
  evas_object_del
  evas_object_evas_get
  evas_object_event_callback_add
  evas_object_focus_get
  evas_object_focus_set
  evas_object_geometry_get
  evas_object_gradient2_color_np_stop_insert
  evas_object_gradient2_fill_spread_get
  evas_object_gradient2_fill_spread_set
  evas_object_gradient2_fill_transform_get
  evas_object_gradient2_fill_transform_set
  evas_object_gradient2_linear_add
  evas_object_gradient2_linear_fill_get
  evas_object_gradient2_linear_fill_set
  evas_object_gradient2_radial_add
  evas_object_gradient2_radial_fill_get
  evas_object_gradient2_radial_fill_set
  evas_object_gradient_add
  evas_object_gradient_alpha_data_set
  evas_object_gradient_alpha_stop_add
  evas_object_gradient_angle_get
  evas_object_gradient_angle_set
  evas_object_gradient_clear
  evas_object_gradient_color_data_set
  evas_object_gradient_color_stop_add
  evas_object_gradient_direction_get
  evas_object_gradient_direction_set
  evas_object_gradient_fill_angle_get
  evas_object_gradient_fill_angle_set
  evas_object_gradient_fill_get
  evas_object_gradient_fill_set
  evas_object_gradient_fill_spread_get
  evas_object_gradient_fill_spread_set
  evas_object_gradient_offset_get
  evas_object_gradient_offset_set
  evas_object_gradient_type_set
  evas_object_hide
  evas_object_image_add
  evas_object_image_alpha_get
  evas_object_image_alpha_set
  evas_object_image_border_center_fill_get
  evas_object_image_border_center_fill_set
  evas_object_image_border_get
  evas_object_image_border_set
  evas_object_image_colorspace_get
  evas_object_image_colorspace_set
  evas_object_image_data_convert
  evas_object_image_data_copy_set
  evas_object_image_data_get
  evas_object_image_data_set
  evas_object_image_data_update_add
  evas_object_image_file_set
  evas_object_image_fill_get
  evas_object_image_fill_set
  evas_object_image_fill_spread_get
  evas_object_image_fill_spread_set
  evas_object_image_fill_transform_get
  evas_object_image_fill_transform_set
  evas_object_image_filled_add
  evas_object_image_filled_get
  evas_object_image_filled_set
  evas_object_image_load_dpi_get
  evas_object_image_load_dpi_set
  evas_object_image_load_error_get
  evas_object_image_load_region_get
  evas_object_image_load_region_set
  evas_object_image_load_scale_down_get
  evas_object_image_load_scale_down_set
  evas_object_image_load_size_get
  evas_object_image_load_size_set
  evas_object_image_native_surface_get
  evas_object_image_native_surface_set
  evas_object_image_pixels_dirty_get
  evas_object_image_pixels_dirty_set
  evas_object_image_pixels_import
  evas_object_image_preload
  evas_object_image_reload
  evas_object_image_save
  evas_object_image_scale_hint_get
  evas_object_image_scale_hint_set
  evas_object_image_size_get
  evas_object_image_size_set
  evas_object_image_smooth_scale_get
  evas_object_image_smooth_scale_set
  evas_object_image_stride_get
  evas_object_key_grab
  evas_object_key_ungrab
  evas_object_layer_get
  evas_object_layer_set
  evas_object_line_add
  evas_object_line_xy_get
  evas_object_line_xy_set
  evas_object_lower
  evas_object_map_enable_get
  evas_object_map_enable_set
  evas_object_map_set
  evas_object_move
  evas_object_name_find
  evas_object_name_get
  evas_object_name_set
  evas_object_pass_events_get
  evas_object_pass_events_set
  evas_object_pointer_mode_get
  evas_object_pointer_mode_set
  evas_object_polygon_add
  evas_object_polygon_point_add
  evas_object_polygon_points_clear
  evas_object_precise_is_inside_get
  evas_object_precise_is_inside_set
  evas_object_propagate_events_get
  evas_object_propagate_events_set
  evas_object_raise
  evas_object_rectangle_add
  evas_object_render_op_get
  evas_object_render_op_set
  evas_object_repeat_events_get
  evas_object_repeat_events_set
  evas_object_resize
  evas_object_scale_get
  evas_object_scale_set
  evas_object_show
  evas_object_size_hint_align_get
  evas_object_size_hint_align_set
  evas_object_size_hint_aspect_get
  evas_object_size_hint_aspect_set
  evas_object_size_hint_fill_set
  evas_object_size_hint_max_get
  evas_object_size_hint_max_set
  evas_object_size_hint_min_get
  evas_object_size_hint_min_set
  evas_object_size_hint_padding_get
  evas_object_size_hint_padding_set
  evas_object_size_hint_request_get
  evas_object_size_hint_request_set
  evas_object_size_hint_weight_get
  evas_object_size_hint_weight_set
  evas_object_smart_add
  evas_object_smart_calculate
  evas_object_smart_callback_add
  evas_object_smart_callback_call
  evas_object_smart_callback_del
  evas_object_smart_changed
  evas_object_smart_clipped_clipper_get
  evas_object_smart_clipped_smart_set
  evas_object_smart_data_get
  evas_object_smart_data_set
  evas_object_smart_member_add
  evas_object_smart_member_del
  evas_object_smart_members_get
  evas_object_smart_move_children_relative
  evas_object_smart_need_recalculate_get
  evas_object_smart_need_recalculate_set
  evas_object_smart_parent_get
  evas_object_smart_smart_get
  evas_object_stack_above
  evas_object_stack_below
  evas_object_table_accessor_new
  evas_object_table_add
  evas_object_table_add_to
  evas_object_table_align_get
  evas_object_table_align_set
  evas_object_table_children_get
  evas_object_table_clear
  evas_object_table_col_row_size_get
  evas_object_table_homogeneous_get
  evas_object_table_homogeneous_set
  evas_object_table_iterator_new
  evas_object_table_pack
  evas_object_table_padding_get
  evas_object_table_padding_set
  evas_object_table_unpack
  evas_object_text_add
  evas_object_text_ascent_get
  evas_object_text_char_coords_get
  evas_object_text_char_pos_get
  evas_object_text_descent_get
  evas_object_text_font_set
  evas_object_text_font_source_get
  evas_object_text_font_source_set
  evas_object_text_glow2_color_get
  evas_object_text_glow2_color_set
  evas_object_text_glow_color_get
  evas_object_text_glow_color_set
  evas_object_text_horiz_advance_get
  evas_object_text_inset_get
  evas_object_text_last_up_to_pos
  evas_object_text_max_ascent_get
  evas_object_text_max_descent_get
  evas_object_text_outline_color_get
  evas_object_text_outline_color_set
  evas_object_text_shadow_color_get
  evas_object_text_shadow_color_set
  evas_object_text_style_get
  evas_object_text_style_pad_get
  evas_object_text_style_set
  evas_object_text_text_get
  evas_object_text_text_set
  evas_object_text_vert_advance_get
  evas_object_textblock_add
  evas_object_textblock_clear
  evas_object_textblock_cursor_get
  evas_object_textblock_cursor_new
  evas_object_textblock_line_number_geometry_get
  evas_object_textblock_replace_char_get
  evas_object_textblock_replace_char_set
  evas_object_textblock_size_formatted_get
  evas_object_textblock_size_native_get
  evas_object_textblock_style_insets_get
  evas_object_textblock_style_set
  evas_object_textblock_text_markup_get
  evas_object_textblock_text_markup_prepend
  evas_object_textblock_text_markup_set
  evas_object_top_at_pointer_get
  evas_object_top_at_xy_get
  evas_object_top_get
  evas_object_top_in_rectangle_get
  evas_object_type_get
  evas_object_visible_get
  evas_objects_at_xy_get
  evas_objects_in_rectangle_get
  evas_obscured_clear
  evas_obscured_rectangle_add
  evas_output_method_get
  evas_output_method_set
  evas_output_size_get
  evas_output_size_set
  evas_output_viewport_get
  evas_output_viewport_set
  evas_pointer_button_down_mask_get
  evas_pointer_canvas_xy_get
  evas_pointer_inside_get
  evas_pointer_output_xy_get
  evas_render
  evas_render_idle_flush
  evas_render_method_list
  evas_render_method_list_free
  evas_render_method_lookup
  evas_render_updates
  evas_render_updates_free
  evas_shutdown
  evas_smart_class_new
  evas_smart_data_get
  evas_smart_free
  evas_smart_objects_calculate
  evas_string_char_len_get
  evas_string_char_next_get
  evas_string_char_prev_get
  evas_textblock_cursor_char_coord_set
  evas_textblock_cursor_char_delete
  evas_textblock_cursor_char_first
  evas_textblock_cursor_char_geometry_get
  evas_textblock_cursor_char_last
  evas_textblock_cursor_char_next
  evas_textblock_cursor_char_prev
  evas_textblock_cursor_compare
  evas_textblock_cursor_copy
  evas_textblock_cursor_eol_get
  evas_textblock_cursor_eol_set
  evas_textblock_cursor_format_append
  evas_textblock_cursor_format_prepend
  evas_textblock_cursor_free
  evas_textblock_cursor_line_coord_set
  evas_textblock_cursor_line_first
  evas_textblock_cursor_line_geometry_get
  evas_textblock_cursor_line_last
  evas_textblock_cursor_line_set
  evas_textblock_cursor_node_delete
  evas_textblock_cursor_node_first
  evas_textblock_cursor_node_format_is_visible_get
  evas_textblock_cursor_node_last
  evas_textblock_cursor_node_next
  evas_textblock_cursor_node_prev
  evas_textblock_cursor_node_text_length_get
  evas_textblock_cursor_pos_get
  evas_textblock_cursor_pos_set
  evas_textblock_cursor_range_delete
  evas_textblock_cursor_range_geometry_get
  evas_textblock_cursor_range_text_get
  evas_textblock_cursor_text_append
  evas_textblock_cursor_text_prepend
  evas_textblock_escape_string_get
  evas_textblock_escape_string_range_get
  evas_textblock_string_escape_get
  evas_textblock_style_free
  evas_textblock_style_get
  evas_textblock_style_new
  evas_textblock_style_set
  evas_transform_compose
  evas_transform_identity_set
  evas_transform_rotate
  evas_transform_scale
  evas_transform_shear
  evas_transform_translate
);

my @__todo = qw(
  evas_async_events_put
  evas_cserve_config_get
  evas_cserve_config_set
  evas_cserve_connected_get
  evas_cserve_disconnect
  evas_cserve_image_cache_contents_clean
  evas_cserve_stats_get
  evas_cserve_want_get
  evas_object_box_layout_set
  evas_object_box_option_property_get
  evas_object_box_option_property_vget
  evas_object_box_option_property_vset
  evas_object_event_callback_del
  evas_object_event_callback_del_full
  evas_object_gradient_type_get
  evas_object_image_file_get
  evas_object_image_pixels_get_callback_set
  evas_object_intercept_clip_set_callback_add
  evas_object_intercept_clip_set_callback_del
  evas_object_intercept_clip_unset_callback_add
  evas_object_intercept_clip_unset_callback_del
  evas_object_intercept_color_set_callback_add
  evas_object_intercept_color_set_callback_del
  evas_object_intercept_hide_callback_add
  evas_object_intercept_hide_callback_del
  evas_object_intercept_layer_set_callback_add
  evas_object_intercept_layer_set_callback_del
  evas_object_intercept_lower_callback_add
  evas_object_intercept_lower_callback_del
  evas_object_intercept_move_callback_add
  evas_object_intercept_move_callback_del
  evas_object_intercept_raise_callback_add
  evas_object_intercept_raise_callback_del
  evas_object_intercept_resize_callback_add
  evas_object_intercept_resize_callback_del
  evas_object_intercept_show_callback_add
  evas_object_intercept_show_callback_del
  evas_object_intercept_stack_above_callback_add
  evas_object_intercept_stack_above_callback_del
  evas_object_intercept_stack_below_callback_add
  evas_object_intercept_stack_below_callback_del
  evas_object_map_get
  evas_object_text_font_get
  evas_object_textblock_style_get
  evas_smart_class_get
  evas_textblock_cursor_node_format_get
  evas_textblock_cursor_node_text_get
);

Sub::Exporter::setup_exporter(
    {
        'exports' => [ @__constants, @__funcs ],
        'groups'  => {
            'funcs'     => \@__funcs,
            'constants' => \@__constants
        },
    }
);

require XSLoader;
XSLoader::load('EFL::Evas', $VERSION);

1;

__END__

=head1 DESCRIPTION

Perl bindings for the Enlightenment Foundation Libraries (EFL) Evas library.

=head1 WARNING

include_file:docs/warning.txt

=head1 SYNOPSIS

    use EFL::Evas qw(:all);

    evas_init();

    ...

    evas_shutdown();

=head1 EXPORTED API/CONSTANTS

include_cmd:misc/supported-api.pl -header evas

=head1 SEE ALSO

include_file:docs/see_also.pod
