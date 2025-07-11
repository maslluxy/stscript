--[[
    Optimized & Fixed by Gemini
    Version: 2.1
    Date: 2025-07-04
    
    Summary of Improvements:
    - Noclip function has been rewritten to be reliable by using a controlled RunService loop.
    - Centralized service management.
    - Combined game data into a single, structured table for easier management.
    - Made the auto-farm teleport safer by capturing the starting position on-demand.
    - Improved code structure and added comments for better readability.
    - Added a user-configurable teleport delay.
]]

--// DEPENDENCIES
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

--// SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")

--// LOCAL PLAYER
local LocalPlayer = Players.LocalPlayer

--// SCRIPT CONFIG & DATA
local GameData = {
    [95508886069297] = { Name = "Slap Tower", Waypoints = {
        Vector3.new(-22.836, -10.696, 106.735), Vector3.new(-186.091, 769.303, 68.362),
        Vector3.new(183.885, -10.696, 81.003), Vector3.new(-20.662, -10.696, 19.133)
    }},
    [79089892790758] = { Name = "Slap Tower 2", Waypoints = {
        Vector3.new(36.821, 4, 4.976), Vector3.new(-339.738, 4, -4.854),
        Vector3.new(162.139, 4, -27.676), Vector3.new(4.081, 354, 321.704)
    }},
    [105612566642310] = { Name = "Slap Tower 3", Waypoints = {
        Vector3.new(18.035, 4, 68.766), Vector3.new(16.240, 4, -157.492),
        Vector3.new(184.256, 4, -2.320), Vector3.new(-226.947, 354, 38.531)
    }},
    [86082995079744] = { Name = "Slap Tower 4", Waypoints = {
        Vector3.new(51.702, -3.031, 6.154), Vector3.new(-33.109, -18.031, -33.673),
        Vector3.new(27.168, -3.031, -187.073), Vector3.new(14.734, 597, 172.204)
    }},
    [93924136437619] = { Name = "Slap Tower 5", Waypoints = {
        Vector3.new(-59.981, -10.697, 49.672), Vector3.new(-27.809, 339.253, -173.783)
    }},
    [120759571391756] = { Name = "Slap Tower 6", Waypoints = {
        Vector3.new(64.42, -9.43, 111.52), Vector3.new(-142.28, 593.05, 76.05)
    }},
    [83312952548612] = { Name = "Troll Is A Pinning Tower 2", Waypoints = {
        Vector3.new(272.64, 347.15, -32.93)
    }},
    [88049480741001] = { Name = "Troll Is A Pinning Tower 4", Waypoints = {
        Vector3.new(353.89, 338.42, 56.05)
    }},
    [105692451124462] = { Name = "Troll Bomb Tower", Waypoints = {
        Vector3.new(567.81, 465.26, -161.32)
    }},
    [128635262479351] = { Name = "Troll Laser Tower", Waypoints = {
        Vector3.new(-31.90, 390.51, -213.14), Vector3.new(-71.36, -7.65, 55.77)
    }}
}

local currentPlaceId = game.PlaceId
local currentGameInfo = GameData[currentPlaceId]

--// FLUENT UI SETUP
local Window = Fluent:CreateWindow({
    Title = "TowerHub 0.0.2 (Fixed)",
    SubTitle = "by masploitz",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Universal = Window:AddTab({ Title = "Universal", Icon = "flash" }),
    Main = Window:AddTab({ Title = "Main", Icon = "home" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local Options = Fluent.Options -- For easy access to UI option values

--// FUNCTIONS

-- Gets the local player's humanoid safely.
local function getHumanoid()
    local character = LocalPlayer.Character
    if character then
        return character:FindFirstChildOfClass("Humanoid")
    end
    return nil
end

-- Sets a property on the humanoid (e.g., WalkSpeed, JumpPower)
local function setHumanoidProperty(property, value)
    local humanoid = getHumanoid()
    local numberValue = tonumber(value)
    if humanoid and numberValue then
        humanoid[property] = numberValue
        if property == "JumpPower" then
            humanoid.UseJumpPower = true -- Required for JumpPower to take effect
        end
    end
end

-- Noclip state and management
local noclipConnection = nil

local function handleNoclip(enabled)
    if enabled then
        -- If the connection doesn't exist, create it.
        if not noclipConnection then
            noclipConnection = RunService.Stepped:Connect(function()
                local character = LocalPlayer.Character
                if character then
                    for _, part in ipairs(character:GetDescendants()) do
                        if part:IsA("BasePart") and part.CanCollide then
                            part.CanCollide = false
                        end
                    end
                end
            end)
        end
    else
        -- If the connection exists, disconnect it.
        if noclipConnection then
            noclipConnection:Disconnect()
            noclipConnection = nil
            Fluent:Notify({
                Title = "Noclip Disabled",
                Content = "Please respawn your character to fully restore collisions.",
                Duration = 5
            })
        end
    end
end


-- Anti-AFK (no changes needed, this is efficient)
LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

--// UI ELEMENTS & CALLBACKS

-- Main Tab
if currentGameInfo then
    Tabs.Main:AddParagraph({
        Title = "Welcome to " .. currentGameInfo.Name,
        Content = "The script is configured for this game. All features in this tab are available."
    })
    
    Tabs.Main:AddSlider("TeleportDelay", {
        Title = "Teleport Delay (Seconds)",
        Description = "Delay between each waypoint teleport.",
        Default = 0,
        Min = 0,
        Max = 5,
        Rounding = 1
    })

    Tabs.Main:AddButton({
        Title = "Auto Get Slaps/Win",
        Callback = function()
            local humanoid = getHumanoid()
            local hrp = humanoid and humanoid.RootPart
            if not hrp then
                Fluent:Notify({ Title = "Error", Content = "Could not find your character.", Duration = 5 })
                return
            end

            local originalCFrame = hrp.CFrame -- Save position right before teleporting
            local waypoints = currentGameInfo.Waypoints
            local tpWait = Options.TeleportDelay.Value

            -- Teleport loop
            for _, position in ipairs(waypoints) do
                hrp.CFrame = CFrame.new(position)
                task.wait(tpWait)
            end

            -- Return to original position
            hrp.CFrame = originalCFrame
            Fluent:Notify({ Title = "Finished", Content = "Teleport sequence complete.", Duration = 5 })
        end
    })
else
    Tabs.Main:AddParagraph({
        Title = "Unsupported Game",
        Content = "The current game is not supported by the Main tab features. You can still use the Universal and Settings tabs."
    })
end

-- Universal Tab
Tabs.Universal:AddInput("WalkSpeedInput", {
    Title = "WalkSpeed", Default = "16", Placeholder = "Enter speed", Numeric = true
})
Tabs.Universal:AddButton({
    Title = "Apply WalkSpeed",
    Callback = function() setHumanoidProperty("WalkSpeed", Options.WalkSpeedInput.Value) end
})

Tabs.Universal:AddInput("JumpPowerInput", {
    Title = "JumpPower", Default = "50", Placeholder = "Enter jump height", Numeric = true
})
Tabs.Universal:AddButton({
    Title = "Apply JumpPower",
    Callback = function() setHumanoidProperty("JumpPower", Options.JumpPowerInput.Value) end
})

Tabs.Universal:AddToggle("NoclipToggle", {
    Title = "Noclip",
    Description = "Allows you to fly through objects. Requires a respawn to disable fully.",
    Default = false,
    Callback = function(state) handleNoclip(state) end
})


--// INITIALIZATION & SAVE MANAGEMENT
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)

SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
InterfaceManager:SetFolder("TowerHub") -- Simplified folder name
SaveManager:SetFolder("TowerHub/SaveData")

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

Window:SelectTab(1)

Fluent:Notify({
    Title = "Loaded",
    Content = "TowerHub (Fixed) has been loaded.",
    Duration = 5
})

SaveManager:LoadAutoloadConfig()
