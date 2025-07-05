--[[
    Optimized & Fixed by masploitz
    Version: 0.0.6
    Date: 4/7/25
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
    Title = "TowerHub 0.0.8",
    SubTitle = "by masploitz",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Universal = Window:AddTab({ Title = "Universal", Icon = "" }),
    Main = Window:AddTab({ Title = "Main", Icon = "home" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local Options = Fluent.Options

--// UTILS
local function getHumanoid()
    local character = LocalPlayer.Character
    if character then
        return character:FindFirstChildOfClass("Humanoid")
    end
    return nil
end

local function setHumanoidProperty(property, value)
    local humanoid = getHumanoid()
    local numberValue = tonumber(value)
    if humanoid and numberValue then
        humanoid[property] = numberValue
        if property == "JumpPower" then
            humanoid.UseJumpPower = true
        end
    end
end

local noclipConnection = nil

local function handleNoclip(enabled)
    if enabled then
        Fluent:Notify({ Title = "Noclip Enabled", Content = "You can now walk through walls.", Duration = 3 })
        if not noclipConnection then
            noclipConnection = RunService.Stepped:Connect(function()
                local character = LocalPlayer.Character
                if character then
                    for _, part in ipairs(character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end)
        end
    else
        if noclipConnection then
            noclipConnection:Disconnect()
            noclipConnection = nil
            Fluent:Notify({ Title = "Noclip Disabled", Content = "Noclip mode has been disabled.", Duration = 3 })
        end
    end
end

LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

-- Main Tab Setup
if currentGameInfo then
    Tabs.Main:AddParagraph({
        Title = "You're in " .. currentGameInfo.Name,
        Content = "The script is configured for this game. All features in this tab are available."
    })

    Tabs.Main:AddSlider("TeleportDelay", {
        Title = "TP Delay (Seconds)",
        Description = "Delay between each TP’s.",
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
            local originalCFrame = hrp.CFrame
            local tpWait = Options.TeleportDelay.Value
            for _, pos in ipairs(currentGameInfo.Waypoints) do
                hrp.CFrame = CFrame.new(pos)
                task.wait(tpWait)
            end
            hrp.CFrame = originalCFrame
            Fluent:Notify({ Title = "Finished", Content = "Teleport sequence complete.", Duration = 5 })
        end
    })

    -- Anti-Troll Logic
    local targetColors = {
        Color3.fromRGB(237, 234, 234),
        Color3.fromRGB(99, 95, 98)
    }
    local matchedParts = {}
    local forceCollisionsEnabled = false

    local function isTargetColor(color)
        for _, t in ipairs(targetColors) do
            if color == t then return true end
        end
        return false
    end

    local function scanForParts()
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") and isTargetColor(obj.Color) then
                if not table.find(matchedParts, obj) then
                    table.insert(matchedParts, obj)
                end
            end
        end
    end

    scanForParts()

    Tabs.Main:AddToggle("AntiTroll", {
        Title = "Anti-Troll",
        Description = "Keep trollers from doing their j*b!",
        Default = false,
        Callback = function(state)
            forceCollisionsEnabled = state
            local status = state and "enabled" or "disabled"
            Fluent:Notify({ Title = "Anti-Troll " .. status:upper(), Content = "Anti-Troll has been " .. status .. ".", Duration = 3 })
            if not state then
                for i = #matchedParts, 1, -1 do
                    local part = matchedParts[i]
                    if part and part:IsDescendantOf(workspace) and part.Transparency == 1 then
                        part.CanCollide = false
                    end
                end
            end
        end
    })

    RunService.Heartbeat:Connect(function()
        if not forceCollisionsEnabled then return end
        for i = #matchedParts, 1, -1 do
            local part = matchedParts[i]
            if part and part:IsDescendantOf(workspace) then
                if not part.CanCollide then
                    part.CanCollide = true
                end
            else
                table.remove(matchedParts, i)
            end
        end
    end)
else
    Tabs.Main:AddParagraph({
        Title = "Unsupported Game",
        Content = "The current game is not supported by us. You can still use Universal and Settings though."
    })
end

-- UNIVERSAL TAB
Tabs.Universal:AddInput("WalkSpeedInput", {
    Title = "WalkSpeed", Default = "16", Placeholder = "Enter speed", Numeric = true
})
Tabs.Universal:AddButton({
    Title = "Set WalkSpeed",
    Callback = function()
        setHumanoidProperty("WalkSpeed", Options.WalkSpeedInput.Value)
        Fluent:Notify({ Title = "Set WalkSpeed", Content = "TowerHub has set your WalkSpeed.", Duration = 3 })
    end
})

Tabs.Universal:AddInput("JumpPowerInput", {
    Title = "JumpPower", Default = "50", Placeholder = "Enter jump height", Numeric = true
})
Tabs.Universal:AddButton({
    Title = "Set JumpPower",
    Callback = function()
        setHumanoidProperty("JumpPower", Options.JumpPowerInput.Value)
        Fluent:Notify({ Title = "Set JumpPower", Content = "TowerHub has set your JumpPower.", Duration = 3 })
    end
})

Tabs.Universal:AddToggle("NoclipToggle", {
    Title = "Noclip",
    Description = "Allows you to walk through walls.",
    Default = false,
    Callback = function(state)
        handleNoclip(state)
    end
})

-- SETTINGS
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
InterfaceManager:SetFolder("TowerHub")
SaveManager:SetFolder("TowerHub/SaveData")
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

Window:SelectTab(1)
Fluent:Notify({ Title = "Loaded", Content = "TowerHub has been loaded.", Duration = 5 })
SaveManager:LoadAutoloadConfig()
