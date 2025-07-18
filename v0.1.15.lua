--[[
    Optimized & Fixed by masploitz
    Version: 0.1.16
    Date: 7/18/25
    Changes:
    - Fixed key verification UI cleanup
    - Optimized tab creation with reusable functions
    - Better UI state management
    - Improved code organization
    - Fixed tab switching after verification
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
local TweenService = game:GetService("TweenService")

--// LOCAL PLAYER
local LocalPlayer = Players.LocalPlayer

--// KEY VERIFICATION SYSTEM
local KeyData = {
    CorrectKey = "masploitzHub",
    VerificationDuration = 14 * 24 * 60 * 60, -- 14 days in seconds
    GetKeyLink = "test",
    SaveFileName = "MasploitzHub_" .. LocalPlayer.UserId .. "_KeyVerification.json"
}

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

--// GLOBAL VARIABLES
local Window, Tabs, Options
local featureStates = {
    noclip = false,
    antiTroll = false,
    infiniteJump = false,
    uiVisible = true
}

local connections = {
    noclip = nil,
    antiTroll = nil,
    infiniteJump = nil
}

local keyVerificationElements = {}

--// UTILITY FUNCTIONS
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

--// KEY VERIFICATION FUNCTIONS
local function isKeyVerified()
    local success, data = pcall(function()
        if isfile(KeyData.SaveFileName) then
            local fileContent = readfile(KeyData.SaveFileName)
            local decodedData = game:GetService("HttpService"):JSONDecode(fileContent)
            return decodedData
        end
        return nil
    end)
    
    if success and data then
        local currentTime = os.time()
        local verificationTime = data.VerificationTime
        
        if verificationTime and (currentTime - verificationTime) <= KeyData.VerificationDuration then
            return true
        end
    end
    
    return false
end

local function saveKeyVerification()
    local success = pcall(function()
        local dataToSave = {
            VerificationTime = os.time(),
            Username = LocalPlayer.Name,
            UserId = LocalPlayer.UserId
        }
        
        local encodedData = game:GetService("HttpService"):JSONEncode(dataToSave)
        writefile(KeyData.SaveFileName, encodedData)
    end)
    
    return success
end

--// UI CREATION FUNCTIONS
local function createWindow()
    Window = Fluent:CreateWindow({
        Title = "Masploitz Hub 0.1.16",
        SubTitle = "by masploitz",
        TabWidth = 160,
        Size = UDim2.fromOffset(580, 460),
        Acrylic = true,
        Theme = "Dark",
        MinimizeKey = Enum.KeyCode.LeftControl
    })
    
    Tabs = {
        Key = Window:AddTab({ Title = "Key", Icon = "key" })
    }
    
    Options = Fluent.Options
end

local function createToggleButton()
    local ToggleGui = Instance.new("ScreenGui")
    local ToggleButton = Instance.new("ImageButton")
    local AspectRatioConstraint = Instance.new("UIAspectRatioConstraint")

    ToggleGui.Name = "MHGui"
    ToggleGui.ResetOnSpawn = false
    ToggleGui.IgnoreGuiInset = true
    ToggleGui.DisplayOrder = 999999999
    ToggleGui.Parent = LocalPlayer.PlayerGui

    ToggleButton.Name = "MasploitzHubToggle"
    ToggleButton.Size = UDim2.new(0, 80, 0, 80)
    ToggleButton.Position = UDim2.new(0.5, 0, 0, 100)
    ToggleButton.AnchorPoint = Vector2.new(0.5, 0)
    ToggleButton.BackgroundTransparency = 1
    ToggleButton.Draggable = true
    ToggleButton.BorderSizePixel = 0
    ToggleButton.Image = "rbxassetid://123965155410559"
    ToggleButton.ScaleType = Enum.ScaleType.Fit
    ToggleButton.Parent = ToggleGui

    AspectRatioConstraint.AspectRatio = 1
    AspectRatioConstraint.AspectType = Enum.AspectType.FitWithinMaxSize
    AspectRatioConstraint.DominantAxis = Enum.DominantAxis.Width
    AspectRatioConstraint.Parent = ToggleButton

    -- Toggle functionality
    ToggleButton.MouseButton1Click:Connect(function()
        local currentVisibility = Window and Window.Root and Window.Root.Visible
        featureStates.uiVisible = not currentVisibility
        toggleUI(featureStates.uiVisible)
    end)

    -- Hover effects
    ToggleButton.MouseEnter:Connect(function()
        TweenService:Create(ToggleButton, TweenInfo.new(0.2), {
            Size = UDim2.new(0, 88, 0, 88)
        }):Play()
    end)

    ToggleButton.MouseLeave:Connect(function()
        TweenService:Create(ToggleButton, TweenInfo.new(0.2), {
            Size = UDim2.new(0, 80, 0, 80)
        }):Play()
    end)

    return ToggleGui, ToggleButton
end

function toggleUI(state)
    featureStates.uiVisible = state
    if Window and Window.Root then
        Window.Root.Visible = state
    end
    
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

--// FEATURE CREATION FUNCTIONS
local function createNoclipFeature()
    local function handleNoclip(enabled)
        featureStates.noclip = enabled
        
        if enabled then
            showNotification("Noclip Enabled", "You can now walk through walls.")
            if not connections.noclip then
                connections.noclip = RunService.Stepped:Connect(function()
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
            if connections.noclip then
                connections.noclip:Disconnect()
                connections.noclip = nil
                showNotification("Noclip Disabled", "Noclip mode has been disabled.")
            end
        end
    end
    
    return handleNoclip
end

local function createAntiTrollFeature()
    local targetColors = {
        Color3.fromRGB(237, 234, 234),
        Color3.fromRGB(99, 95, 98)
    }
    local matchedParts = {}
    local lastScanTime = 0
    local SCAN_INTERVAL = 5

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

    scanForParts()

    local function handleAntiTroll(enabled)
        featureStates.antiTroll = enabled
        
        if enabled then
            showNotification("Anti-Troll Enabled", "Keeping trollers from doing their job!")
            
            if not connections.antiTroll then
                connections.antiTroll = RunService.Heartbeat:Connect(function()
                    local currentTime = tick()
                    
                    if currentTime - lastScanTime >= SCAN_INTERVAL then
                        scanForParts()
                        lastScanTime = currentTime
                    end
                    
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
            if connections.antiTroll then
                connections.antiTroll:Disconnect()
                connections.antiTroll = nil
                
                for _, part in ipairs(matchedParts) do
                    if part and part.Parent and part.Transparency == 1 then
                        part.CanCollide = false
                    end
                end
                
                showNotification("Anti-Troll Disabled", "Anti-Troll has been disabled.")
            end
        end
    end
    
    return handleAntiTroll
end

local function createInfiniteJumpFeature()
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
            
            if not connections.infiniteJump then
                connections.infiniteJump = UserInputService.JumpRequest:Connect(function()
                    if featureStates.infiniteJump and humanoidRef then
                        humanoidRef:ChangeState(Enum.HumanoidStateType.Jumping)
                    end
                end)
            end
        else
            if connections.infiniteJump then
                connections.infiniteJump:Disconnect()
                connections.infiniteJump = nil
                showNotification("Fake Wall-Hop Disabled", "Infinite Jump has been disabled.")
            end
        end
    end

    updateHumanoidReference()
    LocalPlayer.CharacterAdded:Connect(updateHumanoidReference)
    
    return handleInfiniteJump
end

--// TAB CREATION FUNCTIONS
local function createUniversalTab()
    Tabs.Universal = Window:AddTab({ Title = "Universal", Icon = "globe" })
    
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
        Callback = createNoclipFeature()
    })
end

local function createMainTab()
    Tabs.Main = Window:AddTab({ Title = "Main", Icon = "home" })
    
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

        Tabs.Main:AddToggle("AntiTroll", {
            Title = "Anti-Troll",
            Description = "Keep trollers from doing their job!",
            Default = false,
            Callback = createAntiTrollFeature()
        })

        Tabs.Main:AddToggle("FakeWallHop", {
            Title = "Fake Wall-Hop",
            Description = "Lets you jump in air forever. (aka Infinite Jump)",
            Default = false,
            Callback = createInfiniteJumpFeature()
        })

    else
        Tabs.Main:AddParagraph({
            Title = "Unsupported Game",
            Content = "The current game is not supported. You can still use Universal and Settings."
        })
    end
end

local function createAdditionalTabs()
    Tabs.Troll = Window:AddTab({ Title = "Troll", Icon = "smile" })
    Tabs.Misc = Window:AddTab({ Title = "Misc", Icon = "package" })
    Tabs.Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
    
    -- Setup save managers
    SaveManager:SetLibrary(Fluent)
    InterfaceManager:SetLibrary(Fluent)
    SaveManager:IgnoreThemeSettings()
    SaveManager:SetIgnoreIndexes({})
    InterfaceManager:SetFolder("MasploitzHub")
    SaveManager:SetFolder("MasploitzHub/SaveData")
    InterfaceManager:BuildInterfaceSection(Tabs.Settings)
    SaveManager:BuildConfigSection(Tabs.Settings)
end

--// KEY VERIFICATION UI FUNCTIONS
local function clearKeyVerificationUI()
    -- Clear all elements from the key tab
    for _, element in ipairs(keyVerificationElements) do
        if element and element.Destroy then
            element:Destroy()
        end
    end
    keyVerificationElements = {}
end

local function updateKeyTabToVerified()
    clearKeyVerificationUI()
    
    -- Add verification success paragraph
    Tabs.Key:AddParagraph({
        Title = "✅ Verified",
        Content = "Your key has been verified successfully! You now have access to all features."
    })
end

local function setupKeyVerificationUI()
    local paragraph = Tabs.Key:AddParagraph({
        Title = "Key Verification Required",
        Content = "Please enter your key to access Masploitz Hub. Keys are valid for 14 days and will be saved locally."
    })
    table.insert(keyVerificationElements, paragraph)
    
    local keyInput = Tabs.Key:AddInput("KeyInput", {
        Title = "Enter Key",
        Default = "",
        Placeholder = "Enter your key here...",
        Numeric = false,
        Finished = false
    })
    table.insert(keyVerificationElements, keyInput)
    
    local checkButton = Tabs.Key:AddButton({
        Title = "Check Key",
        Callback = function()
            local enteredKey = Options.KeyInput.Value
            
            if enteredKey == KeyData.CorrectKey then
                local success = saveKeyVerification()
                if success then
                    showNotification("Key Verified", "Access granted! Key saved for 14 days.", 5)
                else
                    showNotification("Save Failed", "Key correct but save failed. You'll need to verify again next time.", 7)
                end
                
                -- Update UI and create main features
                updateKeyTabToVerified()
                createMainTabs()
            else
                showNotification("Invalid Key", "The key you entered is incorrect.", 5)
            end
        end
    })
    table.insert(keyVerificationElements, checkButton)
    
    local getKeyButton = Tabs.Key:AddButton({
        Title = "Get Key",
        Callback = function()
            setclipboard(KeyData.GetKeyLink)
            showNotification("Link Copied", "Key purchase link copied to clipboard!", 5)
        end
    })
    table.insert(keyVerificationElements, getKeyButton)
end

local function createMainTabs()
    createUniversalTab()
    createMainTab()
    createAdditionalTabs()
    
    -- Switch to main tab after creation
    Window:SelectTab(2) -- Universal tab
end

--// CLEANUP FUNCTIONS
local function cleanup()
    for _, connection in pairs(connections) do
        if connection then
            connection:Disconnect()
        end
    end
    connections = {}
    
    if ToggleGui then
        ToggleGui:Destroy()
    end
end

--// ANTI-IDLE SETUP
local function setupAntiIdle()
    LocalPlayer.Idled:Connect(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
end

--// INITIALIZATION
local function initialize()
    createWindow()
    ToggleGui, ToggleButton = createToggleButton()
    setupAntiIdle()
    
    -- Handle cleanup on UI destruction
    if Window and Window.Root then
        Window.Root.AncestryChanged:Connect(function()
            if not Window.Root.Parent then
                cleanup()
            end
        end)
    end
    
    -- Setup key verification or main features
    if isKeyVerified() then
        updateKeyTabToVerified()
        createMainTabs()
        showNotification("Welcome Back", "Key still valid! Loading Masploitz Hub...", 5)
    else
        setupKeyVerificationUI()
        showNotification("Key Required", "Please verify your key to access the hub.", 5)
    end
    
    Window:SelectTab(1)
    SaveManager:LoadAutoloadConfig()
end

-- Handle player leaving
Players.PlayerRemoving:Connect(function(player)
    if player == LocalPlayer then
        cleanup()
    end
end)

-- Start the script
initialize()
