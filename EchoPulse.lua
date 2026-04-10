--[[
	EchoPulse
	Author : LenweSaralonde
	Updated to v2.1.1 by Gemini
]]

local GetAddOnMetadata = C_AddOns and C_AddOns.GetAddOnMetadata or GetAddOnMetadata

-- ===========================================
-- Main code functions
-- ===========================================

local MAX_RATE = 10
local isPulseActive = false
local entryTimers = {} -- Transient timers for each entry

-- ===========================================
-- Internal Message Queue Logic
-- ===========================================
local EP_queue = {}
local EP_queueFrame
local EP_flashTimer
local globalMessageDelay = 0

local function EP_FlashClientIcon() 
	if FlashClientIcon then FlashClientIcon() end 
end

local SendChatMessage = (C_ChatInfo and C_ChatInfo.SendChatMessage or SendChatMessage)

local function EP_RunQueue()
	if EP_flashTimer then
		EP_flashTimer:Cancel()
	end
	if #EP_queue > 0 then
		local func = table.remove(EP_queue, 1)
		xpcall(func, geterrorhandler())
	end
	if #EP_queue == 0 and EP_queueFrame then
		EP_queueFrame:Hide()
	end
end

local function EP_Enqueue(f)
	table.insert(EP_queue, f)
	if EP_flashTimer then
		EP_flashTimer:Cancel()
	end
	EP_flashTimer = C_Timer.NewTimer(.25, EP_FlashClientIcon)
end

local function EP_SendChatMessage(msg, chatType, languageID, channel, callback)
	local function doSend()
		if channel then
			SendChatMessage(msg, chatType, languageID, channel)
		elseif languageID then
			SendChatMessage(msg, chatType, languageID)
		else
			SendChatMessage(msg, chatType)
		end
		if callback then
			callback()
		end
	end

	if chatType == 'CHANNEL' or chatType == 'SAY' or chatType == 'YELL' then
		EP_Enqueue(doSend)
	else
		doSend()
	end
end

local function EP_InitQueue()
	if EP_queueFrame then return end
	
	EP_queueFrame = CreateFrame('Frame', 'EchoPulseQueueFrame', UIParent)
	EP_queueFrame:SetPoint('TOPLEFT')
	EP_queueFrame:SetPoint('BOTTOMRIGHT')
	EP_queueFrame:Hide()

	EP_queueFrame:EnableMouse(true)
	EP_queueFrame:EnableMouseWheel(true)
	EP_queueFrame:SetMouseMotionEnabled(true)
	if EP_queueFrame.EnableGamePadButton then EP_queueFrame:EnableGamePadButton(true) end
	if EP_queueFrame.EnableGamePadStick then EP_queueFrame:EnableGamePadStick(true) end
	EP_queueFrame:EnableKeyboard(true)
	EP_queueFrame:SetPropagateKeyboardInput(true)

	EP_queueFrame:SetScript("OnMouseDown", EP_RunQueue)
	EP_queueFrame:SetScript("OnMouseUp", EP_RunQueue)
	EP_queueFrame:SetScript("OnMouseWheel", EP_RunQueue)
	EP_queueFrame:SetScript("OnGamePadButtonDown", EP_RunQueue)
	EP_queueFrame:SetScript("OnGamePadButtonUp", EP_RunQueue)
	EP_queueFrame:SetScript("OnGamePadStick", EP_RunQueue)
	EP_queueFrame:SetScript("OnKeyDown", EP_RunQueue)
	EP_queueFrame:SetScript("OnKeyUp", EP_RunQueue)
end

--- Main script initialization
function EchoPulse_OnLoad()
	EchoPulse_Frame:RegisterEvent("VARIABLES_LOADED")
	EchoPulse_Frame:SetScript("OnEvent", EchoPulse_OnEvent)
	EchoPulse_Frame:SetScript("OnUpdate", EchoPulse_OnUpdate)
	
	EP_InitQueue()
	
	-- Slash commands
	SlashCmdList["ECHOPULSE"] = function(s)
		if s == "on" then EchoPulse_On()
		elseif s == "off" then EchoPulse_Off()
		else
			if isPulseActive then EchoPulse_Off() else EchoPulse_On() end
		end
	end
	SLASH_ECHOPULSE1 = "/pulse"

	SlashCmdList["ECHOPULSECONFIG"] = function()
		if EchoPulse_Category then
			Settings.OpenToCategory(EchoPulse_Category:GetID())
		else
			-- Fallback for older versions or if ID not available
			InterfaceOptionsFrame_OpenToCategory("EchoPulse")
		end
	end
	SLASH_ECHOPULSECONFIG1 = "/pulseconfig"
	SLASH_ECHOPULSECONFIG2 = "/pulsemenu"

	-- Backward compatibility or quick set first entry
	SlashCmdList["ECHOPULSESETMESSAGE"] = function(msg)
		if EP_characterConfig.entries[1] then
			EP_characterConfig.entries[1].message = msg
			EchoPulse_Info()
		end
	end
	SLASH_ECHOPULSESETMESSAGE1 = "/pulsemessage"
	SLASH_ECHOPULSESETMESSAGE2 = "/pulsemsg"

	-- Help
	SlashCmdList["ECHOPULSEHELP"] = function()
		for _, l in pairs(ECHOPULSE_HELP) do
			DEFAULT_CHAT_FRAME:AddMessage(l, 1, 1, 1)
		end
	end
	SLASH_ECHOPULSEHELP1 = "/pulsehelp"
end

--- Event handler function
function EchoPulse_OnEvent(self, event)
	if event == "VARIABLES_LOADED" then
		local version = GetAddOnMetadata("EchoPulse", "Version")

		-- Migration and Init
		if not EP_characterConfig then
			EP_characterConfig = {}
		end
		if not EP_characterConfig.entries then
			EP_characterConfig.entries = {}
		end

		-- Migrate from v1.7.0 (channels table)
		if EP_characterConfig.channels and not EP_characterConfig.entries then
			EP_characterConfig.entries = {}
			for _, chan in ipairs(EP_characterConfig.channels) do
				table.insert(EP_characterConfig.entries, {
					enabled = true,
					message = EP_characterConfig.message or ("EchoPulse " .. version),
					channel = chan,
					rate = EP_characterConfig.rate or 60
				})
			end
			EP_characterConfig.channels = nil
			EP_characterConfig.message = nil
			EP_characterConfig.rate = nil
		end

		-- If still empty (new install)
		if #EP_characterConfig.entries == 0 then
			table.insert(EP_characterConfig.entries, {
				enabled = true,
				message = "EchoPulse " .. version,
				channel = "say",
				rate = 60,
				cityOnly = false
			})
		end

		if EP_characterConfig.smartPauseCombat == nil then
			EP_characterConfig.smartPauseCombat = true
		end
		if EP_characterConfig.smartPauseInstance == nil then
			EP_characterConfig.smartPauseInstance = true
		end
		if EP_characterConfig.smartPauseAFK == nil then
			EP_characterConfig.smartPauseAFK = true
		end
		if EP_characterConfig.smartRNG == nil then
			EP_characterConfig.smartRNG = false
		end
		if EP_characterConfig.smartRNGVariance == nil then
			EP_characterConfig.smartRNGVariance = 5
		end

		-- Register Options Panel
		EchoPulse_CreateOptionsPanel()

		local s = string.gsub(ECHOPULSE_LOAD, "VERSION", version)
		DEFAULT_CHAT_FRAME:AddMessage(s, 1, 1, 1)
	end
end

function EchoPulse_On()
	isPulseActive = true
	DEFAULT_CHAT_FRAME:AddMessage(ECHOPULSE_ACTIVE, 1, 1, 1)
	-- Reset timers to trig immediately
	-- Reset timers and pre-calculate first randomized targets
	for i, entry in ipairs(EP_characterConfig.entries) do
		entryTimers[i] = entry.rate
		entry.nextTargetRate = entry.rate
	end
	if EchoPulseOptionsPanel and EchoPulseOptionsPanel.refreshToggle then
		EchoPulseOptionsPanel.refreshToggle()
	end
end

function EchoPulse_Off()
	isPulseActive = false
	DEFAULT_CHAT_FRAME:AddMessage(ECHOPULSE_INACTIVE, 1, 1, 1)
	if EchoPulseOptionsPanel and EchoPulseOptionsPanel.refreshToggle then
		EchoPulseOptionsPanel.refreshToggle()
	end
end

function EchoPulse_OnUpdate(self, elapsed)
	if not isPulseActive then return end
	
	-- Update queue frame visibility FIRST so we never get stuck in combat with a visible frame
	if #EP_queue > 0 then
		EP_queueFrame:SetFrameStrata('TOOLTIP')
		EP_queueFrame:SetFrameLevel(UIParent:GetFrameLevel() + 1000)
		EP_queueFrame:Show()
		return
	else
		EP_queueFrame:Hide()
	end
	
	if globalMessageDelay > 0 then
		globalMessageDelay = globalMessageDelay - elapsed
		return
	end

	-- Smart Pauses
	if EP_characterConfig.smartPauseCombat and UnitAffectingCombat("player") then return end
	if EP_characterConfig.smartPauseInstance then
		local inInstance, instanceType = IsInInstance()
		if inInstance and (instanceType == "party" or instanceType == "raid" or instanceType == "arena") then return end
	end
	if EP_characterConfig.smartPauseAFK and UnitIsAFK("player") then return end

	for i, entry in ipairs(EP_characterConfig.entries) do
		if entry.enabled then
			entryTimers[i] = (entryTimers[i] or 0) + elapsed
			
			-- Generate target rate just in time if missing
			if not entry.nextTargetRate then
				entry.nextTargetRate = entry.rate or 60
			end

			if entryTimers[i] >= entry.nextTargetRate then
				if not entry.cityOnly or IsResting() then
					local system, channelNumber = EchoPulse_GetChannel(entry.channel)
					if system then
						EP_SendChatMessage(entry.message, system, nil, channelNumber)
					end
				end
				entryTimers[i] = 0

				-- Calculate next cycle rate with RNG
				local baseRate = entry.rate or 60
				if EP_characterConfig.smartRNG and EP_characterConfig.smartRNGVariance then
					local var = tonumber(EP_characterConfig.smartRNGVariance) or 0
					if var > baseRate - 1 then var = baseRate - 1 end -- Prevent negative rates
					if var > 0 then
						entry.nextTargetRate = baseRate + math.random(-var, var)
					else
						entry.nextTargetRate = baseRate
					end
				else
					entry.nextTargetRate = baseRate
				end
				
				globalMessageDelay = 1.5
				break
			end
		end
	end
end

function EchoPulse_Info()
	if isPulseActive then
		DEFAULT_CHAT_FRAME:AddMessage(ECHOPULSE_ACTIVE, 1, 1, 1)
	else
		DEFAULT_CHAT_FRAME:AddMessage(ECHOPULSE_INACTIVE, 1, 1, 1)
	end

	for i, entry in ipairs(EP_characterConfig.entries) do
		local status = entry.enabled and "|cff00ff00[ON]|r" or "|cffff0000[OFF]|r"
		local s = string.format("%d. %s [%s] (%ds): %s", i, status, entry.channel, entry.rate, entry.message)
		DEFAULT_CHAT_FRAME:AddMessage(s, 1, 1, 1)
	end
end

function EchoPulse_GetChannel(channel)
	if not channel then return nil end
	local ch = strlower(strtrim(channel))
	if ch == "say" or ch == "s" then return "SAY", nil, ch
	elseif ch == "guild" or ch == "g" then return "GUILD", nil, ch
	elseif ch == "raid" or ch == "ra" then return "RAID", nil, ch
	elseif ch == "party" or ch == "p" or ch == "gr" then return "PARTY", nil, ch
	elseif ch == "i" then return "INSTANCE_CHAT", nil, ch
	elseif ch == "bg" then return "BATTLEGROUND", nil, ch
	elseif GetChannelName(channel) ~= 0 then return "CHANNEL", (GetChannelName(channel)), channel
	end
	return nil, nil, nil
end

-- ===========================================
-- GUI Options Panel
-- ===========================================

function EchoPulse_CreateOptionsPanel()
	local panel = CreateFrame("Frame", "EchoPulseOptionsPanel", UIParent)
	panel.name = "EchoPulse"
	
	local title = panel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	title:SetPoint("TOPLEFT", 16, -16)
	title:SetText(ECHOPULSE_CONFIG_TITLE)

	local desc = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	desc:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)
	desc:SetText(ECHOPULSE_CONFIG_DESC)

	-- Smart Pauses
	local combatCheck = CreateFrame("CheckButton", nil, panel, "UICheckButtonTemplate")
	combatCheck:SetSize(24, 24)
	combatCheck:SetPoint("TOPLEFT", desc, "BOTTOMLEFT", -5, -10)
	combatCheck.text = combatCheck:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	combatCheck.text:SetPoint("LEFT", combatCheck, "RIGHT", 0, 1)
	combatCheck.text:SetText(ECHOPULSE_OPT_COMBAT)
	combatCheck.tooltipText = ECHOPULSE_TIP_COMBAT
	combatCheck:SetScript("OnClick", function(self) EP_characterConfig.smartPauseCombat = self:GetChecked() end)
	combatCheck:SetScript("OnEnter", function(self)
		if self.tooltipText then
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			GameTooltip:SetText(self.tooltipText, nil, nil, nil, nil, true)
			GameTooltip:Show()
		end
	end)
	combatCheck:SetScript("OnLeave", function(self) GameTooltip:Hide() end)

	local instanceCheck = CreateFrame("CheckButton", nil, panel, "UICheckButtonTemplate")
	instanceCheck:SetSize(24, 24)
	instanceCheck:SetPoint("LEFT", combatCheck.text, "RIGHT", 20, 0)
	instanceCheck.text = instanceCheck:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	instanceCheck.text:SetPoint("LEFT", instanceCheck, "RIGHT", 0, 1)
	instanceCheck.text:SetText(ECHOPULSE_OPT_INSTANCE)
	instanceCheck.tooltipText = ECHOPULSE_TIP_INSTANCE
	instanceCheck:SetScript("OnClick", function(self) EP_characterConfig.smartPauseInstance = self:GetChecked() end)
	instanceCheck:SetScript("OnEnter", function(self)
		if self.tooltipText then
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			GameTooltip:SetText(self.tooltipText, nil, nil, nil, nil, true)
			GameTooltip:Show()
		end
	end)
	instanceCheck:SetScript("OnLeave", function(self) GameTooltip:Hide() end)

	local afkCheck = CreateFrame("CheckButton", nil, panel, "UICheckButtonTemplate")
	afkCheck:SetSize(24, 24)
	afkCheck:SetPoint("LEFT", instanceCheck.text, "RIGHT", 20, 0)
	afkCheck.text = afkCheck:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	afkCheck.text:SetPoint("LEFT", afkCheck, "RIGHT", 0, 1)
	afkCheck.text:SetText(ECHOPULSE_OPT_AFK)
	afkCheck.tooltipText = ECHOPULSE_TIP_AFK
	afkCheck:SetScript("OnClick", function(self) EP_characterConfig.smartPauseAFK = self:GetChecked() end)
	afkCheck:SetScript("OnEnter", function(self)
		if self.tooltipText then
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			GameTooltip:SetText(self.tooltipText, nil, nil, nil, nil, true)
			GameTooltip:Show()
		end
	end)
	afkCheck:SetScript("OnLeave", function(self) GameTooltip:Hide() end)

	local rngCheck = CreateFrame("CheckButton", nil, panel, "UICheckButtonTemplate")
	rngCheck:SetSize(24, 24)
	rngCheck:SetPoint("LEFT", afkCheck.text, "RIGHT", 20, 0)
	rngCheck.text = rngCheck:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	rngCheck.text:SetPoint("LEFT", rngCheck, "RIGHT", 0, 1)
	rngCheck.text:SetText(ECHOPULSE_OPT_RNG)
	rngCheck.tooltipText = ECHOPULSE_TIP_RNG
	rngCheck:SetScript("OnEnter", function(self)
		if self.tooltipText then
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			GameTooltip:SetText(self.tooltipText, nil, nil, nil, nil, true)
			GameTooltip:Show()
		end
	end)
	rngCheck:SetScript("OnLeave", function(self) GameTooltip:Hide() end)

	local rngVar = CreateFrame("EditBox", nil, panel, "InputBoxTemplate")
	rngVar:SetSize(30, 20)
	rngVar:SetPoint("LEFT", rngCheck.text, "RIGHT", 10, 0)
	rngVar:SetAutoFocus(false)
	rngVar:SetNumeric(true)
	rngVar:SetMaxLetters(2)
	rngVar:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:SetText(ECHOPULSE_TIP_VARIANCE, nil, nil, nil, nil, true)
		GameTooltip:Show()
	end)
	rngVar:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
	rngVar:SetScript("OnTextChanged", function(self)
		local v = tonumber(self:GetText()) or 0
		if v > 60 then v = 60; self:SetText("60") end
		EP_characterConfig.smartRNGVariance = v
	end)

	local function UpdateRNGState()
		local isRNG = rngCheck:GetChecked()
		EP_characterConfig.smartRNG = isRNG
		if isRNG then
			rngVar:Enable()
			rngVar:SetAlpha(1.0)
		else
			rngVar:Disable()
			rngVar:SetAlpha(0.5)
		end
	end
	rngCheck:SetScript("OnClick", UpdateRNGState)

	-- Headers
	local hOn = panel:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
	hOn:SetPoint("TOPLEFT", combatCheck, "BOTTOMLEFT", 5, -10)
	hOn:SetText(ECHOPULSE_COL_ACTIVE)
	
	local hChan = panel:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
	hChan:SetPoint("LEFT", hOn, "LEFT", 30, 0)
	hChan:SetText(ECHOPULSE_COL_CHAN)

	local hMsg = panel:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
	hMsg:SetPoint("LEFT", hOn, "LEFT", 95, 0)
	hMsg:SetText(ECHOPULSE_COL_MSG)

	local hCity = panel:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
	hCity:SetPoint("RIGHT", panel, "RIGHT", -115, 0)
	hCity:SetPoint("TOP", hOn, "TOP", 0, 0)
	hCity:SetText(ECHOPULSE_COL_CITY)

	local hRate = panel:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
	hRate:SetPoint("RIGHT", panel, "RIGHT", -55, 0)
	hRate:SetPoint("TOP", hOn, "TOP", 0, 0)
	hRate:SetText(ECHOPULSE_COL_RATE)

	-- ScrollFrame Container
	local scrollFrame = CreateFrame("ScrollFrame", "EchoPulseScrollFrame", panel, "UIPanelScrollFrameTemplate")
	scrollFrame:SetPoint("TOPLEFT", hOn, "BOTTOMLEFT", 0, -10)
	scrollFrame:SetPoint("BOTTOMRIGHT", -30, 50)

	local content = CreateFrame("Frame", "EchoPulseScrollContent", scrollFrame)
	content:SetSize(scrollFrame:GetWidth() > 0 and scrollFrame:GetWidth() or 600, 500)
	content:SetPoint("TOPLEFT")
	scrollFrame:SetScrollChild(content)

	local rows = {}

	local function RefreshRows()
		for _, row in pairs(rows) do row:Hide() end
		
		local yOffset = 0
		for i, entry in ipairs(EP_characterConfig.entries) do
			local row = rows[i]
			if not row then
				row = CreateFrame("Frame", nil, content)
				row:SetHeight(30)
				row:SetPoint("LEFT", 0, 0)
				row:SetPoint("RIGHT", 0, 0)
				
				-- Checkbox
				row.check = CreateFrame("CheckButton", nil, row, "UICheckButtonTemplate")
				row.check:SetSize(24, 24)
				row.check:SetPoint("LEFT", 0, 0)
				
				-- Channel
				row.chan = CreateFrame("EditBox", nil, row, "InputBoxTemplate")
				row.chan:SetSize(60, 20)
				row.chan:SetPoint("LEFT", 30, 0)
				row.chan:SetAutoFocus(false)
				
				-- Message
				row.msg = CreateFrame("EditBox", nil, row, "InputBoxTemplate")
				row.msg:SetHeight(20)
				row.msg:SetPoint("LEFT", 95, 0)
				row.msg:SetPoint("RIGHT", -150, 0)
				row.msg:SetAutoFocus(false)
				
				-- City Only Checkbox
				row.cityCheck = CreateFrame("CheckButton", nil, row, "UICheckButtonTemplate")
				row.cityCheck:SetSize(24, 24)
				row.cityCheck:SetPoint("RIGHT", -110, 0)
				row.cityCheck.tooltipText = ECHOPULSE_TIP_CITY
				row.cityCheck:SetScript("OnEnter", function(self)
					if self.tooltipText then
						GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
						GameTooltip:SetText(self.tooltipText, nil, nil, nil, nil, true)
						GameTooltip:Show()
					end
				end)
				row.cityCheck:SetScript("OnLeave", function(self) GameTooltip:Hide() end)

				-- Rate
				row.rate = CreateFrame("EditBox", nil, row, "InputBoxTemplate")
				row.rate:SetSize(40, 20)
				row.rate:SetPoint("RIGHT", -55, 0)
				row.rate:SetAutoFocus(false)
				row.rate:SetNumeric(true)
				
				-- Delete
				row.del = CreateFrame("Button", nil, row, "UIPanelButtonTemplate")
				row.del:SetSize(50, 20)
				row.del:SetPoint("RIGHT", 0, 0)
				row.del:SetText(ECHOPULSE_DELETE)
				
				rows[i] = row
			end
			
			row:SetPoint("TOPLEFT", 0, yOffset)
			row:Show()

			-- Set values
			row.check:SetScript("OnClick", nil)
			row.check:SetChecked(entry.enabled)
			row.check:SetScript("OnClick", function(self) entry.enabled = self:GetChecked() end)
			
			row.chan:SetScript("OnTextChanged", nil)
			row.chan:SetText(entry.channel or "")
			row.chan:SetScript("OnTextChanged", function(self, isUserInput) 
				if isUserInput then entry.channel = self:GetText() end 
			end)
			
			row.msg:SetScript("OnTextChanged", nil)
			row.msg:SetText(entry.message or "")
			row.msg:SetScript("OnTextChanged", function(self, isUserInput) 
				if isUserInput then entry.message = self:GetText() end 
			end)
			
			row.cityCheck:SetScript("OnClick", nil)
			row.cityCheck:SetChecked(entry.cityOnly)
			row.cityCheck:SetScript("OnClick", function(self) entry.cityOnly = self:GetChecked() end)

			row.rate:SetScript("OnTextChanged", nil)
			row.rate:SetText(tostring(entry.rate or 60))
			row.rate:SetScript("OnTextChanged", function(self, isUserInput) 
				if isUserInput then
					local r = tonumber(self:GetText()) or 10
					if r < MAX_RATE then r = MAX_RATE end
					entry.rate = r 
				end
			end)
			
			row.del:SetScript("OnClick", function()
				table.remove(EP_characterConfig.entries, i)
				RefreshRows()
			end)
			
			yOffset = yOffset - 35
		end
		content:SetHeight(math.abs(yOffset) + 50)
	end

	panel:SetScript("OnShow", function()
		if combatCheck then combatCheck:SetChecked(EP_characterConfig.smartPauseCombat) end
		if instanceCheck then instanceCheck:SetChecked(EP_characterConfig.smartPauseInstance) end
		if afkCheck then afkCheck:SetChecked(EP_characterConfig.smartPauseAFK) end
		if rngCheck then 
			rngCheck:SetChecked(EP_characterConfig.smartRNG)
			UpdateRNGState()
		end
		if rngVar then rngVar:SetText(tostring(EP_characterConfig.smartRNGVariance or 5)) end
		content:SetWidth(scrollFrame:GetWidth() - 20)
		RefreshRows()
	end)
	-- Add Button
	local addBtn = CreateFrame("Button", nil, panel, "UIPanelButtonTemplate")
	addBtn:SetSize(120, 25)
	addBtn:SetPoint("BOTTOMLEFT", 16, 16)
	addBtn:SetText(ECHOPULSE_ADD)
	addBtn:SetScript("OnClick", function()
		table.insert(EP_characterConfig.entries, {
			enabled = true,
			message = "New Message",
			channel = "say",
			rate = 60,
			cityOnly = false
		})
		RefreshRows()
	end)

	-- Toggle Button (Start/Stop)
	local toggleBtn = CreateFrame("Button", nil, panel, "UIPanelButtonTemplate")
	toggleBtn:SetSize(120, 25)
	toggleBtn:SetPoint("BOTTOMLEFT", addBtn, "BOTTOMRIGHT", 10, 0)
	
	local function UpdateToggleBtn()
		if isPulseActive then
			toggleBtn:SetText("|cffff0000" .. "Desactivar EchoPulse" .. "|r")
		else
			toggleBtn:SetText("|cff00ff00" .. "Activar EchoPulse" .. "|r")
		end
	end
	
	toggleBtn:SetScript("OnClick", function()
		if isPulseActive then EchoPulse_Off() else EchoPulse_On() end
		UpdateToggleBtn()
	end)
	
	panel.refreshToggle = UpdateToggleBtn
	UpdateToggleBtn()

	panel.refresh = RefreshRows
	
	-- Register
	if Settings and Settings.RegisterAddOnCategory then
		local category = Settings.RegisterCanvasLayoutCategory(panel, panel.name)
		Settings.RegisterAddOnCategory(category)
		EchoPulse_Category = category
	else
		InterfaceOptions_AddCategory(panel)
	end
end
