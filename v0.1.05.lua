--[[
    TowerHub - Optimized & Modular Version
    Version: 0.1.05
    Date: 7/19/25
    
    Features:
    - Highly configurable through tables
    - Easy to add new games, features, and UI elements
    - Optimized performance with connection pooling
    - Modular architecture for easy maintenance
    - Extensive utility functions
    - Auto-cleanup system
]]

--// ========================================
--//              CONFIGURATION
--// ========================================

local CONFIG = {
    SCRIPT = {
        Name = "MasploitzHub",
        Version = "0.1.05",
        Author = "masploitz",
        UpdateUrl = "https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"
    },
    
    UI = {
        Window = {
            Title = "MasploitzHub | 0.1.05",
            SubTitle = "by masploitz",
            TabWidth = 160,
            Size = UDim2.fromOffset(580, 460),
            Acrylic = true,
            Theme = "Dark",
            MinimizeKey = Enum.KeyCode.LeftControl
        },
        
        ToggleButton = {
            Size = UDim2.new(0, 80, 0, 80),
            Position = UDim2.new(0.5, 0, 0, 100),
            Image = "rbxassetid://123965155410559",
            HoverSize = UDim2.new(0, 88, 0, 88),
            DisplayOrder = 999999999
        },
        
        Notifications = {
            DefaultDuration = 2,
            LoadDuration = 2,
            ErrorDuration = 2
        }
    },
    
    FEATURES = {
        AntiIdle = true,
        AutoCleanup = true,
        PerformanceOptimization = true,
        
        Scanning = {
            Interval = 5, -- seconds
            BatchSize = 100 -- parts per batch
        },
        
        Teleport = {
            DefaultDelay = 0,
            MinDelay = 0,
            MaxDelay = 5,
            SafetyDelay = 0.1
        }
    }
}

--// Game configurations - Easy to add new games
local GAME_DATA = {
    [95508886069297] = {
        Name = "Slap Tower",
        Category = "Slap",
        Features = {"AutoWin", "AntiTroll", "InfiniteJump"},
        Waypoints = {
            Vector3.new(-22.836, -10.696, 106.735),
            Vector3.new(-186.091, 769.303, 68.362),
            Vector3.new(183.885, -10.696, 81.003),
            Vector3.new(-20.662, -10.696, 19.133)
        },
        AntiTroll = {
            TargetColors = {
                Color3.fromRGB(237, 234, 234),
                Color3.fromRGB(99, 95, 98)
            }
        }
    },
    
    [79089892790758] = {
        Name = "Slap Tower 2",
        Category = "Slap",
        Features = {"AutoWin", "AntiTroll", "InfiniteJump"},
        Waypoints = {
            Vector3.new(36.821, 4, 4.976),
            Vector3.new(-339.738, 4, -4.854),
            Vector3.new(162.139, 4, -27.676),
            Vector3.new(4.081, 354, 321.704)
        },
        AntiTroll = {
            TargetColors = {
                Color3.fromRGB(237, 234, 234),
                Color3.fromRGB(99, 95, 98)
            }
        }
    },
    
    [105612566642310] = {
        Name = "Slap Tower 3",
        Category = "Slap",
        Features = {"AutoWin", "AntiTroll", "InfiniteJump"},
        Waypoints = {
            Vector3.new(18.035, 4, 68.766),
            Vector3.new(16.240, 4, -157.492),
            Vector3.new(184.256, 4, -2.320),
            Vector3.new(-226.947, 354, 38.531)
        }
    },
    
    -- Add more games easily here...
}

--// Tab configuration - Easy to add new tabs
local TAB_CONFIG = {
    {Name = "Universal", Icon = "globe", Order = 1},
    {Name = "Main", Icon = "home", Order = 2},
    {Name = "Settings", Icon = "settings", Order = 3}
}

--// ========================================
--//              DEPENDENCIES
--// ========================================

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

--// ========================================
--//                SERVICES
--// ========================================

local Services = {
    Players = game:GetService("Players"),
    RunService = game:GetService("RunService"),
    UserInputService = game:GetService("UserInputService"),
    VirtualUser = game:GetService("VirtualUser"),
    TweenService = game:GetService("TweenService"),
    StarterGui = game:GetService("StarterGui")
}

local LocalPlayer = Services.Players.LocalPlayer

--// ========================================
--//            UTILITY FUNCTIONS
--// ========================================

local Utils = {}

-- Character utilities
function Utils.getCharacterComponents()
    local character = LocalPlayer.Character
    if not character then return nil, nil, nil end
    
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    
    return character, humanoid, rootPart
end

-- Humanoid property setter with validation
function Utils.setHumanoidProperties(walkSpeed, jumpPower)
    local _, humanoid = Utils.getCharacterComponents()
    local wsValue, jpValue = tonumber(walkSpeed), tonumber(jumpPower)
    
    if not humanoid or not wsValue or not jpValue then
        return false, "Invalid humanoid or values"
    end
    
    if wsValue < 0 or jpValue < 0 then
        return false, "Values cannot be negative"
    end
    
    humanoid.WalkSpeed = wsValue
    humanoid.UseJumpPower = true
    humanoid.JumpPower = jpValue
    
    return true, "Success"
end

-- Notification system
function Utils.notify(title, content, duration)
    pcall(function()
        Fluent:Notify({
            Title = title,
            Content = content,
            Duration = duration or CONFIG.UI.Notifications.DefaultDuration
        })
    end)
end

-- Safe teleport function
function Utils.safeTeleport(position, delay)
    local _, _, rootPart = Utils.getCharacterComponents()
    if not rootPart then return false, "No character found" end
    
    delay = delay or CONFIG.FEATURES.Teleport.SafetyDelay
    
    pcall(function()
        rootPart.CFrame = CFrame.new(position)
    end)
    
    if delay > 0 then task.wait(delay) end
    return true, "Teleported successfully"
end

-- Color comparison utility
function Utils.compareColors(color1, color2, tolerance)
    tolerance = tolerance or 0.01
    return math.abs(color1.R - color2.R) < tolerance and
           math.abs(color1.G - color2.G) < tolerance and
           math.abs(color1.B - color2.B) < tolerance
end

-- Connection management
local ConnectionManager = {
    connections = {},
    
    add = function(self, name, connection)
        if self.connections[name] then
            self.connections[name]:Disconnect()
        end
        self.connections[name] = connection
    end,
    
    remove = function(self, name)
        if self.connections[name] then
            self.connections[name]:Disconnect()
            self.connections[name] = nil
        end
    end,
    
    cleanup = function(self)
        for name, connection in pairs(self.connections) do
            if connection then connection:Disconnect() end
        end
        self.connections = {}
    end
}

--// ========================================
--//            FEATURE SYSTEM
--// ========================================

local FeatureManager = {
    states = {},
    features = {},
    
    -- Register a new feature
    register = function(self, name, feature)
        self.features[name] = feature
        self.states[name] = false
        if feature.init then feature.init() end
    end,
    
    -- Toggle a feature
    toggle = function(self, name, state)
        local feature = self.features[name]
        if not feature then return false end
        
        self.states[name] = state
        
        if state and feature.enable then
            feature.enable()
        elseif not state and feature.disable then
            feature.disable()
        end
        
        return true
    end,
    
    -- Get feature state
    getState = function(self, name)
        return self.states[name] or false
    end,
    
    -- Cleanup all features
    cleanup = function(self)
        for name, feature in pairs(self.features) do
            if self.states[name] and feature.disable then feature.disable() end
            if feature.cleanup then feature.cleanup() end
        end
        self.states = {}
    end
}

--// ========================================
--//          CORE FEATURE IMPLEMENTATIONS
--// ========================================

-- Noclip Feature
local NoclipFeature = {
    enable = function()
        ConnectionManager:add("noclip", Services.RunService.Stepped:Connect(function()
            local character = Utils.getCharacterComponents()
            if character then
                for _, part in ipairs(character:GetDescendants()) do
                    if part:IsA("BasePart") and part.CanCollide then
                        part.CanCollide = false
                    end
                end
            end
        end))
        
        Utils.notify("Noclip Enabled", "You can now walk through walls.")
    end,
    
    disable = function()
        ConnectionManager:remove("noclip")
        Utils.notify("Noclip Disabled", "Noclip mode has been disabled.")
    end
}

-- Anti-Troll Feature
local function createAntiTrollFeature(gameData)
    local matchedParts = {}
    local lastScanTime = 0
    
    local function isTargetColor(color)
        if not gameData.AntiTroll or not gameData.AntiTroll.TargetColors then
            return false
        end
        
        for _, targetColor in ipairs(gameData.AntiTroll.TargetColors) do
            if Utils.compareColors(color, targetColor) then
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
    
    return {
        init = function() scanForParts() end,
        
        enable = function()
            ConnectionManager:add("antiTroll", Services.RunService.Heartbeat:Connect(function()
                local currentTime = tick()
                
                if currentTime - lastScanTime >= CONFIG.FEATURES.Scanning.Interval then
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
            end))
            
            Utils.notify("Anti-Troll Enabled", "Keeping trollers from doing their job!")
        end,
        
        disable = function()
            ConnectionManager:remove("antiTroll")
            
            for _, part in ipairs(matchedParts) do
                if part and part.Parent and part.Transparency == 1 then
                    part.CanCollide = false
                end
            end
            
            Utils.notify("Anti-Troll Disabled", "Anti-Troll has been disabled.")
        end,
        
        cleanup = function() matchedParts = {} end
    }
end

-- Infinite Jump Feature
local InfiniteJumpFeature = {
    enable = function()
        ConnectionManager:add("infiniteJump", Services.UserInputService.JumpRequest:Connect(function()
            if FeatureManager:getState("infiniteJump") then
                local _, humanoid = Utils.getCharacterComponents()
                if humanoid then
                    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end
        end))
        
        Utils.notify("Infinite Jump Enabled", "You can now jump forever!")
    end,
    
    disable = function()
        ConnectionManager:remove("infiniteJump")
        Utils.notify("Infinite Jump Disabled", "Infinite Jump has been disabled.")
    end
}

--// ========================================
--//              UI SYSTEM
--// ========================================

local UIManager = {
    window = nil,
    tabs = {},
    options = {},
    toggleGui = nil,
    
    -- Initialize the main window
    init = function(self)
        self.window = Fluent:CreateWindow(CONFIG.UI.Window)
        self.options = Fluent.Options
        
        -- Create tabs
        for _, tabConfig in ipairs(TAB_CONFIG) do
            self.tabs[tabConfig.Name] = self.window:AddTab({
                Title = tabConfig.Name,
                Icon = tabConfig.Icon
            })
        end
        
        self:createToggleButton()
        return self.window
    end,
    
    -- Create the toggle button
    createToggleButton = function(self)
        self.toggleGui = Instance.new("ScreenGui")
        local toggleButton = Instance.new("ImageButton")
        local aspectRatio = Instance.new("UIAspectRatioConstraint")
        
        -- Configure ScreenGui
        self.toggleGui.Name = "TowerHubToggle"
        self.toggleGui.ResetOnSpawn = false
        self.toggleGui.IgnoreGuiInset = true
        self.toggleGui.DisplayOrder = CONFIG.UI.ToggleButton.DisplayOrder
        self.toggleGui.Parent = LocalPlayer.PlayerGui
        
        -- Configure Button
        local buttonConfig = CONFIG.UI.ToggleButton
        toggleButton.Name = "ToggleButton"
        toggleButton.Size = buttonConfig.Size
        toggleButton.Position = buttonConfig.Position
        toggleButton.AnchorPoint = Vector2.new(0.5, 0)
        toggleButton.BackgroundTransparency = 1
        toggleButton.Draggable = true
        toggleButton.BorderSizePixel = 0
        toggleButton.Image = buttonConfig.Image
        toggleButton.ScaleType = Enum.ScaleType.Fit
        toggleButton.Parent = self.toggleGui
        
        -- Configure Aspect Ratio
        aspectRatio.AspectRatio = 1
        aspectRatio.AspectType = Enum.AspectType.FitWithinMaxSize
        aspectRatio.DominantAxis = Enum.DominantAxis.Width
        aspectRatio.Parent = toggleButton
        
        -- Button functionality
        toggleButton.MouseButton1Click:Connect(function() self:toggleVisibility() end)
        
        -- Hover effects
        toggleButton.MouseEnter:Connect(function()
            Services.TweenService:Create(toggleButton, TweenInfo.new(0.2), {Size = buttonConfig.HoverSize}):Play()
        end)
        
        toggleButton.MouseLeave:Connect(function()
            Services.TweenService:Create(toggleButton, TweenInfo.new(0.2), {Size = buttonConfig.Size}):Play()
        end)
    end,
    
    -- Toggle UI visibility
    toggleVisibility = function(self)
        if self.window and self.window.Root then
            local currentVisibility = self.window.Root.Visible
            self.window.Root.Visible = not currentVisibility
            
            if self.window.Root.Visible then
                Utils.notify("UI Shown", "Interface is now visible")
            else
                Utils.notify("UI Hidden", "Interface is now hidden")
            end
        end
    end,
    
    -- Add universal features to UI
    addUniversalFeatures = function(self)
        -- WalkSpeed input
        self.tabs.Universal:AddInput("WalkSpeedInput", {
            Title = "WalkSpeed",
            Default = "16",
            Placeholder = "Enter walkspeed",
            Numeric = true
        })
        
        -- JumpPower input
        self.tabs.Universal:AddInput("JumpPowerInput", {
            Title = "JumpPower",
            Default = "50",
            Placeholder = "Enter jumppower",
            Numeric = true
        })
        
        -- Set Both button
        self.tabs.Universal:AddButton({
            Title = "Set Both",
            Callback = function()
                local wsValue = self.options.WalkSpeedInput.Value
                local jpValue = self.options.JumpPowerInput.Value
                local success, message = Utils.setHumanoidProperties(wsValue, jpValue)
                
                if success then
                    Utils.notify("Properties Updated", 
                               "WalkSpeed: " .. wsValue .. " | JumpPower: " .. jpValue)
                else
                    Utils.notify("Error", message, CONFIG.UI.Notifications.ErrorDuration)
                end
            end
        })
        
        -- Add noclip toggle
        self.tabs.Universal:AddToggle("NoclipToggle", {
            Title = "Noclip",
            Description = "Allows you to walk through walls.",
            Default = false,
            Callback = function(state) FeatureManager:toggle("noclip", state) end
        })
    end,
    
    -- Add game-specific features
    addGameFeatures = function(self, gameData)
        self.tabs.Main:AddParagraph({
            Title = "You're in " .. gameData.Name,
            Content = "The script is configured for this game. All features in this tab are available."
        })
        
        -- Teleport delay slider
        self.tabs.Main:AddSlider("TeleportDelay", {
            Title = "TP Delay (Seconds)",
            Description = "Delay between each teleport.",
            Default = CONFIG.FEATURES.Teleport.DefaultDelay,
            Min = CONFIG.FEATURES.Teleport.MinDelay,
            Max = CONFIG.FEATURES.Teleport.MaxDelay,
            Rounding = 1
        })
        
        -- Auto win button
        if gameData.Waypoints then
            self.tabs.Main:AddButton({
                Title = "Auto Get Slaps/Win",
                Callback = function() self:executeAutoWin(gameData.Waypoints) end
            })
        end
        
        -- Anti-troll toggle
        if table.find(gameData.Features, "AntiTroll") then
            self.tabs.Main:AddToggle("AntiTroll", {
                Title = "Anti-Troll",
                Description = "Keep trollers from doing their job!",
                Default = false,
                Callback = function(state) FeatureManager:toggle("antiTroll", state) end
            })
        end
        
        -- Infinite jump toggle
        if table.find(gameData.Features, "InfiniteJump") then
            self.tabs.Main:AddToggle("InfiniteJump", {
                Title = "Fake Wall-Hop",
                Description = "Lets you jump in air forever. (aka Infinite Jump)",
                Default = false,
                Callback = function(state) FeatureManager:toggle("infiniteJump", state) end
            })
        end
    end,
    
    -- Execute auto win sequence
    executeAutoWin = function(self, waypoints)
        local _, _, rootPart = Utils.getCharacterComponents()
        if not rootPart then
            Utils.notify("Error", "Could not find your character.", CONFIG.UI.Notifications.ErrorDuration)
            return
        end
        
        local originalCFrame = rootPart.CFrame
        local tpWait = self.options.TeleportDelay.Value
        
        for i, pos in ipairs(waypoints) do
            local success, message = Utils.safeTeleport(pos, tpWait)
            if success then
                Utils.notify("Teleporting", "Waypoint " .. i .. "/" .. #waypoints, 1)
            else
                Utils.notify("Teleport Error", message, CONFIG.UI.Notifications.ErrorDuration)
                break
            end
        end
        
        Utils.safeTeleport(originalCFrame.Position)
        Utils.notify("Finished", "Teleport sequence complete.", CONFIG.UI.Notifications.LoadDuration)
    end,
    
    -- Add unsupported game message
    addUnsupportedMessage = function(self)
        self.tabs.Main:AddParagraph({
            Title = "Unsupported Game",
            Content = "The current game is not supported. You can still use Universal and Settings."
        })
    end,
    
    -- Setup save system
    setupSaveSystem = function(self)
        SaveManager:SetLibrary(Fluent)
        InterfaceManager:SetLibrary(Fluent)
        SaveManager:IgnoreThemeSettings()
        SaveManager:SetIgnoreIndexes({})
        InterfaceManager:SetFolder("TowerHub")
        SaveManager:SetFolder("TowerHub/SaveData")
        InterfaceManager:BuildInterfaceSection(self.tabs.Settings)
        SaveManager:BuildConfigSection(self.tabs.Settings)
    end,
    
    -- Cleanup UI
    cleanup = function(self)
        if self.toggleGui then self.toggleGui:Destroy() end
    end
}

--// ========================================
--//            INITIALIZATION
--// ========================================

local function initializeScript()
    -- Get current game info
    local currentPlaceId = game.PlaceId
    local currentGameData = GAME_DATA[currentPlaceId]
    
    -- Register core features
    FeatureManager:register("noclip", NoclipFeature)
    FeatureManager:register("infiniteJump", InfiniteJumpFeature)
    
    -- Register game-specific features
    if currentGameData and table.find(currentGameData.Features or {}, "AntiTroll") then
        FeatureManager:register("antiTroll", createAntiTrollFeature(currentGameData))
    end
    
    -- Initialize UI
    UIManager:init()
    UIManager:addUniversalFeatures()
    
    -- Add game-specific or unsupported features
    if currentGameData then
        UIManager:addGameFeatures(currentGameData)
    else
        UIManager:addUnsupportedMessage()
    end
    
    -- Setup save system
    UIManager:setupSaveSystem()
    
    -- Anti-idle system
    if CONFIG.FEATURES.AntiIdle then
        LocalPlayer.Idled:Connect(function()
            Services.VirtualUser:CaptureController()
            Services.VirtualUser:ClickButton2(Vector2.new())
        end)
    end
    
    -- Cleanup system
    if CONFIG.FEATURES.AutoCleanup then
        game:GetService("Players").PlayerRemoving:Connect(function(player)
            if player == LocalPlayer then cleanup() end
        end)
        
        if UIManager.window and UIManager.window.Root then
            UIManager.window.Root.AncestryChanged:Connect(function()
                if not UIManager.window.Root.Parent then cleanup() end
            end)
        end
    end
    
    -- Final setup
    UIManager.window:SelectTab(1)
    Utils.notify("TowerHub Loaded", "Script has been loaded successfully!", CONFIG.UI.Notifications.LoadDuration)
    SaveManager:LoadAutoloadConfig()
end

--// ========================================
--//              CLEANUP
--// ========================================

function cleanup()
    FeatureManager:cleanup()
    ConnectionManager:cleanup()
    UIManager:cleanup()
end

--// ========================================
--//              START SCRIPT
--// ========================================

-- Initialize the script
initializeScript()
