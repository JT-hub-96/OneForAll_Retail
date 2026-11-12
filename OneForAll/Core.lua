local ADDON, FLT = ...
local L = FLT.L or setmetatable({}, { __index = function(_, k) return k end }) -- (tests without Locales)

local function msg(text)
  DEFAULT_CHAT_FRAME:AddMessage("|cff66ccff" .. tostring(FLT.DISPLAY_NAME or "OneForAll") .. ":|r " .. tostring(text))
end
FLT.Msg = msg

-- The English profession key (our data and saved data use it) for a profession name in the client's language (6.2.0:
-- "Schneiderei" -> "Tailoring"; the trainer and the old skill list give the name only). From the profession spells,
-- whose names the client knows in its language.
local PROF_SPELLS = { Alchemy = 2259, Blacksmithing = 2018, Enchanting = 7411, Engineering = 4036, Leatherworking = 2108,
  Tailoring = 3908, Cooking = 2550, ["First Aid"] = 3273, Mining = 2575, Herbalism = 2366, Skinning = 8613, Fishing = 7620 }
FLT.PROF_SPELLS = PROF_SPELLS
local profByName
function FLT.ProfKey(name)
  if type(name) ~= "string" then return nil end
  if PROF_SPELLS[name] then return name end
  if not profByName then
    local t, all = {}, true
    for key, id in pairs(PROF_SPELLS) do
      local n
      pcall(function() n = (C_Spell and C_Spell.GetSpellName and C_Spell.GetSpellName(id)) or (GetSpellInfo and GetSpellInfo(id)) end)
      if type(n) == "string" then t[n] = key else all = false end
    end
    if not all then return t[name] end -- spell data not ready yet: try again next time
    profByName = t
  end
  return profByName[name]
end

-- Safe calls for event handlers: an error is caught instead of popping up again and
-- again (e.g. in combat, when the Forever client hands out "secret" values). The
-- last errors are kept in OneForAllRetailDB.errors; /ofa errors prints them so
-- players can copy them into a bug report.
local errorSaid = false
local function logError(tag, err)
  local db = type(OneForAllRetailDB) == "table" and OneForAllRetailDB
  if db then
    db.errors = db.errors or {}
    local ver = (C_AddOns and C_AddOns.GetAddOnMetadata and C_AddOns.GetAddOnMetadata(ADDON, "Version")) or (GetAddOnMetadata and GetAddOnMetadata(ADDON, "Version")) or "?"
    local line = string.format("%s | %s | %s | %s | %s", date and date("%Y-%m-%d %H:%M") or "", tostring(ver), GetLocale and GetLocale() or "?", tostring(tag), tostring(err))
    if db.errors[1] ~= line then table.insert(db.errors, 1, line) end
    while #db.errors > 20 do table.remove(db.errors) end
  end
  if not errorSaid then
    errorSaid = true
    msg(L["An error was caught and the feature skipped. Type /ofa errors to see it (for a bug report)."])
  end
end
function FLT.SafeCall(tag, fn, ...)
  local ok, err = pcall(fn, ...)
  if not ok then logError(tag, err) end
  return ok
end
-- true when any of the values is a "secret" (newer clients hide some values in combat)
function FLT.IsSecret(...)
  if not issecretvalue then return false end
  for i = 1, select("#", ...) do if issecretvalue((select(i, ...))) then return true end end
  return false
end

-- [charkey] (tools/tests/charkey.lua loads this block)
-- Account-wide data per character (gold of the info bar, recipes and stock of the alts). 6.2.5 (user 11.11.2026): on WoW
-- Forever characters share a first name (surnames: "Smörgi Rogue", "Smörgi Hunt"; UnitName gives "Smörgi" only), so the
-- old key "Name-Realm" made all of them one character -> the key is the GUID, name / realm / class are stored in the
-- entry. Old entries ("Name-Realm", info bar "Realm|Name") are still read; a character drops its old one when it saves.
local function oldKey()
  local n = UnitName and UnitName("player")
  return n and (n .. "-" .. (GetRealmName and GetRealmName() or "")) or nil
end
function FLT.CharKey() return (UnitGUID and UnitGUID("player")) or oldKey() end
function FLT.IsMyChar(key) return key == FLT.CharKey() or key == oldKey() end
-- name, realm, class token of an entry
function FLT.CharOf(key, d)
  local t = type(d) == "table"
  if t and d.name then return d.name, d.realm, d.class or d[2] end
  local r, n = tostring(key):match("^(.-)|(.*)$")
  if not r then n, r = tostring(key):match("^(.-)%-(.*)$") end
  return n or key, r, t and (d.class or d[2]) or nil
end
-- save this character's entry d in tbl (stamps name, realm, class; removes its old key)
function FLT.CharSave(tbl, d, legacy)
  local key = FLT.CharKey(); if not key then return end
  local _, cls = UnitClass("player")
  d.name, d.realm, d.class = UnitName("player"), GetRealmName and GetRealmName() or "", cls
  tbl[key] = d
  local old = legacy or oldKey()
  if old and old ~= key then tbl[old] = nil end
end
-- the name to show; with the class when another of my characters (or this one) has the same name
function FLT.CharLabel(tbl, key, d)
  local name, _, cls = FLT.CharOf(key, d)
  local dup = name == (UnitName and UnitName("player"))
  if not dup then
    for k, o in pairs(tbl) do if k ~= key and FLT.CharOf(k, o) == name then dup = true; break end end
  end
  local cn = dup and cls and LOCALIZED_CLASS_NAMES_MALE and LOCALIZED_CLASS_NAMES_MALE[cls]
  return cn and (name .. " (" .. cn .. ")") or name
end
-- [/charkey]

-- Retail fork: features whose data or modules are WoW Forever only. Their files are not in the .toc; the switches
-- here say which parts come back once they are rebuilt for Retail (phases 2-7). Code that uses one of these modules
-- checks for the module itself (FLT.X and FLT.X.Fn) as well, so a missing module never errors.
FLT.Features = {
  dungeons = false, armory = false, talents = false, professions = false,
  gear = false, pets = false, quests = false, books = false, map = false,
}
function FLT.HasFeature(key) return FLT.Features[key] == true end

function FLT:Refresh()
  if self.UIRefresh then self:UIRefresh() end
end

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:RegisterEvent("PLAYER_LOGIN")
f:RegisterEvent("BAG_UPDATE_DELAYED")
f:SetScript("OnEvent", function(_, event, arg1)
  if event == "ADDON_LOADED" and arg1 == ADDON then
    -- Retail fork: own SavedVariables (OneForAllRetailDB / OneForAllRetailCharDB), nothing is taken over from Forever
    OneForAllRetailDB = OneForAllRetailDB or {}
    OneForAllRetailCharDB = OneForAllRetailCharDB or {}
    -- 6.0.1: the character's profile (UI/Profiles.lua) into the live settings, before the first-start defaults
    if FLT.Profiles then FLT.Profiles.Load() end
    -- first start (no Quality of Life settings yet): these options start switched on
    if OneForAllRetailDB.qol == nil then
      OneForAllRetailDB.qol = {
        quickLoot = true, bagsFull = true,
        lootFeed = true, lootFeedMoney = true, lootFeedQuality = 0,
        questSparkles = true, unitTarget = true,
        classColors = true, thanksBuff = true,
        bagSlots = true, questXP = true, durability = true, copyChat = true, mmCollect = true,
        cameraZoom = true, moveWindows = true,
      }
    end
  elseif event == "PLAYER_LOGIN" then
    FLT:Refresh()
    if FLT.CreateMinimapButton then FLT:CreateMinimapButton() end
  elseif event == "BAG_UPDATE_DELAYED" then
    FLT:Refresh()
  end
end)

SLASH_ONEFORALL1 = "/oneforall"
SLASH_ONEFORALL2 = "/ofa"
SlashCmdList.ONEFORALL = function(cmd)
  cmd = (cmd or ""):lower():match("^%s*(.-)%s*$")
  if cmd == "where" then
    -- Prints the current map and coordinates, to correct map pins in the data.
    local mapID = C_Map and C_Map.GetBestMapForUnit and C_Map.GetBestMapForUnit("player")
    local pos = mapID and C_Map.GetPlayerMapPosition and C_Map.GetPlayerMapPosition(mapID, "player")
    local info = mapID and C_Map.GetMapInfo and C_Map.GetMapInfo(mapID)
    if pos then
      local x, y = pos:GetXY()
      msg(string.format("%s (mapID %d): %.1f, %.1f", info and info.name or "?", mapID, x * 100, y * 100))
    else
      msg(L["No map position available here (e.g. inside an instance)."])
    end
  elseif cmd == "scale" or cmd:match("^scale%s") then
    local value = cmd:match("^scale%s+([%d%.]+)")
    if FLT.SetWindowScale then
      local applied = FLT:SetWindowScale(value)
      msg(string.format(L["Window size set to %d%%."], math.floor(applied * 100 + 0.5)) .. (value and "" or (" " .. L["Position reset to the screen center."])))
    end
  elseif cmd == "tabs reset" then
    if FLT.UI and FLT.UI.ResetTabs then FLT.UI.ResetTabs() end
    msg(L["Tab selection reset to the defaults for this character."])
  elseif cmd == "chathistory" then
    if FLT.QoL and FLT.QoL.ChatHistoryInfo then FLT.QoL.ChatHistoryInfo() end
  elseif cmd == "mem" then
    -- memory check: the number includes garbage that Lua has not freed yet
    local get = (C_AddOns and C_AddOns.GetAddOnMemoryUsage) or GetAddOnMemoryUsage
    if UpdateAddOnMemoryUsage then UpdateAddOnMemoryUsage() end
    local kb = get and get("OneForAll")
    if kb then msg(string.format(L["Memory: %.1f MB (includes garbage the game has not cleaned up yet)."], kb / 1024)) end
  elseif cmd == "buttons" then
    if FLT.PrintMinimapCollector then FLT.PrintMinimapCollector() end
  elseif cmd == "errors" then
    local list = type(OneForAllRetailDB) == "table" and OneForAllRetailDB.errors
    if not list or #list == 0 then msg(L["No errors caught."]) else
      msg(string.format(L["%d caught error(s), newest first (date | version | client language | where | error):"], #list))
      for i = 1, math.min(10, #list) do msg("  " .. list[i]) end
    end
  elseif cmd == "errors clear" then
    if type(OneForAllRetailDB) == "table" then OneForAllRetailDB.errors = nil end
    msg(L["Caught errors cleared."])
  elseif cmd == "bug" then
    if FLT.UI and FLT.UI.ShowBugReport then FLT.UI.ShowBugReport() end
  elseif cmd == "cheapest" then
    if FLT.QoL and FLT.QoL.PrintCheapest then FLT.QoL.PrintCheapest() end
  elseif cmd == "thanks" then
    if FLT.QoL and FLT.QoL.PrintThanksLog then FLT.QoL.PrintThanksLog() end
  elseif cmd == "news" then
    if FLT.ShowNews then FLT.ShowNews() end
  elseif cmd == "setup" then
    if FLT.ShowWelcome then FLT.ShowWelcome() end
  else
    if FLT.ToggleUI then FLT:ToggleUI() end
  end
end
