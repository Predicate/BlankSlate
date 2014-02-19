do
	local addon, namespace = ...
	_G[addon] = _G[addon] or {}
	setfenv(1, setmetatable(namespace, { __index = _G }))
end
local handlers = { --All known widget handlers from wowprogramming.com as of February 2014 (patch 5.4.7)
	"OnAnimFinished",
	"OnAttributeChanged",
	"OnChar",
	"OnCharComposition",
	"OnClick",
	"OnColorSelect",
	"OnCursorChanged",
	"OnDisable",
	"OnDoubleClick",
	"OnDragStart",
	"OnDragStop",
	"OnEditFocusGained",
	"OnEditFocusLost",
	"OnEnable",
	"OnEnter",
	"OnEnterPressed",
	"OnEscapePressed",
	"OnEvent",
--	"OnFinished", --Animation/AnimationGroup only
	"OnHide",
	"OnHorizontalScroll",
	"OnHyperlinkClick",
	"OnHyperlinkEnter",
	"OnHyperlinkLeave",
	"OnInputLanguageChanged",
	"OnKeyDown",
	"OnKeyUp",
	"OnLeave",
	"OnLoad",
--	"OnLoop", --AnimationGroup only
	"OnMessageScrollChanged",
	"OnMinMaxChanged",
	"OnMouseDown",
	"OnMouseUp",
	"OnMouseWheel",
	"OnMovieFinished",
	"OnMovieHideSubtitle",
	"OnMovieShowSubtitle",
--	"OnPause", --Animation/AnimationGroup only
--	"OnPlay", --Animation/AnimationGroup only
	"OnReceiveDrag",
	"OnScrollRangeChanged",
	"OnShow",
	"OnSizeChanged",
	"OnSpacePressed",
--	"OnStop", --Animation/AnimationGroup only
	"OnTabPressed",
	"OnTextChanged",
	"OnTextSet",
	"OnTooltipAddMoney",
	"OnTooltipCleared",
	"OnTooltipSetAchievement",
	"OnTooltipSetDefaultAnchor",
	"OnTooltipSetEquipmentSet",
	"OnTooltipSetFrameStack",
	"OnTooltipSetItem",
	"OnTooltipSetQuest",
	"OnTooltipSetSpell",
	"OnTooltipSetUnit",
	"OnUpdate",
	"OnUpdateModel",
	"OnValueChanged",
	"OnVerticalScroll",
	"PostClick",
	"PreClick",
}

function FrameWipe(f)
	for x, y in pairs(f) do
		if x ~= 0 then f[x]= nil end
	end
	for _, h in ipairs(handlers) do
		if f:HasScript(h) then f:SetScript(h, nil) end
	end
end

local function FrameNuke(f)
	doneframes[f] = true
	if f:GetParent() == UIParent then f:SetParent(nil) end
	f:Hide()
	f:ClearAllPoints()
	f:StopAnimating()
end

local function MultiNuke(...)
	for i = 1, select('#', ...) do
		local f = select(i, ...)
		if not (doneframes and doneframes[f]) and not keepers[f:GetName()] then
			FrameNukeAll(f)
		end
	end
end

function FrameNukeAll(f)
	FrameWipe(f)
	if f:GetNumChildren() > 0 then
		MultiNuke(f:GetChildren())
	end
	return FrameNuke(f)
end
