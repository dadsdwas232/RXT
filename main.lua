--[[ 
    سكربت ديسنك متحرك - تقدر تمشي وتجري والديسنك شغال
    السيرفر يشوفك وهمي وانت تتحرك طبيعي
]]

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local rootPart = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")

-- حذف أي قائمة قديمة
local oldGui = game:GetService("CoreGui"):FindFirstChild("DesyncPanelV3")
if oldGui then oldGui:Destroy() end

-- ========== إنشاء القائمة ==========
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DesyncPanelV3"
screenGui.Parent = game:GetService("CoreGui")
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 350, 0, 170)
mainFrame.Position = UDim2.new(0.5, -175, 0.3, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 25, 45)
mainFrame.BackgroundTransparency = 0.1
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 20)
mainCorner.Parent = mainFrame

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(80, 150, 255)
stroke.Thickness = 2
stroke.Transparency = 0.5
stroke.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 45)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundTransparency = 1
title.Text = "🌀 DESYNC WALK 🌀"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.Parent = mainFrame

local line = Instance.new("Frame")
line.Size = UDim2.new(0.85, 0, 0, 2)
line.Position = UDim2.new(0.075, 0, 0, 48)
line.BackgroundColor3 = Color3.fromRGB(80, 150, 255)
line.BackgroundTransparency = 0.3
line.Parent = mainFrame

local statusText = Instance.new("TextLabel")
statusText.Size = UDim2.new(0.8, 0, 0, 40)
statusText.Position = UDim2.new(0.1, 0, 0.38, 0)
statusText.BackgroundTransparency = 1
statusText.Text = "🔴 DESYNC: OFF"
statusText.TextColor3 = Color3.fromRGB(255, 100, 100)
statusText.Font = Enum.Font.GothamBold
statusText.TextSize = 18
statusText.Parent = mainFrame

-- الزر الرئيسي
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0.7, 0, 0, 50)
toggleButton.Position = UDim2.new(0.15, 0, 0.68, 0)
toggleButton.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
toggleButton.Text = "🔘 تشغيل الديسنك"
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.Font = Enum.Font.GothamBold
toggleButton.TextSize = 18
toggleButton.Parent = mainFrame

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 15)
btnCorner.Parent = toggleButton

-- زر الإغلاق
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 35, 0, 35)
closeBtn.Position = UDim2.new(1, -45, 0, 8)
closeBtn.BackgroundTransparency = 1
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 22
closeBtn.Parent = mainFrame

closeBtn.MouseButton1Click:Connect(function()
    screenGui.Enabled = not screenGui.Enabled
end)

-- زر تصغير
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 35, 0, 35)
minimizeBtn.Position = UDim2.new(1, -85, 0, 8)
minimizeBtn.BackgroundTransparency = 1
minimizeBtn.Text = "━"
minimizeBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextSize = 24
minimizeBtn.Parent = mainFrame

local minimized = false
minimizeBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        mainFrame:TweenSize(UDim2.new(0, 350, 0, 55), "Out", "Quad", 0.3)
        minimizeBtn.Text = "☐"
        statusText.Visible = false
        toggleButton.Visible = false
        line.Visible = false
    else
        mainFrame:TweenSize(UDim2.new(0, 350, 0, 170), "Out", "Quad", 0.3)
        minimizeBtn.Text = "━"
        wait(0.2)
        statusText.Visible = true
        toggleButton.Visible = true
        line.Visible = true
    end
end)

-- ========== كود الديسنك اللي مايجمدك ==========
local desyncActive = false
local fakeRootPart = nil
local networkLoop = nil

-- إنشاء جسم وهمي (يبقى ثابت عند السيرفر)
local function createFakeBody()
    -- نحذف القديم لو موجود
    if fakeRootPart and fakeRootPart.Parent then
        fakeRootPart:Destroy()
    end
    
    -- ننسخ جسمك الحالي
    local fakeCharacter = character:Clone()
    fakeCharacter.Name = "FakeDesync_" .. player.Name
    fakeCharacter.Parent = workspace
    
    -- نخلي الجسم الوهمي شفاف وثابت
    for _, part in ipairs(fakeCharacter:GetDescendants()) do
        if part:IsA("BasePart") then
            part.Transparency = 0.9
            part.Color = Color3.fromRGB(255, 0, 0)
            part.Material = Enum.Material.Neon
            part.CanCollide = false
        elseif part:IsA("Humanoid") then
            part.PlatformStand = true
            part.WalkSpeed = 0
            part.JumpPower = 0
        end
    end
    
    -- نثبت الجسم الوهمي في مكانه الحالي
    fakeCharacter:SetPrimaryPartCFrame(rootPart.CFrame)
    
    -- نقل ملكية الجسم الوهمي للسيرفر فقط
    local fakeRoot = fakeCharacter:FindFirstChild("HumanoidRootPart")
    if fakeRoot then
        fakeRoot:SetNetworkOwner(nil)
    end
    
    return fakeCharacter
end

-- تحديث موقع الجسم الوهمي (يبقى ثابت او يتحرك ببطء عشان الديسنك)
local function updateFakePosition()
    if fakeRootPart and desyncActive then
        -- نبعد الجسم الوهمي عن موقعك الحقيقي
        local offset = Vector3.new(0, 50, 0) -- يبقى فوقك بـ 50 متر
        fakeRootPart.CFrame = rootPart.CFrame + offset
    end
end

local function startDesync()
    desyncActive = true
    
    statusText.Text = "🟢 DESYNC: ON"
    statusText.TextColor3 = Color3.fromRGB(100, 255, 100)
    toggleButton.Text = "⭕ إطفاء الديسنك"
    toggleButton.BackgroundColor3 = Color3.fromRGB(50, 180, 50)
    
    -- إنشاء الجسم الوهمي
    local fakeChar = createFakeBody()
    fakeRootPart = fakeChar:FindFirstChild("HumanoidRootPart")
    
    -- حلقة خفيفة لتحديث موقع الوهمي (ما تأثر على حركتك)
    spawn(function()
        while desyncActive do
            if fakeRootPart and rootPart then
                -- نحرك الوهمي بشكل عشوائي عشان يضيع السيرفر اكثر
                local randomOffset = Vector3.new(
                    math.random(-30, 30),
                    math.random(0, 20),
                    math.random(-30, 30)
                )
                fakeRootPart.CFrame = rootPart.CFrame + randomOffset
            end
            wait(0.2) -- نحدث كل 0.2 ثانية عشان مايعلق
        end
    end)
    
    -- نغير ملكية الشبكة لخفتك (بس بدون تجميد)
    pcall(function()
        rootPart:SetNetworkOwner(player)
    end)
    
    print("✅ الديسنك مفعل - تقدر تتحرك طبيعي والسيرفر يشوفك وهمي")
end

local function stopDesync()
    desyncActive = false
    
    statusText.Text = "🔴 DESYNC: OFF"
    statusText.TextColor3 = Color3.fromRGB(255, 100, 100)
    toggleButton.Text = "🔘 تشغيل الديسنك"
    toggleButton.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
    
    -- حذف الجسم الوهمي
    if fakeRootPart then
        local fakeChar = fakeRootPart.Parent
        if fakeChar then fakeChar:Destroy() end
        fakeRootPart = nil
    end
    
    -- نرجع الملكية طبيعي
    pcall(function()
        rootPart:SetNetworkOwner(nil)
        wait(0.1)
        rootPart:SetNetworkOwner(player)
    end)
    
    print("✅ الديسنك متوقف - رجع التزامن مع السيرفر")
end

-- زر التشغيل
toggleButton.MouseButton1Click:Connect(function()
    if desyncActive then
        stopDesync()
    else
        startDesync()
    end
end)

-- تحديث الشخصية عند الموت
player.CharacterAdded:Connect(function(newChar)
    character = newChar
    rootPart = character:WaitForChild("HumanoidRootPart")
    humanoid = character:WaitForChild("Humanoid")
    
    if desyncActive then
        stopDesync()
        wait(0.3)
        startDesync()
    end
end)

-- تأثير ظهور
mainFrame.BackgroundTransparency = 1
mainFrame.Size = UDim2.new(0, 0, 0, 170)
mainFrame.Position = UDim2.new(0.5, 0, 0.3, 0)

game:GetService("TweenService"):Create(
    mainFrame,
    TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
    {Size = UDim2.new(0, 350, 0, 170), Position = UDim2.new(0.5, -175, 0.3, 0)}
):Play()

for i = 0, 1, 0.05 do
    mainFrame.BackgroundTransparency = 0.1 * (1 - i) + 0.9 * i
    wait(0.01)
end

print("══════════════════════════════════════")
print("✅ السكربت شغال | تقدر تتحرك طبيعي")
print("📌 السيرفر يشوفك في مكان وهمي (احمر شفاف)")
print("⚡ انت تتحرك عادي وهم مايدرون")
print("══════════════════════════════════════")
