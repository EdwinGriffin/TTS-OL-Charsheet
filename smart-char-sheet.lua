----#include <!/smart-character-sheet/main>
do
----------------------------
--Smart 5e Character Sheet--
--by nabbydude            --
----------------------------

----#include <./localization>
do
----------------
--Localization--
----------------

--[[
Changes this patch:

+Loc.exhaustion
+Loc.hitPointsInitials
+Loc.deathSavesInitials
+Loc.dataFromNewerVersion
]]

local bull = string.char(0x2022) --bullet

Loc = {
  loadingDefault = "No character data found, loading default character",

  lawfulAlignments = {"Lawful", "Neutral", "Chaotic"},
  goodAlignments   = {"Good", "Neutral", "Evil"},
  trueNeutral      = {"True", "Neutral"},

  maxExperience = "MAX",

  abilities = {
    strength     = "Strength",
    dexterity    = "Dexterity",
    constitution = "Constitution",
    intelligence = "Intelligence",
    wisdom       = "Wisdom",
    charisma     = "Charisma"
  },
  abilitiesShort = {
    str = "Str",
    dex = "Dex",
    con = "Con",
    int = "Int",
    wis = "Wis",
    cha = "Cha"
  },

  skills = {
    acrobatics     = "Acrobatics",
    animalHandling = "Animal Handling",
    arcana         = "Arcana",
    athletics      = "Athletics",
    deception      = "Deception",
    history        = "History",
    insight        = "Insight",
    intimidation   = "Intimidation",
    investigation  = "Investigation",
    medicine       = "Medicine",
    nature         = "Nature",
    perception     = "Perception",
    performance    = "Performance",
    persuasion     = "Persuasion",
    religion       = "Religion",
    sleightOfHand  = "Sleight of Hand",
    stealth        = "Stealth",
    survival       = "Survival"
  },

  exhaustion = {
    bull.." No effects",
    bull.." Disadvantage on Ability Checks",
    bull.." Disadvantage on Ability Checks "..bull.." Speed halved",
    bull.." Disadvantage on Ability Checks, Attack Rolls and Saving Throws "..bull.." Speed halved",
    bull.." Disadvantage on Ability Checks, Attack Rolls and Saving Throws "..bull.." Speed halved "..bull.." Max HP halved",
    bull.." Disadvantage on Ability Checks, Attack Rolls and Saving Throws "..bull.." Speed reduced to 0 "..bull.." Max HP halved",
    bull.." Death"
  },

  hitPointsInitials = "HP",
  deathSavesInitials = "DS",

  noTraitSelected     = "No Trait Selected",
  noTraitSelectedDesc = "Click a trait on the side",

  pasteJson            = "Paste JSON here",
  dataImported         = "Imported character data for %s",
  dataNotRecognised    = "Character data not recognised",
  dataFromNewerVersion = "Character only compatible with newer sheet version",
  dataWillReset        = "Character data will be reset on reload"
}

end
----#include <./localization>
----#include <./default-character>
do
DefaultCharacter = [[
  {
    "jsonVersion": 3,
    "name": "",
    "player": "",
    "race": "",
    "class": "",
    "alignment": [1, 1],
    "background": "",
    "exp": 0,
    "abilities": {
      "str": 10,
      "dex": 10,
      "con": 10,
      "int": 10,
      "wis": 10,
      "cha": 10
    },
    "inspiration": false,
    "proficiencyBonus": 2,
    "throws": {
      "str": { "proficiency": 0, "mod": 0 },
      "dex": { "proficiency": 0, "mod": 0 },
      "con": { "proficiency": 0, "mod": 0 },
      "int": { "proficiency": 0, "mod": 0 },
      "wis": { "proficiency": 0, "mod": 0 },
      "cha": { "proficiency": 0, "mod": 0 }
    },
    "skills": {
      "acrobatics":     { "proficiency": 0, "mod": 0 },
      "animalHandling": { "proficiency": 0, "mod": 0 },
      "arcana":         { "proficiency": 0, "mod": 0 },
      "athletics":      { "proficiency": 0, "mod": 0 },
      "deception":      { "proficiency": 0, "mod": 0 },
      "history":        { "proficiency": 0, "mod": 0 },
      "insight":        { "proficiency": 0, "mod": 0 },
      "intimidation":   { "proficiency": 0, "mod": 0 },
      "investigation":  { "proficiency": 0, "mod": 0 },
      "medicine":       { "proficiency": 0, "mod": 0 },
      "nature":         { "proficiency": 0, "mod": 0 },
      "perception":     { "proficiency": 0, "mod": 0 },
      "performance":    { "proficiency": 0, "mod": 0 },
      "persuasion":     { "proficiency": 0, "mod": 0 },
      "religion":       { "proficiency": 0, "mod": 0 },
      "sleightOfHand":  { "proficiency": 0, "mod": 0 },
      "stealth":        { "proficiency": 0, "mod": 0 },
      "survival":       { "proficiency": 0, "mod": 0 }
    },
    "armorClass": 15,
    "initiative": 15,
    "speed": 30,
    "exhaustion": 0,
    "spellcasting": {
      "active": true,
      "ability": "cha",
      "attackBonusMod": 0,
      "saveDcMod": 0
    },
    "hp": {
      "temp": 0,
      "current": 6,
      "max": 6
    },
    "hitDice": {
      "total": "1d6",
      "remaining": "1d6"
    },
    "deathSaves": {
      "successes": 0,
      "failures": 0
    },
    "attacks": [
      {
        "name": "Greatsword",
        "bonus": 2,
        "damage": "2d6 slashing",
        "notes": "Heavy, two-handed"
      },
      {
        "name": "Shortsword",
        "bonus": 2,
        "damage": "1d6 piercing",
        "notes": "Finesse, light"
      }
    ],
    "traits": [
      {
        "name": "Lucky",
        "desc": "This guy super lucky"
      },
      {
        "name": "Unlucky",
        "desc": "But he super unlucky"
      }
    ],
    "notes": ""
  }
]]

end
----#include <./default-character>

----#include <!/util>
do
--inline if statement
function iif(condition, ifTrue, ifFalse)
  if condition then return ifTrue end
  return ifFalse
end

--replace all instances of {{x}} with dictionary.x
function mustacheReplace(str, dictionary)
  return tostring(str):gsub("{{(.-)}}", function(a)
    return tostring(dictionary[a])
  end)
end

--prevents unity rich text tags from being parsed
function escapeRichText(str)
  return tostring(str):gsub("<", "<<b></b>")
end

end
----#include <!/util>
----#include <!/xml>
do
xml = {}

xml.layoutHacks = {}

--traverse an XML table (such as from UI.getXmlTable()), running a visitor
--function on each node
function xml.traverse(tbl, visitor)
  local returnFlags
  for _, node in ipairs(tbl) do
    returnFlags = { traverseChildren = true, done = false, newNode = node }
    visitor(node, returnFlags)
    node = returnFlags.newNode

    if returnFlags.done then return end
    if returnFlags.traverseChildren and node.children then
      xml.traverse(node.children, visitor)
    end
  end
end

--traverse an XML table (such as from UI.getXmlTable()) alongside gameObjects
--(such as from self.getChild("XmlUIWorldCanvas(Clone)").getChild("XmlLayout")
--.getChildren()), running a visitor function on each node
function xml.traverseWithGameObjects(tbl, gameObjects, visitor)
  local returnFlags

  local goIndex = 1
  for i, node in ipairs(tbl) do
    local obj = gameObjects[goIndex]
    if node.tag == obj.name then
      goIndex = goIndex + 1
      returnFlags = { traverseChildren = true, done = false }
      visitor(node, obj, returnFlags)

      if returnFlags.done then return end
      if returnFlags.traverseChildren and node.children then
        if obj.name == "VerticalScrollView" or
          obj.name == "HorizontalScrollView"
        then
          obj = obj.getChild("Viewport").getChild("Content")
        end
        xml.traverseWithGameObjects(node.children, obj.getChildren(), visitor)
      end
    end
  end
end

function xml.edit(func, afterUpdateFunc)
  local tbl = self.UI.getXmlTable()
  func(tbl)
  xml.beforeRebuild()
  self.UI.setXmlTable(tbl)
  Wait.frames(function()
    xml.onRebuild()
    if afterUpdateFunc then afterUpdateFunc() end
  end, 2)
end

function xml.set(id, attrs, exclude)
  if not exclude or not exclude[id] then self.UI.setAttributes(id, attrs) end
end

function xml.triggerLayout()
  for _, id in ipairs(xml.layoutHacks) do
    self.UI.setAttribute(id, "active", true)
    self.UI.setAttribute(id, "active", false)
  end
end

function xml.beforeRebuild() end

function xml.onRebuild()
  xml.updateAll()
end

function xml.updateAll(exclude)
  xml.triggerLayout()
end

end
----#include <!/xml>
----#include <!/xml-bind>
do
-- #include <!/util>
-- #include <!/xml>


xmlBind = {
  bindings = {}
}

function xmlBind.initialize()
  _G["xmlBind.defaultOnFieldFocus"  ] = xmlBind.defaultOnFieldFocus
  _G["xmlBind.defaultOnFieldEdit"   ] = xmlBind.defaultOnFieldEdit
  _G["xmlBind.defaultOnFieldUnfocus"] = xmlBind.defaultOnFieldUnfocus
  _G["xmlBind.defaultOnNudgeClick"  ] = xmlBind.defaultOnNudgeClick
  _G["xmlBind.defaultOnToggleClick" ] = xmlBind.defaultOnToggleClick
end

--------------
--XML Events--
--------------

function xmlBind.defaultOnFieldFocus(_, button, id)
  if button ~= "-1" then return end
  local bind = xmlBind.bindings[id]

  xml.set(id, {
    characterValidation = bind.characterValidation or iif(
      type(xmlBind.getBindValue(bind.keys)) == "number",
      "integer",
      "none"
    ),
    characterLimit = bind.characterLimit or 0,
    text = xmlBind.getBindValue(bind.keys)
  })
end

function xmlBind.defaultOnFieldEdit(_, value, id)
  local bind = xmlBind.bindings[id]

  if type(xmlBind.getBindValue(bind.keys)) == "number" then
    value = tonumber(value) or 0
  end
  xmlBind.setBindValue(bind.keys, value)

  xml.updateAll({ [id] = true })
end

function xmlBind.defaultOnFieldUnfocus()
  xml.updateAll()
end

function xmlBind.defaultOnNudgeClick(_, button, id)
  local coef
  if button == "-1" then coef = 1
  elseif button == "-2" then coef = 5
  else return end
  local nudge = xmlBind.bindings[id]
  local value = xmlBind.getBindValue(nudge.keys)
  local delta = tonumber(self.UI.getAttribute(id, "nudgeAmount")) * coef

  xmlBind.setBindValue(nudge.keys, value + delta)

  xml.updateAll()
end

function xmlBind.defaultOnToggleClick(_, button, id)
  if button ~= "-1" then return end
  local toggle = xmlBind.bindings[id]
  local value = xmlBind.getBindValue(toggle.keys)

  xmlBind.setBindValue(toggle.keys, not value)

  xml.updateAll()
end

---------------------
--Utility Functions--
---------------------

--converts "7" into "+7"
function xmlBind.prependPlus(num)
  if num > 0 then return "+"..num end
  return tostring(num)
end


function xmlBind.getBindValue(keys)
  local val = character
  for _, key in ipairs(keys) do
    val = val[key]
  end
  return val
end

function xmlBind.setBindValue(keys, value)
  local b = Bounds
  local t = character
  for i, key in ipairs(keys) do
    if i < #keys then
      t = t[key]
      if b and type(key) ~= "number" then b = b[key] end
    else
      if b and b[key] then value = math.max(b[key][1], math.min(value, b[key][2])) end
      t[key] = value
    end
  end
end

function xmlBind.registerBindings(nodes)
  xml.traverse(nodes, function(node, returnFlags)
    local attrs = node.attributes
    if not attrs or attrs.bindSkip == "true" then
      returnFlags.traverseChildren = false
    end
    if attrs.bind then
      local id = attrs.id
      local bind = { keys = {}, bindType = attrs.bindType }

      xmlBind.bindings[id] = bind

      for key in string.gmatch(attrs.bind, "([^%.]+)") do
        bind.keys[#bind.keys + 1] = tonumber(key) or key
      end

      bind.characterLimit = attrs.characterLimit
      bind.characterValidation = attrs.characterValidation
      attrs.characterLimit = 0

      local bt = attrs.bindType:lower()
      if bt == "field" then
        if not attrs.onValueChanged then attrs.onValueChanged = "xmlBind.defaultOnFieldEdit"    end
        if not attrs.onMouseDown    then attrs.onMouseDown    = "xmlBind.defaultOnFieldFocus"   end
        if not attrs.onEndEdit      then attrs.onEndEdit      = "xmlBind.defaultOnFieldUnfocus" end
      elseif bt == "nudge" then
        if not attrs.onClick then attrs.onClick = "xmlBind.defaultOnNudgeClick" end
      elseif bt == "toggle" then
        if not attrs.onClick then attrs.onClick = "xmlBind.defaultOnToggleClick" end
      end
    end
  end)
end

function xmlBind.unregisterBindings(nodes)
  xml.traverse(nodes, function(node, returnFlags)
    local attrs = node.attributes
    if not attrs or attrs.bindSkip == "true" then
      returnFlags.traverseChildren = false
    end
    if attrs.bind then
      xmlBind.bindings[attrs.id] = nil
    end
  end)
end

function xmlBind.resetBindings()
  xmlBind.bindings = {}
end

function xmlBind.wrapInputFields(nodes)
  xml.traverse(nodes, function(node, returnFlags)
    if node.tag == "Defaults" then
      xmlBind.wrapDefaults(node)
      returnFlags.traverseChildren = false
      return
    end
    if node.tag == "InputField" then
      xmlBind.wrapInputField(node)
      returnFlags.traverseChildren = false
    end
  end)
end

function xmlBind.wrapDefaults(node)
  local newChildren = {}
  for _, child in ipairs(node.children) do
    newChildren[#newChildren + 1] = child
    if child.tag == "InputField" then
      if child.attributes.textOffset or
        child.attributes.flexibleWidth or
        child.attributes.flexibleHeight or
        child.attributes.preferredWidth or
        child.attributes.preferredHeight
      then
        newChildren[#newChildren + 1] = {
          tag = "VerticalLayout",
          attributes = {
            class           = child.attributes.class and child.attributes.class:gsub("(%S+)", "%1_wrapper") or "_wrapper",
            padding         = child.attributes.textOffset,
            flexibleWidth   = child.attributes.flexibleWidth,
            flexibleHeight  = child.attributes.flexibleHeight,
            preferredWidth  = child.attributes.preferredWidth,
            preferredHeight = child.attributes.preferredHeight
          }
        }
      end
      if child.attributes.class or
        child.attributes.font or
        child.attributes.fontSize or
        child.attributes.fontStyle or
        child.attributes.textAlignment or
        child.attributes.text
      then
        newChildren[#newChildren + 1] = {
          tag = "Text",
          attributes = {
            class              = child.attributes.class and child.attributes.class:gsub("(%S+)", "%1_sizer") or "_sizer",
            font               = child.attributes.font,
            fontSize           = child.attributes.fontSize,
            fontStyle          = child.attributes.fontStyle,
            alignment          = child.attributes.textAlignment,
            text               = child.attributes.text,
            horizontalOverflow = child.attributes.lineType and iif(child.attributes.lineType == "singleLine", "overflow", "wrap")
          }
        }
      end
    end
  end
  node.children = newChildren
end

function xmlBind.wrapInputField(node)
  local inputField = {
    tag = "InputField",
    attributes = node.attributes,
    children = node.children
  }
  node.tag = "VerticalLayout"
  node.attributes = {}

  node.attributes.id      = inputField.attributes.id and inputField.attributes.id.."_wrapper"
  node.attributes.class   = (inputField.attributes.class or ""):gsub("(%S+)", "%1_wrapper").." _wrapper"
  node.attributes.padding = inputField.attributes.textOffset
  local layoutAttributes = {
    "ignoreLayout",
    "minWidth",
    "minHeight",
    "preferredWidth",
    "preferredHeight",
    "flexibleWidth",
    "flexibleHeight",

    "rectAlignment",
    "width",
    "height",
    "offsetXY",
    "contentSizeFitter",

    "anchorMin",
    "anchorMax",
    "sizeDelta",
    "pivot",
    "rotation",
    "scale",
    "offsetMin",
    "offsetMax"
  }
  for _, attr in ipairs(layoutAttributes) do
    node.attributes[attr] = inputField.attributes[attr]
    inputField.attributes[attr] = nil
  end

  inputField.attributes.ignoreLayout = true
  inputField.attributes.anchorMin = "0 0"
  inputField.attributes.anchorMax = "1 1"
  inputField.attributes.offsetMin = "0 0"
  inputField.attributes.offsetMax = "0 0"

  local text = {
    tag = "Text",
    attributes = {
      id                 = inputField.attributes.id and inputField.attributes.id.."_sizer",
      class              = (inputField.attributes.class or ""):gsub("(%S+)", "%1_sizer").." _sizer",
      font               = inputField.attributes.font,
      fontSize           = inputField.attributes.fontSize,
      fontStyle          = inputField.attributes.fontStyle,
      alignment          = inputField.attributes.textAlignment,
      text               = inputField.attributes.text,
      horizontalOverflow = inputField.attributes.lineType and iif(inputField.attributes.lineType == "singleLine", "overflow", "wrap"),
      flexibleWidth      = 1,
      flexibleHeight     = 1,
      color              = ""
    }
  }

  node.children = {
    text,
    inputField
  }
end

-----------------------
--UI Update Functions--
-----------------------

function xmlBind.updateBindeds(exclude)
  for id in pairs(xmlBind.bindings) do
    xmlBind.updateBinded(id, exclude)
  end
end

function xmlBind.updateBinded(id, exclude)
  local bind = xmlBind.bindings[id]
  local value = xmlBind.getBindValue(bind.keys)
  local attrs = self.UI.getAttributes(id)

  if bind.bindType == "field" then

    if attrs.prependPlus == "true" then value = xmlBind.prependPlus(value) end
    value = (attrs.prefix or "")..value..(attrs.suffix or "")

    xml.set(id, {
      characterValidation = "none",
      characterLimit = 0,
      text = escapeRichText(value)
    }, exclude)

    local sizerText = iif(value == "", attrs.placeholder, value)
    xml.set(id.."_sizer", {
      text = escapeRichText(sizerText)
    }, exclude)
  elseif bind.bindType == "toggle" then
    xml.set(id, { text = iif(
      value,
      string.char(10003), --check mark
      ""
    ) }, exclude)
  end
end


local oldUpdateAll = xml.updateAll
function xml.updateAll(exclude)
  xmlBind.updateBindeds(exclude)

  oldUpdateAll(exclude)
end

end
----#include <!/xml-bind>
----#include <!/xml-snippet>
do


xmlSnippet = {}

xmlSnippet.snippets = {}

--find all <Snippet> tags and add them to the snippet list
function xmlSnippet.registerSnippets(nodes)
  xml.traverse(nodes, function(node, returnFlags)
    if node.tag ~= "Snippets" then returnFlags.traverseChildren = false end
    if node.tag == "Snippet" then
      xmlSnippet.snippets[node.attributes.name or ""] = node.children
    end
  end)
end

--instantiates an XML snippet, (<Snippet> tag), adding mustache replacements
function xmlSnippet.createSnippet(base, dictionary)
  local snippet = {}
  for i, piece in ipairs(base) do
    local attributes = {}
    for key, value in pairs(piece.attributes) do
      attributes[key] = mustacheReplace(value, dictionary)
    end
    snippet[i] = {
      attributes = attributes,
      children = piece.children and xmlSnippet.createSnippet(piece.children, dictionary),
      tag = piece.tag,
      value = piece.value and mustacheReplace(piece.value, dictionary)
    }
  end
  return snippet
end

--create an XML snippet for each item of an array, and concatenate them all
function xmlSnippet.snippetsForEach(tbl, snippet, dictMap)
  local children = {}
    for i, item in ipairs(tbl) do
      local pieces = xmlSnippet.createSnippet(snippet, dictMap(item, i))
      for _, v in ipairs(pieces) do children[#children + 1] = v end
    end
    return children
end

end
----#include <!/xml-snippet>
----#include <!/better-scroll-view-3>
do
betterScrollView = {}

betterScrollView.scrollViews = {}

betterScrollView.numAnonScrollViews = 0

betterScrollView.building = true

betterScrollView.xmlDefaults = {
  tag = "Defaults",
  attributes = {
    id = "bsvDefaults"
  },
  children = {
    {
      tag = "VerticalScrollView",
      attributes = {
        class = "bsv_scrollView",
        childForceExpandWidth = false,
        childForceExpandHeight = false,
        noScrollbars = true,
        movementType = "unrestricted",
        anchorMin = "0 0",
        anchorMax = "1 1",
        offsetMin = "0 0",
        offsetMax = "0 0",
        image = "",
        maskImage = "",
        onValueChanged = "betterScrollView.defaultOnMouseWheel"
      }
    },
    {
      tag = "Panel",
      attributes = {
        class = "bsv_bounds",
        anchorMin = "0 1",
        anchorMax = "0 1"
      }
    },
    {
      tag = "HorizontalLayout",
      attributes = {
        class = "bsv_contentAndScrollbar",
        childForceExpandWidth = false,
        childForceExpandHeight = false,
        anchorMin = "0 0",
        anchorMax = "1 1",
        allowDragging = true,
        onClick = ""
      }
    },
    {
      tag = "VerticalLayout",
      attributes = {
        class = "bsv_viewport",
        flexibleWidth = 1,
        flexibleHeight = 1,
        childForceExpandWidth = false,
        childForceExpandHeight = false
      }
    },
    {
      tag = "Mask",
      attributes = {
        class = "bsv_mask",
        anchorMin = "0 0",
        anchorMax = "1 1",
        image = ""
      }
    },
    {
      tag = "VerticalLayout",
      attributes = {
        class = "bsv_maxContent",
        childAlignment = "upperCenter",
        childForceExpandWidth = false,
        childForceExpandHeight = false
      }
    },
    {
      tag = "VerticalLayout",
      attributes = {
        class = "bsv_content",
        flexibleWidth = "1",
        flexibleHeight = "0"
      }
    },
    {
      tag = "Panel",
      attributes = {
        class = "bsv_scrollbar",
        color = "#00000099",
        preferredWidth = 20,
        flexibleHeight = 1
      }
    },
    {
      tag = "Button",
      attributes = {
        class = "bsv_scrollbarHandle",
        allowDragging = true,
        returnToOriginalPositionWhenReleased = true,
        onDrag = "betterScrollView.defaultOnHandleDrag",
        onEndDrag = "betterScrollView.defaultOnHandleEndDrag"
      }
    }
  }
}

function betterScrollView.initialize()
  _G["betterScrollView.defaultOnMouseWheel"   ] = betterScrollView.defaultOnMouseWheel
  _G["betterScrollView.defaultOnHandleDrag"   ] = betterScrollView.defaultOnHandleDrag
  _G["betterScrollView.defaultOnHandleEndDrag"] = betterScrollView.defaultOnHandleEndDrag
end

function betterScrollView.register(nodes)
  table.insert(nodes, 1, betterScrollView.xmlDefaults)
  betterScrollView.wrapScrollViews(nodes)
 
end

--------------
--XML Events--
--------------

function betterScrollView.defaultOnMouseWheel(player, value, id)
  local id = id:match("(.+)_scrollView")
  local bsv = betterScrollView.scrollViews[id]
  if betterScrollView.building then return end

  local viewportHeight = bsv.viewportSizeMarkerRect.get("localPosition").y * 2
  local contentHeight = bsv.contentSizeMarkerRect.get("localPosition").y * 2

  local rawDelta = value:match(",(.+)")
  rawDelta = tonumber(rawDelta)

  local scrollDelta = (1 - rawDelta) * (512 - viewportHeight)
  bsv.scroll = bsv.scroll + scrollDelta

  bsv.scrollViewInnerRect.set("localPosition", {0, 0, 0})

  betterScrollView.clampScroll(bsv)
  betterScrollView.updateScroll(bsv)
end

function betterScrollView.defaultOnHandleDrag(_, _, id)
  local id = id:match("(.+)_scrollbarHandle")
  local bsv = betterScrollView.scrollViews[id]
  if betterScrollView.building then return end

  local viewportHeight = bsv.viewportSizeMarkerRect.get("localPosition").y * 2
  local contentHeight = bsv.contentSizeMarkerRect.get("localPosition").y * 2

  if contentHeight > viewportHeight then
    local boundsHeight = bsv.boundsSizeMarkerRect.get("localPosition").y * 2

    local v = bsv.scrollbarHandleRect.get("localPosition").y
    local max = boundsHeight * (1 - viewportHeight / contentHeight)

    bsv.scroll = (max / 2 - v) / boundsHeight * contentHeight
  end

  betterScrollView.clampScroll(bsv)
  betterScrollView.updateContentScroll(bsv)
end

function betterScrollView.defaultOnHandleEndDrag(_, _, id)
  local id = id:match("(.+)_scrollbarHandle")
  local bsv = betterScrollView.scrollViews[id]

  betterScrollView.clampScroll(bsv)
  betterScrollView.updateScroll(bsv)
end

---------------------
--Startup Functions--
---------------------

function betterScrollView.wrapScrollViews(nodes)
  xml.traverse(nodes, function(node, returnFlags)
    if node.tag == "Defaults" then
      returnFlags.traverseChildren = false
      return
    end
    if
      node.tag ~= "HorizontalScrollView" and
      node.tag ~= "VerticalScrollView"
    then return end

    returnFlags.newNode = betterScrollView.wrap(node)

    betterScrollView.scrollViews[node.attributes.id] = {
      id = node.attributes.id,
      scroll = 0,
      doMinContentHeight = node.attributes.doMinContentHeight == "true"
    }
  end)
end

function betterScrollView.wrap(node)
  node.tag = "Panel"
  if not node.attributes.id then
    node.attributes.id = "betterScrollView_"..betterScrollView.numAnonScrollViews
    betterScrollView.numAnonScrollViews = betterScrollView.numAnonScrollViews + 1
  end

  if node.attributes.class then
    node.attributes.class = node.attributes.class.." betterScrollView"
  else
    node.attributes.class = "betterScrollView"
  end

  node.attributes.isBetterScrollView = true

  local contentSizeMarker = {
    tag = "Panel",
    attributes = {
      id = node.attributes.id.."_contentSizeMarker",
      ignoreLayout = true,
      anchorMin = "1 1",
      anchorMax = "1 1"
    }
  }

  local layoutHack = {
    tag = "Panel",
    attributes = {
      id = node.attributes.id.."_layoutHack",
      active = false
    }
  }

  node.children[#node.children + 1] = layoutHack
  node.children[#node.children + 1] = contentSizeMarker
  xml.layoutHacks[#xml.layoutHacks + 1] = node.attributes.id.."_layoutHack"

  local content = {
    tag = "VerticalLayout",
    attributes = {
      id = node.attributes.id.."_content",
      class = "bsv_content"
    },
    children = node.children
  }

  node.children = {
    {
      tag = "VerticalScrollView",
      attributes = {
        id = node.attributes.id.."_scrollView",
        class = "bsv_scrollView",
        scrollSensitivity = node.attributes.scrollSensitivity
      },
      children = {
        {
          tag = "Panel",
          children = {
            {
              tag = "Panel",
              attributes = {
                id = node.attributes.id.."_bounds",
                class = "bsv_bounds"
              },
              children = {
                {
                  tag = "HorizontalLayout",
                  attributes = {
                    id = node.attributes.id.."_contentAndScrollbar",
                    class = "bsv_contentAndScrollbar",
                    spacing = node.attributes.verticalScrollbarSpacing
                  },
                  children = {
                    {
                      tag = "VerticalLayout",
                      attributes = {
                        id = node.attributes.id.."_viewport",
                        class = "bsv_viewport"
                      },
                      children = {
                        {
                          tag = "Panel",
                          attributes = {
                            flexibleWidth = 1,
                            flexibleHeight = 1
                          },
                          children = {
                            {
                              tag = "Mask",
                              attributes = {
                                id = node.attributes.id.."_mask",
                                class = "bsv_mask"
                              },
                              children = {
                                {
                                  tag = "VerticalLayout",
                                  attributes = {
                                    id = node.attributes.id.."_maxContent",
                                    class = "bsv_maxContent",
                                    width = node.attributes.maxContentWidth or 10000,
                                    height = node.attributes.maxContentHeight or 10000
                                  },
                                  children = {
                                    content
                                  }
                                }
                              }
                            },
                            {
                              tag = "Panel",
                              attributes = {
                                id = node.attributes.id.."_viewportSizeMarker",
                                ignoreLayout = true,
                                anchorMin = "1 1",
                                anchorMax = "1 1"
                              }
                            }
                          }
                        }
                      }
                    },
                    {
                      tag = "Panel",
                      attributes = {
                        id = node.attributes.id.."_scrollbar",
                        class = "bsv_scrollbar"
                      },
                      children = {
                        {
                          tag = "Button",
                          attributes = {
                            id = node.attributes.id.."_scrollbarHandle",
                            class = "bsv_scrollbarHandle"
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
      },
    },
    {
      tag = "Panel",
      attributes = {
        id = node.attributes.id.."_boundsSizeMarker",
        ignoreLayout = true,
        anchorMin = "1 1",
        anchorMax = "1 1"
      }
    }
  }

  return content
end

function betterScrollView.updateObjectMaps()
  local nodes = self.UI.getXmlTable()
  local gameObjects = self.getChild("XmlUIWorldCanvas(Clone)").getChild("XmlLayout").getChildren()
  xml.traverseWithGameObjects(nodes, gameObjects, function(node, obj, returnFlags)
    if node.tag == "Defaults" then
      returnFlags.traverseChildren = false
      return
    end

    if node.attributes.isBetterScrollView == "true" then
      local scrollView = obj.getChild("VerticalScrollView")
      local scrollViewInner = scrollView.getChild("Viewport").getChild("Content")
      local contentAndScrollbar = scrollViewInner.getChild("Panel").getChild("Panel").getChild("HorizontalLayout")
      local viewport = contentAndScrollbar.getChild("VerticalLayout").getChild("Panel")
      local content = viewport.getChild("Mask").getChild("VerticalLayout").getChild("VerticalLayout")
      local contentChildren = content.getChildren()

      local bsv = betterScrollView.scrollViews[node.attributes.id]

      bsv.parent = obj
      bsv.scrollView = scrollView
      bsv.scrollViewInnerRect = scrollViewInner.getComponent("RectTransform")
      bsv.boundsSizeMarkerRect = obj.getChild("Panel").getComponent("RectTransform")
      bsv.viewportSizeMarkerRect = viewport.getChild("Panel").getComponent("RectTransform")
      bsv.contentSizeMarkerRect = contentChildren[#contentChildren].getComponent("RectTransform")
      bsv.scrollbarHandleRect = contentAndScrollbar.getChildren()[2].getChild("Button").getComponent("RectTransform")
    end
  end)
end

function betterScrollView.clampScroll(bsv)
  if betterScrollView.building then return end

  local viewportHeight = bsv.viewportSizeMarkerRect.get("localPosition").y * 2
  local contentHeight = bsv.contentSizeMarkerRect.get("localPosition").y * 2

  if contentHeight > viewportHeight then
    local maxScroll = contentHeight - viewportHeight
    if bsv.scroll < 0 then bsv.scroll = 0
    elseif bsv.scroll > maxScroll then bsv.scroll = maxScroll
    end
  else
    bsv.scroll = 0
  end
end

function betterScrollView.updateScroll(bsv)
  betterScrollView.updateContentScroll(bsv)
  betterScrollView.updateScrollbarScroll(bsv)
end

function betterScrollView.updateContentScroll(bsv)
  if betterScrollView.building then return end

  local viewportHeight = bsv.viewportSizeMarkerRect.get("localPosition").y * 2
  local contentHeight = bsv.contentSizeMarkerRect.get("localPosition").y * 2

  if contentHeight > viewportHeight then
    self.UI.setAttributes(bsv.id.."_maxContent", {
      position = "0 "..(bsv.scroll + viewportHeight / 2 - 10000 / 2).." 0"
    })
  else
    self.UI.setAttributes(bsv.id.."_maxContent", {
      position = "0 "..(viewportHeight / 2 - 10000 / 2).." 0"
    })
  end
end

function betterScrollView.updateScrollbarScroll(bsv)
  if betterScrollView.building then return end

  local viewportHeight = bsv.viewportSizeMarkerRect.get("localPosition").y * 2
  local contentHeight = bsv.contentSizeMarkerRect.get("localPosition").y * 2

  if contentHeight > viewportHeight then
    local size = viewportHeight / contentHeight
    local offset = bsv.scroll / contentHeight

    self.UI.setAttributes(bsv.id.."_scrollbarHandle", {
      anchorMin = "0 "..(1 - (size + offset)),
      anchorMax = "1 "..(1 - offset)
    })
  else
    self.UI.setAttributes(bsv.id.."_scrollbarHandle", {
      anchorMin = "0 0",
      anchorMax = "1 1"
    })
  end
end

function betterScrollView.updateBoundsSize(bsv)
  local boundsWidth = bsv.boundsSizeMarkerRect.get("localPosition").x * 2
  local boundsHeight = bsv.boundsSizeMarkerRect.get("localPosition").y * 2

  self.UI.setAttributes(bsv.id.."_bounds", {
    offsetMin = "0 "..-boundsHeight,
    offsetMax = boundsWidth.." 0"
  })
end

function betterScrollView.updateContentSize(bsv)
  local viewportWidth = bsv.viewportSizeMarkerRect.get("localPosition").x * 2
  local viewportHeight = bsv.viewportSizeMarkerRect.get("localPosition").y * 2

  self.UI.setAttributes(bsv.id.."_maxContent", {
    width = viewportWidth,
  })

  if bsv.doMinContentHeight then
    self.UI.setAttributes(bsv.id.."_content", {
      minHeight = viewportHeight
    })
  end
end

local oldTriggerLayout = xml.triggerLayout
function xml.triggerLayout()
  oldTriggerLayout()

  Wait.frames(function()
    for _, bsv in pairs(betterScrollView.scrollViews) do
      betterScrollView.updateBoundsSize(bsv)
    end
    Wait.frames(function()
      for _, bsv in pairs(betterScrollView.scrollViews) do
        betterScrollView.updateContentSize(bsv)
        betterScrollView.clampScroll(bsv)
        betterScrollView.updateScroll(bsv)
      end
    end, 1)
  end, 1)
end

local oldBeforeRebuild = xml.beforeRebuild
function xml.beforeRebuild()
  betterScrollView.building = true
  oldBeforeRebuild()
end

local oldOnRebuild = xml.onRebuild
function xml.onRebuild()
  betterScrollView.updateObjectMaps()
  betterScrollView.building = false
  oldOnRebuild()
end

end
----#include <!/better-scroll-view-3>

function logAll(a, b, c)
  log(a)
  log(b)
  log(c)
end

-------------
--Constants--
-------------

JsonVersion = 3

ProficiencyIcons = {
  [0] = "",
  [0.5] = string.char(189), --one-half sign
  [1] = string.char(10003), --checkmark
  [2] = "2"
}

Levels = {
  300,
  900,
  2700,
  6500,
  14000,
  23000,
  34000,
  48000,
  64000,
  85000,
  100000,
  120000,
  140000,
  165000,
  195000,
  225000,
  265000,
  305000,
  355000
}

Abilities = {
  { id = "str", name = Loc.abilities.strength,     shortName = Loc.abilitiesShort.str },
  { id = "dex", name = Loc.abilities.dexterity,    shortName = Loc.abilitiesShort.dex },
  { id = "con", name = Loc.abilities.constitution, shortName = Loc.abilitiesShort.con },
  { id = "int", name = Loc.abilities.intelligence, shortName = Loc.abilitiesShort.int },
  { id = "wis", name = Loc.abilities.wisdom,       shortName = Loc.abilitiesShort.wis },
  { id = "cha", name = Loc.abilities.charisma,     shortName = Loc.abilitiesShort.cha }
}
for _, ability in ipairs(Abilities) do Abilities[ability.id] = ability end

Skills = {
  { id = "acrobatics",     name = Loc.skills.acrobatics,     ability = "dex" },
  { id = "animalHandling", name = Loc.skills.animalHandling, ability = "wis" },
  { id = "arcana",         name = Loc.skills.arcana,         ability = "int" },
  { id = "athletics",      name = Loc.skills.athletics,      ability = "str" },
  { id = "deception",      name = Loc.skills.deception,      ability = "cha" },
  { id = "history",        name = Loc.skills.history,        ability = "int" },
  { id = "insight",        name = Loc.skills.insight,        ability = "wis" },
  { id = "intimidation",   name = Loc.skills.intimidation,   ability = "cha" },
  { id = "investigation",  name = Loc.skills.investigation,  ability = "int" },
  { id = "medicine",       name = Loc.skills.medicine,       ability = "wis" },
  { id = "nature",         name = Loc.skills.nature,         ability = "int" },
  { id = "perception",     name = Loc.skills.perception,     ability = "wis" },
  { id = "performance",    name = Loc.skills.performance,    ability = "cha" },
  { id = "persuasion",     name = Loc.skills.persuasion,     ability = "cha" },
  { id = "religion",       name = Loc.skills.religion,       ability = "int" },
  { id = "sleightOfHand",  name = Loc.skills.sleightOfHand,  ability = "dex" },
  { id = "stealth",        name = Loc.skills.stealth,        ability = "dex" },
  { id = "survival",       name = Loc.skills.survival,       ability = "wis" }
}
for _, skill in ipairs(Skills) do Skills[skill.id] = skill end

Bounds = {
  exp = {0, 355000},
  abilities = {
    str = {0, 99},
    dex = {0, 99},
    con = {0, 99},
    int = {0, 99},
    wis = {0, 99},
    cha = {0, 99}
  },
  proficiencyBonus = {0, 9},
  throws = {
    str = { mod = {-99, 99} },
    dex = { mod = {-99, 99} },
    con = { mod = {-99, 99} },
    int = { mod = {-99, 99} },
    wis = { mod = {-99, 99} },
    cha = { mod = {-99, 99} }
  },
  skills = {
    acrobatics     = { mod = {-99, 99} },
    animalHandling = { mod = {-99, 99} },
    arcana         = { mod = {-99, 99} },
    athletics      = { mod = {-99, 99} },
    deception      = { mod = {-99, 99} },
    history        = { mod = {-99, 99} },
    insight        = { mod = {-99, 99} },
    intimidation   = { mod = {-99, 99} },
    investigation  = { mod = {-99, 99} },
    medicine       = { mod = {-99, 99} },
    nature         = { mod = {-99, 99} },
    perception     = { mod = {-99, 99} },
    performance    = { mod = {-99, 99} },
    persuasion     = { mod = {-99, 99} },
    religion       = { mod = {-99, 99} },
    sleightOfHand  = { mod = {-99, 99} },
    stealth        = { mod = {-99, 99} },
    survival       = { mod = {-99, 99} }
  },
  armorClass = {-99, 99},
  initiative = {-99, 99},
  speed = {0, 999},
  exhaustion = {0, 6},
  spellcasting = {
    attackBonusMod = {-99, 99},
    saveDcMod = {-99, 99}
  },
  hp = {
    temp = {0, 999},
    current = {0, 999},
    max = {0, 999}
  },
  attacks = { bonus = {-9, 9} }
}

-----------
--Globals--
-----------

character = nil

manualSkills = false
manualThrows = false
manualSpellcasting = false
showDeathSaves = false
selectedTrait = 0

importedJson = nil

disableSaving = false

-------------------
--Built-in Events--
-------------------

function onLoad(savedData)
  if savedData and savedData ~= "" then
    character = JSON.decode(savedData)
  else
    broadcastToAll(
      Loc.loadingDefault,
      {1, 0, 0}
    )
    character = JSON.decode(DefaultCharacter)
  end

  xmlBind.initialize()
  betterScrollView.initialize()
  xml.layoutHacks[#xml.layoutHacks + 1] = "frontLayoutHack"

  --wait until XML is loaded, which can be after onLoad() if copying or pulling
  --from a bag
  Wait.condition(
    function()
      xml.edit(function(nodes)
        xmlSnippet.registerSnippets(nodes)
        hydrate(nodes)
        xmlBind.registerBindings(nodes)
        betterScrollView.register(nodes)
        xmlBind.wrapInputFields(nodes)
        nodes[#nodes + 1] = { attributes = { class = "main front", color = "red" } }
      end)
    end,
    function() return self.UI.getXmlTable()[1] ~= nil end
  )

end

function onSave()
  if disableSaving then return "" end
  return JSON.encode(character)
end

--------------
--XML Events--
--------------

--Attacks--

function onAttackAddClick(_, button, id)
  if button ~= "-1" then return end

  character.attacks[#character.attacks + 1] = {
    name = "",
    bonus = 0,
    damage = "",
    notes = ""
  }
  xml.edit(function(nodes)
    xml.traverse(nodes, function(node, returnFlags)
      if node.attributes.id == "attacksContainer" then
        local i = #node.children + 1
        local instance = xmlSnippet.createSnippet(xmlSnippet.snippets.attack, {
          i = i,
          swapActive = i > 1
        })
        xmlBind.registerBindings(instance)
        for _, piece in ipairs(instance) do
          node.children[#node.children + 1] = piece
        end
        returnFlags.done = true
      end
    end)
  end)
end

function onAttackSwapClick(_, button, id)
  if button ~= "-1" then return end

  local i = tonumber(id:match("attack(%d+)Swap"))
  local j = i - 1
  if j < 1 or j > #character.attacks then return end

  local temp = character.attacks[i]
  character.attacks[i] = character.attacks[j]
  character.attacks[j] = temp

  xml.updateAll()
end

function onAttackDeleteClick(_, button, id)
  if button ~= "-1" then return end

  local i = tonumber(id:match("attack(%d+)Delete"))
  table.remove(character.attacks, i)

  xml.edit(function(nodes)
    xml.traverse(nodes, function(node, returnFlags)
      if node.attributes.id == "attacksContainer" then
        xmlBind.unregisterBindings({node.children[#node.children]})
        node.children[#node.children] = nil
        returnFlags.done = true
      end
    end)
  end)
end

--Traits--

function onTraitAddClick(_, button, id)
  if button ~= "-1" then return end

  character.traits[#character.traits + 1] = {
    name = "New Trait",
    desc = ""
  }
  selectedTrait = #character.traits

  xml.edit(function(nodes)
    xml.traverse(nodes, function(node, returnFlags)
      if node.attributes.id == "traitsContainer" then
        local instance = xmlSnippet.createSnippet(xmlSnippet.snippets.trait, {
          i = #node.children + 1
        })
        for _, piece in ipairs(instance) do
          node.children[#node.children + 1] = piece
        end
        returnFlags.done = true
      end
    end)
  end)
end

function onTraitClick(_, button, id)
  if button ~= "-1" then return end

  selectedTrait = tonumber(id:match("trait(%d+)"))
  xml.updateAll()
end

function onTraitEdit(_, value, id)
  local prop = ({ traitName = "name", traitDesc = "desc" })[id]
  character.traits[selectedTrait][prop] = value

  xml.updateAll({ [id] = true })
end

function onTraitMoveClick(_, button, id)
  if button ~= "-1" then return end
  if selectedTrait == 0 then return end

  local delta = ({ Up = -1, Down = 1 })[id:match("traitMove(.*)")]

  local j = selectedTrait + delta
  if j < 1 or j > #character.traits then return end

  local temp = character.traits[selectedTrait]
  character.traits[selectedTrait] = character.traits[j]
  character.traits[j] = temp

  selectedTrait = j

  xml.updateAll()
end

function onTraitDeleteClick(_, button, id)
  if button ~= "-1" then return end
  if selectedTrait == 0 then return end

  table.remove(character.traits, selectedTrait)
  selectedTrait = 0

  xml.edit(function(nodes)
    xml.traverse(nodes, function(node, returnFlags)
      if node.attributes.id == "traitsContainer" then
        xmlBind.unregisterBindings({node.children[#node.children]})
        node.children[#node.children] = nil
        returnFlags.done = true
      end
    end)
  end)
end

--Options--

function onJsonInputEdit(_, value)
  importedJson = value
end

function onCopyJsonDoneClick(_, button)
  if button ~= "-1" then return end
  closeJsonWindow()
end

function onPasteJsonDoneClick(player, button)
  if button ~= "-1" then return end

  if importedJson == "" then
    closeJsonWindow()
    return
  end

  if importedJson == "resetData" then
    disableSaving = true
    broadcastToColor(
      Loc.dataWillReset,
      player.color,
      {0, 1, 0}
    )
    closeJsonWindow()
    return
  end

  local status, char = pcall(function() return JSON.decode(importedJson) end)
  if status and type(char) == "table" and char.jsonVersion then
    if char.jsonVersion > JsonVersion then
      broadcastToColor(
        Loc.dataFromNewerVersion,
        player.color,
        {0, 1, 0}
      )
      closeJsonWindow()
      return
    end

    character = updateCharacterJson(char)
    selectedTrait = 0
    manualThrows = false
    manualSkills = false
    xmlBind.resetBindings()

    xml.edit(
      function(nodes)
        hydrate(nodes)
        xmlBind.registerBindings(nodes)
      end,
      function()
        broadcastToColor(
          Loc.dataImported:format(character.name),
          player.color,
          {0, 1, 0}
        )
        closeJsonWindow()
      end
    )

  else
    broadcastToColor(
      Loc.dataNotRecognised,
      player.color,
      {1, 0, 0}
    )
    closeJsonWindow()
  end
end

--Other--

function onAlignmentClick(_, button, id)
  local delta
  if button == "-1" then
    delta = 1
  elseif button == "-2" then
    delta = -1
  else return end

  local i = 1
  if id == "alignmentGood" then i = 2 end

  character.alignment[i] = (character.alignment[i] + delta) % 3

  updateAlignment()
end

function onInspirationClick(_, button)
  if button ~= "-1" then return end

  character.inspiration = not character.inspiration
  xml.updateAll()
end

function onSpellcastingAbilityClick(_, button, id)
  local delta
  if button == "-1" then
    delta = 1
  elseif button == "-2" then
    delta = -1
  else return end

  local index
  for i, ability in ipairs(Abilities) do
    if ability.id == character.spellcasting.ability then
      index = i
      break
    end
  end

  character.spellcasting.ability = Abilities[(index - 1 + delta) % 6 + 1].id

  updateSpellcasting()
end

function onSpellcastingManualClick(_, button)
  if button ~= "-1" then return end

  manualSpellcasting = not manualSpellcasting
  xml.updateAll()
end

function onCurrentHpUnfocus(player, value, id)
  xmlBind.defaultOnFieldUnfocus(player, value, id)
  if character.hp.current == 0 then
    showDeathSaves = true
    updateDeathSaves()
  end
end

function onCurrentHpNudgeClick(player, button, id)
  xmlBind.defaultOnNudgeClick(player, button, id)
  if character.hp.current == 0 then
    showDeathSaves = true
    updateDeathSaves()
  end
end

function onToggleDeathSavesClick(_, button, id)
  if button ~= "-1" then return end

  showDeathSaves = not showDeathSaves
  updateDeathSaves()
end

function onDeathSaveClick(_, button, id)
  local delta
  if button == "-1" then
    delta = 1
  elseif button == "-2" then
    delta = -1
  else return end

  local key = "successes"
  if id == "deathFailures" then key = "failures" end

  character.deathSaves[key] = (character.deathSaves[key] + delta) % 4

  updateDeathSaves()
end

function onThrowsManualButtonClick(_, button)
  if button ~= "-1" then return end

  manualThrows = not manualThrows
  xml.updateAll()
end

function onSkillsManualButtonClick(_, button)
  if button ~= "-1" then return end

  manualSkills = not manualSkills
  xml.updateAll()
end

function onThrowProficiencyClick(_, button, id)
  local ability = id:match("(.+)ThrowProficiency")
  if button == "-1" then
    character.throws[ability].proficiency = iif(
      character.throws[ability].proficiency == 0,
      1,
      0
    )
  elseif button == "-2" then
    character.throws[ability].proficiency = ({
      [0] = 0.5,
      [0.5] = 1,
      [1] = 2,
      [2] = 0
    })[character.throws[ability].proficiency]
  else return end

  xml.updateAll()
end

function onSkillProficiencyClick(_, button, id)
  local skill = id:match("(.+)Proficiency")
  if button == "-1" then
    character.skills[skill].proficiency = iif(
      character.skills[skill].proficiency == 0,
      1,
      0
    )
  elseif button == "-2" then
    character.skills[skill].proficiency = ({
      [0] = 0.5,
      [0.5] = 1,
      [1] = 2,
      [2] = 0
    })[character.skills[skill].proficiency]
  else return end

  xml.updateAll()
end

function onLevelNudgeClick(_, button, id)
  local delta
  if button == "-1" then
    delta = 1
  elseif button == "-2" then
    delta = 5
  else return end

  if id == "levelMinus" then delta = delta * -1 end

  local level = levelFromExperience(character.exp)
  if character.exp ~= (Levels[level - 1] or 0) and delta < 0 then delta = 0 end
  local newLevel = level - 1 + delta
  if newLevel < 0 then newLevel = 0 end
  if newLevel > 19 then newLevel = 19 end
  character.exp = Levels[newLevel] or 0
  xml.updateAll()
end

-----------------------
--UI Update Functions--
-----------------------

local oldUpdateAll = xml.updateAll
function xml.updateAll(exclude)
  updateAlignment(exclude)
  updateExperience(exclude)

  updateAbilityMods(exclude)

  updateInspiration(exclude)
  updateThrows(exclude)
  updateSkills(exclude)
  updatePassivePerception(exclude)

  updateExhaustion(exclude)
  updateSpellcasting(exclude)
  updateDeathSaves(exclude)

  updateTraits(exclude)

  betterScrollView.updateObjectMaps(exclude)

  oldUpdateAll(exclude)
end

function updateAlignment(exclude)
  local lawful = Loc.lawfulAlignments[character.alignment[1] + 1]
  local good   = Loc.goodAlignments[character.alignment[2] + 1]
  if character.alignment[1] == 1 and character.alignment[2] == 1 then
    lawful = Loc.trueNeutral[1]
    good = Loc.trueNeutral[2]
  end
  xml.set("alignmentLawfulText", { text = lawful }, exclude)
  xml.set("alignmentGoodText", { text = good }, exclude)
end

function updateExperience(exclude)
  local level = levelFromExperience(character.exp)
  local currentLevelExp = Levels[level - 1] or 0
  local nextLevelExp = Levels[level] or 1

  xml.set("expToNextLevel", { text = iif(level == 20, Loc.maxExperience, nextLevelExp) }, exclude)
  xml.set("currentLevel", { text = level }, exclude)
  xml.set("nextLevel", { text = iif(level == 20, Loc.maxExperience, level + 1) }, exclude)
  xml.set("expBar", { anchorMax = iif(
    level == 20,
    "1 1",
    ((character.exp - currentLevelExp) / (nextLevelExp - currentLevelExp)).." 1"
  ) }, exclude)
end


function updateAbilityMods(exclude)
  for _, ability in ipairs(Abilities) do
    xml.set(ability.id.."Mod", {
      text = xmlBind.prependPlus(abilityModFromScore(character.abilities[ability.id]))
    }, exclude)
  end
end

function updateInspiration(exclude)
  xml.set("inspirationText", { text = iif(character.inspiration, string.char(10003), "") }, exclude)
end

function updateThrows(exclude)
  xml.set("throwsManualButtonText", { text = iif(
    manualThrows,
    string.char(10003), --check mark
    string.char(177) --plus/minus sign
  ) }, exclude)

  for _, ability in ipairs(Abilities) do
    xml.set(ability.id.."ThrowAuto", { active = not manualThrows }, exclude)
    xml.set(ability.id.."ThrowManual", { active = manualThrows }, exclude)

    xml.set(ability.id.."ThrowProficiencyText", {
      text = ProficiencyIcons[character.throws[ability.id].proficiency]
    }, exclude)
    xml.set(ability.id.."ThrowTotal", {
      text = xmlBind.prependPlus(getThrowTotal(ability))
    }, exclude)
  end
end

function updateSkills(exclude)
  xml.set("skillsManualButtonText", { text = iif(
    manualSkills,
    string.char(10003), --check mark
    string.char(177) --plus/minus sign
  ) }, exclude)

  for _, skill in ipairs(Skills) do
    xml.set(skill.id.."Auto", { active = not manualSkills }, exclude)
    xml.set(skill.id.."Manual", { active = manualSkills }, exclude)

    xml.set(skill.id.."ProficiencyText", {
      text = ProficiencyIcons[character.skills[skill.id].proficiency]
    }, exclude)
    xml.set(skill.id.."Total", {
      text = xmlBind.prependPlus(getSkillTotal(skill))
    }, exclude)
  end
end

function updatePassivePerception(exclude)
  xml.set("passivePerception", { text = 10 + getSkillTotal(Skills.perception) }, exclude)
end

function updateExhaustion(exclude)
  xml.set("exhaustionDesc", { text = Loc.exhaustion[character.exhaustion + 1] }, exclude)
end

function updateSpellcasting(exclude)
  xml.set("spellAttackBonus", { active = not manualSpellcasting }, exclude)
  xml.set("spellAttackBonusManual", { active = manualSpellcasting }, exclude)

  xml.set("spellSaveDc", { active = not manualSpellcasting }, exclude)
  xml.set("spellSaveDcManual", { active = manualSpellcasting }, exclude)

  xml.set("spellcastingManualButtonText", { text = iif(
    manualSpellcasting,
    string.char(10003), --check mark
    string.char(177) --plus/minus sign
  ) }, exclude)

  xml.set("spellcastingAbilityText", { text = Abilities[character.spellcasting.ability].name }, exclude)
  xml.set("spellAttackBonus", { text = xmlBind.prependPlus(
    abilityModFromScore(character.abilities[character.spellcasting.ability]) +
    character.proficiencyBonus +
    character.spellcasting.attackBonusMod
  ) }, exclude)
  xml.set("spellSaveDc", { text = (
    abilityModFromScore(character.abilities[character.spellcasting.ability]) +
    character.proficiencyBonus +
    character.spellcasting.saveDcMod +
    8
  ) }, exclude)
end

function updateDeathSaves(exclude)
  xml.set("deathSavesContainer", { active = showDeathSaves }, exclude)
  xml.set("currentHpContainer", { active = not showDeathSaves }, exclude)
  xml.set("toggleDeathSavesText", { text = iif(
    showDeathSaves,
    Loc.hitPointsInitials,
    Loc.deathSavesInitials
  ) }, exclude)

  xml.set("deathSuccess1", { text = iif(character.deathSaves.successes >= 1, string.char(10003), "") }, exclude)
  xml.set("deathSuccess2", { text = iif(character.deathSaves.successes >= 2, string.char(10003), "") }, exclude)
  xml.set("deathSuccess3", { text = iif(character.deathSaves.successes >= 3, string.char(10003), "") }, exclude)

  xml.set("deathFailure1", { text = iif(character.deathSaves.failures >= 1, string.char(10003), "") }, exclude)
  xml.set("deathFailure2", { text = iif(character.deathSaves.failures >= 2, string.char(10003), "") }, exclude)
  xml.set("deathFailure3", { text = iif(character.deathSaves.failures >= 3, string.char(10003), "") }, exclude)
end

function updateTraits(exclude)
  for i, trait in ipairs(character.traits) do
      xml.set("trait"..i.."Text", {
        color = iif(i == selectedTrait, "black", "white"),
        text = escapeRichText(trait.name)
      }, exclude)
      xml.set("trait"..i, { color = iif(i == selectedTrait, "white", "shadedClear") }, exclude)
  end

  if selectedTrait == 0 then
    xml.set("traitNameContainer", { active = false },                                       exclude)
    xml.set("noTraitSelected",    { active = true, text = Loc.noTraitSelected },            exclude)
    xml.set("traitDesc",          { interactable = false, text = Loc.noTraitSelectedDesc }, exclude)
    xml.set("traitDesc_sizer",    { text = Loc.noTraitSelectedDesc },                       exclude)
  else
    xml.set("traitNameContainer", { active = true },                                                    exclude)
    xml.set("noTraitSelected",    { active = false },                                                   exclude)
    xml.set("traitName",          { text = character.traits[selectedTrait].name },                      exclude)
    xml.set("traitName_sizer",    { text = character.traits[selectedTrait].name },                      exclude)
    xml.set("traitDesc",          { interactable = true, text = character.traits[selectedTrait].desc }, exclude)
    xml.set("traitDesc_sizer",    { text = character.traits[selectedTrait].desc },                      exclude)
  end
end

function showCopyWindow()
  xml.set("jsonInput", {
    text = JSON.encode(character).."\n",
    placeholder = " ",
    readOnly = true,
    onValueChanged = ""
  })
  xml.set("jsonDoneButton", { onClick = "onCopyJsonDoneClick" })
  self.UI.show("jsonWindow")
end

function showPasteWindow()
  importedJson = ""
  xml.set("jsonInput", {
    text = "",
    placeholder = Loc.pasteJson,
    readOnly = false,
    onValueChanged = "onJsonInputEdit"
  })
  xml.set("jsonDoneButton", { onClick = "onPasteJsonDoneClick" })
  self.UI.show("jsonWindow")
end

function closeJsonWindow()
  self.UI.hide("jsonWindow")
end

-------------------
--Logic Functions--
-------------------

function updateCharacterJson(char)
  if char.jsonVersion < 2 then
    for _, throw in pairs(char.throws) do
      throw.proficiency = iif(throw.proficiency, 1, 0)
    end
    for _, skill in pairs(char.skills) do
      skill.proficiency = iif(skill.proficiency, 1, 0)
    end
    char.jsonVersion = 2
  end

  if char.jsonVersion < 3 then
    char.background = ""
    char.exhaustion = 0
    char.spellcasting = {
      active = true,
      ability = "cha",
      attackBonusMod = 0,
      saveDcMod = 0
    }
    char.hitDice = {
      total = char.hitDice.max,
      remaining = char.hitDice.current
    }

    char.jsonVersion = 3
  end

  return char
end

---------------------
--Utility Functions--
---------------------

--calculate an ability mod from its respective score
function abilityModFromScore(score)
  return math.floor((score - 10) / 2)
end

function levelFromExperience(exp)
  for i, v in ipairs(Levels) do
    if exp < v then return i end
  end
  return 20
end

function getSkillTotal(skill)
  return abilityModFromScore(character.abilities[skill.ability]) +
    math.floor(character.skills[skill.id].proficiency * character.proficiencyBonus) +
    character.skills[skill.id].mod
end

function getThrowTotal(ability)
  return abilityModFromScore(character.abilities[ability.id]) +
    math.floor(character.throws[ability.id].proficiency * character.proficiencyBonus) +
    character.throws[ability.id].mod
end

---------------------
--Startup Functions--
---------------------

--Populate all abilities, saving throws, and skills with the appropriate
--snippets
function hydrate(nodes)
  xml.traverse(nodes, function(node, returnFlags)
    if node.attributes.id == "abilitiesContainer" then
      node.children = xmlSnippet.snippetsForEach(
        Abilities,
        xmlSnippet.snippets.ability,
        function(ability) return {
          id = ability.id,
          label = ability.name:upper()
        } end
      )
      returnFlags.traverseChildren = false
    elseif node.attributes.id == "throwsContainer" then
      node.children = xmlSnippet.snippetsForEach(
        Abilities,
        xmlSnippet.snippets.throw,
        function(ability) return {
          id = ability.id,
          label = ability.name
        } end
      )
      returnFlags.traverseChildren = false
    elseif node.attributes.id == "skillsContainer" then
      node.children = xmlSnippet.snippetsForEach(
        Skills,
        xmlSnippet.snippets.skill,
        function(skill) return {
          id = skill.id,
          label = skill.name,
          ability = Abilities[skill.ability].shortName:upper()
        } end
      )
      returnFlags.traverseChildren = false
    elseif node.attributes.id == "attacksContainer" then
      node.children = xmlSnippet.snippetsForEach(
        character.attacks,
        xmlSnippet.snippets.attack,
        function(_, i) return {
          i = i,
          swapActive = i > 1
        } end
      )
      returnFlags.traverseChildren = false
    elseif node.attributes.id == "traitsContainer" then
      node.children = xmlSnippet.snippetsForEach(
        character.traits,
        xmlSnippet.snippets.trait,
        function(_, i) return {
          i = i
        } end
      )
      returnFlags.traverseChildren = false
    end
  end)
end

end
----#include <!/smart-character-sheet/main>