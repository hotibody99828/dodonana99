-- ==================================================
-- CONFIG SETTINGS (SEA3)
-- ==================================================

_G.YOKUDO = {
    Name = "YOKUDO HUB | SEA3 | [Premium]",
    Version = "1.0",
    Author = "Yokudo",
    
    -- Asset
    AssetID = "rbxassetid://101352576986760",
    
    -- UI
    UI = {
        Width = 480,
        Height = 340,
        SidebarWidth = 115,
        TabHeight = 32,
        Theme = {
            Background = Color3.fromRGB(16, 17, 23),
            Sidebar = Color3.fromRGB(20, 21, 28),
            TopBar = Color3.fromRGB(23, 24, 32),
            Accent = Color3.fromRGB(105, 90, 190),
            Text = Color3.fromRGB(255, 255, 255),
            SubText = Color3.fromRGB(145, 145, 165),
        }
    },
    
    -- Default Settings
    Defaults = {
        AttackRange = 60,
        Speed = 16,
        Jump = 50,
    }
}

print("✅ Settings Loaded")
