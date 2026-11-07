local _, FLT = ...

-- Quest icons on the world map (6.0.2, user 01.11.; wish from Discord, "like Questie"): a yellow "!" at quest givers
-- with a quest you can take now - only quests for your level (not grey, not too high), your side, race and class,
-- pre-quests done, not done or in the log yet - and a yellow "?" where a finished quest from your log is turned in.
-- Tooltip only (giver, quests with their level and the levels in which they can be taken and give experience), no click; a walking giver's route is drawn with it. Data: Data/QuestPins.lua (QuestieDB, GPL-3).
-- Switch qol.mapQuests (on by default, user 01.11.); hidden while Questie is loaded (it draws its own, user 01.11.).
-- qol.mapQuestsContinent (6.1.1, user 04.11.): also on the continent map, all zones at once (rect of each zone from
-- C_Map.GetMapRectOnMap), a bit smaller, without the walking routes.
-- Lean: a map's data string is read only when that map is shown (cached per map); the quest log is read once per
-- refresh; quest events are only registered while the map is open and the switch on, debounced.

local MQ = {}
FLT.MapQuests = MQ

local AVAIL_TEX, TURNIN_TEX = "Interface\\GossipFrame\\AvailableQuestIcon", "Interface\\GossipFrame\\ActiveQuestIcon"
-- the client's sharper map atlases when it has them (the 16 px gossip icons looked pixelated, user 01.11.)
local AVAIL_ATLAS, TURNIN_ATLAS = "QuestNormal", "QuestTurnin"
local function setIcon(tex, turnin)
  local atlas = turnin and TURNIN_ATLAS or AVAIL_ATLAS
  if tex.SetAtlas and C_Texture and C_Texture.GetAtlasInfo and C_Texture.GetAtlasInfo(atlas) then tex:SetAtlas(atlas); return end
  tex:SetTexture(turnin and TURNIN_TEX or AVAIL_TEX, nil, nil, "TRILINEAR")
end
local SIZE = 18

local function Q(key) return FLT.QoL and FLT.QoL.Get(key) end

local questie
local function questieLoaded()
  if questie == nil then
    local loaded = C_AddOns and C_AddOns.IsAddOnLoaded or IsAddOnLoaded
    questie = loaded and loaded("Questie") and true or false
  end
  return questie
end

-- map data, read on first use: { starts = { {x, y, name, quests = { {id, lvl, req, max, side, race, class, pre1, preAll, excl, bc, name} } } },
-- ends = { {x, y, name, ids = {id ...}} } }
local parsed = {}
local function split(s) local t = {}; for v in s:gmatch("[^/]+") do t[#t + 1] = tonumber(v) end; return t end
local function mapData(mapID)
  local d = parsed[mapID]
  if d ~= nil then return d end
  local raw = FLT.QUEST_PINS and FLT.QUEST_PINS[mapID]
  if not raw then parsed[mapID] = false; return false end
  d = { starts = {}, ends = {} }
  local cur, last
  for line in raw:gmatch("[^\n]+") do
    local c = line:sub(1, 1)
    if c == "~" then
      if last then last.route = line:sub(2) end -- walking NPC: its route, drawn on mouseover
    elseif c == "!" then
      local x, y, name = line:match("^!([%d.]+),([%d.]+),(.*)$")
      cur = { x = tonumber(x), y = tonumber(y), name = name, quests = {} }
      d.starts[#d.starts + 1] = cur; last = cur
    elseif c == "?" then
      local x, y, ids, name = line:match("^%?([%d.]+),([%d.]+),([%d/]+),(.*)$")
      last = { x = tonumber(x), y = tonumber(y), name = name, ids = split(ids) }
      d.ends[#d.ends + 1] = last
    elseif cur then
      local f = {}
      for v in (line .. "|"):gmatch("([^|]*)|") do f[#f + 1] = v end
      cur.quests[#cur.quests + 1] = { id = tonumber(f[1]), lvl = tonumber(f[2]) or 0, req = tonumber(f[3]) or 0,
        max = tonumber(f[4]) or 0, side = f[5], race = tonumber(f[6]), class = tonumber(f[7]) or 0,
        pre1 = f[8] ~= "" and split(f[8]) or nil, preAll = f[9] ~= "" and split(f[9]) or nil,
        excl = f[10] ~= "" and split(f[10]) or nil, bc = tonumber(f[11]), name = f[12] }
    end
  end
  parsed[mapID] = d
  return d
end

-- the quest log: in the log / finished (reused tables)
local inLog, complete, titles = {}, {}, {}
local bagHas = {} -- [itemID] = in the bags (Library Book quests below), per refresh - wiped with the quest log
local function readLog()
  wipe(inLog); wipe(complete); wipe(titles); wipe(bagHas)
  if C_QuestLog and C_QuestLog.GetNumQuestLogEntries and C_QuestLog.GetInfo then
    for i = 1, C_QuestLog.GetNumQuestLogEntries() or 0 do
      local info = C_QuestLog.GetInfo(i)
      if info and not info.isHeader and info.questID then
        inLog[info.questID] = true; titles[info.questID] = info.title
        local done = C_QuestLog.IsComplete and C_QuestLog.IsComplete(info.questID)
        if done == nil then done = info.isComplete end
        if done and done ~= 0 and done ~= -1 then complete[info.questID] = true end
      end
    end
  elseif GetNumQuestLogEntries and GetQuestLogTitle then
    for i = 1, GetNumQuestLogEntries() or 0 do
      local qtitle, _, _, isHeader, _, isComplete, _, questID = GetQuestLogTitle(i)
      if not isHeader and questID then
        inLog[questID] = true; titles[questID] = qtitle
        if isComplete and isComplete > 0 then complete[questID] = true end
      end
    end
  end
end

local function done(id) return FLT.IsQuestDone and FLT:IsQuestDone(id) end
-- Library Book quests (6.1.6, user 06.11.: "dutzende" ! at Owen Thadd, who had none): QuestieDB names the librarians as
-- givers, but they offer a book quest only while you carry that book (the Friend of the Library quests: any book)
local bookOf -- [questID] = itemID of its book (FLT.BOOKS), built on first use
local FRIEND = { [78150] = true, [79536] = true, [82208] = true }
local function inBags(item)
  local v = bagHas[item]
  if v == nil then
    local n = (C_Item and C_Item.GetItemCount and C_Item.GetItemCount(item)) or (GetItemCount and GetItemCount(item)) or 0
    v = n > 0; bagHas[item] = v
  end
  return v
end
local function bookOK(id)
  if not bookOf then
    bookOf = {}
    for _, b in ipairs(FLT.BOOKS or {}) do if b.questId and b.itemId then bookOf[b.questId] = b.itemId end end
  end
  local item = bookOf[id]
  if item then return inBags(item) end
  if FRIEND[id] then for _, it in pairs(bookOf) do if inBags(it) then return true end end return false end
  return true
end
local function bit(mask, n) return math.floor(mask / 2 ^ (n - 1)) % 2 == 1 end -- masks go past 32 bits (Skyborne)

local me = {}
local function readMe()
  me.level = UnitLevel and UnitLevel("player") or 1
  local f = UnitFactionGroup and UnitFactionGroup("player")
  me.side = f == "Horde" and "H" or f == "Alliance" and "A" or nil
  me.race = UnitRace and select(3, UnitRace("player"))
  me.class = UnitClass and select(3, UnitClass("player"))
  -- grey below this level (the game's own range when it has one)
  local range = GetQuestGreenRange and GetQuestGreenRange("player")
  if type(range) ~= "number" then range = me.level <= 5 and 5 or me.level <= 39 and (math.floor(me.level / 10) + 5) or 8 end
  me.grey = me.level - range
end

local function available(q)
  if q.req > me.level or q.lvl < me.grey or (q.max > 0 and me.level > q.max) then return false end
  -- far above your level (6.1.1, user 04.11.: level 60 book, Legacy and event quests that anyone may take showed for
  -- a level 9 character): only up to 10 levels above
  if q.lvl > me.level + 10 then return false end
  if q.side ~= "" and me.side and q.side ~= me.side then return false end
  if q.race and me.race and not bit(q.race, me.race) then return false end
  if q.class > 0 and me.class and not bit(q.class, me.class) then return false end
  if inLog[q.id] or done(q.id) then return false end
  if not bookOK(q.id) then return false end
  if q.excl then for _, e in ipairs(q.excl) do if inLog[e] or done(e) then return false end end end
  if q.bc and (inLog[q.bc] or done(q.bc)) then return false end -- breadcrumb: its target is already on the way
  if q.preAll then for _, p in ipairs(q.preAll) do if not done(p) then return false end end end
  if q.pre1 then
    local ok = false
    for _, p in ipairs(q.pre1) do if done(p) then ok = true; break end end
    if not ok then return false end
  end
  return true
end

-- the level range in which a quest can be taken and still gives experience (user 01.11.: "[8] Practical Prey (5-13)"):
-- from its required level up to the last level at which it is not grey yet (the classic grey levels: up to level 5
-- nothing, then level - level/10 - 5, from 40 on level - level/5 - 1, at 60: 48)
local function greyAt(pl)
  if pl <= 5 then return 0 elseif pl <= 39 then return pl - math.floor(pl / 10) - 5
  elseif pl <= 59 then return pl - math.floor(pl / 5) - 1 end
  return 48
end
-- grey for you (no experience any more): used by "Accept quests automatically" (6.1.5, user 05.11.)
local questLevel -- [questID] = level, read from the pin data on first use
function FLT.IsQuestGrey(id, level)
  local pl = UnitLevel and UnitLevel("player") or 1
  if not level and id then
    if not questLevel then
      questLevel = {}
      for _, raw in pairs(FLT.QUEST_PINS or {}) do
        for qid, lvl in raw:gmatch("\n(%d+)|(%d+)|") do questLevel[tonumber(qid)] = tonumber(lvl) end
      end
    end
    level = questLevel[id]
  end
  return level ~= nil and level > 0 and level <= greyAt(pl)
end
local function xpRange(q)
  local from = math.max(1, q.req)
  local to = from
  while to < 60 and q.lvl > greyAt(to + 1) do to = to + 1 end
  return from, to
end

local function title(q)
  local t = C_QuestLog and C_QuestLog.GetTitleForQuestID and C_QuestLog.GetTitleForQuestID(q.id or q)
  if type(t) == "string" and t ~= "" and not (FLT.IsSecret and FLT.IsSecret(t)) then return t end
  return q.name or "?"
end

-- Pins -----------------------------------------------------------------------------------------------------------------
local pool, used = {}, 0
-- the mouse only for the tooltip: clicks go through to the map below (GitHub #38: our "?" sat on Blizzard's own
-- turn-in icon and took the click that opens the quest in the quest log)
local function hoverOnly(f)
  f:EnableMouse(true)
  if f.SetMouseClickEnabled then f:SetMouseClickEnabled(false) end
end
local spots = {} -- reused per refresh: key "x,y" -> { x, y, name, avail = {}, turnin = {} }
local spotList = {}

-- the route of a walking quest giver, always shown with its icon (user 01.11., like Questie)
local routeFrame, lines, nLines = nil, {}, 0
-- invisible hover spots along the routes (6.1.1, user 04.11.: like Questie, the route shows its giver's tooltip and
-- lights up on mouseover); pooled like the lines
local hits, nHits = {}, 0
local onEnter, onLeave -- forward (the tooltip of the pins)
local function paintRoute(r, on)
  for i = r.first, r.last do
    local l = lines[i]
    -- only a touch more (user 04.11.: the strong glow looked cheap): slightly thicker, fully opaque
    if on then l:SetColorTexture(1, 0.85, 0.15, 1); l:SetThickness(3.2 * r.scale)
    else l:SetColorTexture(1, 0.82, 0.1, 0.85); l:SetThickness(2.5 * r.scale) end
  end
end
local function hitEnter(self) paintRoute(self.route, true); onEnter(self) end
local function hitLeave(self) paintRoute(self.route, false); onLeave() end
local function hideRoute()
  for i = 1, nLines do lines[i]:Hide() end
  for i = 1, nHits do hits[i]:Hide(); hits[i].spot, hits[i].route = nil, nil end
  nLines, nHits = 0, 0
end
local HIT_STEP = 10 -- a hover spot every 10 units along the route
local function showRoute(route, child, w, h, scale, level, s)
  if not child.CreateLine then return end
  if not routeFrame then routeFrame = CreateFrame("Frame", nil, child); routeFrame:SetAllPoints() end
  routeFrame:SetFrameLevel(math.max(1, level - 1)); routeFrame:Show()
  local r = { first = nLines + 1, scale = scale }
  for path in route:gmatch("[^|]+") do
    local px, py
    for x, y in path:gmatch("([%d.]+),([%d.]+)") do
      x, y = tonumber(x) / 100 * w, -tonumber(y) / 100 * h
      if px then
        nLines = nLines + 1
        local l = lines[nLines]
        if not l then l = routeFrame:CreateLine(nil, "OVERLAY"); lines[nLines] = l end
        l:SetColorTexture(1, 0.82, 0.1, 0.85); l:SetThickness(2.5 * scale)
        l:SetStartPoint("TOPLEFT", routeFrame, px, py); l:SetEndPoint("TOPLEFT", routeFrame, x, y)
        l:Show()
        -- hover spots along this piece
        local dx, dy = x - px, y - py
        local steps = math.max(1, math.floor(math.sqrt(dx * dx + dy * dy) / (HIT_STEP * scale)))
        if nHits + steps > 600 then steps = math.max(0, 600 - nHits) end -- a few routes per map; never hundreds more
        for k = 0, steps - 1 do
          nHits = nHits + 1
          local hf = hits[nHits]
          if not hf then
            hf = CreateFrame("Frame", nil, routeFrame); hoverOnly(hf)
            hf:SetScript("OnEnter", hitEnter); hf:SetScript("OnLeave", hitLeave)
            hits[nHits] = hf
          end
          hf.spot, hf.route = s, r
          hf:SetSize(HIT_STEP * scale * 1.4, HIT_STEP * scale * 1.4)
          hf:ClearAllPoints(); hf:SetPoint("CENTER", routeFrame, "TOPLEFT", px + dx * k / steps, py + dy * k / steps)
          hf:SetFrameLevel(math.max(1, level - 1)); hf:Show()
        end
      end
      px, py = x, y
    end
  end
  r.last = nLines
end

onEnter = function(pin)
  local s = pin.spot
  if not s or not GameTooltip then return end
  GameTooltip:SetOwner(pin, "ANCHOR_RIGHT")
  GameTooltip:AddLine(s.name, 1, 0.82, 0.2)
  for _, id in ipairs(s.turnin) do GameTooltip:AddLine("Turn in: " .. (titles[id] or title({ id = id })), 0.4, 0.9, 0.4, true) end
  for _, q in ipairs(s.avail) do
    local c = GetQuestDifficultyColor and GetQuestDifficultyColor(q.lvl) or { r = 1, g = 1, b = 1 }
    local lo, hi = xpRange(q)
    GameTooltip:AddLine("[" .. q.lvl .. "] " .. title(q) .. "  |cff9d9d9d(" .. lo .. (hi > lo and ("-" .. hi) or "") .. ")|r", c.r, c.g, c.b, true)
  end
  GameTooltip:Show()
end
onLeave = function() if GameTooltip then GameTooltip:Hide() end end

local function acquire(parent)
  used = used + 1
  local pin = pool[used]
  if not pin then
    pin = CreateFrame("Frame", nil, parent)
    pin.tex = pin:CreateTexture(nil, "OVERLAY"); pin.tex:SetAllPoints()
    hoverOnly(pin)
    pin:SetScript("OnEnter", onEnter); pin:SetScript("OnLeave", onLeave)
    pool[used] = pin
  end
  return pin
end
local function hideAll()
  for i = 1, used do pool[i]:Hide(); pool[i].spot = nil end
  used = 0
end

local function spot(x, y, name, route)
  local key = x .. "," .. y
  local s = spots[key]
  if not s then
    s = { avail = {}, turnin = {} }
    spots[key] = s
  end
  if not s.used then s.used = true; s.x, s.y, s.name, s.route = x, y, name, nil; spotList[#spotList + 1] = s end
  if route then s.route = route end
  return s
end

-- the zones of a continent with quest data and where they lie on it: { {mapID, x0, y0, sx, sy} } (0-1 of the
-- continent map), cached per continent (6.1.1, user 04.11.: the icons also when zoomed out of the zone)
local continents = {}
local function continentZones(mapID)
  local c = continents[mapID]
  if c ~= nil then return c end
  c = false
  local info = C_Map and C_Map.GetMapInfo and C_Map.GetMapInfo(mapID)
  local CONT = Enum and Enum.UIMapType and Enum.UIMapType.Continent or 2
  if info and info.mapType == CONT and C_Map.GetMapChildrenInfo and FLT.QUEST_PINS then
    c = {}
    local ok, kids = pcall(C_Map.GetMapChildrenInfo, mapID, nil, true)
    for _, k in ipairs(ok and kids or {}) do
      if k.mapID and FLT.QUEST_PINS[k.mapID] and C_Map.GetMapRectOnMap then
        local ok2, x0, x1, y0, y1 = pcall(C_Map.GetMapRectOnMap, k.mapID, mapID)
        if ok2 and x0 and x1 and y0 and y1 and x1 > x0 and y1 > y0 then c[#c + 1] = { k.mapID, x0, y0, x1 - x0, y1 - y0 } end
      end
    end
    if #c == 0 then c = false end
  end
  continents[mapID] = c
  return c
end

local ONE = { { nil, 0, 0, 1, 1 } } -- a zone map: its own data at full size
function MQ.Refresh()
  if not WorldMapFrame then return end
  hideAll(); hideRoute()
  if not Q("mapQuests") or questieLoaded() or not WorldMapFrame:IsShown() then return end
  local mapID = WorldMapFrame.GetMapID and WorldMapFrame:GetMapID()
  if not mapID then return end
  local zones
  if mapData(mapID) then ONE[1][1] = mapID; zones = ONE
  elseif Q("mapQuestsContinent") then zones = continentZones(mapID) end
  if not zones then return end
  local LM = FLT.MapLandmarks
  local child, w, h, scale, level
  if LM and LM.Canvas then child, w, h, scale, level = LM.Canvas() end
  if not child then return end
  readLog(); readMe()
  for _, s in ipairs(spotList) do s.used = nil; wipe(s.avail); wipe(s.turnin) end
  wipe(spotList)
  local whole = zones == ONE
  for _, z in ipairs(zones) do
    local d = mapData(z[1])
    if d then
      -- zone coordinates (0-100) -> this map's; walking routes only on the zone map itself
      local function at(x, y) return z[2] * 100 + x * z[4], z[3] * 100 + y * z[5] end
      local givers, turnins = Q("mapQuestGivers") ~= false, Q("mapQuestTurnins") ~= false -- 6.1.9: each on its own
      for _, g in ipairs(givers and d.starts or {}) do
        for _, q in ipairs(g.quests) do
          if available(q) then local x, y = at(g.x, g.y); local s = spot(x, y, g.name, whole and g.route or nil); s.avail[#s.avail + 1] = q end
        end
      end
      for _, e in ipairs(turnins and d.ends or {}) do
        for _, id in ipairs(e.ids) do
          if complete[id] then local x, y = at(e.x, e.y); local s = spot(x, y, e.name, whole and e.route or nil); s.turnin[#s.turnin + 1] = id end
        end
      end
    end
  end
  local size = whole and SIZE or SIZE * 0.8 -- a bit smaller on the continent
  for _, s in ipairs(spotList) do
    local pin = acquire(child)
    pin.spot = s
    setIcon(pin.tex, #s.turnin > 0)
    pin:SetSize(size, size); pin:SetScale(scale); pin:SetFrameLevel(level)
    pin:ClearAllPoints()
    pin:SetPoint("CENTER", child, "TOPLEFT", (s.x / 100) * w / scale, -(s.y / 100) * h / scale)
    pin:Show()
    if s.route then showRoute(s.route, child, w, h, scale, level, s) end
  end
end

-- quest log changes while the map is open (accept, finish, turn in, level up): debounced
local ev = CreateFrame("Frame")
local EVENTS = { "QUEST_LOG_UPDATE", "QUEST_TURNED_IN", "PLAYER_LEVEL_UP" }
local pending = false
ev:SetScript("OnEvent", function()
  if pending then return end
  pending = true
  C_Timer.After(0.5, function() pending = false; MQ.Refresh() end)
end)
local function listen(on) for _, e in ipairs(EVENTS) do if on then ev:RegisterEvent(e) else ev:UnregisterEvent(e) end end end

local hooked
local function onShow() if Q("mapQuests") then listen(true) end; MQ.Refresh() end
local function onHide() listen(false); hideAll() end
function MQ.Apply()
  if Q("mapQuests") and not hooked and WorldMapFrame then
    hooked = true
    WorldMapFrame:HookScript("OnShow", onShow)
    WorldMapFrame:HookScript("OnHide", onHide)
    if WorldMapFrame.OnMapChanged then hooksecurefunc(WorldMapFrame, "OnMapChanged", MQ.Refresh) end
    if WorldMapFrame.OnCanvasScaleChanged then hooksecurefunc(WorldMapFrame, "OnCanvasScaleChanged", MQ.Refresh) end
  end
  local open = WorldMapFrame and WorldMapFrame:IsShown()
  listen(Q("mapQuests") and open and true or false)
  MQ.Refresh()
end
MQ.QuestieLoaded = questieLoaded
MQ._mapData, MQ._available, MQ._pool, MQ._xpRange = mapData, available, pool, xpRange -- for tools/tests/t_mapquests.lua
function MQ._me(t) for k, v in pairs(t) do me[k] = v end wipe(bagHas) end

local boot = CreateFrame("Frame")
boot:RegisterEvent("PLAYER_LOGIN")
boot:SetScript("OnEvent", function(self)
  self:UnregisterAllEvents()
  if FLT.QoL and FLT.QoL.On then FLT.QoL.On("mapQuests", MQ.Apply); FLT.QoL.On("mapQuestsContinent", MQ.Refresh)
    FLT.QoL.On("mapQuestGivers", MQ.Refresh); FLT.QoL.On("mapQuestTurnins", MQ.Refresh) end
  if Q("mapQuests") then MQ.Apply() end
end)
