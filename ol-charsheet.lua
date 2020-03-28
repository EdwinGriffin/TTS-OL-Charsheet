--Establishing persistence between loads--
local save_data
local def_attrs = {'agi_score', 'mig_score', 'fort_score', 'will_score', 'presence_score'}
local hp_attrs = {'fort_score', 'will_score', 'presence_score'}
local attr_costs = {'agi_cost', 'fort_cost', 'mig_cost', 
                    'dec_cost', 'presence_cost', 'pers_cost', 
                    'ler_cost', 'log_cost', 'perc_cost', 'will_cost', 
                    'alt_cost', 'cre_cost', 'ene_cost', 'ent_cost', 
                    'inf_cost', 'mov_cost', 'prescience_cost', 'pro_cost'}

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
--1d array iterator
function iterator_func(t)
    local i = 0
    return function() i = i + 1; return t[i] end
end

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
    setAttr("Lock", "raycastTarget", value)
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
    if value then 
        value = tonumber(value)
        --Update level
        local level = 0
        if value < 3 then level = 1 else level = math.floor(value/3) + 1 end
        set_text("level", level)
        --Update attr point total
        local attr_total = 40 + value * 3
        set_text("attr_total", attr_total)
        --Check formatting on attr_spent to see if it needs updating
        print(isnumber(get_text("attr_spent")))
        if attr_total < isnumber(get_text("attr_spent")) then
            set_attr("attr_spent", "color", "#FF0000")
        else
            set_attr("attr_spent", "color", "#666666")
        end
        --Update feat point total
        local feat_total = 6 + value
        set_text("feat_total", feat_total)
    end
end

-- Get the total cost values
function get_spent()
    local total_costs = 0
    for i in iterator_func(attr_costs) do
        total_costs = total_costs + tonumber(get_text(i))
    end
    return total_costs
end

function attr_updated(_, value, id)
    if value then
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
        local spent = get_spent() + cost
        set_text("attr_spent", spent)
        if spent > tonumber(get_text("attr_total")) then
            set_attr("attr_spent", "color", "#FF0000")
        else
            set_attr("attr_spent", "color", "#666666")
        end
        --Update def_attr
        --Update def
        --Update HP
    end
end