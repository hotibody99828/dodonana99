-- ==================================================
-- WEAPON SELECTOR WATCHER (SEA3) - Save/Load Only
-- ==================================================

local AutoHopPage = _G.YOKUDO_AutoHopPage

-- ==================================================
-- ⭐ UPDATE WEAPON BUTTON (សម្រាប់ Config Load)
-- ==================================================
function _G.YOKUDO_UpdateWeaponButton(weaponType)
    if not AutoHopPage then return end
    for _, child in ipairs(AutoHopPage:GetDescendants()) do
        if child.Name == "WeaponButton" then
            child.Text = weaponType
            print("✅ Weapon Button updated to: " .. weaponType)
            return
        end
    end
end

-- ==================================================
-- ⭐ SET WEAPON TYPE (សម្រាប់ Config Load - មិន Equip)
-- ==================================================
function _G.YOKUDO_SetWeaponType(weaponType)
    if not weaponType or weaponType == "" then
        weaponType = "Melee"
    end
    
    _G.YOKUDO_AutoEquip.SelectedType = weaponType
    
    -- Update UI (តែប៉ុណ្ណោះ)
    if _G.YOKUDO_UpdateWeaponButton then
        _G.YOKUDO_UpdateWeaponButton(weaponType)
    end
    
    -- ❌ លុប Equip ចេញ
    -- if _G.YOKUDO_EquipWeaponFromBackpack then
    --     _G.YOKUDO_EquipWeaponFromBackpack(weaponType)
    -- end
    
    -- Save Config
    if _G.YOKUDO_UpdateConfig then
        _G.YOKUDO_UpdateConfig("WeaponType", weaponType)
    end
    
    print("✅ Weapon Type set to: " .. weaponType .. " (UI Updated)")
end

-- ==================================================
-- WATCH DROPDOWN (តាមដានការផ្លាស់ប្ដូរ - មិន Equip)
-- ==================================================
local function setupWeaponSelectorWatcher()
    task.wait(0.5)
    local weaponButton = nil
    if AutoHopPage then
        for _, child in ipairs(AutoHopPage:GetDescendants()) do
            if child.Name == "WeaponButton" then
                weaponButton = child
                break
            end
        end
    end
    
    if weaponButton then
        weaponButton:GetPropertyChangedSignal("Text"):Connect(function()
            local newType = weaponButton.Text
            if newType ~= _G.YOKUDO_AutoEquip.SelectedType then
                _G.YOKUDO_AutoEquip.SelectedType = newType
                
                -- ❌ លុប Equip ចេញ
                -- if _G.YOKUDO_EquipWeaponFromBackpack then
                --     _G.YOKUDO_EquipWeaponFromBackpack(newType)
                -- end
                
                -- ⭐ Save to Config
                if _G.YOKUDO_UpdateConfig then
                    _G.YOKUDO_UpdateConfig("WeaponType", newType)
                    print("✅ Weapon Type saved to config: " .. newType)
                end
            end
        end)
    end
end

task.spawn(function()
    task.wait(1)
    setupWeaponSelectorWatcher()
end)

print("✅ WeaponWatcher Loaded (Save/Load Only - No Equip)")
