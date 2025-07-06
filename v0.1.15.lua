--[[
    Optimized & Fixed by masploitz
    Version: 0.1.15
    Date: 6/7/25
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
local Workspace = game:GetService("Workspace")

--// LOCAL PLAYER
local LocalPlayer = Players.LocalPlayer

--// GLOBAL REFERENCES
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

--// TRACK NEW CHARACTER AFTER DEATH
LocalPlayer.CharacterAdded:Connect(function(char)
    Character = char
    Humanoid = char:WaitForChild("Humanoid")
    RootPart = char:WaitForChild("HumanoidRootPart")
end)

--// GAME DATA
local GameData = {
    [95508886069297] = { Name = "Slap Tower", Waypoints = {
        Vector3.new(-22.836, -10.696, 106.735), Vector3.new(-186.091, 769.303, 68.362),
        Vector3.new(183.885, -10.696, 81.003), Vector3.new(-20.662, -10.696, 19.133)
    }},
    -- ... (keep your existing game data)
}

local currentGameInfo = GameData[game.PlaceId]

--// FLUENT SETUP
local Window = Fluent:CreateWindow({
    Title = "TowerHub 0.1.15",
    SubTitle = "by masploitz",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Universal = Window:AddTab({ Title = "Universal" }),
    Main = Window:AddTab({ Title = "Main", Icon = "home" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}
local Options = Fluent.Options

--// UTILS
local function setHumanoidProperty(prop, value)
    local h = Humanoid
    if h and tonumber(value) then
        h[prop] = tonumber(value)
        if prop == "JumpPower" then
            h.UseJumpPower = true
        end
    end
end

--// Noclip
local noclipEnabled = false
RunService.Stepped:Connect(function()
    if noclipEnabled and Character then
        for _, part in ipairs(Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

--// Anti AFK
LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

--// Infinite Jump
local infiniteJumpEnabled = false
UserInputService.JumpRequest:Connect(function()
    if infiniteJumpEnabled and Humanoid then
        Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

--// Anti-Troll Logic
local targetColors = {
    Color3.fromRGB(237, 234, 234),
    Color3.fromRGB(99, 95, 98)
}
local matchedParts = {}
local forceCollisionsEnabled = false

local function isTargetColor(color)
    for _, t in pairs(targetColors) do
        if color == t then return true end
    end
    return false
end

local function scanForParts()
    matchedParts = {}
    for _, part in pairs(workspace:GetDescendants()) do
        if part:IsA("BasePart") and isTargetColor(part.Color) then
            table.insert(matchedParts, part)
        end
    end
end

scanForParts()

RunService.Heartbeat:Connect(function()
    if forceCollisionsEnabled then
        for i = #matchedParts, 1, -1 do
            local part = matchedParts[i]
            if part and part:IsDescendantOf(workspace) then
                part.CanCollide = true
            else
                table.remove(matchedParts, i)
            end
        end
    end
end)

--// MAIN TAB
if currentGameInfo then
    Tabs.Main:AddParagraph({
        Title = "You're in " .. currentGameInfo.Name,
        Content = "The script is configured for this game."
    })

    Tabs.Main:AddSlider("TeleportDelay", {
        Title = "TP Delay (Seconds)",
        Default = 0,
        Min = 0,
        Max = 5,
        Rounding = 1
    })

    Tabs.Main:AddButton({
        Title = "Auto Get Slaps/Win",
        Callback = function()
            if not RootPart then return end
            local tpDelay = Options.TeleportDelay.Value
            local originalCFrame = RootPart.CFrame
            for _, pos in ipairs(currentGameInfo.Waypoints) do
                if RootPart then
                    RootPart.CFrame = CFrame.new(pos)
                    task.wait(tpDelay)
                end
            end
            if RootPart then RootPart.CFrame = originalCFrame end
            Fluent:Notify({ Title = "Done", Content = "TP sequence complete", Duration = 4 })
        end
    })

    Tabs.Main:AddToggle("AntiTroll", {
        Title = "Anti-Troll",
        Description = "Block invisible troll parts.",
        Default = false,
        Callback = function(state)
            forceCollisionsEnabled = state
            Fluent:Notify({
                Title = "Anti-Troll " .. (state and "ENABLED" or "DISABLED"),
                Content = "Anti-Troll is now " .. (state and "active." or "off."),
                Duration = 3
            })

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

    Tabs.Main:AddToggle("FakeWallHop", {
        Title = "Fake Wall-Hop",
        Description = "Infinite Jump in air",
        Default = false,
        Callback = function(state)
            infiniteJumpEnabled = state
            Fluent:Notify({
                Title = "Fake Wall-Hop " .. (state and "ENABLED" or "DISABLED"),
                Content = "You can now " .. (state and "jump forever." or "no longer jump mid-air."),
                Duration = 3
            })
        end
    })
else
    Tabs.Main:AddParagraph({
        Title = "Unsupported Game",
        Content = "Game isn't in supported list, only Universal tab will work."
    })
end

--// UNIVERSAL TAB
Tabs.Universal:AddInput("WalkSpeedInput", {
    Title = "WalkSpeed", Default = "16", Numeric = true
})
Tabs.Universal:AddButton({
    Title = "Set WalkSpeed",
    Callback = function()
        setHumanoidProperty("WalkSpeed", Options.WalkSpeedInput.Value)
        Fluent:Notify({ Title = "WalkSpeed Set", Content = "Changed WalkSpeed", Duration = 3 })
    end
})

Tabs.Universal:AddInput("JumpPowerInput", {
    Title = "JumpPower", Default = "50", Numeric = true
})
Tabs.Universal:AddButton({
    Title = "Set JumpPower",
    Callback = function()
        setHumanoidProperty("JumpPower", Options.JumpPowerInput.Value)
        Fluent:Notify({ Title = "JumpPower Set", Content = "Changed JumpPower", Duration = 3 })
    end
})

Tabs.Universal:AddToggle("NoclipToggle", {
    Title = "Noclip",
    Description = "Walk through walls.",
    Default = false,
    Callback = function(state)
        noclipEnabled = state
        Fluent:Notify({ Title = "Noclip " .. (state and "ON" or "OFF"), Content = "Walls go brr", Duration = 2 })
    end
})

--// SETTINGS TAB
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
SaveManager:SetIgnoreIndexes({})
SaveManager:IgnoreThemeSettings()
InterfaceManager:SetFolder("TowerHub")
SaveManager:SetFolder("TowerHub/SaveData")
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

Window:SelectTab(1)
Fluent:Notify({ Title = "Loaded", Content = "TowerHub v0.1.15 has started.", Duration = 5 })
SaveManager:LoadAutoloadConfig()
