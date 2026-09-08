-- ==================================================
-- HAKI LEGENDARY CHECKER (SEA3) - LOAD DATA FROM VPS
-- ==================================================

local HttpService = game:GetService("HttpService")
local VPS_URL = "http://217.216.73.147:3000"

local function LoadDataFromVPS(type)
    pcall(function()
        local requestFunc = syn and syn.request or http and http.request or request
        if requestFunc then
            local response = requestFunc({
                Url = VPS_URL .. "/api/data/" .. type,
                Method = "GET"
            })
            if response and response.StatusCode == 200 then
                local data = HttpService:JSONDecode(response.Body)
                return data.servers or {}
            end
        end
    end)
    return {}
end

local function MaskJobId(jobId)
    if not jobId or jobId == "" then return "Unknown" end
    if #jobId > 8 then
        return string.sub(jobId, 1, 8) .. "..." .. string.sub(jobId, -4)
    end
    return jobId
end

local function CreateServerCard(parent, data, titleText)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, 0, 0, 90)
    card.BackgroundColor3 = Color3.fromRGB(22, 23, 31)
    card.BorderSizePixel = 0
    card.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = card

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(105, 90, 190)
    stroke.Thickness = 1
    stroke.Transparency = 0.3
    stroke.Parent = card

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -20, 0, 20)
    title.Position = UDim2.new(0, 10, 0, 5)
    title.BackgroundTransparency = 1
    title.Text = titleText
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 13
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = card

    local playerLabel = Instance.new("TextLabel")
    playerLabel.Size = UDim2.new(1, -20, 0, 16)
    playerLabel.Position = UDim2.new(0, 10, 0, 26)
    playerLabel.BackgroundTransparency = 1
    playerLabel.Text = "Player Count : " .. tostring(data.players or 0)
    playerLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
    playerLabel.TextSize = 11
    playerLabel.Font = Enum.Font.GothamMedium
    playerLabel.TextXAlignment = Enum.TextXAlignment.Left
    playerLabel.Parent = card

    local jobLabel = Instance.new("TextLabel")
    jobLabel.Size = UDim2.new(1, -20, 0, 16)
    jobLabel.Position = UDim2.new(0, 10, 0, 43)
    jobLabel.BackgroundTransparency = 1
    jobLabel.Text = "Jobid : " .. MaskJobId(data.jobid)
    jobLabel.TextColor3 = Color3.fromRGB(145, 145, 175)
    jobLabel.TextSize = 10
    jobLabel.Font = Enum.Font.Gotham
    jobLabel.TextXAlignment = Enum.TextXAlignment.Left
    jobLabel.TextTruncate = Enum.TextTruncate.AtEnd
    jobLabel.Parent = card

    local ageLabel = Instance.new("TextLabel")
    ageLabel.Size = UDim2.new(0, 60, 0, 16)
    ageLabel.Position = UDim2.new(1, -70, 0, 43)
    ageLabel.BackgroundTransparency = 1
    ageLabel.Text = "Age : " .. tostring(data.age or 0) .. "s"
    ageLabel.TextColor3 = Color3.fromRGB(255, 200, 50)
    ageLabel.TextSize = 11
    ageLabel.Font = Enum.Font.GothamBold
    ageLabel.TextXAlignment = Enum.TextXAlignment.Right
    ageLabel.Parent = card

    local joinBtn = Instance.new("TextButton")
    joinBtn.Size = UDim2.new(0, 60, 0, 22)
    joinBtn.Position = UDim2.new(1, -70, 0, 5)
    joinBtn.BackgroundColor3 = Color3.fromRGB(105, 90, 190)
    joinBtn.Text = "Join"
    joinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    joinBtn.TextSize = 11
    joinBtn.Font = Enum.Font.GothamBold
    joinBtn.Parent = card

    local joinCorner = Instance.new("UICorner")
    joinCorner.CornerRadius = UDim.new(0, 4)
    joinCorner.Parent = joinBtn

    joinBtn.MouseButton1Click:Connect(function()
        if _G.YOKUDO_JoinServerByJobId then
            _G.YOKUDO_JoinServerByJobId(data.jobid)
        end
    end)

    return card
end

local function UpdateServerList(serverList, servers, titleText)
    for _, child in ipairs(serverList:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end

    table.sort(servers, function(a, b)
        return a.age < b.age
    end)

    if #servers == 0 then
        local emptyLabel = Instance.new("TextLabel")
        emptyLabel.Size = UDim2.new(1, 0, 0, 30)
        emptyLabel.BackgroundTransparency = 1
        emptyLabel.Text = "No servers found"
        emptyLabel.TextColor3 = Color3.fromRGB(155, 155, 175)
        emptyLabel.TextSize = 12
        emptyLabel.Font = Enum.Font.GothamMedium
        emptyLabel.Parent = serverList
        return
    end

    for i, server in ipairs(servers) do
        CreateServerCard(serverList, server, titleText)
    end
end

local function CreateServerList(parent)
    local serverList = Instance.new("ScrollingFrame")
    serverList.Size = UDim2.new(1, 0, 0, 250)
    serverList.BackgroundTransparency = 1
    serverList.BorderSizePixel = 0
    serverList.ScrollBarThickness = 4
    serverList.ScrollBarImageColor3 = Color3.fromRGB(105, 90, 190)
    serverList.CanvasSize = UDim2.new(0, 0, 0, 0)
    serverList.AutomaticCanvasSize = Enum.AutomaticSize.Y
    serverList.Parent = parent

    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 6)
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Parent = serverList

    return serverList
end

local function CreateRefreshBtn(parent, type, titleText)
    local CooldownTime = 5
    local LastRefreshTime = 0
    local isCooldown = false

    local refreshBtn = Instance.new("TextButton")
    refreshBtn.Size = UDim2.new(1, 0, 0, 30)
    refreshBtn.BackgroundColor3 = Color3.fromRGB(105, 90, 190)
    refreshBtn.Text = "🔄 Refresh Data"
    refreshBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    refreshBtn.TextSize = 12
    refreshBtn.Font = Enum.Font.GothamBold
    refreshBtn.Parent = parent

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = refreshBtn

    local serverList = CreateServerList(parent)

    local function UpdateRefreshButton()
        if isCooldown then
            refreshBtn.Text = "⏳ រង់ចាំ " .. CooldownTime .. "s"
            refreshBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 90)
            refreshBtn.Active = false
        else
            refreshBtn.Text = "🔄 Refresh Data"
            refreshBtn.BackgroundColor3 = Color3.fromRGB(105, 90, 190)
            refreshBtn.Active = true
        end
    end

    refreshBtn.MouseButton1Click:Connect(function()
        if isCooldown then return end

        isCooldown = true
        LastRefreshTime = tick()
        UpdateRefreshButton()

        local servers = LoadDataFromVPS(type)
        UpdateServerList(serverList, servers, titleText)

        task.spawn(function()
            while isCooldown do
                local Elapsed = tick() - LastRefreshTime
                local Remaining = math.ceil(CooldownTime - Elapsed)

                if Remaining <= 0 then
                    isCooldown = false
                    UpdateRefreshButton()
                    break
                else
                    refreshBtn.Text = "⏳ រង់ចាំ " .. Remaining .. "s"
                end

                task.wait(0.1)
            end
        end)
    end)

    return refreshBtn, serverList
end

-- Execute
CreateRefreshBtn(_G.YOKUDO_HakiLegendaryPage, "sea3_haki", "Haki Legendary")
