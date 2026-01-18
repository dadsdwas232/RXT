-- [[ 👑 RXT SERVER - V10 GHOST FARM FIX - Key System ]]

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

-- [[ 🛠️ Backend Functions ]] --

-- [1] Anti-AFK
task.spawn(function()
    local VU = game:GetService("VirtualUser")
    player.Idled:Connect(function()
        VU:CaptureController()
        VU:ClickButton2(Vector2.new())
    end)
end)

-- [2] Speed and Jump Engine
RunService.Stepped:Connect(function()
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        local hum = player.Character.Humanoid
        local root = player.Character:FindFirstChild("HumanoidRootPart")
        
        if stealthSpeedEnabled then
            hum.WalkSpeed = speedValue
        else
            hum.WalkSpeed = 16
        end
        
        if radioactiveFarmEnabled and root then
            for _, v in pairs(player.Character:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.CanCollide = false
                end
            end
            root.Velocity = Vector3.new(root.Velocity.X, 0, root.Velocity.Z)
        end
    end
end)

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
    MainFrame.Size = UDim2.new(0, 400, 0, 300)
    MainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
    MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = KeyGui
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 15)
    UICorner.Parent = MainFrame
    
    local UIStroke = Instance.new("UIStroke")
    UIStroke.Color = Color3.fromRGB(150, 100, 255)
    UIStroke.Thickness = 3
    UIStroke.Parent = MainFrame
    
    -- Main Title
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(0.9, 0, 0, 80)
    Title.Position = UDim2.new(0.05, 0, 0.05, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "🔐 RXT SCRIPT V10\n━━━━━━━━━━━━━━━━━━\n24 HOUR KEY SYSTEM"
    Title.TextColor3 = Color3.fromRGB(170, 120, 255)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 20
    Title.TextXAlignment = Enum.TextXAlignment.Center
    Title.Parent = MainFrame
    
    -- Key Section
    local KeyFrame = Instance.new("Frame")
    KeyFrame.Size = UDim2.new(0.9, 0, 0, 80)
    KeyFrame.Position = UDim2.new(0.05, 0, 0.4, 0)
    KeyFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    KeyFrame.Parent = MainFrame
    
    local KeyUICorner = Instance.new("UICorner")
    KeyUICorner.CornerRadius = UDim.new(0, 12)
    KeyUICorner.Parent = KeyFrame
    
    local KeyLabel = Instance.new("TextLabel")
    KeyLabel.Size = UDim2.new(1, 0, 0, 30)
    KeyLabel.BackgroundTransparency = 1
    KeyLabel.Text = "🔑 ENTER KEY: RXT24"
    KeyLabel.TextColor3 = Color3.new(1, 1, 1)
    KeyLabel.Font = Enum.Font.GothamBold
    KeyLabel.TextSize = 16
    KeyLabel.Parent = KeyFrame
    
    local KeyBox = Instance.new("TextBox")
    KeyBox.Size = UDim2.new(0.9, 0, 0, 40)
    KeyBox.Position = UDim2.new(0.05, 0, 0.5, 0)
    KeyBox.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    KeyBox.TextColor3 = Color3.new(1, 1, 1)
    KeyBox.Font = Enum.Font.GothamBold
    KeyBox.TextSize = 16
    KeyBox.PlaceholderText = "Type RXT24 here..."
    KeyBox.Text = ""
    KeyBox.Parent = KeyFrame
    
    local KeyBoxCorner = Instance.new("UICorner")
    KeyBoxCorner.CornerRadius = UDim.new(0, 10)
    KeyBoxCorner.Parent = KeyBox
    
    -- Activate Button
    local ActivateBtn = Instance.new("TextButton")
    ActivateBtn.Size = UDim2.new(0.9, 0, 0, 50)
    ActivateBtn.Position = UDim2.new(0.05, 0, 0.75, 0)
    ActivateBtn.BackgroundColor3 = Color3.fromRGB(120, 70, 220)
    ActivateBtn.Text = "⚡ ACTIVATE SCRIPT"
    ActivateBtn.TextColor3 = Color3.new(1, 1, 1)
    ActivateBtn.Font = Enum.Font.GothamBold
    ActivateBtn.TextSize = 18
    ActivateBtn.Parent = MainFrame
    
    local ActivateCorner = Instance.new("UICorner")
    ActivateCorner.CornerRadius = UDim.new(0, 12)
    ActivateCorner.Parent = ActivateBtn
    
    -- Status Message
    local StatusLabel = Instance.new("TextLabel")
    StatusLabel.Size = UDim2.new(0.9, 0, 0, 30)
    StatusLabel.Position = UDim2.new(0.05, 0, 0.9, 0)
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.Text = "⌛ Enter key to activate the script"
    StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    StatusLabel.Font = Enum.Font.Gotham
    StatusLabel.TextSize = 14
    StatusLabel.Parent = MainFrame
    
    -- Developers Text
    local DevText = Instance.new("TextLabel")
    DevText.Size = UDim2.new(1, 0, 0, 30)
    DevText.Position = UDim2.new(0, 0, 1, -30)
    DevText.BackgroundTransparency = 1
    DevText.Text = "⚒️ Developed by 3zf & RXT | V10"
    DevText.TextColor3 = Color3.fromRGB(150, 100, 255)
    DevText.Font = Enum.Font.GothamBold
    DevText.TextSize = 12
    DevText.Parent = MainFrame
    
    -- Activation Function
    ActivateBtn.MouseButton1Click:Connect(function()
        local enteredKey = KeyBox.Text:upper():gsub("%s+", "")
        
        if enteredKey == "RXT24" then
            StatusLabel.Text = "✅ Activated Successfully! Loading..."
            StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
            
            -- Success effect
            ActivateBtn.Text = "✅ ACTIVATED!"
            ActivateBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 80)
            
            task.wait(1.5)
            KeyGui:Destroy()
            CreateMainGui()
        else
            StatusLabel.Text = "❌ Wrong Key! Correct Key: RXT24"
            StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
            
            -- Error effect
            ActivateBtn.Text = "❌ WRONG KEY!"
            ActivateBtn.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
            
            task.wait(1)
            ActivateBtn.Text = "⚡ ACTIVATE SCRIPT"
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

-- [[ 🎨 Main GUI ]] --
function CreateMainGui()
    if CoreGui:FindFirstChild("RXT_Master_V10") then
        CoreGui["RXT_Master_V10"]:Destroy()
    end
    
    local ScreenGui = Instance.new("ScreenGui", CoreGui)
    ScreenGui.Name = "RXT_Master_V10"
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    local Main = Instance.new("Frame", ScreenGui)
    Main.Size = UDim2.new(0, 360, 0, 500)
    Main.Position = UDim2.new(0.5, -180, 0.5, -250)
    Main.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
    Main.BorderSizePixel = 0
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 15)
    UICorner.Parent = Main
    
    local UIStroke = Instance.new("UIStroke")
    UIStroke.Color = Color3.fromRGB(150, 100, 255)
    UIStroke.Thickness = 3
    UIStroke.Parent = Main
    
    -- Header
    local Header = Instance.new("TextLabel", Main)
    Header.Size = UDim2.new(1, -20, 0, 70)
    Header.Position = UDim2.new(0, 10, 0, 10)
    Header.BackgroundTransparency = 1
    Header.Text = [[
👑 RXT SERVER V10
━━━━━━━━━━━━━━━━
⚡ GHOST FARM FIX
⚒️ 3zf & RXT
🔐 Key: RXT24
    ]]
    Header.TextColor3 = Color3.fromRGB(170, 120, 255)
    Header.Font = Enum.Font.GothamBold
    Header.TextSize = 14
    Header.TextYAlignment = Enum.TextYAlignment.Top
    
    -- Close Button
    local CloseBtn = Instance.new("TextButton", Main)
    CloseBtn.Size = UDim2.new(0, 35, 0, 35)
    CloseBtn.Position = UDim2.new(1, -45, 0, 15)
    CloseBtn.Text = "✕"
    CloseBtn.BackgroundColor3 = Color3.fromRGB(220, 70, 70)
    CloseBtn.TextColor3 = Color3.new(1, 1, 1)
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.TextSize = 20
    Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(1, 0)
    
    -- Floating Open Button
    local OpenBtn = Instance.new("TextButton", ScreenGui)
    OpenBtn.Size = UDim2.new(0, 60, 0, 60)
    OpenBtn.Position = UDim2.new(0, 20, 0.5, -30)
    OpenBtn.BackgroundColor3 = Color3.fromRGB(40, 30, 70)
    OpenBtn.Text = "RXT\nV10"
    OpenBtn.TextColor3 = Color3.fromRGB(170, 120, 255)
    OpenBtn.Font = Enum.Font.GothamBold
    OpenBtn.TextSize = 16
    OpenBtn.Visible = false
    Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(1, 0)
    
    local OpenStroke = Instance.new("UIStroke", OpenBtn)
    OpenStroke.Color = Color3.fromRGB(150, 100, 255)
    OpenStroke.Thickness = 2
    
    CloseBtn.MouseButton1Click:Connect(function()
        Main.Visible = false
        OpenBtn.Visible = true
    end)
    
    OpenBtn.MouseButton1Click:Connect(function()
        Main.Visible = true
        OpenBtn.Visible = false
    end)
    
    -- Simple Dragging System
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
    
    -- Discord reminder
    task.spawn(function()
        while true do
            task.wait(120)
            local Alert = Instance.new("TextLabel", ScreenGui)
            Alert.Size = UDim2.new(0, 300, 0, 40)
            Alert.Position = UDim2.new(0.5, -150, 1, -50)
            Alert.BackgroundColor3 = Color3.fromRGB(70, 40, 140)
            Alert.TextColor3 = Color3.new(1, 1, 1)
            Alert.Text = "📢 Enjoy RXT Script V10!"
            Alert.Font = Enum.Font.GothamBold
            Alert.TextSize = 13
            Instance.new("UICorner", Alert)
            task.wait(5)
            Alert:Destroy()
        end
    end)
    
    -- Tabs (Removed CONTACT tab)
    local TabHolder = Instance.new("Frame", Main)
    TabHolder.Size = UDim2.new(1, -20, 0, 40)
    TabHolder.Position = UDim2.new(0, 10, 0, 90)
    TabHolder.BackgroundTransparency = 1
    
    local TabList = Instance.new("UIListLayout", TabHolder)
    TabList.FillDirection = Enum.FillDirection.Horizontal
    TabList.HorizontalAlignment = Enum.HorizontalAlignment.Center
    TabList.Padding = UDim.new(0, 8)
    
    local Pages = Instance.new("Frame", Main)
    Pages.Size = UDim2.new(1, -20, 1, -150)
    Pages.Position = UDim2.new(0, 10, 0, 140)
    Pages.BackgroundTransparency = 1
    
    local function CreatePage()
        local p = Instance.new("ScrollingFrame", Pages)
        p.Size = UDim2.new(1, 0, 1, 0)
        p.BackgroundTransparency = 1
        p.Visible = false
        p.ScrollBarThickness = 0
        Instance.new("UIListLayout", p).Padding = UDim.new(0, 10)
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
        b.Size = UDim2.new(0, 70, 1, 0)
        b.Text = icon .. " " .. t
        b.TextColor3 = Color3.new(1, 1, 1)
        b.BackgroundTransparency = 1
        b.Font = Enum.Font.GothamBold
        b.TextSize = 11
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
    
    -- Toggle System
    local function AddToggle(parent, txt, current, cb)
        local b = Instance.new("TextButton", parent)
        b.Size = UDim2.new(1, 0, 0, 40)
        b.Text = txt .. " : OFF"
        b.BackgroundColor3 = Color3.fromRGB(35, 30, 60)
        b.TextColor3 = Color3.new(1, 1, 1)
        b.Font = Enum.Font.GothamBold
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
    
    -- [ Main Buttons ]
    AddToggle(P1, "🚫 No Ragdoll", noRagdollEnabled, function(s)
        noRagdollEnabled = s
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
    
    AddToggle(P1, "🦘 Infinite Jump", infJumpEnabled, function(s)
        infJumpEnabled = s
    end)
    
    local SpdInput = Instance.new("TextBox", P1)
    SpdInput.Size = UDim2.new(1, 0, 0, 35)
    SpdInput.PlaceholderText = "Speed (16-100)"
    SpdInput.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    SpdInput.TextColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", SpdInput)
    SpdInput.Text = "50"
    
    AddToggle(P1, "🚀 Stealth Speed", stealthSpeedEnabled, function(s)
        stealthSpeedEnabled = s
        speedValue = tonumber(SpdInput.Text) or 50
    end)
    
    AddToggle(P2, "☢️ Radioactive Farm", radioactiveFarmEnabled, function(s)
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
    
    AddToggle(P3, "⚡ FPS BOOST", false, function(s)
        if s then
            for _, v in pairs(game:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.Material = "SmoothPlastic"
                end
            end
        end
    end)
    
    AddToggle(P3, "👁️ Unlock Zoom", false, function(s)
        if s then
            player.CameraMaxZoomDistance = 100000
        end
    end)
    
    AddToggle(P3, "💡 Full Bright", false, function(s)
        if s then
            Lighting.Brightness = 2
            Lighting.ClockTime = 14
        end
    end)
    
    local bSave = Instance.new("TextButton", P4)
    bSave.Size = UDim2.new(1, 0, 0, 40)
    bSave.Text = "📍 Save Position"
    bSave.BackgroundColor3 = Color3.fromRGB(35, 30, 60)
    bSave.TextColor3 = Color3.new(1, 1, 1)
    bSave.Font = Enum.Font.GothamBold
    Instance.new("UICorner", bSave)
    
    bSave.MouseButton1Click:Connect(function()
        if player.Character then
            savedPosition = player.Character.HumanoidRootPart.CFrame
            bSave.Text = "✅ Position Saved!"
            task.wait(1)
            bSave.Text = "📍 Save Position"
        end
    end)
    
    local bTP = Instance.new("TextButton", P4)
    bTP.Size = UDim2.new(1, 0, 0, 40)
    bTP.Text = "🌀 Ghost Smooth TP"
    bTP.BackgroundColor3 = Color3.fromRGB(35, 30, 60)
    bTP.TextColor3 = Color3.new(1, 1, 1)
    bTP.Font = Enum.Font.GothamBold
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
    
    -- [[ ⚒️ Developer Tab ]] --
    local DevLabel = Instance.new("TextLabel", P5)
    DevLabel.Size = UDim2.new(1, 0, 0, 150)
    DevLabel.BackgroundTransparency = 1
    DevLabel.Text = [[
⚒️ Developer Tools
━━━━━━━━━━━━━━
Developers:
• 3zf
• RXT

Version: V10
Key System: 24 Hours
Safe Ghost Farm
Simple & Clean
    ]]
    DevLabel.TextColor3 = Color3.fromRGB(150, 100, 255)
    DevLabel.Font = Enum.Font.GothamBold
    DevLabel.TextSize = 14
    DevLabel.TextYAlignment = Enum.TextYAlignment.Top
    
    local ReloadBtn = Instance.new("TextButton", P5)
    ReloadBtn.Size = UDim2.new(1, 0, 0, 40)
    ReloadBtn.Position = UDim2.new(0, 0, 0, 160)
    ReloadBtn.Text = "🔄 Reload Script"
    ReloadBtn.BackgroundColor3 = Color3.fromRGB(35, 30, 60)
    ReloadBtn.TextColor3 = Color3.new(1, 1, 1)
    ReloadBtn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", ReloadBtn)
    
    ReloadBtn.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
        task.wait(0.5)
        CreateKeyGui()
    end)
    
    -- Footer
    local Footer = Instance.new("TextLabel", Main)
    Footer.Size = UDim2.new(1, 0, 0, 30)
    Footer.Position = UDim2.new(0, 0, 1, -30)
    Footer.BackgroundTransparency = 1
    Footer.Text = "RXT SERVER V10 | 24H KEY SYSTEM | CLEAN VERSION"
    Footer.TextColor3 = Color3.fromRGB(150, 100, 255)
    Footer.Font = Enum.Font.GothamBold
    Footer.TextSize = 11
    
    print("👑 RXT MASTER V10 LOADED - CLEAN VERSION")
end

-- Start with Key GUI
CreateKeyGui()
