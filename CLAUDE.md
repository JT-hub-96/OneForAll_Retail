# OneForAll Retail

Retail (12.x, Midnight) port of **OneForAll** by Smoergi, an all-in-one companion addon originally written for
WoW Forever (Blizzard's vanilla-like world on the modern client). GPL-3.0-or-later; keep the author (`Smoergi`),
the license and the attribution.

## Working with the user

- Talk to the user in **Croatian**. Code, comments and commit messages stay in English.
- The user tests in game themselves (at home); you cannot run WoW. Say clearly what still needs an in-game test.
- **Nothing may go to the original author**: no PRs, issues or comments on `smoergi/OneForAll_Forever`, no links to
  his Discord / CurseForge in the addon. This repo is a GitHub fork of his - when opening a PR, the base must be
  `JT-hub-96/OneForAll_Retail`.
- Publishing (personal use vs. a CurseForge fork) is not decided yet.

## Repo layout

- `OneForAll/` - the addon folder (copy it to `World of Warcraft\_retail_\Interface\AddOns\`).
- `OneForAll/OneForAll.toc` - load list. Only files listed here are loaded.
- `.luacheckrc`, `tools/check.sh` - checks (see below).
- Branches: `main` = the original Forever version, `retail` = the port (PR #1 retail -> main).

## Rules for the code

- Namespace: `local ADDON, FLT = ...`; UI helpers in `FLT.UI` (`UI/Widgets.lua`), QoL logic in `FLT.QoL` (`QoL.lua`),
  QoL options in `UI/QoL.lua`, main window/tabs in `UI/MainFrame.lua` (tabs register via `UI.RegisterPanel`).
- SavedVariables: `OneForAllRetailDB` (account), `OneForAllRetailCharDB` (character). Never the old Forever names.
- Feature flags: `FLT.Features` / `FLT.HasFeature(key)` in `Core.lua`. Code that uses an optional module checks the
  module itself too (`if FLT.X and FLT.X.Fn then`).
- Midnight secret values: use `FLT.IsSecret(...)` before reading combat/chat/aura values, and `FLT.SafeCall(tag, fn)`
  in event handlers (errors are logged, `/ofa errors` shows them).
- Nothing aura- or buff-related in combat (`InCombatLockdown()`); never register `COMBAT_LOG_EVENT_UNFILTERED`.
- Prefer `C_*` APIs; legacy globals only as a fallback behind them. Look frames up with `rawget(_G, name)` and type checks.
- Addon message prefixes are Retail-only: `OFARetail` (version check), `OFARetailProf` (profiles).
- Locales: `Locales/Locale.lua` + `deDE/frFR/esES.lua` hold UI strings (keyed by the English text, `L["..."]`).
- Lua 5.1, one file must stay under 200 locals (`QoL.lua` is close: add table fields, not locals).

## Checks (run before every commit)

```
tools/check.sh
```

Every TOC file exists, `luac5.1 -p` passes, luacheck is clean. Needs `lua5.1` and `luacheck` (`luarocks install luacheck`).
New WoW globals go into `read_globals` in `.luacheckrc`.

## Plan (phases)

- [x] **0 - setup**: TOC (`## Interface: 120001, 120005` - confirm with `/dump select(4, GetBuildInfo())`), own
  SavedVariables, Forever data and the modules that need it removed from the TOC (files kept in the repo), feature flags.
- [x] **1 - core and QoL**: Forever branches removed (Skyborne, LegacySystemFrame, ammo/quiver, Forever blessings,
  books), Retail frame names (party `PartyFrame.MemberFrameN`, XP bar `MainStatusTrackingBarContainer`), Blizzard
  options entry (`Settings.RegisterCanvasLayoutCategory`), buff reminder / thanks off in combat, Retail welcome/news,
  upstream Discord links removed.
- [ ] **2 - Dungeons / Armory** on the Encounter Journal API (`EJ_*`, `C_EncounterJournal`).
- [ ] **3 - Talent planner** on `C_Traits` / `C_ClassTalents` (class + spec + hero tree).
- [ ] **4 - Professions** on `C_TradeSkillUI`, warband bank.
- [ ] **5 - Gear planner**: EJ loot + stat weights per spec.
- [ ] **6 - Hunter pets, world map, locale cleanup** (also remove texts that still mention Library Books / trainer).
- [ ] **7 - Python generator** for data the API does not give, packaging.

Not in the TOC (Forever-only, rebuild or delete in later phases): `Data/*`, `Data/Dungeons/*`, `Data/Professions/*`,
`Locales/Names_*.lua`, `Talent*.lua`, `Dungeon*.lua`, `Profession*.lua`, `ExtraData.lua`, `Flights.lua`, `Map*.lua`,
`Proximity.lua`, `QuestMarks.lua`, and in `UI/`: Books, Dungeon*, Armory, Profession*, CraftList,
TrainerSpells, HunterPets, Gear*, MapFog, MapButton, LowRank, QuestShare (`UI/NodeGlow.lua` stays loaded). The Forever data is still on `main` / in the
git history.

## Open points

- Interface number not confirmed in game yet.
- New Retail texts (welcome, news, bug window, footer) are English only.
- `OneForAll/README.txt` (in-addon command list / changelog) is still the Forever one.
- Retail buff preset spell IDs in `QoL.lua` (`PRESETS`) not checked in game.
