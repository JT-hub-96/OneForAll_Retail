local _, FLT = ...

-- Krol'dok Stronghold: location and story (Blizzard at BlizzCon / PAX Australia via foreverchanges.pro); October 2026.
-- Bosses from the Forever client (DungeonEncounter, wago.tools 1.60.1.70862), NPC IDs and item IDs from Wowhead Forever,
-- loot from wowtbc.gg (08.11.2026, still being discovered); tools/dungeon-check.
FLT.DUNGEON_REGISTRY["Krol'dok Stronghold"] = {
    level = "40-47",
    location = "Riverglades",
    description = "New Forever dungeon: a Twilight's Hammer ogre fortress on a hill in the Riverglades. The ogres raid nearby settlements and take prisoners. Its loot is still being discovered.",
    icon = "Interface\\Icons\\INV_Misc_Bone_OrcSkull_01",
    quests = {
        {
            level = 41,
            id = 94974,
            name = "Key Ingredients",
            requires = 38,
            faction = "Horde",
            pickup = "Kreza Darkthorn, Riverglades (59.9, 46.0)",
            objective = "Bring 4 Thick Leather and 12 Iron Bar to Kreza Darkthorn.",
            turnin = "Kreza Darkthorn, Riverglades",
            rewardItems = {
            },
        },
        {
            level = 41,
            id = 94981,
            name = "Key Ingredients",
            requires = 38,
            faction = "Alliance",
            pickup = "Alphonse Dumas, Riverglades (64.4, 82.0)",
            objective = "Bring 4 Thick Leather and 12 Iron Bars to Alphonse Dumas.",
            turnin = "Alphonse Dumas, Riverglades",
            rewardItems = {
            },
        },
        {
            level = 42,
            id = 94975,
            name = "A Token of Vengeance",
            requires = 38,
            faction = "Horde",
            pickup = "Da'grosh, inside Krol'dok Stronghold",
            objective = "Collect 15 Cultist Ears from the Twilight's Hammer in Krol'dok Stronghold.",
            turnin = "Da'grosh, inside Krol'dok Stronghold",
            rewardItems = {
            },
        },
        {
            level = 42,
            id = 94983,
            name = "Twilight Mementos",
            requires = 38,
            faction = "Alliance",
            objective = "Collect 8 Cultist Bangles from the Twilight's Hammer in Krol'dok Stronghold.",
            rewardItems = {
            },
        },
        {
            level = 42,
            id = 94998,
            name = "Curios of Curiosity",
            requires = 38,
            faction = "Alliance",
            pickup = "Melanie Sable, Riverglades (66.2, 83.4)",
            objective = "Bring the Satchel of Mementos to Melanie Sable.",
            turnin = "Melanie Sable, Riverglades",
            rewardItems = {
            },
        },
        {
            level = 44,
            id = 94972,
            name = "Tome of Twilight",
            requires = 39,
            faction = "Horde",
            pickup = "Tran'gul, Riverglades (59.4, 44.2)",
            objective = "Recover the Tome of Twilight from Krol'dok Stronghold.",
            turnin = "Tran'gul, Riverglades",
            rewardItems = {
            },
        },
        {
            level = 44,
            id = 94984,
            name = "Tome of Twilight",
            requires = 39,
            faction = "Alliance",
            objective = "Kill Nar'gurk within Krol'dok Stronghold and recover any valuable information.",
            rewardItems = {
            },
        },
        {
            level = 45,
            id = 94968,
            name = "Eye of Mugg",
            requires = 40,
            faction = "Horde",
            pickup = "Krom'rosh, Riverglades (59.4, 45.6)",
            objective = "Infiltrate Krol'dok Stronghold and return to Krom'rosh with proof of their leader's demise.",
            turnin = "Krom'rosh, Riverglades",
            rewardItems = {
            },
        },
        {
            level = 45,
            id = 94982,
            name = "Eye of Mugg",
            requires = 40,
            faction = "Alliance",
            objective = "Infiltrate Krol'dok Stronghold and return to Commander Brant with proof of their leader's demise.",
            rewardItems = {
            },
        },
        {
            level = 45,
            id = 96771,
            name = "Vengeance of the Highborne",
            requires = 37,
            faction = "Alliance",
            objective = "Travel to Krol'dok Stronghold and slay Zalfan Moonshadow.",
            rewardItems = {
            },
        },
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
            name = "Bossman Toof",
            npcID = 264773,
            loot = {
                {286429, "Big-Belly Belt", "Waist, Cloth", 3},
            },
        },
    },
}
