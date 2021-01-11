--[[
    Resturcturing:
    All ui elements need to be stored as global variables (local for the runtime of the script, global in the sense that they are across the object).
    Globals can be stored in arrays to minimise complexity.
    Event's fired from the XML should just be to update the globals, and then call the relevant update functions, which should read in the globals and make any modifications necessary.
    The save function should be called on all edits as normal.
    On load, globals will need to be populated from the save_data json object, then all update functions run.
]]--

--Establishing persistence between loads--
local save_data

-- Globals, because ui updates don't function apparently --
local damage = 0
local lethal_damage = 0
local other_hp = 0
local cost_to_attr = {[0] = 0, [1] = 1, [3] = 2, [6] = 3, [10] = 4, 
                    [15] = 5, [21] = 6, [28] = 7, [36] = 8, [45] = 9}
local guard_ids = {'guard_agi', 'guard_mig', 'guard_arm', 'guard_other'}
local toughness_ids = {'toughness_fort', 'toughness_will', 'toughness_other'}
local resolve_ids = {'resolve_presence', 'resolve_will', 'resolve_other'}
local hp_attrs = {'fort_cost', 'will_cost', 'presence_cost'}
local attr_costs = {'agi_cost', 'fort_cost', 'mig_cost', 
                    'dec_cost', 'presence_cost', 'pers_cost', 
                    'ler_cost', 'log_cost', 'perc_cost', 'will_cost', 
                    'alt_cost', 'cre_cost', 'ene_cost', 'ent_cost', 
                    'inf_cost', 'mov_cost', 'prescience_cost', 'pro_cost'}
local attr_scores = {'agi_score', 'fort_score', 'mig_score', 
                    'dec_score', 'presence_score', 'pers_score', 
                    'ler_score', 'log_score', 'perc_score', 'will_score', 
                    'alt_score', 'cre_score', 'ene_score', 'ent_score', 
                    'inf_score', 'mov_score', 'prescience_score', 'pro_score'}
local attributes = {['agility'] = 0, ['fortitude'] = 0, ['might'] = 0}

function onSave()
    return JSON.encode(save_data)
end

function onLoad(data)
    if data ~= "" then
        save_data = JSON.decode(data)
        load_data()
    else
        save_data = {
            ["Text"] = {},
            ["Toggle"] = {},
        }
    end
end

function onObjectSpawn(obj)
    if obj.getGUID() == self.getGUID() then
        load_data()
    end
end

function load_data()
    for type, values in pairs(save_data) do
        if type == "Text" then
            for id, value in pairs(values) do
                set_text(id, value)
                if string.find(id, "xp") then
                    xp_changed(_, value, id)
                elseif string.find(id, "guard") or 
                        string.find(id, "toughness") or
                        string.find(id, "resolve") then
                    def_updated(_, value, id)
                elseif string.find(id, "score") then
                    attr_updated(_, value, id)
                elseif string.find(id, 'hp') then
                    update_hp_other(_, value, id)
                elseif string.find('dmg', id) then
                    update_damage(_, value, id)
                elseif string.find('lethal_damage', id) then
                    update_lethal_damage(_, value, id)
                end
            end
        elseif type == "Toggle" then
            for id, value in pairs(values) do
                if id == "LockToggle" then
                    setAttr("Lock", "raycastTarget", value)
                end
                set_toggle(id, value)
            end
        end
    end
end

--Basic Functions--
function save(type, id, value)
    save_data[type][id] = value
	self.script_state = JSON.encode(save_data)
end

function get_attr(id, attribute)
    return self.UI.getAttribute(id, attribute)
end

function set_attr(id, attribute, value)
    self.UI.setAttribute(id, attribute, value)
end

-- Saving text --
function save_text(id, value)
    save("Text", id, value)
end

function get_text(id)
    return get_attr(id, "text")
end

function set_text(id, value)
    set_attr(id, "text", value)
end

-- Saving toggle buttons --
function save_toggle(id, value)
    save("Toggle", id, value)
end

function get_toggle(id)
    return get_attr(id, "isOn")
end

function set_toggle(id, value)
    set_attr(id, "isOn", value)
end

-- hide ? --
function hide(id)
    set_attr(id, "active", "false")
end

function show(id)
    set_attr(id, "active", "true")
end

--XML Functions--
--InputField--
function update_field(_, value, id)
	set_text(id, value)
    save_text(id, value)
end

-- Custom lock button --
function update_lock(_, value, id)
    set_attr("Lock", "raycastTarget", value)
    save_toggle(id, value)
end

--Reset--
function reset_sheet()
	save_data = {
		["Text"] = {},
		["Toggle"] = {},
	}

	self.script_state = JSON.encode(save_data)
	self.reload()
end

-- Automation functions --
function xp_changed(_, value, id)
    if value and not is_empty(value) then 
        value = tonumber(value)
        --Update level
        local level = 0
        if value < 3 then level = 1 else level = math.floor(value/3) + 1 end
        set_text("level", level)
        --Update attr point total
        local attr_total = 40 + value * 3
        set_text("attr_total", attr_total)
        --Check formatting on attr_spent to see if it needs updating
        if attr_total < tonumber(get_text("attr_spent")) then
            set_attr("attr_spent", "color", "#FF0000")
        else
            set_attr("attr_spent", "color", "#666666")
        end
        --Update feat point total
        local feat_total = 6 + value
        set_text("feat_total", feat_total)
    end
end

-- Get values from a change in the defence entries
function def_updated(_, value, id)
    if value and not is_empty(value) then
        --Identify the id so you can get the corresponding ids
        local results = {}
        for match in string.gmatch(id, "[^_]+") do
            table.insert(results, match)
        end
        local attr_id = results[2]
        value = tonumber(value)
        if string.find(id, "guard") then
            local new_guard = update_guard(attr_id) + value
            set_text("guard_" .. attr_id, value)
            set_text("guard", new_guard)
        elseif string.find(id, "toughness") then
            local new_toughness = update_toughness(attr_id) + value
            set_text("toughness_" .. attr_id, value)
            set_text("toughness", new_toughness)
        elseif string.find(id, "resolve") then
            local new_resolve = update_resolve(attr_id) + value
            set_text("resolve_" .. attr_id, value)
            set_text("resolve", new_resolve)
        end
    end
end

-- what to do if an attribute is updated
function attr_updated(_, value, id)
    
    if value and not is_empty(value) then
        --Identify the id so you can get the corresponding ids
        local results = {}
        for match in string.gmatch(id, "[^_]+") do
            table.insert(results, match)
        end
        local attr_id = results[1]
        value = tonumber(value)
        --Update cost
        local cost = value * (value+1) / 2
        set_text(attr_id .. "_cost", cost)
        
        --Update dice
        local dice = 'd20'
        if value == 1 then
            dice = 'd4'
        elseif value == 2 then
            dice = 'd6'
        elseif value == 3 then
            dice = 'd8'
        elseif value == 4 then
            dice = 'd10'
        elseif value == 5 then
            dice = '2d6'
        elseif value == 6 then
            dice = '2d8'
        elseif value == 7 then
            dice = '2d10'
        elseif value == 8 then
            dice = '3d8'
        elseif value == 9 then
            dice = '3d10'
        end
        set_text(attr_id .. "_dice", dice)

        --Update attr_spent
        local spent = get_spent(attr_id) + cost
        set_text("attr_spent", spent)
        if spent > tonumber(get_text("attr_total")) then
            set_attr("attr_spent", "color", "#FF0000")
        else
            set_attr("attr_spent", "color", "#666666")
        end

        --Update def_attr
        for i, v in ipairs(guard_ids) do
            if string.find(v, attr_id) then
                local new_guard = update_guard(attr_id) + value
                set_text("guard_" .. attr_id, value)
                set_text("guard", new_guard)
            end
        end
        for i, v in ipairs(toughness_ids) do
            if string.find(v, attr_id) then
                local new_toughness = update_toughness(attr_id) + value
                set_text("toughness_" .. attr_id, value)
                set_text("toughness", new_toughness)
            end
        end
        for i, v in ipairs(resolve_ids) do
            if string.find(v, attr_id) then
                local new_resolve = update_resolve(attr_id) + value
                set_text("resolve_" .. attr_id, value)
                set_text("resolve", new_resolve)
            end
        end

        --Update HP
        for i, v in ipairs(hp_attrs) do
            if string.find(v, attr_id) then 
                calc_hp(attr_id, value, true)
            end
        end
    end
end

--Custom HP modifier
function update_hp_other(_, value, id)
    other_hp = tonumber(value)
    calc_hp(id, value, false)
end

--Handling changes to damage and lethal damage
function update_damage(_, value, id)
    damage = tonumber(value)
    calc_hp(id, value, false)
end

function update_lethal_damage(_, value, id)
    lethal_damage = tonumber(value)
    calc_hp(id, value, false)
end

-- Helper Functions (these are called by the automatic functions to better segment the code)
-- Get the total cost values, except for the triggering attribute
-- Check if a value is empty --
function is_empty(value)
    return value == nil or value == ''
end

function get_spent(attr_id)
    local total_costs = 0
    for i, v in ipairs(attr_costs) do
        if not string.find(v, attr_id) then
            total_costs = total_costs + tonumber(get_text(v))
        end
    end
    return total_costs
end

-- Update the defensive scores
-- Update Guard
function update_guard(attr_id)
    local guard = 10
    for i, v in ipairs(guard_ids) do
        if not string.find(v, attr_id) then
            guard = guard + tonumber(get_text(v))
        end
    end
    return guard
end
-- Update Toughness
function update_toughness(attr_id)
    local toughness = 10
    for i, v in ipairs(toughness_ids) do
        if not string.find(v, attr_id) then
            toughness = toughness + tonumber(get_text(v))
        end
    end
    return toughness
end
-- Update Resolve
function update_resolve(attr_id)
    local resolve = 10
    for i, v in ipairs(resolve_ids) do
        if not string.find(v, attr_id) then
            resolve = resolve + tonumber(get_text(v))
        end
    end
    return resolve
end

function calc_hp(id, value, attr)
    -- Calculate the attribute contributions
    local attr_total = 0
    local max_hp = 0
    for i, v in ipairs(hp_attrs) do
        if not string.find(v, id) then
            attr_total = attr_total + cost_to_attr[tonumber(get_text(v))]
        end
    end
    if attr then
        max_hp = 10 + 2 * (attr_total + value) + other_hp
    else
        max_hp = 10 + 2 * (attr_total) + other_hp
    end
    max_hp = max_hp - lethal_damage
    set_text("hp_max", max_hp)
    local current_hp = max_hp - damage
    set_text("hp_current", current_hp)
end