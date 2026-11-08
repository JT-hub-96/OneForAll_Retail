local _, FLT = ...

-- Alcaz Prison: location and story (Blizzard at BlizzCon via foreverchanges.pro); October 2026.
-- Bosses from the Forever client (DungeonEncounter, wago.tools 1.60.1.70862), NPC IDs and item IDs from Wowhead Forever,
-- loot from wowtbc.gg (08.11.2026, still being discovered); tools/dungeon-check.
FLT.DUNGEON_REGISTRY["Alcaz Prison"] = {
    level = "48-53",
    location = "Alcaz Island, Dustwallow Marsh",
    description = "New Forever dungeon: a Defias prison on Alcaz Island where nobles were held for ransom, and rumour says Varian Wrynn was one of them. Now the Defias fight the naga inside. Its loot is still being discovered.",
    icon = "Interface\\Icons\\Spell_Frost_ChainsOfIce",
    quests = {
    },
    bosses = {
        {
            name = "Overseer Wrex",
            loot = {
                {276734, "Wrex's Pinky Ring", "Finger", 3},
            },
        },
        {
            name = "Tidemistress Ca'zass",
            npcID = 255997,
            loot = {
                {276737, "Cloak of the Tidemistress", "Back", 3},
            },
        },
        {
            name = "Katerina the Cleaner",
            npcID = 257016,
            loot = {
                {276740, "Sentimental Locket", "Neck", 3},
            },
        },
        {
            name = "The Questioner",
            npcID = 256236,
            loot = {
                {276742, "Girdle of Extracted Answers", "Waist, Plate", 3},
            },
        },
        {
            name = "Blazeroar",
            loot = {},
        },
    },
}
