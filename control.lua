-- control.lua

local mod_gui = require("mod-gui")
local slider_name = "rx_movement_speed_slider"

local function create_gui(player)
    player.print("rx 01")
    mod_gui.get_button_flow(player).add({
        type = "slider",
        --style = "rx_slider",
        style = "notched_slider",
        name = slider_name,
        caption = "Speed",
        minimum_value = 0,
        maximum_value = 20,
        value = 0,
        value_step = 1,
        tooltip = "Adjust movement speed"
    })
end

local function initialize()
    for _, player in pairs(game.players) do
        create_gui(player)
    end
end

local function set_movement_speed(event)
    local player = game.players[event.player_index]
    if (player.character == nil) then
        return
    end
    if (player.character_running_speed_modifier ~= event.element_slider_value) then
        return
    end

    player.character_running_speed_modifier = event.element.slider_value
    player.create_local_flying_text{
        text = "Movement speed: " .. player.character_running_speed_modifier,
        position = player.position,
        color = {r=0, g=1, b=0},
        time_to_live = 30
    }
end

script.on_init(initialize)
script.on_configuration_changed(initialize)
script.on_event(defines.events.on_gui_value_changed, function(event)
    if event.element.name == "rx_button_test" then
        set_movement_speed(event)
    end
end)
