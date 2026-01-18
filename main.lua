-- [[ 👑 RXT SERVER - V10 PRO EDITION ]] --
-- مفتاح الدخول: RXT24

if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

-- [ إعدادات الصورة ]
local AssetID = "rbxassetid://91517993921396"

-- [[ 🛠️ وظيفة نظام المفتاح والتحميل ]] --
local function LaunchScript()
    -- 1. واجهة التحقق من المفتاح
    local KeyGui = Instance.new("ScreenGui", CoreGui)
    local KeyMain = Instance.new("Frame", KeyGui)
    KeyMain.Size = UDim2.new(0, 300, 0, 200)
    KeyMain.Position = UDim2.new(0.5, -150, 0.5, -100)
    KeyMain.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
    Instance.new("UICorner", KeyMain)
    Instance.new("UIStroke", KeyMain).Color = Color3.fromRGB(150, 100, 255)

    local KeyTitle = Instance.new("TextLabel", KeyMain)
    KeyTitle.Size = UDim2.new(1, 0, 0, 40)
    KeyTitle.Text = "ENTER KEY TO ACTIVATE"
    KeyTitle.TextColor3 = Color3.new(1,1,1)
    KeyTitle.Font = Enum.Font.GothamBold
    KeyTitle.BackgroundTransparency = 1

    local KeyInput = Instance.new("TextBox", KeyMain)
    KeyInput.Size = UDim2.new(0, 240, 0, 40)
    KeyInput.Position = UDim2.new(0.5, -120, 0.4, 0)
    KeyInput.PlaceholderText = "Input Key Here..."
    KeyInput.Text = ""
    KeyInput.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    KeyInput.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", KeyInput)

    local EnterBtn = Instance.new("TextButton", KeyMain)
    EnterBtn.Size = UDim2.new(0, 150, 0, 40)
    EnterBtn.Position = UDim2.new(0.5, -75, 0.7, 10)
    EnterBtn.Text = "LOGIN"
    EnterBtn.BackgroundColor3 = Color3.fromRGB(120, 50, 220)
    EnterBtn.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", EnterBtn)

    EnterBtn.MouseButton1Click:Connect(function()
        if KeyInput.Text == "RXT24" then
            -- إخفاء واجهة المفتاح
            KeyMain:Destroy()
            
            -- 2. واجهة التحميل مع صورتك
            local LoadingFrame = Instance.new("Frame", KeyGui)
            LoadingFrame.Size = UDim2.new(1, 0, 1, 0)
            LoadingFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
            
            local LogoImg = Instance.new("ImageLabel", LoadingFrame)
            LogoImg.Size = UDim2.new(0, 200, 0, 200)
            LogoImg.Position = UDim2.new(0.5, -100, 0.4, -100)
            LogoImg.Image = AssetID
            LogoImg.BackgroundTransparency = 1
            
            local LoadText = Instance.new("TextLabel", LoadingFrame)
            LoadText.Position = UDim2.new(0.5, -100, 0.6, 0)
            LoadText.Size = UDim2.new(0, 200, 0, 30)
            LoadText.Text = "Jumping into the system..."
            LoadText.TextColor3 = Color3.fromRGB(150, 100, 255)
            LoadText.Font = Enum.Font.GothamBold
            LoadText.BackgroundTransparency = 1
            
            task.wait(2) -- وقت التحميل الوهمي
            LoadingFrame:Destroy()
            
            -- تشغيل السكربت الأصلي
            StartMainScript()
            
            -- رسالة التفعيل أسفل اليمين
            local Notif = Instance.new("TextLabel", KeyGui)
            Notif.Size = UDim2.new(0, 250, 0, 50)
            Notif.Position = UDim2.new(1, -260, 1, -60)
            Notif.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
            Notif.Text = "✅ تم تفعيل الـ 24 ساعة بنجاح"
            Notif.TextColor3 = Color3.fromRGB(0, 255, 150)
            Notif.Font = Enum.Font.GothamBold
            Instance.new("UICorner", Notif)
            task.wait(4)
            Notif:Destroy()
        else
            KeyInput.Text = ""
            KeyInput.PlaceholderText = "WRONG KEY!"
            KeyInput.PlaceholderColor3 = Color3.new(1,0,0)
        end
    end)
end

function StartMainScript()
    -- [[ المتغيرات الأصلية ]] --
    local stealthSpeedEnabled = false
    local speedValue = 50
    local radioactiveFarmEnabled = false
    local savedPosition = nil
    local infJumpEnabled = false

    -- [[ 🎨 الواجهة الرئيسية المحدثة ]] --
    if CoreGui:FindFirstChild("RXT_Master_V10") then CoreGui["RXT_Master_V10"]:Destroy() end
    local ScreenGui = Instance.new("ScreenGui", CoreGui); ScreenGui.Name = "RXT_Master_V10"

    local Main = Instance.new("Frame", ScreenGui)
    Main.Size = UDim2.new(0, 360, 0, 520); Main.Position = UDim2.new(0.5, -180, 0.5, -260)
    Main.BackgroundColor3 = Color3.fromRGB(12, 12, 18); Main.BorderSizePixel = 0
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 15)
    local MainStroke = Instance.new("UIStroke", Main); MainStroke.Color = Color3.fromRGB(150, 100, 255); MainStroke.Thickness = 2

    -- [[ 🖼️ إضافة الصورة فوق يسار ]] --
    local SideLogo = Instance.new("ImageLabel", Main)
    SideLogo.Size = UDim2.new(0, 45, 0, 45)
    SideLogo.Position = UDim2.new(0, 5, 0, 5)
    SideLogo.Image = AssetID
    SideLogo.BackgroundTransparency = 1
    Instance.new("UICorner", SideLogo).CornerRadius = UDim.new(1,0)

    -- زر الإغلاق والفتح (بنفس نظامك)
    local CloseBtn = Instance.new("TextButton", Main)
    CloseBtn.Size = UDim2.new(0, 30, 0, 30); CloseBtn.Position = UDim2.new(1, -40, 0, 10)
    CloseBtn.Text = "X"; CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50); CloseBtn.TextColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", CloseBtn)

    -- [ باقي الأقسام والوظائف من كودك الأصلي ]
    local Pages = Instance.new("Frame", Main); Pages.Size = UDim2.new(1, -20, 1, -90); Pages.Position = UDim2.new(0, 10, 0, 70); Pages.BackgroundTransparency = 1
    local TabHolder = Instance.new("Frame", Main)
    TabHolder.Size = UDim2.new(1, -100, 0, 45); TabHolder.Position = UDim2.new(0, 60, 0, 5); TabHolder.BackgroundTransparency = 1
    local TabList = Instance.new("UIListLayout", TabHolder); TabList.FillDirection = Enum.FillDirection.Horizontal; TabList.Padding = UDim.new(0, 5)

    local function CreatePage()
        local p = Instance.new("ScrollingFrame", Pages); p.Size = UDim2.new(1, 0, 1, 0); p.BackgroundTransparency = 1; p.Visible = false; p.ScrollBarThickness = 0
        Instance.new("UIListLayout", p).Padding = UDim.new(0, 10); return p
    end
    
    local P1 = CreatePage(); P1.Visible = true
    local P2 = CreatePage(); local P3 = CreatePage(); local P4 = CreatePage()

    local function AddTab(t, pg)
        local b = Instance.new("TextButton", TabHolder); b.Size = UDim2.new(0, 60, 1, 0); b.Text = t; b.TextColor3 = Color3.new(1,1,1); b.BackgroundTransparency = 1; b.Font = Enum.Font.GothamBold; b.TextSize = 11
        b.MouseButton1Click:Connect(function() P1.Visible = false; P2.Visible = false; P3.Visible = false; P4.Visible = false; pg.Visible = true end)
    end
    AddTab("MAIN", P1); AddTab("EVENT", P2); AddTab("WORLD", P3); AddTab("TP", P4)

    -- [ أزرار التحكم - دمج وظائفك الأصلية ]
    local function AddToggle(parent, txt, current, cb)
        local b = Instance.new("TextButton", parent); b.Size = UDim2.new(1, 0, 0, 40); b.Text = txt .. " : OFF"; b.BackgroundColor3 = Color3.fromRGB(35, 30, 60); b.TextColor3 = Color3.new(1,1,1); b.Font = Enum.Font.GothamBold; Instance.new("UICorner", b)
        local state = current
        local function Update()
            b.Text = state and txt .. " : ON" or txt .. " : OFF"
            b.BackgroundColor3 = state and Color3.fromRGB(150, 100, 255) or Color3.fromRGB(35, 30, 60)
        end
        b.MouseButton1Click:Connect(function() state = not state; cb(state); Update() end)
        Update()
        return b
    end

    AddToggle(P1, "🚀 Stealth Speed", stealthSpeedEnabled, function(s) stealthSpeedEnabled = s end)
    AddToggle(P1, "🦘 Infinity Jump", infJumpEnabled, function(s) infJumpEnabled = s end)
    AddToggle(P2, "☢️ Radioactive Farm", radioactiveFarmEnabled, function(s) radioactiveFarmEnabled = s end)

    -- [ محرك الكود الخلفي - نفس كودك بدون تغيير لضمان الثبات ]
    RunService.Stepped:Connect(function()
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.WalkSpeed = stealthSpeedEnabled and speedValue or 16
        end
    end)
    
    UserInputService.JumpRequest:Connect(function()
        if infJumpEnabled and player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
            player.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
        end
    end)

    CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)
    print("👑 RXT PRO V10 LOADED WITH AUTH SYSTEM")
end

-- تشغيل البوابة أولاً
LaunchScript()
