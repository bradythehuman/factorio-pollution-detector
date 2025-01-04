---- Mod Settings ----
-- local update_interval = 120
local update_interval = settings.startup["pollution_detector_update_interval"].value
local multiplier = settings.startup["pollution_detector_multiplier"].value
local floor = math.floor

---- runtime Events ----
function OnEntityCreated(event)
    local entity
    if event.entity and event.entity.valid then
        entity = event.entity
    end
    if event.created_entity and event.created_entity.valid then
        entity = event.created_entity
    end

    if entity.name == "pollution-detector" then
        if storage == nil then
            -- log("storage is nil for OnEntityCreated.")
            storage = {}
        end
        if storage.Pollution_Detectors == nil then
            -- log("storage.Pollution_Detectors is nil for OnEntityCreated.")
            storage.Pollution_Detectors = {}
        end
        table.insert(storage.Pollution_Detectors, entity)
        -- register to events after placing the first sensor
        if #storage.Pollution_Detectors == 1 then
            script.on_event(defines.events.on_tick, OnTick)
            script.on_event({ defines.events.on_pre_player_mined_item, defines.events.on_robot_pre_mined, defines.events.on_entity_died }, OnEntityRemoved)
        end
    end
end

function OnEntityRemoved(event)
    if event.entity.name == "pollution-detector" then

        for i = #storage.Pollution_Detectors, 1, -1 do
            if storage.Pollution_Detectors[i].unit_number == event.entity.unit_number then
                table.remove(storage.Pollution_Detectors, i)
            end
        end

        -- unregister when last sensor was removed
        if #storage.Pollution_Detectors == 0 then
            script.on_event(defines.events.on_tick, nil)
            script.on_event({ defines.events.on_pre_player_mined_item, defines.events.on_robot_pre_mined, defines.events.on_entity_died }, nil)
        end
    end
end

-- stepping from tick modulo with stride by eradicator
function OnTick(event)
    local offset = event.tick % update_interval
    for i = #storage.Pollution_Detectors - offset, 1, -1 * update_interval do
        local pollution_detector = storage.Pollution_Detectors[i]
        local pollution_count = floor(pollution_detector.surface.get_pollution(pollution_detector.position) * multiplier)
        local signal = { value = "pd-pollution", min = pollution_count }
        -- Section clear code: copied from "PollutionCombinator-JamieFork".
        for _, section in pairs(pollution_detector.get_control_behavior().sections) do
            pollution_detector.get_control_behavior().remove_section(section.index);
        end
        local section = pollution_detector.get_control_behavior().add_section("");
        if (not section) then
            return false;
        end
        section.set_slot(1, signal)
    end
end

---- Init ----
local function init_Pollution_Detectors()
    -- gather all pollution detectors on every surface in case another mod added some

    if storage == nil then
        -- log("storage is nil for init_Pollution_Detectors.")
        storage = {}
    end
    if storage.Pollution_Detectors == nil then
        -- log("storage.Pollution_Detectors is nil for init_Pollution_Detectors.")
        storage.Pollution_Detectors = {}
    end
    for _, surface in pairs(game.surfaces) do
        -- log("surface.name: " .. surface.name)
        pollution_detectors = surface.find_entities_filtered {
            name = "pollution-detector",
        }
        for _, pollution_detector in pairs(pollution_detectors) do
            table.insert(storage.Pollution_Detectors, pollution_detector)
        end
    end
end

local function init_events()
    script.on_event({ defines.events.on_built_entity, defines.events.on_robot_built_entity, defines.events.script_raised_built, defines.events.script_raised_revive }, OnEntityCreated)

    if storage and storage.Pollution_Detectors and next(storage.Pollution_Detectors) then
        script.on_event(defines.events.on_tick, OnTick)
        script.on_event({ defines.events.on_pre_player_mined_item, defines.events.on_robot_pre_mined, defines.events.on_entity_died }, OnEntityRemoved)
    end
end

script.on_load(function()
    -- log("on_load called.")
    init_events()
end)

script.on_init(function()
    -- log("on_init called.")
    init_Pollution_Detectors()
    init_events()
end)

script.on_configuration_changed(function(data)
    -- log("on_configuration_changed called.")
    init_Pollution_Detectors()
    init_events()
end)
