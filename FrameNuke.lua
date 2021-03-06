do
	local addon, namespace = ...
	_G[addon] = _G[addon] or {}
	setfenv(1, setmetatable(namespace, { __index = _G }))
end
local handlers = { --All known widget handlers from FrameXML/`strings Wow.exe` as of September 2015 (patch 6.2.2)
	"OnAnimFinished",
	"OnArrowPressed",
	"OnAttributeChanged",
	"OnButtonUpdate",
	"OnChar",
	"OnCharComposition",
	"OnClick",
	"OnColorSelect",
	"OnCooldownDone",
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
	"OnError",
	"OnEscapePressed",
	"OnEvent",
	"OnExternalLink",
--	"OnFinished", --Animation/AnimationGroup only
	"OnHide",
	"OnHorizontalScroll",
	"OnHyperlinkClick",
	"OnHyperlinkEnter",
	"OnHyperlinkLeave",
	"OnInputLanguageChanged",
	"OnJoystickAxisMotion",
	"OnJoystickButtonDown",
	"OnJoystickButtonUp",
	"OnJoystickHatMotion",
	"OnJoystickStickMotion",
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
