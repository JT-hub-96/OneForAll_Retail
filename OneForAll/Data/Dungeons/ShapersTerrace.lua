local _, FLT = ...

-- Shaper's Terrace: location and story (Blizzard at BlizzCon via foreverchanges.pro); October 2026.
-- Bosses from the Forever client (DungeonEncounter, wago.tools 1.60.1.70862), NPC IDs and item IDs from Wowhead Forever,
-- loot from wowtbc.gg (08.11.2026, still being discovered); tools/dungeon-check.
FLT.DUNGEON_REGISTRY["Shaper's Terrace"] = {
    level = "58-60",
    location = "Un'Goro Crater",
    description = "New Forever dungeon: titan terraces, power crystals and ancient wildlife in the hills of Un'Goro Crater. Its loot is still being discovered.",
    icon = "Interface\\Icons\\INV_Misc_Gem_Crystal_02",
    quests = {
    },
    bosses = {
        {
            name = "Titanosaur",
            npcID = 253201,
            loot = {},
        },
        {
            name = "Ravasaur Hunters",
            loot = {},
        },
        {
            name = "Thunderhoof",
            npcID = 261812,
            loot = {},
        },
        {
            name = "Venomridge",
            npcID = 261813,
            loot = {},
        },
        {
            name = "Direhorn Matriarch",
            npcID = 262127,
            loot = {},
        },
        {
            name = "Cinder",
            loot = {},
        },
        {
            name = "King Op",
            loot = {},
        },
        {
            name = "Snowtalon",
            loot = {},
        },
        {
            name = "Bolt",
            loot = {},
        },
        {
            name = "Vitrix",
            npcID = 272561,
            loot = {},
        },
        {
            name = "Nanaya",
            loot = {},
        },
    },
}
