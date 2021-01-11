local Controller = AutoBiographer_Controller
local HF = HelperFunctions

AutoBiographer_MainWindow = CreateFrame("Frame", "AutoBiographerMain", UIParent, "BasicFrameTemplateWithInset")
AutoBiographer_DebugWindow = CreateFrame("Frame", "AutoBiographerDebug", AutoBiographer_MainWindow, "BasicFrameTemplate")

-- For some reason the event window needs a parent frame in order to properly show over the main window.
local eventParent = CreateFrame("Frame", "AutoBiographerEventParent", AutoBiographer_MainWindow)
eventParent:SetSize(750, 585)
eventParent:SetPoint("CENTER")
AutoBiographer_EventWindow = CreateFrame("Frame", "AutoBiographerEvent", eventParent, "BasicFrameTemplate")

function AutoBiographer_DebugWindow:Initialize()
  local frame = self
  frame:SetSize(750, 585)
  frame:SetPoint("CENTER")

  frame:SetMovable(true)
  frame:EnableMouse(true)

  frame:SetScript("OnHide", function(self)
    if (self.isMoving) then
      self:StopMovingOrSizing()
      self.isMoving = false
    end
  end)

  frame:SetScript("OnMouseDown", function(self, button)
    if (button == "LeftButton" and not self.isMoving) then
      self:StartMoving()
      self.isMoving = true
    end
  end)

  frame:SetScript("OnMouseUp", function(self, button)
    if (button == "LeftButton" and self.isMoving) then
      self:StopMovingOrSizing()
      self.isMoving = false
    end
  end)

  frame.Title = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  frame.Title:SetPoint("LEFT", frame.TitleBg, "LEFT", 5, 0);
  frame.Title:SetText("AutoBiographer Debug Window")
  
  --scrollframe 
  frame.ScrollFrame = CreateFrame("ScrollFrame", nil, frame) 
  frame.ScrollFrame:SetPoint("TOPLEFT", 10, -25) 
  frame.ScrollFrame:SetPoint("BOTTOMRIGHT", -10, 10) 

  --scrollbar 
  frame.ScrollFrame.Scrollbar = CreateFrame("Slider", nil, frame.ScrollFrame, "UIPanelScrollBarTemplate") 
  frame.ScrollFrame.Scrollbar:SetPoint("TOPLEFT", frame, "TOPRIGHT", -25, -40)
  frame.ScrollFrame.Scrollbar:SetPoint("BOTTOMLEFT", frame, "BOTTOMRIGHT", -25, 22)
  frame.ScrollFrame.Scrollbar:SetMinMaxValues(1, 1)
  frame.ScrollFrame.Scrollbar:SetValueStep(1)
  frame.ScrollFrame.Scrollbar.scrollStep = 15
  frame.ScrollFrame.Scrollbar:SetValue(0)
  frame.ScrollFrame.Scrollbar:SetWidth(16)
  frame.ScrollFrame.Scrollbar:SetScript("OnValueChanged",
    function (self, value) 
      self:GetParent():SetVerticalScroll(value) 
    end
  )
  local scrollbg = frame.ScrollFrame.Scrollbar:CreateTexture(nil, "BACKGROUND") 
  scrollbg:SetAllPoints(scrollbar) 
  scrollbg:SetTexture(0, 0, 0, 0.4) 
  
  --content frame 
  frame.ScrollFrame.Content = CreateFrame("Frame", nil, frame.ScrollFrame)
  frame.ScrollFrame.Content:SetSize(1, 1)
  frame.ScrollFrame.Content.ChildrenCount = 0
  frame.ScrollFrame:SetScrollChild(frame.ScrollFrame.Content)

  frame.LogsUpdated = function(self) -- This is called when a new debug log is added.
    if (self:IsVisible()) then
      self:Update()
    end
  end

  frame.Toggle = function(self)
    if (self:IsVisible()) then
      self:Hide()
    else
      self:Update()
      self:Show()
    end
  end
  
  frame:Hide()
  return frame
end

function AutoBiographer_EventWindow:Initialize()
  local frame = self
  frame:SetSize(750, 585) 
  frame:SetPoint("CENTER") 
  
  frame:SetMovable(true)
  frame:EnableMouse(true)

  frame:SetScript("OnHide", function(self)
    if (self.isMoving) then
      self:StopMovingOrSizing()
      self.isMoving = false
    end
  end)

  frame:SetScript("OnMouseDown", function(self, button)
    if (button == "LeftButton" and not self.isMoving) then
      self:StartMoving()
      self.isMoving = true
    end
  end)

  frame:SetScript("OnMouseUp", function(self, button)
    if (button == "LeftButton" and self.isMoving) then
      self:StopMovingOrSizing()
      self.isMoving = false
    end
  end)

  frame.Title = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  frame.Title:SetPoint("LEFT", frame.TitleBg, "LEFT", 5, 0);
  frame.Title:SetText("AutoBiographer Event Window")
  
  frame.SubFrame = CreateFrame("Frame", "AutoBiographerEventSub", frame)
  frame.SubFrame:SetPoint("TOPLEFT", 10, -25) 
  frame.SubFrame:SetPoint("BOTTOMRIGHT", -10, 10) 
  
  -- Filter Check Boxes
  local leftPoint = -300
  local fsBattleground = frame.SubFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  fsBattleground:SetPoint("CENTER", frame.SubFrame, "TOP", leftPoint, -15)
  fsBattleground:SetText("Battle\nground")
  local cbBattleground= CreateFrame("CheckButton", nil, frame.SubFrame, "UICheckButtonTemplate") 
  cbBattleground:SetPoint("CENTER", frame.SubFrame, "TOP", leftPoint, -40)
  cbBattleground:SetChecked(AutoBiographer_Settings.EventDisplayFilters[AutoBiographerEnum.EventSubType.BattlegroundJoined])
  cbBattleground:SetScript("OnClick", function(self, event, arg1)
    AutoBiographer_Settings.EventDisplayFilters[AutoBiographerEnum.EventSubType.BattlegroundJoined] = self:GetChecked()
    AutoBiographer_Settings.EventDisplayFilters[AutoBiographerEnum.EventSubType.BattlegroundLost] = self:GetChecked()
    AutoBiographer_Settings.EventDisplayFilters[AutoBiographerEnum.EventSubType.BattlegroundWon] = self:GetChecked()
    frame:Update()
  end)

  leftPoint = leftPoint + 50
  local fsBossKill = frame.SubFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  fsBossKill:SetPoint("CENTER", frame.SubFrame, "TOP", leftPoint, -15)
  fsBossKill:SetText("Boss\nKill")
  local cbBossKill= CreateFrame("CheckButton", nil, frame.SubFrame, "UICheckButtonTemplate") 
  cbBossKill:SetPoint("CENTER", frame.SubFrame, "TOP", leftPoint, -40)
  cbBossKill:SetChecked(AutoBiographer_Settings.EventDisplayFilters[AutoBiographerEnum.EventSubType.BossKill])
  cbBossKill:SetScript("OnClick", function(self, event, arg1)
    AutoBiographer_Settings.EventDisplayFilters[AutoBiographerEnum.EventSubType.BossKill] = self:GetChecked()
    frame:Update()
  end)
  
  leftPoint = leftPoint + 50
  local fsFirstAcquiredItem = frame.SubFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  fsFirstAcquiredItem:SetPoint("CENTER", frame.SubFrame, "TOP", leftPoint, -15) 
  fsFirstAcquiredItem:SetText("First\nItem")
  local cbFirstAcquiredItem = CreateFrame("CheckButton", nil, frame.SubFrame, "UICheckButtonTemplate") 
  cbFirstAcquiredItem:SetPoint("CENTER", frame.SubFrame, "TOP", leftPoint, -40)
  cbFirstAcquiredItem:SetChecked(AutoBiographer_Settings.EventDisplayFilters[AutoBiographerEnum.EventSubType.FirstAcquiredItem])
  cbFirstAcquiredItem:SetScript("OnClick", function(self, event, arg1)
    AutoBiographer_Settings.EventDisplayFilters[AutoBiographerEnum.EventSubType.FirstAcquiredItem] = self:GetChecked()
    frame:Update()
  end)
  
  leftPoint = leftPoint + 50
  local fsFirstKill = frame.SubFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  fsFirstKill:SetPoint("CENTER", frame.SubFrame, "TOP", leftPoint, -15)
  fsFirstKill:SetText("First\nKill")
  local cbFirstKill = CreateFrame("CheckButton", nil, frame.SubFrame, "UICheckButtonTemplate") 
  cbFirstKill:SetPoint("CENTER", frame.SubFrame, "TOP", leftPoint, -40)
  cbFirstKill:SetChecked(AutoBiographer_Settings.EventDisplayFilters[AutoBiographerEnum.EventSubType.FirstKill])
  cbFirstKill:SetScript("OnClick", function(self, event, arg1)
    AutoBiographer_Settings.EventDisplayFilters[AutoBiographerEnum.EventSubType.FirstKill] = self:GetChecked()
    frame:Update()
  end)
  
  leftPoint = leftPoint + 50
  local fsGuild = frame.SubFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  fsGuild:SetPoint("CENTER", frame.SubFrame, "TOP", leftPoint, -15)
  fsGuild:SetText("Guild")
  local cbGuild = CreateFrame("CheckButton", nil, frame.SubFrame, "UICheckButtonTemplate") 
  cbGuild:SetPoint("CENTER", frame.SubFrame, "TOP", leftPoint, -40)
  cbGuild:SetChecked(AutoBiographer_Settings.EventDisplayFilters[AutoBiographerEnum.EventSubType.GuildJoined])
  cbGuild:SetScript("OnClick", function(self, event, arg1)
    AutoBiographer_Settings.EventDisplayFilters[AutoBiographerEnum.EventSubType.GuildJoined] = self:GetChecked()
    AutoBiographer_Settings.EventDisplayFilters[AutoBiographerEnum.EventSubType.GuildLeft] = self:GetChecked()
    AutoBiographer_Settings.EventDisplayFilters[AutoBiographerEnum.EventSubType.GuildRankChanged] = self:GetChecked()
    frame:Update()
  end)
  
  leftPoint = leftPoint + 50
  local fsLevelUp = frame.SubFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  fsLevelUp:SetPoint("CENTER", frame.SubFrame, "TOP", leftPoint, -15)
  fsLevelUp:SetText("Level\nUp")
  local cbLevelUp= CreateFrame("CheckButton", nil, frame.SubFrame, "UICheckButtonTemplate") 
  cbLevelUp:SetPoint("CENTER", frame.SubFrame, "TOP", leftPoint, -40)
  cbLevelUp:SetChecked(AutoBiographer_Settings.EventDisplayFilters[AutoBiographerEnum.EventSubType.LevelUp])
  cbLevelUp:SetScript("OnClick", function(self, event, arg1)
    AutoBiographer_Settings.EventDisplayFilters[AutoBiographerEnum.EventSubType.LevelUp] = self:GetChecked()
    frame:Update()
  end)
  
  leftPoint = leftPoint + 50
  local fsPlayerDeath = frame.SubFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  fsPlayerDeath:SetPoint("CENTER", frame.SubFrame, "TOP", leftPoint, -15)
  fsPlayerDeath:SetText("Player\nDeath")
  local cbPlayerDeath = CreateFrame("CheckButton", nil, frame.SubFrame, "UICheckButtonTemplate") 
  cbPlayerDeath:SetPoint("CENTER", frame.SubFrame, "TOP", leftPoint, -40)
  cbPlayerDeath:SetChecked(AutoBiographer_Settings.EventDisplayFilters[AutoBiographerEnum.EventSubType.PlayerDeath])
  cbPlayerDeath:SetScript("OnClick", function(self, event, arg1)
    AutoBiographer_Settings.EventDisplayFilters[AutoBiographerEnum.EventSubType.PlayerDeath] = self:GetChecked()
    frame:Update()
  end)
  
  leftPoint = leftPoint + 50
  local fsQuestTurnIn = frame.SubFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  fsQuestTurnIn:SetPoint("CENTER", frame.SubFrame, "TOP", leftPoint, -15)
  fsQuestTurnIn:SetText("Quest")
  local cbQuestTurnIn = CreateFrame("CheckButton", nil, frame.SubFrame, "UICheckButtonTemplate") 
  cbQuestTurnIn:SetPoint("CENTER", frame.SubFrame, "TOP", leftPoint, -40)
  cbQuestTurnIn:SetChecked(AutoBiographer_Settings.EventDisplayFilters[AutoBiographerEnum.EventSubType.QuestTurnIn])
  cbQuestTurnIn:SetScript("OnClick", function(self, event, arg1)
    AutoBiographer_Settings.EventDisplayFilters[AutoBiographerEnum.EventSubType.QuestTurnIn] = self:GetChecked()
    frame:Update()
  end)
  
  leftPoint = leftPoint + 50
  local fsReputationLevelChanged = frame.SubFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  fsReputationLevelChanged:SetPoint("CENTER", frame.SubFrame, "TOP", leftPoint, -15)
  fsReputationLevelChanged:SetText("Rep\nChanged")
  local cbReputationLevelChanged= CreateFrame("CheckButton", nil, frame.SubFrame, "UICheckButtonTemplate") 
  cbReputationLevelChanged:SetPoint("CENTER", frame.SubFrame, "TOP", leftPoint, -40)
  cbReputationLevelChanged:SetChecked(AutoBiographer_Settings.EventDisplayFilters[AutoBiographerEnum.EventSubType.ReputationLevelChanged])
  cbReputationLevelChanged:SetScript("OnClick", function(self, event, arg1)
    AutoBiographer_Settings.EventDisplayFilters[AutoBiographerEnum.EventSubType.ReputationLevelChanged] = self:GetChecked()
    frame:Update()
  end)
  
  leftPoint = leftPoint + 50
  local fsSkillMilestone = frame.SubFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  fsSkillMilestone:SetPoint("CENTER", frame.SubFrame, "TOP", leftPoint, -15)
  fsSkillMilestone:SetText("Skill")
  local cbSkillMilestone = CreateFrame("CheckButton", nil, frame.SubFrame, "UICheckButtonTemplate") 
  cbSkillMilestone:SetPoint("CENTER", frame.SubFrame, "TOP", leftPoint, -40)
  cbSkillMilestone:SetChecked(AutoBiographer_Settings.EventDisplayFilters[AutoBiographerEnum.EventSubType.SkillMilestone])
  cbSkillMilestone:SetScript("OnClick", function(self, event, arg1)
    AutoBiographer_Settings.EventDisplayFilters[AutoBiographerEnum.EventSubType.SkillMilestone] = self:GetChecked()
    frame:Update()
  end)
  
  leftPoint = leftPoint + 50
  local fsSpellLearned = frame.SubFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  fsSpellLearned:SetPoint("CENTER", frame.SubFrame, "TOP", leftPoint, -15)
  fsSpellLearned:SetText("Spell")
  local cbSpellLearned= CreateFrame("CheckButton", nil, frame.SubFrame, "UICheckButtonTemplate") 
  cbSpellLearned:SetPoint("CENTER", frame.SubFrame, "TOP", leftPoint, -40)
  cbSpellLearned:SetChecked(AutoBiographer_Settings.EventDisplayFilters[AutoBiographerEnum.EventSubType.SpellLearned])
  cbSpellLearned:SetScript("OnClick", function(self, event, arg1)
    AutoBiographer_Settings.EventDisplayFilters[AutoBiographerEnum.EventSubType.SpellLearned] = self:GetChecked()
    frame:Update()
  end)
  
  leftPoint = leftPoint + 50
  local fsSubZoneFirstVisit = frame.SubFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  fsSubZoneFirstVisit:SetPoint("CENTER", frame.SubFrame, "TOP", leftPoint, -15)
  fsSubZoneFirstVisit:SetText("Sub\nZone")
  local cbSubZoneFirstVisit = CreateFrame("CheckButton", nil, frame.SubFrame, "UICheckButtonTemplate") 
  cbSubZoneFirstVisit:SetPoint("CENTER", frame.SubFrame, "TOP", leftPoint, -40)
  cbSubZoneFirstVisit:SetChecked(AutoBiographer_Settings.EventDisplayFilters[AutoBiographerEnum.EventSubType.SubZoneFirstVisit])
  cbSubZoneFirstVisit:SetScript("OnClick", function(self, event, arg1)
    AutoBiographer_Settings.EventDisplayFilters[AutoBiographerEnum.EventSubType.SubZoneFirstVisit] = self:GetChecked()
    frame:Update()
  end)
  
  leftPoint = leftPoint + 50
  local fsZoneFirstVisit = frame.SubFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  fsZoneFirstVisit:SetPoint("CENTER", frame.SubFrame, "TOP", leftPoint, -15)
  fsZoneFirstVisit:SetText("Zone")
  local cbZoneFirstVisit = CreateFrame("CheckButton", nil, frame.SubFrame, "UICheckButtonTemplate") 
  cbZoneFirstVisit:SetPoint("CENTER", frame.SubFrame, "TOP", leftPoint, -40)
  cbZoneFirstVisit:SetChecked(AutoBiographer_Settings.EventDisplayFilters[AutoBiographerEnum.EventSubType.ZoneFirstVisit])
  cbZoneFirstVisit:SetScript("OnClick", function(self, event, arg1)
    AutoBiographer_Settings.EventDisplayFilters[AutoBiographerEnum.EventSubType.ZoneFirstVisit] = self:GetChecked()
    frame:Update()
  end)
  
  --scrollframe 
  frame.SubFrame.ScrollFrame = CreateFrame("ScrollFrame", nil, frame.SubFrame) 
  frame.SubFrame.ScrollFrame:SetPoint("TOPLEFT", 10, -65) 
  frame.SubFrame.ScrollFrame:SetPoint("BOTTOMRIGHT", -10, 10) 

  --scrollbar 
  frame.SubFrame.ScrollFrame.Scrollbar = CreateFrame("Slider", nil, frame.SubFrame.ScrollFrame, "UIPanelScrollBarTemplate")
  frame.SubFrame.ScrollFrame.Scrollbar:SetPoint("TOPLEFT", frame.SubFrame, "TOPRIGHT", -15, -17)
  frame.SubFrame.ScrollFrame.Scrollbar:SetPoint("BOTTOMLEFT", frame.SubFrame, "BOTTOMRIGHT", -15, 12)
  frame.SubFrame.ScrollFrame.Scrollbar:SetMinMaxValues(1, 1)
  frame.SubFrame.ScrollFrame.Scrollbar:SetValueStep(1)
  frame.SubFrame.ScrollFrame.Scrollbar.scrollStep = 15
  frame.SubFrame.ScrollFrame.Scrollbar:SetValue(0)
  frame.SubFrame.ScrollFrame.Scrollbar:SetWidth(16)
  frame.SubFrame.ScrollFrame.Scrollbar:SetScript("OnValueChanged",
    function (self, value) 
      self:GetParent():SetVerticalScroll(value) 
    end
  ) 
  local scrollbg = frame.SubFrame.ScrollFrame.Scrollbar:CreateTexture(nil, "BACKGROUND") 
  scrollbg:SetAllPoints(frame.SubFrame.ScrollFrame.Scrollbar) 
  scrollbg:SetTexture(0, 0, 0, 0.4) 

  frame.Toggle = function(self)
    if (self:IsVisible()) then
      self:Hide()
    else
      self:Update()
      self:Show()
    end
  end

  frame:Hide()
  return frame
end

function AutoBiographer_MainWindow:Initialize()
  local frame = self
  frame:SetSize(800, 600) 
  frame:SetPoint("CENTER") 
  
  frame:SetMovable(true)
  frame:EnableMouse(true)

  frame:SetScript("OnHide", function(self)
    if (self.isMoving) then
      self:StopMovingOrSizing()
      self.isMoving = false
    end

    self:Clear()
  end)

  frame:SetScript("OnMouseDown", function(self, button)
    if (button == "LeftButton" and not self.isMoving) then
     self:StartMoving()
     self.isMoving = true
    end
  end)

  frame:SetScript("OnMouseUp", function(self, button)
    if (button == "LeftButton" and self.isMoving) then
     self:StopMovingOrSizing()
     self.isMoving = false
    end
  end)
  
  frame.Title = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
  frame.Title:SetPoint("LEFT", frame.TitleBg, "LEFT", 5, 0);
  frame.Title:SetText("AutoBiographer Main Window")

   --scrollframe 
  frame.ScrollFrame = CreateFrame("ScrollFrame", nil, frame) 
  frame.ScrollFrame:SetPoint("TOPLEFT", 10, -25) 
  frame.ScrollFrame:SetPoint("BOTTOMRIGHT", -10, 10) 

  --scrollbar 
  frame.ScrollFrame.Scrollbar = CreateFrame("Slider", nil, frame.ScrollFrame, "UIPanelScrollBarTemplate")
  frame.ScrollFrame.Scrollbar:SetPoint("TOPLEFT", frame, "TOPRIGHT", -25, -45)
  frame.ScrollFrame.Scrollbar:SetPoint("BOTTOMLEFT", frame, "BOTTOMRIGHT", -25, 22)
  frame.ScrollFrame.Scrollbar:SetMinMaxValues(1, 510)
  frame.ScrollFrame.Scrollbar:SetValueStep(1)
  frame.ScrollFrame.Scrollbar.scrollStep = 15
  frame.ScrollFrame.Scrollbar:SetValue(0)
  frame.ScrollFrame.Scrollbar:SetWidth(16)
  frame.ScrollFrame.Scrollbar:SetScript("OnValueChanged",
    function (self, value) 
      self:GetParent():SetVerticalScroll(value) 
    end
  )
  
  frame.Clear = function(self)
    if (self.ScrollFrame.Content) then
      self.ScrollFrame.Content:Hide()
      self.ScrollFrame.Content = nil
    end
  end  
  
  frame.Toggle = function(self)
    if (self:IsVisible()) then
      self:Hide()
    else
      self:Update()
      self:Show()
    end
  end
  
  frame:Hide()
  return frame
end

function AutoBiographer_DebugWindow:Update()
  local previousScrollbarMaxValue = (self.ScrollFrame.Content.ChildrenCount * 15) - self.ScrollFrame:GetHeight();
  local previousScrollbarValue = self.ScrollFrame.Scrollbar:GetValue()
  local previousScrollbarValueWasAtMax = previousScrollbarValue >= previousScrollbarMaxValue

  local debugLogs = Controller:GetLogs()
  for i = self.ScrollFrame.Content.ChildrenCount + 1, #debugLogs, 1 do
    local font = "GameFontWhite"
    if (debugLogs[i].Level == AutoBiographerEnum.LogLevel.Verbose) then font = "GameFontDisable"
    elseif (debugLogs[i].Level == AutoBiographerEnum.LogLevel.Debug) then font = "GameFontDisable"
    elseif (debugLogs[i].Level == AutoBiographerEnum.LogLevel.Information) then font = "GameFontWhite"
    elseif (debugLogs[i].Level == AutoBiographerEnum.LogLevel.Warning) then font = "GameFontNormal"
    elseif (debugLogs[i].Level == AutoBiographerEnum.LogLevel.Error) then font = "GameFontRed"
    elseif (debugLogs[i].Level == AutoBiographerEnum.LogLevel.Fatal) then font = "GameFontRed"
    end
    
    local text = self.ScrollFrame.Content:CreateFontString(nil, "OVERLAY", font)
    text:SetPoint("TOPLEFT", 5, -15 * i) 
    text:SetText(debugLogs[i].Text)
    self.ScrollFrame.Content.ChildrenCount = self.ScrollFrame.Content.ChildrenCount + 1
  end
  
  local scrollbarMaxValue = (self.ScrollFrame.Content.ChildrenCount * 15) - self.ScrollFrame:GetHeight();
  if (scrollbarMaxValue <= 0) then scrollbarMaxValue = 1 end
  self.ScrollFrame.Scrollbar:SetMinMaxValues(1, scrollbarMaxValue)

  if (previousScrollbarValueWasAtMax) then
    self.ScrollFrame.Scrollbar:SetValue(scrollbarMaxValue)
  end
end

function AutoBiographer_EventWindow:Update()
  if (self.SubFrame.ScrollFrame.Content) then self.SubFrame.ScrollFrame.Content:Hide() end
  --content frame
  self.SubFrame.ScrollFrame.Content = CreateFrame("Frame", nil, self.SubFrame.ScrollFrame) 
  self.SubFrame.ScrollFrame.Content:SetSize(1, 1) 
  
  local events = Controller:GetEvents()

  --texts
  local index = 0
  for i = 1, #events, 1 do
    if (AutoBiographer_Settings.EventDisplayFilters[events[i].SubType]) then
      local text = self.SubFrame.ScrollFrame.Content:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
      text:SetPoint("TOPLEFT", 5, -15 * index) 
      text:SetText(Controller:GetEventString(events[i]))
      index = index + 1
    end
  end
  
  local scrollbarMaxValue = (index * 15) - self.SubFrame.ScrollFrame:GetHeight();
  if (scrollbarMaxValue <= 0) then scrollbarMaxValue = 1 end
  self.SubFrame.ScrollFrame.Scrollbar:SetMinMaxValues(1, scrollbarMaxValue)
  self.SubFrame.ScrollFrame.Scrollbar:SetValue(scrollbarMaxValue)
  
  self.SubFrame.ScrollFrame:SetScrollChild(self.SubFrame.ScrollFrame.Content)
end

function AutoBiographer_MainWindow:Update()
  --content frame 
  local content = CreateFrame("Frame", nil, AutoBiographer_MainWindow.ScrollFrame) 
  content:SetSize(775, 600)
  content:SetPoint("TOPLEFT", AutoBiographer_MainWindow.ScrollFrame, "TOPRIGHT", 0, 0) 
  content:SetPoint("BOTTOMLEFT", AutoBiographer_MainWindow.ScrollFrame, "BOTTOMRIGHT", 0, 0)
  
  -- Buttons
  local eventsBtn = CreateFrame("Button", nil, content, "UIPanelButtonTemplate");
  eventsBtn:SetPoint("CENTER", content, "TOP", -150, -25);
  eventsBtn:SetSize(140, 40);
  eventsBtn:SetText("Events");
  eventsBtn:SetNormalFontObject("GameFontNormalLarge");
  eventsBtn:SetHighlightFontObject("GameFontHighlightLarge");
  eventsBtn:SetScript("OnClick", 
    function(self)
      AutoBiographer_EventWindow:Toggle()
    end
  )
  
  local optionsBtn = CreateFrame("Button", nil, content, "UIPanelButtonTemplate");
  optionsBtn:SetPoint("CENTER", content, "TOP", 0, -25);
  optionsBtn:SetSize(140, 40);
  optionsBtn:SetText("Options");
  optionsBtn:SetNormalFontObject("GameFontNormalLarge");
  optionsBtn:SetHighlightFontObject("GameFontHighlightLarge");
  optionsBtn:SetScript("OnClick", 
    function(self)
      InterfaceOptionsFrame_OpenToCategory(AutoBiographer_OptionWindow) -- Call this twice because it won't always work correcly if just called once.
      InterfaceOptionsFrame_OpenToCategory(AutoBiographer_OptionWindow)
      AutoBiographer_MainWindow:Hide()
    end
  )
  
  local debugBtn = CreateFrame("Button", nil, content, "UIPanelButtonTemplate");
  debugBtn:SetPoint("CENTER", content, "TOP", 150, -25);
  debugBtn:SetSize(140, 40);
  debugBtn:SetText("Debug");
  debugBtn:SetNormalFontObject("GameFontNormalLarge");
  debugBtn:SetHighlightFontObject("GameFontHighlightLarge");
  debugBtn:SetScript("OnClick", 
    function(self)
      AutoBiographer_DebugWindow:Toggle()
    end
  )
  
  -- Dropdown
  local dropdown = CreateFrame("Frame", nil, content, "UIDropDownMenuTemplate")
  dropdown:SetSize(100, 25)
  dropdown:SetPoint("LEFT", content, "TOP", -dropdown:GetWidth(), -65)
  
  if (not self.DropdownText) then self.DropdownText = "Total" end
  if (not self.DisplayMaxLevel) then self.DisplayMaxLevel = 9999 end
  if (not self.DisplayMinLevel) then self.DisplayMinLevel = 1 end
  UIDropDownMenu_SetText(dropdown, self.DropdownText)
  
  local dropdownOnClick = function(self, arg1, arg2, checked)
    AutoBiographer_MainWindow.DropdownText = self.value
    
    AutoBiographer_MainWindow.DisplayMinLevel = arg1
    AutoBiographer_MainWindow.DisplayMaxLevel = arg2
    
    AutoBiographer_MainWindow:Clear()
    AutoBiographer_MainWindow:Update()
  end
  
  UIDropDownMenu_Initialize(dropdown, function(self, level, menuList)
    local info = UIDropDownMenu_CreateInfo()
    info.func = dropdownOnClick
   
    if (not level or level == 1) then
      info.text, info.arg1, info.arg2 = "Total", 1, 9999
      UIDropDownMenu_AddButton(info)
      
      for i = 0, 5 do
        local includeThisRange = false
        for j = 1, 10 do
          if (Controller.CharacterData.Levels[(i * 10) + j]) then includeThisRange = true end
        end
        
        if (includeThisRange) then
          info.arg1 = (i * 10) + 1
          info.arg2 = (i * 10) + 10
          info.text = "Levels " .. info.arg1 .. " - " .. info.arg2
          info.menuList = i
          info.hasArrow = true
          UIDropDownMenu_AddButton(info)
        end
      end
    else
      for i = 1, 10 do
        info.arg1 = (menuList * 10) + i
        info.arg2 = info.arg1
        info.text = "Level " .. info.arg1
        
        if (Controller.CharacterData.Levels[info.arg1]) then UIDropDownMenu_AddButton(info, level) end
      end
    end
  end)
  
  -- Header Stuff
  if (self.DisplayMinLevel == self.DisplayMaxLevel and Controller.CharacterData.Levels[self.DisplayMinLevel] and Controller.CharacterData.Levels[self.DisplayMinLevel].TimePlayedThisLevel) then
    local timePlayedThisLevelFS = content:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    timePlayedThisLevelFS:SetPoint("LEFT", content, "TOP", 50, -65)
    timePlayedThisLevelFS:SetText("Time played this level: " .. HF.SecondsToTimeString(Controller.CharacterData.Levels[self.DisplayMinLevel].TimePlayedThisLevel))
  end
  
  local topPoint = -65

  -- Battlegrounds
  local battlegroundHeaderFs = content:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
  topPoint = topPoint - 10
  battlegroundHeaderFs:SetPoint("TOPLEFT", 10, topPoint)
  battlegroundHeaderFs:SetText("Battlegrounds")

  local avJoined, avLosses, avWins = Controller:GetBattlegroundStatsByBattlegroundId(1, self.DisplayMinLevel, self.DisplayMaxLevel)
  local avStatsText = "Alterac Valley - Wins: " .. HF.CommaValue(avWins) .. ". Losses: " .. HF.CommaValue(avLosses) .. ". Incomplete: " .. HF.CommaValue(avJoined - avLosses - avWins) .. "."
  local avStatsFs = content:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  topPoint = topPoint - 20
  avStatsFs:SetPoint("TOPLEFT", 10, topPoint)
  avStatsFs:SetText(avStatsText)

  local abJoined, abLosses, abWins = Controller:GetBattlegroundStatsByBattlegroundId(3, self.DisplayMinLevel, self.DisplayMaxLevel)
  local abStatsText = "Arathi Basin - Wins: " .. HF.CommaValue(abWins) .. ". Losses: " .. HF.CommaValue(abLosses) .. ". Incomplete: " .. HF.CommaValue(abJoined - abLosses - abWins) .. "."
  local abStatsFs = content:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  topPoint = topPoint - 15
  abStatsFs:SetPoint("TOPLEFT", 10, topPoint)
  abStatsFs:SetText(abStatsText)

  local wsgJoined, wsgLosses, wsgWins = Controller:GetBattlegroundStatsByBattlegroundId(2, self.DisplayMinLevel, self.DisplayMaxLevel)
  local wsgStatsText = "Warsong Gulch - Wins: " .. HF.CommaValue(wsgWins) .. ". Losses: " .. HF.CommaValue(wsgLosses) .. ". Incomplete: " .. HF.CommaValue(wsgJoined - wsgLosses - wsgWins) .. "."
  local wsgStatsFs = content:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  topPoint = topPoint - 15
  wsgStatsFs:SetPoint("TOPLEFT", 10, topPoint)
  wsgStatsFs:SetText(wsgStatsText)

  -- Damage
  local damageHeaderFs = content:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
  topPoint = topPoint - 30
  damageHeaderFs:SetPoint("TOPLEFT", 10, topPoint)
  damageHeaderFs:SetText("Damage")
  
  local damageDealtAmount, damageDealtOver = Controller:GetDamageOrHealing(AutoBiographerEnum.DamageOrHealingCategory.DamageDealt, self.DisplayMinLevel, self.DisplayMaxLevel)
  local petDamageDealtAmount, petDamageDealtOver = Controller:GetDamageOrHealing(AutoBiographerEnum.DamageOrHealingCategory.PetDamageDealt, self.DisplayMinLevel, self.DisplayMaxLevel)
  local damageDealtText = "Damage Dealt: " .. HF.CommaValue(damageDealtAmount) .. " (" .. HF.CommaValue(damageDealtOver) .. " over)."
  if (petDamageDealtAmount > 0) then damageDealtText = damageDealtText .. " Pet Damage Dealt: " .. tostring(petDamageDealtAmount) .. " (" .. tostring(petDamageDealtOver) .. " over)." end
  local damageDealtFs = content:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  topPoint = topPoint - 20
  damageDealtFs:SetPoint("TOPLEFT", 10, topPoint)
  damageDealtFs:SetText(damageDealtText)
  
  local damageTakenAmount, damageTakenOver = Controller:GetDamageOrHealing(AutoBiographerEnum.DamageOrHealingCategory.DamageTaken, self.DisplayMinLevel, self.DisplayMaxLevel)
  local petDamageTakenAmount, petDamageTakenOver = Controller:GetDamageOrHealing(AutoBiographerEnum.DamageOrHealingCategory.PetDamageTaken, self.DisplayMinLevel, self.DisplayMaxLevel)
  local damageTakenText = "Damage Taken: " .. HF.CommaValue(damageTakenAmount) .. " (" .. HF.CommaValue(damageTakenOver) .. " over)."
  if (petDamageTakenAmount > 0) then damageTakenText = damageTakenText .. " Pet Damage Taken: " .. HF.CommaValue(petDamageTakenAmount) .. " (" .. HF.CommaValue(petDamageTakenOver) .. " over)." end
  local damageTakenFs = content:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  topPoint = topPoint - 15
  damageTakenFs:SetPoint("TOPLEFT", 10, topPoint)
  damageTakenFs:SetText(damageTakenText)
  
  local healingOtherAmount, healingOtherOver = Controller:GetDamageOrHealing(AutoBiographerEnum.DamageOrHealingCategory.HealingDealtToOthers, self.DisplayMinLevel, self.DisplayMaxLevel)
  local healingOtherFs = content:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  topPoint = topPoint - 15
  healingOtherFs:SetPoint("TOPLEFT", 10, topPoint)
  healingOtherFs:SetText("Healing Dealt to Others: " .. HF.CommaValue(healingOtherAmount) .. " (" .. HF.CommaValue(healingOtherOver) .. " over).")
  
  local healingSelfAmount, healingSelfOver = Controller:GetDamageOrHealing(AutoBiographerEnum.DamageOrHealingCategory.HealingDealtToSelf, self.DisplayMinLevel, self.DisplayMaxLevel)
  local healingSelfFs = content:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  topPoint = topPoint - 15
  healingSelfFs:SetPoint("TOPLEFT", 10, topPoint)
  healingSelfFs:SetText("Healing Dealt to Self: " .. HF.CommaValue(healingSelfAmount) .. " (" .. HF.CommaValue(healingSelfOver) .. " over).")
  
  local healingTakenAmount, healingTakenOver = Controller:GetDamageOrHealing(AutoBiographerEnum.DamageOrHealingCategory.HealingTaken, self.DisplayMinLevel, self.DisplayMaxLevel)
  local healingTakenFs = content:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  topPoint = topPoint - 15
  healingTakenFs:SetPoint("TOPLEFT", 10, topPoint)
  healingTakenFs:SetText("Healing Taken: " .. HF.CommaValue(healingTakenAmount) .. " (" .. HF.CommaValue(healingTakenOver) .. " over).")
  
  -- Deaths
  local deathsHeaderFs = content:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
  topPoint = topPoint - 30
  deathsHeaderFs:SetPoint("TOPLEFT", 10, topPoint)
  deathsHeaderFs:SetText("Deaths")

  local deathsToCreatures = Controller:GetDeathsByDeathTrackingType(AutoBiographerEnum.DeathTrackingType.DeathToCreature, self.DisplayMinLevel, self.DisplayMaxLevel)
  local deathsToEnvironment = Controller:GetDeathsByDeathTrackingType(AutoBiographerEnum.DeathTrackingType.DeathToEnvironment, self.DisplayMinLevel, self.DisplayMaxLevel)
  local deathsToGameObjects = Controller:GetDeathsByDeathTrackingType(AutoBiographerEnum.DeathTrackingType.DeathToGameObject, self.DisplayMinLevel, self.DisplayMaxLevel)
  local deathsToPets = Controller:GetDeathsByDeathTrackingType(AutoBiographerEnum.DeathTrackingType.DeathToPet, self.DisplayMinLevel, self.DisplayMaxLevel)
  local deathsToPlayers = Controller:GetDeathsByDeathTrackingType(AutoBiographerEnum.DeathTrackingType.DeathToPlayer, self.DisplayMinLevel, self.DisplayMaxLevel)
  local totalDeaths = deathsToCreatures + deathsToEnvironment + deathsToGameObjects + deathsToPets + deathsToPlayers
  local totalDeathsFs = content:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  topPoint = topPoint - 20
  totalDeathsFs:SetPoint("TOPLEFT", 10, topPoint)
  totalDeathsFs:SetText("Total Deaths: " .. HF.CommaValue(totalDeaths) .. ".")

  local deathsToCreaturesFs = content:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  topPoint = topPoint - 15
  deathsToCreaturesFs:SetPoint("TOPLEFT", 20, topPoint)
  deathsToCreaturesFs:SetText("Deaths to Creatures: " .. HF.CommaValue(deathsToCreatures) .. ".")

  local deathsToEnvironmentFs = content:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  topPoint = topPoint - 15
  deathsToEnvironmentFs:SetPoint("TOPLEFT", 20, topPoint)
  deathsToEnvironmentFs:SetText("Deaths to Environment: " .. HF.CommaValue(deathsToEnvironment) .. ".")

  local deathsToGameObjectsFs = content:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  topPoint = topPoint - 15
  deathsToGameObjectsFs:SetPoint("TOPLEFT", 20, topPoint)
  deathsToGameObjectsFs:SetText("Deaths to Game Objects: " .. HF.CommaValue(deathsToGameObjects) .. ".")

  local deathsToPetsFs = content:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  topPoint = topPoint - 15
  deathsToPetsFs:SetPoint("TOPLEFT", 20, topPoint)
  deathsToPetsFs:SetText("Deaths to Pets: " .. HF.CommaValue(deathsToPets) .. ".")

  local deathsToPlayersFs = content:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  topPoint = topPoint - 15
  deathsToPlayersFs:SetPoint("TOPLEFT", 20, topPoint)
  deathsToPlayersFs:SetText("Deaths to Players: " .. HF.CommaValue(deathsToPlayers) .. ".")

  -- Experience
  local experienceHeaderFs = content:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
  topPoint = topPoint - 30
  experienceHeaderFs:SetPoint("TOPLEFT", 10, topPoint)
  experienceHeaderFs:SetText("Experience")

  local experienceFromKills = Controller:GetExperienceByExperienceTrackingType(AutoBiographerEnum.ExperienceTrackingType.Kill, self.DisplayMinLevel, self.DisplayMaxLevel)
  local experienceFromKillsFs = content:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  topPoint = topPoint - 20
  experienceFromKillsFs:SetPoint("TOPLEFT", 10, topPoint)
  experienceFromKillsFs:SetText("Experience From Kills: " .. HF.CommaValue(experienceFromKills) .. ".")
      
  local experienceFromRestedBonus = Controller:GetExperienceByExperienceTrackingType(AutoBiographerEnum.ExperienceTrackingType.RestedBonus, self.DisplayMinLevel, self.DisplayMaxLevel)
  local experienceFromRestedBonusFs = content:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  topPoint = topPoint - 15
  experienceFromRestedBonusFs:SetPoint("TOPLEFT", 20, topPoint)
  experienceFromRestedBonusFs:SetText("Experience From Rested Bonus: " .. HF.CommaValue(experienceFromRestedBonus) .. ".")
  
  local experienceFromGroupBonus = Controller:GetExperienceByExperienceTrackingType(AutoBiographerEnum.ExperienceTrackingType.GroupBonus, self.DisplayMinLevel, self.DisplayMaxLevel)
  local experienceFromGroupBonusFs = content:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  topPoint = topPoint - 15
  experienceFromGroupBonusFs:SetPoint("TOPLEFT", 20, topPoint)
  experienceFromGroupBonusFs:SetText("Experience From Group Bonus: " .. HF.CommaValue(experienceFromGroupBonus) .. ".")
  
  local experienceLostToRaidPenalty = Controller:GetExperienceByExperienceTrackingType(AutoBiographerEnum.ExperienceTrackingType.RaidPenalty, self.DisplayMinLevel, self.DisplayMaxLevel)
  local experienceLostToRaidPenaltyFs = content:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  topPoint = topPoint - 15
  experienceLostToRaidPenaltyFs:SetPoint("TOPLEFT", 20, topPoint)
  experienceLostToRaidPenaltyFs:SetText("Experience Lost To Raid Penalty: " .. HF.CommaValue(experienceLostToRaidPenalty) .. ".")
  
  local experienceFromQuests = Controller:GetExperienceByExperienceTrackingType(AutoBiographerEnum.ExperienceTrackingType.Quest, self.DisplayMinLevel, self.DisplayMaxLevel)
  local experienceFromQuestsFs = content:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  topPoint = topPoint - 15
  experienceFromQuestsFs:SetPoint("TOPLEFT", 10, topPoint)
  experienceFromQuestsFs:SetText("Experience From Quests: " .. HF.CommaValue(experienceFromQuests) .. ".")
  
  local experienceFromDiscovery = Controller:GetExperienceByExperienceTrackingType(AutoBiographerEnum.ExperienceTrackingType.Discovery, self.DisplayMinLevel, self.DisplayMaxLevel)
  local experienceFromDiscoveryFs = content:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  topPoint = topPoint - 15
  experienceFromDiscoveryFs:SetPoint("TOPLEFT", 10, topPoint)
  experienceFromDiscoveryFs:SetText("Experience From Discovery: " .. HF.CommaValue(experienceFromDiscovery) .. ".")
  
  -- Items
  local itemsHeaderFs = content:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
  topPoint = topPoint - 30
  itemsHeaderFs:SetPoint("TOPLEFT", 10, topPoint)
  itemsHeaderFs:SetText("Items")
  
  local itemsCreated = Controller:GetItemCountForAcquisitionMethod(AutoBiographerEnum.ItemAcquisitionMethod.Create, self.DisplayMinLevel, self.DisplayMaxLevel)
  local itemsCreatedFs = content:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  topPoint = topPoint - 20
  itemsCreatedFs:SetPoint("TOPLEFT", 10, topPoint)
  itemsCreatedFs:SetText("Items Created: " .. HF.CommaValue(itemsCreated) .. ".")
  
  local itemsLooted = Controller:GetItemCountForAcquisitionMethod(AutoBiographerEnum.ItemAcquisitionMethod.Loot, self.DisplayMinLevel, self.DisplayMaxLevel)
  local itemsLootedFs = content:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  topPoint = topPoint - 15
  itemsLootedFs:SetPoint("TOPLEFT", 10, topPoint)
  itemsLootedFs:SetText("Items Looted: " .. HF.CommaValue(itemsLooted) .. ".")
  
  local itemsOther = Controller:GetItemCountForAcquisitionMethod(AutoBiographerEnum.ItemAcquisitionMethod.Other, self.DisplayMinLevel, self.DisplayMaxLevel)
  local itemsOtherFs = content:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  topPoint = topPoint - 15
  itemsOtherFs:SetPoint("TOPLEFT", 10, topPoint)
  itemsOtherFs:SetText("Other Items Acquired: " .. HF.CommaValue(itemsOther) .. ".")
  
  -- Kills
  local killsHeaderFs = content:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
  topPoint = topPoint - 30
  killsHeaderFs:SetPoint("TOPLEFT", 10, topPoint)
  killsHeaderFs:SetText("Kills")
  
  local taggedKillingBlows = Controller:GetTaggedKillingBlows(self.DisplayMinLevel, self.DisplayMaxLevel)
  local taggedKillingBlowsFs = content:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  topPoint = topPoint - 20
  taggedKillingBlowsFs:SetPoint("TOPLEFT", 10, topPoint)
  taggedKillingBlowsFs:SetText("Tagged Killing Blows: " .. HF.CommaValue(taggedKillingBlows) .. ".")
  
  local otherTaggedKills = Controller:GetTaggedKills(self.DisplayMinLevel, self.DisplayMaxLevel) - taggedKillingBlows
  local otherTaggedKillsFs = content:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  topPoint = topPoint - 15
  otherTaggedKillsFs:SetPoint("TOPLEFT", 10, topPoint)
  otherTaggedKillsFs:SetText("Other Tagged Kills: " .. HF.CommaValue(otherTaggedKills) .. ".")

  -- Money
  local moneyHeaderFs = content:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
  topPoint = topPoint - 30
  moneyHeaderFs:SetPoint("TOPLEFT", 10, topPoint)
  moneyHeaderFs:SetText("Money")
  
  local moneyGainedFromAuctionHouseSales = Controller:GetMoneyForAcquisitionMethod(AutoBiographerEnum.MoneyAcquisitionMethod.AuctionHouseSale, self.DisplayMinLevel, self.DisplayMaxLevel)
  local moneyGainedFromAuctionHouseSalesFs = content:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  topPoint = topPoint - 20
  moneyGainedFromAuctionHouseSalesFs:SetPoint("TOPLEFT", 10, topPoint)
  moneyGainedFromAuctionHouseSalesFs:SetText("Money Gained from Auction House: " .. GetCoinText(moneyGainedFromAuctionHouseSales) .. ".")

  local moneyGainedFromLoot = Controller:GetMoneyForAcquisitionMethod(AutoBiographerEnum.MoneyAcquisitionMethod.Loot, self.DisplayMinLevel, self.DisplayMaxLevel)
  local moneyGainedFromLootFs = content:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  topPoint = topPoint - 15
  moneyGainedFromLootFs:SetPoint("TOPLEFT", 10, topPoint)
  moneyGainedFromLootFs:SetText("Money Looted: " .. GetCoinText(moneyGainedFromLoot) .. ".")
  
  local moneyGainedFromMail = Controller:GetMoneyForAcquisitionMethod(AutoBiographerEnum.MoneyAcquisitionMethod.Mail, self.DisplayMinLevel, self.DisplayMaxLevel)
  local moneyGainedFromMailFs = content:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  topPoint = topPoint - 15
  moneyGainedFromMailFs:SetPoint("TOPLEFT", 10, topPoint)
  moneyGainedFromMailFs:SetText("Money Gained From Mail (Direct): " .. GetCoinText(moneyGainedFromMail) .. ".")

  local moneyGainedFromMailCod = Controller:GetMoneyForAcquisitionMethod(AutoBiographerEnum.MoneyAcquisitionMethod.MailCod, self.DisplayMinLevel, self.DisplayMaxLevel)
  local moneyGainedFromMailCodFs = content:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  topPoint = topPoint - 15
  moneyGainedFromMailCodFs:SetPoint("TOPLEFT", 10, topPoint)
  moneyGainedFromMailCodFs:SetText("Money Gained From Mail (COD): " .. GetCoinText(moneyGainedFromMailCod) .. ".")

  local moneyGainedFromMerchants = Controller:GetMoneyForAcquisitionMethod(AutoBiographerEnum.MoneyAcquisitionMethod.Merchant, self.DisplayMinLevel, self.DisplayMaxLevel)
  local moneyGainedFromMerchantsFs = content:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  topPoint = topPoint - 15
  moneyGainedFromMerchantsFs:SetPoint("TOPLEFT", 10, topPoint)
  moneyGainedFromMerchantsFs:SetText("Money Gained From Merchants: " .. GetCoinText(moneyGainedFromMerchants) .. ".")
  
  local moneyGainedFromQuesting = Controller:GetMoneyForAcquisitionMethod(AutoBiographerEnum.MoneyAcquisitionMethod.Quest, self.DisplayMinLevel, self.DisplayMaxLevel)
  local moneyGainedFromQuestingFs = content:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  topPoint = topPoint - 15
  moneyGainedFromQuestingFs:SetPoint("TOPLEFT", 10, topPoint)
  moneyGainedFromQuestingFs:SetText("Money Gained From Quests: " .. GetCoinText(moneyGainedFromQuesting) .. ".")

  local moneyGainedFromTrade = Controller:GetMoneyForAcquisitionMethod(AutoBiographerEnum.MoneyAcquisitionMethod.Trade, self.DisplayMinLevel, self.DisplayMaxLevel)
  local moneyGainedFromTradeFs = content:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  topPoint = topPoint - 15
  moneyGainedFromTradeFs:SetPoint("TOPLEFT", 10, topPoint)
  moneyGainedFromTradeFs:SetText("Money Gained From Trade: " .. GetCoinText(moneyGainedFromTrade) .. ".")
  
  local moneyGainedFromAuctionHouseDepositReturns = Controller:GetMoneyForAcquisitionMethod(AutoBiographerEnum.MoneyAcquisitionMethod.AuctionHouseDepositReturn, self.DisplayMinLevel, self.DisplayMaxLevel)
  local moneyGainedFromAuctionHouseOutbids = Controller:GetMoneyForAcquisitionMethod(AutoBiographerEnum.MoneyAcquisitionMethod.AuctionHouseOutbid, self.DisplayMinLevel, self.DisplayMaxLevel)
  local moneyGainedFromOther = Controller:GetTotalMoneyGained(self.DisplayMinLevel, self.DisplayMaxLevel) - moneyGainedFromAuctionHouseDepositReturns -
    moneyGainedFromAuctionHouseOutbids - moneyGainedFromAuctionHouseSales - moneyGainedFromLoot - moneyGainedFromMail - moneyGainedFromMailCod - moneyGainedFromMerchants -
    moneyGainedFromQuesting - moneyGainedFromTrade
  if (moneyGainedFromOther < 0) then moneyGainedFromOther = 0 end -- This should not ever happen.
  local moneyOtherFs = content:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  topPoint = topPoint - 15
  moneyOtherFs:SetPoint("TOPLEFT", 10, topPoint)
  moneyOtherFs:SetText("Money Gained From Other Sources: " .. GetCoinText(moneyGainedFromOther) .. ".")
  
  -- Other Player Stats
  local otherPlayerHeaderFs = content:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
  topPoint = topPoint - 30
  otherPlayerHeaderFs:SetPoint("TOPLEFT", 10, topPoint)
  otherPlayerHeaderFs:SetText("Other Player")
  
  local duelsWon = Controller:GetOtherPlayerStatByOtherPlayerTrackingType(AutoBiographerEnum.OtherPlayerTrackingType.DuelsLostToPlayer, self.DisplayMinLevel, self.DisplayMaxLevel)
  local duelsWonFs = content:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  topPoint = topPoint - 15
  duelsWonFs:SetPoint("TOPLEFT", 10, topPoint)
  duelsWonFs:SetText("Duels Won: " .. HF.CommaValue(duelsWon) .. ".")
  
  local duelsLost = Controller:GetOtherPlayerStatByOtherPlayerTrackingType(AutoBiographerEnum.OtherPlayerTrackingType.DuelsWonAgainstPlayer, self.DisplayMinLevel, self.DisplayMaxLevel)
  local duelsLostFs = content:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  topPoint = topPoint - 15
  duelsLostFs:SetPoint("TOPLEFT", 10, topPoint)
  duelsLostFs:SetText("Duels Lost: " .. HF.CommaValue(duelsLost) .. ".")
  
  -- Spells
  local spellsHeaderFs = content:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
  topPoint = topPoint - 30
  spellsHeaderFs:SetPoint("TOPLEFT", 10, topPoint)
  spellsHeaderFs:SetText("Spells")
  
  local spellsStartedCasting = Controller:GetSpellCountBySpellTrackingType(AutoBiographerEnum.SpellTrackingType.StartedCasting, self.DisplayMinLevel, self.DisplayMaxLevel)
  local spellsStartedCastingFs = content:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  topPoint = topPoint - 20
  spellsStartedCastingFs:SetPoint("TOPLEFT", 10, topPoint)
  spellsStartedCastingFs:SetText("Spells Started Casting: " .. HF.CommaValue(spellsStartedCasting) .. ".")
  
  local spellsSuccessfullyCast = Controller:GetSpellCountBySpellTrackingType(AutoBiographerEnum.SpellTrackingType.SuccessfullyCast, self.DisplayMinLevel, self.DisplayMaxLevel)
  local spellsSuccessfullyCastFs = content:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  topPoint = topPoint - 15
  spellsSuccessfullyCastFs:SetPoint("TOPLEFT", 10, topPoint)
  spellsSuccessfullyCastFs:SetText("Spells Successfully Cast: " .. HF.CommaValue(spellsSuccessfullyCast) .. ".")
  
  -- Time
  local timeHeaderFs = content:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
  topPoint = topPoint - 30
  timeHeaderFs:SetPoint("TOPLEFT", 10, topPoint)
  timeHeaderFs:SetText("Time")
  
  local timeSpentAfk = Controller:GetTimeForTimeTrackingType(AutoBiographerEnum.TimeTrackingType.Afk, self.DisplayMinLevel, self.DisplayMaxLevel)
  local timeSpentAfkFs = content:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  topPoint = topPoint - 20
  timeSpentAfkFs:SetPoint("TOPLEFT", 10, topPoint)
  timeSpentAfkFs:SetText("Time Spent AFK: " .. HF.SecondsToTimeString(timeSpentAfk) .. ".")
  
  local timeSpentCasting = Controller:GetTimeForTimeTrackingType(AutoBiographerEnum.TimeTrackingType.Casting, self.DisplayMinLevel, self.DisplayMaxLevel)
  local timeSpentCastingFs = content:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  topPoint = topPoint - 15
  timeSpentCastingFs:SetPoint("TOPLEFT", 10, topPoint)
  timeSpentCastingFs:SetText("Time Spent Casting: " .. HF.SecondsToTimeString(timeSpentCasting) .. ".")
  
  local timeSpentDead = Controller:GetTimeForTimeTrackingType(AutoBiographerEnum.TimeTrackingType.DeadOrGhost, self.DisplayMinLevel, self.DisplayMaxLevel)
  local timeSpentDeadFs = content:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  topPoint = topPoint - 15
  timeSpentDeadFs:SetPoint("TOPLEFT", 10, topPoint)
  timeSpentDeadFs:SetText("Time Spent Dead: " .. HF.SecondsToTimeString(timeSpentDead) .. ".")
  
  local timeSpentInCombat = Controller:GetTimeForTimeTrackingType(AutoBiographerEnum.TimeTrackingType.InCombat, self.DisplayMinLevel, self.DisplayMaxLevel)
  local timeSpentInCombatFs = content:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  topPoint = topPoint - 15
  timeSpentInCombatFs:SetPoint("TOPLEFT", 10, topPoint)
  timeSpentInCombatFs:SetText("Time Spent in Combat: " .. HF.SecondsToTimeString(timeSpentInCombat) .. ".")
  
  local timeSpentInGroup = Controller:GetTimeForTimeTrackingType(AutoBiographerEnum.TimeTrackingType.InParty, self.DisplayMinLevel, self.DisplayMaxLevel)
  local timeSpentInGroupFs = content:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  topPoint = topPoint - 15
  timeSpentInGroupFs:SetPoint("TOPLEFT", 10, topPoint)
  timeSpentInGroupFs:SetText("Time Spent in Group: " .. HF.SecondsToTimeString(timeSpentInGroup) .. ".")
  
  local timeSpentLoggedIn = Controller:GetTimeForTimeTrackingType(AutoBiographerEnum.TimeTrackingType.LoggedIn, self.DisplayMinLevel, self.DisplayMaxLevel)
  local timeSpentLoggedInFs = content:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  topPoint = topPoint - 15
  timeSpentLoggedInFs:SetPoint("TOPLEFT", 10, topPoint)
  timeSpentLoggedInFs:SetText("Time Spent Logged In: " .. HF.SecondsToTimeString(timeSpentLoggedIn) .. ".")
  
  local timeSpentOnTaxi = Controller:GetTimeForTimeTrackingType(AutoBiographerEnum.TimeTrackingType.OnTaxi, self.DisplayMinLevel, self.DisplayMaxLevel)
  local timeSpentOnTaxiFs = content:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  topPoint = topPoint - 15
  timeSpentOnTaxiFs:SetPoint("TOPLEFT", 10, topPoint)
  timeSpentOnTaxiFs:SetText("Time Spent on Flights: " .. HF.SecondsToTimeString(timeSpentOnTaxi) .. ".")
  
  self.ScrollFrame.Content = content
  self.ScrollFrame:SetScrollChild(content)
end