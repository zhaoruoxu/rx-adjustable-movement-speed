-- data.lua

local styles = data.raw["gui-style"].default

styles["rx_ams_content_frame"] = {
    type = "frame_style",
    parent = "inside_shallow_frame_with_padding",
    vertically_stretchable = "on"
}

styles["rx_ams_control_flow"] = {
    type = "horizontal_flow_style",
    vertical_align = "center",
    horizontal_spacing = 16
}

styles["rx_ams_deep_frame"] = {
    type = "frame_style",
    parent = "slot_button_deep_frame",
    vertically_stretchable = "on",
    horizontally_stretchable = "on",
    top_margin = 16,
    left_margin = 8,
    right_margin = 8,
    bottom_margin = 4
}

data:extend({
    {
        type = "custom-input",
        name = "rx_ams_toggle_ui",
        key_sequence = "CONTROL + I",
        order = "r"
    },
    {
        type = "shortcut",
        name = "rx_ams_toggle_shortcut",
        order = "a[adjust]-m[movement]-s[speed]",
        action = "lua",
        associated_control_input = "rx_ams_toggle_ui",
        localised_name = {"shortcuts.toggle"},
        toggleable = true,
        icon = "__rx-adjustable-movement-speed__/graphics/movement_speed_1_m.png",
        icon_size = 128,
        disabled_icon = "__rx-adjustable-movement-speed__/graphics/movement_speed_1_m.png",
        disabled_icon_size = 128,
        small_icon = "__rx-adjustable-movement-speed__/graphics/movement_speed_1_s.png",
        small_icon_size = 64,
        disabled_small_icon = "__rx-adjustable-movement-speed__/graphics/movement_speed_1_s.png",
        disabled_small_icon_size = 64
    }
})
