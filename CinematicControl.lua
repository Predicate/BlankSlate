local f = CreateFrame("Frame")
f:RegisterEvent("CINEMATIC_START")
f:RegisterEvent("CINEMATIC_STOP")
f:EnableKeyboard()
f:Hide()
f:SetScript("OnEvent", function(self, event)
	if (event == "CINEMATIC_START") then
		self:Show()
	elseif (event == "CINEMATIC_STOP") then
		self:Hide()
	end
end)
f:SetScript("OnKeyDown", function(_, key)
	if key == "ESCAPE" then
		StopCinematic()
	elseif key == "PRINTSCREEN" then
		Screenshot()
	end
end)
