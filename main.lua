-- [[ 👑 RXT MASTER V10 - FINAL CLEAN VERSION ]] --

if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local player = Players.LocalPlayer

-- [[ ⚙️ إعدادات التحكم ]] --
local GlobalKey = "FREE24"
local DaysActive = 2 -- حط 0 عشان تقفل السكربت عند الكل

-- [[ 📢 وظيفة الإشعارات ]] --
local function SendNotify(txt)
    local NotifyGui = Instance.new("ScreenGui", CoreGui)
    local Frame = Instance.new("Frame", NotifyGui)
    Frame.Size = UDim2.new(0, 250, 0, 50)
    Frame.Position = UDim2.new(1, -260, 1, -60)
    Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    Instance.new("UICorner", Frame)
    Instance.new("UIStroke", Frame).Color = Color3.fromRGB(150, 100, 255)
    
    local Label = Instance.new("TextLabel", Frame)
    Label.Size = UDim2.new(1, 0, 1, 0)
    Label.Text = txt
    Label.TextColor3 = Color3.new(1, 1, 1)
    Label.BackgroundTransparency = 1
    Label.Font = "GothamBold"
    Label.TextSize = 14
    
    task.wait(4)
    NotifyGui:Destroy()
end

-- [[ 🎨 واجهة الدخول ]] --
if CoreGui:FindFirstChild("RXT_Login") then CoreGui["RXT_Login"]:Destroy() end
local LoginGui = Instance.new("ScreenGui", CoreGui); LoginGui.Name = "RXT_Login"

local LoginFrame = Instance.new("Frame", LoginGui)
LoginFrame.Size = UDim2.new(0, 300, 0, 180); LoginFrame.Position = UDim2.new(0.5, -150, 0.5, -90)
LoginFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 18); LoginFrame.BorderSizePixel = 0
Instance.new("UICorner", LoginFrame)
Instance.new("UIStroke", LoginFrame).Color = Color3.fromRGB(120, 50, 220)

local KInp = Instance.new("TextBox", LoginFrame)
KInp.Size = UDim2.new(0, 240, 0, 40); KInp.Position = UDim2.new(0.5, -120, 0.3, 0)
KInp.PlaceholderText = "Enter Key..."; KInp.BackgroundColor3 = Color3.fromRGB(20, 20, 30); KInp.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", KInp)

local KLog = Instance.new("TextButton", LoginFrame)
KLog.Size = UDim2.new(0, 140, 0, 40); KLog.Position = UDim2.new(0.5, -70, 0.7, 0)
KLog.Text = "LOGIN"; KLog.BackgroundColor3 = Color3.fromRGB(120, 50, 220); KLog.TextColor3 = Color3.new(1,1,1); KLog.Font = "GothamBold"
Instance.new("UICorner", KLog)

-- [[ 🛠️ السكربت الرئيسي بعد التفعيل ]] --
local function StartScript()
    local radioactiveFarmEnabled = false
    local infJumpEnabled = false
    local speedValue = 50
    local stealthSpeedEnabled = false

    -- تذكير الديسكورد كل 5 دقايق
    task.spawn(function()
        while true do
            task.wait(300)
            SendNotify("لا تنسى ترسل ل اخوياك الدس RXT 🚀")
        end
    end)

    if CoreGui:FindFirstChild("RXT_Main") then CoreGui["RXT_Main"]:Destroy() end
    local MainGui = Instance.new("ScreenGui", CoreGui); MainGui.Name = "RXT_Main"
    
    local Main = Instance.new("Frame", MainGui)
    Main.Size = UDim2.new(0, 350, 0, 450); Main.Position = UDim2.new(0.5, -175, 0.5, -225)
    Main.BackgroundColor3 = Color3.fromRGB(10, 10, 15); Instance.new("UICorner", Main)
    Instance.new("UIStroke", Main).Color = Color3.fromRGB(150, 100, 255)

    -- نظام التبويبات (مرتب)
    local Pages = Instance.new("Frame", Main); Pages.Size = UDim2.new(1, -20, 1, -80); Pages.Position = UDim2.new(0, 10, 0, 70); Pages.BackgroundTransparency = 1
    local function CreatePage()
        local p = Instance.new("ScrollingFrame", Pages); p.Size = UDim2.new(1, 0, 1, 0); p.BackgroundTransparency = 1; p.Visible = false; p.ScrollBarThickness = 0
        Instance.new("UIListLayout", p).Padding = UDim.new(0, 8); return p
    end
    local P1 = CreatePage(); local P2 = CreatePage(); P1.Visible = true

    local TabH = Instance.new("Frame", Main); TabH.Size = UDim2.new(1, 0, 0, 40); TabH.Position = UDim2.new(0, 0, 0, 20); TabH.BackgroundTransparency = 1
    local function AddTab(t, pg)
        local b = Instance.new("TextButton", TabH); b.Size = UDim2.new(0.5, 0, 1, 0); b.Text = t; b.TextColor3 = Color3.new(1,1,1); b.BackgroundTransparency = 1; b.Font = "GothamBold"
        b.MouseButton1Click:Connect(function() P1.Visible = false; P2.Visible = false; pg.Visible = true end)
    end
    AddTab("MAIN", P1); AddTab("FARM", P2)

    local function AddToggle(parent, txt, cb)
        local b = Instance.new("TextButton", parent); b.Size = UDim2.new(1, 0, 0, 40); b.Text = txt .. " : OFF"; b.BackgroundColor3 = Color3.fromRGB(25, 25, 35); b.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", b)
        local s = false
        b.MouseButton1Click:Connect(function() s = not s; b.Text = s and txt.." : ON" or txt.." : OFF"; b.BackgroundColor3 = s and Color3.fromRGB(120, 50, 220) or Color3.fromRGB(25, 25, 35); cb(s) end)
    end

    AddToggle(P1, "Infinity Jump", function(s) infJumpEnabled = s end)
    AddToggle(P2, "Radioactive Farm", function(s) radioactiveFarmEnabled = s end)

    -- محرك الفارم والجمب
    UserInputService.JumpRequest:Connect(function() if infJumpEnabled then player.Character.Humanoid:ChangeState("Jumping") end end)
    task.spawn(function()
        while task.wait(0.1) do
            if radioactiveFarmEnabled and player.Character then
                local root = player.Character.HumanoidRootPart
                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("TouchTransmitter") and (v.Parent.Name:lower():find("coin") or v.Parent.Name:lower():find("radioactive")) then
                        firetouchinterest(root, v.Parent, 0); firetouchinterest(root, v.Parent, 1)
                    end
                end
            end
        end
    end)

    -- نظام سحب القائمة
    local d, ds, sp; Main.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then d = true ds = i.Position sp = Main.Position end end)
    UserInputService.InputChanged:Connect(function(i) if d and i.UserInputType == Enum.UserInputType.MouseMovement then local delta = i.Position - ds Main.Position = UDim2.new(sp.X.Scale, sp.X.Offset + delta.X, sp.Y.Scale, sp.Y.Offset + delta.Y) end end)
    UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then d = false end end)
end

-- [[ التحقق من الدخول ]] --
KLog.MouseButton1Click:Connect(function()
    if KInp.Text == GlobalKey then
        if DaysActive > 0 then
            LoginGui:Destroy()
            StartScript()
            task.spawn(function() SendNotify("تم تفعيل الـ 24 ساعة بنجاح ✅") end)
        else
            KLog.Text = "المفتاح معطل"
        end
    else
        KLog.Text = "خطأ!"; task.wait(1); KLog.Text = "LOGIN"
    end
end)
