--[[ 
    سكربت تفعيل الديسنك (Desync)
    الزر يسبب عدم تزامن بين الكلاينت والسيرفر
]]

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local rootPart = character:WaitForChild("HumanoidRootPart")

-- إنشاء القائمة
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DesyncGUI"
screenGui.Parent = game:GetService("CoreGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 250, 0, 100)
mainFrame.Position = UDim2.new(0.5, -125, 0.7, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
mainFrame.BackgroundTransparency = 0.2
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 35)
title.BackgroundTransparency = 1
title.Text = "🌀 Desync Toggle"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.Parent = mainFrame

-- زر تشغيل الديسنك
local desyncButton = Instance.new("TextButton")
desyncButton.Size = UDim2.new(0.8, 0, 0, 45)
desyncButton.Position = UDim2.new(0.1, 0, 0.5, 0)
desyncButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
desyncButton.Text = "🌀 تفعيل الديسنك"
desyncButton.TextColor3 = Color3.fromRGB(255, 255, 255)
desyncButton.Font = Enum.Font.GothamBold
desyncButton.TextSize = 14
desyncButton.Parent = mainFrame

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 8)
btnCorner.Parent = desyncButton

-- زر اغلاق
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 25, 0, 25)
closeBtn.Position = UDim2.new(1, -30, 0, 5)
closeBtn.BackgroundTransparency = 1
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 16
closeBtn.Parent = mainFrame

closeBtn.MouseButton1Click:Connect(function()
    screenGui.Enabled = not screenGui.Enabled
end)

-- ========== كود الديسنك الحقيقي ==========
local desyncActive = false
local bodyVelocity = nil
var tab

local function startDesync()
    desyncActive = true
    
    -- طريقة الديسنك: نحرك جسم اللاعب بكود ولكن السيرفر ما يشوف الحركة
    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(1/0, 1/0, 1/0)
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.Parent = rootPart
    
    -- نغير مالك الشبكة عشان نسبب ديسنك
    rootPart:SetNetworkOwner(player)
    
    -- نبعد الشخصية عن موقعها الحقيقي (السيرفر يشوفها بمكان وهي بمكان ثاني)
    local remotePos = rootPart.Position + Vector3.new(0, 999, 0)
    rootPart.CFrame = CFrame.new(remotePos)
    
    desyncButton.Text = "🌀 ايقاف الديسنك"
    desyncButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
    
    print("✅ ديسنك مفعل - السيرفر يشوفك بمكان وانت بمكان ثاني")
end

local function stopDesync()
    desyncActive = false
    
    if bodyVelocity then
        bodyVelocity:Destroy()
        bodyVelocity = nil
    end
    
    -- نرجع الموقع للسيرفر
    rootPart:SetNetworkOwner(nil)
    wait(0.1)
    rootPart:SetNetworkOwner(player)
    
    desyncButton.Text = "🌀 تفعيل الديسنك"
    desyncButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    
    print("✅ ديسنك متوقف - رجع التزامن")
end

-- ضغط الزر
desyncButton.MouseButton1Click:Connect(function()
    if desyncActive then
        stopDesync()
    else
        startDesync()
    end
end)

-- تأثير ظهور
mainFrame.BackgroundTransparency = 1
for i = 0, 1, 0.05 do
    mainFrame.BackgroundTransparency = 0.2 * (1 - i) + 0.8 * i
    wait(0.01)
end

print("✅ السكربت شغال | زر تفعيل/ايقاف الديسنك")
