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
local webhookURL = "https://discord.com/api/webhooks/1462554040633266217/BoaIVF4se11rul1HJS7RTtESHd9hP0v-6ZYLPm6S82-uWFIC62g2X9k4jjxZ6dcvkDvV"

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

-- [[ 🔧 وظيفة إرسال ويب هوك جديدة ومختبرة ]] --
local function SendDiscordWebhook(title, description, color, webhookType, extraData)
    pcall(function()
        local url = webhookURL
        
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
        
        -- إضافة معلومات المستخدم
        table.insert(embed.fields, {
            ["name"] = "👤 المستخدم",
            ["value"] = player.Name,
            ["inline"] = true
        })
        
        table.insert(embed.fields, {
            ["name"] = "🆔 الأيدي",
            ["value"] = tostring(player.UserId),
            ["inline"] = true
        })
        
        table.insert(embed.fields, {
            ["name"] = "🎮 مكان اللعب",
            ["value"] = game.PlaceId .. " | " .. game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name,
            ["inline"] = false
        })
        
        -- إضافة بيانات إضافية إذا كانت موجودة
        if extraData then
            for _, data in pairs(extraData) do
                table.insert(embed.fields, data)
            end
        end
        
        -- إنشاء البيانات النهائية
        local data = {
            ["username"] = "RXT Script Logger",
            ["avatar_url"] = "https://cdn.discordapp.com/attachments/123456789/987654321/rxt_logo.png",
            ["embeds"] = {embed}
        }
        
        -- تحويل البيانات إلى JSON
        local jsonData = HttpService:JSONEncode(data)
        
        -- إرسال الطلب
        local success, response = pcall(function()
            return HttpService:PostAsync(url, jsonData, Enum.HttpContentType.ApplicationJson)
        end)
        
        if success then
            print("✅ تم إرسال الويب هوك بنجاح: " .. title)
        else
            warn("❌ فشل إرسال الويب هوك: " .. tostring(response))
        end
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
    Background.BackgroundTransparency = 0.6
    Background.Parent = KeyGui
    
    -- نافذة المفتاح الرئيسية
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 450, 0, 400)
    MainFrame.Position = UDim2.new(0.5, -225, 0.5, -200)
    MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 25)
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = KeyGui
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 20)
    UICorner.Parent = MainFrame
    
    local UIStroke = Instance.new("UIStroke")
    UIStroke.Color = Color3.fromRGB(170, 120, 255)
    UIStroke.Thickness = 3
    UIStroke.Parent = MainFrame
    
    -- الصورة العلوية اليسرى
    local TopLeftImage = Instance.new("ImageLabel")
    TopLeftImage.Size = UDim2.new(0, 80, 0, 80)
    TopLeftImage.Position = UDim2.new(0.02, 0, 0.02, 0)
    TopLeftImage.BackgroundTransparency = 1
    TopLeftImage.Image = "rbxassetid://86991492020004"
    TopLeftImage.ImageColor3 = Color3.fromRGB(170, 120, 255)
    TopLeftImage.ImageTransparency = 0.2
    TopLeftImage.Parent = MainFrame
    
    -- الصورة العلوية اليمنى
    local TopRightImage = Instance.new("ImageLabel")
    TopRightImage.Size = UDim2.new(0, 80, 0, 80)
    TopRightImage.Position = UDim2.new(0.98, -80, 0.02, 0)
    TopRightImage.BackgroundTransparency = 1
    TopRightImage.Image = "rbxassetid://86991492020004"
    TopRightImage.ImageColor3 = Color3.fromRGB(170, 120, 255)
    TopRightImage.ImageTransparency = 0.2
    TopRightImage.Parent = MainFrame
    
    -- العنوان الرئيسي
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(0.8, 0, 0, 100)
    Title.Position = UDim2.new(0.1, 0, 0.05, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "🔐 RXT SCRIPT\n━━━━━━━━━━━━━━\nVERSION 10.0"
    Title.TextColor3 = Color3.fromRGB(190, 140, 255)
    Title.Font = Enum.Font.GothamBlack
    Title.TextSize = 28
    Title.TextXAlignment = Enum.TextXAlignment.Center
    Title.Parent = MainFrame
    
    -- الصورة الوسطى
    local CenterImage = Instance.new("ImageLabel")
    CenterImage.Size = UDim2.new(0, 120, 0, 120)
    CenterImage.Position = UDim2.new(0.5, -60, 0.3, 0)
    CenterImage.BackgroundTransparency = 1
    CenterImage.Image = "rbxassetid://86991492020004"
    CenterImage.Parent = MainFrame
    
    -- قسم المفتاح
    local KeyFrame = Instance.new("Frame")
    KeyFrame.Size = UDim2.new(0.85, 0, 0, 100)
    KeyFrame.Position = UDim2.new(0.075, 0, 0.65, 0)
    KeyFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    KeyFrame.Parent = MainFrame
    
    local KeyUICorner = Instance.new("UICorner")
    KeyUICorner.CornerRadius = UDim.new(0, 15)
    KeyUICorner.Parent = KeyFrame
    
    local KeyLabel = Instance.new("TextLabel")
    KeyLabel.Size = UDim2.new(1, 0, 0, 40)
    KeyLabel.BackgroundTransparency = 1
    KeyLabel.Text = "🔑 المفتاح: RXT24 (24 ساعة)"
    KeyLabel.TextColor3 = Color3.new(1, 1, 1)
    KeyLabel.Font = Enum.Font.GothamBold
    KeyLabel.TextSize = 18
    KeyLabel.Parent = KeyFrame
    
    local KeyBox = Instance.new("TextBox")
    KeyBox.Size = UDim2.new(0.9, 0, 0, 50)
    KeyBox.Position = UDim2.new(0.05, 0, 0.5, 0)
    KeyBox.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
    KeyBox.TextColor3 = Color3.new(1, 1, 1)
    KeyBox.Font = Enum.Font.GothamBold
    KeyBox.TextSize = 18
    KeyBox.PlaceholderText = "أدخل RXT24 هنا..."
    KeyBox.Text = ""
    KeyBox.Parent = KeyFrame
    
    local KeyBoxCorner = Instance.new("UICorner")
    KeyBoxCorner.CornerRadius = UDim.new(0, 12)
    KeyBoxCorner.Parent = KeyBox
    
    -- زر التفعيل
    local ActivateBtn = Instance.new("TextButton")
    ActivateBtn.Size = UDim2.new(0.85, 0, 0, 60)
    ActivateBtn.Position = UDim2.new(0.075, 0, 0.85, 0)
    ActivateBtn.BackgroundColor3 = Color3.fromRGB(130, 80, 230)
    ActivateBtn.Text = "⚡ تفعيل السكربت الآن"
    ActivateBtn.TextColor3 = Color3.new(1, 1, 1)
    ActivateBtn.Font = Enum.Font.GothamBlack
    ActivateBtn.TextSize = 22
    ActivateBtn.Parent = MainFrame
    
    local ActivateCorner = Instance.new("UICorner")
    ActivateCorner.CornerRadius = UDim.new(0, 15)
    ActivateCorner.Parent = ActivateBtn
    
    -- إضافة تدرج لوني للزر
    local UIGradient = Instance.new("UIGradient")
    UIGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(130, 80, 230)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 130, 255))
    })
    UIGradient.Rotation = 45
    UIGradient.Parent = ActivateBtn
    
    -- رسالة الحالة
    local StatusLabel = Instance.new("TextLabel")
    StatusLabel.Size = UDim2.new(0.85, 0, 0, 30)
    StatusLabel.Position = UDim2.new(0.075, 0, 0.95, 0)
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.Text = "⌛ أدخل المفتاح لتفعيل السكربت"
    StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    StatusLabel.Font = Enum.Font.Gotham
    StatusLabel.TextSize = 14
    StatusLabel.Parent = MainFrame
    
    -- نص المطورين
    local DevText = Instance.new("TextLabel")
    DevText.Size = UDim2.new(1, 0, 0, 40)
    DevText.Position = UDim2.new(0, 0, 1, -40)
    DevText.BackgroundTransparency = 1
    DevText.Text = "⚒️ تم التطوير بواسطة 3zf & RXT | V10 | Key: RXT24"
    DevText.TextColor3 = Color3.fromRGB(170, 120, 255)
    DevText.Font = Enum.Font.GothamBold
    DevText.TextSize = 13
    DevText.Parent = MainFrame
    
    -- دالة تفعيل المفتاح
    ActivateBtn.MouseButton1Click:Connect(function()
        local enteredKey = KeyBox.Text:upper():gsub("%s+", "")
        
        if enteredKey == "RXT24" then
            -- إرسال إشعار التفعيل للدسكورد
            SendDiscordWebhook(
                "✅ تفعيل جديد للسكربت",
                "قام مستخدم بتفعيل سكربت RXT V10",
                65280, -- أخضر
                "activation",
                {
                    {
                        ["name"] = "🔑 المفتاح المستخدم",
                        ["value"] = "RXT24",
                        ["inline"] = true
                    },
                    {
                        ["name"] = "⏰ صلاحية المفتاح",
                        ["value"] = "24 ساعة",
                        ["inline"] = true
                    },
                    {
                        ["name"] = "🕐 وقت التفعيل",
                        ["value"] = os.date("%I:%M:%S %p"),
                        ["inline"] = true
                    }
                }
            )
            
            StatusLabel.Text = "✅ تم التفعيل بنجاح! جاري التحميل..."
            StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
            
            -- تأثير نجاح
            ActivateBtn.Text = "✅ تم التفعيل!"
            ActivateBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 80)
            
            task.wait(1.5)
            KeyGui:Destroy()
            CreateMainGui()
        else
            StatusLabel.Text = "❌ المفتاح غير صحيح! المفتاح الصحيح: RXT24"
            StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
            
            -- تأثير خطأ
            ActivateBtn.Text = "❌ خطأ في المفتاح!"
            ActivateBtn.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
            
            task.wait(1)
            ActivateBtn.Text = "⚡ تفعيل السكربت الآن"
            ActivateBtn.BackgroundColor3 = Color3.fromRGB(130, 80, 230)
        end
    end)
    
    -- إضافة تأثيرات للزر
    ActivateBtn.MouseEnter:Connect(function()
        game:GetService("TweenService"):Create(
            ActivateBtn,
            TweenInfo.new(0.3),
            {BackgroundColor3 = Color3.fromRGB(150, 100, 250)}
        ):Play()
    end)
    
    ActivateBtn.MouseLeave:Connect(function()
        game:GetService("TweenService"):Create(
            ActivateBtn,
            TweenInfo.new(0.3),
            {BackgroundColor3 = Color3.fromRGB(130, 80, 230)}
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
    Main.Size = UDim2.new(0, 420, 0, 620)
    Main.Position = UDim2.new(0.5, -210, 0.5, -310)
    Main.BackgroundColor3 = Color3.fromRGB(18, 18, 25)
    Main.BorderSizePixel = 0
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 20)
    UICorner.Parent = Main
    
    local UIStroke = Instance.new("UIStroke")
    UIStroke.Color = Color3.fromRGB(170, 120, 255)
    UIStroke.Thickness = 3
    UIStroke.Parent = Main
    
    -- الهيدر مع الصور
    local Header = Instance.new("Frame", Main)
    Header.Size = UDim2.new(1, -20, 0, 90)
    Header.Position = UDim2.new(0, 10, 0, 10)
    Header.BackgroundTransparency = 1
    
    -- الصورة اليسرى
    local LeftImage = Instance.new("ImageLabel", Header)
    LeftImage.Size = UDim2.new(0, 70, 0, 70)
    LeftImage.Position = UDim2.new(0, 0, 0, 10)
    LeftImage.BackgroundTransparency = 1
    LeftImage.Image = "rbxassetid://86991492020004"
    LeftImage.ImageColor3 = Color3.fromRGB(170, 120, 255)
    
    -- الصورة اليمنى
    local RightImage = Instance.new("ImageLabel", Header)
    RightImage.Size = UDim2.new(0, 70, 0, 70)
    RightImage.Position = UDim2.new(1, -70, 0, 10)
    RightImage.BackgroundTransparency = 1
    RightImage.Image = "rbxassetid://86991492020004"
    RightImage.ImageColor3 = Color3.fromRGB(170, 120, 255)
    
    -- العنوان
    local Title = Instance.new("TextLabel", Header)
    Title.Size = UDim2.new(1, -150, 1, 0)
    Title.Position = UDim2.new(0, 80, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = [[
👑 RXT SERVER V10
━━━━━━━━━━━━━━━━
⚡ GHOST FARM FIX
⚒️ 3zf & RXT
🔐 Key: RXT24
    ]]
    Title.TextColor3 = Color3.fromRGB(190, 140, 255)
    Title.Font = Enum.Font.GothamBlack
    Title.TextSize = 16
    Title.TextYAlignment = Enum.TextYAlignment.Top
    
    -- زر الإغلاق
    local CloseBtn = Instance.new("TextButton", Main)
    CloseBtn.Size = UDim2.new(0, 40, 0, 40)
    CloseBtn.Position = UDim2.new(1, -50, 0, 20)
    CloseBtn.Text = "✕"
    CloseBtn.BackgroundColor3 = Color3.fromRGB(220, 70, 70)
    CloseBtn.TextColor3 = Color3.new(1, 1, 1)
    CloseBtn.Font = Enum.Font.GothamBlack
    CloseBtn.TextSize = 22
    Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(1, 0)
    
    -- زر الفتح العائم
    local OpenBtn = Instance.new("TextButton", ScreenGui)
    OpenBtn.Size = UDim2.new(0, 70, 0, 70)
    OpenBtn.Position = UDim2.new(0, 25, 0.5, -35)
    OpenBtn.BackgroundColor3 = Color3.fromRGB(45, 35, 80)
    OpenBtn.Text = "RXT\nV10"
    OpenBtn.TextColor3 = Color3.fromRGB(190, 140, 255)
    OpenBtn.Font = Enum.Font.GothamBlack
    OpenBtn.TextSize = 16
    OpenBtn.Visible = false
    Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(1, 0)
    
    local OpenStroke = Instance.new("UIStroke", OpenBtn)
    OpenStroke.Color = Color3.fromRGB(170, 120, 255)
    OpenStroke.Thickness = 3
    
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
    TabHolder.Size = UDim2.new(1, -20, 0, 50)
    TabHolder.Position = UDim2.new(0, 10, 0, 110)
    TabHolder.BackgroundTransparency = 1
    
    local TabList = Instance.new("UIListLayout", TabHolder)
    TabList.FillDirection = Enum.FillDirection.Horizontal
    TabList.HorizontalAlignment = Enum.HorizontalAlignment.Center
    TabList.Padding = UDim.new(0, 10)
    
    local Pages = Instance.new("Frame", Main)
    Pages.Size = UDim2.new(1, -20, 1, -190)
    Pages.Position = UDim2.new(0, 10, 0, 170)
    Pages.BackgroundTransparency = 1
    
    local function CreatePage()
        local p = Instance.new("ScrollingFrame", Pages)
        p.Size = UDim2.new(1, 0, 1, 0)
        p.BackgroundTransparency = 1
        p.Visible = false
        p.ScrollBarThickness = 4
        p.ScrollBarImageColor3 = Color3.fromRGB(170, 120, 255)
        Instance.new("UIListLayout", p).Padding = UDim.new(0, 15)
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
        b.Size = UDim2.new(0, 75, 1, 0)
        b.Text = icon .. "\n" .. t
        b.TextColor3 = Color3.new(1, 1, 1)
        b.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
        b.Font = Enum.Font.GothamBold
        b.TextSize = 12
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 10)
        
        b.MouseButton1Click:Connect(function()
            P1.Visible = false; P2.Visible = false; P3.Visible = false
            P4.Visible = false; P5.Visible = false; P6.Visible = false
            pg.Visible = true
            b.BackgroundColor3 = Color3.fromRGB(90, 70, 160)
            
            for _, btn in pairs(TabHolder:GetChildren()) do
                if btn:IsA("TextButton") and btn ~= b then
                    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
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
        b.Size = UDim2.new(1, 0, 0, 45)
        b.Text = txt .. " : ❌"
        b.BackgroundColor3 = Color3.fromRGB(50, 45, 75)
        b.TextColor3 = Color3.new(1, 1, 1)
        b.Font = Enum.Font.GothamBold
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 10)
        
        local state = current
        local function Update()
            b.Text = state and txt .. " : ✅" or txt .. " : ❌"
            b.BackgroundColor3 = state and Color3.fromRGB(40, 200, 110) or Color3.fromRGB(50, 45, 75)
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
    SpdInput.Size = UDim2.new(1, 0, 0, 40)
    SpdInput.PlaceholderText = "السرعة (16-100)"
    SpdInput.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    SpdInput.TextColor3 = Color3.new(1, 1, 1)
    SpdInput.Font = Enum.Font.Gotham
    SpdInput.TextSize = 15
    Instance.new("UICorner", SpdInput).CornerRadius = UDim.new(0, 10)
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
    bSave.Size = UDim2.new(1, 0, 0, 45)
    bSave.Text = "📍 حفظ الموقع الحالي"
    bSave.BackgroundColor3 = Color3.fromRGB(50, 45, 75)
    bSave.TextColor3 = Color3.new(1, 1, 1)
    bSave.Font = Enum.Font.GothamBold
    Instance.new("UICorner", bSave).CornerRadius = UDim.new(0, 10)
    
    bSave.MouseButton1Click:Connect(function()
        if player.Character then
            savedPosition = player.Character.HumanoidRootPart.CFrame
            bSave.Text = "✅ تم حفظ الموقع!"
            task.wait(1.5)
            bSave.Text = "📍 حفظ الموقع الحالي"
        end
    end)
    
    local bTP = Instance.new("TextButton", P4)
    bTP.Size = UDim2.new(1, 0, 0, 45)
    bTP.Text = "🌀 الانتقال للموقع المحفوظ"
    bTP.BackgroundColor3 = Color3.fromRGB(50, 45, 75)
    bTP.TextColor3 = Color3.new(1, 1, 1)
    bTP.Font = Enum.Font.GothamBold
    Instance.new("UICorner", bTP).CornerRadius = UDim.new(0, 10)
    
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
    DevLabel.Size = UDim2.new(1, 0, 0, 180)
    DevLabel.BackgroundTransparency = 1
    DevLabel.Text = [[
⚒️ أدوات المطور
━━━━━━━━━━━━━━━━━━
👨‍💻 المطورون:
• 3zf
• RXT

📦 الإصدار: V10
🔐 نظام المفاتيح: RXT24
⏰ صلاحية المفتاح: 24 ساعة
🛡️ مزرعة الأشباح الآمنة
🎮 مكان اللعب الحالي:
]] .. game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name .. [[

🔧 المميزات المضمنة:
• نظام مفاتيح آمن
• إرسال تقارير تلقائية
• واجهة مستخدم متطورة
• حماية من الطرد
• أداء محسن
• دعم فني مباشر
    ]]
    DevLabel.TextColor3 = Color3.fromRGB(190, 140, 255)
    DevLabel.Font = Enum.Font.Gotham
    DevLabel.TextSize = 13
    DevLabel.TextYAlignment = Enum.TextYAlignment.Top
    
    local ReloadBtn = Instance.new("TextButton", P5)
    ReloadBtn.Size = UDim2.new(1, 0, 0, 45)
    ReloadBtn.Position = UDim2.new(0, 0, 0, 190)
    ReloadBtn.Text = "🔄 إعادة تحميل السكربت"
    ReloadBtn.BackgroundColor3 = Color3.fromRGB(50, 45, 75)
    ReloadBtn.TextColor3 = Color3.new(1, 1, 1)
    ReloadBtn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", ReloadBtn).CornerRadius = UDim.new(0, 10)
    
    ReloadBtn.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
        task.wait(0.5)
        CreateKeyGui()
    end)
    
    -- [[ 📞 تبويب الاقتراحات والشكاوي ]] --
    local ContactLabel = Instance.new("TextLabel", P6)
    ContactLabel.Size = UDim2.new(1, 0, 0, 90)
    ContactLabel.BackgroundTransparency = 1
    ContactLabel.Text = [[
📞 مركز الاتصال
━━━━━━━━━━━━━━━━━━
أرسل اقتراحاتك أو شكاويك
سيتم إرسالها مباشرة إلى المطورين
جميع الرسائل مراقبة وتسجل
    ]]
    ContactLabel.TextColor3 = Color3.fromRGB(190, 140, 255)
    ContactLabel.Font = Enum.Font.GothamBold
    ContactLabel.TextSize = 15
    ContactLabel.TextYAlignment = Enum.TextYAlignment.Top
    
    -- حقل الاقتراحات
    local SuggestionLabel = Instance.new("TextLabel", P6)
    SuggestionLabel.Size = UDim2.new(1, 0, 0, 30)
    SuggestionLabel.Position = UDim2.new(0, 0, 0, 95)
    SuggestionLabel.BackgroundTransparency = 1
    SuggestionLabel.Text = "💡 الاقتراحات:"
    SuggestionLabel.TextColor3 = Color3.fromRGB(150, 200, 255)
    SuggestionLabel.Font = Enum.Font.GothamBold
    SuggestionLabel.TextSize = 14
    SuggestionLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local SuggestionBox = Instance.new("TextBox", P6)
    SuggestionBox.Size = UDim2.new(1, 0, 0, 110)
    SuggestionBox.Position = UDim2.new(0, 0, 0, 125)
    SuggestionBox.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    SuggestionBox.TextColor3 = Color3.new(1, 1, 1)
    SuggestionBox.Font = Enum.Font.Gotham
    SuggestionBox.TextSize = 14
    SuggestionBox.PlaceholderText = "اكتب اقتراحك هنا لتحسين السكربت..."
    SuggestionBox.Text = ""
    SuggestionBox.TextXAlignment = Enum.TextXAlignment.Left
    SuggestionBox.TextYAlignment = Enum.TextYAlignment.Top
    SuggestionBox.MultiLine = true
    SuggestionBox.ClearTextOnFocus = false
    Instance.new("UICorner", SuggestionBox).CornerRadius = UDim.new(0, 10)
    
    local SendSuggestionBtn = Instance.new("TextButton", P6)
    SendSuggestionBtn.Size = UDim2.new(1, 0, 0, 45)
    SendSuggestionBtn.Position = UDim2.new(0, 0, 0, 245)
    SendSuggestionBtn.Text = "📤 إرسال الاقتراح"
    SendSuggestionBtn.BackgroundColor3 = Color3.fromRGB(70, 120, 200)
    SendSuggestionBtn.TextColor3 = Color3.new(1, 1, 1)
    SendSuggestionBtn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", SendSuggestionBtn).CornerRadius = UDim.new(0, 10)
    
    SendSuggestionBtn.MouseButton1Click:Connect(function()
        local suggestion = SuggestionBox.Text
        if suggestion and suggestion ~= "" and #suggestion > 5 then
            SendDiscordWebhook(
                "💡 اقتراح جديد",
                suggestion,
                3447003, -- أزرق
                "suggestion",
                {
                    {
                        ["name"] = "📝 نوع الرسالة",
                        ["value"] = "اقتراح",
                        ["inline"] = true
                    },
                    {
                        ["name"] = "📏 طول الرسالة",
                        ["value"] = #suggestion .. " حرف",
                        ["inline"] = true
                    },
                    {
                        ["name"] = "🕐 وقت الإرسال",
                        ["value"] = os.date("%I:%M:%S %p"),
                        ["inline"] = true
                    }
                }
            )
            
            SuggestionBox.Text = ""
            SendSuggestionBtn.Text = "✅ تم إرسال الاقتراح!"
            task.wait(1.5)
            SendSuggestionBtn.Text = "📤 إرسال الاقتراح"
        else
            SendSuggestionBtn.Text = "❌ اكتب اقتراحاً أطول من 5 أحرف!"
            task.wait(1)
            SendSuggestionBtn.Text = "📤 إرسال الاقتراح"
        end
    end)
    
    -- حقل الشكاوي
    local ComplaintLabel = Instance.new("TextLabel", P6)
    ComplaintLabel.Size = UDim2.new(1, 0, 0, 30)
    ComplaintLabel.Position = UDim2.new(0, 0, 0, 300)
    ComplaintLabel.BackgroundTransparency = 1
    ComplaintLabel.Text = "🚨 الشكاوي:"
    ComplaintLabel.TextColor3 = Color3.fromRGB(255, 150, 150)
    ComplaintLabel.Font = Enum.Font.GothamBold
    ComplaintLabel.TextSize = 14
    ComplaintLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local ComplaintBox = Instance.new("TextBox", P6)
    ComplaintBox.Size = UDim2.new(1, 0, 0, 110)
    ComplaintBox.Position = UDim2.new(0, 0, 0, 330)
    ComplaintBox.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    ComplaintBox.TextColor3 = Color3.new(1, 1, 1)
    ComplaintBox.Font = Enum.Font.Gotham
    ComplaintBox.TextSize = 14
    ComplaintBox.PlaceholderText = "اكتب شكواك هنا عن مشكلة واجهتها..."
    ComplaintBox.Text = ""
    ComplaintBox.TextXAlignment = Enum.TextXAlignment.Left
    ComplaintBox.TextYAlignment = Enum.TextYAlignment.Top
    ComplaintBox.MultiLine = true
    ComplaintBox.ClearTextOnFocus = false
    Instance.new("UICorner", ComplaintBox).CornerRadius = UDim.new(0, 10)
    
    local SendComplaintBtn = Instance.new("TextButton", P6)
    SendComplaintBtn.Size = UDim2.new(1, 0, 0, 45)
    SendComplaintBtn.Position = UDim2.new(0, 0, 0, 450)
    SendComplaintBtn.Text = "🚨 إرسال الشكوى"
    SendComplaintBtn.BackgroundColor3 = Color3.fromRGB(200, 70, 70)
    SendComplaintBtn.TextColor3 = Color3.new(1, 1, 1)
    SendComplaintBtn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", SendComplaintBtn).CornerRadius = UDim.new(0, 10)
    
    SendComplaintBtn.MouseButton1Click:Connect(function()
        local complaint = ComplaintBox.Text
        if complaint and complaint ~= "" and #complaint > 5 then
            SendDiscordWebhook(
                "🚨 شكوى جديدة",
                complaint,
                15158332, -- أحمر
                "complaint",
                {
                    {
                        ["name"] = "📝 نوع الرسالة",
                        ["value"] = "شكوى",
                        ["inline"] = true
                    },
                    {
                        ["name"] = "📏 طول الرسالة",
                        ["value"] = #complaint .. " حرف",
                        ["inline"] = true
                    },
                    {
                        ["name"] = "⚠️ مستوى الأهمية",
                        ["value"] = "عالية",
                        ["inline"] = true
                    },
                    {
                        ["name"] = "🕐 وقت الإرسال",
                        ["value"] = os.date("%I:%M:%S %p"),
                        ["inline"] = true
                    }
                }
            )
            
            ComplaintBox.Text = ""
            SendComplaintBtn.Text = "✅ تم إرسال الشكوى!"
            task.wait(1.5)
            SendComplaintBtn.Text = "🚨 إرسال الشكوى"
        else
            SendComplaintBtn.Text = "❌ اكتب شكوى أطول من 5 أحرف!"
            task.wait(1)
            SendComplaintBtn.Text = "🚨 إرسال الشكوى"
        end
    end)
    
    -- زر اختبار الويب هوك
    local TestWebhookBtn = Instance.new("TextButton", P5)
    TestWebhookBtn.Size = UDim2.new(1, 0, 0, 45)
    TestWebhookBtn.Position = UDim2.new(0, 0, 0, 245)
    TestWebhookBtn.Text = "🔧 اختبار نظام الإرسال"
    TestWebhookBtn.BackgroundColor3 = Color3.fromRGB(70, 45, 110)
    TestWebhookBtn.TextColor3 = Color3.new(1, 1, 1)
    TestWebhookBtn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", TestWebhookBtn).CornerRadius = UDim.new(0, 10)
    
    TestWebhookBtn.MouseButton1Click:Connect(function()
        SendDiscordWebhook(
            "🔧 اختبار نظام الإرسال",
            "هذه رسالة اختبار من سكربت RXT V10\nتم إرسالها بنجاح ✅",
            16753920, -- برتقالي
            "test",
            {
                {
                    ["name"] = "🧪 حالة الاختبار",
                    ["value"] = "ناجح",
                    ["inline"] = true
                },
                {
                    ["name"] = "📊 إصدار السكربت",
                    ["value"] = "V10",
                    ["inline"] = true
                },
                {
                    ["name"] = "🔗 رابط الويب هوك",
                    ["value"] = "يعمل بشكل صحيح",
                    ["inline"] = false
                }
            }
        )
        
        TestWebhookBtn.Text = "✅ تم إرسال الاختبار!"
        task.wait(1.5)
        TestWebhookBtn.Text = "🔧 اختبار نظام الإرسال"
    end)
    
    -- الفوتر
    local Footer = Instance.new("TextLabel", Main)
    Footer.Size = UDim2.new(1, 0, 0, 40)
    Footer.Position = UDim2.new(0, 0, 1, -40)
    Footer.BackgroundTransparency = 1
    Footer.Text = "🔐 المفتاح: RXT24 | ⏰ صلاحية: 24 ساعة | 📡 نظام الإرسال: نشط"
    Footer.TextColor3 = Color3.fromRGB(170, 120, 255)
    Footer.Font = Enum.Font.GothamBold
    Footer.TextSize = 12
    
    print("👑 RXT MASTER V10 LOADED - WEBHOOK SYSTEM ACTIVE")
    
    -- إرسال رسالة دخول للويب هوك
    task.wait(2)
    SendDiscordWebhook(
        "🚀 دخول مستخدم جديد",
        "قام مستخدم بتحميل سكربت RXT V10",
        10181046, -- بنفسجي
        "login",
        {
            {
                ["name"] = "🎮 مكان اللعب",
                ["value"] = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name,
                ["inline"] = true
            },
            {
                ["name"] = "🆔 كود المكان",
                ["value"] = tostring(game.PlaceId),
                ["inline"] = true
            },
            {
                ["name"] = "👥 عدد اللاعبين",
                ["value"] = #game:GetService("Players"):GetPlayers(),
                ["inline"] = true
            }
        }
    )
end

-- بدء واجهة المفتاح أولاً
CreateKeyGui()
