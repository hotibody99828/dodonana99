-- ==================================================
-- CHARACTER RESPAWN HANDLER (SEA3) - FIXED
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
    
    -- ⭐ Auto Buso (ប្រើ Set មិនមែន Toggle)
    if _G.YOKUDO_BusoEnabled then
        if _G.YOKUDO_SetBuso then
            _G.YOKUDO_SetBuso(true)
        end
    end
    
    -- ⭐ Walk on Water (ប្រើ Set មិនមែន Toggle)
    if _G.YOKUDO_WalkEnabled then
        if _G.YOKUDO_SetWalk then
            _G.YOKUDO_SetWalk(true)
        end
    end
    
    -- ==============================================
    -- ⭐ AUTO RIP INDRA (ប្រើ Set មិនមែន Toggle)
    -- ==============================================
    if _G.YOKUDO_AutoRipIndraEnabled then
        task.spawn(function()
            -- ពិនិត្យ workspace.Enemies["rip_indra True Form"] ភ្លាមៗ
            local enemies = workspace:FindFirstChild("Enemies")
            if enemies then
                local boss = enemies:FindFirstChild("rip_indra True Form")
                if boss and boss:FindFirstChild("Humanoid") then
                    local humanoid = boss.Humanoid
                    if humanoid.Health > 0 then
                        local bossRoot = boss:FindFirstChild("HumanoidRootPart") or boss:FindFirstChild("Torso")
                        if bossRoot then
                            if _G.YOKUDO_TweenToBoss and _G.YOKUDO_AttackTarget then
                                _G.YOKUDO_TweenToBoss(bossRoot.Position, 200)
                                _G.YOKUDO_AttackTarget(boss)
                            end
                        end
                    end
                end
            end
        end)
    end
    
    -- ==============================================
    -- ⭐ AUTO SOUL REAPER (ប្រើ Set មិនមែន Toggle)
    -- ==============================================
    if _G.YOKUDO_AutoSoulReaperEnabled then
        task.spawn(function()
            local enemies = workspace:FindFirstChild("Enemies")
            if enemies then
                local boss = enemies:FindFirstChild("Soul Reaper")
                if boss and boss:FindFirstChild("Humanoid") then
                    local humanoid = boss.Humanoid
                    if humanoid.Health > 0 then
                        local bossRoot = boss:FindFirstChild("HumanoidRootPart") or boss:FindFirstChild("Torso")
                        if bossRoot then
                            if _G.YOKUDO_TweenToBoss and _G.YOKUDO_AttackTarget then
                                _G.YOKUDO_TweenToBoss(bossRoot.Position, 190)
                                _G.YOKUDO_AttackTarget(boss)
                            end
                        end
                    end
                end
            end
        end)
    end
    
    -- ==============================================
    -- ⭐ AUTO DOUGH KING (ប្រើ Set មិនមែន Toggle)
    -- ==============================================
    if _G.YOKUDO_AutoDoughKingEnabled then
        if _G.YOKUDO_SetDoughKing then
            _G.YOKUDO_SetDoughKing(true)
        end
    end
    
    -- ==============================================
    -- ⭐ AUTO CAKE PRINCE (ប្រើ Set មិនមែន Toggle)
    -- ==============================================
    if _G.YOKUDO_AutoCakePrinceEnabled then
        if _G.YOKUDO_SetCakePrince then
            _G.YOKUDO_SetCakePrince(true)
        end
    end
    
    -- ==============================================
    -- ⭐ AUTO ELITE HUNTER (ប្រើ Set មិនមែន Toggle)
    -- ==============================================
    if _G.YOKUDO_AutoEliteHunterEnabled then
        if _G.YOKUDO_SetEliteHunter then
            _G.YOKUDO_SetEliteHunter(true)
        end
    end
    
    -- ==============================================
    -- ⭐ AUTO CLICK ATTACK (ប្រើ Set មិនមែន Toggle)
    -- ==============================================
    if _G.YOKUDO_AutoClickAttackEnabled then
        if _G.YOKUDO_SetClickAttack then
            _G.YOKUDO_SetClickAttack(true)
        end
    end
    
    -- ==============================================
    -- ⭐ AUTO UNLOCK HAKI (ប្រើ Set មិនមែន Toggle)
    -- ==============================================
    if _G.YOKUDO_AutoUnlockHakiEnabled then
        if _G.YOKUDO_SetUnlockHaki then
            _G.YOKUDO_SetUnlockHaki(true)
        end
    end
    
end)

print("✅ CharacterHandler Loaded (FIXED - Using Set Functions)")
