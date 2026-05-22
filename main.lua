--[[
    سكربت ديسنك متكامل 2026
    يجمع بين تقنيات: FastFlag Manipulation + Network Ownership Exploitation + Lag Switching
    مع واجهة مستخدم احترافية للتحكم الكامل
]]

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local rootPart = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")

-- حذف أي واجهة قديمة
local oldGui = game:GetService("CoreGui"):FindFirstChild("UltimateDesyncPanel")
if oldGui then oldGui:Destroy() end

-- ================ الواجهة الرسومية الرئيسية ================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "UltimateDesyncPanel"
screenGui.Parent = game:GetService("CoreGui")
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 380, 0, 250)
mainFrame.Position = UDim2.new(0.5, -190, 0.25, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
mainFrame.BackgroundTransparency = 0.08
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 16)
mainCorner.Parent = mainFrame

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(100, 100, 255)
stroke.Thickness = 1.5
stroke.Transparency = 0.6
stroke.Parent = mainFrame

local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 25, 45)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 15, 32))
})
gradient.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 45)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundTransparency = 1
title.Text = "🎛️ ULTIMATE DESYNC CONTROLLER"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 17
title.Parent = mainFrame

local line = Instance.new("Frame")
line.Size = UDim2.new(0.9, 0, 0, 1.5)
line.Position = UDim2.new(0.05, 0, 0, 48)
line.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
line.BackgroundTransparency = 0.4
line.Parent = mainFrame

-- حالة الديسنك
local statusText = Instance.new("TextLabel")
statusText.Size = UDim2.new(0.9, 0, 0, 35)
statusText.Position = UDim2.new(0.05, 0, 0.22, 0)
statusText.BackgroundTransparency = 1
statusText.Text = "🔴 DESYNC: OFF"
statusText.TextColor3 = Color3.fromRGB(255, 100, 100)
statusText.Font = Enum.Font.GothamBold
statusText.TextSize = 16
statusText.Parent = mainFrame

-- معلومات إضافية (البينغ - زمن الاستجابة)
local pingText = Instance.new("TextLabel")
pingText.Size = UDim2.new(0.45, 0, 0, 25)
pingText.Position = UDim2.new(0.05, 0, 0.38, 0)
pingText.BackgroundTransparency = 1
pingText.Text = "📡 Ping: -- ms"
pingText.TextColor3 = Color3.fromRGB(180, 180, 200)
pingText.Font = Enum.Font.Gotham
pingText.TextSize = 12
pingText.TextXAlignment = Enum.TextXAlignment.Left
pingText.Parent = mainFrame

-- معلومات إضافية (طريقة الديسنك النشطة)
local methodText = Instance.new("TextLabel")
methodText.Size = UDim2.new(0.5, 0, 0, 25)
methodText.Position = UDim2.new(0.45, 0, 0.38, 0)
methodText.BackgroundTransparency = 1
methodText.Text = "⚙️ Method: None"
methodText.TextColor3 = Color3.fromRGB(180, 180, 200)
methodText.Font = Enum.Font.Gotham
methodText.TextSize = 12
methodText.TextXAlignment = Enum.TextXAlignment.Left
methodText.Parent = mainFrame

-- ================ أزرار اختيار طريقة الديسنك ================

-- زر الطريقة الأولى: FastFlag (علامات التطوير السريع)
local fflagButton = Instance.new("TextButton")
fflagButton.Size = UDim2.new(0.28, 0, 0, 35)
fflagButton.Position = UDim2.new(0.05, 0, 0.55, 0)
fflagButton.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
fflagButton.Text = "🧠 FFlag Mode"
fflagButton.TextColor3 = Color3.fromRGB(255, 255, 255)
fflagButton.Font = Enum.Font.GothamBold
fflagButton.TextSize = 12
fflagButton.Parent = mainFrame

local fflagCorner = Instance.new("UICorner")
fflagCorner.CornerRadius = UDim.new(0, 8)
fflagCorner.Parent = fflagButton

-- زر الطريقة الثانية: Network (ملكية الشبكة)
local networkButton = Instance.new("TextButton")
networkButton.Size = UDim2.new(0.28, 0, 0, 35)
networkButton.Position = UDim2.new(0.36, 0, 0.55, 0)
networkButton.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
networkButton.Text = "🌐 Net Mode"
networkButton.TextColor3 = Color3.fromRGB(255, 255, 255)
networkButton.Font = Enum.Font.GothamBold
networkButton.TextSize = 12
networkButton.Parent = mainFrame

local networkCorner = Instance.new("UICorner")
networkCorner.CornerRadius = UDim.new(0, 8)
networkCorner.Parent = networkButton

-- زر الطريقة الثالثة: RakNet (التأخير المتعمد)
local raknetButton = Instance.new("TextButton")
raknetButton.Size = UDim2.new(0.28, 0, 0, 35)
raknetButton.Position = UDim2.new(0.67, 0, 0.55, 0)
raknetButton.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
raknetButton.Text = "⏱️ RakNet Mode"
raknetButton.TextColor3 = Color3.fromRGB(255, 255, 255)
raknetButton.Font = Enum.Font.GothamBold
raknetButton.TextSize = 12
raknetButton.Parent = mainFrame

local raknetCorner = Instance.new("UICorner")
raknetCorner.CornerRadius = UDim.new(0, 8)
raknetCorner.Parent = raknetButton

-- زر تشغيل/إيقاف الديسنك الرئيسي
local mainToggleButton = Instance.new("TextButton")
mainToggleButton.Size = UDim2.new(0.9, 0, 0, 45)
mainToggleButton.Position = UDim2.new(0.05, 0, 0.75, 0)
mainToggleButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
mainToggleButton.Text = "▶️ تشغيل الديسنك"
mainToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
mainToggleButton.Font = Enum.Font.GothamBold
mainToggleButton.TextSize = 16
mainToggleButton.Parent = mainFrame

local mainCornerBtn = Instance.new("UICorner")
mainCornerBtn.CornerRadius = UDim.new(0, 10)
mainCornerBtn.Parent = mainToggleButton

-- أزرار التحكم الجانبية
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 32, 0, 32)
closeBtn.Position = UDim2.new(1, -42, 0, 8)
closeBtn.BackgroundTransparency = 1
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 20
closeBtn.Parent = mainFrame

local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 32, 0, 32)
minimizeBtn.Position = UDim2.new(1, -80, 0, 8)
minimizeBtn.BackgroundTransparency = 1
minimizeBtn.Text = "━"
minimizeBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextSize = 22
minimizeBtn.Parent = mainFrame

-- ================ المتغيرات الأساسية ================
local desyncActive = false
local currentMethod = "None"  -- FFlag / Network / RakNet
local selectedMethod = "FFlag"  -- الطريقة المختارة افتراضياً

-- متغيرات FastFlag
local originalWorldStepMax = nil
local worldStepChanged = false

-- متغيرات Network
local networkLoop = nil
local bodyVelocity = nil

-- متغيرات RakNet
local raknetLoop = nil

-- تحديث البينغ
local function updatePing()
    local stats = game:GetService("Stats"):FindFirstChild("Network")
    if stats and stats:FindFirstChild("Ping") then
        local ping = math.floor(stats.Ping.Value)
        pingText.Text = string.format("📡 Ping: %d ms", ping)
        if ping > 150 then
            pingText.TextColor3 = Color3.fromRGB(255, 100, 100)
        elseif ping > 80 then
            pingText.TextColor3 = Color3.fromRGB(255, 200, 100)
        else
            pingText.TextColor3 = Color3.fromRGB(100, 255, 100)
        end
    end
end

-- تحديث البينغ بشكل دوري
spawn(function()
    while wait(1) do
        updatePing()
    end
end)

-- ================ 1. طريقة FFlag Desync ================
-- تعتمد على تغيير إعدادات محرك اللعبة الأساسية لإرباك حسابات الفيزياء والوقت
local function startFFlagDesync()
    -- حفظ القيمة الأصلية إن لم تكن محفوظة
    if originalWorldStepMax == nil then
        originalWorldStepMax = getfflag("WorldStepMax")
    end
    
    -- تغيير WorldStepMax لقيمة سالبة كبيرة لتعطيل حسابات الفيزياء
    setfflag("WorldStepMax", "-99999999999999")
    wait(0.05)
    setfflag("WorldStepMax", "-1")
    
    -- استخدام NextGenReplicator المتقدم لإرباك نظام النسخ المتماثل
    setfflag("NextGenReplicatorEnabledWrite4", "True")
    wait(0.04)
    setfflag("NextGenReplicatorEnabledWrite4", "False")
    
    worldStepChanged = true
end

local function stopFFlagDesync()
    if originalWorldStepMax then
        setfflag("WorldStepMax", originalWorldStepMax)
    end
    worldStepChanged = false
end

-- ================ 2. طريقة Network Desync ================
-- تستغل ميزة "ملكية الشبكة" لتضليل السيرفر حول موقعك الحقيقي
local function startNetworkDesync()
    -- خلق جسم وهمي يبقى ثابتاً في مكانه لإرباك اللاعبين الآخرين
    local fakeChar = character:Clone()
    fakeChar.Name = "FakeDesync_" .. player.Name
    fakeChar.Parent = workspace
    
    for _, part in ipairs(fakeChar:GetDescendants()) do
        if part:IsA("BasePart") then
            part.Transparency = 0.9
            part.Color = Color3.fromRGB(255, 0, 255)
            part.Material = Enum.Material.Neon
            part.CanCollide = false
        elseif part:IsA("Humanoid") then
            part.PlatformStand = true
            part.WalkSpeed = 0
        end
    end
    
    local fakeRoot = fakeChar:FindFirstChild("HumanoidRootPart")
    if fakeRoot then
        fakeRoot:SetNetworkOwner(nil)  -- إعطاء ملكية الجسم الوهمي للسيرفر
    end
    
    -- حلقة مستمرة لتعطيل ملكية الشبكة وإعادة تعيينها
    networkLoop = game:GetService("RunService").RenderStepped:Connect(function()
        if desyncActive and currentMethod == "Network" then
            pcall(function()
                rootPart:SetNetworkOwner(nil)
                wait(0.02)
                rootPart:SetNetworkOwner(player)
                wait(0.02)
                -- تحديث موقع الجسم الوهمي بعيداً عن موقعك الحقيقي
                if fakeRoot then
                    fakeRoot.CFrame = rootPart.CFrame + Vector3.new(0, 50, 0)
                end
            end)
        end
    end)
end

local function stopNetworkDesync()
    if networkLoop then
        networkLoop:Disconnect()
        networkLoop = nil
    end
    -- تنظيف الجسم الوهمي
    local fakeChar = workspace:FindFirstChild("FakeDesync_" .. player.Name)
    if fakeChar then fakeChar:Destroy() end
    pcall(function()
        rootPart:SetNetworkOwner(nil)
        wait(0.1)
        rootPart:SetNetworkOwner(player)
    end)
end

-- ================ 3. طريقة RakNet Desync ================
-- تعتمد على مقاطعة وإعادة حزم البيانات الشبكية (Lag Switch)
local function startRakNetDesync()
    raknetLoop = game:GetService("RunService").Heartbeat:Connect(function()
        if desyncActive and currentMethod == "RakNet" then
            -- خلق تأخيرات متقطعة في الحزمة الشبكية
            pcall(function()
                -- إرسال كميات كبيرة من البيانات مؤقتاً لإرباك المعالجة
                for i = 1, 5 do
                    local remote = Instance.new("RemoteEvent")
                    remote.Name = "DesyncBuffer_" .. i
                    remote.Parent = game:GetService("ReplicatedStorage")
                    remote:FireServer()
                    game:GetService("Debris"):AddItem(remote, 0.1)
                end
                
                -- تغيير سرعة الجسم بشكل مفاجئ
                if rootPart then
                    rootPart.Velocity = Vector3.new(
                        math.random(-200, 200),
                        math.random(-100, 100),
                        math.random(-200, 200)
                    )
                end
                wait(0.05)
                
                -- إعادة تعيين السرعة
                if rootPart then
                    rootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                end
            end)
        end
    end)
end

local function stopRakNetDesync()
    if raknetLoop then
        raknetLoop:Disconnect()
        raknetLoop = nil
    end
    pcall(function()
        if rootPart then
            rootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            rootPart.Velocity = Vector3.new(0, 0, 0)
        end
    end)
end

-- ================ وظائف التشغيل والإيقاف العامة ================
local function startDesync()
    if desyncActive then return end
    desyncActive = true
    
    statusText.Text = "🟢 DESYNC: ON"
    statusText.TextColor3 = Color3.fromRGB(100, 255, 100)
    mainToggleButton.Text = "⏹️ إيقاف الديسنك"
    mainToggleButton.BackgroundColor3 = Color3.fromRGB(50, 180, 50)
    
    if selectedMethod == "FFlag" then
        currentMethod = "FFlag"
        methodText.Text = "⚙️ Method: FastFlag"
        startFFlagDesync()
    elseif selectedMethod == "Network" then
        currentMethod = "Network"
        methodText.Text = "⚙️ Method: Network Ownership"
        startNetworkDesync()
    elseif selectedMethod == "RakNet" then
        currentMethod = "RakNet"
        methodText.Text = "⚙️ Method: RakNet/Lag Switch"
        startRakNetDesync()
    end
    
    print("✅ الديسنك مفعل | الطريقة: " .. currentMethod)
end

local function stopDesync()
    if not desyncActive then return end
    desyncActive = false
    
    statusText.Text = "🔴 DESYNC: OFF"
    statusText.TextColor3 = Color3.fromRGB(255, 100, 100)
    mainToggleButton.Text = "▶️ تشغيل الديسنك"
    mainToggleButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    methodText.Text = "⚙️ Method: None"
    
    if currentMethod == "FFlag" then
        stopFFlagDesync()
    elseif currentMethod == "Network" then
        stopNetworkDesync()
    elseif currentMethod == "RakNet" then
        stopRakNetDesync()
    end
    
    currentMethod = "None"
    print("✅ الديسنك متوقف")
end

-- تبديل الطريقة المختارة
fflagButton.MouseButton1Click:Connect(function()
    selectedMethod = "FFlag"
    fflagButton.BackgroundColor3 = Color3.fromRGB(80, 80, 120)
    networkButton.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
    raknetButton.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
    if desyncActive then
        stopDesync()
        wait(0.2)
        startDesync()
    end
end)

networkButton.MouseButton1Click:Connect(function()
    selectedMethod = "Network"
    networkButton.BackgroundColor3 = Color3.fromRGB(80, 80, 120)
    fflagButton.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
    raknetButton.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
    if desyncActive then
        stopDesync()
        wait(0.2)
        startDesync()
    end
end)

raknetButton.MouseButton1Click:Connect(function()
    selectedMethod = "RakNet"
    raknetButton.BackgroundColor3 = Color3.fromRGB(80, 80, 120)
    fflagButton.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
    networkButton.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
    if desyncActive then
        stopDesync()
        wait(0.2)
        startDesync()
    end
end)

-- الزر الرئيسي
mainToggleButton.MouseButton1Click:Connect(function()
    if desyncActive then
        stopDesync()
    else
        startDesync()
    end
end)

-- أزرار التحكم
local minimized = false
minimizeBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        mainFrame:TweenSize(UDim2.new(0, 380, 0, 55), "Out", "Quad", 0.25)
        minimizeBtn.Text = "□"
        statusText.Visible = false
        pingText.Visible = false
        methodText.Visible = false
        fflagButton.Visible = false
        networkButton.Visible = false
        raknetButton.Visible = false
        mainToggleButton.Visible = false
        line.Visible = false
    else
        mainFrame:TweenSize(UDim2.new(0, 380, 0, 250), "Out", "Quad", 0.25)
        minimizeBtn.Text = "━"
        wait(0.15)
        statusText.Visible = true
        pingText.Visible = true
        methodText.Visible = true
        fflagButton.Visible = true
        networkButton.Visible = true
        raknetButton.Visible = true
        mainToggleButton.Visible = true
        line.Visible = true
    end
end)

closeBtn.MouseButton1Click:Connect(function()
    screenGui.Enabled = not screenGui.Enabled
end)

-- إعادة تهيئة المتغيرات عند موت الشخصية
player.CharacterAdded:Connect(function(newChar)
    character = newChar
    rootPart = character:WaitForChild("HumanoidRootPart")
    humanoid = character:WaitForChild("Humanoid")
    
    if desyncActive then
        local method = currentMethod
        stopDesync()
        wait(0.3)
        if method == "FFlag" then
            selectedMethod = "FFlag"
        elseif method == "Network" then
            selectedMethod = "Network"
        elseif method == "RakNet" then
            selectedMethod = "RakNet"
        end
        startDesync()
    end
end)

-- تأثير ظهور القائمة
mainFrame.BackgroundTransparency = 1
mainFrame.Size = UDim2.new(0, 0, 0, 250)
mainFrame.Position = UDim2.new(0.5, 0, 0.25, 0)

game:GetService("TweenService"):Create(
    mainFrame,
    TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
    {Size = UDim2.new(0, 380, 0, 250), Position = UDim2.new(0.5, -190, 0.25, 0)}
):Play()

for i = 0, 1, 0.04 do
    mainFrame.BackgroundTransparency = 0.08 * (1 - i) + 0.92 * i
    wait(0.01)
end

updatePing()

print("═══════════════════════════════════════════════════════")
print("✅ السكربت شغال | Ultimate Desync Controller")
print("📌 اختر طريقة الديسنك المفضلة ثم اضغط تشغيل")
print("🧠 FFlag Mode - تعطيل حسابات الفيزياء")
print("🌐 Net Mode - تضليل السيرفر بالجسم الوهمي")
print("⏱️ RakNet Mode - مقاطعة الحزم الشبكية")
print("═══════════════════════════════════════════════════════")
