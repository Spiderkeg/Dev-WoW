local bar = CreateFrame('StatusBar', nil, UIParent)
bar:SetMovable(true)
bar:EnableMouse(true)
bar:RegisterForDrag("LeftButton")
bar:SetScript("OnDragStart", bar.StartMoving)
bar:SetScript("OnDragStop", bar.StopMovingOrSizing)
bar:SetPoint('CENTER')
bar.unit = "player" -- Variable for the unitID to watch so we only have to change it in one location

bar:SetSize(200, 40)
bar:SetBackdrop({bgFile = [[Interface\DialogFrame\UI-DialogBox-Background-Dark]]})
bar:SetStatusBarTexture([[Interface\AddOns\TEST\Flat]], 'ARTWORK') --Background image
bar:SetOrientation('HORIZONTAL')
bar:SetBackdropColor(144/255, 47/255, 223/255, 1)

local fill = bar:GetStatusBarTexture()
fill:SetVertexColor(1.0,0.0,0.0)

----

bar:SetScript('OnEvent', function(self, event, ...)
	if event == 'UNIT_MAXPOWER' then
		self:SetMinMaxValues(0, UnitPowerMax(self.unit)) -- Update max value for the bar
	elseif event == 'UNIT_POWER' or event == 'UNIT_POWER_FREQUENT' then
		self:SetValue(UnitPower(self.unit)) -- Update current value for the bar to reflect our health
	elseif event == 'PLAYER_ENTERING_WORLD' then -- Update everything after a loading screen
		self:SetMinMaxValues(0, UnitPowerMax(self.unit))
		self:SetValue(UnitPower(self.unit))
	end
end)

bar:RegisterUnitEvent('UNIT_MAXPOWER', bar.unit)
bar:RegisterUnitEvent('UNIT_POWER', bar.unit)
bar:RegisterUnitEvent('UNIT_POWER_FREQUENT', bar.unit)
bar:RegisterEvent('PLAYER_ENTERING_WORLD')
bar:SetScript("OnUpdate", AnimationTick)
