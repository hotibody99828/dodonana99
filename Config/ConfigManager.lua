-- ==================================================
-- CONFIG MANAGER (SEA3 - Save/Load) - WITH SET FUNCTIONS
-- ==================================================

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer

-- ==================================================
-- CONFIG PATH
-- ==================================================
local CONFIG_FOLDER = "YOKUDOSEA3/"
local CONFIG_FILE = CONFIG_FOLDER .. Player.Name .. ".json"

pcall(function()
    if makefolder then
        makefolder(CONFIG_FOLDER)
    end
end)

-- ==================================================
-- DEFAULT CONFIG
-- ==================================================
local DEFAULT = {
    -- Movement Hacks
    WalkOnWater = false,
    
    -- Auto Abilities
    AutoBuso = false,
    
    -- Shop
    AutoUnlockHaki = false,
    
    -- Combat
    AutoClickAttack = false,
    
    -- Farm Bosses
    AutoDoughKing = false,
    AutoRipIndra = false,
    AutoCakePrince = false,
    AutoSoulReaper = false,
    AutoEliteHunter = false,
    
    -- Weapon
    WeaponType = "Melee",
}

-- ==================================================
-- INIT
-- ==================================================
_G.YOKUDO_Config = _G.YOKUDO_Config or {}

-- ==================================================
-- LOAD CONFIG
-- ==================================================
function _G.YOKUDO_LoadConfig()
    print("📁 Loading config for: " .. Player.Name)
    print("📁 Config file: " .. CONFIG_FILE)
    
    local json = nil
    
    if readfile then
        local ok, data = pcall(readfile, CONFIG_FILE)
        if ok then json = data end
    elseif syn and syn.crypt then
        local ok, data = pcall(syn.crypt.custom_readfile, CONFIG_FILE)
        if ok then json = data end
    end
    
    if json and json ~= "" then
        local config = HttpService:JSONDecode(json)
        if config then
            for k, v in pairs(DEFAULT) do
                _G.YOKUDO_Config[k] = config[k] ~= nil and config[k] or v
            end
            print("✅ Config Loaded for: " .. Player.Name)
            print("   WalkOnWater: " .. tostring(_G.YOKUDO_Config.WalkOnWater))
            print("   AutoBuso: " .. tostring(_G.YOKUDO_Config.AutoBuso))
            print("   AutoUnlockHaki: " .. tostring(_G.YOKUDO_Config.AutoUnlockHaki))
            print("   AutoClickAttack: " .. tostring(_G.YOKUDO_Config.AutoClickAttack))
            print("   AutoDoughKing: " .. tostring(_G.YOKUDO_Config.AutoDoughKing))
            print("   AutoRipIndra: " .. tostring(_G.YOKUDO_Config.AutoRipIndra))
            print("   AutoCakePrince: " .. tostring(_G.YOKUDO_Config.AutoCakePrince))
            print("   AutoSoulReaper: " .. tostring(_G.YOKUDO_Config.AutoSoulReaper))
            print("   AutoEliteHunter: " .. tostring(_G.YOKUDO_Config.AutoEliteHunter))
            print("   WeaponType: " .. tostring(_G.YOKUDO_Config.WeaponType))
            return
        end
    end
    
    print("📁 No config found for: " .. Player.Name .. ", creating default...")
    for k, v in pairs(DEFAULT) do
        _G.YOKUDO_Config[k] = v
    end
    _G.YOKUDO_SaveConfig()
end

-- ==================================================
-- SAVE CONFIG
-- ==================================================
function _G.YOKUDO_SaveConfig()
    local json = HttpService:JSONEncode(_G.YOKUDO_Config)
    
    if writefile then
        writefile(CONFIG_FILE, json)
    elseif syn and syn.crypt then
        syn.crypt.custom_writefile(CONFIG_FILE, json)
    end
    
    print("✅ Config Saved for: " .. Player.Name)
    print("   AutoSoulReaper: " .. tostring(_G.YOKUDO_Config.AutoSoulReaper))
end

-- ==================================================
-- UPDATE SINGLE CONFIG
-- ==================================================
function _G.YOKUDO_UpdateConfig(key, value)
    _G.YOKUDO_Config[key] = value
    _G.YOKUDO_SaveConfig()
end

-- ==================================================
-- CHECK FEATURE READY
-- ==================================================
local function IsFeatureReady(featureName)
    if featureName == "AutoBuso" then
        return _G.YOKUDO_SetBuso ~= nil
    elseif featureName == "WalkOnWater" then
        return _G.YOKUDO_SetWalk ~= nil or _G.YOKUDO_ToggleWalkOnWater ~= nil
    elseif featureName == "AutoUnlockHaki" then
        return _G.YOKUDO_SetUnlockHaki ~= nil or _G.YOKUDO_ToggleAutoUnlockHaki ~= nil
    elseif featureName == "AutoClickAttack" then
        return _G.YOKUDO_SetClickAttack ~= nil or _G.YOKUDO_ToggleAutoClickAttack ~= nil
    elseif featureName == "AutoDoughKing" then
        return _G.YOKUDO_SetDoughKing ~= nil or _G.YOKUDO_ToggleAutoDoughKing ~= nil
    elseif featureName == "AutoRipIndra" then
        return _G.YOKUDO_SetRipIndra ~= nil or _G.YOKUDO_ToggleAutoRipIndra ~= nil
    elseif featureName == "AutoCakePrince" then
        return _G.YOKUDO_SetCakePrince ~= nil or _G.YOKUDO_ToggleAutoCakePrince ~= nil
    elseif featureName == "AutoSoulReaper" then
        return _G.YOKUDO_SetSoulReaper ~= nil or _G.YOKUDO_ToggleAutoSoulReaper ~= nil
    elseif featureName == "AutoEliteHunter" then
        return _G.YOKUDO_SetEliteHunter ~= nil or _G.YOKUDO_ToggleAutoEliteHunter ~= nil
    end
    return false
end

-- ==================================================
-- APPLY CONFIG WITH RETRY (ប្រើ Set Functions)
-- ==================================================
function _G.YOKUDO_ApplyConfig()
    print("🔄 Applying config for: " .. Player.Name)
    
    local c = _G.YOKUDO_Config
    
    -- ==============================================
    -- WALK ON WATER
    -- ==============================================
    local walkState = c.WalkOnWater
    if _G.YOKUDO_SetWalk then
        _G.YOKUDO_SetWalk(walkState)
        print("✅ Walk on Water set to: " .. tostring(walkState))
    else
        print("⚠️ Walk on Water Set function not ready, will retry...")
        task.spawn(function()
            local maxRetry = 5
            local retryCount = 0
            while retryCount < maxRetry do
                task.wait(0.5)
                retryCount = retryCount + 1
                if _G.YOKUDO_SetWalk then
                    _G.YOKUDO_SetWalk(walkState)
                    print("✅ Walk on Water set to: " .. tostring(walkState) .. " (retry " .. retryCount .. ")")
                    break
                end
            end
        end)
    end
    if _G.YOKUDO_UpdateUI_Walk then
        _G.YOKUDO_UpdateUI_Walk(walkState)
    end
    
    -- ==============================================
    -- AUTO BUSO
    -- ==============================================
    local busoState = c.AutoBuso
    if _G.YOKUDO_SetBuso then
        _G.YOKUDO_SetBuso(busoState)
        print("✅ Auto Buso set to: " .. tostring(busoState))
    else
        print("⚠️ Auto Buso Set function not ready, will retry...")
        task.spawn(function()
            local maxRetry = 5
            local retryCount = 0
            while retryCount < maxRetry do
                task.wait(0.5)
                retryCount = retryCount + 1
                if _G.YOKUDO_SetBuso then
                    _G.YOKUDO_SetBuso(busoState)
                    print("✅ Auto Buso set to: " .. tostring(busoState) .. " (retry " .. retryCount .. ")")
                    break
                end
            end
        end)
    end
    if _G.YOKUDO_UpdateUI_Buso then
        _G.YOKUDO_UpdateUI_Buso(busoState)
    end
    
    -- ==============================================
    -- AUTO UNLOCK HAKI (ប្រើ Set Function)
    -- ==============================================
    local unlockHakiState = c.AutoUnlockHaki
    if _G.YOKUDO_SetUnlockHaki then
        _G.YOKUDO_SetUnlockHaki(unlockHakiState)
        print("✅ Auto Unlock Haki set to: " .. tostring(unlockHakiState))
    elseif _G.YOKUDO_ToggleAutoUnlockHaki then
        if unlockHakiState and not _G.YOKUDO_AutoUnlockHakiEnabled then
            _G.YOKUDO_ToggleAutoUnlockHaki()
            print("✅ Auto Unlock Haki started from config")
        elseif not unlockHakiState and _G.YOKUDO_AutoUnlockHakiEnabled then
            _G.YOKUDO_ToggleAutoUnlockHaki()
            print("❌ Auto Unlock Haki stopped from config")
        end
    else
        print("⚠️ Auto Unlock Haki not ready, will retry...")
        task.spawn(function()
            local maxRetry = 5
            local retryCount = 0
            while retryCount < maxRetry do
                task.wait(0.5)
                retryCount = retryCount + 1
                if _G.YOKUDO_SetUnlockHaki then
                    _G.YOKUDO_SetUnlockHaki(unlockHakiState)
                    print("✅ Auto Unlock Haki set to: " .. tostring(unlockHakiState) .. " (retry " .. retryCount .. ")")
                    break
                elseif _G.YOKUDO_ToggleAutoUnlockHaki then
                    if unlockHakiState and not _G.YOKUDO_AutoUnlockHakiEnabled then
                        _G.YOKUDO_ToggleAutoUnlockHaki()
                        print("✅ Auto Unlock Haki started from config (retry " .. retryCount .. ")")
                    elseif not unlockHakiState and _G.YOKUDO_AutoUnlockHakiEnabled then
                        _G.YOKUDO_ToggleAutoUnlockHaki()
                        print("❌ Auto Unlock Haki stopped from config (retry " .. retryCount .. ")")
                    end
                    break
                end
            end
        end)
    end
    if _G.YOKUDO_UpdateUI_UnlockHaki then
        _G.YOKUDO_UpdateUI_UnlockHaki(unlockHakiState)
    end
    
    -- ==============================================
    -- AUTO CLICK ATTACK (ប្រើ Set Function)
    -- ==============================================
    local clickState = c.AutoClickAttack
    if _G.YOKUDO_SetClickAttack then
        _G.YOKUDO_SetClickAttack(clickState)
        print("✅ Auto Click Attack set to: " .. tostring(clickState))
    elseif _G.YOKUDO_ToggleAutoClickAttack then
        if clickState and not _G.YOKUDO_AutoClickAttackEnabled then
            _G.YOKUDO_ToggleAutoClickAttack()
            print("✅ Auto Click Attack started from config")
        elseif not clickState and _G.YOKUDO_AutoClickAttackEnabled then
            _G.YOKUDO_ToggleAutoClickAttack()
            print("❌ Auto Click Attack stopped from config")
        end
    else
        print("⚠️ Auto Click Attack not ready, will retry...")
        task.spawn(function()
            local maxRetry = 5
            local retryCount = 0
            while retryCount < maxRetry do
                task.wait(0.5)
                retryCount = retryCount + 1
                if _G.YOKUDO_SetClickAttack then
                    _G.YOKUDO_SetClickAttack(clickState)
                    print("✅ Auto Click Attack set to: " .. tostring(clickState) .. " (retry " .. retryCount .. ")")
                    break
                elseif _G.YOKUDO_ToggleAutoClickAttack then
                    if clickState and not _G.YOKUDO_AutoClickAttackEnabled then
                        _G.YOKUDO_ToggleAutoClickAttack()
                        print("✅ Auto Click Attack started from config (retry " .. retryCount .. ")")
                    elseif not clickState and _G.YOKUDO_AutoClickAttackEnabled then
                        _G.YOKUDO_ToggleAutoClickAttack()
                        print("❌ Auto Click Attack stopped from config (retry " .. retryCount .. ")")
                    end
                    break
                end
            end
        end)
    end
    if _G.YOKUDO_UpdateUI_ClickAttack then
        _G.YOKUDO_UpdateUI_ClickAttack(clickState)
    end
    
    -- ==============================================
    -- AUTO DOUGH KING (ប្រើ Set Function)
    -- ==============================================
    local doughKingState = c.AutoDoughKing
    if _G.YOKUDO_SetDoughKing then
        _G.YOKUDO_SetDoughKing(doughKingState)
        print("✅ Auto Dough King set to: " .. tostring(doughKingState))
    elseif _G.YOKUDO_ToggleAutoDoughKing then
        if doughKingState and not _G.YOKUDO_AutoDoughKingEnabled then
            _G.YOKUDO_ToggleAutoDoughKing()
            print("✅ Auto Dough King started from config")
        elseif not doughKingState and _G.YOKUDO_AutoDoughKingEnabled then
            _G.YOKUDO_ToggleAutoDoughKing()
            print("❌ Auto Dough King stopped from config")
        end
    else
        print("⚠️ Auto Dough King not ready, will retry...")
        task.spawn(function()
            local maxRetry = 5
            local retryCount = 0
            while retryCount < maxRetry do
                task.wait(0.5)
                retryCount = retryCount + 1
                if _G.YOKUDO_SetDoughKing then
                    _G.YOKUDO_SetDoughKing(doughKingState)
                    print("✅ Auto Dough King set to: " .. tostring(doughKingState) .. " (retry " .. retryCount .. ")")
                    break
                elseif _G.YOKUDO_ToggleAutoDoughKing then
                    if doughKingState and not _G.YOKUDO_AutoDoughKingEnabled then
                        _G.YOKUDO_ToggleAutoDoughKing()
                        print("✅ Auto Dough King started from config (retry " .. retryCount .. ")")
                    elseif not doughKingState and _G.YOKUDO_AutoDoughKingEnabled then
                        _G.YOKUDO_ToggleAutoDoughKing()
                        print("❌ Auto Dough King stopped from config (retry " .. retryCount .. ")")
                    end
                    break
                end
            end
        end)
    end
    if _G.YOKUDO_UpdateUI_DoughKing then
        _G.YOKUDO_UpdateUI_DoughKing(doughKingState)
    end
    
    -- ==============================================
    -- AUTO RIP INDRA (ប្រើ Set Function)
    -- ==============================================
    local ripIndraState = c.AutoRipIndra
    if _G.YOKUDO_SetRipIndra then
        _G.YOKUDO_SetRipIndra(ripIndraState)
        print("✅ Auto Rip Indra set to: " .. tostring(ripIndraState))
    elseif _G.YOKUDO_ToggleAutoRipIndra then
        if ripIndraState and not _G.YOKUDO_AutoRipIndraEnabled then
            _G.YOKUDO_ToggleAutoRipIndra()
            print("✅ Auto Rip Indra started from config")
        elseif not ripIndraState and _G.YOKUDO_AutoRipIndraEnabled then
            _G.YOKUDO_ToggleAutoRipIndra()
            print("❌ Auto Rip Indra stopped from config")
        end
    else
        print("⚠️ Auto Rip Indra not ready, will retry...")
        task.spawn(function()
            local maxRetry = 5
            local retryCount = 0
            while retryCount < maxRetry do
                task.wait(0.5)
                retryCount = retryCount + 1
                if _G.YOKUDO_SetRipIndra then
                    _G.YOKUDO_SetRipIndra(ripIndraState)
                    print("✅ Auto Rip Indra set to: " .. tostring(ripIndraState) .. " (retry " .. retryCount .. ")")
                    break
                elseif _G.YOKUDO_ToggleAutoRipIndra then
                    if ripIndraState and not _G.YOKUDO_AutoRipIndraEnabled then
                        _G.YOKUDO_ToggleAutoRipIndra()
                        print("✅ Auto Rip Indra started from config (retry " .. retryCount .. ")")
                    elseif not ripIndraState and _G.YOKUDO_AutoRipIndraEnabled then
                        _G.YOKUDO_ToggleAutoRipIndra()
                        print("❌ Auto Rip Indra stopped from config (retry " .. retryCount .. ")")
                    end
                    break
                end
            end
        end)
    end
    if _G.YOKUDO_UpdateUI_RipIndra then
        _G.YOKUDO_UpdateUI_RipIndra(ripIndraState)
    end
    
    -- ==============================================
    -- AUTO CAKE PRINCE (ប្រើ Set Function)
    -- ==============================================
    local cakePrinceState = c.AutoCakePrince
    if _G.YOKUDO_SetCakePrince then
        _G.YOKUDO_SetCakePrince(cakePrinceState)
        print("✅ Auto Cake Prince set to: " .. tostring(cakePrinceState))
    elseif _G.YOKUDO_ToggleAutoCakePrince then
        if cakePrinceState and not _G.YOKUDO_AutoCakePrinceEnabled then
            _G.YOKUDO_ToggleAutoCakePrince()
            print("✅ Auto Cake Prince started from config")
        elseif not cakePrinceState and _G.YOKUDO_AutoCakePrinceEnabled then
            _G.YOKUDO_ToggleAutoCakePrince()
            print("❌ Auto Cake Prince stopped from config")
        end
    else
        print("⚠️ Auto Cake Prince not ready, will retry...")
        task.spawn(function()
            local maxRetry = 5
            local retryCount = 0
            while retryCount < maxRetry do
                task.wait(0.5)
                retryCount = retryCount + 1
                if _G.YOKUDO_SetCakePrince then
                    _G.YOKUDO_SetCakePrince(cakePrinceState)
                    print("✅ Auto Cake Prince set to: " .. tostring(cakePrinceState) .. " (retry " .. retryCount .. ")")
                    break
                elseif _G.YOKUDO_ToggleAutoCakePrince then
                    if cakePrinceState and not _G.YOKUDO_AutoCakePrinceEnabled then
                        _G.YOKUDO_ToggleAutoCakePrince()
                        print("✅ Auto Cake Prince started from config (retry " .. retryCount .. ")")
                    elseif not cakePrinceState and _G.YOKUDO_AutoCakePrinceEnabled then
                        _G.YOKUDO_ToggleAutoCakePrince()
                        print("❌ Auto Cake Prince stopped from config (retry " .. retryCount .. ")")
                    end
                    break
                end
            end
        end)
    end
    if _G.YOKUDO_UpdateUI_CakePrince then
        _G.YOKUDO_UpdateUI_CakePrince(cakePrinceState)
    end
    
    -- ==============================================
    -- AUTO SOUL REAPER (ប្រើ Set Function)
    -- ==============================================
    local soulReaperState = c.AutoSoulReaper
    if _G.YOKUDO_SetSoulReaper then
        _G.YOKUDO_SetSoulReaper(soulReaperState)
        print("✅ Auto Soul Reaper set to: " .. tostring(soulReaperState))
    elseif _G.YOKUDO_ToggleAutoSoulReaper then
        if soulReaperState and not _G.YOKUDO_AutoSoulReaperEnabled then
            _G.YOKUDO_ToggleAutoSoulReaper()
            print("✅ Auto Soul Reaper started from config")
        elseif not soulReaperState and _G.YOKUDO_AutoSoulReaperEnabled then
            _G.YOKUDO_ToggleAutoSoulReaper()
            print("❌ Auto Soul Reaper stopped from config")
        end
    else
        print("⚠️ Auto Soul Reaper not ready, will retry...")
        task.spawn(function()
            local maxRetry = 5
            local retryCount = 0
            while retryCount < maxRetry do
                task.wait(0.5)
                retryCount = retryCount + 1
                if _G.YOKUDO_SetSoulReaper then
                    _G.YOKUDO_SetSoulReaper(soulReaperState)
                    print("✅ Auto Soul Reaper set to: " .. tostring(soulReaperState) .. " (retry " .. retryCount .. ")")
                    break
                elseif _G.YOKUDO_ToggleAutoSoulReaper then
                    if soulReaperState and not _G.YOKUDO_AutoSoulReaperEnabled then
                        _G.YOKUDO_ToggleAutoSoulReaper()
                        print("✅ Auto Soul Reaper started from config (retry " .. retryCount .. ")")
                    elseif not soulReaperState and _G.YOKUDO_AutoSoulReaperEnabled then
                        _G.YOKUDO_ToggleAutoSoulReaper()
                        print("❌ Auto Soul Reaper stopped from config (retry " .. retryCount .. ")")
                    end
                    break
                end
            end
        end)
    end
    if _G.YOKUDO_UpdateUI_SoulReaper then
        _G.YOKUDO_UpdateUI_SoulReaper(soulReaperState)
    end
    
    -- ==============================================
    -- AUTO ELITE HUNTER (ប្រើ Set Function)
    -- ==============================================
    local eliteHunterState = c.AutoEliteHunter
    if _G.YOKUDO_SetEliteHunter then
        _G.YOKUDO_SetEliteHunter(eliteHunterState)
        print("✅ Auto Elite Hunter set to: " .. tostring(eliteHunterState))
    elseif _G.YOKUDO_ToggleAutoEliteHunter then
        if eliteHunterState and not _G.YOKUDO_AutoEliteHunterEnabled then
            _G.YOKUDO_ToggleAutoEliteHunter()
            print("✅ Auto Elite Hunter started from config")
        elseif not eliteHunterState and _G.YOKUDO_AutoEliteHunterEnabled then
            _G.YOKUDO_ToggleAutoEliteHunter()
            print("❌ Auto Elite Hunter stopped from config")
        end
    else
        print("⚠️ Auto Elite Hunter not ready, will retry...")
        task.spawn(function()
            local maxRetry = 5
            local retryCount = 0
            while retryCount < maxRetry do
                task.wait(0.5)
                retryCount = retryCount + 1
                if _G.YOKUDO_SetEliteHunter then
                    _G.YOKUDO_SetEliteHunter(eliteHunterState)
                    print("✅ Auto Elite Hunter set to: " .. tostring(eliteHunterState) .. " (retry " .. retryCount .. ")")
                    break
                elseif _G.YOKUDO_ToggleAutoEliteHunter then
                    if eliteHunterState and not _G.YOKUDO_AutoEliteHunterEnabled then
                        _G.YOKUDO_ToggleAutoEliteHunter()
                        print("✅ Auto Elite Hunter started from config (retry " .. retryCount .. ")")
                    elseif not eliteHunterState and _G.YOKUDO_AutoEliteHunterEnabled then
                        _G.YOKUDO_ToggleAutoEliteHunter()
                        print("❌ Auto Elite Hunter stopped from config (retry " .. retryCount .. ")")
                    end
                    break
                end
            end
        end)
    end
    if _G.YOKUDO_UpdateUI_EliteHunter then
        _G.YOKUDO_UpdateUI_EliteHunter(eliteHunterState)
    end
    
    -- ==============================================
    -- WEAPON TYPE
    -- ==============================================
    local weaponType = c.WeaponType or "Melee"
    if _G.YOKUDO_SetWeaponType then
        _G.YOKUDO_SetWeaponType(weaponType)
        print("✅ Weapon Type applied from config: " .. weaponType)
    end
    
    print("✅ Config applied for: " .. Player.Name)
end

-- ==================================================
-- LOAD CONFIG ON START
-- ==================================================
_G.YOKUDO_LoadConfig()

print("✅ ConfigManager Loaded (with Set Functions & Retry System)")
print("📁 Config file: " .. CONFIG_FILE)
