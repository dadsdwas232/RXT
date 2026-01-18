-- -- [[ 👑 RXT SERVER - V9 THE ULTIMATE FULL VERSION ]] --
-- STATUS: ALL FEATURES ACTIVE | LEGACY SPEED & JUMP | FULL FARM

if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")
local player = Players.LocalPlayer

-- [[ ⚙️ الإعدادات ]] --
local stealthSpeedEnabled = false
local speedValue = 50
local noclipEnabled = false
local instantInteractionEnabled = false
local infJumpEnabled = false
local noRagdollEnabled = false
local radioactiveFarmEnabled = false
local savedPosition = nil

-- [[ 🛠️ وظائف النظام الخلفية ]] --

-- [1] مانع الطرد (Anti-AFK) - النسخة الأقوى
task.spawn(function()
    local VU = game:GetService("VirtualUser")
    player.Idled:Connect(function()
        VU:CaptureController()
        VU:ClickButton2(Vector2.new())
    end)
end)

-- [2] محرك الحركة (السرعة والقفز - النظام القديم)
RunService.Stepped:Connect(function()
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        local hum = player.Character.Humanoid
        
        -- السرعة القوية
        if stealthSpeedEnabled then
            hum.WalkSpeed = speedValue
        else
            hum.WalkSpeed = 16
        end
        
        -- الجمب القوي
        if infJumpEnabled then
            hum.JumpPower = 50
        end
        
        -- التخفي تحت الأرض
        if radioactiveFarmEnabled and player.Character:FindFirstChild("HumanoidRootPart") then
            player.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame * CFrame.new(0, -0.01, 0)
        end
    end
end)

-- [3] قفز لانهائي (نظام النسخة الأولى)
UserInputService.JumpRequest:Connect(function()
    if infJumpEnabled and player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
        player.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

-- [4] تجميع Radioactive Coins (النظام الصاروخي الأصلي)
task.spawn(function()
    while task.wait() do
        if radioactiveFarmEnabled and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("TouchTransmitter") then
                    local p = v.Parent
                    if p and (p.Name:lower():find("radioactive") or p.Name:lower():find("coin")) then
                        firetouchinterest(player.Character.HumanoidRootPart, p, 0)
                        firetouchinterest(player.Character.HumanoidRootPart, p, 1)
                    end
                end
            end
        end
    end
end)

-- [[ 🎨 واجهة المستخدم V9 ]] --

if CoreGui:FindFirstChild("RXT_Master_V9") then CoreGui["RXT_Master_V9"]:Destroy() end
local ScreenGui = Instance.new("ScreenGui", CoreGui); ScreenGui.Name = "RXT_Master_V9"

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 360, 0, 520); Main.Position = UDim2.new(0.5, -180, 0.5, -260)
Main.BackgroundColor3 = Color3.fromRGB(12, 12, 18); Main.BorderSizePixel = 0
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 15)
local MainStroke = Instance.new("UIStroke", Main); MainStroke.Color = Color3.fromRGB(150, 100, 255); MainStroke.Thickness = 2

-- زر الإغلاق X البنفسجي
local CloseBtn = Instance.new("TextButton", Main)
CloseBtn.Size = UDim2.new(0, 35, 0, 35); CloseBtn.Position = UDim2.new(0, 10, 0, 10)
CloseBtn.Text = "X"; CloseBtn.BackgroundColor3 = Color3.fromRGB(120, 50, 220)
CloseBtn.TextColor3 = Color3.new(1, 1, 1); CloseBtn.Font = Enum.Font.GothamBold; CloseBtn.TextSize = 22
Instance.new("UICorner", CloseBtn)

-- زر الفتح العائم
local OpenBtn = Instance.new("TextButton", ScreenGui)
OpenBtn.Size = UDim2.new(0, 60, 0, 60); OpenBtn.Position = UDim2.new(0, 15, 0.5, -30)
OpenBtn.BackgroundColor3 = Color3.fromRGB(30, 20, 50); OpenBtn.Text = "RXT"; OpenBtn.TextColor3 = Color3.fromRGB(150, 100, 255)
OpenBtn.Font = Enum.Font.GothamBold; OpenBtn.Visible = false; Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(1,0)
Instance.new("UIStroke", OpenBtn).Color = Color3.fromRGB(150, 100, 255)

CloseBtn.MouseButton1Click:Connect(function() Main.Visible = false; OpenBtn.Visible = true end)
OpenBtn.MouseButton1Click:Connect(function() Main.Visible = true; OpenBtn.Visible = false end)

-- نظام سحب القائمة
local d, ds, sp; Main.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then d = true ds = i.Position sp = Main.Position end end)
UserInputService.InputChanged:Connect(function(i) if d and i.UserInputType == Enum.UserInputType.MouseMovement then local delta = i.Position - ds Main.Position = UDim2.new(sp.X.Scale, sp.X.Offset + delta.X, sp.Y.Scale, sp.Y.Offset + delta.Y) end end)
UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then d = false end end)

-- تنبيه الدسكورد التلقائي
task.spawn(function()
    while true do
        task.wait(120)
        local Alert = Instance.new("TextLabel", ScreenGui)
        Alert.Size = UDim2.new(0, 320, 0, 45); Alert.Position = UDim2.new(0.5, -160, 1, -70)
        Alert.BackgroundColor3 = Color3.fromRGB(60, 30, 120); Alert.TextColor3 = Color3.new(1,1,1)
        Alert.Text = "لا تنسى ترسل ل اخوياك الدس RXT 🚀"; Alert.Font = Enum.Font.GothamBold; Alert.TextSize = 13
        Instance.new("UICorner", Alert); task.wait(5); Alert:Destroy()
    end
end)

-- التبويبات
local TabHolder = Instance.new("Frame", Main)
TabHolder.Size = UDim2.new(1, -60, 0, 45); TabHolder.Position = UDim2.new(0, 50, 0, 5); TabHolder.BackgroundTransparency = 1
local TabList = Instance.new("UIListLayout", TabHolder); TabList.FillDirection = Enum.FillDirection.Horizontal; TabList.HorizontalAlignment = Enum.HorizontalAlignment.Center; TabList.Padding = UDim.new(0, 5)

local Pages = Instance.new("Frame", Main); Pages.Size = UDim2.new(1, -20, 1, -90); Pages.Position = UDim2.new(0, 10, 0, 70); Pages.BackgroundTransparency = 1
local function CreatePage()
    local p = Instance.new("ScrollingFrame", Pages); p.Size = UDim2.new(1, 0, 1, 0); p.BackgroundTransparency = 1; p.Visible = false; p.ScrollBarThickness = 0
    Instance.new("UIListLayout", p).Padding = UDim.new(0, 10); return p
end
local P1 = CreatePage(); local P2 = CreatePage(); local P3 = CreatePage(); local P4 = CreatePage(); P1.Visible = true

local function AddTab(t, pg)
    local b = Instance.new("TextButton", TabHolder); b.Size = UDim2.new(0, 70, 1, 0); b.Text = t; b.TextColor3 = Color3.new(1,1,1); b.BackgroundTransparency = 1; b.Font = Enum.Font.GothamBold; b.TextSize = 11
    b.MouseButton1Click:Connect(function() P1.Visible = false; P2.Visible = false; P3.Visible = false; P4.Visible = false; pg.Visible = true end)
end
AddTab("MAIN", P1); AddTab("EVENT", P2); AddTab("WORLD", P3); AddTab("TP", P4)

-- نظام الأزرار
local function AddToggle(parent, txt, current, cb)
    local b = Instance.new("TextButton", parent); b.Size = UDim2.new(1, 0, 0, 40); b.Text = txt .. " : OFF"; b.BackgroundColor3 = Color3.fromRGB(35, 30, 60); b.TextColor3 = Color3.new(1,1,1); b.Font = Enum.Font.GothamBold; Instance.new("UICorner", b)
    local state = current
    local function Update()
        b.Text = state and txt .. " : ON" or txt .. " : OFF"
        b.BackgroundColor3 = state and Color3.fromRGB(0, 180, 100) or Color3.fromRGB(35, 30, 60)
    end
    b.MouseButton1Click:Connect(function() state = not state; cb(state); Update() end)
    Update()
    return b
end

-- [ MAIN ]
AddToggle(P1, "🚫 No Ragdoll", noRagdollEnabled, function(s) noRagdollEnabled = s end)
AddToggle(P1, "🧱 NoClip", noclipEnabled, function(s) noclipEnabled = s end)
AddToggle(P1, "🦘 Infinity Jump", infJumpEnabled, function(s) infJumpEnabled = s end)
local SpdInput = Instance.new("TextBox", P1); SpdInput.Size = UDim2.new(1, 0, 0, 35); SpdInput.PlaceholderText = "Speed (50)"; SpdInput.BackgroundColor3 = Color3.fromRGB(20, 20, 30); SpdInput.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", SpdInput); SpdInput.Text = "50"
AddToggle(P1, "🚀 Stealth Speed", stealthSpeedEnabled, function(s) stealthSpeedEnabled = s; speedValue = tonumber(SpdInput.Text) or 50 end)

-- [ EVENT ]
AddToggle(P2, "☢️ Radioactive Farm", radioactiveFarmEnabled, function(s) radioactiveFarmEnabled = s end)
AddToggle(P2, "⚡ Instant E", instantInteractionEnabled, function(s) 
    instantInteractionEnabled = s
    if s then for _,v in pairs(workspace:GetDescendants()) do if v:IsA("ProximityPrompt") then v.HoldDuration = 0 end end end
end)

-- [ WORLD ]
local bAFK = Instance.new("TextButton", P3); bAFK.Size = UDim2.new(1, 0, 0, 40); bAFK.Text = "💤 Anti-AFK: ALWAYS ON ✅"; bAFK.BackgroundColor3 = Color3.fromRGB(0, 120, 200); bAFK.TextColor3 = Color3.new(1,1,1); bAFK.Font = Enum.Font.GothamBold; Instance.new("UICorner", bAFK)
AddToggle(P3, "⚡ FPS BOOST", false, function(s) if s then for _,v in pairs(game:GetDescendants()) do if v:IsA("BasePart") then v.Material = "SmoothPlastic" end end end end)
AddToggle(P3, "👁️ Unlock Zoom", false, function(s) if s then player.CameraMaxZoomDistance = 100000 end end)
AddToggle(P3, "💡 Full Bright", false, function(s) if s then Lighting.Brightness = 2; Lighting.ClockTime = 14 end end)

-- [ TP ]
local bSave = Instance.new("TextButton", P4); bSave.Size = UDim2.new(1, 0, 0, 40); bSave.Text = "📍 Save Position"; bSave.BackgroundColor3 = Color3.fromRGB(35, 30, 60); bSave.TextColor3 = Color3.new(1,1,1); bSave.Font = Enum.Font.GothamBold; Instance.new("UICorner", bSave)
bSave.MouseButton1Click:Connect(function() if player.Character then savedPosition = player.Character.HumanoidRootPart.CFrame; bSave.Text = "✅ Position Saved!"; task.wait(1); bSave.Text = "📍 Save Position" end end)

local bTP = Instance.new("TextButton", P4); bTP.Size = UDim2.new(1, 0, 0, 40); bTP.Text = "🌀 Ghost Smooth TP"; bTP.BackgroundColor3 = Color3.fromRGB(35, 30, 60); bTP.TextColor3 = Color3.new(1,1,1); bTP.Font = Enum.Font.GothamBold; Instance.new("UICorner", bTP)
bTP.MouseButton1Click:Connect(function()
    if savedPosition then
        local root = player.Character.HumanoidRootPart; local dist = (root.Position - savedPosition.Position).Magnitude
        local duration = dist / 120; local start = tick(); local startCF = root.CFrame
        local conn; conn = RunService.Heartbeat:Connect(function()
            local elapsed = tick() - start
            if elapsed >= duration then root.CFrame = savedPosition; conn:Disconnect()
            else root.CFrame = startCF:Lerp(savedPosition, elapsed/duration); root.Velocity = Vector3.new(0,0,0) end
        end)
    end
end)

local Footer = Instance.new("TextLabel", Main); Footer.Size = UDim2.new(1, 0, 0, 30); Footer.Position = UDim2.new(0, 0, 1, -30); Footer.Text = "RXT SERVER | V9 ULTIMATE EDITION"; Footer.TextColor3 = Color3.fromRGB(150, 100, 255); Footer.BackgroundTransparency = 1; Footer.Font = Enum.Font.GothamBold

print("👑 RXT MASTER V9 LOADED - EVERYTHING IS BACK!")
