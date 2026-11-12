# OneForAll Retail

**A Retail (12.x, Midnight) fork of [OneForAll](https://github.com/smoergi/OneForAll_Forever) by Smoergi**, the all-in-one companion addon for WoW Forever.
All credit for the original addon, its code and art goes to **Smoergi**. This fork is licensed like the original under the **GNU General Public License v3.0 or later**.

Status: the Quality of Life helpers, info bar, minimap button collector, chat and window tools, profiles and settings work on Retail.
Dungeons & raids, the Armory, talent planner, professions, gear planner, hunter pets and the world map features use WoW Forever data
and are switched off (`FLT.Features` in `OneForAll/Core.lua`) until they are rebuilt on the Retail APIs.
Settings are saved in their own SavedVariables (`OneForAllRetailDB` / `OneForAllRetailCharDB`), separate from the Forever version.

Checks: `tools/check.sh` (needs Lua 5.1 and luacheck) verifies that every file in the `.toc` exists, compiles and passes luacheck.

---

The original README (features of the WoW Forever version) follows; its download and Discord links were removed.

# OneForAll

All-in-one companion addon for **WoW Forever**. No other addons required.

- **Gear Planner** – click a slot of your character to see upgrades from dungeons, quests, reputation and crafting that your class can use, with the gain in % for your talent spec (also in item tooltips), a wishlist, quest chains and the boss that drops an item, a source filter and your own stat weights; enchants, armor kits and scopes that fit each item and who can make them
- **Armory** – item sets for your class (raid, dungeon, PvP, crafted, world; buttons for the main tiers) with the pieces you own, set bonuses and where they drop; reputation rewards by standing
- **Dungeons & Raids** – dungeon maps with boss portraits (M inside a dungeon), bosses, loot with drop chances, quests with quest chains and map pins, dungeon keys and raid attunements
- **Library Books** – which books you have, still need, and where to find them
- **Professions** – a Crafting List that checks your bags, bank and other characters for the materials, Merchant's Favor recipes, who in your guild (or on your other characters) knows a recipe, the nearest trainer of every profession
- **Talent planner** – plan your talents with two saved presets per class, import builds from talentsforever.com / wowforevertalents.com and export your own; trainer window (also a tab in the spellbook) with the spells you can learn next, weapon skills and your class quests with progress
- **Hunter pets** – where to tame which family, which abilities a pet can learn
- **Map Landmarks** – dungeon and raid entrances, flight masters, zeppelins, ships, the Deeprun Tram and Library Books on the world map; click an entrance to open that dungeon
- **Quality of Life** – optional helpers in groups with a search (an info bar at the top of the screen, guild members with OneForAll on the world map, auto repair, sell junk with your own junk list, hide the chat, quest XP on the experience bar, item compare with Shift, minimap button collector, square minimap, sparkle on herbs and ore, brighter class colors, low spell ranks on your action bars, popups and alerts and more); a welcome setup switches them on page by page
- **Look** – one gold modern style that can be made see-through, and a logo in five colors
- **Languages** – English, German, French and Spanish (Settings > General > Language); in a German, French or Spanish game client quest, NPC, item and zone names come in that language too

## Bug reports

This is an unofficial fork. **Please do not report bugs of OneForAll Retail to the original author** (his Discord, CurseForge or GitHub) -
use this repository's issues instead.

## License

Copyright (C) 2026 Smoergi. Licensed under the **GNU General Public License v3.0 or later** – see [LICENSE](LICENSE).
Third-party data and attributions: [`OneForAll/THIRD_PARTY_LICENSES.txt`](OneForAll/THIRD_PARTY_LICENSES.txt) and [`OneForAll/DUNGEON_DATA_SOURCES.txt`](OneForAll/DUNGEON_DATA_SOURCES.txt).
