local CONFIG = {
    SCRIPT = {
        Name = "MasploitzHub",
        Version = "0.1.1",
        Author = "masploitz",
        UpdateUrl = "https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"
    },
    
    UI = {
        Window = {
            Title = "MasploitzHub | 0.1.1",
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
            Image = "rbxassetid://85081942412982",
            HoverSize = UDim2.new(0, 88, 0, 88),
            DisplayOrder = 999999999
        },
        
        Notifications = {
            DefaultDuration = 3,
            LoadDuration = 5,
            ErrorDuration = 5
        }
    },
    
    FEATURES = {
        AntiIdle = true,
        AutoCleanup = true,
        PerformanceOptimization = true,
        
        Scanning = {
            Interval = 5,
            BatchSize = 100
        },
        
        Teleport = {
            DefaultDelay = 0,
            MinDelay = 0,
            MaxDelay = 5,
            SafetyDelay = 0
        }
    }
}

local GAME_DATA = {
 [95508886069297] = { 
    Name = "Slap Tower", 
    Features = {"AutoWin", "AntiTroll", "InfiniteJump", "AntiKillpart"},
    Waypoints = {
        Vector3.new(-22.836, -10.696, 106.735), Vector3.new(-186.091, 769.303, 68.362),
        Vector3.new(183.885, -10.696, 81.003), Vector3.new(-20.662, -10.696, 19.133)
    }
},
[79089892790758] = { 
    Name = "Slap Tower 2", 
    Features = {"AutoWin", "AntiTroll", "InfiniteJump", "AntiKillpart"},
    Waypoints = {
        Vector3.new(36.821, 4, 4.976), Vector3.new(-339.738, 4, -4.854),
        Vector3.new(162.139, 4, -27.676), Vector3.new(4.081, 354, 321.704)
    }
},
[105612566642310] = { 
    Name = "Slap Tower 3", 
    Features = {"AutoWin", "AntiTroll", "InfiniteJump", "AntiKillpart"},
    Waypoints = {
        Vector3.new(18.035, 4, 68.766), Vector3.new(16.240, 4, -157.492),
        Vector3.new(184.256, 4, -2.320), Vector3.new(-226.947, 354, 38.531)
    }
},
[86082995079744] = { 
    Name = "Slap Tower 4", 
    Features = {"AutoWin", "AntiTroll", "InfiniteJump", "AntiKillpart"},
    Waypoints = {
        Vector3.new(51.702, -3.031, 6.154), Vector3.new(-33.109, -18.031, -33.673),
        Vector3.new(27.168, -3.031, -187.073), Vector3.new(14.734, 597, 172.204)
    }
},
[93924136437619] = { 
    Name = "Slap Tower 5", 
    Features = {"AutoWin", "AntiTroll", "InfiniteJump", "AntiKillpart"},
    Waypoints = {
        Vector3.new(-59.981, -10.697, 49.672), Vector3.new(-27.809, 339.253, -173.783)
    }
},
[120759571391756] = { 
    Name = "Slap Tower 6", 
    Features = {"AutoWin", "AntiTroll", "InfiniteJump", "AntiKillpart"},
    Waypoints = {
        Vector3.new(64.42, -9.43, 111.52), Vector3.new(-142.28, 593.05, 76.05)
    }
},
[83312952548612] = { 
    Name = "Troll Is A Pinning Tower 2", 
    Features = {"AutoWin", "AntiTroll", "InfiniteJump", "AntiKillpart"},
    Waypoints = {
        Vector3.new(272.64, 347.15, -32.93)
    }
},
[88049480741001] = { 
    Name = "Troll Is A Pinning Tower 4", 
    Features = {"AutoWin", "AntiTroll", "InfiniteJump", "AntiKillpart"},
    Waypoints = {
        Vector3.new(353.89, 338.42, 56.05)
    }
},
[105692451124462] = { 
    Name = "Troll Bomb Tower", 
    Features = {"AutoWin", "AntiTroll", "InfiniteJump", "AntiKillpart"},
    Waypoints = {
        Vector3.new(567.81, 465.26, -161.32)
    }
},
[128635262479351] = { 
    Name = "Troll Laser Tower", 
    Features = {"AutoWin", "AntiTroll", "InfiniteJump", "AntiKillpart"},
    Waypoints = {
        Vector3.new(-31.90, 390.51, -213.14), Vector3.new(-71.36, -7.65, 55.77)
    }
}
}

local UNIVERSAL_FEATURES = {
    WalkSpeed = {
        Title = "WalkSpeed",
        Default = "16",
        Property = "WalkSpeed",
        Min = 0,
        Max = 1000,
        UseJumpPower = false
    },
    
    JumpPower = {
        Title = "JumpPower",
        Default = "50",
        Property = "JumpPower",
        Min = 0,
        Max = 1000,
        UseJumpPower = true
    },
}

local TAB_CONFIG = {
    {
        Name = "Universal",
        Icon = "globe",
        Order = 1
    },
    {
        Name = "Main",
        Icon = "home",
        Order = 2
    },
    {
        Name = "Settings",
        Icon = "settings",
        Order = 3
    }
}

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Services = {
    Players = game:GetService("Players"),
    RunService = game:GetService("RunService"),
    UserInputService = game:GetService("UserInputService"),
    VirtualUser = game:GetService("VirtualUser"),
    TweenService = game:GetService("TweenService"),
    StarterGui = game:GetService("StarterGui")
}

local LocalPlayer = Services.Players.LocalPlayer

local Utils = {}

function Utils.getCharacterComponents()
    local character = LocalPlayer.Character
    if not character then return nil, nil, nil end
    
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    local head = character:FindFirstChild("Head")
    
    return character, humanoid, rootPart, head
end

function Utils.waitForCharacter()
    return LocalPlayer.CharacterAdded:Wait()
end

function Utils.setHumanoidProperty(property, value, useJumpPower)
    local _, humanoid = Utils.getCharacterComponents()
    local numberValue = tonumber(value)
    
    if not humanoid or not numberValue then
        return false, "Invalid humanoid or value"
    end
    
    if numberValue < 0 then
        return false, "Value cannot be negative"
    end
    
    humanoid[property] = numberValue
    
    if useJumpPower then
        humanoid.UseJumpPower = true
    end
    
    return true, "Success"
end

function Utils.notify(title, content, duration)
    pcall(function()
        Fluent:Notify({
            Title = title,
            Content = content,
            Duration = duration or CONFIG.UI.Notifications.DefaultDuration
        })
    end)
end

function Utils.safeTeleport(position, delay)
    local _, _, rootPart = Utils.getCharacterComponents()
    if not rootPart then
        return false, "No character found"
    end
    
    delay = delay or CONFIG.FEATURES.Teleport.SafetyDelay
    
    pcall(function()
        rootPart.CFrame = CFrame.new(position)
    end)
    
    if delay > 0 then
        task.wait(delay)
    elseif delay = 0 then
        task.wait(0.001)
    end
    
    return true, "Teleported successfully"
end

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
            if connection then
                connection:Disconnect()
            end
        end
        self.connections = {}
    end
}

local FeatureManager = {
    states = {},
    features = {},
    
    register = function(self, name, feature)
        self.features[name] = feature
        self.states[name] = false
        
        if feature.init then
            feature.init()
        end
    end,
    
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
    
    getState = function(self, name)
        return self.states[name] or false
    end,
    
    cleanup = function(self)
        for name, feature in pairs(self.features) do
            if self.states[name] and feature.disable then
                feature.disable()
            end
            if feature.cleanup then
                feature.cleanup()
            end
        end
        self.states = {}
    end
}

local NoclipFeature = {
    init = function()
    end,
    
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

local function createAntiTrollFeature()
    local partPaths = {
        "game.Workspace.Model.Part",
        "game.Workspace.사라지는 파트",
        "game.Workspace.Part",
        "game.Workspace.Pyong"
    }
    
    local targetNames = {}
    local function extractNamesFromPaths()
        for _, path in ipairs(partPaths) do
            local name = path:match("([^%.]+)$")
            if name and not targetNames[name] then
                targetNames[name] = true
            end
        end
    end
    
    extractNamesFromPaths()
    
    local function getObjectFromPath(path)
        local cleanPath = path:gsub("^game%.", "")
        
        local parts = {}
        for part in cleanPath:gmatch("[^%.]+") do
            table.insert(parts, part)
        end
        
        local current = game
        for _, part in ipairs(parts) do
            if current and current:FindFirstChild(part) then
                current = current[part]
            else
                return nil
            end
        end
        
        return current
    end
    
    local function shouldForceCanCollide(obj)
        if targetNames[obj.Name] then
            return true
        end
        
        for _, path in ipairs(partPaths) do
            local pathObj = getObjectFromPath(path)
            if pathObj == obj or (pathObj and pathObj:IsAncestorOf(obj)) then
                return true
            end
        end
        
        return false
    end
    
    local function forceCanCollide()
        for _, path in ipairs(partPaths) do
            local obj = getObjectFromPath(path)
            
            if obj then
                if obj:IsA("BasePart") then
                    if obj.CanCollide ~= true then
                        obj.CanCollide = true
                    end
                elseif obj:IsA("Model") then
                    for _, child in pairs(obj:GetDescendants()) do
                        if child:IsA("BasePart") and child.CanCollide ~= true then
                            child.CanCollide = true
                        end
                    end
                elseif obj:IsA("Folder") then
                    for _, child in pairs(obj:GetDescendants()) do
                        if child:IsA("BasePart") and child.CanCollide ~= true then
                            child.CanCollide = true
                        end
                    end
                end
            end
        end
        
        for _, descendant in pairs(game.Workspace:GetDescendants()) do
            if descendant:IsA("BasePart") and shouldForceCanCollide(descendant) then
                if descendant.CanCollide ~= true then
                    descendant.CanCollide = true
                end
            end
        end
    end
    
    local function setupPropertyListeners()
        for _, path in ipairs(partPaths) do
            local obj = getObjectFromPath(path)
            
            if obj then
                if obj:IsA("BasePart") then
                    obj:GetPropertyChangedSignal("CanCollide"):Connect(function()
                        if obj.CanCollide ~= true then
                            obj.CanCollide = true
                        end
                    end)
                elseif obj:IsA("Model") or obj:IsA("Folder") then
                    for _, child in pairs(obj:GetDescendants()) do
                        if child:IsA("BasePart") then
                            child:GetPropertyChangedSignal("CanCollide"):Connect(function()
                                if child.CanCollide ~= true then
                                    child.CanCollide = true
                                end
                            end)
                        end
                    end
                    
                    obj.DescendantAdded:Connect(function(descendant)
                        if descendant:IsA("BasePart") then
                            descendant.CanCollide = true
                            descendant:GetPropertyChangedSignal("CanCollide"):Connect(function()
                                if descendant.CanCollide ~= true then
                                    descendant.CanCollide = true
                                end
                            end)
                        end
                    end)
                end
            end
        end
        
        for _, descendant in pairs(game.Workspace:GetDescendants()) do
            if descendant:IsA("BasePart") and shouldForceCanCollide(descendant) then
                descendant:GetPropertyChangedSignal("CanCollide"):Connect(function()
                    if descendant.CanCollide ~= true then
                        descendant.CanCollide = true
                    end
                end)
            end
        end
    end
    
    return {
        init = function()
            forceCanCollide()
            setupPropertyListeners()
        end,
        
        enable = function()
            ConnectionManager:add("antiTroll", Services.RunService.Heartbeat:Connect(function()
                forceCanCollide()
            end))
            
            ConnectionManager:add("antiTrollDescendantAdded", game.Workspace.DescendantAdded:Connect(function(descendant)
                wait(0.1)
                
                if descendant:IsA("BasePart") and shouldForceCanCollide(descendant) then
                    descendant.CanCollide = true
                    descendant:GetPropertyChangedSignal("CanCollide"):Connect(function()
                        if descendant.CanCollide ~= true then
                            descendant.CanCollide = true
                        end
                    end)
                end
            end))
            
            Utils.notify("Anti-Troll Enabled", "Keeping trollers from doing their job!")
        end,
        
        disable = function()
            ConnectionManager:remove("antiTroll")
            ConnectionManager:remove("antiTrollDescendantAdded")
            Utils.notify("Anti-Troll Disabled", "Anti-Troll has been disabled.")
        end,
        
        cleanup = function()
        end
    }
end

local InfiniteJumpFeature = {
    init = function()
    end,
    
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

local KillPartDisableFeature = {
    killParts = {},
    
    init = function(self)
        -- Initialize but don't execute yet
    end,
    
    enable = function(self)
        -- Your kill part disable code here
        self.killParts = {}
        
        -- Loop through all descendants in workspace
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") and string.find(obj.Name:lower(), "killpart") then
                table.insert(self.killParts, obj)
            end
        end
        
        -- Remove all TouchTransmitter instances from each kill part
        for _, part in ipairs(self.killParts) do
            for _, child in ipairs(part:GetChildren()) do
                if child:IsA("TouchTransmitter") then
                    child:Destroy()
                end
            end
        end
        
        Utils.notify("Kill Parts Disabled", #self.killParts .. " kill parts have been disabled.")
    end,
    
    disable = function(self)
        Utils.notify("Kill Parts Feature", "Feature disabled (parts remain disabled).")
    end
}

local UIManager = {
    window = nil,
    tabs = {},
    options = {},
    toggleGui = nil,
    
    init = function(self)
        self.window = Fluent:CreateWindow(CONFIG.UI.Window)
        self.options = Fluent.Options
        
        for _, tabConfig in ipairs(TAB_CONFIG) do
            self.tabs[tabConfig.Name] = self.window:AddTab({
                Title = tabConfig.Name,
                Icon = tabConfig.Icon
            })
        end
        
        self:createToggleButton()
        return self.window
    end,
    
    createToggleButton = function(self)
        self.toggleGui = Instance.new("ScreenGui")
        local toggleButton = Instance.new("ImageButton")
        local aspectRatio = Instance.new("UIAspectRatioConstraint")
        
        self.toggleGui.Name = "TowerHubToggle"
        self.toggleGui.ResetOnSpawn = false
        self.toggleGui.IgnoreGuiInset = true
        self.toggleGui.DisplayOrder = CONFIG.UI.ToggleButton.DisplayOrder
        self.toggleGui.Parent = LocalPlayer.PlayerGui
        
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
        
        aspectRatio.AspectRatio = 1
        aspectRatio.AspectType = Enum.AspectType.FitWithinMaxSize
        aspectRatio.DominantAxis = Enum.DominantAxis.Width
        aspectRatio.Parent = toggleButton
        
        toggleButton.MouseButton1Click:Connect(function()
            self:toggleVisibility()
        end)
        
        toggleButton.MouseEnter:Connect(function()
            Services.TweenService:Create(toggleButton, TweenInfo.new(0.2), {
                Size = buttonConfig.HoverSize
            }):Play()
        end)
        
        toggleButton.MouseLeave:Connect(function()
            Services.TweenService:Create(toggleButton, TweenInfo.new(0.2), {
                Size = buttonConfig.Size
            }):Play()
        end)
    end,
    
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
    
    addUniversalFeatures = function(self)
        for name, config in pairs(UNIVERSAL_FEATURES) do
            self.tabs.Universal:AddInput(name .. "Input", {
                Title = config.Title,
                Default = config.Default,
                Placeholder = "Enter " .. config.Title:lower(),
                Numeric = true
            })
            
            self.tabs.Universal:AddButton({
                Title = "Set " .. config.Title,
                Callback = function()
                    local value = self.options[name .. "Input"].Value
                    local success, message = Utils.setHumanoidProperty(
                        config.Property, 
                        value, 
                        config.UseJumpPower
                    )
                    
                    if success then
                        Utils.notify(config.Title .. " Updated", 
                                   "Your " .. config.Title .. " has been set to " .. value)
                    else
                        Utils.notify("Error", message, CONFIG.UI.Notifications.ErrorDuration)
                    end
                end
            })
        end
        
        self.tabs.Universal:AddToggle("NoclipToggle", {
            Title = "Noclip",
            Description = "Allows you to walk through walls.",
            Default = false,
            Callback = function(state)
                FeatureManager:toggle("noclip", state)
            end
        })
    end,
    
    addGameFeatures = function(self, gameData)
        self.tabs.Main:AddParagraph({
            Title = "You're in " .. gameData.Name,
            Content = "The script is configured for this game. All features in this tab are available."
        })
        
        self.tabs.Main:AddSlider("TeleportDelay", {
            Title = "TP Delay (Seconds)",
            Description = "Delay between each teleport.",
            Default = CONFIG.FEATURES.Teleport.DefaultDelay,
            Min = CONFIG.FEATURES.Teleport.MinDelay,
            Max = CONFIG.FEATURES.Teleport.MaxDelay,
            Rounding = 1
        })
        
        if gameData.Waypoints then
            self.tabs.Main:AddButton({
                Title = "Auto Get Slaps/Win",
                Callback = function()
                    self:executeAutoWin(gameData.Waypoints)
                end
            })
        end
        
        if table.find(gameData.Features, "AntiTroll") then
            self.tabs.Main:AddToggle("AntiTroll", {
                Title = "Anti-Troll",
                Description = "Keep trollers from doing their job!",
                Default = false,
                Callback = function(state)
                    FeatureManager:toggle("antiTroll", state)
                end
            })
        end
        
        if table.find(gameData.Features, "InfiniteJump") then
            self.tabs.Main:AddToggle("InfiniteJump", {
                Title = "Fake Wall-Hop",
                Description = "Lets you jump in air forever. (aka Infinite Jump)",
                Default = false,
                Callback = function(state)
                    FeatureManager:toggle("infiniteJump", state)
                end
            })
        end
    end,
    
if table.find(gameData.Features, "AntiKillpart") then
    self.tabs.Main:AddToggle("AntiKillpart", {
        Title = "Anti-Killpart",
        Description = "Removes TouchTransmitters from kill parts to prevent death.",
        Default = false,
        Callback = function(state)
            FeatureManager:toggle("antiKillpart", state)
        end
    })
end
end
    
    executeAutoWin = function(self, waypoints)
        local _, _, rootPart = Utils.getCharacterComponents()
        if not rootPart then
            Utils.notify("Error", "Could not find your character.", 
                        CONFIG.UI.Notifications.ErrorDuration)
            return
        end
        
        local originalCFrame = rootPart.CFrame
        local tpWait = self.options.TeleportDelay.Value
        
        for i, pos in ipairs(waypoints) do
            local success, message = Utils.safeTeleport(pos, tpWait)
            if success then
                Utils.notify("Teleporting", 
                           "Waypoint " .. i .. "/" .. #waypoints, 1)
            else
                Utils.notify("Teleport Error", message, 
                           CONFIG.UI.Notifications.ErrorDuration)
                break
            end
        end
        
        Utils.safeTeleport(originalCFrame.Position)
        Utils.notify("Finished", "Teleport sequence complete.", 
                    CONFIG.UI.Notifications.LoadDuration)
    end,
    
    addUnsupportedMessage = function(self)
        self.tabs.Main:AddParagraph({
            Title = "Unsupported Game",
            Content = "The current game is not supported. You can still use Universal and Settings."
        })
    end,
    
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
    
    cleanup = function(self)
        if self.toggleGui then
            self.toggleGui:Destroy()
        end
    end
}

local function initializeScript()
    local currentPlaceId = game.PlaceId
    local currentGameData = GAME_DATA[currentPlaceId]
    
    FeatureManager:register("noclip", NoclipFeature)
    FeatureManager:register("killPartDisable", KillPartDisableFeature)
    FeatureManager:register("infiniteJump", InfiniteJumpFeature)
    
    if currentGameData then
        if table.find(currentGameData.Features or {}, "AntiTroll") then
            FeatureManager:register("antiTroll", createAntiTrollFeature())
        end
    end
    FeatureManager:register("antiKillpart", AntiKillpartFeature)
    UIManager:init()
    
    UIManager:addUniversalFeatures()
    
    if currentGameData then
        UIManager:addGameFeatures(currentGameData)
    else
        UIManager:addUnsupportedMessage()
    end
    
    UIManager:setupSaveSystem()
    
    if CONFIG.FEATURES.AntiIdle then
        LocalPlayer.Idled:Connect(function()
            Services.VirtualUser:CaptureController()
            Services.VirtualUser:ClickButton2(Vector2.new())
        end)
    end
    
    if CONFIG.FEATURES.AutoCleanup then
        game:GetService("Players").PlayerRemoving:Connect(function(player)
            if player == LocalPlayer then
                cleanup()
            end
        end)
        
        if UIManager.window and UIManager.window.Root then
            UIManager.window.Root.AncestryChanged:Connect(function()
                if not UIManager.window.Root.Parent then
                    cleanup()
                end
            end)
        end
    end
    
    UIManager.window:SelectTab(1)
    Utils.notify("TowerHub Loaded", "Script has been loaded successfully!", 
                CONFIG.UI.Notifications.LoadDuration)
    SaveManager:LoadAutoloadConfig()
end

function cleanup()
    FeatureManager:cleanup()
    ConnectionManager:cleanup()
    UIManager:cleanup()
end

initializeScript()
