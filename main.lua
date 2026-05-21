-- === قائمة روبلوكس متطورة - تصميم 100X بيطور ===
local GuiLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/xxxxx/ExampleLibrary/main/Library.lua"))() -- مثال فقط
local MainWindow = GuiLibrary:CreateWindow("✨ وهمية - الطيار المتكامل ✨")

-- === تصميم القائمة الفريد ===
MainWindow:SetStyle({
    Theme = "NeonPurple",
    BorderThickness = 3,
    CornerRadius = 15,
    ShadowEffect = true,
    AnimationSpeed = 0.3,
    Font = "Arabic",
    Size = UDim2.new(0.4, 0, 0.8, 0),
    Position = UDim2.new(0.3, 0, 0.1, 0),
    BackgroundGradient = {Color3.fromRGB(120, 0, 255), Color3.fromRGB(0, 180, 255)},
    TitleBarEffect = "GlowPulse"
})

-- === الـ 20 ميزة ===
local FlightTab = MainWindow:CreateTab("✈️ طيران وحركة")
FlightTab:CreateToggle("طيران فعال", function(state)
    _G.FlightEnabled = state
    -- كود الطيران هنا
end)
FlightTab:CreateSlider("سرعة الطيران", 0, 500, 100, function(val)
    _G.FlightSpeed = val
end)
FlightTab:CreateButton("توقف فوري للطيران", function()
    _G.FlightEnabled = false
    game.Players.LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
end)
FlightTab:CreateToggle("طيران تلقائي للهدف", function(state)
    _G.AutoFly = state
end)
FlightTab:CreateTextBox("ادخل اسم اللاعب للطيران اليه", function(text)
    _G.TargetPlayer = text
end)
FlightTab:CreateToggle("تثبيت الموقف في الهواء", function(state)
    _G.HoverLock = state
end)
FlightTab:CreateSlider("ارتفاع الطيران الافتراضي", 0, 200, 50, function(val)
    _G.DefaultHeight = val
end)
FlightTab:CreateToggle("حركة بلا جاذبية", function(state)
    _G.NoGravity = state
    game.Workspace.Gravity = state and 0 or 196.2
end)

local PlayerTab = MainWindow:CreateTab("👤 خصائص اللاعب")
PlayerTab:CreateToggle("الخضوع للضرر مغلق", function(state)
    game.Players.LocalPlayer.Character.Humanoid.MaxHealth = state and math.huge or 100
    game.Players.LocalPlayer.Character.Humanoid.Health = state and math.huge or 100
end)
PlayerTab:CreateSlider("سرعة المشي", 0, 200, 16, function(val)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = val
end)
PlayerTab:CreateSlider("قوة القفز", 0, 200, 50, function(val)
    game.Players.LocalPlayer.Character.Humanoid.JumpPower = val
end)
PlayerTab:CreateToggle("اظهار جميع اللاعبين", function(state)
    for _,v in pairs(game.Players:GetPlayers()) do
        if v.Character then v.Character.HumanoidRootPart.Transparency = state and 0 or 1 end
    end
end)
PlayerTab:CreateButton("إعادة تعيين خصائص اللاعب", function()
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16
    game.Players.LocalPlayer.Character.Humanoid.JumpPower = 50
    game.Workspace.Gravity = 196.2
end)
PlayerTab:CreateToggle("تغير لون البطارية", function(state)
    _G.ColorEnabled = state
    -- كود تغير اللون هنا
end)
PlayerTab:CreateColorPicker("اختر لون البطارية", Color3.fromRGB(255,0,0), function(col)
    _G.PlayerColor = col
end)

local WorldTab = MainWindow:CreateTab("🌍 عالم اللعب")
WorldTab:CreateToggle("اظهار جميع الأشياء المخفية", function(state)
    for _,v in pairs(game.Workspace:GetDescendants()) do
        if v:IsA("BasePart") then v.Transparency = state and 0 or v.Transparency end
    end
end)
WorldTab:CreateButton("تحديث عالم اللعب", function()
    game.Workspace:ClearAllChildren()
    game:GetService("ReplicatedStorage"):FindFirstChild("MapLoader"):FireServer()
end)
WorldTab:CreateToggle("وقت اللعب ثابت (نهار)", function(state)
    game.Lighting.ClockTime = state and 12 or game.Lighting.ClockTime
end)
WorldTab:CreateSlider("ضوء العالم", 0, 1, 0.5, function(val)
    game.Lighting.Brightness = val
end)
WorldTab:CreateToggle("إزالة الغيوم والغيوم", function(state)
    game.Lighting.FogEnd = state and 100000 or 1000
end)

-- === نظام تحكم بالطيران يعمل بشكل مستمر ===
game:GetService("RunService").RenderStepped:Connect(function()
    if _G.FlightEnabled and game.Players.LocalPlayer.Character then
        local Humanoid = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        local RootPart = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if Humanoid and RootPart then
            Humanoid.PlatformStand = true
            local Direction = Vector3.new(0,0,0)
            
            -- التحكم بالطيران باستخدام مفاتيح لوحة المفاتيح
            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.W) then
                Direction = Direction + RootPart.CFrame.LookVector
            end
            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.S) then
                Direction = Direction - RootPart.CFrame.LookVector
            end
            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.A) then
                Direction = Direction - RootPart.CFrame.RightVector
            end
            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.D) then
                Direction = Direction + RootPart.CFrame.RightVector
            end
            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.Space) then
                Direction = Direction + Vector3.new(0,1,0)
            end
            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.LeftShift) then
                Direction = Direction - Vector3.new(0,1,0)
            end
            
            RootPart.Velocity = Direction.Unit * _G.FlightSpeed
            if _G.HoverLock then RootPart.Velocity = Vector3.new(0,0,0) end
        end
    end
end)
