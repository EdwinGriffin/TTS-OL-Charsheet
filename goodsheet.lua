----#include LDD5ECS/CharacterSheet.ttslua
local saveData;

function onSave()
    return JSON.encode(saveData);
end

function onLoad(data)
    if data ~= "" then
        saveData = JSON.decode(data);

        loadData();
    else
        saveData = {
            ["Bullet"] = {},
            ["Check"] = {},
            ["Text"] = {},
            ["Toggle"] = {},
        };
    end
end

function onObjectSpawn(obj)
    if obj.getGUID() == self.getGUID() then
        loadData();
    end
end

function loadData()
    for type, values in pairs(saveData) do
        if type == "Bullet" then
            for id, value in pairs(values) do
                setBullet(id, value);
            end
        elseif type == "Check" then
            for id, value in pairs(values) do
                setCheck(id, value);
            end
        elseif type == "Text" then
            for id, value in pairs(values) do
                setText(id, value);
            end
        elseif type == "Toggle" then
            for id, value in pairs(values) do
                if id == "LockToggle" then
                    setAttr("Lock", "raycastTarget", value);
                end

                setToggle(id, value);
            end
        end
    end
end

--Basic Functions--
function save(type, id, value)
    saveData[type][id] = value;
	self.script_state = JSON.encode(saveData);
end

function getAttr(id, attribute)
    return self.UI.getAttribute(id, attribute);
end

function setAttr(id, attribute, value)
    self.UI.setAttribute(id, attribute, value);
end

function hide(id)
    setAttr(id, "active", "false");
end

function show(id)
    setAttr(id, "active", "true");
end

function saveBullet(id, value)
    save("Bullet", id, value);
end

function setBullet(id, value)
    setAttr(id, "isOn", value);

    if string.lower(value) == "true" then
        setText(id, "•");
    else
        setText(id, "");
    end
end

function saveCheck(id, value)
    save("Check", id, value);
end

function setCheck(id, value)
    setAttr(id, "isOn", value);

    if string.lower(value) == "true" then
        setText(id, "✔");
    else
        setText(id, "");
    end
end

function saveText(id, value)
    save("Text", id, value);
end

function getText(id)
    return getAttr(id, "text");
end

function setText(id, value)
    setAttr(id, "text", value);
end

function saveToggle(id, value)
    save("Toggle", id, value);
end

function getToggle(id)
    return getAttr(id, "isOn");
end

function setToggle(id, value)
    setAttr(id, "isOn", value);
end

--XML Functions--
--InputField--
function updateField(_, value, id)
	setText(id, value);
    saveText(id, value);
end

--Toggle--
function updateBullet(_, value, id)
    if string.lower(value) == "true" then
        setText(id, "•");
    else
        setText(id, "");
    end

    saveBullet(id, value);
end

function updateCheck(_, value, id)
    if string.lower(value) == "true" then
        setText(id, "✔");
    else
        setText(id, "");
    end

    saveCheck(id, value);
end

function updateLock(_, value, id)
    setAttr("Lock", "raycastTarget", value);
    saveToggle(id, value);
end

--Reset--
function resetSheet()
	saveData = {
		["Bullet"] = {},
		["Check"] = {},
		["Text"] = {},
		["Toggle"] = {},
	};

	self.script_state = JSON.encode(saveData);
	self.reload();
end

----#include LDD5ECS/CharacterSheet.ttslua