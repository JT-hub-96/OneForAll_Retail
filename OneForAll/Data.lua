local ADDON, FLT = ...
FLT = FLT or {}
_G[ADDON] = FLT

-- The visible product name is separate from the addon folder/internal name; asset paths derive from ADDON.
FLT.INTERNAL_ADDON_NAME = ADDON
FLT.DISPLAY_NAME = FLT.DISPLAY_NAME or "OneForAll Retail"
FLT.ASSET_ROOT = FLT.ASSET_ROOT or ("Interface\\AddOns\\" .. ADDON .. "\\Assets\\")
-- Retail fork: the WoW Forever data (Library Books, Classic map IDs, book sets) was removed; it is in the git history
-- (branch main) for the later Retail phases.
