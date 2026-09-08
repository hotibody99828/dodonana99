-- ==================================================
-- UI COMPONENTS (SEA3) + SMART CHECKBOX
-- ==================================================

local Y = _G.Y
local Services = _G.YOKUDO.Services
local Settings = _G.YOKUDO

local function GetTabTextSize(Name)
    local Length = #Name
    if Length >= 16 then return 10
    elseif Length >= 13 then return 11
    elseif Length >= 9 then return 12
    elseif Length >= 6 then return 13
    else return 14 end
end

function CreateTab(Name, Order)
    local TabScroll = _G.YOKUDO_TabScroll
    local Tab = Instance.new("TextButton")
    Tab.Name = Name:gsub("%s+", "_") .. "_Tab"
    Tab.Size = UDim2.new(1, 0, 0, Settings.UI.TabHeight)
    Tab.BackgroundColor3 = Color3.fromRGB(38, 40, 52)
    Tab.BackgroundTransparency = 1
    Tab.BorderSizePixel = 0
    Tab.Text = ""
    Tab.AutoButtonColor = false
    Tab.LayoutOrder = Order or 1
    Tab.ZIndex = 7
    Tab.Parent = TabScroll

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = Tab

    local TabBorder = Instance.new("UIStroke")
    TabBorder.Color = Color3.fromRGB(200, 200, 220)
    TabBorder.Thickness = 1
    TabBorder.Transparency = 0.2
    TabBorder.Parent = Tab

    local Indicator = Instance.new("Frame")
    Indicator.Name = "Indicator"
    Indicator.Size = UDim2.new(0, 3, 0, 18)
    Indicator.Position = UDim2.new(0, 2, 0.5, -9)
    Indicator.BackgroundColor3 = Color3.fromRGB(200, 200, 220)
    Indicator.BackgroundTransparency = 1
    Indicator.BorderSizePixel = 0
    Indicator.ZIndex = 8
    Indicator.Parent = Tab

    local IndicatorCorner = Instance.new("UICorner")
    IndicatorCorner.CornerRadius = UDim.new(1, 0)
    IndicatorCorner.Parent = Indicator

    local Text = Instance.new("TextLabel")
    Text.Name = "TabText"
    Text.Size = UDim2.new(1, -10, 1, 0)
    Text.Position = UDim2.new(0, 8, 0, 0)
    Text.BackgroundTransparency = 1
    Text.Text = Name
    Text.TextColor3 = Color3.fromRGB(155, 155, 175)
    Text.TextSize = GetTabTextSize(Name)
    Text.TextXAlignment = Enum.TextXAlignment.Left
    Text.TextYAlignment = Enum.TextYAlignment.Center
    Text.Font = Enum.Font.GothamMedium
    Text.TextTruncate = Enum.TextTruncate.AtEnd
    Text.Active = false
    Text.Selectable = false
    Text.ZIndex = 8
    Text.Parent = Tab

    return Tab
end

function CreatePage(Name)
    local Content = _G.YOKUDO_Content
    local Page = Instance.new("ScrollingFrame")
    Page.Name = Name .. "_Page"
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.BorderSizePixel = 0
    Page.Visible = false
    Page.CanvasSize = UDim2.new(0, 0, 0, 0)
    Page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    Page.ScrollingDirection = Enum.ScrollingDirection.Y
    Page.ScrollBarThickness = 4
    Page.ScrollBarImageColor3 = Color3.fromRGB(200, 200, 220)
    Page.ScrollBarImageTransparency = 0.1
    Page.VerticalScrollBarInset = Enum.ScrollBarInset.Always
    Page.HorizontalScrollBarInset = Enum.ScrollBarInset.None
    Page.Active = true
    Page.Selectable = true
    Page.ZIndex = 6
    Page.Parent = Content

    local Padding = Instance.new("UIPadding")
    Padding.PaddingTop = UDim.new(0, 12)
    Padding.PaddingBottom = UDim.new(0, 14)
    Padding.PaddingLeft = UDim.new(0, 14)
    Padding.PaddingRight = UDim.new(0, 12)
    Padding.Parent = Page

    local List = Instance.new("UIListLayout")
    List.Padding = UDim.new(0, 4)
    List.SortOrder = Enum.SortOrder.LayoutOrder
    List.Parent = Page

    return Page
end

function CreateSectionTitle(Parent, TextValue, Order)
    local Label = Instance.new("TextLabel")
    Label.Name = "SectionTitle"
    Label.Size = UDim2.new(1, 0, 0, 23)
    Label.BackgroundTransparency = 1
    Label.Text = TextValue
    Label.TextColor3 = Color3.fromRGB(235, 235, 245)
    Label.TextSize = 13
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.TextYAlignment = Enum.TextYAlignment.Center
    Label.Font = Enum.Font.GothamBold
    Label.LayoutOrder = Order or 1
    Label.Active = false
    Label.Selectable = false
    Label.ZIndex = 8
    Label.Parent = Parent
    return Label
end

function CreateCheckbox(Parent, TextValue, Order)
    local Holder = Instance.new("Frame")
    Holder.Name = TextValue:gsub("%s+", "_")
    Holder.Size = UDim2.new(1, 0, 0, 32)
    Holder.BackgroundTransparency = 1
    Holder.BorderSizePixel = 0
    Holder.LayoutOrder = Order or 1
    Holder.Active = false
    Holder.ZIndex = 9
    Holder.Parent = Parent

    local Label = Instance.new("TextLabel")
    Label.Name = "Label"
    Label.Size = UDim2.new(1, -38, 1, 0)
    Label.Position = UDim2.new(0, 0, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = TextValue
    Label.TextColor3 = Color3.fromRGB(205, 205, 220)
    Label.TextSize = 12
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.TextYAlignment = Enum.TextYAlignment.Center
    Label.Font = Enum.Font.GothamMedium
    Label.Active = false
    Label.Selectable = false
    Label.ZIndex = 10
    Label.Parent = Holder

    local CheckButton = Instance.new("TextButton")
    CheckButton.Name = "CheckBox"
    CheckButton.Size = UDim2.new(0, 26, 0, 26)
    CheckButton.Position = UDim2.new(1, -26, 0.5, -13)
    CheckButton.BackgroundColor3 = Color3.fromRGB(28, 29, 39)
    CheckButton.BorderSizePixel = 0
    CheckButton.Text = ""
    CheckButton.AutoButtonColor = false
    CheckButton.Active = true
    CheckButton.ZIndex = 20
    CheckButton.Parent = Holder

    local BoxCorner = Instance.new("UICorner")
    BoxCorner.CornerRadius = UDim.new(0, 6)
    BoxCorner.Parent = CheckButton

    local BoxStroke = Instance.new("UIStroke")
    BoxStroke.Color = Color3.fromRGB(200, 200, 220)
    BoxStroke.Thickness = 1.5
    BoxStroke.Parent = CheckButton

    local Check = Instance.new("TextLabel")
    Check.Name = "Check"
    Check.Size = UDim2.new(1, 0, 1, 0)
    Check.BackgroundTransparency = 1
    Check.Text = "✓"
    Check.TextColor3 = Color3.fromRGB(255, 255, 255)
    Check.TextSize = 18
    Check.Font = Enum.Font.GothamBold
    Check.Visible = false
    Check.Active = false
    Check.Selectable = false
    Check.ZIndex = 21
    Check.Parent = CheckButton

    local Enabled = false

    local function Toggle()
        Enabled = not Enabled
        Check.Visible = Enabled
        if Enabled then
            CheckButton.BackgroundColor3 = Settings.UI.Theme.Accent
            BoxStroke.Color = Color3.fromRGB(135, 120, 225)
        else
            CheckButton.BackgroundColor3 = Color3.fromRGB(28, 29, 39)
            BoxStroke.Color = Color3.fromRGB(200, 200, 220)
        end
    end

    CheckButton.MouseButton1Click:Connect(function()
        Toggle()
    end)

    return Holder, CheckButton, function() return Enabled end
end

function CreateTextBoxWithCheckbox(Parent, TextValue, Order)
    local Holder = Instance.new("Frame")
    Holder.Name = TextValue:gsub("%s+", "_")
    Holder.Size = UDim2.new(1, 0, 0, 32)
    Holder.BackgroundTransparency = 1
    Holder.BorderSizePixel = 0
    Holder.LayoutOrder = Order or 1
    Holder.Active = false
    Holder.ZIndex = 9
    Holder.Parent = Parent

    local Label = Instance.new("TextLabel")
    Label.Name = "Label"
    Label.Size = UDim2.new(0, 100, 1, 0)
    Label.Position = UDim2.new(0, 0, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = TextValue
    Label.TextColor3 = Color3.fromRGB(205, 205, 220)
    Label.TextSize = 12
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.TextYAlignment = Enum.TextYAlignment.Center
    Label.Font = Enum.Font.GothamMedium
    Label.Active = false
    Label.Selectable = false
    Label.ZIndex = 10
    Label.Parent = Holder

    local TextBox = Instance.new("TextBox")
    TextBox.Name = "TextBox"
    TextBox.Size = UDim2.new(0, 60, 1, -6)
    TextBox.Position = UDim2.new(0, 105, 0, 3)
    TextBox.BackgroundColor3 = Color3.fromRGB(30, 31, 45)
    TextBox.BorderSizePixel = 0
    TextBox.Text = TextValue == "Speed Hack" and "16" or "50"
    TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextBox.TextSize = 12
    TextBox.TextXAlignment = Enum.TextXAlignment.Center
    TextBox.TextYAlignment = Enum.TextYAlignment.Center
    TextBox.Font = Enum.Font.GothamMedium
    TextBox.ZIndex = 11
    TextBox.Parent = Holder

    local TBoxCorner = Instance.new("UICorner")
    TBoxCorner.CornerRadius = UDim.new(0, 4)
    TBoxCorner.Parent = TextBox

    local TBoxStroke = Instance.new("UIStroke")
    TBoxStroke.Color = Color3.fromRGB(200, 200, 220)
    TBoxStroke.Thickness = 0.5
    TBoxStroke.Transparency = 0.2
    TBoxStroke.Parent = TextBox

    local CheckButton = Instance.new("TextButton")
    CheckButton.Name = "CheckBox"
    CheckButton.Size = UDim2.new(0, 26, 0, 26)
    CheckButton.Position = UDim2.new(1, -26, 0.5, -13)
    CheckButton.BackgroundColor3 = Color3.fromRGB(28, 29, 39)
    CheckButton.BorderSizePixel = 0
    CheckButton.Text = ""
    CheckButton.AutoButtonColor = false
    CheckButton.Active = true
    CheckButton.ZIndex = 20
    CheckButton.Parent = Holder

    local BoxCorner = Instance.new("UICorner")
    BoxCorner.CornerRadius = UDim.new(0, 6)
    BoxCorner.Parent = CheckButton

    local BoxStroke = Instance.new("UIStroke")
    BoxStroke.Color = Color3.fromRGB(200, 200, 220)
    BoxStroke.Thickness = 1.5
    BoxStroke.Parent = CheckButton

    local Check = Instance.new("TextLabel")
    Check.Name = "Check"
    Check.Size = UDim2.new(1, 0, 1, 0)
    Check.BackgroundTransparency = 1
    Check.Text = "✓"
    Check.TextColor3 = Color3.fromRGB(255, 255, 255)
    Check.TextSize = 18
    Check.Font = Enum.Font.GothamBold
    Check.Visible = false
    Check.Active = false
    Check.Selectable = false
    Check.ZIndex = 21
    Check.Parent = CheckButton

    local Enabled = false
    local CurrentValue = tonumber(TextBox.Text) or 16
    
    if TextValue == "Speed Hack" then
        _G.YOKUDO_SpeedTextBoxValue = CurrentValue
        _G.YOKUDO_CurrentSpeed = CurrentValue
    elseif TextValue == "Jump Hack" then
        _G.YOKUDO_JumpTextBoxValue = CurrentValue
        _G.YOKUDO_CurrentJump = CurrentValue
    end

    local function UpdateValue()
        local val = tonumber(TextBox.Text)
        if val then
            if TextValue == "Speed Hack" then
                CurrentValue = math.clamp(val, 16, 350)
                TextBox.Text = tostring(CurrentValue)
                if Enabled and _G.YOKUDO_SpeedEnabled then
                    _G.YOKUDO_CurrentSpeed = CurrentValue
                    if _G.YOKUDO_SpeedLoopConnection then 
                        _G.YOKUDO_SpeedLoopConnection:Disconnect() 
                        _G.YOKUDO_SpeedLoopConnection = nil 
                    end
                    _G.YOKUDO_StartSpeedLoop()
                end
            elseif TextValue == "Jump Hack" then
                CurrentValue = math.clamp(val, 50, 300)
                TextBox.Text = tostring(CurrentValue)
                if Enabled and _G.YOKUDO_JumpEnabled then
                    _G.YOKUDO_CurrentJump = CurrentValue
                    _G.YOKUDO_DisableJumpPower()
                    _G.YOKUDO_EnableJumpPower()
                end
            end
        else
            TextBox.Text = tostring(CurrentValue)
        end
    end

    local function Toggle()
        Enabled = not Enabled
        Check.Visible = Enabled
        if Enabled then
            CheckButton.BackgroundColor3 = Settings.UI.Theme.Accent
            BoxStroke.Color = Color3.fromRGB(135, 120, 225)
            if TextValue == "Speed Hack" then
                _G.YOKUDO_CurrentSpeed = CurrentValue
                _G.YOKUDO_SpeedEnabled = true
                _G.YOKUDO_StartSpeedLoop()
            elseif TextValue == "Jump Hack" then
                _G.YOKUDO_CurrentJump = CurrentValue
                _G.YOKUDO_JumpEnabled = true
                _G.YOKUDO_EnableJumpPower()
            end
        else
            CheckButton.BackgroundColor3 = Color3.fromRGB(28, 29, 39)
            BoxStroke.Color = Color3.fromRGB(200, 200, 220)
            if TextValue == "Speed Hack" then
                _G.YOKUDO_SpeedEnabled = false
                _G.YOKUDO_StopSpeedLoop()
            elseif TextValue == "Jump Hack" then
                _G.YOKUDO_JumpEnabled = false
                _G.YOKUDO_DisableJumpPower()
            end
        end
    end

    CheckButton.MouseButton1Click:Connect(function()
        Toggle()
    end)

    TextBox.FocusLost:Connect(function()
        UpdateValue()
    end)

    return Holder, CheckButton, function() return Enabled end, TextBox, function() return CurrentValue end
end

-- ==================================================
-- REFRESH BUTTON
-- ==================================================
function CreateRefreshButton(Parent, Order)
    local Y = _G.Y
    local Holder = Instance.new("Frame")
    Holder.Name = "RefreshHolder"
    Holder.Size = UDim2.new(1, 0, 0, 50)
    Holder.BackgroundTransparency = 1
    Holder.BorderSizePixel = 0
    Holder.LayoutOrder = Order or 1
    Holder.ZIndex = 10
    Holder.Parent = Parent
    Holder.ClipsDescendants = true

    local TopSpacer = Instance.new("Frame")
    TopSpacer.Name = "TopSpacer"
    TopSpacer.Size = UDim2.new(1, 0, 0, 4)
    TopSpacer.Position = UDim2.new(0, 0, 0, 0)
    TopSpacer.BackgroundTransparency = 1
    TopSpacer.BorderSizePixel = 0
    TopSpacer.ZIndex = 9
    TopSpacer.Parent = Holder

    local Button = Instance.new("TextButton")
    Button.Name = "RefreshButton"
    Button.Size = UDim2.new(1, 0, 0, 32)
    Button.Position = UDim2.new(0, 0, 0, 4)
    Button.BackgroundColor3 = Color3.fromRGB(30, 31, 42)
    Button.BorderSizePixel = 0
    Button.Text = ""
    Button.AutoButtonColor = false
    Button.Active = true
    Button.ZIndex = 11
    Button.Parent = Holder

    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 6)
    ButtonCorner.Parent = Button

    local ButtonStroke = Instance.new("UIStroke")
    ButtonStroke.Color = Color3.fromRGB(200, 200, 220)
    ButtonStroke.Thickness = 1
    ButtonStroke.Transparency = 0.2
    ButtonStroke.Parent = Button

    local SlideOverlay = Instance.new("Frame")
    SlideOverlay.Name = "SlideOverlay"
    SlideOverlay.Size = UDim2.new(1, 0, 1, 0)
    SlideOverlay.Position = UDim2.new(-1, 0, 0, 0)
    SlideOverlay.BackgroundColor3 = Color3.fromRGB(200, 200, 220)
    SlideOverlay.BackgroundTransparency = 0.85
    SlideOverlay.BorderSizePixel = 0
    SlideOverlay.ZIndex = 13
    SlideOverlay.Parent = Button

    local SlideCorner = Instance.new("UICorner")
    SlideCorner.CornerRadius = UDim.new(0, 6)
    SlideCorner.Parent = SlideOverlay

    local RefreshText = Instance.new("TextLabel")
    RefreshText.Name = "RefreshText"
    RefreshText.Size = UDim2.new(1, 0, 0, 18)
    RefreshText.Position = UDim2.new(0, 10, 0, 2)
    RefreshText.BackgroundTransparency = 1
    RefreshText.Text = "Refresh Server"
    RefreshText.TextColor3 = Color3.fromRGB(255, 255, 255)
    RefreshText.TextSize = 12
    RefreshText.TextXAlignment = Enum.TextXAlignment.Left
    RefreshText.TextYAlignment = Enum.TextYAlignment.Top
    RefreshText.Font = Enum.Font.GothamBold
    RefreshText.ZIndex = 14
    RefreshText.Parent = Button

    local SubText = Instance.new("TextLabel")
    SubText.Name = "SubText"
    SubText.Size = UDim2.new(1, 0, 0, 14)
    SubText.Position = UDim2.new(0, 10, 0, 20)
    SubText.BackgroundTransparency = 1
    SubText.Text = "Click Refresh for find new server"
    SubText.TextColor3 = Color3.fromRGB(145, 145, 165)
    SubText.TextSize = 9
    SubText.TextXAlignment = Enum.TextXAlignment.Left
    SubText.TextYAlignment = Enum.TextYAlignment.Top
    SubText.Font = Enum.Font.GothamMedium
    SubText.ZIndex = 14
    SubText.Parent = Button

    local function PlaySlideAnimation()
        SlideOverlay.Position = UDim2.new(-1, 0, 0, 0)
        local Tween = Y.TS:Create(
            SlideOverlay,
            TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {Position = UDim2.new(1.1, 0, 0, 0)}
        )
        Tween:Play()
    end

    Button.MouseButton1Click:Connect(function()
        PlaySlideAnimation()
    end)

    local BottomSpacer = Instance.new("Frame")
    BottomSpacer.Name = "BottomSpacer"
    BottomSpacer.Size = UDim2.new(1, 0, 0, 6)
    BottomSpacer.Position = UDim2.new(0, 0, 1, -6)
    BottomSpacer.BackgroundTransparency = 1
    BottomSpacer.BorderSizePixel = 0
    BottomSpacer.ZIndex = 9
    BottomSpacer.Parent = Holder

    return Holder
end

function CreateStopTweenButton(Parent, Order)
    local Holder = Instance.new("Frame")
    Holder.Name = "StopTweenHolder"
    Holder.Size = UDim2.new(1, 0, 0, 32)
    Holder.BackgroundTransparency = 1
    Holder.BorderSizePixel = 0
    Holder.LayoutOrder = Order or 1
    Holder.Active = false
    Holder.ZIndex = 9
    Holder.Parent = Parent

    local Label = Instance.new("TextLabel")
    Label.Name = "Label"
    Label.Size = UDim2.new(0, 100, 1, 0)
    Label.Position = UDim2.new(0, 0, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = "Stop Tween"
    Label.TextColor3 = Color3.fromRGB(205, 205, 220)
    Label.TextSize = 12
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.TextYAlignment = Enum.TextYAlignment.Center
    Label.Font = Enum.Font.GothamMedium
    Label.Active = false
    Label.Selectable = false
    Label.ZIndex = 10
    Label.Parent = Holder

    local Button = Instance.new("TextButton")
    Button.Name = "StopTweenButton"
    Button.Size = UDim2.new(0, 80, 1, -6)
    Button.Position = UDim2.new(1, -85, 0, 3)
    Button.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    Button.BorderSizePixel = 0
    Button.Text = "Stop"
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.TextSize = 12
    Button.TextXAlignment = Enum.TextXAlignment.Center
    Button.TextYAlignment = Enum.TextYAlignment.Center
    Button.Font = Enum.Font.GothamBold
    Button.ZIndex = 11
    Button.Parent = Holder

    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 6)
    BtnCorner.Parent = Button

    local BtnStroke = Instance.new("UIStroke")
    BtnStroke.Color = Color3.fromRGB(200, 200, 220)
    BtnStroke.Thickness = 0.5
    BtnStroke.Transparency = 0.2
    BtnStroke.Parent = Button

    Button.MouseEnter:Connect(function()
        Button.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
    end)

    Button.MouseLeave:Connect(function()
        Button.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    end)

    Button.MouseButton1Click:Connect(function()
        if _G.YOKUDO_StopTweenTeleport then
            _G.YOKUDO_StopTweenTeleport()
        end
    end)

    return Holder
end

function CreateWeaponDropdown(Parent, Order)
    local Holder = Instance.new("Frame")
    Holder.Name = "WeaponSelector"
    Holder.Size = UDim2.new(1, 0, 0, 34)
    Holder.BackgroundTransparency = 1
    Holder.BorderSizePixel = 0
    Holder.LayoutOrder = Order or 1
    Holder.ZIndex = 9
    Holder.Parent = Parent

    local Label = Instance.new("TextLabel")
    Label.Name = "WeaponLabel"
    Label.Size = UDim2.new(0, 120, 1, 0)
    Label.Position = UDim2.new(0, 0, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = "Select Weapon :"
    Label.TextColor3 = Color3.fromRGB(205, 205, 220)
    Label.TextSize = 12
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.TextYAlignment = Enum.TextYAlignment.Center
    Label.Font = Enum.Font.GothamMedium
    Label.Active = false
    Label.Selectable = false
    Label.ZIndex = 10
    Label.Parent = Holder

    local Button = Instance.new("TextButton")
    Button.Name = "WeaponButton"
    Button.Size = UDim2.new(0, 115, 0, 28)
    Button.Position = UDim2.new(1, -115, 0, 3)
    Button.BackgroundColor3 = Color3.fromRGB(30, 31, 41)
    Button.BorderSizePixel = 0
    Button.Text = "Melee"
    Button.TextColor3 = Color3.fromRGB(225, 225, 235)
    Button.TextSize = 12
    Button.TextXAlignment = Enum.TextXAlignment.Left
    Button.Font = Enum.Font.GothamMedium
    Button.AutoButtonColor = false
    Button.ZIndex = 11
    Button.Parent = Holder

    local ButtonPadding = Instance.new("UIPadding")
    ButtonPadding.PaddingLeft = UDim.new(0, 10)
    ButtonPadding.PaddingRight = UDim.new(0, 5)
    ButtonPadding.Parent = Button

    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 7)
    ButtonCorner.Parent = Button

    local ButtonStroke = Instance.new("UIStroke")
    ButtonStroke.Color = Color3.fromRGB(200, 200, 220)
    ButtonStroke.Thickness = 1
    ButtonStroke.Transparency = 0.2
    ButtonStroke.Parent = Button

    local Dropdown = Instance.new("Frame")
    Dropdown.Name = "Dropdown"
    Dropdown.Size = UDim2.new(0, 115, 0, 68)
    Dropdown.Position = UDim2.new(1, -115, 0, 31)
    Dropdown.BackgroundColor3 = Color3.fromRGB(25, 26, 35)
    Dropdown.BorderSizePixel = 0
    Dropdown.Visible = false
    Dropdown.ZIndex = 30
    Dropdown.Parent = Holder

    local DropCorner = Instance.new("UICorner")
    DropCorner.CornerRadius = UDim.new(0, 7)
    DropCorner.Parent = Dropdown

    local DropStroke = Instance.new("UIStroke")
    DropStroke.Color = Color3.fromRGB(200, 200, 220)
    DropStroke.Thickness = 1
    DropStroke.Transparency = 0.15
    DropStroke.Parent = Dropdown

    local Options = {"Melee", "Sword"}

    for Index, Weapon in ipairs(Options) do
        local Option = Instance.new("TextButton")
        Option.Name = Weapon
        Option.Size = UDim2.new(1, -8, 0, 28)
        Option.Position = UDim2.new(0, 4, 0, 4 + ((Index - 1) * 31))
        Option.BackgroundColor3 = Color3.fromRGB(32, 33, 43)
        Option.BackgroundTransparency = 1
        Option.BorderSizePixel = 0
        Option.Text = Weapon
        Option.TextColor3 = Color3.fromRGB(215, 215, 230)
        Option.TextSize = 11
        Option.TextXAlignment = Enum.TextXAlignment.Left
        Option.Font = Enum.Font.GothamMedium
        Option.AutoButtonColor = false
        Option.ZIndex = 31
        Option.Parent = Dropdown

        local OptionPadding = Instance.new("UIPadding")
        OptionPadding.PaddingLeft = UDim.new(0, 8)
        OptionPadding.Parent = Option

        Option.MouseButton1Click:Connect(function()
            Button.Text = Weapon
            Dropdown.Visible = false
            if _G.YOKUDO_AutoEquip then
                _G.YOKUDO_AutoEquip.SelectedType = Weapon
            end
        end)
    end

    Button.MouseButton1Click:Connect(function()
        Dropdown.Visible = not Dropdown.Visible
    end)

    return Holder
end

function AddFeaturesSoon(Page)
    local Card = Instance.new("Frame")
    Card.Name = "PageCard"
    Card.Size = UDim2.new(1, 0, 0, 240)
    Card.BackgroundColor3 = Color3.fromRGB(22, 23, 31)
    Card.BorderSizePixel = 0
    Card.LayoutOrder = 1
    Card.ZIndex = 7
    Card.Parent = Page

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 10)
    Corner.Parent = Card

    local Soon = Instance.new("TextLabel")
    Soon.Size = UDim2.new(1, -20, 0, 40)
    Soon.Position = UDim2.new(0, 10, 0.5, -20)
    Soon.BackgroundTransparency = 1
    Soon.Text = "FEATURES SOON"
    Soon.TextColor3 = Color3.fromRGB(130, 130, 150)
    Soon.TextSize = 15
    Soon.Font = Enum.Font.GothamMedium
    Soon.ZIndex = 8
    Soon.Parent = Card
end

-- ==================================================
-- ⭐ SMART CHECKBOX (ភ្ជាប់ជាមួយ Config)
-- ==================================================
function CreateSmartCheckbox(Parent, LabelText, Order, SetFunction, GetStateFunction)
    local Holder = Instance.new("Frame")
    Holder.Size = UDim2.new(1, 0, 0, 32)
    Holder.BackgroundTransparency = 1
    Holder.LayoutOrder = Order or 1
    Holder.Parent = Parent

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -38, 1, 0)
    Label.BackgroundTransparency = 1
    Label.Text = LabelText
    Label.TextColor3 = Color3.fromRGB(205, 205, 220)
    Label.TextSize = 13
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.TextYAlignment = Enum.TextYAlignment.Center
    Label.Font = Enum.Font.GothamMedium
    Label.Parent = Holder

    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(0, 26, 0, 26)
    Button.Position = UDim2.new(1, -26, 0.5, -13)
    Button.BackgroundColor3 = Color3.fromRGB(28, 29, 39)
    Button.BorderSizePixel = 0
    Button.Text = ""
    Button.Parent = Holder

    local BoxCorner = Instance.new("UICorner")
    BoxCorner.CornerRadius = UDim.new(0, 6)
    BoxCorner.Parent = Button

    local Check = Instance.new("TextLabel")
    Check.Size = UDim2.new(1, 0, 1, 0)
    Check.BackgroundTransparency = 1
    Check.Text = "✓"
    Check.TextColor3 = Color3.fromRGB(255, 255, 255)
    Check.TextSize = 18
    Check.Font = Enum.Font.GothamBold
    Check.Visible = false
    Check.Parent = Button

    -- State
    local Enabled = false
    if GetStateFunction then
        Enabled = GetStateFunction()
        Check.Visible = Enabled
        if Enabled then
            Button.BackgroundColor3 = Color3.fromRGB(105, 90, 190)
        end
    end

    local function UpdateUI(state)
        Enabled = state
        Check.Visible = state
        if state then
            Button.BackgroundColor3 = Color3.fromRGB(105, 90, 190)
        else
            Button.BackgroundColor3 = Color3.fromRGB(28, 29, 39)
        end
    end

    Button.MouseButton1Click:Connect(function()
        if SetFunction then
            local currentState = GetStateFunction and GetStateFunction() or Enabled
            local newState = not currentState
            UpdateUI(newState)
            task.spawn(function()
                SetFunction(newState)
            end)
        end
    end)

    -- Export for external update
    if LabelText == "Walk on Water" then
        _G.YOKUDO_UpdateUI_Walk = UpdateUI
    elseif LabelText == "Auto Buso" then
        _G.YOKUDO_UpdateUI_Buso = UpdateUI
    elseif LabelText == "Auto Unlock Haki Legendary" then
        _G.YOKUDO_UpdateUI_UnlockHaki = UpdateUI
    elseif LabelText == "Auto Click Attack" then
        _G.YOKUDO_UpdateUI_ClickAttack = UpdateUI
    elseif LabelText == "Auto Dough King" then
        _G.YOKUDO_UpdateUI_DoughKing = UpdateUI
    elseif LabelText == "Auto Rip indra" then
        _G.YOKUDO_UpdateUI_RipIndra = UpdateUI
    elseif LabelText == "Auto Cake Prince" then
        _G.YOKUDO_UpdateUI_CakePrince = UpdateUI
    elseif LabelText == "Auto Soul Reaper" then
        _G.YOKUDO_UpdateUI_SoulReaper = UpdateUI
    elseif LabelText == "Auto Elite Hunter" then
        _G.YOKUDO_UpdateUI_EliteHunter = UpdateUI
    end

    return {
        Holder = Holder,
        Button = Button,
        GetState = function() return Enabled end,
        SetState = UpdateUI,
        Update = UpdateUI,
    }
end

-- ==================================================
-- ⭐ UPDATE WEAPON BUTTON (សម្រាប់ Config Load)
-- ==================================================
function _G.YOKUDO_UpdateWeaponButton(weaponType)
    if not _G.YOKUDO_AutoHopPage then return end
    for _, child in ipairs(_G.YOKUDO_AutoHopPage:GetDescendants()) do
        if child.Name == "WeaponButton" then
            child.Text = weaponType
            print("✅ Weapon Button updated to: " .. weaponType)
            return
        end
    end
end

print("✅ Components Loaded")
