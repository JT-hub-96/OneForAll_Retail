local _, FLT = ...

-- The Drowned City: quests (wowforevertalents.com beta quest cache), boss names and NPC IDs (Wowhead Forever database via foreverchanges.pro); October 2026.
-- Loot (09.11.2026): boss loot lists of wowtbc.gg, item IDs and the dropping boss checked on Wowhead Forever (search, built-in browser).
-- Viscera Spaulders 274607 and Ritual-Binder's Gloves 274610 (same ID range, item level 41-42) have no known boss yet - left out.
FLT.DUNGEON_REGISTRY["The Drowned City"] = {
    level = "35-42",
    location = "Gillijim's Isle, off the coast of Stranglethorn Vale",
    description = "New Forever dungeon: I'lalai, a lost troll city that has risen from the sea. Naga, risen trolls and stranded pirates fight over its ruins. Its loot is still being discovered: what players have recorded so far is listed.",
    icon = "Interface\\Icons\\INV_Misc_Idol_03",
    quests = {
        {
            id = 95775,
            liveXPFallback = 3150,
            name = "The Drowned City",
            level = 40,
            requires = 30,
            faction = "Horde",
            pickup = "Kin'weelay, Stranglethorn Vale (32.3, 27.7)",
            objective = "Use the hide and charcoal to create rubbings of the tablets found in the Drowned City.",
            turnin = "Kin'weelay, Stranglethorn Vale",
            note = "Make rubbings of the four Tablets of I'lalai inside the city.",
        },
        {
            id = 95776,
            liveXPFallback = 3550,
            name = "The Only Good Brinescale...",
            level = 38,
            requires = 30,
            faction = "Horde",
            pickup = "Commander Aggro'gosh, Stranglethorn Vale (32.2, 28.9)",
            objective = "Slay Var'Taka in the Drowned City.",
            turnin = "Commander Aggro'gosh, Stranglethorn Vale",
            rewardItems = {{279888, "Tidesoaked Leggings", 2}, {279889, "Naga Priestess's Mantle", 2}},
            rewardChoice = true,
            rewardSummary = "1g 30s",
            note = "The quest text mentions Kin'weelay, the troll scholar at Grom'gol Base Camp.",
        },
        {
            id = 96774,
            liveXPFallback = 3900,
            name = "Ancient Gurubashi Idol",
            level = 40,
            requires = 30,
            faction = "Horde",
            pickup = "Mazu'kon, Mulgore (32.4, 20.4)",
            objective = "Recover an Ancient Gurubashi Idol from the Drowned City.",
            turnin = "Mazu'kon, Mulgore",
            rewardSummary = "1g",
            note = "The idol is carried by the strongest priest in the city.",
        },
        {
            level = 40,
            id = 95787,
            name = "Take Two With Water",
            requires = 30,
            faction = "Alliance",
            objective = "Use the hide and charcoal to create rubbings of the tablets found in the Drowned City.",
            rewardItems = {
            },
        },
        {
            level = 40,
            id = 95788,
            name = "Magics of the Drowned City",
            requires = 30,
            faction = "Alliance",
            objective = "Collect 5 I'lalai Fetishes from trolls in the Drowned City.",
            rewardItems = {
            },
        },
        {
            level = 40,
            id = 95789,
            name = "Shady Saltseers",
            requires = 34,
            faction = "Both",
            pickup = "Krazek, Stranglethorn Vale (26.9, 77.2)",
            objective = "Collect 10 Voodoo Infused Artifacts from Saltseer pirates in the Drowned City.",
            rewardItems = {
            },
        },
        {
            level = 40,
            id = 95791,
            name = "The Saltseer Captain",
            requires = 34,
            faction = "Both",
            pickup = "Krazek, Stranglethorn Vale (26.9, 77.2)",
            objective = "Slay 3 Saltseer Coroners and Captain Dreadrise in the Drowned City.",
            turnin = "Krazek, Stranglethorn Vale",
            rewardItems = {
            },
        },
        {
            level = 40,
            id = 95798,
            name = "The Web of Magic",
            requires = 30,
            faction = "Alliance",
            pickup = "Abra Cadabra, Alterac Mountains (12.1, 70.3)",
            objective = "Bring the I'lalai Fetish to Abra Cadabra in Dalaran.",
            turnin = "Abra Cadabra, Alterac Mountains",
            rewardItems = {
            },
        },
        {
            level = 40,
            id = 95799,
            name = "Findings for the Explorer's League",
            requires = 30,
            faction = "Alliance",
            pickup = "Historian Karnik, Ironforge (77.5, 11.8)",
            objective = "Bring Loremaster Dibbs' I'lalai Translations to Historian Karnik in Ironforge.",
            turnin = "Historian Karnik, Ironforge",
            rewardItems = {
            },
        },
        {
            level = 40,
            id = 96078,
            name = "A Tale Spun Around the Fire",
            requires = 30,
            faction = "Horde",
            objective = "Take the tablet etchings to Master Gadrin in Sen'jin Village in Durotar.",
            turnin = "Master Gadrin, Durotar",
            rewardItems = {
            },
        },
        {
            level = 40,
            id = 97130,
            name = "Ancient Gurubashi Secrets",
            requires = 34,
            faction = "Alliance",
            pickup = "Archmage Timear, Alterac Mountains (16.2, 71.7)",
            objective = "Recover an Ancient Gurubashi Idol from the Drowned City.",
            rewardItems = {
            },
        },
    },
    bosses = {
        {
            name = "Zul'Alai",
            npcID = 270882,
            loot = {
                {274598, "Bloodslash Axe", "One-Hand, Axe", 3},
                {274599, "Oathbound Bracers", "Wrist, Leather", 3},
                {274600, "Berserker Shackles", "Wrist, Mail", 3},
            },
        },
        {
            name = "Var'Taka",
            npcID = 270883,
            loot = {
                {274601, "Harpoon of Command", "Two-Hand, Polearm", 3},
                {274602, "Brinebelly Leggings", "Legs, Leather", 3},
                {274613, "Priestess Cloak", "Back", 3},
            },
        },
        {
            name = "Captain Dreadrise",
            npcID = 270884,
            loot = {
                {274603, "Dreadfrost Saber", "Main Hand, Sword", 3},
                {274604, "Frosty Blunderbuss", "Ranged, Gun", 3},
                {274605, "Briny Sash", "Waist, Cloth", 3},
            },
        },
        {
            name = "Deathless Marrow",
            npcID = 270885,
            loot = {
                {274606, "Bloodspine Staff", "Two-Hand, Staff", 3},
                {274614, "Knucklebone Ring", "Finger", 3},
            },
        },
        {
            name = "Gill",
            npcID = 270888,
            loot = {
                {286646, "Gill's Gills", "Trinket", 3},
                {286649, "Tidebound Dagger", "Main Hand, Dagger", 3},
            },
        },
        {
            name = "Primeval Elemental",
            npcID = 270887,
            loot = {
                {274611, "Robe of the Drowned", "Chest, Cloth", 3},
                {274612, "Waterlogged Burial Shroud", "Back", 3},
                {274615, "Heart of the Primeval", "Trinket", 3},
            },
        },
        {
            name = "Min'loth the Serpent",
            npcID = 270886,
            loot = {
                {274608, "Maw of Min'loth", "Off Hand, Shield", 3},
                {274609, "Serpentbane Crown", "Head, Mail", 3},
            },
        },
        {
            name = "Zin'aka",
            loot = {},
        },
    },
}
