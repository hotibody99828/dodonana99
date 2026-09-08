-- ==================================================
-- TABS (SEA3) + SMART CHECKBOX
-- ==================================================

local Y = _G.Y
local Services = _G.YOKUDO.Services
local Settings = _G.YOKUDO

-- Create Pages
local InfoPage = CreatePage("INFO")
local ShopPage = CreatePage("SHOP")
local AutoHopPage = CreatePage("AUTO_HOP")
local NearMoonPage = CreatePage("NEAR_MOON")
local FullMoonPage = CreatePage("FULL_MOON")
local DoughKingPage = CreatePage("DOUGH_KING")
local RipIndraPage = CreatePage("RIP_INDRA")
local CakePrincePage = CreatePage("CAKE_PRINCE")
local CakeQueenPage = CreatePage("CAKE_QUEEN")
local EliteHunterPage = CreatePage("ELITE_HUNTER")
local SoulReaperPage = CreatePage("SOUL_REAPER")
local PirateRaidPage = CreatePage("PIRATE_RAID")
local TyrantSkiesPage = CreatePage("TYRANT_SKIES")
local MirageIslandPage = CreatePage("MIRAGE_ISLAND")
local PrehistoricIslandPage = CreatePage("PREHISTORIC_ISLAND")
local KitsuneIslandPage = CreatePage("KITSUNE_ISLAND")
local HakiLegendaryPage = CreatePage("HAKI_LEGENDARY")
local FruitPage = CreatePage("FRUIT")
local BerryPage = CreatePage("BERRY")
local SettingPage = CreatePage("SETTING")

-- Create Tabs
local InfoTab = CreateTab("Info", 1)
local ShopTab = CreateTab("Shop", 2)
local AutoHopTab = CreateTab("Auto Hop", 3)
local NearMoonTab = CreateTab("Near Moon", 4)
local FullMoonTab = CreateTab("Full Moon", 5)
local DoughKingTab = CreateTab("Dough King", 6)
local RipIndraTab = CreateTab("Rip indra", 7)
local CakePrinceTab = CreateTab("Cake Prince", 8)
local CakeQueenTab = CreateTab("Cake Queen", 9)
local EliteHunterTab = CreateTab("Elite Hunter", 10)
local SoulReaperTab = CreateTab("Soul Reaper", 11)
local PirateRaidTab = CreateTab("Pirate Raid", 12)
local TyrantSkiesTab = CreateTab("tyrant of the skies", 13)
local MirageIslandTab = CreateTab("Mirage Island", 14)
local PrehistoricIslandTab = CreateTab("Prehistoric Island", 15)
local KitsuneIslandTab = CreateTab("Kitsune Island", 16)
local HakiLegendaryTab = CreateTab("Haki Legendary", 17)
local FruitTab = CreateTab("Fruit", 18)
local BerryTab = CreateTab("Berry", 19)
local SettingTab = CreateTab("Setting", 20)

-- Tab Map
local Tabs = {
    [InfoTab] = InfoPage,
    [ShopTab] = ShopPage,
    [AutoHopTab] = AutoHopPage,
    [NearMoonTab] = NearMoonPage,
    [FullMoonTab] = FullMoonPage,
    [DoughKingTab] = DoughKingPage,
    [RipIndraTab] = RipIndraPage,
    [CakePrinceTab] = CakePrincePage,
    [CakeQueenTab] = CakeQueenPage,
    [EliteHunterTab] = EliteHunterPage,
    [SoulReaperTab] = SoulReaperPage,
    [PirateRaidTab] = PirateRaidPage,
    [TyrantSkiesTab] = TyrantSkiesPage,
    [MirageIslandTab] = MirageIslandPage,
    [PrehistoricIslandTab] = PrehistoricIslandPage,
    [KitsuneIslandTab] = KitsuneIslandPage,
    [HakiLegendaryTab] = HakiLegendaryPage,
    [FruitTab] = FruitPage,
    [BerryTab] = BerryPage,
    [SettingTab] = SettingPage
}

local function SelectTab(SelectedTab, SelectedPage)
    for Tab, Page in pairs(Tabs) do
        Page.Visible = false
        local Indicator = Tab:FindFirstChild("Indicator")
        local TabText = Tab:FindFirstChild("TabText")
        Y.TS:Create(Tab, TweenInfo.new(0.15), {BackgroundTransparency = 1}):Play()
        if Indicator then
            Y.TS:Create(Indicator, TweenInfo.new(0.15), {BackgroundTransparency = 1}):Play()
        end
        if TabText then
            Y.TS:Create(TabText, TweenInfo.new(0.15), {TextColor3 = Color3.fromRGB(155, 155, 175)}):Play()
        end
    end

    SelectedPage.Visible = true
    task.wait(0.05)
    pcall(function()
        SelectedPage.CanvasPosition = Vector2.new(0, 0)
    end)

    Y.TS:Create(SelectedTab, TweenInfo.new(0.15), {BackgroundTransparency = 0}):Play()
    local Indicator = SelectedTab:FindFirstChild("Indicator")
    local TabText = SelectedTab:FindFirstChild("TabText")
    if Indicator then
        Y.TS:Create(Indicator, TweenInfo.new(0.15), {BackgroundTransparency = 0}):Play()
    end
    if TabText then
        Y.TS:Create(TabText, TweenInfo.new(0.15), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
    end
end

for Tab, Page in pairs(Tabs) do
    Tab.MouseButton1Click:Connect(function()
        SelectTab(Tab, Page)
    end)
end

SelectTab(InfoTab, InfoPage)

-- ==================================================
-- ⭐ INFO TAB (NO COLOR - FAST LOAD)
-- ==================================================

-- Title
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Size = UDim2.new(1, -20, 0, 40)
titleLabel.Position = UDim2.new(0, 10, 0, 10)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "YOKUDO HUB PREMIUM"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 20
titleLabel.TextXAlignment = Enum.TextXAlignment.Center
titleLabel.TextYAlignment = Enum.TextYAlignment.Center
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Parent = InfoPage

-- Line
local line = Instance.new("Frame")
line.Name = "Line"
line.Size = UDim2.new(0.9, 0, 0, 1)
line.Position = UDim2.new(0.05, 0, 0, 55)
line.BackgroundColor3 = Color3.fromRGB(100, 100, 120)
line.BorderSizePixel = 0
line.Parent = InfoPage

-- Telegram Group
local tgLabel = Instance.new("TextLabel")
tgLabel.Name = "TgLabel"
tgLabel.Size = UDim2.new(1, -20, 0, 22)
tgLabel.Position = UDim2.new(0, 10, 0, 72)
tgLabel.BackgroundTransparency = 1
tgLabel.Text = "Telegram Group :"
tgLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
tgLabel.TextSize = 13
tgLabel.TextXAlignment = Enum.TextXAlignment.Left
tgLabel.TextYAlignment = Enum.TextYAlignment.Center
tgLabel.Font = Enum.Font.GothamBold
tgLabel.Parent = InfoPage

local tgLink = Instance.new("TextLabel")
tgLink.Name = "TgLink"
tgLink.Size = UDim2.new(1, -20, 0, 22)
tgLink.Position = UDim2.new(0, 10, 0, 94)
tgLink.BackgroundTransparency = 1
tgLink.Text = "https://t.me/mailay20"
tgLink.TextColor3 = Color3.fromRGB(200, 200, 220)
tgLink.TextSize = 12
tgLink.TextXAlignment = Enum.TextXAlignment.Left
tgLink.TextYAlignment = Enum.TextYAlignment.Center
tgLink.Font = Enum.Font.Gotham
tgLink.Parent = InfoPage

-- Discord Group
local dcLabel = Instance.new("TextLabel")
dcLabel.Name = "DcLabel"
dcLabel.Size = UDim2.new(1, -20, 0, 22)
dcLabel.Position = UDim2.new(0, 10, 0, 126)
dcLabel.BackgroundTransparency = 1
dcLabel.Text = "Discord Group :"
dcLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
dcLabel.TextSize = 13
dcLabel.TextXAlignment = Enum.TextXAlignment.Left
dcLabel.TextYAlignment = Enum.TextYAlignment.Center
dcLabel.Font = Enum.Font.GothamBold
dcLabel.Parent = InfoPage

local dcLink = Instance.new("TextLabel")
dcLink.Name = "DcLink"
dcLink.Size = UDim2.new(1, -20, 0, 22)
dcLink.Position = UDim2.new(0, 10, 0, 148)
dcLink.BackgroundTransparency = 1
dcLink.Text = "https://discord.gg/2XbN7M5Vem"
dcLink.TextColor3 = Color3.fromRGB(200, 200, 220)
dcLink.TextSize = 12
dcLink.TextXAlignment = Enum.TextXAlignment.Left
dcLink.TextYAlignment = Enum.TextYAlignment.Center
dcLink.Font = Enum.Font.Gotham
dcLink.Parent = InfoPage

-- Telegram User
local tgUserLabel = Instance.new("TextLabel")
tgUserLabel.Name = "TgUserLabel"
tgUserLabel.Size = UDim2.new(1, -20, 0, 22)
tgUserLabel.Position = UDim2.new(0, 10, 0, 180)
tgUserLabel.BackgroundTransparency = 1
tgUserLabel.Text = "Telegram :"
tgUserLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
tgUserLabel.TextSize = 13
tgUserLabel.TextXAlignment = Enum.TextXAlignment.Left
tgUserLabel.TextYAlignment = Enum.TextYAlignment.Center
tgUserLabel.Font = Enum.Font.GothamBold
tgUserLabel.Parent = InfoPage

local tgUserLink = Instance.new("TextLabel")
tgUserLink.Name = "TgUserLink"
tgUserLink.Size = UDim2.new(1, -20, 0, 22)
tgUserLink.Position = UDim2.new(0, 10, 0, 202)
tgUserLink.BackgroundTransparency = 1
tgUserLink.Text = "@maibigber"
tgUserLink.TextColor3 = Color3.fromRGB(200, 200, 220)
tgUserLink.TextSize = 12
tgUserLink.TextXAlignment = Enum.TextXAlignment.Left
tgUserLink.TextYAlignment = Enum.TextYAlignment.Center
tgUserLink.Font = Enum.Font.Gotham
tgUserLink.Parent = InfoPage

-- Build By
local buildLabel = Instance.new("TextLabel")
buildLabel.Name = "BuildLabel"
buildLabel.Size = UDim2.new(1, -20, 0, 30)
buildLabel.Position = UDim2.new(0, 10, 0, 240)
buildLabel.BackgroundTransparency = 1
buildLabel.Text = "Build By : Kon Khmer 🇰🇭"
buildLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
buildLabel.TextSize = 13
buildLabel.TextXAlignment = Enum.TextXAlignment.Center
buildLabel.TextYAlignment = Enum.TextYAlignment.Center
buildLabel.Font = Enum.Font.GothamBold
buildLabel.Parent = InfoPage

-- ==================================================
-- REFRESH BUTTONS
-- ==================================================
CreateRefreshButton(NearMoonPage, 1)
CreateRefreshButton(FullMoonPage, 1)
CreateRefreshButton(DoughKingPage, 1)
CreateRefreshButton(RipIndraPage, 1)
CreateRefreshButton(CakePrincePage, 1)
CreateRefreshButton(CakeQueenPage, 1)
CreateRefreshButton(EliteHunterPage, 1)
CreateRefreshButton(SoulReaperPage, 1)
CreateRefreshButton(PirateRaidPage, 1)
CreateRefreshButton(TyrantSkiesPage, 1)
CreateRefreshButton(MirageIslandPage, 1)
CreateRefreshButton(PrehistoricIslandPage, 1)
CreateRefreshButton(KitsuneIslandPage, 1)
CreateRefreshButton(HakiLegendaryPage, 1)
CreateRefreshButton(FruitPage, 1)
CreateRefreshButton(BerryPage, 1)

-- ==================================================
-- SHOP TAB
-- ==================================================
CreateSectionTitle(ShopPage, "Shop", 1)

-- ⭐ Auto Unlock Haki (Smart Checkbox)
local unlockHaki = CreateSmartCheckbox(
    ShopPage,
    "Auto Unlock Haki Legendary",
    2,
    function(state)
        if state and not _G.YOKUDO_AutoUnlockHakiEnabled then
            _G.YOKUDO_ToggleAutoUnlockHaki()
        elseif not state and _G.YOKUDO_AutoUnlockHakiEnabled then
            _G.YOKUDO_ToggleAutoUnlockHaki()
        end
    end,
    function()
        return _G.YOKUDO_AutoUnlockHakiEnabled or false
    end
)

if _G.YOKUDO_UpdateUI_UnlockHaki == nil then
    _G.YOKUDO_UpdateUI_UnlockHaki = unlockHaki.Update
end

-- ==================================================
-- ⭐ JOIN SERVER WITH JOBID (DECODE + JOIN)
-- ==================================================
CreateSectionTitle(ShopPage, "Join Server With Jobid", 3)

local jobIdHolder = Instance.new("Frame")
jobIdHolder.Name = "JobIdHolder"
jobIdHolder.Size = UDim2.new(1, 0, 0, 28)
jobIdHolder.BackgroundTransparency = 1
jobIdHolder.BorderSizePixel = 0
jobIdHolder.LayoutOrder = 4
jobIdHolder.ZIndex = 9
jobIdHolder.Parent = ShopPage

local jobIdLabel = Instance.new("TextLabel")
jobIdLabel.Name = "JobIdLabel"
jobIdLabel.Size = UDim2.new(0, 55, 1, 0)
jobIdLabel.Position = UDim2.new(0, 0, 0, 0)
jobIdLabel.BackgroundTransparency = 1
jobIdLabel.Text = "JobId:"
jobIdLabel.TextColor3 = Color3.fromRGB(205, 205, 220)
jobIdLabel.TextSize = 11
jobIdLabel.TextXAlignment = Enum.TextXAlignment.Left
jobIdLabel.TextYAlignment = Enum.TextYAlignment.Center
jobIdLabel.Font = Enum.Font.GothamMedium
jobIdLabel.ZIndex = 10
jobIdLabel.Parent = jobIdHolder

local jobIdTextBox = Instance.new("TextBox")
jobIdTextBox.Name = "JobIdTextBox"
jobIdTextBox.Size = UDim2.new(0, 180, 1, -4)
jobIdTextBox.Position = UDim2.new(0, 58, 0, 2)
jobIdTextBox.BackgroundColor3 = Color3.fromRGB(30, 31, 45)
jobIdTextBox.BorderSizePixel = 0
jobIdTextBox.Text = ""
jobIdTextBox.PlaceholderText = "Paste Premium Jobid or Normal"
jobIdTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
jobIdTextBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 170)
jobIdTextBox.TextSize = 10
jobIdTextBox.TextXAlignment = Enum.TextXAlignment.Left
jobIdTextBox.TextYAlignment = Enum.TextYAlignment.Center
jobIdTextBox.Font = Enum.Font.GothamMedium
jobIdTextBox.ZIndex = 11
jobIdTextBox.Parent = jobIdHolder

local TBoxCorner = Instance.new("UICorner")
TBoxCorner.CornerRadius = UDim.new(0, 4)
TBoxCorner.Parent = jobIdTextBox

local TBoxStroke = Instance.new("UIStroke")
TBoxStroke.Color = Color3.fromRGB(200, 200, 220)
TBoxStroke.Thickness = 0.5
TBoxStroke.Transparency = 0.2
TBoxStroke.Parent = jobIdTextBox

local joinButton = Instance.new("TextButton")
joinButton.Name = "JoinButton"
joinButton.Size = UDim2.new(0, 60, 1, -4)
joinButton.Position = UDim2.new(1, -62, 0, 2)
joinButton.BackgroundColor3 = Color3.fromRGB(105, 90, 190)
joinButton.BorderSizePixel = 0
joinButton.Text = "Join"
joinButton.TextColor3 = Color3.fromRGB(255, 255, 255)
joinButton.TextSize = 11
joinButton.TextXAlignment = Enum.TextXAlignment.Center
joinButton.TextYAlignment = Enum.TextYAlignment.Center
joinButton.Font = Enum.Font.GothamBold
joinButton.ZIndex = 11
joinButton.Parent = jobIdHolder

local BtnCorner = Instance.new("UICorner")
BtnCorner.CornerRadius = UDim.new(0, 4)
BtnCorner.Parent = joinButton

local BtnStroke = Instance.new("UIStroke")
BtnStroke.Color = Color3.fromRGB(200, 200, 220)
BtnStroke.Thickness = 0.5
BtnStroke.Transparency = 0.2
BtnStroke.Parent = joinButton

joinButton.MouseEnter:Connect(function()
    joinButton.BackgroundColor3 = Color3.fromRGB(135, 120, 225)
end)

joinButton.MouseLeave:Connect(function()
    joinButton.BackgroundColor3 = Color3.fromRGB(105, 90, 190)
end)

joinButton.MouseButton1Click:Connect(function()
    local inputText = jobIdTextBox.Text
    if inputText and inputText ~= "" and inputText ~= "Paste Premium Jobid or Normal" then
        if _G.YOKUDO_JoinServerByEncoded then
            local ok, msg = _G.YOKUDO_JoinServerByEncoded(inputText)
            if ok then
                print("✅ " .. msg)
            else
                print("❌ " .. msg)
            end
        else
            warn("⚠️ _G.YOKUDO_JoinServerByEncoded not found!")
        end
    else
        print("⚠️ Please paste Premium Jobid or Normal!")
    end
end)

jobIdTextBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        joinButton.MouseButton1Click:Fire()
    end
end)

-- ==================================================
-- AUTO HOP TAB
-- ==================================================
CreateSectionTitle(AutoHopPage, "Select Weapon for attack", 1)
CreateWeaponDropdown(AutoHopPage, 2)

-- ⭐ Auto Click Attack (Smart Checkbox)
local clickAttack = CreateSmartCheckbox(
    AutoHopPage,
    "Auto Click Attack",
    3,
    function(state)
        if state and not _G.YOKUDO_AutoClickAttackEnabled then
            _G.YOKUDO_ToggleAutoClickAttack()
        elseif not state and _G.YOKUDO_AutoClickAttackEnabled then
            _G.YOKUDO_ToggleAutoClickAttack()
        end
    end,
    function()
        return _G.YOKUDO_AutoClickAttackEnabled or false
    end
)

if _G.YOKUDO_UpdateUI_ClickAttack == nil then
    _G.YOKUDO_UpdateUI_ClickAttack = clickAttack.Update
end

-- Farm Boss: Dough King
CreateSectionTitle(AutoHopPage, "Farm Boss", 4)

-- ⭐ Auto Dough King (Smart Checkbox)
local doughKing = CreateSmartCheckbox(
    AutoHopPage,
    "Auto Dough King",
    5,
    function(state)
        if state and not _G.YOKUDO_AutoDoughKingEnabled then
            _G.YOKUDO_ToggleAutoDoughKing()
        elseif not state and _G.YOKUDO_AutoDoughKingEnabled then
            _G.YOKUDO_ToggleAutoDoughKing()
        end
    end,
    function()
        return _G.YOKUDO_AutoDoughKingEnabled or false
    end
)

if _G.YOKUDO_UpdateUI_DoughKing == nil then
    _G.YOKUDO_UpdateUI_DoughKing = doughKing.Update
end

-- Auto Hop Dough King (Checkbox ដើម)
local hopDoughKingFrame, hopDoughKingCheckbox, getHopDoughKingState = CreateCheckbox(AutoHopPage, "Auto Hop Dough King", 6)

-- Farm Boss: Rip Indra
CreateSectionTitle(AutoHopPage, "Farm Boss", 7)

-- ⭐ Auto Rip Indra (Smart Checkbox)
local ripIndra = CreateSmartCheckbox(
    AutoHopPage,
    "Auto Rip indra",
    8,
    function(state)
        if state and not _G.YOKUDO_AutoRipIndraEnabled then
            _G.YOKUDO_ToggleAutoRipIndra()
        elseif not state and _G.YOKUDO_AutoRipIndraEnabled then
            _G.YOKUDO_ToggleAutoRipIndra()
        end
    end,
    function()
        return _G.YOKUDO_AutoRipIndraEnabled or false
    end
)

if _G.YOKUDO_UpdateUI_RipIndra == nil then
    _G.YOKUDO_UpdateUI_RipIndra = ripIndra.Update
end

-- Auto Hop Rip Indra (Checkbox ដើម)
local hopRipIndraFrame, hopRipIndraCheckbox, getHopRipIndraState = CreateCheckbox(AutoHopPage, "Auto Hop Rip indra", 9)

-- Farm Boss: Cake Prince
CreateSectionTitle(AutoHopPage, "Farm Boss", 10)

-- ⭐ Auto Cake Prince (Smart Checkbox)
local cakePrince = CreateSmartCheckbox(
    AutoHopPage,
    "Auto Cake Prince",
    11,
    function(state)
        if state and not _G.YOKUDO_AutoCakePrinceEnabled then
            _G.YOKUDO_ToggleAutoCakePrince()
        elseif not state and _G.YOKUDO_AutoCakePrinceEnabled then
            _G.YOKUDO_ToggleAutoCakePrince()
        end
    end,
    function()
        return _G.YOKUDO_AutoCakePrinceEnabled or false
    end
)

if _G.YOKUDO_UpdateUI_CakePrince == nil then
    _G.YOKUDO_UpdateUI_CakePrince = cakePrince.Update
end

-- Auto Hop Cake Prince (Checkbox ដើម)
local hopCakePrinceFrame, hopCakePrinceCheckbox, getHopCakePrinceState = CreateCheckbox(AutoHopPage, "Auto Hop Cake Prince", 12)

-- Farm Boss: Soul Reaper
CreateSectionTitle(AutoHopPage, "Farm Boss", 13)

-- ⭐ Auto Soul Reaper (Smart Checkbox)
local soulReaper = CreateSmartCheckbox(
    AutoHopPage,
    "Auto Soul Reaper",
    14,
    function(state)
        if state and not _G.YOKUDO_AutoSoulReaperEnabled then
            _G.YOKUDO_ToggleAutoSoulReaper()
        elseif not state and _G.YOKUDO_AutoSoulReaperEnabled then
            _G.YOKUDO_ToggleAutoSoulReaper()
        end
    end,
    function()
        return _G.YOKUDO_AutoSoulReaperEnabled or false
    end
)

if _G.YOKUDO_UpdateUI_SoulReaper == nil then
    _G.YOKUDO_UpdateUI_SoulReaper = soulReaper.Update
end

-- Auto Hop Soul Reaper (Checkbox ដើម)
local hopSoulReaperFrame, hopSoulReaperCheckbox, getHopSoulReaperState = CreateCheckbox(AutoHopPage, "Auto Hop Soul Reaper", 15)

-- Farm Boss: Elite Hunter
CreateSectionTitle(AutoHopPage, "Farm Boss", 16)

-- ⭐ Auto Elite Hunter (Smart Checkbox)
local eliteHunter = CreateSmartCheckbox(
    AutoHopPage,
    "Auto Elite Hunter",
    17,
    function(state)
        if state and not _G.YOKUDO_AutoEliteHunterEnabled then
            _G.YOKUDO_ToggleAutoEliteHunter()
        elseif not state and _G.YOKUDO_AutoEliteHunterEnabled then
            _G.YOKUDO_ToggleAutoEliteHunter()
        end
    end,
    function()
        return _G.YOKUDO_AutoEliteHunterEnabled or false
    end
)

if _G.YOKUDO_UpdateUI_EliteHunter == nil then
    _G.YOKUDO_UpdateUI_EliteHunter = eliteHunter.Update
end

-- Auto Hop Elite Hunter (Checkbox ដើម)
local hopEliteHunterFrame, hopEliteHunterCheckbox, getHopEliteHunterState = CreateCheckbox(AutoHopPage, "Auto Hop Elite Hunter", 18)

-- ==================================================
-- AUTO HOP CHECKBOX EVENTS
-- ==================================================
hopDoughKingCheckbox.MouseButton1Click:Connect(function()
    if _G.YOKUDO_ToggleAutoHopDoughKing then
        _G.YOKUDO_ToggleAutoHopDoughKing()
    end
end)

hopRipIndraCheckbox.MouseButton1Click:Connect(function()
    if _G.YOKUDO_ToggleAutoHopRipIndra then
        _G.YOKUDO_ToggleAutoHopRipIndra()
    end
end)

hopCakePrinceCheckbox.MouseButton1Click:Connect(function()
    if _G.YOKUDO_ToggleAutoHopCakePrince then
        _G.YOKUDO_ToggleAutoHopCakePrince()
    end
end)

hopSoulReaperCheckbox.MouseButton1Click:Connect(function()
    if _G.YOKUDO_ToggleAutoHopSoulReaper then
        _G.YOKUDO_ToggleAutoHopSoulReaper()
    end
end)

hopEliteHunterCheckbox.MouseButton1Click:Connect(function()
    if _G.YOKUDO_ToggleAutoHopEliteHunter then
        _G.YOKUDO_ToggleAutoHopEliteHunter()
    end
end)

-- ==================================================
-- SETTING TAB
-- ==================================================
CreateSectionTitle(SettingPage, "Tween Settings", 1)
CreateStopTweenButton(SettingPage, 2)

CreateSectionTitle(SettingPage, "Other", 3)
local noClipFrame, noClipCheckbox, getNoClipState = CreateCheckbox(SettingPage, "No Clip", 4)

CreateSectionTitle(SettingPage, "Auto Abilities", 5)

-- ⭐ Auto Buso (Smart Checkbox)
local buso = CreateSmartCheckbox(
    SettingPage,
    "Auto Buso",
    6,
    function(state)
        if state and not _G.YOKUDO_BusoEnabled then
            _G.YOKUDO_ToggleAutoBuso()
        elseif not state and _G.YOKUDO_BusoEnabled then
            _G.YOKUDO_ToggleAutoBuso()
        end
    end,
    function()
        return _G.YOKUDO_BusoEnabled or false
    end
)

if _G.YOKUDO_UpdateUI_Buso == nil then
    _G.YOKUDO_UpdateUI_Buso = buso.Update
end

-- ⭐ Auto Ken (Checkbox ដើម - គ្មាន Config)
local obsFrame, obsCheckbox, getObsState = CreateCheckbox(SettingPage, "Auto Ken", 7)

CreateSectionTitle(SettingPage, "Movement Hacks", 8)
local jumpHolder, jumpCheckbox, getJumpState, jumpTextBox, getJumpValue = CreateTextBoxWithCheckbox(SettingPage, "Jump Hack", 9)
local speedHolder, speedCheckbox, getSpeedState, speedTextBox, getSpeedValue = CreateTextBoxWithCheckbox(SettingPage, "Speed Hack", 10)

-- ⭐ Walk on Water (Smart Checkbox)
local walk = CreateSmartCheckbox(
    SettingPage,
    "Walk on Water",
    11,
    function(state)
        if state and not _G.YOKUDO_WalkEnabled then
            _G.YOKUDO_ToggleWalkOnWater()
        elseif not state and _G.YOKUDO_WalkEnabled then
            _G.YOKUDO_ToggleWalkOnWater()
        end
    end,
    function()
        return _G.YOKUDO_WalkEnabled or false
    end
)

if _G.YOKUDO_UpdateUI_Walk == nil then
    _G.YOKUDO_UpdateUI_Walk = walk.Update
end

-- ==================================================
-- SETTING CHECKBOX EVENTS
-- ==================================================
obsCheckbox.MouseButton1Click:Connect(function()
    if _G.YOKUDO_ToggleAutoKen then
        _G.YOKUDO_ToggleAutoKen()
    end
end)

noClipCheckbox.MouseButton1Click:Connect(function()
    if _G.YOKUDO_ToggleNoClip then
        _G.YOKUDO_ToggleNoClip()
    end
end)

-- ==================================================
-- OTHER PAGES
-- ==================================================

_G.YOKUDO_AutoHopPage = AutoHopPage

print("✅ Tabs Loaded")
