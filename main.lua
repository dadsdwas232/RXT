-- [[ 👑 RXT SERVER - V10 GHOST FARM FIX - Key System ]] + FLIGHT SYSTEM

if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")
local player = Players.LocalPlayer

-- [[ 🔑 Key System ]] --
local validKeys = {}

-- [[ ⚙️ Settings ]] --
local stealthSpeedEnabled = false
local speedValue = 50
local noclipEnabled = false
local instantInteractionEnabled = false
local infJumpEnabled = false
local noRagdollEnabled = false
local radioactiveFarmEnabled = false
local savedPosition = nil
local antiAFKEnabled = true -- Anti-AFK enabled by default
local lastAFKAction = 0 -- Track last anti-AFK action

-- [[ 🚀 FLIGHT SYSTEM ]] --
local isFlying = false
local flySpeed = 100
local flightConnection
local bodyVelocity, bodyGyro
local coordinatesEnabled = false
local coordinatesConnection
local flightUIFrame

-- [[ 🛠️ Backend Functions ]] --

-- [1] Advanced Anti-AFK System (Every 15 minutes)
local antiAFKConnection
local function ToggleAntiAFK(state)
    antiAFKEnabled = state
    
    if antiAFKConnection then
        antiAFKConnection:Disconnect()
        antiAFKConnection = nil
    end
    
    if state then
        -- Method 1: VirtualUser (Works in most games)
        local VU = game:GetService("VirtualUser")
        antiAFKConnection = player.Idled:Connect(function()
            VU:CaptureController()
            VU:ClickButton2(Vector2.new())
            print("🔄 Anti-AFK: Prevented kick (Idle detection)")
        end)
        
        -- Method 2: Scheduled movement every 15 minutes (900 seconds)
        task.spawn(function()
            while antiAFKEnabled do
                task.wait(900) -- Every 15 minutes (900 seconds)
                
                -- Record time
                lastAFKAction = os.time()
                
                -- Simulate small movement
                if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    local root = player.Character.HumanoidRootPart
                    
                    -- Very small invisible movement (0.001 studs)
                    local originalPosition = root.Position
                    
                    -- Move up 0.001 studs
                    root.CFrame = root.CFrame * CFrame.new(0, 0.001, 0)
                    task.wait(0.05)
                    
                    -- Move back down
                    root.CFrame = root.CFrame * CFrame.new(0, -0.001, 0)
                    task.wait(0.05)
                    
                    -- Restore original position
                    root.CFrame = CFrame.new(originalPosition) * (root.CFrame - root.Position)
                    
                    print("📡 Anti-AFK: Micro-movement completed")
                end
                
                -- Simulate camera movement (very subtle)
                local camera = workspace.CurrentCamera
                if camera then
                    local currentCF = camera.CFrame
                    
                    -- Tiny camera rotation (0.1 degree)
                    camera.CFrame = currentCF * CFrame.Angles(0, math.rad(0.1), 0)
                    task.wait(0.05)
                    camera.CFrame = currentCF * CFrame.Angles(0, math.rad(-0.1), 0)
                    task.wait(0.05)
                    camera.CFrame = currentCF
                    
                    print("📷 Anti-AFK: Camera adjustment completed")
                end
                
                -- Simulate space key press (very quick)
                local virtualInput = game:GetService("VirtualInputManager")
                virtualInput:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
                task.wait(0.05)
                virtualInput:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
                
                -- Status update
                local currentTime = os.date("%H:%M:%S")
                print("✅ Anti-AFK: Protection active | Time: " .. currentTime)
                print("⏰ Next action in 15 minutes")
            end
        end)
        
        -- Method 3: Character reset prevention
        player.CharacterAdded:Connect(function()
            if antiAFKEnabled then
                task.wait(2)
                print("♻️ Anti-AFK: Character respawned, protection remains active")
            end
        end)
        
        -- Initial status
        lastAFKAction = os.time()
        print("✅ Anti-AFK: Protection activated")
        print("⏰ First action will occur in 15 minutes")
        
    else
        print("❌ Anti-AFK: Protection deactivated")
    end
end

-- Start Anti-AFK by default
task.wait(1)
ToggleAntiAFK(true)

-- [2] Fixed Speed and Jump Engine
local speedConnection
local function UpdateSpeed()
    if speedConnection then
        speedConnection:Disconnect()
    end
    
    speedConnection = RunService.Stepped:Connect(function()
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            local hum = player.Character.Humanoid
            
            -- Update speed value from input
            speedValue = tonumber(speedInput.Text) or 50
            
            -- Apply speed
            if stealthSpeedEnabled then
                hum.WalkSpeed = speedValue
            else
                hum.WalkSpeed = 16
            end
            
            -- Radioactive farm protection
            if radioactiveFarmEnabled and player.Character:FindFirstChild("HumanoidRootPart") then
                local root = player.Character.HumanoidRootPart
                for _, v in pairs(player.Character:GetDescendants()) do
                    if v:IsA("BasePart") then
                        v.CanCollide = false
                    end
                end
                root.Velocity = Vector3.new(root.Velocity.X, 0, root.Velocity.Z)
            end
        end
    end)
end

-- Call once to start
UpdateSpeed()

-- [3] Infinite Jump
UserInputService.JumpRequest:Connect(function()
    if infJumpEnabled and player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
        player.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

-- [4] Ghost Farm Collection
task.spawn(function()
    while task.wait(0.05) do
        if radioactiveFarmEnabled and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local root = player.Character.HumanoidRootPart
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("TouchTransmitter") then
                    local p = v.Parent
                    if p and (p.Name:lower():find("radioactive") or p.Name:lower():find("coin")) then
                        firetouchinterest(root, p, 0)
                        task.wait()
                        firetouchinterest(root, p, 1)
                    end
                end
            end
        end
    end
end)

-- [5] FLIGHT SYSTEM FUNCTIONS
local function startFlight()
    if isFlying or not player.Character then return end
    isFlying = true
    
    local character = player.Character
    local humanoid = character:FindFirstChild("Humanoid")
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    
    if not humanoid or not rootPart then return end
    
    humanoid.PlatformStand = true
    
    -- Remove collision
    for _, part in pairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end
    
    -- Create flight controls
    bodyGyro = Instance.new("BodyGyro")
    bodyGyro.P = 15000
    bodyGyro.D = 2000
    bodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    bodyGyro.CFrame = rootPart.CFrame
    bodyGyro.Parent = rootPart
    
    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bodyVelocity.Parent = rootPart
    
    flightConnection = RunService.Heartbeat:Connect(function()
        if not isFlying or not character then
            if flightConnection then flightConnection:Disconnect() end
            return
        end
        
        local camera = workspace.CurrentCamera
        if not camera then return end
        
        local moveDirection = Vector3.new(0, 0, 0)
        
        -- Movement controls
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            moveDirection = moveDirection + camera.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            moveDirection = moveDirection - camera.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            moveDirection = moveDirection - camera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            moveDirection = moveDirection + camera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            moveDirection = moveDirection + Vector3.new(0, 1, 0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Q) then
            moveDirection = moveDirection - Vector3.new(0, 1, 0)
        end
        
        -- Apply speed
        local currentSpeed = flySpeed
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
            currentSpeed = flySpeed * 2
        end
        
        if moveDirection.Magnitude > 0 then
            moveDirection = moveDirection.Unit * currentSpeed
        end
        
        -- Update velocity
        if bodyVelocity then
            bodyVelocity.Velocity = moveDirection
        end
        
        -- Update rotation
        if bodyGyro then
            bodyGyro.CFrame = CFrame.new(rootPart.Position, rootPart.Position + camera.CFrame.LookVector)
        end
    end)
    
    print("🚀 FLIGHT SYSTEM: Activated | Speed: " .. flySpeed)
    
    -- Show flight UI if enabled
    if flightUIEnabled then
        showFlightUI()
    end
    if coordinatesEnabled then
        toggleCoordinates(true)
    end
end

local function stopFlight()
    if not isFlying then return end
    isFlying = false
    
    if bodyGyro then bodyGyro:Destroy() end
    if bodyVelocity then bodyVelocity:Destroy() end
    
    if player.Character then
        local humanoid = player.Character:FindFirstChild("Humanoid")
        if humanoid then 
            humanoid.PlatformStand = false
        end
        
        -- Restore collision
        for _, part in pairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
    
    if flightConnection then
        flightConnection:Disconnect()
        flightConnection = nil
    end
    
    print("🛑 FLIGHT SYSTEM: Deactivated")
    
    -- Hide flight UI
    hideFlightUI()
end

local function changeFlightSpeed(amount)
    flySpeed = math.max(1, flySpeed + amount)
    if isFlying then
        print("⚡ FLIGHT SPEED: " .. flySpeed)
    end
end

local function toggleCoordinates(state)
    coordinatesEnabled = state
    
    if coordinatesConnection then
        coordinatesConnection:Disconnect()
        coordinatesConnection = nil
    end
    
    if CoreGui:FindFirstChild("RXT_Coordinates") then
        CoreGui:FindFirstChild("RXT_Coordinates"):Destroy()
    end
    
    if state then
        local coordGui = Instance.new("ScreenGui", CoreGui)
        coordGui.Name = "RXT_Coordinates"
        coordGui.ResetOnSpawn = false
        
        local coordFrame = Instance.new("Frame", coordGui)
        coordFrame.Size = UDim2.new(0, 200, 0, 60)
        coordFrame.Position = UDim2.new(1, -210, 1, -200)
        coordFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
        coordFrame.BackgroundTransparency = 0.2
        Instance.new("UICorner", coordFrame).CornerRadius = UDim.new(0, 10)
        
        local coordText = Instance.new("TextLabel", coordFrame)
        coordText.Name = "CoordText"
        coordText.Text = "Height: 0"
        coordText.Size = UDim2.new(1, 0, 1, 0)
        coordText.BackgroundTransparency = 1
        coordText.TextColor3 = Color3.new(1, 1, 1)
        coordText.Font = Enum.Font.Gotham
        coordText.TextSize = 14
        
        coordinatesConnection = RunService.Heartbeat:Connect(function()
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local root = player.Character.HumanoidRootPart
                local height = math.floor(root.Position.Y)
                coordText.Text = string.format("Height: %d", height)
            end
        end)
    end
end

-- [6] FLIGHT UI FUNCTIONS
local flightUIEnabled = false

local function showFlightUI()
    if flightUIFrame then
        flightUIFrame:Destroy()
    end
    
    local flightScreenGui = Instance.new("ScreenGui", CoreGui)
    flightScreenGui.Name = "FlightUI"
    flightScreenGui.ResetOnSpawn = false
    
    flightUIFrame = Instance.new("Frame", flightScreenGui)
    flightUIFrame.Size = UDim2.new(0, 220, 0, 180)
    flightUIFrame.Position = UDim2.new(0, 20, 0.5, -90)
    flightUIFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
    flightUIFrame.BackgroundTransparency = 0.2
    
    local corner = Instance.new("UICorner", flightUIFrame)
    corner.CornerRadius = UDim.new(0, 10)
    
    local stroke = Instance.new("UIStroke", flightUIFrame)
    stroke.Color = Color3.fromRGB(0, 150, 255)
    stroke.Thickness = 2
    
    -- Title
    local title = Instance.new("TextLabel", flightUIFrame)
    title.Text = "✈️ FLIGHT SPEED"
    title.Size = UDim2.new(1, 0, 0, 30)
    title.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
    title.TextColor3 = Color3.new(1, 1, 1)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 14
    Instance.new("UICorner", title).CornerRadius = UDim.new(0, 10)
    
    -- Speed Display
    local speedDisplay = Instance.new("TextLabel", flightUIFrame)
    speedDisplay.Text = "Speed: " .. flySpeed
    speedDisplay.Size = UDim2.new(0.9, 0, 0, 25)
    speedDisplay.Position = UDim2.new(0.05, 0, 0.2, 0)
    speedDisplay.BackgroundTransparency = 1
    speedDisplay.TextColor3 = Color3.new(1, 1, 1)
    speedDisplay.Font = Enum.Font.GothamBold
    speedDisplay.TextSize = 16
    
    -- Speed Control Buttons
    local controlFrame = Instance.new("Frame", flightUIFrame)
    controlFrame.Size = UDim2.new(0.9, 0, 0, 35)
    controlFrame.Position = UDim2.new(0.05, 0, 0.35, 0)
    controlFrame.BackgroundTransparency = 1
    
    -- Decrease -100 Button
    local dec100Btn = Instance.new("TextButton", controlFrame)
    dec100Btn.Text = "-100"
    dec100Btn.Size = UDim2.new(0.45, 0, 1, 0)
    dec100Btn.BackgroundColor3 = Color3.fromRGB(220, 80, 80)
    dec100Btn.TextColor3 = Color3.new(1, 1, 1)
    dec100Btn.Font = Enum.Font.GothamBold
    dec100Btn.TextSize = 14
    Instance.new("UICorner", dec100Btn).CornerRadius = UDim.new(0, 6)
    
    dec100Btn.MouseButton1Click:Connect(function()
        changeFlightSpeed(-100)
        speedDisplay.Text = "Speed: " .. flySpeed
    end)
    
    -- Increase +100 Button
    local inc100Btn = Instance.new("TextButton", controlFrame)
    inc100Btn.Text = "+100"
    inc100Btn.Size = UDim2.new(0.45, 0, 1, 0)
    inc100Btn.Position = UDim2.new(0.55, 0, 0, 0)
    inc100Btn.BackgroundColor3 = Color3.fromRGB(80, 200, 80)
    inc100Btn.TextColor3 = Color3.new(1, 1, 1)
    inc100Btn.Font = Enum.Font.GothamBold
    inc100Btn.TextSize = 14
    Instance.new("UICorner", inc100Btn).CornerRadius = UDim.new(0, 6)
    
    inc100Btn.MouseButton1Click:Connect(function()
        changeFlightSpeed(100)
        speedDisplay.Text = "Speed: " .. flySpeed
    end)
    
    -- Quick Speed Buttons Frame
    local quickSpeedFrame = Instance.new("Frame", flightUIFrame)
    quickSpeedFrame.Size = UDim2.new(0.9, 0, 0, 70)
    quickSpeedFrame.Position = UDim2.new(0.05, 0, 0.55, 0)
    quickSpeedFrame.BackgroundTransparency = 1
    
    -- 500 Button
    local speed500Btn = Instance.new("TextButton", quickSpeedFrame)
    speed500Btn.Text = "500"
    speed500Btn.Size = UDim2.new(0.3, 0, 0, 30)
    speed500Btn.BackgroundColor3 = Color3.fromRGB(60, 120, 200)
    speed500Btn.TextColor3 = Color3.new(1, 1, 1)
    speed500Btn.Font = Enum.Font.GothamBold
    speed500Btn.TextSize = 12
    Instance.new("UICorner", speed500Btn).CornerRadius = UDim.new(0, 6)
    
    speed500Btn.MouseButton1Click:Connect(function()
        flySpeed = 500
        speedDisplay.Text = "Speed: " .. flySpeed
    end)
    
    -- 1000 Button
    local speed1000Btn = Instance.new("TextButton", quickSpeedFrame)
    speed1000Btn.Text = "1000"
    speed1000Btn.Size = UDim2.new(0.3, 0, 0, 30)
    speed1000Btn.Position = UDim2.new(0.35, 0, 0, 0)
    speed1000Btn.BackgroundColor3 = Color3.fromRGB(200, 120, 60)
    speed1000Btn.TextColor3 = Color3.new(1, 1, 1)
    speed1000Btn.Font = Enum.Font.GothamBold
    speed1000Btn.TextSize = 12
    Instance.new("UICorner", speed1000Btn).CornerRadius = UDim.new(0, 6)
    
    speed1000Btn.MouseButton1Click:Connect(function()
        flySpeed = 1000
        speedDisplay.Text = "Speed: " .. flySpeed
    end)
    
    -- 5000 Button
    local speed5000Btn = Instance.new("TextButton", quickSpeedFrame)
    speed5000Btn.Text = "5000"
    speed5000Btn.Size = UDim2.new(0.3, 0, 0, 30)
    speed5000Btn.Position = UDim2.new(0.7, 0, 0, 0)
    speed5000Btn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
    speed5000Btn.TextColor3 = Color3.new(1, 1, 1)
    speed5000Btn.Font = Enum.Font.GothamBold
    speed5000Btn.TextSize = 12
    Instance.new("UICorner", speed5000Btn).CornerRadius = UDim.new(0, 6)
    
    speed5000Btn.MouseButton1Click:Connect(function()
        flySpeed = 5000
        speedDisplay.Text = "Speed: " .. flySpeed
    end)
    
    -- Stop Flight Button
    local stopBtn = Instance.new("TextButton", quickSpeedFrame)
    stopBtn.Text = "🛑 STOP FLIGHT"
    stopBtn.Size = UDim2.new(1, 0, 0, 30)
    stopBtn.Position = UDim2.new(0, 0, 1, -30)
    stopBtn.BackgroundColor3 = Color3.fromRGB(220, 80, 80)
    stopBtn.TextColor3 = Color3.new(1, 1, 1)
    stopBtn.Font = Enum.Font.GothamBold
    stopBtn.TextSize = 13
    Instance.new("UICorner", stopBtn).CornerRadius = UDim.new(0, 6)
    
    stopBtn.MouseButton1Click:Connect(function()
        stopFlight()
    end)
    
    -- Make draggable
    local dragging = false
    local dragStart, startPos
    
    flightUIFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = flightUIFrame.Position
        end
    end)
    
    flightUIFrame.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            flightUIFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    flightUIFrame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
end

local function hideFlightUI()
    if flightUIFrame then
        flightUIFrame:Destroy()
        flightUIFrame = nil
    end
end

local function toggleFlightUI(state)
    flightUIEnabled = state
    if state and isFlying then
        showFlightUI()
    else
        hideFlightUI()
    end
end

-- [[ 🎨 Key GUI ]] --
local function CreateKeyGui()
    if CoreGui:FindFirstChild("RXT_KeyGUI") then
        CoreGui["RXT_KeyGUI"]:Destroy()
    end
    
    local KeyGui = Instance.new("ScreenGui", CoreGui)
    KeyGui.Name = "RXT_KeyGUI"
    KeyGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Background
    local Background = Instance.new("Frame")
    Background.Size = UDim2.new(1, 0, 1, 0)
    Background.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Background.BackgroundTransparency = 0.7
    Background.Parent = KeyGui
    
    -- Main Window
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 350, 0, 250) -- أصغر حجم
    MainFrame.Position = UDim2.new(0.5, -175, 0.5, -125)
    MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = KeyGui
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 12)
    UICorner.Parent = MainFrame
    
    local UIStroke = Instance.new("UIStroke")
    UIStroke.Color = Color3.fromRGB(150, 100, 255)
    UIStroke.Thickness = 2
    UIStroke.Parent = MainFrame
    
    -- Main Title
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(0.9, 0, 0, 60)
    Title.Position = UDim2.new(0.05, 0, 0.05, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "🔐 RXT V10\n━━━━━━━━━━\n24 HOUR KEY"
    Title.TextColor3 = Color3.fromRGB(170, 120, 255)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 16
    Title.TextXAlignment = Enum.TextXAlignment.Center
    Title.Parent = MainFrame
    
    -- Key Section
    local KeyFrame = Instance.new("Frame")
    KeyFrame.Size = UDim2.new(0.9, 0, 0, 70)
    KeyFrame.Position = UDim2.new(0.05, 0, 0.35, 0)
    KeyFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    KeyFrame.Parent = MainFrame
    
    local KeyUICorner = Instance.new("UICorner")
    KeyUICorner.CornerRadius = UDim.new(0, 10)
    KeyUICorner.Parent = KeyFrame
    
    local KeyLabel = Instance.new("TextLabel")
    KeyLabel.Size = UDim2.new(1, 0, 0, 25)
    KeyLabel.BackgroundTransparency = 1
    KeyLabel.Text = "🔑 KEY: RXT24"
    KeyLabel.TextColor3 = Color3.new(1, 1, 1)
    KeyLabel.Font = Enum.Font.GothamBold
    KeyLabel.TextSize = 14
    KeyLabel.Parent = KeyFrame
    
    local KeyBox = Instance.new("TextBox")
    KeyBox.Size = UDim2.new(0.9, 0, 0, 35)
    KeyBox.Position = UDim2.new(0.05, 0, 0.5, 0)
    KeyBox.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    KeyBox.TextColor3 = Color3.new(1, 1, 1)
    KeyBox.Font = Enum.Font.GothamBold
    KeyBox.TextSize = 14
    KeyBox.PlaceholderText = "Type RXT24 here..."
    KeyBox.Text = ""
    KeyBox.Parent = KeyFrame
    
    local KeyBoxCorner = Instance.new("UICorner")
    KeyBoxCorner.CornerRadius = UDim.new(0, 8)
    KeyBoxCorner.Parent = KeyBox
    
    -- Activate Button
    local ActivateBtn = Instance.new("TextButton")
    ActivateBtn.Size = UDim2.new(0.9, 0, 0, 40)
    ActivateBtn.Position = UDim2.new(0.05, 0, 0.75, 0)
    ActivateBtn.BackgroundColor3 = Color3.fromRGB(120, 70, 220)
    ActivateBtn.Text = "⚡ ACTIVATE"
    ActivateBtn.TextColor3 = Color3.new(1, 1, 1)
    ActivateBtn.Font = Enum.Font.GothamBold
    ActivateBtn.TextSize = 16
    ActivateBtn.Parent = MainFrame
    
    local ActivateCorner = Instance.new("UICorner")
    ActivateCorner.CornerRadius = UDim.new(0, 10)
    ActivateCorner.Parent = ActivateBtn
    
    -- Status Message
    local StatusLabel = Instance.new("TextLabel")
    StatusLabel.Size = UDim2.new(0.9, 0, 0, 25)
    StatusLabel.Position = UDim2.new(0.05, 0, 0.92, 0)
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.Text = "⌛ Enter key to activate"
    StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    StatusLabel.Font = Enum.Font.Gotham
    StatusLabel.TextSize = 12
    StatusLabel.Parent = MainFrame
    
    -- Developers Text
    local DevText = Instance.new("TextLabel")
    DevText.Size = UDim2.new(1, 0, 0, 20)
    DevText.Position = UDim2.new(0, 0, 1, -20)
    DevText.BackgroundTransparency = 1
    DevText.Text = "⚒️ 3zf & RXT | V10"
    DevText.TextColor3 = Color3.fromRGB(150, 100, 255)
    DevText.Font = Enum.Font.GothamBold
    DevText.TextSize = 11
    DevText.Parent = MainFrame
    
    -- Activation Function
    ActivateBtn.MouseButton1Click:Connect(function()
        local enteredKey = KeyBox.Text:upper():gsub("%s+", "")
        
        if enteredKey == "RXT24" then
            StatusLabel.Text = "✅ Activated! Loading..."
            StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
            
            -- Success effect
            ActivateBtn.Text = "✅ ACTIVATED!"
            ActivateBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 80)
            
            task.wait(1.5)
            KeyGui:Destroy()
            CreateMainGui()
        else
            StatusLabel.Text = "❌ Wrong Key! Use: RXT24"
            StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
            
            -- Error effect
            ActivateBtn.Text = "❌ WRONG!"
            ActivateBtn.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
            
            task.wait(1)
            ActivateBtn.Text = "⚡ ACTIVATE"
            ActivateBtn.BackgroundColor3 = Color3.fromRGB(120, 70, 220)
        end
    end)
    
    -- Button Hover Effects
    ActivateBtn.MouseEnter:Connect(function()
        ActivateBtn.BackgroundColor3 = Color3.fromRGB(140, 90, 240)
    end)
    
    ActivateBtn.MouseLeave:Connect(function()
        ActivateBtn.BackgroundColor3 = Color3.fromRGB(120, 70, 220)
    end)
    
    return KeyGui
end

-- [[ 🎨 Main GUI (أصغر) ]] --
function CreateMainGui()
    if CoreGui:FindFirstChild("RXT_Master_V10") then
        CoreGui["RXT_Master_V10"]:Destroy()
    end
    
    local ScreenGui = Instance.new("ScreenGui", CoreGui)
    ScreenGui.Name = "RXT_Master_V10"
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    local Main = Instance.new("Frame", ScreenGui)
    Main.Size = UDim2.new(0, 320, 0, 420) -- أصغر من السابق
    Main.Position = UDim2.new(0.5, -160, 0.5, -210)
    Main.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
    Main.BorderSizePixel = 0
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 12)
    UICorner.Parent = Main
    
    local UIStroke = Instance.new("UIStroke")
    UIStroke.Color = Color3.fromRGB(150, 100, 255)
    UIStroke.Thickness = 2
    UIStroke.Parent = Main
    
    -- Header (أصغر)
    local Header = Instance.new("TextLabel", Main)
    Header.Size = UDim2.new(1, -15, 0, 70)
    Header.Position = UDim2.new(0, 10, 0, 10)
    Header.BackgroundTransparency = 1
    Header.Text = [[
👑 RXT V10
━━━━━━━━
⚡ GHOST FARM
🚀 FLIGHT
⚒️ 3zf & RXT
]]
    Header.TextColor3 = Color3.fromRGB(170, 120, 255)
    Header.Font = Enum.Font.GothamBold
    Header.TextSize = 12
    Header.TextYAlignment = Enum.TextYAlignment.Top
    
    -- Close Button (أصغر)
    local CloseBtn = Instance.new("TextButton", Main)
    CloseBtn.Size = UDim2.new(0, 30, 0, 30)
    CloseBtn.Position = UDim2.new(1, -40, 0, 10)
    CloseBtn.Text = "✕"
    CloseBtn.BackgroundColor3 = Color3.fromRGB(220, 70, 70)
    CloseBtn.TextColor3 = Color3.new(1, 1, 1)
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.TextSize = 16
    Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(1, 0)
    
    -- Floating Open Button (Movable) (أصغر)
    local OpenBtn = Instance.new("TextButton", ScreenGui)
    OpenBtn.Size = UDim2.new(0, 50, 0, 50)
    OpenBtn.Position = UDim2.new(0, 15, 0.5, -25)
    OpenBtn.BackgroundColor3 = Color3.fromRGB(40, 30, 70)
    OpenBtn.Text = "RXT\nV10"
    OpenBtn.TextColor3 = Color3.fromRGB(170, 120, 255)
    OpenBtn.Font = Enum.Font.GothamBold
    OpenBtn.TextSize = 14
    OpenBtn.Visible = false
    Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(1, 0)
    
    local OpenStroke = Instance.new("UIStroke", OpenBtn)
    OpenStroke.Color = Color3.fromRGB(150, 100, 255)
    OpenStroke.Thickness = 2
    
    -- Make OpenBtn movable
    local openDragging = false
    local openDragStart, openStartPos
    
    OpenBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            openDragging = true
            openDragStart = input.Position
            openStartPos = OpenBtn.Position
        end
    end)
    
    OpenBtn.InputChanged:Connect(function(input)
        if openDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - openDragStart
            OpenBtn.Position = UDim2.new(openStartPos.X.Scale, openStartPos.X.Offset + delta.X, openStartPos.Y.Scale, openStartPos.Y.Offset + delta.Y)
        end
    end)
    
    OpenBtn.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            openDragging = false
        end
    end)
    
    CloseBtn.MouseButton1Click:Connect(function()
        Main.Visible = false
        OpenBtn.Visible = true
    end)
    
    OpenBtn.MouseButton1Click:Connect(function()
        Main.Visible = true
        OpenBtn.Visible = false
    end)
    
    -- Simple Dragging System for Main window
    local dragging = false
    local dragStart, startPos
    
    Main.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = Main.Position
        end
    end)
    
    Main.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    Main.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    -- Anti-AFK Status Indicator (أصغر)
    local afkStatus = Instance.new("TextLabel", ScreenGui)
    afkStatus.Size = UDim2.new(0, 180, 0, 30)
    afkStatus.Position = UDim2.new(1, -190, 1, -35)
    afkStatus.BackgroundColor3 = Color3.fromRGB(0, 100, 0)
    afkStatus.TextColor3 = Color3.new(1, 1, 1)
    afkStatus.Text = "🟢 ANTI-AFK: ON (15min)"
    afkStatus.Font = Enum.Font.GothamBold
    afkStatus.TextSize = 11
    Instance.new("UICorner", afkStatus)
    
    -- Anti-AFK Timer Display (أصغر)
    local afkTimer = Instance.new("TextLabel", ScreenGui)
    afkTimer.Size = UDim2.new(0, 180, 0, 20)
    afkTimer.Position = UDim2.new(1, -190, 1, -60)
    afkTimer.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    afkTimer.TextColor3 = Color3.new(1, 1, 1)
    afkTimer.Text = "Next: 15:00"
    afkTimer.Font = Enum.Font.Gotham
    afkTimer.TextSize = 10
    Instance.new("UICorner", afkTimer)
    
    -- Update AFK status and timer
    local function UpdateAFKStatus()
        if antiAFKEnabled then
            afkStatus.Text = "🟢 ANTI-AFK: ON (15min)"
            afkStatus.BackgroundColor3 = Color3.fromRGB(0, 100, 0)
            
            -- Calculate next action time
            local nextActionTime = lastAFKAction + 900
            local timeLeft = nextActionTime - os.time()
            
            if timeLeft > 0 then
                local minutes = math.floor(timeLeft / 60)
                local seconds = math.floor(timeLeft % 60)
                afkTimer.Text = string.format("Next: %02d:%02d", minutes, seconds)
            else
                afkTimer.Text = "Next: Soon"
            end
        else
            afkStatus.Text = "🔴 ANTI-AFK: OFF"
            afkStatus.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
            afkTimer.Text = "Timer: Inactive"
        end
    end
    
    -- Update timer every second
    task.spawn(function()
        while true do
            task.wait(1)
            UpdateAFKStatus()
        end
    end)
    
    UpdateAFKStatus()
    
    -- Discord reminder (أصغر)
    task.spawn(function()
        while true do
            task.wait(120)
            local Alert = Instance.new("TextLabel", ScreenGui)
            Alert.Size = UDim2.new(0, 250, 0, 35)
            Alert.Position = UDim2.new(0.5, -125, 1, -45)
            Alert.BackgroundColor3 = Color3.fromRGB(70, 40, 140)
            Alert.TextColor3 = Color3.new(1, 1, 1)
            Alert.Text = "📢 RXT V10 Active!"
            Alert.Font = Enum.Font.GothamBold
            Alert.TextSize = 12
            Instance.new("UICorner", Alert)
            task.wait(5)
            Alert:Destroy()
        end
    end)
    
    -- Tabs (أصغر)
    local TabHolder = Instance.new("Frame", Main)
    TabHolder.Size = UDim2.new(1, -15, 0, 35)
    TabHolder.Position = UDim2.new(0, 10, 0, 85)
    TabHolder.BackgroundTransparency = 1
    
    local TabList = Instance.new("UIListLayout", TabHolder)
    TabList.FillDirection = Enum.FillDirection.Horizontal
    TabList.HorizontalAlignment = Enum.HorizontalAlignment.Center
    TabList.Padding = UDim.new(0, 6)
    
    local Pages = Instance.new("Frame", Main)
    Pages.Size = UDim2.new(1, -15, 1, -135)
    Pages.Position = UDim2.new(0, 10, 0, 130)
    Pages.BackgroundTransparency = 1
    
    local function CreatePage()
        local p = Instance.new("ScrollingFrame", Pages)
        p.Size = UDim2.new(1, 0, 1, 0)
        p.BackgroundTransparency = 1
        p.Visible = false
        p.ScrollBarThickness = 0
        p.CanvasSize = UDim2.new(0, 0, 0, 0)
        local list = Instance.new("UIListLayout", p)
        list.Padding = UDim.new(0, 8)
        
        list:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            p.CanvasSize = UDim2.new(0, 0, 0, list.AbsoluteContentSize.Y)
        end)
        return p
    end
    
    local P1 = CreatePage() -- MAIN
    local P2 = CreatePage() -- EVENT
    local P3 = CreatePage() -- WORLD
    local P4 = CreatePage() -- TP
    local P5 = CreatePage() -- Dev
    P1.Visible = true
    
    local function AddTab(t, pg, icon)
        local b = Instance.new("TextButton", TabHolder)
        b.Size = UDim2.new(0, 60, 1, 0)
        b.Text = icon .. t
        b.TextColor3 = Color3.new(1, 1, 1)
        b.BackgroundTransparency = 1
        b.Font = Enum.Font.GothamBold
        b.TextSize = 10
        b.MouseButton1Click:Connect(function()
            P1.Visible = false; P2.Visible = false; P3.Visible = false
            P4.Visible = false; P5.Visible = false
            pg.Visible = true
        end)
    end
    
    AddTab("MAIN", P1, "🏠")
    AddTab("EVENT", P2, "🎯")
    AddTab("WORLD", P3, "🌎")
    AddTab("TP", P4, "📍")
    AddTab("DEV", P5, "⚒️")
    
    -- Toggle System (أصغر)
    local function AddToggle(parent, txt, current, cb)
        local b = Instance.new("TextButton", parent)
        b.Size = UDim2.new(1, 0, 0, 35)
        b.Text = txt .. " : OFF"
        b.BackgroundColor3 = Color3.fromRGB(35, 30, 60)
        b.TextColor3 = Color3.new(1, 1, 1)
        b.Font = Enum.Font.GothamBold
        b.TextSize = 12
        Instance.new("UICorner", b)
        
        local state = current
        local function Update()
            b.Text = state and txt .. " : ON" or txt .. " : OFF"
            b.BackgroundColor3 = state and Color3.fromRGB(0, 180, 100) or Color3.fromRGB(35, 30, 60)
        end
        
        b.MouseButton1Click:Connect(function()
            state = not state
            cb(state)
            Update()
        end)
        Update()
        return b
    end
    
    -- Button System (أصغر)
    local function AddButton(parent, txt, cb)
        local b = Instance.new("TextButton", parent)
        b.Size = UDim2.new(1, 0, 0, 35)
        b.Text = txt
        b.BackgroundColor3 = Color3.fromRGB(35, 30, 60)
        b.TextColor3 = Color3.new(1, 1, 1)
        b.Font = Enum.Font.GothamBold
        b.TextSize = 12
        Instance.new("UICorner", b)
        b.MouseButton1Click:Connect(cb)
        return b
    end
    
    -- [ Main Buttons ]
    -- Anti-AFK Toggle
    AddToggle(P1, "🛡️ Anti-AFK", antiAFKEnabled, function(s)
        antiAFKEnabled = s
        ToggleAntiAFK(s)
        UpdateAFKStatus()
    end)
    
    AddToggle(P1, "🧱 NoClip", noclipEnabled, function(s)
        noclipEnabled = s
        if s then
            RunService.Stepped:Connect(function()
                if noclipEnabled and player.Character then
                    for _, v in pairs(player.Character:GetDescendants()) do
                        if v:IsA("BasePart") then
                            v.CanCollide = false
                        end
                    end
                end
            end)
        end
    end)
    
    AddToggle(P1, "🦘 Inf Jump", infJumpEnabled, function(s)
        infJumpEnabled = s
    end)
    
    -- Speed Input (أصغر)
    speedInput = Instance.new("TextBox", P1)
    speedInput.Name = "SpeedInput"
    speedInput.Size = UDim2.new(1, 0, 0, 30)
    speedInput.PlaceholderText = "Speed (16-500)"
    speedInput.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    speedInput.TextColor3 = Color3.new(1, 1, 1)
    speedInput.Font = Enum.Font.Gotham
    speedInput.TextSize = 12
    speedInput.Text = "50"
    Instance.new("UICorner", speedInput)
    
    -- Speed Toggle
    AddToggle(P1, "🚀 Speed", stealthSpeedEnabled, function(s)
        stealthSpeedEnabled = s
        if s then
            -- Update speed value from input
            speedValue = tonumber(speedInput.Text) or 50
            print("✅ Speed: ON | Value: " .. speedValue)
        else
            print("❌ Speed: OFF")
        end
        UpdateSpeed() -- Update the speed connection
    end)
    
    -- Update speed when input changes
    speedInput.FocusLost:Connect(function()
        local newSpeed = tonumber(speedInput.Text)
        if newSpeed then
            if newSpeed < 16 then
                speedInput.Text = "16"
                speedValue = 16
            elseif newSpeed > 500 then
                speedInput.Text = "500"
                speedValue = 500
            else
                speedValue = newSpeed
            end
            print("📊 Speed: " .. speedValue)
            
            -- Update speed if stealth speed is enabled
            if stealthSpeedEnabled then
                UpdateSpeed()
            end
        else
            speedInput.Text = "50"
            speedValue = 50
        end
    end)
    
    -- Coordinates Toggle in MAIN tab
    AddToggle(P1, "📍 Coords", coordinatesEnabled, function(s)
        toggleCoordinates(s)
    end)
    
    -- Flight Info (أصغر)
    local flightInfo = Instance.new("TextLabel", P1)
    flightInfo.Size = UDim2.new(1, 0, 0, 50)
    flightInfo.BackgroundTransparency = 1
    flightInfo.Text = [[
🎮 FLIGHT:
WASD - Move
SPACE - Up
Q - Down
SHIFT - Boost
]]
    flightInfo.TextColor3 = Color3.fromRGB(150, 200, 255)
    flightInfo.Font = Enum.Font.Gotham
    flightInfo.TextSize = 10
    flightInfo.TextYAlignment = Enum.TextYAlignment.Top
    
    -- EVENT TAB (أصغر)
    AddToggle(P2, "☢️ Farm", radioactiveFarmEnabled, function(s)
        radioactiveFarmEnabled = s
    end)
    
    AddToggle(P2, "⚡ Instant E", instantInteractionEnabled, function(s)
        instantInteractionEnabled = s
        if s then
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("ProximityPrompt") then
                    v.HoldDuration = 0
                end
            end
        end
    end)
    
    -- [[ 🌎 WORLD TAB ]] --
    
    -- Flight System in WORLD tab
    AddToggle(P3, "✈️ Flight", isFlying, function(s)
        if s then 
            startFlight()
        else 
            stopFlight()
        end
    end)
    
    AddToggle(P3, "⚡ FPS Boost", false, function(s)
        if s then
            for _, v in pairs(game:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.Material = "SmoothPlastic"
                end
            end
        end
    end)
    
    AddToggle(P3, "👁️ Zoom", false, function(s)
        if s then
            player.CameraMaxZoomDistance = 100000
        end
    end)
    
    AddToggle(P3, "💡 Bright", false, function(s)
        if s then
            Lighting.Brightness = 2
            Lighting.ClockTime = 14
        end
    end)
    
    -- Current Flight Speed Display (أصغر)
    local currentSpeedDisplay = Instance.new("TextLabel", P3)
    currentSpeedDisplay.Text = "Flight Speed: " .. flySpeed
    currentSpeedDisplay.Size = UDim2.new(1, 0, 0, 20)
    currentSpeedDisplay.BackgroundTransparency = 1
    currentSpeedDisplay.TextColor3 = Color3.new(1, 1, 1)
    currentSpeedDisplay.Font = Enum.Font.GothamBold
    currentSpeedDisplay.TextSize = 14
    currentSpeedDisplay.Name = "CurrentSpeedDisplay"
    
    -- Flight UI Toggle
    AddToggle(P3, "📊 Flight UI", flightUIEnabled, function(s)
        toggleFlightUI(s)
    end)
    
    -- Flight Instructions (أصغر)
    local flightControlsInfo = Instance.new("TextLabel", P3)
    flightControlsInfo.Text = [[
🎮 FLIGHT:
• Turn ON Flight
• Adjust in UI
• Space: Up
• Q: Down
• Shift: Boost
]]
    flightControlsInfo.Size = UDim2.new(1, 0, 0, 70)
    flightControlsInfo.BackgroundTransparency = 1
    flightControlsInfo.TextColor3 = Color3.fromRGB(180, 180, 180)
    flightControlsInfo.Font = Enum.Font.Gotham
    flightControlsInfo.TextSize = 10
    flightControlsInfo.TextYAlignment = Enum.TextYAlignment.Top
    
    -- TP TAB (أصغر)
    local bSave = Instance.new("TextButton", P4)
    bSave.Size = UDim2.new(1, 0, 0, 35)
    bSave.Text = "📍 Save Pos"
    bSave.BackgroundColor3 = Color3.fromRGB(35, 30, 60)
    bSave.TextColor3 = Color3.new(1, 1, 1)
    bSave.Font = Enum.Font.GothamBold
    bSave.TextSize = 12
    Instance.new("UICorner", bSave)
    
    bSave.MouseButton1Click:Connect(function()
        if player.Character then
            savedPosition = player.Character.HumanoidRootPart.CFrame
            bSave.Text = "✅ Saved!"
            task.wait(1)
            bSave.Text = "📍 Save Pos"
        end
    end)
    
    local bTP = Instance.new("TextButton", P4)
    bTP.Size = UDim2.new(1, 0, 0, 35)
    bTP.Text = "🌀 TP to Saved"
    bTP.BackgroundColor3 = Color3.fromRGB(35, 30, 60)
    bTP.TextColor3 = Color3.new(1, 1, 1)
    bTP.Font = Enum.Font.GothamBold
    bTP.TextSize = 12
    Instance.new("UICorner", bTP)
    
    bTP.MouseButton1Click:Connect(function()
        if savedPosition then
            local root = player.Character.HumanoidRootPart
            local dist = (root.Position - savedPosition.Position).Magnitude
            local duration = dist / 120
            local start = tick()
            local startCF = root.CFrame
            local conn
            
            conn = RunService.Heartbeat:Connect(function()
                local elapsed = tick() - start
                if elapsed >= duration then
                    root.CFrame = savedPosition
                    conn:Disconnect()
                else
                    root.CFrame = startCF:Lerp(savedPosition, elapsed/duration)
                    root.Velocity = Vector3.new(0,0,0)
                end
            end)
        end
    end)
    
    -- [[ ⚒️ Developer Tab (أصغر) ]] --
    local DevLabel = Instance.new("TextLabel", P5)
    DevLabel.Size = UDim2.new(1, 0, 0, 150)
    DevLabel.BackgroundTransparency = 1
    DevLabel.Text = [[
⚒️ Developer Tools
━━━━━━━━━━
• 3zf & RXT
• V10
• Key: RXT24

🛡️ Anti-AFK:
• Every 15min
• Micro moves
• Camera adjust

⚡ Speed:
• Real-time
• 16-500 range

🚀 FLIGHT:
• Turn ON in WORLD
• Adjust in UI
• 500/1000/5000
]]
    DevLabel.TextColor3 = Color3.fromRGB(150, 100, 255)
    DevLabel.Font = Enum.Font.GothamBold
    DevLabel.TextSize = 12
    DevLabel.TextYAlignment = Enum.TextYAlignment.Top
    
    local ReloadBtn = Instance.new("TextButton", P5)
    ReloadBtn.Size = UDim2.new(1, 0, 0, 35)
    ReloadBtn.Position = UDim2.new(0, 0, 0, 160)
    ReloadBtn.Text = "🔄 Reload"
    ReloadBtn.BackgroundColor3 = Color3.fromRGB(35, 30, 60)
    ReloadBtn.TextColor3 = Color3.new(1, 1, 1)
    ReloadBtn.Font = Enum.Font.GothamBold
    ReloadBtn.TextSize = 12
    Instance.new("UICorner", ReloadBtn)
    
    ReloadBtn.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
        if flightUIFrame then
            flightUIFrame:Destroy()
        end
        task.wait(0.5)
        CreateKeyGui()
    end)
    
    -- Footer (أصغر)
    local Footer = Instance.new("TextLabel", Main)
    Footer.Size = UDim2.new(1, 0, 0, 25)
    Footer.Position = UDim2.new(0, 0, 1, -25)
    Footer.BackgroundTransparency = 1
    Footer.Text = "RXT V10 | 24H KEY | FLIGHT IN WORLD"
    Footer.TextColor3 = Color3.fromRGB(150, 100, 255)
    Footer.Font = Enum.Font.GothamBold
    Footer.TextSize = 10
    
    print("👑 RXT V10 LOADED - COMPACT UI")
    print("🚀 All features preserved")
    print("📏 Smaller interface")
end

-- Start with Key GUI
CreateKeyGui()
