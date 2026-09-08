-- ==================================================
-- AUTO BUSO HAKI (SEA3) - ជាមួយ Config Save
-- ==================================================

local Y = _G.Y
local Player = _G.YOKUDO.Player

_G.YOKUDO_BusoEnabled = false
_G.YOKUDO_BusoLoopConnection = nil
_G.YOKUDO_BusoCharConnection = nil

local function IsBusoOn()
    local username = Player.Local.Name
    local character = Y.WS:FindFirstChild("Characters") and Y.WS.Characters:FindFirstChild(username)
    if character then
        return character:FindFirstChild("HasBuso") ~= nil
    end
    return false
end

local function TurnOnBuso()
    local Remote = Y.Replicated:FindFirstChild("Remotes")
    if Remote then
        local CommF = Remote:FindFirstChild("CommF_")
        if CommF then
            pcall(function()
                CommF:InvokeServer("Buso")
            end)
        end
    end
end

function startAutoBuso()
    if _G.YOKUDO_BusoLoopConnection then return end
    TurnOnBuso()
    _G.YOKUDO_BusoLoopConnection = Y.RS.Stepped:Connect(function()
        if not _G.YOKUDO_BusoEnabled then return end
        if not IsBusoOn() then
            TurnOnBuso()
        end
    end)
    _G.YOKUDO_BusoCharConnection = Player.OnCharacterAdded(function()
        task.wait(0.5)
        if _G.YOKUDO_BusoEnabled then TurnOnBuso() end
    end)
end

function stopAutoBuso()
    if _G.YOKUDO_BusoLoopConnection then 
        _G.YOKUDO_BusoLoopConnection:Disconnect() 
        _G.YOKUDO_BusoLoopConnection = nil 
    end
    if _G.YOKUDO_BusoCharConnection then 
        _G.YOKUDO_BusoCharConnection:Disconnect() 
        _G.YOKUDO_BusoCharConnection = nil 
    end
end

-- ==================================================
-- ⭐ SET FUNCTION (សម្រាប់ ConfigManager)
-- ==================================================
function _G.YOKUDO_SetBuso(enabled)
    if enabled == _G.YOKUDO_BusoEnabled then return end
    
    _G.YOKUDO_BusoEnabled = enabled
    if enabled then
        startAutoBuso()
        print("✅ Auto Buso: ON (Config)")
    else
        stopAutoBuso()
        print("❌ Auto Buso: OFF (Config)")
    end
    
    -- Update UI
    if _G.YOKUDO_UpdateUI_Buso then
        _G.YOKUDO_UpdateUI_Buso(enabled)
    end
    
    -- Save Config
    if _G.YOKUDO_UpdateConfig then
        _G.YOKUDO_UpdateConfig("AutoBuso", enabled)
    end
end

-- ==================================================
-- TOGGLE FUNCTION (សម្រាប់ User Click)
-- ==================================================
function _G.YOKUDO_ToggleAutoBuso()
    _G.YOKUDO_SetBuso(not _G.YOKUDO_BusoEnabled)
end

-- ==================================================
-- STATE (ប្រើ or false ដើម្បីកុំឲ្យ Reset)
-- ==================================================
_G.YOKUDO_BusoEnabled = _G.YOKUDO_BusoEnabled or false

print("✅ AutoBuso Loaded (Config Ready - With Set)")
