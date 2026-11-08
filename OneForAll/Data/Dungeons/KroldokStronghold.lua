local _, FLT = ...

-- Krol'dok Stronghold: location and story (Blizzard at BlizzCon / PAX Australia via foreverchanges.pro); October 2026.
-- Bosses from the Forever client (DungeonEncounter, wago.tools 1.60.1.70862), NPC IDs and item IDs from Wowhead Forever,
-- loot from wowtbc.gg (08.11.2026, still being discovered); tools/dungeon-check.
FLT.DUNGEON_REGISTRY["Krol'dok Stronghold"] = {
    level = "40-45",
    location = "Riverglades",
    description = "New Forever dungeon: a Twilight's Hammer ogre fortress on a hill in the Riverglades. The ogres raid nearby settlements and take prisoners. Its loot is still being discovered.",
    icon = "Interface\\Icons\\INV_Misc_Bone_OrcSkull_01",
    quests = {
    },
    bosses = {
        {
            name = "Slavecrusher Grox",
            npcID = 258966,
            loot = {
                {274996, "Resistance Breaker Spaulder", "Shoulder, Mail", 3},
            },
        },
        {
            name = "Twilight Commander Zarmok",
            npcID = 258972,
            loot = {
                {274998, "Shadowlight Athame", "Main Hand, Dagger", 3},
            },
        },
        {
            name = "Handler Ashka",
            npcID = 259281,
            aliases = {"War Handler Ashka"},
            loot = {},
        },
        {
            name = "Nar'gurk",
            npcID = 258964,
            loot = {
                {275004, "Chain of the Corruptor", "Neck", 3},
            },
        },
        {
            name = "Overseer Mugg",
            aliases = {"Overlord Mugg"},
            loot = {
                {275009, "Emblem of Slamming", "Trinket", 3},
            },
        },
        {
            description = "Not in the game's boss list; his loot was seen by players (wowtbc.gg).",
            name = "Bossman Toof",
            npcID = 264773,
            loot = {
                {286429, "Big-Belly Belt", "Waist, Cloth", 3},
            },
        },
    },
}
