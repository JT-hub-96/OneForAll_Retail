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
        {
            level = 55,
            id = 92343,
            name = "Get to the Roots of It",
            requires = 45,
            faction = "Horde",
            pickup = "Nara Wildmane, Thunder Bluff (75.7, 31.6)",
            objective = "Gather 10 Nordrassil Root Caps inside Blackmaw Hold for Nara Wildmane in Thunder Bluff.",
            turnin = "Nara Wildmane, Thunder Bluff",
            rewardItems = {
            },
        },
        {
            level = 55,
            id = 92344,
            name = "Get to the Roots of It",
            requires = 45,
            faction = "Alliance",
            pickup = "Mathrengyl Bearwalker, Darnassus (35.4, 8.4)",
            objective = "Gather 10 Nordrassil Root Caps inside Blackmaw Hold for Mathrengyl Bearwalker in Darnassus.",
            turnin = "Mathrengyl Bearwalker, Darnassus",
            rewardItems = {
            },
        },
        {
            level = 59,
            id = 97173,
            name = "Blackmaw Magic",
            requires = 52,
            faction = "Alliance",
            objective = "Recover a Blackmaw Ritual Totem from Blackmaw Hold.",
            rewardItems = {
            },
        },
        {
            level = 59,
            id = 97198,
            name = "Blackmaw Magic",
            requires = 52,
            faction = "Horde",
            objective = "Recover a Blackmaw Ritual Totem from Blackmaw Hold.",
            rewardItems = {
            },
        },
        {
            level = 58,
            id = 92069,
            name = "Claws That Rend, Tusks that Gore",
            faction = "Both",
            pickup = "Ogtinc, Azshara (42.4, 42.6)",
            objective = "Bring the Claws of the Great Bear and the Tusks of the Unbroken to Ogtinc, in Azshara.",
            turnin = "Ogtinc, Azshara",
            rewardItems = {
            },
            note = "Still being discovered: who gives this quest and its rewards are not known yet.",
        },
        {
            level = 55,
            id = 92070,
            name = "A Lost Memento",
            faction = "Both",
            objective = "Find the owner of the Feathered Charm Necklace.",
            rewardItems = {
            },
            note = "Still being discovered: who gives this quest and its rewards are not known yet.",
        },
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
