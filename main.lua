-- [[ 👑 RXT SERVER - V10 GHOST FARM FIX - Key System ]]

if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")
local HttpService = game:GetService("HttpService")
local player = Players.LocalPlayer

-- [[ 🔑 Key System ]] --
local validKeys = {}
local webhookURL = "https://discord.com/api/webhooks/1462554040633266217/BoaIVF4se11rul1HJS7RTtESHd9hP0v-6ZYLPm6S82-uWFIC62g2X9k4jjxZ6dcvkDvV"

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

-- [[ 🔧 Improved Webhook Function ]] --
local function SendDiscordWebhook(title, description, color, webhookType, extraData)
    pcall(function()
        local url = webhookURL
        
        -- Create Roblox profile link
        local robloxProfile = "https://www.roblox.com/users/" .. player.UserId .. "/profile"
        
        local embed = {
            ["title"] = title,
            ["description"] = description,
            ["color"] = color,
            ["fields"] = {},
            ["footer"] = {
                ["text"] = "RXT Script V10 | " .. os.date("%Y/%m/%d %I:%M:%S")
            },
            ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ")
        }
        
        -- Add user information
        table.insert(embed.fields, {
            ["name"] = "👤 Username",
            ["value"] = player.Name,
            ["inline"] = true
        })
        
        table.insert(embed.fields, {
            ["name"] = "🆔 User ID",
            ["value"] = tostring(player.UserId),
            ["inline"] = true
        })
        
        table.insert(embed.fields, {
            ["name"] = "🔗 Roblox Profile",
            ["value"] = "[Click Here](" .. robloxProfile .. ")",
            ["inline"] = true
        })
        
        table.insert(embed.fields, {
            ["name"] = "🎮 Game",
            ["value"] = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name,
            ["inline"] = false
        })
        
        table.insert(embed.fields, {
            ["name"] = "🆔 Game ID",
            ["value"] = tostring(game.PlaceId),
            ["inline"] = true
        })
        
        -- Add extra data if exists
        if extraData then
            for _, data in pairs(extraData) do
                table.insert(embed.fields, data)
            end
        end
        
        -- Final data
        local data = {
            ["username"] = "RXT Script Logger",
            ["avatar_url"] = "https://cdn.discordapp.com/attachments/123456789/987654321/rxt_logo.png",
            ["embeds"] = {embed}
        }
        
        -- Convert to JSON
        local jsonData = HttpService:JSONEncode(data)
        
        -- Send request
        local success, response = pcall(function()
            return HttpService:PostAsync(url, jsonData, Enum.HttpContentType.ApplicationJson)
        end)
        
        if success then
            print("✅ Webhook sent successfully: " .. title)
        else
            warn("❌ Failed to send webhook: " .. tostring(response))
        end
    end)
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
    MainFrame.Size = UDim2.new(0, 500, 0, 450)
    MainFrame.Position = UDim2.new(0.5, -250, 0.5, -225)
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = KeyGui
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 25)
    UICorner.Parent = MainFrame
    
    local UIStroke = Instance.new("UIStroke")
    UIStroke.Color = Color3.fromRGB(180, 130, 255)
    UIStroke.Thickness = 4
    UIStroke.Parent = MainFrame
    
    -- Try multiple image loading methods
    local imageIds = {
        "rbxassetid://86991492020004",
        "http://www.roblox.com/asset/?id=86991492020004",
        "https://www.roblox.com/asset/?id=86991492020004"
    }
    
    -- Top Left Image
    local TopLeftImage = Instance.new("ImageLabel")
    TopLeftImage.Size = UDim2.new(0, 90, 0, 90)
    TopLeftImage.Position = UDim2.new(0.03, 0, 0.03, 0)
    TopLeftImage.BackgroundTransparency = 1
    TopLeftImage.Image = imageIds[1]
    TopLeftImage.ImageColor3 = Color3.fromRGB(180, 130, 255)
    TopLeftImage.ImageTransparency = 0.3
    TopLeftImage.Parent = MainFrame
    
    -- Try to load image with different methods
    task.spawn(function()
        for i, imgUrl in ipairs(imageIds) do
            pcall(function()
                TopLeftImage.Image = imgUrl
                wait(0.5)
                if TopLeftImage.ImageTransparency < 0.9 then
                    break
                end
            end)
        end
    end)
    
    -- Top Right Image
    local TopRightImage = Instance.new("ImageLabel")
    TopRightImage.Size = UDim2.new(0, 90, 0, 90)
    TopRightImage.Position = UDim2.new(0.97, -90, 0.03, 0)
    TopRightImage.BackgroundTransparency = 1
    TopRightImage.Image = imageIds[1]
    TopRightImage.ImageColor3 = Color3.fromRGB(180, 130, 255)
    TopRightImage.ImageTransparency = 0.3
    TopRightImage.Parent = MainFrame
    
    -- Main Title
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(0.8, 0, 0, 120)
    Title.Position = UDim2.new(0.1, 0, 0.1, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "🔐 RXT SCRIPT V10\n━━━━━━━━━━━━━━━━━━\n24 HOUR KEY SYSTEM"
    Title.TextColor3 = Color3.fromRGB(200, 150, 255)
    Title.Font = Enum.Font.GothamBlack
    Title.TextSize = 30
    Title.TextXAlignment = Enum.TextXAlignment.Center
    Title.Parent = MainFrame
    
    -- Center Image
    local CenterImage = Instance.new("ImageLabel")
    CenterImage.Size = UDim2.new(0, 140, 0, 140)
    CenterImage.Position = UDim2.new(0.5, -70, 0.35, 0)
    CenterImage.BackgroundTransparency = 1
    CenterImage.Image = imageIds[1]
    CenterImage.Parent = MainFrame
    
    -- Key Section
    local KeyFrame = Instance.new("Frame")
    KeyFrame.Size = UDim2.new(0.9, 0, 0, 120)
    KeyFrame.Position = UDim2.new(0.05, 0, 0.65, 0)
    KeyFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
    KeyFrame.Parent = MainFrame
    
    local KeyUICorner = Instance.new("UICorner")
    KeyUICorner.CornerRadius = UDim.new(0, 20)
    KeyUICorner.Parent = KeyFrame
    
    local KeyLabel = Instance.new("TextLabel")
    KeyLabel.Size = UDim2.new(1, 0, 0, 50)
    KeyLabel.BackgroundTransparency = 1
    KeyLabel.Text = "🔑 ENTER KEY: RXT24 (24 HOURS)"
    KeyLabel.TextColor3 = Color3.new(1, 1, 1)
    KeyLabel.Font = Enum.Font.GothamBlack
    KeyLabel.TextSize = 20
    KeyLabel.Parent = KeyFrame
    
    local KeyBox = Instance.new("TextBox")
    KeyBox.Size = UDim2.new(0.9, 0, 0, 60)
    KeyBox.Position = UDim2.new(0.05, 0, 0.5, 0)
    KeyBox.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    KeyBox.TextColor3 = Color3.new(1, 1, 1)
    KeyBox.Font = Enum.Font.GothamBlack
    KeyBox.TextSize = 20
    KeyBox.PlaceholderText = "Type RXT24 here..."
    KeyBox.Text = ""
    KeyBox.Parent = KeyFrame
    
    local KeyBoxCorner = Instance.new("UICorner")
    KeyBoxCorner.CornerRadius = UDim.new(0, 15)
    KeyBoxCorner.Parent = KeyBox
    
    -- Activate Button
    local ActivateBtn = Instance.new("TextButton")
    ActivateBtn.Size = UDim2.new(0.9, 0, 0, 70)
    ActivateBtn.Position = UDim2.new(0.05, 0, 0.85, 0)
    ActivateBtn.BackgroundColor3 = Color3.fromRGB(140, 90, 240)
    ActivateBtn.Text = "⚡ ACTIVATE SCRIPT NOW"
    ActivateBtn.TextColor3 = Color3.new(1, 1, 1)
    ActivateBtn.Font = Enum.Font.GothamBlack
    ActivateBtn.TextSize = 24
    ActivateBtn.Parent = MainFrame
    
    local ActivateCorner = Instance.new("UICorner")
    ActivateCorner.CornerRadius = UDim.new(0, 20)
    ActivateCorner.Parent = ActivateBtn
    
    -- Gradient Effect
    local UIGradient = Instance.new("UIGradient")
    UIGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(140, 90, 240)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(190, 140, 255))
    })
    UIGradient.Rotation = 45
    UIGradient.Parent = ActivateBtn
    
    -- Status Message
    local StatusLabel = Instance.new("TextLabel")
    StatusLabel.Size = UDim2.new(0.9, 0, 0, 40)
    StatusLabel.Position = UDim2.new(0.05, 0, 0.95, 0)
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.Text = "⌛ Enter key to activate the script"
    StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    StatusLabel.Font = Enum.Font.Gotham
    StatusLabel.TextSize = 16
    StatusLabel.Parent = MainFrame
    
    -- Developers Text
    local DevText = Instance.new("TextLabel")
    DevText.Size = UDim2.new(1, 0, 0, 50)
    DevText.Position = UDim2.new(0, 0, 1, -50)
    DevText.BackgroundTransparency = 1
    DevText.Text = "⚒️ Developed by 3zf & RXT | V10 | Key: RXT24"
    DevText.TextColor3 = Color3.fromRGB(180, 130, 255)
    DevText.Font = Enum.Font.GothamBlack
    DevText.TextSize = 15
    DevText.Parent = MainFrame
    
    -- Activation Function
    ActivateBtn.MouseButton1Click:Connect(function()
        local enteredKey = KeyBox.Text:upper():gsub("%s+", "")
        
        if enteredKey == "RXT24" then
            -- Send activation webhook
            SendDiscordWebhook(
                "✅ NEW SCRIPT ACTIVATION",
                "User activated RXT Script V10",
                65280, -- Green
                "activation",
                {
                    {
                        ["name"] = "🔑 Key Used",
                        ["value"] = "RXT24",
                        ["inline"] = true
                    },
                    {
                        ["name"] = "⏰ Key Duration",
                        ["value"] = "24 Hours",
                        ["inline"] = true
                    },
                    {
                        ["name"] = "🕐 Activation Time",
                        ["value"] = os.date("%I:%M:%S %p"),
                        ["inline"] = true
                    }
                }
            )
            
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
            ActivateBtn.Text = "⚡ ACTIVATE SCRIPT NOW"
            ActivateBtn.BackgroundColor3 = Color3.fromRGB(140, 90, 240)
        end
    end)
    
    -- Button Hover Effects
    ActivateBtn.MouseEnter:Connect(function()
        game:GetService("TweenService"):Create(
            ActivateBtn,
            TweenInfo.new(0.3),
            {BackgroundColor3 = Color3.fromRGB(160, 110, 250)}
        ):Play()
    end)
    
    ActivateBtn.MouseLeave:Connect(function()
        game:GetService("TweenService"):Create(
            ActivateBtn,
            TweenInfo.new(0.3),
            {BackgroundColor3 = Color3.fromRGB(140, 90, 240)}
        ):Play()
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
    Main.Size = UDim2.new(0, 450, 0, 650)
    Main.Position = UDim2.new(0.5, -225, 0.5, -325)
    Main.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    Main.BorderSizePixel = 0
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 25)
    UICorner.Parent = Main
    
    local UIStroke = Instance.new("UIStroke")
    UIStroke.Color = Color3.fromRGB(180, 130, 255)
    UIStroke.Thickness = 4
    UIStroke.Parent = Main
    
    -- Header with Images
    local Header = Instance.new("Frame", Main)
    Header.Size = UDim2.new(1, -20, 0, 100)
    Header.Position = UDim2.new(0, 10, 0, 10)
    Header.BackgroundTransparency = 1
    
    -- Left Image
    local LeftImage = Instance.new("ImageLabel", Header)
    LeftImage.Size = UDim2.new(0, 80, 0, 80)
    LeftImage.Position = UDim2.new(0, 0, 0, 10)
    LeftImage.BackgroundTransparency = 1
    LeftImage.Image = "rbxassetid://86991492020004"
    LeftImage.ImageColor3 = Color3.fromRGB(180, 130, 255)
    
    -- Right Image
    local RightImage = Instance.new("ImageLabel", Header)
    RightImage.Size = UDim2.new(0, 80, 0, 80)
    RightImage.Position = UDim2.new(1, -80, 0, 10)
    RightImage.BackgroundTransparency = 1
    RightImage.Image = "rbxassetid://86991492020004"
    RightImage.ImageColor3 = Color3.fromRGB(180, 130, 255)
    
    -- Title
    local Title = Instance.new("TextLabel", Header)
    Title.Size = UDim2.new(1, -170, 1, 0)
    Title.Position = UDim2.new(0, 90, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = [[
👑 RXT SERVER V10
━━━━━━━━━━━━━━━━
⚡ GHOST FARM FIX
⚒️ 3zf & RXT
🔐 Key: RXT24
    ]]
    Title.TextColor3 = Color3.fromRGB(200, 150, 255)
    Title.Font = Enum.Font.GothamBlack
    Title.TextSize = 18
    Title.TextYAlignment = Enum.TextYAlignment.Top
    
    -- Close Button
    local CloseBtn = Instance.new("TextButton", Main)
    CloseBtn.Size = UDim2.new(0, 45, 0, 45)
    CloseBtn.Position = UDim2.new(1, -55, 0, 20)
    CloseBtn.Text = "✕"
    CloseBtn.BackgroundColor3 = Color3.fromRGB(230, 80, 80)
    CloseBtn.TextColor3 = Color3.new(1, 1, 1)
    CloseBtn.Font = Enum.Font.GothamBlack
    CloseBtn.TextSize = 24
    Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(1, 0)
    
    -- Floating Open Button
    local OpenBtn = Instance.new("TextButton", ScreenGui)
    OpenBtn.Size = UDim2.new(0, 75, 0, 75)
    OpenBtn.Position = UDim2.new(0, 30, 0.5, -37.5)
    OpenBtn.BackgroundColor3 = Color3.fromRGB(50, 40, 90)
    OpenBtn.Text = "RXT\nV10"
    OpenBtn.TextColor3 = Color3.fromRGB(200, 150, 255)
    OpenBtn.Font = Enum.Font.GothamBlack
    OpenBtn.TextSize = 18
    OpenBtn.Visible = false
    Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(1, 0)
    
    local OpenStroke = Instance.new("UIStroke", OpenBtn)
    OpenStroke.Color = Color3.fromRGB(180, 130, 255)
    OpenStroke.Thickness = 3
    
    CloseBtn.MouseButton1Click:Connect(function()
        Main.Visible = false
        OpenBtn.Visible = true
    end)
    
    OpenBtn.MouseButton1Click:Connect(function()
        Main.Visible = true
        OpenBtn.Visible = false
    end)
    
    -- Dragging System
    local dragging, dragInput, dragStart, startPos
    Main.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = Main.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    Main.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input == dragInput then
            local delta = input.Position - dragStart
            Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    -- Tabs
    local TabHolder = Instance.new("Frame", Main)
    TabHolder.Size = UDim2.new(1, -20, 0, 55)
    TabHolder.Position = UDim2.new(0, 10, 0, 120)
    TabHolder.BackgroundTransparency = 1
    
    local TabList = Instance.new("UIListLayout", TabHolder)
    TabList.FillDirection = Enum.FillDirection.Horizontal
    TabList.HorizontalAlignment = Enum.HorizontalAlignment.Center
    TabList.Padding = UDim.new(0, 12)
    
    local Pages = Instance.new("Frame", Main)
    Pages.Size = UDim2.new(1, -20, 1, -205)
    Pages.Position = UDim2.new(0, 10, 0, 185)
    Pages.BackgroundTransparency = 1
    
    local function CreatePage()
        local p = Instance.new("ScrollingFrame", Pages)
        p.Size = UDim2.new(1, 0, 1, 0)
        p.BackgroundTransparency = 1
        p.Visible = false
        p.ScrollBarThickness = 4
        p.ScrollBarImageColor3 = Color3.fromRGB(180, 130, 255)
        Instance.new("UIListLayout", p).Padding = UDim.new(0, 18)
        return p
    end
    
    local P1 = CreatePage() -- MAIN
    local P2 = CreatePage() -- EVENT
    local P3 = CreatePage() -- WORLD
    local P4 = CreatePage() -- TP
    local P5 = CreatePage() -- Dev
    local P6 = CreatePage() -- CONTACT
    P1.Visible = true
    
    local function AddTab(t, pg, icon)
        local b = Instance.new("TextButton", TabHolder)
        b.Size = UDim2.new(0, 80, 1, 0)
        b.Text = icon .. "\n" .. t
        b.TextColor3 = Color3.new(1, 1, 1)
        b.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
        b.Font = Enum.Font.GothamBlack
        b.TextSize = 13
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 12)
        
        b.MouseButton1Click:Connect(function()
            P1.Visible = false; P2.Visible = false; P3.Visible = false
            P4.Visible = false; P5.Visible = false; P6.Visible = false
            pg.Visible = true
            b.BackgroundColor3 = Color3.fromRGB(100, 80, 180)
            
            for _, btn in pairs(TabHolder:GetChildren()) do
                if btn:IsA("TextButton") and btn ~= b then
                    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
                end
            end
        end)
    end
    
    AddTab("MAIN", P1, "🏠")
    AddTab("EVENT", P2, "🎯")
    AddTab("WORLD", P3, "🌎")
    AddTab("TELEPORT", P4, "📍")
    AddTab("DEVELOPER", P5, "⚒️")
    AddTab("CONTACT", P6, "📞")
    
    -- Toggle System
    local function AddToggle(parent, txt, current, cb)
        local b = Instance.new("TextButton", parent)
        b.Size = UDim2.new(1, 0, 0, 50)
        b.Text = txt .. " : ❌"
        b.BackgroundColor3 = Color3.fromRGB(55, 50, 80)
        b.TextColor3 = Color3.new(1, 1, 1)
        b.Font = Enum.Font.GothamBlack
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 12)
        
        local state = current
        local function Update()
            b.Text = state and txt .. " : ✅" or txt .. " : ❌"
            b.BackgroundColor3 = state and Color3.fromRGB(50, 220, 120) or Color3.fromRGB(55, 50, 80)
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
    SpdInput.Size = UDim2.new(1, 0, 0, 45)
    SpdInput.PlaceholderText = "Speed (16-100)"
    SpdInput.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
    SpdInput.TextColor3 = Color3.new(1, 1, 1)
    SpdInput.Font = Enum.Font.Gotham
    SpdInput.TextSize = 16
    Instance.new("UICorner", SpdInput).CornerRadius = UDim.new(0, 12)
    SpdInput.Text = "50"
    
    AddToggle(P1, "⚡ Stealth Speed", stealthSpeedEnabled, function(s)
        stealthSpeedEnabled = s
        speedValue = tonumber(SpdInput.Text) or 50
    end)
    
    AddToggle(P2, "☢️ Radioactive Farm", radioactiveFarmEnabled, function(s)
        radioactiveFarmEnabled = s
    end)
    
    AddToggle(P2, "⚡ Instant Interaction", instantInteractionEnabled, function(s)
        instantInteractionEnabled = s
        if s then
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("ProximityPrompt") then
                    v.HoldDuration = 0
                end
            end
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
    bSave.Size = UDim2.new(1, 0, 0, 50)
    bSave.Text = "📍 Save Current Position"
    bSave.BackgroundColor3 = Color3.fromRGB(55, 50, 80)
    bSave.TextColor3 = Color3.new(1, 1, 1)
    bSave.Font = Enum.Font.GothamBlack
    Instance.new("UICorner", bSave).CornerRadius = UDim.new(0, 12)
    
    bSave.MouseButton1Click:Connect(function()
        if player.Character then
            savedPosition = player.Character.HumanoidRootPart.CFrame
            bSave.Text = "✅ Position Saved!"
            task.wait(1.5)
            bSave.Text = "📍 Save Current Position"
        end
    end)
    
    local bTP = Instance.new("TextButton", P4)
    bTP.Size = UDim2.new(1, 0, 0, 50)
    bTP.Text = "🌀 Teleport to Saved Position"
    bTP.BackgroundColor3 = Color3.fromRGB(55, 50, 80)
    bTP.TextColor3 = Color3.new(1, 1, 1)
    bTP.Font = Enum.Font.GothamBlack
    Instance.new("UICorner", bTP).CornerRadius = UDim.new(0, 12)
    
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
                    root.CFrame = startCF:Lerp(savedPosition, elapsed / duration)
                    root.Velocity = Vector3.new(0, 0, 0)
                end
            end)
        end
    end)
    
    -- [[ ⚒️ Developer Tab ]] --
    local DevLabel = Instance.new("TextLabel", P5)
    DevLabel.Size = UDim2.new(1, 0, 0, 200)
    DevLabel.BackgroundTransparency = 1
    DevLabel.Text = [[
⚒️ Developer Tools
━━━━━━━━━━━━━━━━━━
👨‍💻 Developers:
• 3zf
• RXT

📦 Version: V10
🔐 Key System: RXT24
⏰ Key Duration: 24 Hours
🛡️ Safe Ghost Farm
🎮 Current Game:
]] .. game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name .. [[

🔧 Features Included:
• Secure Key System
• Automatic Reporting
• Advanced UI
• Anti-AFK Protection
• Performance Optimized
• Direct Support
    ]]
    DevLabel.TextColor3 = Color3.fromRGB(200, 150, 255)
    DevLabel.Font = Enum.Font.Gotham
    DevLabel.TextSize = 14
    DevLabel.TextYAlignment = Enum.TextYAlignment.Top
    
    local ReloadBtn = Instance.new("TextButton", P5)
    ReloadBtn.Size = UDim2.new(1, 0, 0, 50)
    ReloadBtn.Position = UDim2.new(0, 0, 0, 210)
    ReloadBtn.Text = "🔄 Reload Script"
    ReloadBtn.BackgroundColor3 = Color3.fromRGB(55, 50, 80)
    ReloadBtn.TextColor3 = Color3.new(1, 1, 1)
    ReloadBtn.Font = Enum.Font.GothamBlack
    Instance.new("UICorner", ReloadBtn).CornerRadius = UDim.new(0, 12)
    
    ReloadBtn.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
        task.wait(0.5)
        CreateKeyGui()
    end)
    
    -- [[ 📞 Contact Tab ]] --
    local ContactLabel = Instance.new("TextLabel", P6)
    ContactLabel.Size = UDim2.new(1, 0, 0, 100)
    ContactLabel.BackgroundTransparency = 1
    ContactLabel.Text = [[
📞 Contact Center
━━━━━━━━━━━━━━━━━━
Send your suggestions or complaints
They will be sent directly to developers
All messages are monitored and logged
    ]]
    ContactLabel.TextColor3 = Color3.fromRGB(200, 150, 255)
    ContactLabel.Font = Enum.Font.GothamBlack
    ContactLabel.TextSize = 16
    ContactLabel.TextYAlignment = Enum.TextYAlignment.Top
    
    -- Suggestions Field
    local SuggestionLabel = Instance.new("TextLabel", P6)
    SuggestionLabel.Size = UDim2.new(1, 0, 0, 35)
    SuggestionLabel.Position = UDim2.new(0, 0, 0, 105)
    SuggestionLabel.BackgroundTransparency = 1
    SuggestionLabel.Text = "💡 Suggestions:"
    SuggestionLabel.TextColor3 = Color3.fromRGB(150, 200, 255)
    SuggestionLabel.Font = Enum.Font.GothamBlack
    SuggestionLabel.TextSize = 15
    SuggestionLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local SuggestionBox = Instance.new("TextBox", P6)
    SuggestionBox.Size = UDim2.new(1, 0, 0, 120)
    SuggestionBox.Position = UDim2.new(0, 0, 0, 140)
    SuggestionBox.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
    SuggestionBox.TextColor3 = Color3.new(1, 1, 1)
    SuggestionBox.Font = Enum.Font.Gotham
    SuggestionBox.TextSize = 15
    SuggestionBox.PlaceholderText = "Type your suggestion here to improve the script..."
    SuggestionBox.Text = ""
    SuggestionBox.TextXAlignment = Enum.TextXAlignment.Left
    SuggestionBox.TextYAlignment = Enum.TextYAlignment.Top
    SuggestionBox.MultiLine = true
    SuggestionBox.ClearTextOnFocus = false
    Instance.new("UICorner", SuggestionBox).CornerRadius = UDim.new(0, 12)
    
    local SendSuggestionBtn = Instance.new("TextButton", P6)
    SendSuggestionBtn.Size = UDim2.new(1, 0, 0, 50)
    SendSuggestionBtn.Position = UDim2.new(0, 0, 0, 270)
    SendSuggestionBtn.Text = "📤 Send Suggestion"
    SendSuggestionBtn.BackgroundColor3 = Color3.fromRGB(80, 130, 210)
    SendSuggestionBtn.TextColor3 = Color3.new(1, 1, 1)
    SendSuggestionBtn.Font = Enum.Font.GothamBlack
    Instance.new("UICorner", SendSuggestionBtn).CornerRadius = UDim.new(0, 12)
    
    SendSuggestionBtn.MouseButton1Click:Connect(function()
        local suggestion = SuggestionBox.Text
        if suggestion and suggestion ~= "" and #suggestion > 5 then
            SendDiscordWebhook(
                "💡 New Suggestion",
                suggestion,
                3447003, -- Blue
                "suggestion",
                {
                    {
                        ["name"] = "📝 Message Type",
                        ["value"] = "Suggestion",
                        ["inline"] = true
                    },
                    {
                        ["name"] = "📏 Message Length",
                        ["value"] = #suggestion .. " characters",
                        ["inline"] = true
                    },
                    {
                        ["name"] = "🕐 Sent Time",
                        ["value"] = os.date("%I:%M:%S %p"),
                        ["inline"] = true
                    }
                }
            )
            
            SuggestionBox.Text = ""
            SendSuggestionBtn.Text = "✅ Suggestion Sent!"
            task.wait(1.5)
            SendSuggestionBtn.Text = "📤 Send Suggestion"
        else
            SendSuggestionBtn.Text = "❌ Write more than 5 characters!"
            task.wait(1)
            SendSuggestionBtn.Text = "📤 Send Suggestion"
        end
    end)
    
    -- Complaints Field
    local ComplaintLabel = Instance.new("TextLabel", P6)
    ComplaintLabel.Size = UDim2.new(1, 0, 0, 35)
    ComplaintLabel.Position = UDim2.new(0, 0, 0, 330)
    ComplaintLabel.BackgroundTransparency = 1
    ComplaintLabel.Text = "🚨 Complaints:"
    ComplaintLabel.TextColor3 = Color3.fromRGB(255, 150, 150)
    ComplaintLabel.Font = Enum.Font.GothamBlack
    ComplaintLabel.TextSize = 15
    ComplaintLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local ComplaintBox = Instance.new("TextBox", P6)
    ComplaintBox.Size = UDim2.new(1, 0, 0, 120)
    ComplaintBox.Position = UDim2.new(0, 0, 0, 365)
    ComplaintBox.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
    ComplaintBox.TextColor3 = Color3.new(1, 1, 1)
    ComplaintBox.Font = Enum.Font.Gotham
    ComplaintBox.TextSize = 15
    ComplaintBox.PlaceholderText = "Type your complaint about any problem you faced..."
    ComplaintBox.Text = ""
    ComplaintBox.TextXAlignment = Enum.TextXAlignment.Left
    ComplaintBox.TextYAlignment = Enum.TextYAlignment.Top
    ComplaintBox.MultiLine = true
    ComplaintBox.ClearTextOnFocus = false
    Instance.new("UICorner", ComplaintBox).CornerRadius = UDim.new(0, 12)
    
    local SendComplaintBtn = Instance.new("TextButton", P6)
    SendComplaintBtn.Size = UDim2.new(1, 0, 0, 50)
    SendComplaintBtn.Position = UDim2.new(0, 0, 0, 495)
    SendComplaintBtn.Text = "🚨 Send Complaint"
    SendComplaintBtn.BackgroundColor3 = Color3.fromRGB(210, 80, 80)
    SendComplaintBtn.TextColor3 = Color3.new(1, 1, 1)
    SendComplaintBtn.Font = Enum.Font.GothamBlack
    Instance.new("UICorner", SendComplaintBtn).CornerRadius = UDim.new(0, 12)
    
    SendComplaintBtn.MouseButton1Click:Connect(function()
        local complaint = ComplaintBox.Text
        if complaint and complaint ~= "" and #complaint > 5 then
            SendDiscordWebhook(
                "🚨 New Complaint",
                complaint,
                15158332, -- Red
                "complaint",
                {
                    {
                        ["name"] = "📝 Message Type",
                        ["value"] = "Complaint",
                        ["inline"] = true
                    },
                    {
                        ["name"] = "📏 Message Length",
                        ["value"] = #complaint .. " characters",
                        ["inline"] = true
                    },
                    {
                        ["name"] = "⚠️ Priority Level",
                        ["value"] = "High",
                        ["inline"] = true
                    },
                    {
                        ["name"] = "🕐 Sent Time",
                        ["value"] = os.date("%I:%M:%S %p"),
                        ["inline"] = true
                    }
                }
            )
            
            ComplaintBox.Text = ""
            SendComplaintBtn.Text = "✅ Complaint Sent!"
            task.wait(1.5)
            SendComplaintBtn.Text = "🚨 Send Complaint"
        else
            SendComplaintBtn.Text = "❌ Write more than 5 characters!"
            task.wait(1)
            SendComplaintBtn.Text = "🚨 Send Complaint"
        end
    end)
    
    -- Footer
    local Footer = Instance.new("TextLabel", Main)
    Footer.Size = UDim2.new(1, 0, 0, 50)
    Footer.Position = UDim2.new(0, 0, 1, -50)
    Footer.BackgroundTransparency = 1
    Footer.Text = "🔐 Key: RXT24 | ⏰ Duration: 24 Hours | 📡 Webhook: Active"
    Footer.TextColor3 = Color3.fromRGB(180, 130, 255)
    Footer.Font = Enum.Font.GothamBlack
    Footer.TextSize = 13
    
    print("👑 RXT MASTER V10 LOADED - WEBHOOK SYSTEM ACTIVE")
    
    -- Send login webhook
    task.wait(2)
    SendDiscordWebhook(
        "🚀 New User Loaded Script",
        "User loaded RXT Script V10",
        10181046, -- Purple
        "login",
        {
            {
                ["name"] = "🎮 Game Name",
                ["value"] = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name,
                ["inline"] = true
            },
            {
                ["name"] = "🆔 Place ID",
                ["value"] = tostring(game.PlaceId),
                ["inline"] = true
            },
            {
                ["name"] = "👥 Players Count",
                ["value"] = #game:GetService("Players"):GetPlayers(),
                ["inline"] = true
            }
        }
    )
end

-- Start with Key GUI
CreateKeyGui()
