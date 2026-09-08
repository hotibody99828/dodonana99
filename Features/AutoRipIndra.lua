-- ==================================================
-- AUTO RIP INDRA (SEA3) - NO CONFIG - TOGGLE FUNCTION
-- ==================================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local workspace = game:GetService("Workspace")

local Player = Players.LocalPlayer

-- ==================================================
-- PORTAL REMOTE ARGS
-- ==================================================
local PORTAL_ARGS = {"requestEntrance", Vector3.new(-4936.41162109375, 314.50201416015625, -3103.224853515625)}

-- ==================================================
-- TWEEN SPEED
-- ==================================================
local TWEEN_SPEED = 200

-- ==================================================
-- STATE (No Config)
-- ==================================================
local isRunning = false
local loopConnection = nil
local noCollideConnection = nil
local noCollideActive = false
local hasUsedPortal = false

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
local hasTeleportedToBoss = false

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
-- REMOTE PORTAL FUNCTION
-- ==================================================
local function usePortal()
    pcall(function()
        local Remote = ReplicatedStorage:FindFirstChild("Remotes")
        if Remote then
            local CommF = Remote:FindFirstChild("CommF_")
            if CommF then
                CommF:InvokeServer(unpack(PORTAL_ARGS))
                hasUsedPortal = true
                print("✅ Portal used!")
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
-- FIND RIP INDRA BOSS
-- ==================================================
local function findRipIndra()
    -- 1. ពិនិត្យ workspace មុន (Boss នៅជិត)
    local enemies = workspace:FindFirstChild("Enemies")
    if enemies then
        local boss = enemies:FindFirstChild("rip_indra True Form")
        if boss and boss:FindFirstChild("Humanoid") then
            local humanoid = boss.Humanoid
            if humanoid.Health > 0 then
                return boss, "workspace"
            else
                return nil, "dead"
            end
        end
    end
    
    -- 2. ពិនិត្យ ReplicatedStorage (Boss នៅឆ្ងាយ)
    local stored = ReplicatedStorage:FindFirstChild("rip_indra True Form")
    if stored then
        return stored, "replicatedstorage"
    end
    
    return nil, nil
end

-- ==================================================
-- CHECK IF BOSS IS IN WORKSPACE
-- ==================================================
local function isBossInWorkspace()
    local enemies = workspace:FindFirstChild("Enemies")
    if enemies then
        local boss = enemies:FindFirstChild("rip_indra True Form")
        if boss and boss:FindFirstChild("Humanoid") then
            local humanoid = boss.Humanoid
            if humanoid.Health > 0 then
                return true, boss
            end
        end
    end
    return false, nil
end

-- ==================================================
-- MAIN LOOP
-- ==================================================
local function ripIndraLoop()
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
        
        local boss, location = findRipIndra()
        
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
                    hasUsedPortal = false
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
        
        isBossDead = false
        
        -- Equip Weapon
        if _G.YOKUDO_EquipWeaponFromBackpack then
            local weaponType = "Melee"
            if _G.YOKUDO_AutoEquip then
                weaponType = _G.YOKUDO_AutoEquip.SelectedType
            end
            _G.YOKUDO_EquipWeaponFromBackpack(weaponType)
        end
        
        -- ==================================================
        -- CASE 1: Boss នៅជិត (workspace) → Tween ទៅ Attack
        -- ==================================================
        if location == "workspace" then
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
            hasTeleportedToBoss = true
            
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
        
        -- ==================================================
        -- CASE 2: Boss នៅ ReplicatedStorage → Use Portal
        -- ==================================================
        if location == "replicatedstorage" then
            bossFound = false
            isAtPosition = false
            isFollowingBoss = false
            hasTeleportedToBoss = false
            
            -- ប្រើ Portal ប្រសិនបើមិនទាន់បានប្រើ
            if not hasUsedPortal then
                print("🔵 Boss in ReplicatedStorage, using portal...")
                usePortal()
                task.wait(0.5)  -- រង់ចាំ Portal
            end
            
            -- ពិនិត្យមើល Boss ក្នុង workspace ម្ដងទៀត
            local bossInWorkspace, bossObj = isBossInWorkspace()
            
            if bossInWorkspace and bossObj then
                local bossRoot = bossObj:FindFirstChild("HumanoidRootPart") or bossObj:FindFirstChild("Torso")
                if bossRoot then
                    local bossPos = bossRoot.Position
                    bossTarget = bossObj
                    currentBossPos = bossPos
                    bossFound = true
                    isFollowingBoss = true
                    
                    print("✅ Boss found in workspace, tweening to attack...")
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
                end
            else
                -- បើមិនឃើញ Boss ក្នុង workspace រង់ចាំបន្តិច
                task.wait(0.5)
            end
            
            task.wait(0.01)
            continue
        end
    end
end

-- ==================================================
-- ⭐ TOGGLE FUNCTION (No Config - Direct Toggle)
-- ==================================================
function _G.YOKUDO_ToggleAutoRipIndra()
    isRunning = not isRunning
    
    if isRunning then
        hasUsedPortal = false
        hasTeleportedToBoss = false
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
        
        loopConnection = task.spawn(ripIndraLoop)
        print("⚡ Auto Rip Indra Started")
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
        
        isBossDead = false
        bossFound = false
        isAtPosition = false
        isFollowingBoss = false
        isTweeningToPosition = false
        bossTarget = nil
        currentBossPos = nil
        isLocked = false
        hasUsedPortal = false
        hasTeleportedToBoss = false
        print("⚡ Auto Rip Indra Stopped")
    end
    
    -- ⭐ Update UI (No Config)
    if _G.YOKUDO_UpdateUI_RipIndra then
        _G.YOKUDO_UpdateUI_RipIndra(isRunning)
    end
end

-- ==================================================
-- STATE (No Config)
-- ==================================================
_G.YOKUDO_AutoRipIndraEnabled = false

-- ==================================================
-- CHARACTER RESPAWN HANDLER
-- ==================================================
Player.CharacterAdded:Connect(function()
    task.wait(0.5)
    hasUsedPortal = false
    hasTeleportedToBoss = false
    stopNoCollide()
    if isRunning then
        stopTweenTeleport()
    end
end)

print("✅ AutoRipIndra Loaded (SEA3 - No Config - Toggle Function)")
