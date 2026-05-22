--[[ 
    سكربت روبلوكس - قائمة جميلة + زر طفي/اشغل + مؤشر مكانك الحقيقي + ناسخ شخصية ازرق
    يعمل على معظم المشغلات الخارجية
    للاستخدام الشخصي فقط
--]]

-- إنشاء الواجهة الرئيسية
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- إنشاء ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MainGUI"
screenGui.Parent = game:GetService("CoreGui")
screenGui.ResetOnSpawn = false

-- القائمة الرئيسية (Frame)
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 320, 0, 200)
mainFrame.Position = UDim2.new(0.5, -160, 0.3, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
mainFrame.BackgroundTransparency = 0.15
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui

-- زوايا دائرية (UI Corner)
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = mainFrame

-- تدرج لوني للخلفية (UI Gradient)
local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 45)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 35))
})
gradient.Parent = mainFrame

-- ظل (UI Shadow)
local shadow = Instance.new("UIShadow")
shadow.Parent = mainFrame

-- عنوان القائمة
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundTransparency = 1
title.Text = "📡 Location Tracker"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.Parent = mainFrame

-- خط فاصل
local divider = Instance.new("Frame")
divider.Size = UDim2.new(0.9, 0, 0, 2)
divider.Position = UDim2.new(0.05, 0, 0, 42)
divider.BackgroundColor3 = Color3.fromRGB(80, 150, 255)
divider.BackgroundTransparency = 0.5
divider.Parent = mainFrame

-- إحداثيات X
local coordXLabel = Instance.new("TextLabel")
coordXLabel.Size = UDim2.new(0.45, 0, 0, 30)
coordXLabel.Position = UDim2.new(0.05, 0, 0.25, 0)
coordXLabel.BackgroundTransparency = 1
coordXLabel.Text = "📍 X: 0.00"
coordXLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
coordXLabel.Font = Enum.Font.Gotham
coordXLabel.TextSize = 14
coordXLabel.TextXAlignment = Enum.TextXAlignment.Left
coordXLabel.Parent = mainFrame

-- إحداثيات Y
local coordYLabel = Instance.new("TextLabel")
coordYLabel.Size = UDim2.new(0.45, 0, 0, 30)
coordYLabel.Position = UDim2.new(0.05, 0, 0.4, 0)
coordYLabel.BackgroundTransparency = 1
coordYLabel.Text = "📈 Y: 0.00"
coordYLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
coordYLabel.Font = Enum.Font.Gotham
coordYLabel.TextSize = 14
coordYLabel.TextXAlignment = Enum.TextXAlignment.Left
coordYLabel.Parent = mainFrame

-- إحداثيات Z
local coordZLabel = Instance.new("TextLabel")
coordZLabel.Size = UDim2.new(0.45, 0, 0, 30)
coordZLabel.Position = UDim2.new(0.05, 0, 0.55, 0)
coordZLabel.BackgroundTransparency = 1
coordZLabel.Text = "🧭 Z: 0.00"
coordZLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
coordZLabel.Font = Enum.Font.Gotham
coordZLabel.TextSize = 14
coordZLabel.TextXAlignment = Enum.TextXAlignment.Left
coordZLabel.Parent = mainFrame

-- زر تشغيل/إطفاء (Switch)
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0.4, 0, 0, 36)
toggleButton.Position = UDim2.new(0.55, 0, 0.7, 0)
toggleButton.BackgroundColor3 = Color3.fromRGB(80, 150, 255)
toggleButton.Text = "إيقاف"
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.Font = Enum.Font.GothamBold
toggleButton.TextSize = 14
toggleButton.Parent = mainFrame

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 8)
toggleCorner.Parent = toggleButton

-- حالة الزر
local isActive = true

-- إنشاء الشخصية الناسخة (الازرق)
local cloneModel = nil
local function createClone()
    if cloneModel then cloneModel:Destroy() end
    
    -- نسخ الشخصية الحالية
    cloneModel = character:Clone()
    cloneModel.Name = "BlueClone_" .. player.Name
    cloneModel.Parent = workspace
    
    -- جعل جميع الأجزاء شفافة وزرقاء
    for _, part in ipairs(cloneModel:GetDescendants()) do
        if part:IsA("BasePart") then
            part.Material = Enum.Material.Neon
            part.Color = Color3.fromRGB(0, 100, 255)
            part.Transparency = 0.4
            part.CanCollide = false
        elseif part:IsA("Decal") or part:IsA("Texture") then
            part.Transparency = 1
        end
    end
    
    -- إزالة التحكم عن الناسخة
    local cloneHumanoid = cloneModel:FindFirstChild("Humanoid")
    if cloneHumanoid then
        cloneHumanoid.PlatformStand = true
        cloneHumanoid.WalkSpeed = 0
        cloneHumanoid.JumpPower = 0
    end
    
    return cloneModel
end

-- تحديث موقع الناسخة
local function updateClonePosition()
    if cloneModel and isActive then
        cloneModel:SetPrimaryPartCFrame(character:GetPrimaryPartCFrame())
    end
end

-- تحديث الإحداثيات في القائمة
local function updateCoordinates()
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if rootPart then
        local pos = rootPart.Position
        coordXLabel.Text = string.format("📍 X: %.2f", pos.X)
        coordYLabel.Text = string.format("📈 Y: %.2f", pos.Y)
        coordZLabel.Text = string.format("🧭 Z: %.2f", pos.Z)
    end
end

-- زر الإغلاق (X الصغير)
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -35, 0, 5)
closeButton.BackgroundTransparency = 1
closeButton.Text = "✕"
closeButton.TextColor3 = Color3.fromRGB(255, 100, 100)
closeButton.Font = Enum.Font.GothamBold
closeButton.TextSize = 18
closeButton.Parent = mainFrame

closeButton.MouseButton1Click:Connect(function()
    screenGui.Enabled = not screenGui.Enabled
end)

-- زر الإظهار/الإخفاء (للشخصية الناسخة والمتابعة)
local isCloneVisible = true
local cloneToggleButton = Instance.new("TextButton")
cloneToggleButton.Size = UDim2.new(0.35, 0, 0, 36)
cloneToggleButton.Position = UDim2.new(0.1, 0, 0.7, 0)
cloneToggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
cloneToggleButton.Text = "إخفاء الناسخ"
cloneToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
cloneToggleButton.Font = Enum.Font.GothamBold
cloneToggleButton.TextSize = 12
cloneToggleButton.Parent = mainFrame

local cloneToggleCorner = Instance.new("UICorner")
cloneToggleCorner.CornerRadius = UDim.new(0, 8)
cloneToggleCorner.Parent = cloneToggleButton

cloneToggleButton.MouseButton1Click:Connect(function()
    isCloneVisible = not isCloneVisible
    if cloneModel then
        cloneModel.Visible = isCloneVisible
    end
    cloneToggleButton.Text = isCloneVisible and "إخفاء الناسخ" or "إظهار الناسخ"
end)

-- وظيفة تشغيل النظام
local function activate()
    isActive = true
    toggleButton.Text = "إيقاف"
    toggleButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    createClone()
end

-- وظيفة إيقاف النظام
local function deactivate()
    isActive = false
    toggleButton.Text = "تشغيل"
    toggleButton.BackgroundColor3 = Color3.fromRGB(80, 150, 255)
    if cloneModel then
        cloneModel:Destroy()
        cloneModel = nil
    end
end

-- ضغط زر التشغيل/الإطفاء
toggleButton.MouseButton1Click:Connect(function()
    if isActive then
        deactivate()
    else
        activate()
    end
end)

-- تحديث المواقع كل إطار
game:GetService("RunService").RenderStepped:Connect(function()
    if isActive then
        updateCoordinates()
        updateClonePosition()
    end
end)

-- عند تغيير الشخصية (إذا مات اللاعب)
player.CharacterAdded:Connect(function(newChar)
    character = newChar
    humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    if isActive then
        createClone()
    end
end)

-- بدء التشغيل تلقائياً
activate()

-- تأثير ظهور متحرك للقائمة
mainFrame.BackgroundTransparency = 1
mainFrame:TweenSize(UDim2.new(0, 0, 0, 200), "Out", "Quad", 0.3)
wait(0.2)
mainFrame:TweenSize(UDim2.new(0, 320, 0, 200), "Out", "Quad", 0.3)
for i = 0, 1, 0.05 do
    mainFrame.BackgroundTransparency = 0.15 * (1 - i) + 0.85 * i
    wait(0.01)
end

print("✅ السكربت شغال! | القائمة جاهزة | المطور: @YourName")
