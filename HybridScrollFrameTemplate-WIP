local addonName, addon = ...

local function genData(scrollChild,maxx)
  if not maxx then maxx = 99 end
  scrollChild.data = scrollChild.data or {}
  local padding = 10
  local height = 0
  local width = 0
  local cheight = 0
  for i=1, maxx  do
     scrollChild.data[i] = scrollChild.data[i] or scrollChild:CreateFontString("Blah "..i, nil, "GameFontBlackMedium")
     local fs = scrollChild.data[i]
     fs:SetText("String"..i)
     local fheight = fs:GetStringHeight()
	 fheight = math.ceil(fheight)
	 fs:SetHeight(fheight)
     if i == 1 then
        fs:SetPoint("TOPLEFT", 0, 0)
     else
        fs:SetPoint("TOPLEFT", scrollChild.data[i - 1], "BOTTOMLEFT", 0, -padding)
     end
     height = height + fheight + padding
	 cheight = fheight
  end
  scrollChild:SetHeight(height)
end

local Frame = CreateFrame("Frame", nil, UIParent)
Frame:SetSize(300, 300)
Frame:SetPoint("CENTER", UIParent, 0, 200)

local scrollFrame = CreateFrame("ScrollFrame", "scrollFrame", Frame, "HybridScrollFrameTemplate")
scrollFrame:SetAllPoints()
scrollFrame.width  = Frame:GetWidth()
scrollFrame.height = Frame:GetHeight()
--scrollFrame.scrollChild = scrollChild
local tex = scrollFrame:CreateTexture(nil, "BACKGROUND")
tex:SetTexture(1,1,1)
tex:SetVertexColor(1,1,0,0.3)
tex:SetAllPoints()

local scrollChild = CreateFrame("Frame", "scrollChild", scrollFrame)
scrollChild:SetSize(Frame:GetWidth(), Frame:GetHeight())
scrollChild.width  = Frame:GetWidth()
scrollChild.height = Frame:GetHeight()
local tex = scrollChild:CreateTexture(nil, "BACKGROUND")
tex:SetTexture(1,1,1)
tex:SetVertexColor(1,0,1,0.3)
tex:SetAllPoints()

local scrollbar = CreateFrame("Slider", "scrollBar", scrollFrame, "HybridScrollBarTemplate")
scrollbar:SetPoint("LEFT", scrollFrame, "RIGHT", -10, 10)
scrollbar:SetSize(30, scrollFrame.height)
scrollbar:SetMinMaxValues(0, 150) --Max guess for now
scrollbar:SetValueStep(1)
scrollbar.scrollStep = 1
scrollbar.range = 100
scrollbar.scrollBar = scrollbar
scrollbar.parent = scrollFrame
scrollbar:SetScript("OnValueChanged", function(self, value)
	scrollFrame:SetVerticalScroll(value)
end)

scrollFrame.scrollBar = scrollbar
scrollFrame.range = select(2, scrollbar:GetMinMaxValues())
scrollFrame.buttonHeight = 15 --math.ceil
scrollChild.buttonHeight = 15 --math.ceil

genData(scrollChild, 20)

scrollFrame:SetScrollChild(scrollChild)
