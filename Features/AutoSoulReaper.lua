-- ==================================================
-- AUTO SOUL REAPER (ជាមួយ Config Save) - FINAL
-- ==================================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local workspace = game:GetService("Workspace")

local Player = Players.LocalPlayer

-- ==================================================
-- POSITIONS
-- ==================================================
local SOUL_REAPER_BYPASS = Vector3.new(-12465, 376, -7563)
local SOUL_REAPER_TWEEN = Vector3.new(-9524, 327, 6660)

-- ==================================================
-- TWEEN SPEED
-- ==================================================
local TWEEN_SPEED = 180
local DISTANCE_THRESHOLD = 3000

-- ==================================================
-- STATE (ដូច AutoRipIndra)
-- ==================================================
local isRunning = false
local loopConnection = nil
local noCollideConnection = nil
local noCollideActive = false
local hasUsedPortal = false
local hasTweenedToPosition = false
local isInvoking = false
local invokeLoopConnection = nil
local spawnPointCheckConnection = nil

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
-- GET SPAWN POINT
-- ==================================================
local function getSpawnPoint()
    local success, result = pcall(function()
        local data = Player:FindFirstChild("Data")
        if data then
            local lastSpawnPoint = data:FindFirstChild("LastSpawnPoint")
            if lastSpawnPoint then
                return lastSpawnPoint.Value
            end
        end
        return ""
    end)
    return success and result or ""
end

-- ==================================================
-- SET SPAWN POINT
-- ==================================================
local function setSpawnPoint(location)
    local Event = ReplicatedStorage:FindFirstChild("Remotes")
    if Event then
        local CommF = Event:FindFirstChild("CommF_")
        if CommF then
            pcall(function()
                CommF:InvokeServer("SetLastSpawnPoint", location)
            end)
        end
    end
end

-- ==================================================
-- GET DISTANCE TO TWEEN POSITION
-- ==================================================
local function getDistanceToTweenPosition()
    local character = Player.Character
    if not character then return 99999 end
    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then return 99999 end
    return (SOUL_REAPER_TWEEN - root.Position).Magnitude
end

-- ==================================================
-- RESET STATE
-- ==================================================
local function resetState()
    hasUsedPortal = false
    hasTweenedToPosition = false
end

-- ==================================================
-- INVOKE LOOP
-- ==================================================
local function startInvokeLoop()
    if isInvoking then return end
    isInvoking = true
    invokeLoopConnection = RunService.Heartbeat:Connect(function()
        if not isRunning then
            stopInvokeLoop()
            return
        end
        local enemies = workspace:FindFirstChild("Enemies")
        if enemies then
            local boss = enemies:FindFirstChild("Soul Reaper")
            if boss and boss:FindFirstChild("Humanoid") then
                local humanoid = boss.Humanoid
                if humanoid.Health > 0 then
                    stopInvokeLoop()
                    return
                end
            end
        end
        setSpawnPoint("HauntedCastle")
    end)
end

local function stopInvokeLoop()
    isInvoking = false
    if invokeLoopConnection then
        invokeLoopConnection:Disconnect()
        invokeLoopConnection = nil
    end
end

-- ==================================================
-- CHECK SPAWN POINT
-- ==================================================
local function startSpawnPointCheck()
    if spawnPointCheckConnection then return end
    spawnPointCheckConnection = RunService.Heartbeat:Connect(function()
        if not isRunning then
            stopSpawnPointCheck()
            return
        end
        local enemies = workspace:FindFirstChild("Enemies")
        if enemies then
            local boss = enemies:FindFirstChild("Soul Reaper")
            if boss and boss:FindFirstChild("Humanoid") then
                local humanoid = boss.Humanoid
                if humanoid.Health > 0 then
                    stopSpawnPointCheck()
                    return
                end
            end
        end
        local spawnPoint = getSpawnPoint()
        if spawnPoint == "HauntedCastle" then
            local character = Player.Character
            if character then
                local humanoid = character:FindFirstChild("Humanoid")
                if humanoid then
                    humanoid.Health = 0
                    task.wait(0.01)
                    setSpawnPoint("HauntedCastle")
                    startInvokeLoop()
                end
            end
        end
    end)
end

local function stopSpawnPointCheck()
    if spawnPointCheckConnection then
        spawnPointCheckConnection:Disconnect()
        spawnPointCheckConnection = nil
    end
end

-- ==================================================
-- BYPASS TELEPORT
-- ==================================================
local function bypassTeleport(targetPos)
    local character = Player.Character
    if not character then return false end
    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then return false end
    local humanoid = character:FindFirstChild("Humanoid")
    if humanoid and humanoid.Health <= 0 then return false end
    root.CFrame = CFrame.new(targetPos)
    hasUsedPortal = true
    return true
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

local function tweenToPosition(targetPos, speed)
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
    isTweeningToPosition = true
    
    if lockConnection then
        lockConnection:Disconnect()
        lockConnection = nil
    end
    isLocked = false
    
    startNoCollide()
    
    local distance = (targetPos - root.Position).Magnitude
    if distance < 3 then 
        isTweeningToPosition = false
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
        isTweeningToPosition = false
        stopNoCollide()
        return false
    end
    
    isTweeningToPosition = false
    stopNoCollide()
    return true
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
    
    local duration = math.max(0.10, distance / speed)
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
-- FIND SOUL REAPER BOSS
-- ==================================================
local function findSoulReaper()
    local enemies = workspace:FindFirstChild("Enemies")
    if enemies then
        local boss = enemies:FindFirstChild("Soul Reaper")
        if boss and boss:FindFirstChild("Humanoid") then
            local humanoid = boss.Humanoid
            if humanoid.Health > 0 then
                return boss, "workspace"
            else
                return nil, "dead"
            end
        end
    end
    
    local stored = ReplicatedStorage:FindFirstChild("Soul Reaper")
    if stored then
        return stored, "replicatedstorage"
    end
    
    return nil, nil
end

-- ==================================================
-- MAIN LOOP (ប្រើ isRunning)
-- ==================================================
local function soulReaperLoop()
    while isRunning do
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
        
        local boss, location = findSoulReaper()
        
        if location == "replicatedstorage" then
            local distance = getDistanceToTweenPosition()
            
            if distance > DISTANCE_THRESHOLD then
                if not hasUsedPortal then
                    bypassTeleport(SOUL_REAPER_BYPASS)
                end
                if hasUsedPortal and not hasTweenedToPosition then
                    task.wait(3)
                    tweenToPosition(SOUL_REAPER_TWEEN, TWEEN_SPEED)
                    hasTweenedToPosition = true
                    startInvokeLoop()
                    startSpawnPointCheck()
                end
            else
                if not hasTweenedToPosition then
                    tweenToPosition(SOUL_REAPER_TWEEN, TWEEN_SPEED)
                    hasTweenedToPosition = true
                    startInvokeLoop()
                    startSpawnPointCheck()
                end
            end
            task.wait(0.01)
            continue
        end
        
        if location == "workspace" then
            stopInvokeLoop()
            stopSpawnPointCheck()
            
            if isTweeningToPosition then
                stopTweenToPosition()
                isTweeningToPosition = false
            end
            
            -- Equip Weapon
            if _G.YOKUDO_EquipWeaponFromBackpack then
                local weaponType = "Melee"
                if _G.YOKUDO_AutoEquip then
                    weaponType = _G.YOKUDO_AutoEquip.SelectedType
                end
                _G.YOKUDO_EquipWeaponFromBackpack(weaponType)
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
        
        if not boss then
            if location == "dead" then
                if not isBossDead then
                    isBossDead = true
                    cleanupBody()
                    if followConnection then
                        followConnection:Disconnect()
                        followConnection = nil
                    end
                    isFollowingBoss = false
                    isTweeningToPosition = false
                    resetState()
                end
                task.wait(5)
                isBossDead = false
                continue
            end
            bossFound = false
            isAtPosition = false
            isFollowingBoss = false
            task.wait(0.01)
            continue
        end
    end
end

-- ==================================================
-- TOGGLE FUNCTION (ដូច AutoRipIndra)
-- ==================================================
function _G.YOKUDO_ToggleAutoSoulReaper()
    isRunning = not isRunning
    _G.YOKUDO_AutoSoulReaperEnabled = isRunning
    
    if isRunning then
        hasUsedPortal = false
        hasTweenedToPosition = false
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
        
        loopConnection = task.spawn(soulReaperLoop)
        print("💀 Auto Soul Reaper Started")
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
        stopInvokeLoop()
        stopSpawnPointCheck()
        
        isBossDead = false
        bossFound = false
        isAtPosition = false
        isFollowingBoss = false
        isTweeningToPosition = false
        bossTarget = nil
        currentBossPos = nil
        isLocked = false
        print("💀 Auto Soul Reaper Stopped")
    end
    
    -- ⭐ Update UI
    if _G.YOKUDO_UpdateUI_SoulReaper then
        _G.YOKUDO_UpdateUI_SoulReaper(isRunning)
    end
    
    -- ⭐ Save Config
    if _G.YOKUDO_UpdateConfig then
        _G.YOKUDO_UpdateConfig("AutoSoulReaper", isRunning)
    end
end

-- ==================================================
-- ⭐ SET FUNCTION (សម្រាប់ ConfigManager)
-- ==================================================
function _G.YOKUDO_SetSoulReaper(enabled)
    if enabled == isRunning then return end
    _G.YOKUDO_ToggleAutoSoulReaper()
end

-- ==================================================
-- STATE (ប្រើ or false ដើម្បីកុំឲ្យ Reset)
-- ==================================================
_G.YOKUDO_AutoSoulReaperEnabled = _G.YOKUDO_AutoSoulReaperEnabled or false

-- ==================================================
-- CHARACTER RESPAWN HANDLER
-- ==================================================
Player.CharacterAdded:Connect(function()
    task.wait(0.5)
    resetState()
    stopNoCollide()
    if isRunning then
        tweenToPosition(SOUL_REAPER_TWEEN, TWEEN_SPEED)
        hasTweenedToPosition = true
        startInvokeLoop()
        startSpawnPointCheck()
        stopTweenTeleport()
    end
end)

print("✅ AutoSoulReaper Loaded (Config Ready)")
