--[[
    DesyncController v3.0
    Fixed & Enhanced - Private Use Only
]]

-- ========== الخدمات ==========
local Players        = game:GetService("Players")
local TweenService   = game:GetService("TweenService")
local RunService     = game:GetService("RunService")
local CoreGui        = game:GetService("CoreGui")

local player    = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local rootPart  = character:WaitForChild("HumanoidRootPart")

-- ========== تنظيف قديم ==========
local oldGui = CoreGui:FindFirstChild("DesyncPanel_v3")
if oldGui then oldGui:Destroy() end

-- ========== الحالة ==========
local desyncActive  = false
local bodyVelocity  = nil
local bodyGyro      = nil
local desyncThread  = nil

-- ========== بناء الواجهة ==========
local screenGui = Instance.new("ScreenGui")
screenGui.Name             = "DesyncPanel_v3"
screenGui.ResetOnSpawn     = false
screenGui.ZIndexBehavior   = Enum.ZIndexBehavior.Sibling
screenGui.IgnoreGuiInset   = true
screenGui.Parent           = CoreGui

-- الإطار الرئيسي
local mainFrame = Instance.new("Frame")
mainFrame.Size                = UDim2.new(0, 360, 0, 190)
mainFrame.Position            = UDim2.new(0.5, -180, 0.3, 0)
mainFrame.BackgroundColor3    = Color3.fromRGB(12, 14, 28)
mainFrame.BackgroundTransparency = 0
mainFrame.BorderSizePixel     = 0
mainFrame.ClipsDescendants    = true
mainFrame.Parent              = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 18)
mainCorner.Parent = mainFrame

-- حد خارجي
local stroke = Instance.new("UIStroke")
stroke.Color       = Color3.fromRGB(70, 140, 255)
stroke.Thickness   = 1.5
stroke.Transparency = 0.3
stroke.Parent      = mainFrame

-- تدرج داخلي
local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0,   Color3.fromRGB(18, 22, 45)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(14, 17, 35)),
    ColorSequenceKeypoint.new(1,   Color3.fromRGB(10, 12, 25)),
})
gradient.Rotation = 135
gradient.Parent = mainFrame

-- ========== شريط العنوان ==========
local titleBar = Instance.new("Frame")
titleBar.Size              = UDim2.new(1, 0, 0, 52)
titleBar.BackgroundColor3  = Color3.fromRGB(20, 25, 50)
titleBar.BackgroundTransparency = 0.2
titleBar.BorderSizePixel   = 0
titleBar.Parent            = mainFrame

local titleBarCorner = Instance.new("UICorner")
titleBarCorner.CornerRadius = UDim.new(0, 18)
titleBarCorner.Parent = titleBar

-- تصحيح الزوايا السفلية للشريط
local titleBarFix = Instance.new("Frame")
titleBarFix.Size             = UDim2.new(1, 0, 0, 18)
titleBarFix.Position         = UDim2.new(0, 0, 1, -18)
titleBarFix.BackgroundColor3 = Color3.fromRGB(20, 25, 50)
titleBarFix.BackgroundTransparency = 0.2
titleBarFix.BorderSizePixel  = 0
titleBarFix.Parent           = titleBar

-- أيقونة البرق
local icon = Instance.new("TextLabel")
icon.Size                = UDim2.new(0, 40, 0, 40)
icon.Position            = UDim2.new(0, 12, 0.5, -20)
icon.BackgroundTransparency = 1
icon.Text                = "⚡"
icon.TextSize            = 22
icon.Font                = Enum.Font.GothamBold
icon.TextColor3          = Color3.fromRGB(80, 160, 255)
icon.Parent              = titleBar

-- العنوان
local title = Instance.new("TextLabel")
title.Size               = UDim2.new(1, -110, 1, 0)
title.Position           = UDim2.new(0, 52, 0, 0)
title.BackgroundTransparency = 1
title.Text               = "DESYNC CONTROLLER"
title.TextColor3         = Color3.fromRGB(220, 230, 255)
title.Font               = Enum.Font.GothamBold
title.TextSize           = 17
title.TextXAlignment     = Enum.TextXAlignment.Left
title.Parent             = titleBar

-- نص الإصدار
local versionLabel = Instance.new("TextLabel")
versionLabel.Size            = UDim2.new(0, 35, 0, 16)
versionLabel.Position        = UDim2.new(0, 52, 0.5, 4)
versionLabel.BackgroundTransparency = 1
versionLabel.Text            = "v3.0"
versionLabel.TextColor3      = Color3.fromRGB(80, 100, 160)
versionLabel.Font            = Enum.Font.Gotham
versionLabel.TextSize        = 11
versionLabel.TextXAlignment  = Enum.TextXAlignment.Left
versionLabel.Parent          = titleBar

-- ========== أزرار شريط العنوان ==========
-- دالة مساعدة لإنشاء أزرار التحكم
local function makeTitleBtn(offsetX, txt, color)
    local btn = Instance.new("TextButton")
    btn.Size                  = UDim2.new(0, 28, 0, 28)
    btn.Position              = UDim2.new(1, offsetX, 0.5, -14)
    btn.BackgroundColor3      = Color3.fromRGB(30, 35, 60)
    btn.BackgroundTransparency = 0.3
    btn.Text                  = txt
    btn.TextColor3            = color
    btn.Font                  = Enum.Font.GothamBold
    btn.TextSize              = 14
    btn.AutoButtonColor       = false
    btn.Parent                = titleBar

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 8)
    c.Parent = btn

    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.12), {
            BackgroundColor3 = color,
            TextColor3       = Color3.fromRGB(255, 255, 255),
        }):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.12), {
            BackgroundColor3 = Color3.fromRGB(30, 35, 60),
            TextColor3       = color,
        }):Play()
    end)
    return btn
end

local closeBtn    = makeTitleBtn(-12,  "✕", Color3.fromRGB(255, 80,  80))
local minimizeBtn = makeTitleBtn(-48,  "—", Color3.fromRGB(200, 200, 200))

-- ========== نص الحالة ==========
local statusLabel = Instance.new("TextLabel")
statusLabel.Size             = UDim2.new(1, -30, 0, 32)
statusLabel.Position         = UDim2.new(0, 15, 0, 60)
statusLabel.BackgroundTransparency = 1
statusLabel.Text             = "● STATUS:  OFFLINE"
statusLabel.TextColor3       = Color3.fromRGB(255, 90, 90)
statusLabel.Font             = Enum.Font.GothamBold
statusLabel.TextSize         = 15
statusLabel.TextXAlignment   = Enum.TextXAlignment.Left
statusLabel.Parent           = mainFrame

-- خط فاصل
local divider = Instance.new("Frame")
divider.Size             = UDim2.new(1, -30, 0, 1)
divider.Position         = UDim2.new(0, 15, 0, 96)
divider.BackgroundColor3 = Color3.fromRGB(40, 55, 100)
divider.BorderSizePixel  = 0
divider.Parent           = mainFrame

-- ========== الزر الرئيسي ==========
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size             = UDim2.new(1, -30, 0, 55)
toggleBtn.Position         = UDim2.new(0, 15, 0, 108)
toggleBtn.BackgroundColor3 = Color3.fromRGB(200, 45, 45)
toggleBtn.Text             = "ACTIVATE  DESYNC"
toggleBtn.TextColor3       = Color3.fromRGB(255, 255, 255)
toggleBtn.Font             = Enum.Font.GothamBold
toggleBtn.TextSize         = 17
toggleBtn.AutoButtonColor  = false
toggleBtn.Parent           = mainFrame

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 12)
toggleCorner.Parent = toggleBtn

-- تدرج الزر
local btnGradient = Instance.new("UIGradient")
btnGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0,   Color3.fromRGB(230, 55, 55)),
    ColorSequenceKeypoint.new(1,   Color3.fromRGB(180, 35, 35)),
})
btnGradient.Rotation = 90
btnGradient.Parent = toggleBtn

-- توهج الزر (إطار شبه شفاف فوقه)
local btnGlow = Instance.new("Frame")
btnGlow.Size              = UDim2.new(1, 8, 1, 8)
btnGlow.Position          = UDim2.new(0, -4, 0, -4)
btnGlow.BackgroundColor3  = Color3.fromRGB(200, 45, 45)
btnGlow.BackgroundTransparency = 0.85
btnGlow.BorderSizePixel   = 0
btnGlow.ZIndex            = toggleBtn.ZIndex - 1
btnGlow.Parent            = toggleBtn

local btnGlowCorner = Instance.new("UICorner")
btnGlowCorner.CornerRadius = UDim.new(0, 16)
btnGlowCorner.Parent = btnGlow

-- ========== منطق السحب (Drag) ==========
do
    local dragging, dragStart, startPos = false, nil, nil

    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or
           input.UserInputType == Enum.UserInputType.Touch then
            dragging  = true
            dragStart = input.Position
            startPos  = mainFrame.Position
        end
    end)

    titleBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or
           input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or
                         input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
end

-- ========== تصغير / إغلاق ==========
local minimized     = false
local fullSize      = UDim2.new(0, 360, 0, 190)
local minimizedSize = UDim2.new(0, 360, 0, 52)

local function tweenFrame(targetSize)
    TweenService:Create(mainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Size = targetSize
    }):Play()
end

minimizeBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        tweenFrame(minimizedSize)
        minimizeBtn.Text = "□"
    else
        tweenFrame(fullSize)
        minimizeBtn.Text = "—"
    end
end)

closeBtn.MouseButton1Click:Connect(function()
    screenGui.Enabled = not screenGui.Enabled
end)

-- ========== منطق الديسنك ==========
local function cleanPhysics()
    if bodyVelocity and bodyVelocity.Parent then
        bodyVelocity:Destroy()
    end
    if bodyGyro and bodyGyro.Parent then
        bodyGyro:Destroy()
    end
    bodyVelocity = nil
    bodyGyro     = nil
end

local function applyPhysics()
    cleanPhysics()

    bodyVelocity               = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce      = Vector3.new(1e5, 1e5, 1e5)
    bodyVelocity.Velocity      = Vector3.zero
    bodyVelocity.Parent        = rootPart

    bodyGyro               = Instance.new("BodyGyro")
    bodyGyro.MaxTorque     = Vector3.new(1e5, 1e5, 1e5)
    bodyGyro.D             = 100
    bodyGyro.P             = 3000
    bodyGyro.CFrame        = rootPart.CFrame
    bodyGyro.Parent        = rootPart
end

-- تحديث الواجهة
local function setUI(active)
    if active then
        statusLabel.Text       = "● STATUS:  ACTIVE"
        statusLabel.TextColor3 = Color3.fromRGB(80, 255, 140)
        toggleBtn.Text         = "DEACTIVATE  DESYNC"
        TweenService:Create(toggleBtn, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(40, 175, 85)
        }):Play()
        TweenService:Create(btnGlow, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(40, 175, 85)
        }):Play()
        btnGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(55, 200, 100)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(35, 150, 70)),
        })
        stroke.Color = Color3.fromRGB(55, 200, 100)
    else
        statusLabel.Text       = "● STATUS:  OFFLINE"
        statusLabel.TextColor3 = Color3.fromRGB(255, 90, 90)
        toggleBtn.Text         = "ACTIVATE  DESYNC"
        TweenService:Create(toggleBtn, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(200, 45, 45)
        }):Play()
        TweenService:Create(btnGlow, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(200, 45, 45)
        }):Play()
        btnGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(230, 55, 55)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 35, 35)),
        })
        stroke.Color = Color3.fromRGB(70, 140, 255)
    end
end

local function startDesync()
    if desyncActive then return end
    desyncActive = true
    setUI(true)
    applyPhysics()

    desyncThread = task.spawn(function()
        while desyncActive do
            task.wait(0.08)
            pcall(function()
                if not rootPart or not rootPart.Parent then return end

                -- اهتزاز عشوائي للجسم
                rootPart.AssemblyLinearVelocity = Vector3.new(
                    math.random(-120, 120),
                    math.random( -40,  40),
                    math.random(-120, 120)
                )

                -- تحديث الـ BodyGyro لإبقاء الاتجاه
                if bodyGyro and bodyGyro.Parent then
                    bodyGyro.CFrame = rootPart.CFrame
                end
            end)
        end
    end)

    print("[DesyncController] Activated")
end

local function stopDesync()
    if not desyncActive then return end
    desyncActive = false

    if desyncThread then
        task.cancel(desyncThread)
        desyncThread = nil
    end

    cleanPhysics()

    pcall(function()
        if rootPart and rootPart.Parent then
            rootPart.AssemblyLinearVelocity  = Vector3.zero
            rootPart.AssemblyAngularVelocity = Vector3.zero
        end
    end)

    setUI(false)
    print("[DesyncController] Deactivated")
end

-- ========== ضغط الزر ==========
toggleBtn.MouseButton1Click:Connect(function()
    -- تأثير نبض عند الضغط
    TweenService:Create(toggleBtn, TweenInfo.new(0.08), {Size = UDim2.new(1, -38, 0, 51)}):Play()
    task.wait(0.08)
    TweenService:Create(toggleBtn, TweenInfo.new(0.1), {Size = UDim2.new(1, -30, 0, 55)}):Play()

    if desyncActive then
        stopDesync()
    else
        startDesync()
    end
end)

-- تأثيرات hover للزر الرئيسي
toggleBtn.MouseEnter:Connect(function()
    TweenService:Create(toggleBtn, TweenInfo.new(0.12), {
        BackgroundTransparency = 0.15
    }):Play()
end)
toggleBtn.MouseLeave:Connect(function()
    TweenService:Create(toggleBtn, TweenInfo.new(0.12), {
        BackgroundTransparency = 0
    }):Play()
end)

-- ========== إعادة الشخصية ==========
player.CharacterAdded:Connect(function(newChar)
    local wasActive = desyncActive

    if desyncActive then
        stopDesync()
    end

    character = newChar
    rootPart  = newChar:WaitForChild("HumanoidRootPart")

    if wasActive then
        task.wait(0.3)
        startDesync()
    end
end)

-- ========== حركة ظهور القائمة ==========
mainFrame.Size               = UDim2.new(0, 0,   0, 0)
mainFrame.BackgroundTransparency = 1
mainFrame.Position           = UDim2.new(0.5, 0, 0.3, 0)

task.spawn(function()
    task.wait(0.05)
    TweenService:Create(mainFrame,
        TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        {
            Size                    = fullSize,
            Position                = UDim2.new(0.5, -180, 0.3, 0),
            BackgroundTransparency  = 0,
        }
    ):Play()
end)

print("══════════════════════════════════════")
print(" DesyncController v3.0  —  Ready")
print(" Drag the title bar to move the panel")
print(" [X] hides | [—] minimizes")
print("══════════════════════════════════════")
