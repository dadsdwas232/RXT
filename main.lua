--[[ 
    سكربت ديسنك كامل بقائمة تشغيل/اطفاء
    للاستخدام مع المشغلات الخارجية (Executor)
]]

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local rootPart = character:WaitForChild("HumanoidRootPart")

-- ========== إنشاء القائمة ==========
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DesyncPanel"
screenGui.Parent = game:GetService("CoreGui")
screenGui.ResetOnSpawn = false

-- الإطار الرئيسي
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 150)
mainFrame.Position = UDim2.new(0.5, -150, 0.35, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
mainFrame.BackgroundTransparency = 0.15
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

-- زوايا دائرية
local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 15)
mainCorner.Parent = mainFrame

-- خلفية زجاجية (تأثير blur)
local blur = Instance.new("BlurEffect")
blur.Size = 0
blur.Parent = game:GetService("Lighting")

-- تدرج لوني
local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 50)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 15, 30))
})
gradient.Parent = mainFrame

-- عنوان القائمة
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 45)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundTransparency = 1
title.Text = "⚡ DESYNC CONTROLLER ⚡"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.Parent = mainFrame

-- خط فاصل
local line = Instance.new("Frame")
line.Size = UDim2.new(0.9, 0, 0, 2)
line.Position = UDim2.new(0.05, 0, 0, 45)
line.BackgroundColor3 = Color3.fromRGB(100, 100, 200)
line.BackgroundTransparency = 0.4
line.Parent = mainFrame

-- حالة الديسنك (نص يعرض الحالة)
local statusText = Instance.new("TextLabel")
statusText.Size = UDim2.new(0.8, 0, 0, 30)
statusText.Position = UDim2.new(0.1, 0, 0.4, 0)
statusText.BackgroundTransparency = 1
statusText.Text = "🔴 DESYNC: OFF"
statusText.TextColor3 = Color3.fromRGB(255, 100, 100)
statusText.Font = Enum.Font.GothamBold
statusText.TextSize = 14
statusText.Parent = mainFrame

-- زر التشغيل/الإطفاء
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0.6, 0, 0, 45)
toggleButton.Position = UDim2.new(0.2, 0, 0.65, 0)
toggleButton.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
toggleButton.Text = "🔘 تشغيل الديسنك"
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.Font = Enum.Font.GothamBold
toggleButton.TextSize = 14
toggleButton.Parent = mainFrame

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 10)
btnCorner.Parent = toggleButton

-- ظل للزر
local btnShadow = Instance.new("UIShadow")
btnShadow.Parent = toggleButton

-- زر الإغلاق (X)
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 8)
closeBtn.BackgroundTransparency = 1
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 18
closeBtn.Parent = mainFrame

closeBtn.MouseButton1Click:Connect(function()
    screenGui.Enabled = not screenGui.Enabled
end)

-- زر تصغير القائمة (-)
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 25, 0, 25)
minimizeBtn.Position = UDim2.new(1, -65, 0, 10)
minimizeBtn.BackgroundTransparency = 1
minimizeBtn.Text = "−"
minimizeBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextSize = 20
minimizeBtn.Parent = mainFrame

local minimized = false
local originalSize = mainFrame.Size

minimizeBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        mainFrame:TweenSize(UDim2.new(0, 300, 0, 50), "Out", "Quad", 0.3)
        minimizeBtn.Text = "+"
        statusText.Visible = false
        toggleButton.Visible = false
        line.Visible = false
    else
        mainFrame:TweenSize(originalSize, "Out", "Quad", 0.3)
        minimizeBtn.Text = "−"
        wait(0.2)
        statusText.Visible = true
        toggleButton.Visible = true
        line.Visible = true
    end
end)

-- ========== كود الديسنك الحقيقي ==========
local desyncActive = false
local bodyVelocity = nil
local bodyGyro = nil
local originalCF = nil
local networkOwnershipLoop = nil

-- دوامات الشبكة (تسبب ديسنك قوي)
local function causeNetworkDesync()
    -- نغير ملكية الشبكة بشكل متكرر
    for i = 1, 5 do
        rootPart:SetNetworkOwner(nil)
        wait(0.02)
        rootPart:SetNetworkOwner(player)
        wait(0.02)
        rootPart:SetNetworkOwner(nil)
        wait(0.02)
    end
end

-- تثبيت الجسم بشكل غريب
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

-- زعزعة الموقع (السيرفر يشوفك بمكان وانت بمكان ثاني)
local function desyncPosition()
    originalCF = rootPart.CFrame
    local fakePos = rootPart.Position + Vector3.new(0, 9999, 0)
    rootPart.CFrame = CFrame.new(fakePos)
    
    -- نرجعه للمكان الاصلي بعد شوي بس السيرفر يضيع
    wait(0.1)
    rootPart.CFrame = originalCF
end

-- حلقة مستمرة للديسنك
local function startDesyncLoop()
    desyncActive = true
    
    -- نغير الحالة في القائمة
    statusText.Text = "🟢 DESYNC: ON"
    statusText.TextColor3 = Color3.fromRGB(100, 255, 100)
    toggleButton.Text = "⭕ إطفاء الديسنك"
    toggleButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
    
    -- نبدأ سكربت الديسنك المتواصل
    spawn(function()
        while desyncActive do
            -- طريقة 1: نغير ملكية الشبكة
            pcall(function()
                rootPart:SetNetworkOwner(nil)
                wait(0.03)
                rootPart:SetNetworkOwner(player)
                wait(0.03)
            end)
            
            -- طريقة 2: نحرك الجسم بشكل سريع
            pcall(function()
                if rootPart then
                    local randomOffset = Vector3.new(
                        math.random(-50, 50),
                        math.random(-10, 10),
                        math.random(-50, 50)
                    )
                    rootPart.Velocity = randomOffset
                end
            end)
            
            wait(0.1)
            
            -- طريقة 3: نوقف الحركة عند السيرفر
            pcall(function()
                if rootPart then
                    rootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                end
            end)
            
            wait(0.05)
        end
    end)
    
    -- تجميد الجسم
    freezeBody()
    
    -- نعمل ديسنك اولي قوي
    causeNetworkDesync()
    desyncPosition()
    
    print("✅ الديسنك مفعل | السيرفر ما يعرف وين انت بالضبط")
end

local function stopDesyncLoop()
    desyncActive = false
    
    -- تحديث القائمة
    statusText.Text = "🔴 DESYNC: OFF"
    statusText.TextColor3 = Color3.fromRGB(255, 100, 100)
    toggleButton.Text = "🔘 تشغيل الديسنك"
    toggleButton.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
    
    -- تنظيف
    unfreezeBody()
    
    -- نرجع الموقع طبيعي
    pcall(function()
        rootPart:SetNetworkOwner(nil)
        wait(0.1)
        rootPart:SetNetworkOwner(player)
        if originalCF then
            rootPart.CFrame = originalCF
        end
        rootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        rootPart.Velocity = Vector3.new(0, 0, 0)
    end)
    
    print("✅ الديسنك متوقف | رجع التزامن مع السيرفر")
end

-- ضغط زر التشغيل/الإطفاء
toggleButton.MouseButton1Click:Connect(function()
    if desyncActive then
        stopDesyncLoop()
    else
        startDesyncLoop()
    end
end)

-- تحديث الشخصية اذا مات اللاعب
player.CharacterAdded:Connect(function(newChar)
    character = newChar
    rootPart = character:WaitForChild("HumanoidRootPart")
    
    if desyncActive then
        stopDesyncLoop()
        wait(0.2)
        startDesyncLoop()
    end
end)

-- تأثير ظهور القائمة
mainFrame.BackgroundTransparency = 1
mainFrame:TweenSize(UDim2.new(0, 0, 0, 150), "Out", "Quad", 0.2)
wait(0.1)
mainFrame:TweenSize(UDim2.new(0, 300, 0, 150), "Out", "Quad", 0.3)
for i = 0, 1, 0.05 do
    mainFrame.BackgroundTransparency = 0.15 * (1 - i) + 0.85 * i
    wait(0.01)
end

print("══════════════════════════════════════")
print("✅ سكربت الديسنك شغال بنجاح!")
print("📌 استخدم الزر لتشغيل/اطفاء الديسنك")
print("⚡ Desync Mode - للأغراض التعليمية فقط")
print("══════════════════════════════════════")
