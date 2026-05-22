--[[ 
    سكربت ديسنك - قائمة واضحة وجميلة
    زر تشغيل/اطفاء كبير + خلفية مريحة
]]

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local rootPart = character:WaitForChild("HumanoidRootPart")

-- حذف أي قائمة قديمة لو موجودة
local oldGui = game:GetService("CoreGui"):FindFirstChild("DesyncPanelV2")
if oldGui then oldGui:Destroy() end

-- ========== إنشاء القائمة من الصفر ==========
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DesyncPanelV2"
screenGui.Parent = game:GetService("CoreGui")
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- الإطار الرئيسي (خلفية زرقاء داكنة مريحة)
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 350, 0, 180)
mainFrame.Position = UDim2.new(0.5, -175, 0.3, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 25, 45)
mainFrame.BackgroundTransparency = 0.1
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

-- زوايا دائرية كبيرة
local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 20)
mainCorner.Parent = mainFrame

-- حدود خارجية زرقاء (stroke)
local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(80, 150, 255)
stroke.Thickness = 2
stroke.Transparency = 0.5
stroke.Parent = mainFrame

-- تدرج خلفية جميل
local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 30, 55)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 20, 40))
})
gradient.Parent = mainFrame

-- عنوان كبير
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 50)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundTransparency = 1
title.Text = "⚡ DESYNC CONTROLLER ⚡"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.Parent = mainFrame

-- خط فاصل جميل
local line = Instance.new("Frame")
line.Size = UDim2.new(0.85, 0, 0, 2)
line.Position = UDim2.new(0.075, 0, 0, 52)
line.BackgroundColor3 = Color3.fromRGB(80, 150, 255)
line.BackgroundTransparency = 0.3
line.Parent = mainFrame

-- نص الحالة (كبير وواضح)
local statusText = Instance.new("TextLabel")
statusText.Size = UDim2.new(0.8, 0, 0, 40)
statusText.Position = UDim2.new(0.1, 0, 0.4, 0)
statusText.BackgroundTransparency = 1
statusText.Text = "🔴 DESYNC: OFF"
statusText.TextColor3 = Color3.fromRGB(255, 100, 100)
statusText.Font = Enum.Font.GothamBold
statusText.TextSize = 18
statusText.Parent = mainFrame

-- ========== الزر الرئيسي (كبير وواضح) ==========
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0.7, 0, 0, 55)
toggleButton.Position = UDim2.new(0.15, 0, 0.68, 0)
toggleButton.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
toggleButton.Text = "🔘 تشغيل الديسنك"
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.Font = Enum.Font.GothamBold
toggleButton.TextSize = 18
toggleButton.Parent = mainFrame

-- زوايا الزر
local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 15)
btnCorner.Parent = toggleButton

-- ظل للزر
local btnShadow = Instance.new("UIShadow")
btnShadow.Parent = toggleButton

-- تأثير ضوء على الزر عند المرور
toggleButton.MouseEnter:Connect(function()
    toggleButton.BackgroundColor3 = Color3.fromRGB(250, 60, 60)
end)
toggleButton.MouseLeave:Connect(function()
    if desyncActive then
        toggleButton.BackgroundColor3 = Color3.fromRGB(50, 180, 50)
    else
        toggleButton.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
    end
end)

-- ========== أزرار التحكم الجانبية ==========

-- زر الإغلاق (X)
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 35, 0, 35)
closeBtn.Position = UDim2.new(1, -45, 0, 10)
closeBtn.BackgroundTransparency = 1
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 22
closeBtn.Parent = mainFrame

closeBtn.MouseEnter:Connect(function()
    closeBtn.TextColor3 = Color3.fromRGB(255, 150, 150)
end)
closeBtn.MouseLeave:Connect(function()
    closeBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
end)

closeBtn.MouseButton1Click:Connect(function()
    screenGui.Enabled = not screenGui.Enabled
end)

-- زر تصغير (━)
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 35, 0, 35)
minimizeBtn.Position = UDim2.new(1, -85, 0, 10)
minimizeBtn.BackgroundTransparency = 1
minimizeBtn.Text = "━"
minimizeBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextSize = 24
minimizeBtn.Parent = mainFrame

local minimized = false
local originalSize = mainFrame.Size
local originalY = mainFrame.Position

minimizeBtn.MouseEnter:Connect(function()
    minimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
end)
minimizeBtn.MouseLeave:Connect(function()
    minimizeBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
end)

minimizeBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        mainFrame:TweenSize(UDim2.new(0, 350, 0, 60), "Out", "Quad", 0.3)
        minimizeBtn.Text = "☐"
        statusText.Visible = false
        toggleButton.Visible = false
        line.Visible = false
    else
        mainFrame:TweenSize(originalSize, "Out", "Quad", 0.3)
        minimizeBtn.Text = "━"
        wait(0.2)
        statusText.Visible = true
        toggleButton.Visible = true
        line.Visible = true
    end
end)

-- ========== كود الديسنك ==========
local desyncActive = false
local bodyVelocity = nil
local bodyGyro = nil
local originalCF = nil

local function freezeBody()
    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.Parent = rootPart
    
    bodyGyro = Instance.new("BodyGyro")
    bodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    bodyGyro.CFrame = rootPart.CFrame
    bodyGyro.Parent = rootPart
end

local function unfreezeBody()
    if bodyVelocity then bodyVelocity:Destroy() bodyVelocity = nil end
    if bodyGyro then bodyGyro:Destroy() bodyGyro = nil end
end

local function startDesync()
    desyncActive = true
    
    statusText.Text = "🟢 DESYNC: ON"
    statusText.TextColor3 = Color3.fromRGB(100, 255, 100)
    toggleButton.Text = "⭕ إطفاء الديسنك"
    toggleButton.BackgroundColor3 = Color3.fromRGB(50, 180, 50)
    
    freezeBody()
    
    spawn(function()
        while desyncActive do
            pcall(function()
                -- تغيير ملكية الشبكة
                rootPart:SetNetworkOwner(nil)
                wait(0.03)
                rootPart:SetNetworkOwner(player)
                wait(0.03)
                rootPart:SetNetworkOwner(nil)
                wait(0.03)
                
                -- تحريك الجسم بعنف
                if rootPart then
                    rootPart.Velocity = Vector3.new(
                        math.random(-100, 100),
                        math.random(-50, 50),
                        math.random(-100, 100)
                    )
                end
            end)
            wait(0.1)
        end
    end)
    
    print("✅ الديسنك مفعل")
end

local function stopDesync()
    desyncActive = false
    
    statusText.Text = "🔴 DESYNC: OFF"
    statusText.TextColor3 = Color3.fromRGB(255, 100, 100)
    toggleButton.Text = "🔘 تشغيل الديسنك"
    toggleButton.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
    
    unfreezeBody()
    
    pcall(function()
        rootPart:SetNetworkOwner(nil)
        wait(0.1)
        rootPart:SetNetworkOwner(player)
        rootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        rootPart.Velocity = Vector3.new(0, 0, 0)
    end)
    
    print("✅ الديسنك متوقف")
end

-- ضغط الزر
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
    
    if desyncActive then
        stopDesync()
        wait(0.2)
        startDesync()
    end
end)

-- ========== تأثير ظهور القائمة (حركة جميلة) ==========
mainFrame.BackgroundTransparency = 1
mainFrame.Size = UDim2.new(0, 0, 0, 180)
mainFrame.Position = UDim2.new(0.5, 0, 0.3, 0)

game:GetService("TweenService"):Create(
    mainFrame,
    TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
    {Size = UDim2.new(0, 350, 0, 180), Position = UDim2.new(0.5, -175, 0.3, 0)}
):Play()

for i = 0, 1, 0.05 do
    mainFrame.BackgroundTransparency = 0.1 * (1 - i) + 0.9 * i
    wait(0.01)
end

print("══════════════════════════════════════")
print("✅ السكربت شغال | القائمة واضحة وجاهزة")
print("📌 الزر الكبير يشغل ويطفئ الديسنك")
print("⚡ DESYNC MODE - للأغراض التعليمية")
print("══════════════════════════════════════")
