--[[
    Optimized & Fixed by masploitz
    Version: 0.1.15
    Date: 7/17/25
    Changes:
    - Fixed notifications firing on script load for disabled features
    - Optimized part scanning and memory usage
    - Improved error handling and performance
    - Better code organization and cleanup
    - Reduced redundant operations
    - Added responsive UI toggle button with aspect ratio constraint
    - Removed toggle UI visibility button from Fluent library
    - Made button bigger and positioned above all GUIs
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
        Vector3.new(-59.981, -10.697, 49.672), Vector3.new(-27.809, 339.253, -173.783),
        Vector3.new(-32.521, -8.482, 310.998)
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
    Title = "TowerHub 0.1.15",
    SubTitle = "by masploitz",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Universal = Window:AddTab({ Title = "Universal", Icon = "globe" }),
    Main = Window:AddTab({ Title = "Main", Icon = "home" }),
    Troll = Window:AddTab({ Title = "Troll", Icon = "home" }),
    Misc = Window:AddTab({ Title = "Misc", Icon = "home" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local Options = Fluent.Options

--// OPTIMIZED UTILS
local function getHumanoidAndRoot()
    local character = LocalPlayer.Character
    if character then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        return humanoid, rootPart
    end
    return nil, nil
end

local function setHumanoidProperty(property, value)
    local humanoid = getHumanoidAndRoot()
    local numberValue = tonumber(value)
    if humanoid and numberValue then
        humanoid[property] = numberValue
        if property == "JumpPower" then
            humanoid.UseJumpPower = true
        end
    end
end

local function showNotification(title, content, duration)
    Fluent:Notify({ 
        Title = title, 
        Content = content, 
        Duration = duration or 3 
    })
end

--// FEATURE STATES
local featureStates = {
    noclip = false,
    antiTroll = false,
    infiniteJump = false,
    uiVisible = true
}

--// UI TOGGLE FUNCTIONALITY
local function toggleUI(state)
    featureStates.uiVisible = state
    if Window and Window.Root then
        Window.Root.Visible = state
    end
    
    -- Update button transparency to reflect current state
    if ToggleButton then
        if state then
            ToggleButton.ImageTransparency = 0
            showNotification("UI Shown", "Interface is now visible")
        else
            ToggleButton.ImageTransparency = 0.5
            showNotification("UI Hidden", "Interface is now hidden")
        end
    end
end

--// RESPONSIVE TOGGLE BUTTON CREATION
local ToggleGui = Instance.new("ScreenGui")
local ToggleButton = Instance.new("ImageButton")
local AspectRatioConstraint = Instance.new("UIAspectRatioConstraint")

ToggleGui.Name = "THGui"
ToggleGui.ResetOnSpawn = false
ToggleGui.IgnoreGuiInset = true
ToggleGui.DisplayOrder = 999999999 -- Ensure it's above all other GUIs
ToggleGui.Parent = game.Players.LocalPlayer.PlayerGui

ToggleButton.Name = "TowerHubToggle"
ToggleButton.Size = UDim2.new(0, 80, 0, 80) -- Made bigger
ToggleButton.Position = UDim2.new(0.5, 0, 0, 100) -- Adjusted for bigger size
ToggleButton.AnchorPoint = Vector2.new(0.5, 0)
ToggleButton.BackgroundTransparency = 1
ToggleButton.Draggable = True
ToggleButton.BorderSizePixel = 0
ToggleButton.Image = "rbxassetid://123965155410559"
ToggleButton.ScaleType = Enum.ScaleType.Fit
ToggleButton.Parent = ToggleGui

-- Add aspect ratio constraint for responsiveness
AspectRatioConstraint.AspectRatio = 1 -- 1:1 ratio (square)
AspectRatioConstraint.AspectType = Enum.AspectType.FitWithinMaxSize
AspectRatioConstraint.DominantAxis = Enum.DominantAxis.Width
AspectRatioConstraint.Parent = ToggleButton

-- Toggle button functionality
ToggleButton.MouseButton1Click:Connect(function()
    -- Toggle based on current visibility state
    local currentVisibility = Window and Window.Root and Window.Root.Visible
    featureStates.uiVisible = not currentVisibility
    toggleUI(featureStates.uiVisible)
end)

-- Enhanced hover effects for bigger button
ToggleButton.MouseEnter:Connect(function()
    game:GetService("TweenService"):Create(ToggleButton, TweenInfo.new(0.2), {
        Size = UDim2.new(0, 88, 0, 88) -- Slightly bigger on hover
    }):Play()
end)

ToggleButton.MouseLeave:Connect(function()
    game:GetService("TweenService"):Create(ToggleButton, TweenInfo.new(0.2), {
        Size = UDim2.new(0, 80, 0, 80) -- Back to original bigger size
    }):Play()
end)

--// NOCLIP SYSTEM
local noclipConnection = nil

local function handleNoclip(enabled)
    featureStates.noclip = enabled
    
    if enabled then
        showNotification("Noclip Enabled", "You can now walk through walls.")
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
        if noclipConnection then
            noclipConnection:Disconnect()
            noclipConnection = nil
            showNotification("Noclip Disabled", "Noclip mode has been disabled.")
        end
    end
end

--// ANTI-IDLE
LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

--// MAIN TAB SETUP
if currentGameInfo then
    Tabs.Main:AddParagraph({
        Title = "You're in " .. currentGameInfo.Name,
        Content = "The script is configured for this game. All features in this tab are available."
    })

    Tabs.Main:AddSlider("TeleportDelay", {
        Title = "TP Delay (Seconds)",
        Description = "Delay between each TP's.",
        Default = 0,
        Min = 0,
        Max = 5,
        Rounding = 1
    })

    Tabs.Main:AddButton({
        Title = "Auto Get Slaps/Win",
        Callback = function()
            local humanoid, rootPart = getHumanoidAndRoot()
            if not rootPart then
                showNotification("Error", "Could not find your character.", 5)
                return
            end
            
            local originalCFrame = rootPart.CFrame
            local tpWait = Options.TeleportDelay.Value
            
            for i, pos in ipairs(currentGameInfo.Waypoints) do
                rootPart.CFrame = CFrame.new(pos)
                showNotification("Teleporting", "Waypoint " .. i .. "/" .. #currentGameInfo.Waypoints, 1)
                task.wait(tpWait)
            end
            
            rootPart.CFrame = originalCFrame
            showNotification("Finished", "Teleport sequence complete.", 5)
        end
    })

    --// OPTIMIZED ANTI-TROLL SYSTEM
    local targetColors = {
        Color3.fromRGB(237, 234, 234),
        Color3.fromRGB(99, 95, 98)
    }
    local matchedParts = {}
    local antiTrollConnection = nil
    local lastScanTime = 0
    local SCAN_INTERVAL = 5 -- Rescan every 5 seconds instead of every frame

    local function isTargetColor(color)
        for _, targetColor in ipairs(targetColors) do
            if color == targetColor then 
                return true 
            end
        end
        return false
    end

    local function scanForParts()
        local newParts = {}
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") and isTargetColor(obj.Color) then
                table.insert(newParts, obj)
            end
        end
        matchedParts = newParts
    end

    -- Initial scan
    scanForParts()

    local function handleAntiTroll(enabled)
        featureStates.antiTroll = enabled
        
        if enabled then
            showNotification("Anti-Troll Enabled", "Keeping trollers from doing their job!")
            
            if not antiTrollConnection then
                antiTrollConnection = RunService.Heartbeat:Connect(function()
                    local currentTime = tick()
                    
                    -- Periodic rescan
                    if currentTime - lastScanTime >= SCAN_INTERVAL then
                        scanForParts()
                        lastScanTime = currentTime
                    end
                    
                    -- Force collisions on target parts
                    for i = #matchedParts, 1, -1 do
                        local part = matchedParts[i]
                        if part and part.Parent then
                            part.CanCollide = true
                        else
                            table.remove(matchedParts, i)
                        end
                    end
                end)
            end
        else
            if antiTrollConnection then
                antiTrollConnection:Disconnect()
                antiTrollConnection = nil
                
                -- Restore original collision states
                for _, part in ipairs(matchedParts) do
                    if part and part.Parent and part.Transparency == 1 then
                        part.CanCollide = false
                    end
                end
                
                showNotification("Anti-Troll Disabled", "Anti-Troll has been disabled.")
            end
        end
    end

    Tabs.Main:AddToggle("AntiTroll", {
        Title = "Anti-Troll",
        Description = "Keep trollers from doing their job!",
        Default = false,
        Callback = handleAntiTroll
    })

    --// OPTIMIZED INFINITE JUMP SYSTEM
    local jumpConnection = nil
    local humanoidRef = nil

    local function updateHumanoidReference()
        local character = LocalPlayer.Character
        if character then
            humanoidRef = character:WaitForChild("Humanoid")
        end
    end

    local function handleInfiniteJump(enabled)
        featureStates.infiniteJump = enabled
        
        if enabled then
            showNotification("Fake Wall-Hop Enabled", "Infinite Jump has been enabled.")
            
            if not jumpConnection then
                jumpConnection = UserInputService.JumpRequest:Connect(function()
                    if featureStates.infiniteJump and humanoidRef then
                        humanoidRef:ChangeState(Enum.HumanoidStateType.Jumping)
                    end
                end)
            end
        else
            if jumpConnection then
                jumpConnection:Disconnect()
                jumpConnection = nil
                showNotification("Fake Wall-Hop Disabled", "Infinite Jump has been disabled.")
            end
        end
    end

    -- Initialize humanoid reference
    updateHumanoidReference()
    LocalPlayer.CharacterAdded:Connect(updateHumanoidReference)

    local fakeWallHopToggle = Tabs.Main:AddToggle("FakeWallHop", {
        Title = "Fake Wall-Hop",
        Description = "Lets you jump in air forever. (aka Infinite Jump)",
        Default = false,
        Callback = handleInfiniteJump
    })

    -- Store reference to toggle for cleanup
    Options.FakeWallHopToggle = fakeWallHopToggle

else
    Tabs.Main:AddParagraph({
        Title = "Unsupported Game",
        Content = "The current game is not supported. You can still use Universal and Settings."
    })
end

--// UNIVERSAL TAB
Tabs.Universal:AddInput("WalkSpeedInput", {
    Title = "WalkSpeed", 
    Default = "16", 
    Placeholder = "Enter speed", 
    Numeric = true
})

Tabs.Universal:AddButton({
    Title = "Set WalkSpeed",
    Callback = function()
        setHumanoidProperty("WalkSpeed", Options.WalkSpeedInput.Value)
        showNotification("WalkSpeed Updated", "Your WalkSpeed has been set to " .. Options.WalkSpeedInput.Value)
    end
})

Tabs.Universal:AddInput("JumpPowerInput", {
    Title = "JumpPower", 
    Default = "50", 
    Placeholder = "Enter jump height", 
    Numeric = true
})

Tabs.Universal:AddButton({
    Title = "Set JumpPower",
    Callback = function()
        setHumanoidProperty("JumpPower", Options.JumpPowerInput.Value)
        showNotification("JumpPower Updated", "Your JumpPower has been set to " .. Options.JumpPowerInput.Value)
    end
})

Tabs.Universal:AddToggle("NoclipToggle", {
    Title = "Noclip",
    Description = "Allows you to walk through walls.",
    Default = false,
    Callback = handleNoclip
})

-- REMOVED: Toggle UI Visibility button as requested

--// SETTINGS & CLEANUP
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
InterfaceManager:SetFolder("TowerHub")
SaveManager:SetFolder("TowerHub/SaveData")
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

--// CLEANUP ON SCRIPT END
local function cleanup()
    if noclipConnection then
        noclipConnection:Disconnect()
        noclipConnection = nil
    end
    if antiTrollConnection then
        antiTrollConnection:Disconnect()
        antiTrollConnection = nil
    end
    if jumpConnection then
        jumpConnection:Disconnect()
        jumpConnection = nil
    end
    if ToggleGui then
        ToggleGui:Destroy()
        ToggleGui = nil
    end
end

-- Handle UI destruction/closing
if Window and Window.Root then
    Window.Root.AncestryChanged:Connect(function()
        if not Window.Root.Parent then
            -- UI was destroyed, cleanup everything
            cleanup()
        end
    end)
end

game:GetService("Players").PlayerRemoving:Connect(function(player)
    if player == LocalPlayer then
        cleanup()
    end
end)

--// INITIALIZATION
Window:SelectTab(1)
showNotification("TowerHub Loaded", "Script has been loaded successfully!", 5)
SaveManager:LoadAutoloadConfig()
