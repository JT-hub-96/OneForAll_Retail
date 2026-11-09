local _, FLT = ...

-- Blackmaw Hold: location and story (Blizzard at BlizzCon via foreverchanges.pro); October 2026.
-- Bosses from the Forever client (DungeonEncounter, wago.tools 1.60.1.70862), NPC IDs and item IDs from Wowhead Forever,
-- loot from wowtbc.gg (08.11.2026, still being discovered); tools/dungeon-check.
FLT.DUNGEON_REGISTRY["Blackmaw Hold"] = {
    level = "55-60",
    location = "Behind the Furbolg gate, Azshara",
    description = "New Forever dungeon: a great furbolg city behind the gates of northern Azshara, whose people fight the corruption spreading through it. Its tunnels lead toward the Barrow Deeps raid. Its loot is still being discovered.",
    icon = "Interface\\Icons\\INV_Misc_Pelt_Bear_03",
    quests = {
    },
    bosses = {
        {
            name = "Withermaw",
            npcID = 247195,
            loot = {},
        },
        {
            name = "Impaan the Imprisoner",
            npcID = 247206,
            loot = {},
        },
        {
            name = "Elder Shaman Bloodmane",
            npcID = 247209,
            loot = {},
        },
        {
            name = "Bonesnout the Unbroken",
            npcID = 247198,
            loot = {},
        },
        {
            name = "Varrox Bleakhoof",
            loot = {},
        },
        {
            name = "Blackmaw Behemoth",
            npcID = 247207,
            loot = {},
        },
        {
            name = "Unbound Spirit",
            npcID = 247231,
            loot = {},
        },
        {
            -- rare elite beast; wowtbc.gg lists it as a boss (data check 09.11.2026), NPC ID from Wowhead Forever
            name = "Moontouched Wanderer",
            npcID = 269104,
            rare = true,
            loot = {},
        },
    },
}
