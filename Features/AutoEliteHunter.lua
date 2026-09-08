-- ==================================================
-- AUTO ELITE HUNTER (SEA3) - NO CONFIG - TOGGLE FUNCTION + DELETE OBSTACLES
-- ==================================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local workspace = game:GetService("Workspace")

local Player = Players.LocalPlayer

-- ==================================================
-- ELITE BOSS CONFIG
-- ==================================================
local ELITE_BOSSES = {
    {Name = "Urban", Path = "Urban"},
    {Name = "Deandre", Path = "Deandre"},
    {Name = "Diablo", Path = "Diablo"},
}

-- ==================================================
-- MAP POSITIONS
-- ==================================================
local MAP_POSITIONS = {
    Port = Vector3.new(-531, 85, 6278),
    Waterfall = Vector3.new(4961, 1070, 102),
    GreatTree = Vector3.new(2546, 567, -8267),
    Turtle = Vector3.new(-12614, 427, -9520),
}

-- ==================================================
-- PORTAL REMOTE ARGS
-- ==================================================
local PORTAL_ARGS = {
    Waterfall = {"requestEntrance", Vector3.new(5700.94775390625, 1013.2747802734375, -277.3791809082031)},
    Turtle = {"requestEntrance", Vector3.new(-12550.6025390625, 337.3270568847656, -7543.0830078125)},
    Port = {"requestEntrance", Vector3.new(-4936.41162109375, 314.50201416015625, -3103.224853515625)},
    GreatTree = {"requestEntrance", Vector3.new(-4936.41162109375, 314.50201416015625, -3103.224853515625)},
}

-- ==================================================
-- TWEEN SPEED
-- ==================================================
local TWEEN_SPEED = 150

-- ==================================================
-- ⭐ DELETE OBSTACLES FUNCTION (WATERFALL)
-- ==================================================
local function deleteObstacles()
    pcall(function()
        local Map = workspace:FindFirstChild("Map")
        if not Map then return end
        
        local Waterfall = Map:FindFirstChild("Waterfall")
        if not Waterfall then return end
        
        local IslandModel = Waterfall:FindFirstChild("IslandModel")
        if not IslandModel then return end
        
        -- 1. Delete IslandChunks.E.rock3
        local IslandChunks = IslandModel:FindFirstChild("IslandChunks")
        if IslandChunks then
            local E = IslandChunks:FindFirstChild("E")
            if E then
                -- rock3
                local rock3 = E:FindFirstChild("rock3")
                if rock3 then
                    rock3:Destroy()
                    print("🗑️ Deleted: rock3")
                end
                
                -- rock2 (GetChildren()[14].rock2)
                local children = E:GetChildren()
                if children and children[14] then
                    local rock2 = children[14]:FindFirstChild("rock2")
                    if rock2 then
                        rock2:Destroy()
                        print("🗑️ Deleted: rock2")
                    end
                end
                
                -- Delete by index
                local indicesToDelete = {95, 97, 96, 71, 104}
                for _, idx in ipairs(indicesToDelete) do
                    local childrenList = E:GetChildren()
                    if childrenList and childrenList[idx] then
                        childrenList[idx]:Destroy()
                        print("🗑️ Deleted: GetChildren()[" .. idx .. "]")
                    end
                end
            end
            
            -- D['Meshes/amazonfixes2_Sphere.069']
            local D = IslandChunks:FindFirstChild("D")
            if D then
                for _, child in ipairs(D:GetChildren()) do
                    if child.Name and string.find(child.Name, "amazonfixes2_Sphere.069") then
                        child:Destroy()
                        print("🗑️ Deleted: amazonfixes2_Sphere.069")
                    end
                end
            end
        end
        
        -- 2. IslandModel:GetChildren()[45]["Meshes/mountainfixes_Sphere.037"]
        local modelChildren = IslandModel:GetChildren()
        if modelChildren and modelChildren[45] then
            local child45 = modelChildren[45]
            if child45 then
                for _, subChild in ipairs(child45:GetChildren()) do
                    if subChild.Name and string.find(subChild.Name, "mountainfixes_Sphere.037") then
                        subChild:Destroy()
                        print("🗑️ Deleted: mountainfixes_Sphere.037")
                    end
                end
            end
        end
        
        print("✅ Obstacles deleted successfully!")
    end)
end

-- ==================================================
-- ⭐ DELETE OBSTACLES WITH RETRY
-- ==================================================
local function deleteObstaclesWithRetry()
    task.spawn(function()
        local maxRetry = 5
        local retryCount = 0
        while retryCount < maxRetry do
            pcall(deleteObstacles)
            retryCount = retryCount + 1
            task.wait(0.5)
        end
    end)
end

-- ==================================================
-- STATE (No Config)
-- ==================================================
local isRunning = false
local loopConnection = nil
local noCollideConnection = nil
local noCollideActive = false
local invokeCount = 0
local lastInvokeTime = 0
local INVOKE_COOLDOWN = 2
local obstaclesDeleted = false

-- ==================================================
-- TWEEN TELEPORT VARIABLES
-- ==================================================
local currentTween = nil
local bodyVelocity = nil
local bodyGyro = nil
local isTweening = false
local lockConnection = nil
local isLocked = false
local currentBossPos = nil
local followConnection = nil
local bossTarget = nil
local isBossDead = false
local isTweeningToPosition = false
local bossFound = false
local isAtPosition = false
local isFollowingBoss = false

-- ==================================================
-- NO COLLIDE FUNCTIONS
-- ==================================================
local function applyNoCollide()
    local character = Player.Character
    if not character then return end
    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end
end

local function startNoCollide()
    if noCollideConnection then return end
    if noCollideActive then return end
    noCollideActive = true
    applyNoCollide()
    noCollideConnection = RunService.Heartbeat:Connect(function()
        if not noCollideActive then return end
        applyNoCollide()
    end)
end

local function stopNoCollide()
    noCollideActive = false
    if noCollideConnection then
        noCollideConnection:Disconnect()
        noCollideConnection = nil
    end
    local character = Player.Character
    if character then
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end

-- ==================================================
-- ⭐ ELITE HUNTER INVOKE (តែ ២ ដង)
-- ==================================================
local function invokeEliteHunter()
    local currentTime = tick()
    if currentTime - lastInvokeTime < INVOKE_COOLDOWN then
        return false
    end
    if invokeCount >= 2 then
        return false
    end
    
    pcall(function()
        local Remote = ReplicatedStorage:FindFirstChild("Remotes")
        if Remote then
            local CommF = Remote:FindFirstChild("CommF_")
            if CommF then
                CommF:InvokeServer("EliteHunter")
                invokeCount = invokeCount + 1
                lastInvokeTime = currentTime
                print("✅ EliteHunter Invoked! (" .. invokeCount .. "/2)")
                return true
            end
        end
    end)
    return false
end

-- ==================================================
-- RESET INVOKE COUNT
-- ==================================================
local function resetInvokeCount()
    invokeCount = 0
    lastInvokeTime = 0
end

-- ==================================================
-- REMOTE PORTAL FUNCTION
-- ==================================================
local function usePortal(mapName)
    local args = PORTAL_ARGS[mapName]
    if not args then return false end
    pcall(function()
        local Remote = ReplicatedStorage:FindFirstChild("Remotes")
        if Remote then
            local CommF = Remote:FindFirstChild("CommF_")
            if CommF then
                CommF:InvokeServer(unpack(args))
                return true
            end
        end
    end)
    return false
end

-- ==================================================
-- TWEEN TELEPORT FUNCTIONS
-- ==================================================
local function cleanupBody()
    if bodyVelocity then
        bodyVelocity:Destroy()
        bodyVelocity = nil
    end
    if bodyGyro then
        bodyGyro:Destroy()
        bodyGyro = nil
    end
    if currentTween then
        currentTween:Cancel()
        currentTween = nil
    end
    if followConnection then
        followConnection:Disconnect()
        followConnection = nil
    end
    isTweening = false
    isLocked = false
    isTweeningToPosition = false
end

local function stopTweenTeleport()
    cleanupBody()
    if lockConnection then
        lockConnection:Disconnect()
        lockConnection = nil
    end
    isLocked = false
    currentBossPos = nil
    bossTarget = nil
    isTweeningToPosition = false
    stopNoCollide()
end

local function stopTweenToPosition()
    if currentTween then
        currentTween:Cancel()
        currentTween = nil
    end
    if followConnection then
        followConnection:Disconnect()
        followConnection = nil
    end
    isTweening = false
    isTweeningToPosition = false
    if bodyVelocity then
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    end
end

local function tweenToBoss(bossPos, speed)
    local character = Player.Character
    if not character then return false end
    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then return false end
    local humanoid = character:FindFirstChild("Humanoid")
    if humanoid and humanoid.Health <= 0 then return false end
    
    if currentTween then
        currentTween:Cancel()
        currentTween = nil
    end
    if followConnection then
        followConnection:Disconnect()
        followConnection = nil
    end
    isTweening = false
    isTweeningToPosition = false
    
    if lockConnection then
        lockConnection:Disconnect()
        lockConnection = nil
    end
    isLocked = false
    
    startNoCollide()
    
    local targetPos = Vector3.new(bossPos.X, bossPos.Y + 30, bossPos.Z)
    local distance = (targetPos - root.Position).Magnitude
    if distance < 3 then 
        if bodyVelocity then
            bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        end
        stopNoCollide()
        return true 
    end
    
    local duration = math.max(0.5, distance / speed)
    local direction = (targetPos - root.Position).Unit
    
    if not bodyVelocity then
        bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(1, 1, 1) * 10000
        bodyVelocity.Parent = root
    end
    bodyVelocity.Velocity = direction * speed
    
    if not bodyGyro then
        bodyGyro = Instance.new("BodyGyro")
        bodyGyro.MaxTorque = Vector3.new(1, 1, 1) * 10000
        bodyGyro.Parent = root
    end
    bodyGyro.CFrame = CFrame.lookAt(root.Position, targetPos)
    
    local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
    currentTween = TweenService:Create(root, tweenInfo, {CFrame = CFrame.new(targetPos)})
    isTweening = true
    currentTween:Play()
    currentTween.Completed:Wait()
    
    if bodyVelocity then
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    end
    
    if not isTweening then
        stopNoCollide()
        return false
    end
    
    stopNoCollide()
    return true
end

-- ==================================================
-- FIND CLOSEST MAP
-- ==================================================
local function findClosestMap(bossPos)
    local closestMap = nil
    local closestDist = math.huge
    for mapName, mapPos in pairs(MAP_POSITIONS) do
        local dist = (bossPos - mapPos).Magnitude
        if dist < closestDist then
            closestDist = dist
            closestMap = mapName
        end
    end
    return closestMap
end

-- ==================================================
-- FIND ELITE BOSS
-- ==================================================
local function findEliteBoss()
    local enemies = workspace:FindFirstChild("Enemies")
    if enemies then
        for _, boss in ipairs(ELITE_BOSSES) do
            local bossObj = enemies:FindFirstChild(boss.Path)
            if bossObj and bossObj:FindFirstChild("Humanoid") then
                local humanoid = bossObj.Humanoid
                if humanoid.Health > 0 then
                    return bossObj, "workspace", boss.Name
                end
            end
        end
    end
    
    for _, boss in ipairs(ELITE_BOSSES) do
        local stored = ReplicatedStorage:FindFirstChild(boss.Path)
        if stored then
            return stored, "replicatedstorage", boss.Name
        end
    end
    
    return nil, nil, nil
end

-- ==================================================
-- GET BOSS POSITION
-- ==================================================
local function getBossPosition(boss)
    if boss:IsA("Model") then
        local root = boss:FindFirstChild("HumanoidRootPart") or boss:FindFirstChild("Torso")
        if root then
            return root.Position
        end
    else
        local pos = boss:FindFirstChild("Position")
        if pos then
            return pos.Value
        end
        local cframe = boss:FindFirstChild("CFrame")
        if cframe then
            return cframe.Value.Position
        end
    end
    return nil
end

-- ==================================================
-- MAIN LOOP
-- ==================================================
local function eliteHunterLoop()
    while isRunning do
        -- ⭐ លុប Obstacles (ធ្វើម្ដង)
        if not obstaclesDeleted then
            deleteObstaclesWithRetry()
            obstaclesDeleted = true
        end
        
        local character = Player.Character
        if not character then
            task.wait(0.01)
            continue
        end
        
        local root = character:FindFirstChild("HumanoidRootPart")
        if not root then
            task.wait(0.01)
            continue
        end
        
        local boss, location, bossName = findEliteBoss()
        
        if not boss then
            bossFound = false
            isAtPosition = false
            isFollowingBoss = false
            task.wait(0.01)
            continue
        end
        
        -- Equip Weapon
        if _G.YOKUDO_EquipWeaponFromBackpack then
            local weaponType = "Melee"
            if _G.YOKUDO_AutoEquip then
                weaponType = _G.YOKUDO_AutoEquip.SelectedType
            end
            _G.YOKUDO_EquipWeaponFromBackpack(weaponType)
        end
        
        if location == "workspace" then
            -- ⭐ ប្រសិនបើឃើញ Boss ក្នុង workspace → Invoke EliteHunter
            if invokeCount < 2 then
                invokeEliteHunter()
            end
            
            if isTweeningToPosition then
                stopTweenToPosition()
                isTweeningToPosition = false
            end
            
            local bossRoot = boss:FindFirstChild("HumanoidRootPart") or boss:FindFirstChild("Torso")
            if not bossRoot then
                task.wait(0.01)
                continue
            end
            
            local bossPos = bossRoot.Position
            bossTarget = boss
            currentBossPos = bossPos
            bossFound = true
            isFollowingBoss = true
            
            local dist = (bossPos - root.Position).Magnitude
            
            if dist > 60 then
                tweenToBoss(bossPos, TWEEN_SPEED)
                
                if followConnection then
                    followConnection:Disconnect()
                    followConnection = nil
                end
                
                followConnection = RunService.Heartbeat:Connect(function()
                    if not isRunning then
                        if followConnection then
                            followConnection:Disconnect()
                            followConnection = nil
                        end
                        return
                    end
                    
                    if not bossTarget or not bossTarget.Parent then
                        return
                    end
                    
                    local bossRoot = bossTarget:FindFirstChild("HumanoidRootPart") or bossTarget:FindFirstChild("Torso")
                    if not bossRoot then return end
                    
                    local currentBossPos = bossRoot.Position
                    local char = Player.Character
                    if not char then return end
                    
                    local rootPart = char:FindFirstChild("HumanoidRootPart")
                    if not rootPart then return end
                    
                    local lockPos = Vector3.new(currentBossPos.X, currentBossPos.Y + 30, currentBossPos.Z)
                    
                    local distToLock = (lockPos - rootPart.Position).Magnitude
                    if distToLock > 5 then
                        rootPart.CFrame = CFrame.new(lockPos)
                    end
                    
                    local distToBoss = (currentBossPos - rootPart.Position).Magnitude
                    if distToBoss <= 60 then
                        if _G.YOKUDO_AttackTarget then
                            _G.YOKUDO_AttackTarget(bossTarget)
                        end
                    end
                end)
                isLocked = true
            else
                if _G.YOKUDO_AttackTarget then
                    _G.YOKUDO_AttackTarget(boss)
                end
            end
            task.wait(0.01)
            continue
        end
        
        if location == "replicatedstorage" then
            bossFound = false
            isAtPosition = false
            isFollowingBoss = false
            
            -- ⭐ ប្រសិនបើ Boss នៅ ReplicatedStorage → Invoke EliteHunter
            if invokeCount < 2 then
                invokeEliteHunter()
            end
            
            local bossPos = getBossPosition(boss)
            if not bossPos then
                task.wait(0.01)
                continue
            end
            
            local closestMap = findClosestMap(bossPos)
            if not closestMap then
                task.wait(0.01)
                continue
            end
            
            usePortal(closestMap)
            task.wait(0.10)
            tweenToBoss(bossPos, TWEEN_SPEED)
            
            if followConnection then
                followConnection:Disconnect()
                followConnection = nil
            end
            
            followConnection = RunService.Heartbeat:Connect(function()
                if not isRunning then
                    if followConnection then
                        followConnection:Disconnect()
                        followConnection = nil
                    end
                    return
                end
                
                if not bossTarget or not bossTarget.Parent then
                    return
                end
                
                local bossRoot = bossTarget:FindFirstChild("HumanoidRootPart") or bossTarget:FindFirstChild("Torso")
                if not bossRoot then return end
                
                local currentBossPos = bossRoot.Position
                local char = Player.Character
                if not char then return end
                
                local rootPart = char:FindFirstChild("HumanoidRootPart")
                if not rootPart then return end
                
                local lockPos = Vector3.new(currentBossPos.X, currentBossPos.Y + 30, currentBossPos.Z)
                
                local distToLock = (lockPos - rootPart.Position).Magnitude
                if distToLock > 5 then
                    rootPart.CFrame = CFrame.new(lockPos)
                end
                
                local distToBoss = (currentBossPos - rootPart.Position).Magnitude
                if distToBoss <= 60 then
                    if _G.YOKUDO_AttackTarget then
                        _G.YOKUDO_AttackTarget(bossTarget)
                    end
                end
            end)
            isLocked = true
            task.wait(0.01)
            continue
        end
    end
end

-- ==================================================
-- ⭐ TOGGLE FUNCTION (No Config - Direct Toggle)
-- ==================================================
function _G.YOKUDO_ToggleAutoEliteHunter()
    isRunning = not isRunning
    
    if isRunning then
        obstaclesDeleted = false
        resetInvokeCount()
        isBossDead = false
        bossFound = false
        isAtPosition = false
        isFollowingBoss = false
        isTweeningToPosition = false
        
        if followConnection then
            followConnection:Disconnect()
            followConnection = nil
        end
        
        if loopConnection then
            loopConnection:Disconnect()
            loopConnection = nil
        end
        
        loopConnection = task.spawn(eliteHunterLoop)
        print("✅ Auto Elite Hunter Started")
        print("🗑️ Will delete obstacles at Waterfall...")
    else
        if loopConnection then
            task.cancel(loopConnection)
            loopConnection = nil
        end
        
        if followConnection then
            followConnection:Disconnect()
            followConnection = nil
        end
        
        stopTweenTeleport()
        resetInvokeCount()
        
        isBossDead = false
        bossFound = false
        isAtPosition = false
        isFollowingBoss = false
        isTweeningToPosition = false
        bossTarget = nil
        currentBossPos = nil
        isLocked = false
        obstaclesDeleted = false
        print("❌ Auto Elite Hunter Stopped")
    end
    
    -- ⭐ Update UI (No Config)
    if _G.YOKUDO_UpdateUI_EliteHunter then
        _G.YOKUDO_UpdateUI_EliteHunter(isRunning)
    end
end

-- ==================================================
-- STATE (No Config)
-- ==================================================
_G.YOKUDO_AutoEliteHunterEnabled = false

-- ==================================================
-- CHARACTER RESPAWN HANDLER
-- ==================================================
Player.CharacterAdded:Connect(function()
    task.wait(0.5)
    resetInvokeCount()
    stopNoCollide()
    if isRunning then
        stopTweenTeleport()
    end
end)

print("✅ AutoEliteHunter Loaded (SEA3 - No Config - Toggle Function + Delete Obstacles)")
