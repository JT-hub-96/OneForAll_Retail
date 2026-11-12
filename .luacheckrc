-- luacheck config for OneForAll Retail (run: tools/check.sh, or luacheck on the files of OneForAll/OneForAll.toc)
std = "lua51"
allow_defined_top = true -- file-level globals (slash commands, key bindings) are fine
max_line_length = false
unused = false
redefined = false
ignore = {
  "542", -- empty if branch (used on purpose as "nothing to do")
  "511", -- unreachable code after an early return (kept for later phases)
  "131", -- "unused" globals: slash commands and key binding names are read by the game
}

-- written by the addon (SavedVariables, slash commands, key bindings)
globals = {
  "OneForAllRetailDB", "OneForAllRetailCharDB", "SlashCmdList", "GetMinimapShape",
  "SLASH_ONEFORALL1", "SLASH_ONEFORALL2", "BINDING_HEADER_ONEFORALL", "BINDING_NAME_ONEFORALL_TOGGLECHAT", "OneForAll_ToggleChat",
  "GameTooltip", "ColorPickerFrame", -- own fields are set on them
}

-- WoW API and Blizzard frames the addon reads
read_globals = {
  table = { fields = { "unpack", "wipe" } },
  "AcceptGroup", "AcceptQuest", "ActionButtonSpellAlertManager", "ActionButton_HideOverlayGlow",
  "ActionButton_ShowOverlayGlow", "AddonCompartmentFrame", "AuraUtil", "BNGetNumFriends", "BOOKTYPE_SPELL",
  "Baganator", "BreakUpLargeNumbers", "CLOSE", "CUSTOM_CLASS_COLORS", "C_AddOns", "C_BattleNet", "C_CVar",
  "C_ChatInfo", "C_Container", "C_FriendList", "C_GamePad", "C_GossipInfo", "C_GuildInfo", "C_Item", "C_Map",
  "C_Minimap", "C_NamePlate", "C_PartyInfo", "C_QuestLog", "C_Spell", "C_SpellBook", "C_Texture", "C_Timer",
  "C_UnitAuras", "CanMerchantRepair", "CancelDuel", "ChatEdit_ActivateChat", "ChatEdit_GetActiveWindow",
  "ChatEdit_UpdateHeader", "ChatFontNormal", "ChatFrame1", "ChatFrameMenuButton", "ClearCursor",
  "CompactUnitFrameProfiles_ApplyCurrentSettings", "CompleteQuest", "ConfirmAcceptQuest",
  "ContainerFrameCombinedBags", "ContainerFrame_Update", "CreateColor", "CreateFrame", "DEFAULT_CHAT_FRAME",
  "DeleteCursorItem", "DoEmote", "ERR_INV_FULL", "ERR_LOOT_NO_SPACE", "Enum", "FCF_SetChatWindowFontSize",
  "GameFontHighlightSmall", "GeneralDockManager", "GetActiveQuestID", "GetActiveTitle",
  "GetAddOnMemoryUsage", "GetAddOnMetadata", "GetAvailableQuestInfo", "GetBindLocation", "GetCVar", "GetCVarBool",
  "GetContainerItemID", "GetContainerItemInfo", "GetContainerItemQuestInfo", "GetContainerNumFreeSlots",
  "GetContainerNumSlots", "GetCursorPosition", "GetFileIDFromPath", "GetFramerate", "GetGameTime",
  "GetGuildRosterInfo", "GetInventoryItemDurability", "GetInventoryItemLink", "GetInventoryItemTexture",
  "GetItemCooldown", "GetItemCount", "GetItemIcon", "GetItemInfo", "GetItemInfoInstant", "GetItemSpell",
  "GetLatestThreeSenders", "GetLocale", "GetLootSlotInfo", "GetLootSlotLink", "GetLootSlotType", "GetMaxPlayerLevel",
  "GetMoney", "GetMouseButtonClicked", "GetNetStats", "GetNumActiveQuests",
  "GetNumAvailableQuests", "GetNumGuildMembers", "GetNumLootItems", "GetNumQuestChoices", "GetNumQuestItems",
  "GetNumQuestLogEntries", "GetNumSpellTabs", "GetPlayerInfoByGUID", "GetQuestID", "GetQuestItemLink",
  "GetQuestLogRewardXP", "GetQuestLogTitle", "GetQuestReward", "GetRealZoneText", "GetRealmName", "GetRepairAllCost",
  "GetSpellBookItemName", "GetSpellInfo", "GetSpellTabInfo", "GetSpellTexture", "GetSubZoneText", "GetTime",
  "GetTitleText", "GetTrackingTexture", "GetWeaponEnchantInfo", "GetXPExhaustion", "GetZoneText",
  "HandleModifiedItemClick", "HasNewMail", "HealthBar_OnValueChanged", "HideUIPanel", "ITEM_QUALITY_COLORS",
  "InCombatLockdown", "InviteUnit", "IsAddOnLoaded", "IsAltKeyDown", "IsGuildMember", "IsInGroup", "IsInGuild",
  "IsInRaid", "IsModifiedClick", "IsMouseButtonDown", "IsPlayerSpell", "IsQuestCompletable", "IsQuestWatched",
  "IsShiftKeyDown", "IsSpellKnown", "ItemRefTooltip", "LOCALIZED_CLASS_NAMES_MALE", "LOOT_SLOT_ITEM", "LibStub",
  "LootFrame", "LootSlot", "LootSlotHasItem", "MainMenuBarBackpackButton", "MainMenuExpBar", "MerchantFrame",
  "Minimap", "MinimapBackdrop", "MinimapCluster", "NUM_BAG_SLOTS", "NUM_CHAT_WINDOWS", "NUM_CONTAINER_FRAMES",
  "PVEFrame_ToggleFrame", "PickupContainerItem", "PlaySound", "RAID_CLASS_COLORS", "RepairAllItems",
  "SELECTED_CHAT_FRAME", "SOUNDKIT", "SelectActiveQuest", "SelectAvailableQuest", "SetCVar", "SetUnitCursorTexture",
  "Settings", "SettingsPanel", "ShoppingTooltip1", "ShoppingTooltip2", "StaticPopup_Hide",
  "TRANSMOGRIFY_TOOLTIP_APPEARANCE_UNKNOWN", "TRANSMOGRIFY_TOOLTIP_ITEM_UNKNOWN_APPEARANCE_KNOWN",
  "TimeManager_Toggle", "ToggleAllBags", "ToggleCalendar", "ToggleCharacter", "ToggleCollectionsJournal",
  "ToggleEncounterJournal", "ToggleFriendsFrame", "ToggleGuildFrame", "ToggleLFGParentFrame", "ToggleQuestLog",
  "ToggleSpellBook", "ToggleTalentFrame", "ToggleWorldMap", "TooltipDataProcessor", "UIErrorsFrame", "UIParent",
  "UISpecialFrames", "UnitBuff", "UnitClass", "UnitExists", "UnitFrameHealthBar_Update", "UnitGUID",
  "UnitIsDeadOrGhost", "UnitIsGameObject", "UnitIsGroupAssistant", "UnitIsGroupLeader", "UnitIsPlayer", "UnitIsUnit",
  "UnitLevel", "UnitName", "UnitNameFromGUID", "UnitRace", "UnitXP", "UnitXPMax", "UpdateAddOnMemoryUsage",
  "UpdateContainerFrameAnchors", "UpdateUIPanelPositions", "UseContainerItem", "WorldMapFrame", "atan2", "date",
  "hooksecurefunc", "issecretvalue", "wipe",
}
