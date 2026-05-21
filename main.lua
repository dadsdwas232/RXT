-- === قائمة ROBLOX مخصصة - تصميم كامل من الصفر ===
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- === إنشاء واجهة المستخدم ===
local MainGui = Instance.new("ScreenGui")
MainGui.Name = "CustomRobloxGui"
MainGui.Parent = PlayerGui

-- === إطار القائمة الرئيسي ===
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0.45, 0, 0.85, 0)
MainFrame.Position = UDim2.new(0.275, 0, 0.075, 0)
MainFrame.BackgroundTransparency = 0.1
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = MainGui

-- === تدرج لوني للخلفية ===
local Gradient = Instance.new("UIGradient")
Gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 0, 200)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 100, 200)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(80, 0, 200))
}
Gradient.Rotation = 45
Gradient.Parent = MainFrame

-- === ظل للقائمة ===
local Shadow = Instance.new("ImageLabel")
Shadow.Name = "Shadow"
Shadow.Size = UDim2.new(1, 20, 1, 20)
Shadow.Position = UDim2.new(0, -10, 0, -10)
Shadow.BackgroundTransparency = 1
Shadow.Image = "rbxassetid://1316045217"
Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
Shadow.ImageTransparency = 0.7
Shadow.ZIndex = 0
Shadow.Parent = MainFrame

-- === شريط العنوان ===
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 50)
TitleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleText = Instance.new("TextLabel")
TitleText.Name = "TitleText"
TitleText.Size = UDim2.new(0.8, 0, 1, 0)
TitleText.Position = UDim2.new(0.1, 0, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "✨ طيار المطور - الواجهة الخارقة ✨"
TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleText.Font = Enum.Font.Arabic
TitleText.TextSize = 22
TitleText.TextStrokeTransparency = 0.7
TitleText.Parent = TitleBar

-- === زر إغلاق ===
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 40, 0, 40)
CloseButton.Position = UDim2.new(1, -45, 0, 5)
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 0, 50)
CloseButton.BorderSizePixel = 0
CloseButton.CornerRadius = UDim.new(0, 20)
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.Font = Enum.Font.ArialBold
CloseButton.TextSize = 20
CloseButton.Parent = TitleBar

CloseButton.MouseButton1Click:Connect(function()
    MainGui.Enabled = not MainGui.Enabled
end)

-- === شريط التبويبات ===
local TabsFrame = Instance.new("Frame")
TabsFrame.Name = "TabsFrame"
TabsFrame.Size = UDim2.new(1, 0, 0, 40)
TabsFrame.Position = UDim2.new(0, 0, 0, 50)
TabsFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
TabsFrame.BorderSizePixel = 0
TabsFrame.Parent = MainFrame

-- === إنشاء تبويبات ===
local Tabs = {
    {Name = "✈️ طيران", Color = Color3.fromRGB(100, 0, 200)},
    {Name = "👤 لاعب", Color = Color3.fromRGB(0, 150, 200)},
    {Name = "🌍 عالم", Color = Color3.fromRGB(0, 200, 100)},
    {Name = "⚙️ إعدادات", Color = Color3.fromRGB(200, 150, 0)}
}

local ActiveTab = 1
local TabButtons = {}
local ContentFrames = {}

-- === إنشاء أزرار التبويبات ===
for i, tab in ipairs(Tabs) do
    local TabButton = Instance.new("TextButton")
    TabButton.Name = "TabButton_" .. i
    TabButton.Size = UDim2.new(1/#Tabs, 0, 1, 0)
    TabButton.Position = UDim2.new((i-1)/#Tabs, 0, 0, 0)
    TabButton.BackgroundColor3 = tab.Color
    TabButton.BackgroundTransparency = i == ActiveTab and 0 or 0.5
    TabButton.BorderSizePixel = 0
    TabButton.Text = tab.Name
    TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    TabButton.Font = Enum.Font.Arabic
    TabButton.TextSize = 18
    TabButton.Parent = TabsFrame
    table.insert(TabButtons, TabButton)

    -- === إطار محتوى التبويبة ===
    local ContentFrame = Instance.new("ScrollingFrame")
    ContentFrame.Name = "ContentFrame_" .. i
    ContentFrame.Size = UDim2.new(1, 0, 1, -90)
    ContentFrame.Position = UDim2.new(0, 0, 0, 90)
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.BorderSizePixel = 0
    ContentFrame.CanvasSize = UDim2.new(1, 0, 2, 0)
    ContentFrame.ScrollBarThickness = 5
    ContentFrame.Visible = i == ActiveTab
    ContentFrame.Parent = MainFrame
    table.insert(ContentFrames, ContentFrame)

    -- === تفعيل التبويبة عند الضغط ===
    TabButton.MouseButton1Click:Connect(function()
        ActiveTab = i
        for j, btn in ipairs(TabButtons) do
            btn.BackgroundTransparency = j == i and 0 or 0.5
            ContentFrames[j].Visible = j == i
        end
    end)
end

-- === دالة لإنشاء عناصر التحكم ===
local function CreateUIElement(parent, type, props)
    local elem = Instance.new(type)
    for k, v in pairs(props) do
        elem[k] = v
    end
    elem.Parent = parent
    return elem
end

-- === متغيرات التحكم ===
local Settings = {
    FlightEnabled = false,
    FlightSpeed = 150,
    NoDamage = false,
    WalkSpeed = 16,
    JumpPower = 50,
    NoGravity = false,
    Brightness = 0.5,
    FlightHeight = 50
}

-- === محتوى تبويبة الطيران ===
local FlightTab = ContentFrames[1]

-- زر تفعيل الطيران
CreateUIElement(FlightTab, "TextButton", {
    Name = "FlightToggle",
    Size = UDim2.new(0.9, 0, 0, 50),
    Position = UDim2.new(0.05, 0, 0, 20),
    BackgroundColor3 = Color3.fromRGB(100, 0, 200),
    CornerRadius = UDim.new(0, 10),
    BorderSizePixel = 0,
    Text = "🔘 تفعيل الطيران",
    TextColor3 = Color3.fromRGB(255,255,255),
    Font = Enum.Font.Arabic,
    TextSize = 20
}).MouseButton1Click:Connect(function()
    Settings.FlightEnabled = not Settings.FlightEnabled
    this.Text = Settings.FlightEnabled and "🔘 إيقاف الطيران" or "🔘 تفعيل الطيران"
end)

-- شريط سرعة الطيران
CreateUIElement(FlightTab, "TextLabel", {
    Name = "SpeedLabel",
    Size = UDim2.new(0.9, 0, 0, 30),
    Position = UDim2.new(0.05, 0, 0, 80),
    BackgroundTransparency = 1,
    Text = "⚡ سرعة الطيران: " .. Settings.FlightSpeed,
    TextColor3 = Color3.fromRGB(255,255,255),
    Font = Enum.Font.Arabic,
    TextSize = 18
})

local SpeedSlider = CreateUIElement(FlightTab, "Frame", {
    Name = "SpeedSlider",
    Size = UDim2.new(0.9, 0, 0, 10),
    Position = UDim2.new(0.05, 0, 0, 110),
    BackgroundColor3 = Color3.fromRGB(50,50,80),
    CornerRadius = UDim.new(0,5),
    BorderSizePixel = 0
})

local SpeedFill = CreateUIElement(SpeedSlider, "Frame", {
    Name = "SpeedFill",
    Size = UDim2.new(Settings.FlightSpeed/500, 0, 1, 0),
    BackgroundColor3 = Color3.fromRGB(100, 0, 200),
    CornerRadius = UDim.new(0,5),
    BorderSizePixel = 0
})

local SpeedKnob = CreateUIElement(SpeedSlider, "Frame", {
    Name = "SpeedKnob",
    Size = UDim2.new(0,20,0,20),
    Position = UDim2.new(Settings.FlightSpeed/500, -10, 0, -5),
    BackgroundColor3 = Color3.fromRGB(255,255,255),
    CornerRadius = UDim.new(1,0),
    BorderSizePixel = 0
})

-- تحكم بالشريط
local SliderDragging = false
SpeedKnob.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        SliderDragging = true
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        SliderDragging = false
    end
end)

RunService.RenderStepped:Connect(function()
    if SliderDragging then
        local MousePos = UserInputService:GetMouseLocation()
        local SliderPos = SpeedSlider.AbsolutePosition.X
        local SliderSize = SpeedSlider.AbsoluteSize.X
        local Percent = math.clamp((MousePos.X - SliderPos)/SliderSize, 0, 1)
        Settings.FlightSpeed = math.floor(Percent * 500)
        SpeedFill.Size = UDim2.new(Percent, 0, 1, 0)
        SpeedKnob.Position = UDim2.new(Percent, -10, 0, -5)
        FlightTab.SpeedLabel.Text = "⚡ سرعة الطيران: " .. Settings.FlightSpeed
    end
end)

-- زر طيران تلقائي
CreateUIElement(FlightTab, "TextButton", {
    Name = "AutoHover",
    Size = UDim2.new(0.9, 0, 0, 50),
    Position = UDim2.new(0.05, 0, 0, 140),
    BackgroundColor3 = Color3.fromRGB(100, 0, 200),
    CornerRadius = UDim.new(0, 10),
    BorderSizePixel = 0,
    Text = "🛡️ تثبيت في الهواء",
    TextColor3 = Color3.fromRGB(255,255,255),
    Font = Enum.Font.Arabic,
    TextSize = 20
}).MouseButton1Click:Connect(function()
    Settings.HoverLock = not Settings.HoverLock
    this.Text = Settings.HoverLock and "🛡️ إيقاف التثبيت" or "🛡️ تثبيت في الهواء"
end)

-- زر إلغاء الجاذبية
CreateUIElement(FlightTab, "TextButton", {
    Name = "NoGravityBtn",
    Size = UDim2.new(0.9, 0, 0, 50),
    Position = UDim2.new(0.05, 0, 0, 200),
    BackgroundColor3 = Color3.fromRGB(100, 0, 200),
    CornerRadius = UDim.new(0, 10),
    BorderSizePixel = 0,
    Text = "🪐 إلغاء الجاذبية",
    TextColor3 = Color3.fromRGB(255,255,255),
    Font = Enum.Font.Arabic,
    TextSize = 20
}).MouseButton1Click:Connect(function()
    Settings.NoGravity = not Settings.NoGravity
    game.Workspace.Gravity = Settings.NoGravity and 0 or 196.2
    this.Text = Settings.NoGravity and "🪐 تفعيل الجاذبية" or "🪐 إلغاء الجاذبية"
end)

-- === محتوى تبويبة اللاعب ===
local PlayerTab = ContentFrames[2]

-- زر إلغاء الضرر
CreateUIElement(PlayerTab, "TextButton", {
    Name = "NoDamageBtn",
    Size = UDim2.new(0.9, 0, 0, 50),
    Position = UDim2.new(0.05, 0, 0, 20),
    BackgroundColor3 = Color3.fromRGB(0, 150, 200),
    CornerRadius = UDim.new(0, 10),
    BorderSizePixel = 0,
    Text = "🛡️ تفعيل الحماية الكاملة",
    TextColor3 = Color3.fromRGB(255,255,255),
    Font = Enum.Font.Arabic,
    TextSize = 20
}).MouseButton1Click:Connect(function()
    Settings.NoDamage = not Settings.NoDamage
    if LocalPlayer.Character then
        local Humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if Humanoid then
            Humanoid.MaxHealth = Settings.NoDamage and 9999 or 100
            Humanoid.Health = Settings.NoDamage and 9999 or 100
        end
    end
    this.Text = Settings.NoDamage and "🛡️ إيقاف الحماية" or "🛡️ تفعيل الحماية الكاملة"
end)

-- === نظام الطيران العام ===
RunService.RenderStepped:Connect(function()
    if Settings.FlightEnabled and LocalPlayer.Character then
        local Humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        local RootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if Humanoid and RootPart then
            Humanoid.PlatformStand = true
            local Direction = Vector3.new(0,0,0)

            -- التحكم بالطيران بالمفاتيح
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then Direction += RootPart.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then Direction -= RootPart.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then Direction -= RootPart.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then Direction += RootPart.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then Direction += Vector3.new(0,1,0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then Direction -= Vector3.new(0,1,0) end

            -- تطبيق الحركة
            if Settings.HoverLock then
                RootPart.Velocity = Vector3.new(0,0,0)
                RootPart.CFrame = CFrame.new(RootPart.Position) * RootPart.CFrame.Rotation
            else
                RootPart.Velocity = Direction.Unit * Settings.FlightSpeed
            end
        end
    end
end)

-- === إضافة حركة متوهجة للقائمة ===
local function AnimateGui()
    local TweenService = game:GetService("TweenService")
    local TweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    
    local PulseTween = TweenService:Create(MainFrame, TweenInfo, {
        BackgroundTransparency = MainFrame.BackgroundTransparency == 0.1 and 0.15 or 0.1
    })
    PulseTween:Play()
    PulseTween.Completed:Connect(AnimateGui)
end
AnimateGui()

-- === إظهار/إخفاء القائمة بالمفتاح F9 ===
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.F9 then
        MainGui.Enabled = not MainGui.Enabled
    end
end)
