-- [[ 👑 RXT MASTER V10 - GLOBAL ACCESS ONLY ]] --

if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")
local player = Players.LocalPlayer

-- [[ ⚙️ إعدادات التحكم بالمفتاح ]] --
local GlobalKey = "FREE24"   -- المفتاح الموحد للجميع
local DaysActive = 2         -- حط 0 للإيقاف الشامل عند الكل

-- [[ 🎨 واجهة الدخول (Login UI) ]] --
if CoreGui:FindFirstChild("RXT_Login") then CoreGui["RXT_Login"]:Destroy() end
local LoginGui = Instance.new("ScreenGui", CoreGui); LoginGui.Name = "RXT_Login"

local LoginFrame = Instance.new("Frame", LoginGui)
LoginFrame.Size = UDim2.new(0, 300, 0, 180); LoginFrame.Position = UDim2.new(0.5, -150, 0.5, -90)
LoginFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 18); LoginFrame.BorderSizePixel = 0
Instance.new("UICorner", LoginFrame).CornerRadius = UDim.new(0, 15)
local LStroke = Instance.new("UIStroke", LoginFrame); LStroke.Color = Color3.fromRGB(120, 50, 220); LStroke.Thickness = 2

local KInp = Instance.new("TextBox", LoginFrame)
KInp.Size = UDim2.new(0, 240, 0, 40); KInp.Position = UDim2.new(0.5, -120, 0.3, 0)
KInp.PlaceholderText = "ادخل المفتاح (FREE24)..."; KInp.BackgroundColor3 = Color3.fromRGB(20, 20, 30); KInp.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", KInp)

local KLog = Instance.new("TextButton", LoginFrame)
KLog.Size = UDim2.new(0, 140, 0, 40); KLog.Position = UDim2.new(0.5, -70, 0.7, 0)
KLog.Text = "تسجيل دخول"; KLog.BackgroundColor3 = Color3.fromRGB(120, 50, 220); KLog.TextColor3 = Color3.new(1,1,1); KLog.Font = "GothamBold"
Instance.new("UICorner", KLog)

-- [[ 🛠️ محرك السكربت الرئيسي ]] --
local function StartScript()
    local stealthSpeedEnabled = false
    local speedValue = 50
    local noclipEnabled = false
    local instantInteractionEnabled = false
    local infJumpEnabled = false
    local noRagdollEnabled = false
    local radioactiveFarmEnabled = false
    local savedPosition = nil

    -- [1] مانع الطرد (Anti-AFK)
    task.spawn(function()
        local VU = game:GetService("VirtualUser")
        player.Idled:Connect(function() VU:CaptureController(); VU:ClickButton2(Vector2.new()) end)
    end)

    -- [2] محرك السرعة
    RunService.Stepped:Connect(function()
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            local hum = player.Character.Humanoid
            if stealthSpeedEnabled then hum.WalkSpeed = speedValue else hum.WalkSpeed = 16 end
        end
    end)

    -- [3] تجميع الكوينز (Ghost Farm)
    task.spawn(function()
        while task.wait(0.05) do
            if radioactiveFarmEnabled and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local root = player.Character.HumanoidRootPart
                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("TouchTransmitter") then
                        local p = v.Parent
                        if p and (p.Name:lower():find("radioactive") or p.Name:lower():find("coin")) then
                            firetouchinterest(root, p, 0); task.wait(); firetouchinterest(root, p, 1)
                        end
                    end
                end
            end
        end
    end)

    -- [[ واجهة القوائم ]] --
    if CoreGui:FindFirstChild("RXT_Master_V10") then CoreGui["RXT_Master_V10"]:Destroy() end
    local ScreenGui = Instance.new("ScreenGui", CoreGui); ScreenGui.Name = "RXT_Master_V10"
    local Main = Instance.new("Frame", ScreenGui)
    Main.Size = UDim2.new(0, 360, 0, 520); Main.Position = UDim2.new(0.5, -180, 0.5, -260); Main.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 15)
    local MainStroke = Instance.new("UIStroke", Main); MainStroke.Color = Color3.fromRGB(150, 100, 255); MainStroke.Thickness = 2

    local CloseBtn = Instance.new("TextButton", Main)
    CloseBtn.Size = UDim2.new(0, 35, 0, 35); CloseBtn.Position = UDim2.new(0, 10, 0, 10); CloseBtn.Text = "X"; CloseBtn.BackgroundColor3 = Color3.fromRGB(120, 50, 220); CloseBtn.TextColor3 = Color3.new(1, 1, 1); Instance.new("UICorner", CloseBtn)
    
    local OpenBtn = Instance.new("TextButton", ScreenGui)
    OpenBtn.Size = UDim2.new(0, 60, 0, 60); OpenBtn.Position = UDim2.new(0, 15, 0.5, -30); OpenBtn.BackgroundColor3 = Color3.fromRGB(30, 20, 50); OpenBtn.Text = "RXT"; OpenBtn.TextColor3 = Color3.fromRGB(150, 100, 255); OpenBtn.Visible = false; Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(1,0)

    CloseBtn.MouseButton1Click:Connect(function() Main.Visible = false; OpenBtn.Visible = true end)
    OpenBtn.MouseButton1Click:Connect(function() Main.Visible = true; OpenBtn.Visible = false end)

    local Pages = Instance.new("Frame", Main); Pages.Size = UDim2.new(1, -20, 1, -90); Pages.Position = UDim2.new(0, 10, 0, 70); Pages.BackgroundTransparency = 1
    local function CreatePage()
        local p = Instance.new("ScrollingFrame", Pages); p.Size = UDim2.new(1, 0, 1, 0); p.BackgroundTransparency = 1; p.Visible = false; p.ScrollBarThickness = 0
        Instance.new("UIListLayout", p).Padding = UDim.new(0, 10); return p
    end
    local P1 = CreatePage(); local P2 = CreatePage(); P1.Visible = true
    
    local TabHolder = Instance.new("Frame", Main); TabHolder.Size = UDim2.new(1, -60, 0, 45); TabHolder.Position = UDim2.new(0, 50, 0, 5); TabHolder.BackgroundTransparency = 1
    local TabList = Instance.new("UIListLayout", TabHolder); TabList.FillDirection = Enum.FillDirection.Horizontal; TabList.HorizontalAlignment = Enum.HorizontalAlignment.Center
    
    local function AddTab(t, pg)
        local b = Instance.new("TextButton", TabHolder); b.Size = UDim2.new(0, 70, 1, 0); b.Text = t; b.TextColor3 = Color3.new(1,1,1); b.BackgroundTransparency = 1; b.Font = Enum.Font.GothamBold
        b.MouseButton1Click:Connect(function() P1.Visible = false; P2.Visible = false; pg.Visible = true end)
    end
    AddTab("MAIN", P1); AddTab("FARM", P2)

    local function AddToggle(parent, txt, current, cb)
        local b = Instance.new("TextButton", parent); b.Size = UDim2.new(1, 0, 0, 40); b.Text = txt .. " : OFF"; b.BackgroundColor3 = Color3.fromRGB(35, 30, 60); b.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", b)
        local state = current
        local function Update() b.Text = state and txt .. " : ON" or txt .. " : OFF"; b.BackgroundColor3 = state and Color3.fromRGB(0, 180, 100) or Color3.fromRGB(35, 30, 60) end
        b.MouseButton1Click:Connect(function() state = not state; cb(state); Update() end)
        Update()
    end

    AddToggle(P1, "🦘 Infinity Jump", infJumpEnabled, function(s) infJumpEnabled = s end)
    AddToggle(P2, "☢️ Radioactive Farm", radioactiveFarmEnabled, function(s) radioactiveFarmEnabled = s end)

    -- نظام السحب
    local d, ds, sp; Main.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then d = true ds = i.Position sp = Main.Position end end)
    UserInputService.InputChanged:Connect(function(i) if d and i.UserInputType == Enum.UserInputType.MouseMovement then local delta = i.Position - ds Main.Position = UDim2.new(sp.X.Scale, sp.X.Offset + delta.X, sp.Y.Scale, sp.Y.Offset + delta.Y) end end)
    UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then d = false end end)

    print("👑 RXT MASTER V10 - GLOBAL ACCESS ACTIVE")
end

-- [[ التحقق من المفتاح العام ]] --
KLog.MouseButton1Click:Connect(function()
    if KInp.Text == GlobalKey then
        if DaysActive <= 0 then
            KLog.Text = "السكربت معطل حالياً"; task.wait(1.5); KLog.Text = "تسجيل دخول"
        else
            LoginGui:Destroy(); StartScript()
        end
    else
        KLog.Text = "المفتاح خاطئ"; task.wait(1); KLog.Text = "تسجيل دخول"
    end
end)
