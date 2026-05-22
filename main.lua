--[[
    كود ديسنك - زر واحد فقط
    قائمة بسيطة مع زر لتشغيل وإيقاف عدم التزامن
]]

-- إنشاء الواجهة الرئيسية
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SimpleDesyncGUI"
screenGui.Parent = game:GetService("CoreGui")
screenGui.ResetOnSpawn = false

-- الإطار (القائمة البسيطة)
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 220, 0, 100)
frame.Position = UDim2.new(0.5, -110, 0.8, 0)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
frame.BackgroundTransparency = 0.15
frame.BorderSizePixel = 0
frame.Parent = screenGui

-- زوايا دائرية
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = frame

-- عنوان
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 35)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundTransparency = 1
title.Text = "⚡ Desync Control"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.Parent = frame

-- حالة التشغيل
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, 0, 0, 25)
statusLabel.Position = UDim2.new(0, 0, 0.4, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "🔴 غير مفعل"
statusLabel.TextColor3 = Color3.fromRGB(255, 120, 120)
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 12
statusLabel.Parent = frame

-- الزر الرئيسي
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0.8, 0, 0, 35)
toggleButton.Position = UDim2.new(0.1, 0, 0.65, 0)
toggleButton.BackgroundColor3 = Color3.fromRGB(220, 60, 60)
toggleButton.Text = "▶️ تشغيل"
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.Font = Enum.Font.GothamBold
toggleButton.TextSize = 14
toggleButton.Parent = frame

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 8)
btnCorner.Parent = toggleButton

-- متغير الحالة
local isDesyncOn = false

-- وظيفة تفعيل الديسنك (عدم التزامن)
local function enableDesync()
    setfflag("WorldStepMax", "-99999999999999")
    wait(0.05)
    setfflag("WorldStepMax", "-1")
    statusLabel.Text = "🟢 مفعل (أنت تتحرك، هم يرونك متجمد)"
    statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
    toggleButton.Text = "⏹️ إيقاف"
    toggleButton.BackgroundColor3 = Color3.fromRGB(60, 180, 60)
    print("[Desync] تم التفعيل - عدم تزامن نشط")
end

-- وظيفة إيقاف الديسنك
local function disableDesync()
    setfflag("WorldStepMax", "0.03")
    statusLabel.Text = "🔴 غير مفعل"
    statusLabel.TextColor3 = Color3.fromRGB(255, 120, 120)
    toggleButton.Text = "▶️ تشغيل"
    toggleButton.BackgroundColor3 = Color3.fromRGB(220, 60, 60)
    print("[Desync] تم الإيقاف - عودة التزامن")
end

-- تبديل الحالة عند الضغط على الزر
toggleButton.MouseButton1Click:Connect(function()
    if isDesyncOn then
        disableDesync()
    else
        enableDesync()
    end
    isDesyncOn = not isDesyncOn
end)

-- تأثير ظهور القائمة
frame.BackgroundTransparency = 1
for i = 0, 1, 0.05 do
    frame.BackgroundTransparency = 0.15 * (1 - i) + 0.85 * i
    wait(0.01)
end

print("✅ السكربت شغال | زر واحد للديسنك | القائمة بسيطة")
