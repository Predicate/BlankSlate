do
	local addon, namespace = ...
	_G[addon] = _G[addon] or {}
	setfenv(1, setmetatable(namespace, { __index = _G }))
end

--BlankSlate should never remove these globals.
keepers = {
	--Lua globals
	_G = true,
	_VERSION = true,

	--Lua library tables
	bit = true,
	coroutine = true,
	math = true,
	string = true,
	table = true,

	--C API tables
	C_AdventureJournal = true,
	C_BlackMarket = true,
	C_Commentator = true,
	C_Garrison = true,
	C_Heirloom = true,
	C_LFGList = true,
	C_LootHistory = true,
	C_LossOfControl = true,
	C_MapBar = true,
	C_MountJournal = true,
	C_NewItems = true,
	C_PetBattles = true,
	C_PetJournal = true,
	C_ProductChoice = true,
	C_Questline = true,
	C_RecruitAFriend = true,
	C_Scenario = true,
	C_Social = true,
	C_StorePublic = true,
	C_TaskQuest = true,
	C_Timer = true,
	C_ToyBox = true,
	C_Trophy = true,
	C_Vignettes = true,
	C_WowTokenPublic = true,

	--Frames accessed from C
	WorldFrame = true,
	UIParent = true,
	GameTooltip = true,
	--["NamePlate%d"] = true,
}

do
	local playername = UnitName("player")
	local function parseTOCstring(index, field, func)
		local str, enabled, loadable = GetAddOnMetadata(index, field), GetAddOnEnableState(playername, index), select(4,GetAddOnInfo(index))
		if str and enabled and loadable then
			local i = 2
			local nextstr = GetAddOnMetadata(index, field..i)
			while nextstr do
				str = str.." "..nextstr
				nextstr = GetAddOnMetadata(index, field..i)
				i = i + 1
			end
			str:gsub("[%a_][%w_]*", func)
		end
	end

	local imports = setmetatable({}, { __index = function(t, k) t[k] = {} return t[k] end })
	for i = 1, GetNumAddOns() do
		---A TOC metadata field allowing addons to request that certain globals be kept.
		--This is intended for situations where the globals must be accessible to default UI code, such as the use of secure templates.
		--This should not be used unless absolutely necessary, as it will pollute the global environment.
		--If you need more variables than you can fit in one TOC field, continue your list in X-BlankSlate-Keep2, X-BlankSlate-Keep3, etc.
		--@class function
		--@name [TOC] X-BlankSlate-Keep
		--@param ... List of global variable names. May be separated by any characters which cannot be part of a Lua identifier (e.g. commas or whitespace).
		parseTOCstring(i, "X-BlankSlate-Keep", function(var) keepers[var] = true end)
		---A TOC metadata field allowing addons to request a copy of a default UI global to be held by BlankSlate.
		--This is intended for situations where an addon makes use of default UI data such as localized strings or texture paths that are not available from C API.
		--The data will not remain in the global environment (for that, use X-BlankSlate-Keep) and will not be accessible to other addons unless they request it themselves.
		--If you need more variables than you can fit in one TOC field, continue your list in X-BlankSlate-Import2, X-BlankSlate-Import3, etc.
		--@class function
		--@name [TOC] X-BlankSlate-Import
		--@param ... List of global variable names. May be separated by any characters which cannot be part of a Lua identifier (e.g. commas or whitespace).
		parseTOCstring(i, "X-BlankSlate-Import", function(var) imports[GetAddOnInfo(i)][var] = _G[var] end)
	end

	---Retrieves imported globals held by BlankSlate.
	--@param addon Name of the addon requesting the globals.
	--@param ... Names of globals to retrieve.
	--@return The requested globals.
	function BlankSlate.GetImports(addon, ...)
		if select('#', ...) == 1 then
			return imports[addon][(...)]
		end
		local ret = {}
		for i = 1, select('#', ...) do
			ret[i] = imports[addon][select(i, ...)]
		end
		return unpack(ret)
	end
end

doneframes = {}
for f in function(_, f) return EnumerateFrames(f) end do
	if not doneframes[f] and not keepers[f:GetName()] then
		FrameNukeAll(f)
	end
end
doneframes = nil
FrameWipe(WorldFrame)
FrameWipe(UIParent)
FrameWipe(GameTooltip)
--restore basic tooltip functionality
GameTooltip:SetScript("OnTooltipSetDefaultAnchor", function(self) self:SetOwner(UIParent, "ANCHOR_CURSOR") end)

local function isCfunc(f) return (type(f) == "function" and not pcall(setfenv, f, getfenv(f))) end

local curkey
for tmp in next, _G, curkey do
	if keepers[tmp] or isCfunc(_G[tmp]) then
		curkey = tmp
	else
		_G[tmp] = nil
	end
end
