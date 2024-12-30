-- control.lua

local function initialize_storage(player)
    storage.players[player.index] = {
        is_active = false,
        movement_speed = 1,
        elements = {}
    }
end

local function to_speed_display_string(speed)
    if speed == 0 then return "+0%" end
    return "+" .. tostring(speed) .. "00%"
end

local function update_ui(player_storage)
    player_storage.elements.toggle_button.caption =
        player_storage.is_active and {"ams.deactivate"} or {"ams.activate"}
    player_storage.elements.slider.enabled = player_storage.is_active
    player_storage.elements.slider.slider_value = player_storage.movement_speed
    player_storage.elements.label.caption =
        to_speed_display_string(player_storage.movement_speed)
end

local function build_ui(player)
    local player_storage = storage.players[player.index]

    local main_frame = player.gui.screen.add{
        type = "frame",
        name = "rx_ams_main_frame",
        caption = {"ams.main_frame_caption"}
    }
    main_frame.style.size = {385, 165}
    main_frame.auto_center = true

    player.opened = main_frame
    player_storage.elements.main_frame = main_frame

    local content_frame = main_frame.add{
        type = "frame",
        name = "rx_ams_content_frame",
        direction = "vertical",
        style = "rx_ams_content_frame"
    }
    local controls_flow = content_frame.add{
        type = "flow",
        name = "rx_ams_controls_flow",
        direction = "horizontal",
        style = "rx_ams_control_flow"
    }
    local toggle_button = controls_flow.add{
        type = "button",
        name = "rx_ams_controls_toggle_button"
    }
    player_storage.elements.toggle_button = toggle_button

    local slider = controls_flow.add{
        type = "slider",
        name = "rx_ams_controls_slider",
        minimum_value = 0,
        maximum_value =
            settings.get_player_settings(player.index)["rx_ams_max_movement_speed"].value,
        style = "notched_slider",
    }
    player_storage.elements.slider = slider

    local label = controls_flow.add{
        type = "label",
        name = "rx_ams_controls_label",
    }
    player_storage.elements.label = label

    update_ui(player_storage)
end

local function update_speed(player)
    local player_storage = storage.players[player.index]
    player.set_shortcut_toggled("rx_ams_toggle_shortcut", player_storage.is_active)
    if player_storage.is_active then
        if player.character_running_speed_modifier == player_storage.movement_speed then
            return
        end

        player.character_running_speed_modifier = player_storage.movement_speed
        player.create_local_flying_text {
            text = {
                "ams.speed_change_notice",
                to_speed_display_string(player.character_running_speed_modifier)
            },
            position = player.position,
            color = {r=0, g=1, b=0},
            time_to_live = 60
        }
    else
        if player.character_running_speed_modifier == 0 then return end
        player.character_running_speed_modifier = 0
        player.create_local_flying_text {
            text = {"ams.speed_reset_notice"},
            position = player.position,
            color = {r=0, g=1, b=0},
            time_to_live = 60
        }
    end
end

local function toggle_ui(player)
    local player_storage = storage.players[player.index]
    local main_frame = player_storage.elements.main_frame

    if main_frame == nil then
        build_ui(player)
    else
        update_speed(player)
        main_frame.destroy()
        player_storage.elements = {}
    end
end

script.on_init(function ()
    local freeplay = remote.interfaces["freeplay"]
    if freeplay then  -- Disable freeplay popup-message
        if freeplay["set_skip_intro"] then remote.call("freeplay", "set_skip_intro", true) end
        if freeplay["set_disable_crashsite"] then remote.call("freeplay", "set_disable_crashsite", true) end
    end

    storage.players = {}

    for _, player in pairs(game.players) do
        initialize_storage(player)
    end
end)

script.on_configuration_changed(function (config_changed_data)
    if config_changed_data.mod_changes["rx-adjustable-movement-speed"] then
        for _, player in pairs(game.players) do
            local s = storage.players[player.index]
            if s.elements.main_frame ~= nil then
                toggle_ui(player)
            end
        end
    end
end)

script.on_event(defines.events.on_player_created, function(event)
    local player = game.get_player(event.player_index)
    initialize_storage(player)
end)

script.on_event(defines.events.on_player_removed, function(event)
    storage.players[event.player_index] = nil
end)

script.on_event("rx_ams_toggle_ui", function (event)
    toggle_ui(game.get_player(event.player_index))
end)

script.on_event(defines.events.on_gui_closed, function (event)
    if event.element and event.element.name == "rx_ams_main_frame" then
        local player = game.get_player(event.player_index)
        toggle_ui(player)
    end
end)

script.on_event(defines.events.on_gui_click, function (event)
    if event.element.name == "rx_ams_controls_toggle_button" then
        local player_storage = storage.players[event.player_index]
        player_storage.is_active = not player_storage.is_active
        update_ui(player_storage)
    end
end)

script.on_event(defines.events.on_gui_value_changed, function (event)
    if event.element.name == "rx_ams_controls_slider" then
        local player_storage = storage.players[event.player_index]
        player_storage.movement_speed = event.element.slider_value
        update_ui(player_storage)
    end
end)

script.on_event(defines.events.on_lua_shortcut, function (event)
    if event.prototype_name == "rx_ams_toggle_shortcut" then
        local player = game.get_player(event.player_index)
        local player_storage = storage.players[event.player_index]
        if player.is_shortcut_toggled("rx_ams_toggle_shortcut") then
            player_storage.is_active = false
            if player_storage.elements.main_frame ~= nil then
                toggle_ui(player)
            end
            update_speed(player)
        else
            player_storage.is_active = true
            update_speed(player)
            toggle_ui(player)
        end
    end
end)