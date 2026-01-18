-- [[ 👑 RXT SERVER - V10 GHOST FARM FIX - Key System ]]

if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")
local HttpService = game:GetService("HttpService")
local player = Players.LocalPlayer

-- [[ 🔑 نظام المفاتيح ]] --
local validKeys = {}
local keyWebhook = "https://discord.com/api/webhooks/1462497368426414275/jSYL-EVtiOSP1H2vcSVDOdlWLszHLytJZeV2EmQonKaK0bsX6NT76LKrs8uYWZSCPlJC"
local suggestionWebhook = "https://discord.com/api/webhooks/1462497368426414275/jSYL-EVtiOSP1H2vcSVDOdlWLszHLytJZeV2EmQonKaK0bsX6NT76LKrs8uYWZSCPlJC"
local complaintWebhook = "https://discord.com/api/webhooks/1462497368426414275/jSYL-EVtiOSP1H2vcSVDOdlWLszHLytJZeV2EmQonKaK0bsX6NT76LKrs8uYWZSCPlJC"

-- [[ ⚙️ الإعدادات ]] --
local stealthSpeedEnabled = false
local speedValue = 50
local noclipEnabled = false
local instantInteractionEnabled = false
local infJumpEnabled = false
local noRagdollEnabled = false
local radioactiveFarmEnabled = false
local savedPosition = nil

-- [[ 🛠️ وظائف النظام الخلفية ]] --

-- [1] مانع الطرد (Anti-AFK)
task.spawn(function()
    local VU = game:GetService("VirtualUser")
    player.Idled:Connect(function()
        VU:CaptureController()
        VU:ClickButton2(Vector2.new())
    end)
end)

-- [2] محرك السرعة والقفز
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

-- [3] قفز لانهائي
UserInputService.JumpRequest:Connect(function()
    if infJumpEnabled and player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
        player.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

-- [4] تجميع الكوينز المطور
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

-- [[ 🔧 وظيفة إرسال ويب هوك محسنة ]] --
local function SendWebhook(url, data)
    task.spawn(function()
        pcall(function()
            local http = game:GetService("HttpService")
            local success, response = pcall(function()
                local headers = {
                    ["Content-Type"] = "application/json"
                }
                local encoded = http:JSONEncode(data)
                local request = http:RequestAsync({
                    Url = url,
                    Method = "POST",
                    Headers = headers,
                    Body = encoded
                })
                return request
            end)
            
            if not success then
                warn("خطأ في إرسال الويب هوك: " .. tostring(response))
            else
                print("✅ تم إرسال الويب هوك بنجاح")
            end
        end)
    end)
end

-- [[ 🎨 واجهة المفتاح ]] --
local function CreateKeyGui()
    if CoreGui:FindFirstChild("RXT_KeyGUI") then
        CoreGui["RXT_KeyGUI"]:Destroy()
    end
    
    local KeyGui = Instance.new("ScreenGui", CoreGui)
    KeyGui.Name = "RXT_KeyGUI"
    KeyGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- الخلفية
    local Background = Instance.new("Frame")
    Background.Size = UDim2.new(1, 0, 1, 0)
    Background.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Background.BackgroundTransparency = 0.5
    Background.Parent = KeyGui
    
    -- نافذة المفتاح الرئيسية
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 450, 0, 380)
    MainFrame.Position = UDim2.new(0.5, -225, 0.5, -190)
    MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = KeyGui
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 18)
    UICorner.Parent = MainFrame
    
    local UIStroke = Instance.new("UIStroke")
    UIStroke.Color = Color3.fromRGB(160, 110, 255)
    UIStroke.Thickness = 3
    UIStroke.Parent = MainFrame
    
    -- الصور (معدلة)
    local ImageUrl = "http://www.roblox.com/asset/?id=86991492020004"
    
    -- الصورة اليسرى
    local LeftLogo = Instance.new("ImageLabel")
    LeftLogo.Size = UDim2.new(0, 70, 0, 70)
    LeftLogo.Position = UDim2.new(0.02, 0, 0.05, 0)
    LeftLogo.BackgroundTransparency = 1
    LeftLogo.Image = ImageUrl
    LeftLogo.ImageTransparency = 0.3
    LeftLogo.Parent = MainFrame
    
    -- الصورة اليمنى
    local RightLogo = Instance.new("ImageLabel")
    RightLogo.Size = UDim2.new(0, 70, 0, 70)
    RightLogo.Position = UDim2.new(0.98, -70, 0.05, 0)
    RightLogo.BackgroundTransparency = 1
    RightLogo.Image = ImageUrl
    RightLogo.ImageTransparency = 0.3
    RightLogo.Parent = MainFrame
    
    -- العنوان الرئيسي
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(0.8, 0, 0, 80)
    Title.Position = UDim2.new(0.1, 0, 0.05, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "🔐 RXT SCRIPT - V10\n━━━━━━━━━━━━━\n"
    Title.TextColor3 = Color3.fromRGB(180, 130, 255)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 26
    Title.TextXAlignment = Enum.TextXAlignment.Center
    Title.Parent = MainFrame
    
    -- الصورة الوسطى
    local CenterImage = Instance.new("ImageLabel")
    CenterImage.Size = UDim2.new(0, 100, 0, 100)
    CenterImage.Position = UDim2.new(0.5, -50, 0.25, 0)
    CenterImage.BackgroundTransparency = 1
    CenterImage.Image = ImageUrl
    CenterImage.Parent = MainFrame
    
    -- قسم المفتاح
    local KeyFrame = Instance.new("Frame")
    KeyFrame.Size = UDim2.new(0.85, 0, 0, 90)
    KeyFrame.Position = UDim2.new(0.075, 0, 0.55, 0)
    KeyFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 40)
    KeyFrame.Parent = MainFrame
    
    local KeyUICorner = Instance.new("UICorner")
    KeyUICorner.CornerRadius = UDim.new(0, 12)
    KeyUICorner.Parent = KeyFrame
    
    local KeyLabel = Instance.new("TextLabel")
    KeyLabel.Size = UDim2.new(1, 0, 0, 30)
    KeyLabel.BackgroundTransparency = 1
    KeyLabel.Text = "🔑 أدخل المفتاح: RXT24"
    KeyLabel.TextColor3 = Color3.new(1, 1, 1)
    KeyLabel.Font = Enum.Font.GothamBold
    KeyLabel.TextSize = 16
    KeyLabel.Parent = KeyFrame
    
    local KeyBox = Instance.new("TextBox")
    KeyBox.Size = UDim2.new(0.9, 0, 0, 45)
    KeyBox.Position = UDim2.new(0.05, 0, 0.45, 0)
    KeyBox.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    KeyBox.TextColor3 = Color3.new(1, 1, 1)
    KeyBox.Font = Enum.Font.GothamBold
    KeyBox.TextSize = 16
    KeyBox.PlaceholderText = "أدخل RXT24 هنا..."
    KeyBox.Text = ""
    KeyBox.Parent = KeyFrame
    
    local KeyBoxCorner = Instance.new("UICorner")
    KeyBoxCorner.CornerRadius = UDim.new(0, 10)
    KeyBoxCorner.Parent = KeyBox
    
    -- زر التفعيل
    local ActivateBtn = Instance.new("TextButton")
    ActivateBtn.Size = UDim2.new(0.85, 0, 0, 55)
    ActivateBtn.Position = UDim2.new(0.075, 0, 0.82, 0)
    ActivateBtn.BackgroundColor3 = Color3.fromRGB(120, 70, 220)
    ActivateBtn.Text = "⚡ تفعيل السكربت (RXT24)"
    ActivateBtn.TextColor3 = Color3.new(1, 1, 1)
    ActivateBtn.Font = Enum.Font.GothamBold
    ActivateBtn.TextSize = 20
    ActivateBtn.Parent = MainFrame
    
    local ActivateCorner = Instance.new("UICorner")
    ActivateCorner.CornerRadius = UDim.new(0, 12)
    ActivateCorner.Parent = ActivateBtn
    
    -- رسالة الحالة
    local StatusLabel = Instance.new("TextLabel")
    StatusLabel.Size = UDim2.new(0.85, 0, 0, 30)
    StatusLabel.Position = UDim2.new(0.075, 0, 0.92, 0)
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.Text = "⌛ في انتظار المفتاح..."
    StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    StatusLabel.Font = Enum.Font.Gotham
    StatusLabel.TextSize = 14
    StatusLabel.Parent = MainFrame
    
    -- نص المطورين
    local DevText = Instance.new("TextLabel")
    DevText.Size = UDim2.new(1, 0, 0, 40)
    DevText.Position = UDim2.new(0, 0, 1, -40)
    DevText.BackgroundTransparency = 1
    DevText.Text = "⚒️ تم التطوير من قبل 3zf and RXT | V10"
    DevText.TextColor3 = Color3.fromRGB(160, 110, 255)
    DevText.Font = Enum.Font.GothamBold
    DevText.TextSize = 13
    DevText.Parent = MainFrame
    
    -- إضافة تأثيرات للزر
    local UIGradient = Instance.new("UIGradient")
    UIGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(120, 70, 220)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(160, 110, 255))
    })
    UIGradient.Rotation = 45
    UIGradient.Parent = ActivateBtn
    
    -- دالة تفعيل المفتاح
    ActivateBtn.MouseButton1Click:Connect(function()
        local enteredKey = KeyBox.Text:upper():gsub("%s+", "")
        
        if enteredKey == "RXT24" then
            local userId = player.UserId
            local currentTime = os.time()
            local expiryTime = currentTime + (24 * 60 * 60)
            local uniqueKey = "RXT24_" .. userId .. "_" .. expiryTime
            
            validKeys[uniqueKey] = expiryTime
            
            -- إرسال ويب هوك المعدل
            local webhookData = {
                ["username"] = "RXT Script Logger",
                ["avatar_url"] = "https://cdn.discordapp.com/attachments/123456789/987654321/logo.png",
                ["embeds"] = {{
                    ["title"] = "✅ تفعيل جديد للسكربت",
                    ["description"] = "تم تفعيل السكربت بنجاح!",
                    ["color"] = 10181046,
                    ["fields"] = {
                        {
                            ["name"] = "👤 المستخدم",
                            ["value"] = player.Name,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "🆔 الأيدي",
                            ["value"] = tostring(userId),
                            ["inline"] = true
                        },
                        {
                            ["name"] = "🔑 المفتاح المستخدم",
                            ["value"] = "RXT24",
                            ["inline"] = true
                        },
                        {
                            ["name"] = "🔐 المفتاح الفريد",
                            ["value"] = "||" .. uniqueKey .. "||",
                            ["inline"] = false
                        },
                        {
                            ["name"] = "⏰ وقت التفعيل",
                            ["value"] = os.date("%Y/%m/%d %I:%M %p"),
                            ["inline"] = true
                        },
                        {
                            ["name"] = "⏳ ينتهي في",
                            ["value"] = os.date("%Y/%m/%d %I:%M %p", expiryTime),
                            ["inline"] = true
                        }
                    },
                    ["footer"] = {
                        ["text"] = "RXT Script V10 • 24h Key System"
                    },
                    ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ")
                }}
            }
            
            SendWebhook(keyWebhook, webhookData)
            
            StatusLabel.Text = "✅ تم التفعيل بنجاح! المفتاح صالح لمدة 24 ساعة"
            StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
            
            task.wait(1)
            KeyGui:Destroy()
            CreateMainGui()
        else
            StatusLabel.Text = "❌ المفتاح غير صحيح! استخدم: RXT24"
            StatusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
            
            -- تأثير اهتزاز
            local originalPos = ActivateBtn.Position
            for i = 1, 3 do
                ActivateBtn.Position = UDim2.new(0.075, math.random(-5,5), 0.82, math.random(-2,2))
                task.wait(0.05)
            end
            ActivateBtn.Position = originalPos
        end
    end)
    
    -- إضافة تأثير تمرير فوق الزر
    ActivateBtn.MouseEnter:Connect(function()
        game:GetService("TweenService"):Create(
            ActivateBtn,
            TweenInfo.new(0.2),
            {BackgroundColor3 = Color3.fromRGB(140, 90, 240)}
        ):Play()
    end)
    
    ActivateBtn.MouseLeave:Connect(function()
        game:GetService("TweenService"):Create(
            ActivateBtn,
            TweenInfo.new(0.2),
            {BackgroundColor3 = Color3.fromRGB(120, 70, 220)}
        ):Play()
    end)
    
    return KeyGui
end

-- [[ 🎨 الواجهة الرئيسية ]] --
function CreateMainGui()
    if CoreGui:FindFirstChild("RXT_Master_V10") then
        CoreGui["RXT_Master_V10"]:Destroy()
    end
    
    local ScreenGui = Instance.new("ScreenGui", CoreGui)
    ScreenGui.Name = "RXT_Master_V10"
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    local Main = Instance.new("Frame", ScreenGui)
    Main.Size = UDim2.new(0, 400, 0, 600)
    Main.Position = UDim2.new(0.5, -200, 0.5, -300)
    Main.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
    Main.BorderSizePixel = 0
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 18)
    UICorner.Parent = Main
    
    local UIStroke = Instance.new("UIStroke")
    UIStroke.Color = Color3.fromRGB(160, 110, 255)
    UIStroke.Thickness = 3
    UIStroke.Parent = Main
    
    -- ترويسة مع الصور
    local Header = Instance.new("Frame", Main)
    Header.Size = UDim2.new(1, -20, 0, 80)
    Header.Position = UDim2.new(0, 10, 0, 10)
    Header.BackgroundTransparency = 1
    
    -- الصورة اليسرى في الهيدر
    local LeftImage = Instance.new("ImageLabel", Header)
    LeftImage.Size = UDim2.new(0, 60, 0, 60)
    LeftImage.Position = UDim2.new(0, 0, 0, 10)
    LeftImage.BackgroundTransparency = 1
    LeftImage.Image = "http://www.roblox.com/asset/?id=86991492020004"
    LeftImage.ImageColor3 = Color3.fromRGB(160, 110, 255)
    
    -- الصورة اليمنى في الهيدر
    local RightImage = Instance.new("ImageLabel", Header)
    RightImage.Size = UDim2.new(0, 60, 0, 60)
    RightImage.Position = UDim2.new(1, -60, 0, 10)
    RightImage.BackgroundTransparency = 1
    RightImage.Image = "http://www.roblox.com/asset/?id=86991492020004"
    RightImage.ImageColor3 = Color3.fromRGB(160, 110, 255)
    
    -- العنوان
    local Title = Instance.new("TextLabel", Header)
    Title.Size = UDim2.new(1, -130, 1, 0)
    Title.Position = UDim2.new(0, 65, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = [[
👑 RXT SERVER V10
━━━━━━━━━━━━━━━━
⚡ GHOST FARM FIX
⚒️ Dev: 3zf & RXT
    ]]
    Title.TextColor3 = Color3.fromRGB(180, 130, 255)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 14
    Title.TextYAlignment = Enum.TextYAlignment.Top
    
    -- زر الإغلاق
    local CloseBtn = Instance.new("TextButton", Main)
    CloseBtn.Size = UDim2.new(0, 35, 0, 35)
    CloseBtn.Position = UDim2.new(1, -45, 0, 15)
    CloseBtn.Text = "✕"
    CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
    CloseBtn.TextColor3 = Color3.new(1, 1, 1)
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.TextSize = 20
    Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(1, 0)
    
    -- زر الفتح العائم
    local OpenBtn = Instance.new("TextButton", ScreenGui)
    OpenBtn.Size = UDim2.new(0, 65, 0, 65)
    OpenBtn.Position = UDim2.new(0, 20, 0.5, -32.5)
    OpenBtn.BackgroundColor3 = Color3.fromRGB(40, 30, 70)
    OpenBtn.Text = "RXT\nV10"
    OpenBtn.TextColor3 = Color3.fromRGB(180, 130, 255)
    OpenBtn.Font = Enum.Font.GothamBold
    OpenBtn.TextSize = 14
    OpenBtn.Visible = false
    Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(1, 0)
    
    local OpenStroke = Instance.new("UIStroke", OpenBtn)
    OpenStroke.Color = Color3.fromRGB(160, 110, 255)
    OpenStroke.Thickness = 2
    
    CloseBtn.MouseButton1Click:Connect(function()
        Main.Visible = false
        OpenBtn.Visible = true
    end)
    
    OpenBtn.MouseButton1Click:Connect(function()
        Main.Visible = true
        OpenBtn.Visible = false
    end)
    
    -- نظام السحب
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
    
    -- التبويبات
    local TabHolder = Instance.new("Frame", Main)
    TabHolder.Size = UDim2.new(1, -20, 0, 45)
    TabHolder.Position = UDim2.new(0, 10, 0, 95)
    TabHolder.BackgroundTransparency = 1
    
    local TabList = Instance.new("UIListLayout", TabHolder)
    TabList.FillDirection = Enum.FillDirection.Horizontal
    TabList.HorizontalAlignment = Enum.HorizontalAlignment.Center
    TabList.Padding = UDim.new(0, 8)
    
    local Pages = Instance.new("Frame", Main)
    Pages.Size = UDim2.new(1, -20, 1, -180)
    Pages.Position = UDim2.new(0, 10, 0, 150)
    Pages.BackgroundTransparency = 1
    
    local function CreatePage()
        local p = Instance.new("ScrollingFrame", Pages)
        p.Size = UDim2.new(1, 0, 1, 0)
        p.BackgroundTransparency = 1
        p.Visible = false
        p.ScrollBarThickness = 3
        p.ScrollBarImageColor3 = Color3.fromRGB(160, 110, 255)
        Instance.new("UIListLayout", p).Padding = UDim.new(0, 12)
        return p
    end
    
    local P1 = CreatePage() -- MAIN
    local P2 = CreatePage() -- EVENT
    local P3 = CreatePage() -- WORLD
    local P4 = CreatePage() -- TP
    local P5 = CreatePage() -- Dev
    local P6 = CreatePage() -- اتصل
    P1.Visible = true
    
    local function AddTab(t, pg, icon)
        local b = Instance.new("TextButton", TabHolder)
        b.Size = UDim2.new(0, 70, 1, 0)
        b.Text = icon .. "\n" .. t
        b.TextColor3 = Color3.new(1, 1, 1)
        b.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
        b.Font = Enum.Font.GothamBold
        b.TextSize = 11
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
        
        b.MouseButton1Click:Connect(function()
            P1.Visible = false; P2.Visible = false; P3.Visible = false
            P4.Visible = false; P5.Visible = false; P6.Visible = false
            pg.Visible = true
            b.BackgroundColor3 = Color3.fromRGB(80, 60, 140)
            
            for _, btn in pairs(TabHolder:GetChildren()) do
                if btn:IsA("TextButton") and btn ~= b then
                    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
                end
            end
        end)
    end
    
    AddTab("الرئيسية", P1, "🏠")
    AddTab("الأحداث", P2, "🎯")
    AddTab("العالم", P3, "🌎")
    AddTab("الانتقال", P4, "📍")
    AddTab("المطور", P5, "⚒️")
    AddTab("اتصل بنا", P6, "📞")
    
    -- نظام الأزرار
    local function AddToggle(parent, txt, current, cb)
        local b = Instance.new("TextButton", parent)
        b.Size = UDim2.new(1, 0, 0, 42)
        b.Text = txt .. " : OFF"
        b.BackgroundColor3 = Color3.fromRGB(45, 40, 70)
        b.TextColor3 = Color3.new(1, 1, 1)
        b.Font = Enum.Font.GothamBold
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
        
        local state = current
        local function Update()
            b.Text = state and txt .. " : ✅ ON" or txt .. " : ❌ OFF"
            b.BackgroundColor3 = state and Color3.fromRGB(30, 180, 100) or Color3.fromRGB(45, 40, 70)
        end
        
        b.MouseButton1Click:Connect(function()
            state = not state
            cb(state)
            Update()
        end)
        Update()
        return b
    end
    
    -- [ أزرار القائمة ]
    AddToggle(P1, "🚫 إيقاف الرجل", noRagdollEnabled, function(s)
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
    
    AddToggle(P1, "🦘 قفز لا نهائي", infJumpEnabled, function(s)
        infJumpEnabled = s
    end)
    
    local SpdInput = Instance.new("TextBox", P1)
    SpdInput.Size = UDim2.new(1, 0, 0, 38)
    SpdInput.PlaceholderText = "السرعة (16-100)"
    SpdInput.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
    SpdInput.TextColor3 = Color3.new(1, 1, 1)
    SpdInput.Font = Enum.Font.Gotham
    SpdInput.TextSize = 14
    Instance.new("UICorner", SpdInput).CornerRadius = UDim.new(0, 8)
    SpdInput.Text = "50"
    
    AddToggle(P1, "⚡ السرعة الخفية", stealthSpeedEnabled, function(s)
        stealthSpeedEnabled = s
        speedValue = tonumber(SpdInput.Text) or 50
    end)
    
    AddToggle(P2, "☢️ تجميع الكوينز", radioactiveFarmEnabled, function(s)
        radioactiveFarmEnabled = s
    end)
    
    AddToggle(P2, "⚡ تفاعل فوري", instantInteractionEnabled, function(s)
        instantInteractionEnabled = s
        if s then
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("ProximityPrompt") then
                    v.HoldDuration = 0
                end
            end
        end
    end)
    
    AddToggle(P3, "⚡ تحسين الأداء", false, function(s)
        if s then
            for _, v in pairs(game:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.Material = "SmoothPlastic"
                end
            end
        end
    end)
    
    AddToggle(P3, "👁️ تكبير الكاميرا", false, function(s)
        if s then
            player.CameraMaxZoomDistance = 100000
        end
    end)
    
    AddToggle(P3, "💡 إضاءة كاملة", false, function(s)
        if s then
            Lighting.Brightness = 2
            Lighting.ClockTime = 14
        end
    end)
    
    local bSave = Instance.new("TextButton", P4)
    bSave.Size = UDim2.new(1, 0, 0, 42)
    bSave.Text = "📍 حفظ الموقع الحالي"
    bSave.BackgroundColor3 = Color3.fromRGB(45, 40, 70)
    bSave.TextColor3 = Color3.new(1, 1, 1)
    bSave.Font = Enum.Font.GothamBold
    Instance.new("UICorner", bSave).CornerRadius = UDim.new(0, 8)
    
    bSave.MouseButton1Click:Connect(function()
        if player.Character then
            savedPosition = player.Character.HumanoidRootPart.CFrame
            bSave.Text = "✅ تم حفظ الموقع!"
            task.wait(1.5)
            bSave.Text = "📍 حفظ الموقع الحالي"
        end
    end)
    
    local bTP = Instance.new("TextButton", P4)
    bTP.Size = UDim2.new(1, 0, 0, 42)
    bTP.Text = "🌀 الانتقال للموقع المحفوظ"
    bTP.BackgroundColor3 = Color3.fromRGB(45, 40, 70)
    bTP.TextColor3 = Color3.new(1, 1, 1)
    bTP.Font = Enum.Font.GothamBold
    Instance.new("UICorner", bTP).CornerRadius = UDim.new(0, 8)
    
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
    
    -- [[ 🛠️ تبويب Dev ]] --
    local DevLabel = Instance.new("TextLabel", P5)
    DevLabel.Size = UDim2.new(1, 0, 0, 150)
    DevLabel.BackgroundTransparency = 1
    DevLabel.Text = [[
⚒️ أدوات المطور
━━━━━━━━━━━━━━
👨‍💻 المطورون:
• 3zf
• RXT

📦 الإصدار: V10
🔐 نظام المفاتيح: 24 ساعة
🛡️ مزرعة الأشباح الآمنة
⏰ وقت التفعيل: 24h
🎨 الواجهة: محسنة

🔧 المميزات:
• نظام مفاتيح آمن
• إرسال تقارير تلقائية
• واجهة مستخدم متطورة
• حماية من الطرد
• أداء محسن
    ]]
    DevLabel.TextColor3 = Color3.fromRGB(180, 130, 255)
    DevLabel.Font = Enum.Font.Gotham
    DevLabel.TextSize = 13
    DevLabel.TextYAlignment = Enum.TextYAlignment.Top
    
    local ReloadBtn = Instance.new("TextButton", P5)
    ReloadBtn.Size = UDim2.new(1, 0, 0, 42)
    ReloadBtn.Position = UDim2.new(0, 0, 0, 160)
    ReloadBtn.Text = "🔄 إعادة تحميل السكربت"
    ReloadBtn.BackgroundColor3 = Color3.fromRGB(45, 40, 70)
    ReloadBtn.TextColor3 = Color3.new(1, 1, 1)
    ReloadBtn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", ReloadBtn).CornerRadius = UDim.new(0, 8)
    
    ReloadBtn.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
        task.wait(0.5)
        CreateKeyGui()
    end)
    
    -- [[ 📞 تبويب الاقتراحات والشكاوي ]] --
    local ContactLabel = Instance.new("TextLabel", P6)
    ContactLabel.Size = UDim2.new(1, 0, 0, 80)
    ContactLabel.BackgroundTransparency = 1
    ContactLabel.Text = [[
📞 مركز الاتصال
━━━━━━━━━━━━━━
أرسل اقتراحاتك أو شكاويك
سيتم إرسالها مباشرة إلى المطورين
    ]]
    ContactLabel.TextColor3 = Color3.fromRGB(180, 130, 255)
    ContactLabel.Font = Enum.Font.GothamBold
    ContactLabel.TextSize = 14
    ContactLabel.TextYAlignment = Enum.TextYAlignment.Top
    
    -- حقل الاقتراحات
    local SuggestionLabel = Instance.new("TextLabel", P6)
    SuggestionLabel.Size = UDim2.new(1, 0, 0, 25)
    SuggestionLabel.Position = UDim2.new(0, 0, 0, 85)
    SuggestionLabel.BackgroundTransparency = 1
    SuggestionLabel.Text = "💡 الاقتراحات:"
    SuggestionLabel.TextColor3 = Color3.fromRGB(150, 200, 255)
    SuggestionLabel.Font = Enum.Font.GothamBold
    SuggestionLabel.TextSize = 13
    SuggestionLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local SuggestionBox = Instance.new("TextBox", P6)
    SuggestionBox.Size = UDim2.new(1, 0, 0, 100)
    SuggestionBox.Position = UDim2.new(0, 0, 0, 110)
    SuggestionBox.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
    SuggestionBox.TextColor3 = Color3.new(1, 1, 1)
    SuggestionBox.Font = Enum.Font.Gotham
    SuggestionBox.TextSize = 13
    SuggestionBox.PlaceholderText = "اكتب اقتراحك هنا لتحسين السكربت..."
    SuggestionBox.Text = ""
    SuggestionBox.TextXAlignment = Enum.TextXAlignment.Left
    SuggestionBox.TextYAlignment = Enum.TextYAlignment.Top
    SuggestionBox.MultiLine = true
    SuggestionBox.ClearTextOnFocus = false
    Instance.new("UICorner", SuggestionBox).CornerRadius = UDim.new(0, 8)
    
    local SendSuggestionBtn = Instance.new("TextButton", P6)
    SendSuggestionBtn.Size = UDim2.new(1, 0, 0, 42)
    SendSuggestionBtn.Position = UDim2.new(0, 0, 0, 220)
    SendSuggestionBtn.Text = "📤 إرسال الاقتراح"
    SendSuggestionBtn.BackgroundColor3 = Color3.fromRGB(60, 100, 180)
    SendSuggestionBtn.TextColor3 = Color3.new(1, 1, 1)
    SendSuggestionBtn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", SendSuggestionBtn).CornerRadius = UDim.new(0, 8)
    
    SendSuggestionBtn.MouseButton1Click:Connect(function()
        local suggestion = SuggestionBox.Text
        if suggestion and suggestion ~= "" and #suggestion > 5 then
            local webhookData = {
                ["username"] = "RXT Suggestions",
                ["avatar_url"] = "https://cdn.discordapp.com/attachments/123456789/987654321/suggestion.png",
                ["embeds"] = {{
                    ["title"] = "💡 اقتراح جديد",
                    ["description"] = suggestion,
                    ["color"] = 3447003,
                    ["fields"] = {
                        {
                            ["name"] = "👤 المرسل",
                            ["value"] = player.Name,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "🆔 الأيدي",
                            ["value"] = tostring(player.UserId),
                            ["inline"] = true
                        },
                        {
                            ["name"] = "🕐 الوقت",
                            ["value"] = os.date("%Y/%m/%d %I:%M %p"),
                            ["inline"] = true
                        }
                    },
                    ["footer"] = {
                        ["text"] = "RXT Script V10 • Suggestion System"
                    },
                    ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ")
                }}
            }
            
            SendWebhook(suggestionWebhook, webhookData)
            SuggestionBox.Text = ""
            SendSuggestionBtn.Text = "✅ تم إرسال الاقتراح!"
            task.wait(1.5)
            SendSuggestionBtn.Text = "📤 إرسال الاقتراح"
        else
            SendSuggestionBtn.Text = "❌ اكتب اقتراحاً أطول!"
            task.wait(1)
            SendSuggestionBtn.Text = "📤 إرسال الاقتراح"
        end
    end)
    
    -- حقل الشكاوي
    local ComplaintLabel = Instance.new("TextLabel", P6)
    ComplaintLabel.Size = UDim2.new(1, 0, 0, 25)
    ComplaintLabel.Position = UDim2.new(0, 0, 0, 272)
    ComplaintLabel.BackgroundTransparency = 1
    ComplaintLabel.Text = "🚨 الشكاوي:"
    ComplaintLabel.TextColor3 = Color3.fromRGB(255, 150, 150)
    ComplaintLabel.Font = Enum.Font.GothamBold
    ComplaintLabel.TextSize = 13
    ComplaintLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local ComplaintBox = Instance.new("TextBox", P6)
    ComplaintBox.Size = UDim2.new(1, 0, 0, 100)
    ComplaintBox.Position = UDim2.new(0, 0, 0, 297)
    ComplaintBox.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
    ComplaintBox.TextColor3 = Color3.new(1, 1, 1)
    ComplaintBox.Font = Enum.Font.Gotham
    ComplaintBox.TextSize = 13
    ComplaintBox.PlaceholderText = "اكتب شكواك هنا عن مشكلة واجهتها..."
    ComplaintBox.Text = ""
    ComplaintBox.TextXAlignment = Enum.TextXAlignment.Left
    ComplaintBox.TextYAlignment = Enum.TextYAlignment.Top
    ComplaintBox.MultiLine = true
    ComplaintBox.ClearTextOnFocus = false
    Instance.new("UICorner", ComplaintBox).CornerRadius = UDim.new(0, 8)
    
    local SendComplaintBtn = Instance.new("TextButton", P6)
    SendComplaintBtn.Size = UDim2.new(1, 0, 0, 42)
    SendComplaintBtn.Position = UDim2.new(0, 0, 0, 407)
    SendComplaintBtn.Text = "🚨 إرسال الشكوى"
    SendComplaintBtn.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
    SendComplaintBtn.TextColor3 = Color3.new(1, 1, 1)
    SendComplaintBtn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", SendComplaintBtn).CornerRadius = UDim.new(0, 8)
    
    SendComplaintBtn.MouseButton1Click:Connect(function()
        local complaint = ComplaintBox.Text
        if complaint and complaint ~= "" and #complaint > 5 then
            local webhookData = {
                ["username"] = "RXT Complaints",
                ["avatar_url"] = "https://cdn.discordapp.com/attachments/123456789/987654321/complaint.png",
                ["embeds"] = {{
                    ["title"] = "🚨 شكوى جديدة",
                    ["description"] = complaint,
                    ["color"] = 15158332,
                    ["fields"] = {
                        {
                            ["name"] = "👤 المرسل",
                            ["value"] = player.Name,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "🆔 الأيدي",
                            ["value"] = tostring(player.UserId),
                            ["inline"] = true
                        },
                        {
                            ["name"] = "🕐 الوقت",
                            ["value"] = os.date("%Y/%m/%d %I:%M %p"),
                            ["inline"] = true
                        }
                    },
                    ["footer"] = {
                        ["text"] = "RXT Script V10 • Complaint System"
                    },
                    ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ")
                }}
            }
            
            SendWebhook(complaintWebhook, webhookData)
            ComplaintBox.Text = ""
            SendComplaintBtn.Text = "✅ تم إرسال الشكوى!"
            task.wait(1.5)
            SendComplaintBtn.Text = "🚨 إرسال الشكوى"
        else
            SendComplaintBtn.Text = "❌ اكتب شكوى أطول!"
            task.wait(1)
            SendComplaintBtn.Text = "🚨 إرسال الشكوى"
        end
    end)
    
    -- الفوتر
    local Footer = Instance.new("TextLabel", Main)
    Footer.Size = UDim2.new(1, 0, 0, 40)
    Footer.Position = UDim2.new(0, 0, 1, -40)
    Footer.BackgroundTransparency = 1
    Footer.Text = "🔐 المفتاح: RXT24 | ⏰ صلاحية: 24 ساعة | 👑 RXT V10"
    Footer.TextColor3 = Color3.fromRGB(160, 110, 255)
    Footer.Font = Enum.Font.GothamBold
    Footer.TextSize = 12
    
    print("👑 RXT MASTER V10 LOADED - KEY SYSTEM ACTIVE")
end

-- بدء واجهة المفتاح أولاً
CreateKeyGui()
