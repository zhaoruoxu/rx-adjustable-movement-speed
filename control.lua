-- control.lua

local mod_gui = require("mod-gui")

local function create_gui(player)
    player.print("rx 01")
    mod_gui.get_button_flow(player).add({
        type = "slider",
        style = "rx_slider",
        name = "rx_button_test",
        caption = "Speed",
        minimum_value = 0,
        maximum_value = 20,
        value = 0,
        value_step = 1,
        tooltip = "Movement speed"
    })
end

local function initialize()
    for _, player in pairs(game.players) do
        create_gui(player)
    end
end

script.on_init(initialize)
script.on_configuration_changed(initialize)

