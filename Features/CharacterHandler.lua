-- ==================================================
-- CHARACTER RESPAWN HANDLER (SEA3) - NO CONFIG
-- ==================================================

local Player = _G.YOKUDO.Player

Player.OnCharacterAdded(function()
    task.wait(0.5)
    
    -- Speed Hack
    if _G.YOKUDO_SpeedEnabled then
        if _G.YOKUDO_StartSpeedLoop then
            _G.YOKUDO_StartSpeedLoop()
        end
    end
    
    -- Jump Hack
    if _G.YOKUDO_JumpEnabled then
        if _G.YOKUDO_EnableJumpPower then
            _G.YOKUDO_EnableJumpPower()
        end
    end
    
    -- ⭐ Auto Buso
    if _G.YOKUDO_BusoEnabled then
        if _G.YOKUDO_ToggleAutoBuso then
            _G.YOKUDO_ToggleAutoBuso()
        end
    end
    
    -- ⭐ Walk on Water
    if _G.YOKUDO_WalkEnabled then
        if _G.YOKUDO_ToggleWalkOnWater then
            _G.YOKUDO_ToggleWalkOnWater()
        end
    end
    
    -- ==============================================
    -- AUTO BOSS FEATURES
    -- ==============================================
    
    -- Auto Dough King
    if _G.YOKUDO_AutoDoughKingEnabled then
        if _G.YOKUDO_ToggleAutoDoughKing then
            _G.YOKUDO_ToggleAutoDoughKing()
        end
    end
    
    -- Auto Rip Indra
    if _G.YOKUDO_AutoRipIndraEnabled then
        if _G.YOKUDO_ToggleAutoRipIndra then
            _G.YOKUDO_ToggleAutoRipIndra()
        end
    end
    
    -- Auto Cake Prince
    if _G.YOKUDO_AutoCakePrinceEnabled then
        if _G.YOKUDO_ToggleAutoCakePrince then
            _G.YOKUDO_ToggleAutoCakePrince()
        end
    end
    
    -- Auto Soul Reaper
    if _G.YOKUDO_AutoSoulReaperEnabled then
        if _G.YOKUDO_ToggleAutoSoulReaper then
            _G.YOKUDO_ToggleAutoSoulReaper()
        end
    end
    
    -- Auto Elite Hunter
    if _G.YOKUDO_AutoEliteHunterEnabled then
        if _G.YOKUDO_ToggleAutoEliteHunter then
            _G.YOKUDO_ToggleAutoEliteHunter()
        end
    end
    
    -- ==============================================
    -- AUTO ABILITIES
    -- ==============================================
    
    -- Auto Ken
    if _G.YOKUDO_ObservationEnabled then
        if _G.YOKUDO_ToggleAutoKen then
            _G.YOKUDO_ToggleAutoKen()
        end
    end
    
    -- ==============================================
    -- AUTO CLICK ATTACK
    -- ==============================================
    if _G.YOKUDO_AutoClickAttackEnabled then
        if _G.YOKUDO_ToggleAutoClickAttack then
            _G.YOKUDO_ToggleAutoClickAttack()
        end
    end
    
    -- ==============================================
    -- SHOP FEATURES
    -- ==============================================
    
    -- Auto Unlock Haki
    if _G.YOKUDO_AutoUnlockHakiEnabled then
        if _G.YOKUDO_ToggleAutoUnlockHaki then
            _G.YOKUDO_ToggleAutoUnlockHaki()
        end
    end
    
    -- ==============================================
    -- AUTO HOP FEATURES
    -- ==============================================
    
    -- Auto Hop Dough King
    if _G.YOKUDO_AutoHopDoughKingEnabled then
        if _G.YOKUDO_ToggleAutoHopDoughKing then
            _G.YOKUDO_ToggleAutoHopDoughKing()
        end
    end
    
    -- Auto Hop Rip Indra
    if _G.YOKUDO_AutoHopRipIndraEnabled then
        if _G.YOKUDO_ToggleAutoHopRipIndra then
            _G.YOKUDO_ToggleAutoHopRipIndra()
        end
    end
    
    -- Auto Hop Cake Prince
    if _G.YOKUDO_AutoHopCakePrinceEnabled then
        if _G.YOKUDO_ToggleAutoHopCakePrince then
            _G.YOKUDO_ToggleAutoHopCakePrince()
        end
    end
    
    -- Auto Hop Soul Reaper
    if _G.YOKUDO_AutoHopSoulReaperEnabled then
        if _G.YOKUDO_ToggleAutoHopSoulReaper then
            _G.YOKUDO_ToggleAutoHopSoulReaper()
        end
    end
    
    -- Auto Hop Elite Hunter
    if _G.YOKUDO_AutoHopEliteHunterEnabled then
        if _G.YOKUDO_ToggleAutoHopEliteHunter then
            _G.YOKUDO_ToggleAutoHopEliteHunter()
        end
    end
end)

print("✅ CharacterHandler Loaded (SEA3 - No Config)")
