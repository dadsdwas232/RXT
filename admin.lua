-- [[ 👑 RXT SERVER - THE ULTIMATE MASTER EDITION ]] --
-- Credits: RXT SERVER OFFICIAL
-- Version: 3.5 (Stable)

if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")
local player = Players.LocalPlayer

-- [[ ⚙️ المتغيرات الأساسية ]] --
local stealthSpeedEnabled = false
local speedValue = 50
local noclipEnabled = false
local instantInteractionEnabled = false
local infJumpEnabled = false
local noRagdollEnabled = false
local radioactiveFarmEnabled = false
local savedPosition = nil

-- [[ 🛠️ وظائف النظام الخلفية ]] --

-- [1] مانع الطرد (Anti-AFK)
local VirtualUser = game:GetService("VirtualUser")
player.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

-- [2] محرك الحركة الرئيسي (التخفي، النوكليب، مانع السقوط)
RunService.Stepped:Connect(function()
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local root = player.Character.HumanoidRootPart
        local hum = player.Character:FindFirstChildOfClass("Humanoid")
        
        -- ميزة التخفي تحت الأرض (عند تفعيل الفارمينج)
        if radioactiveFarmEnabled then
            root.CFrame = root.CFrame * CFrame.new(0, -0.6, 0) -- نزول بسيط تحت الأرض
        end

        -- مانع الراقدول والنوكليب
        if noRagdollEnabled or noclipEnabled or radioactiveFarmEnabled then
            hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
            hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
            hum:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding, false)
            for _, v in pairs(player.Character:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        end
    end
end)

-- [3] تجميع Radioactive Coins تلقائياً (سرعة فائقة)
task.spawn(function()
    while task.wait(0.01) do
        if radioactiveFarmEnabled and player.Character then
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("TouchTransmitter") then
                    local pName = v.Parent.Name:lower()
                    if pName:find("radioactive") or pName:find("coin") or pName:find("event") then
                        firetouchinterest(player.Character.HumanoidRootPart, v.Parent, 0)
                        firetouchinterest(player.Character.HumanoidRootPart, v.Parent, 1)
                    end
                end
            end
        end
    end
end)

-- [4] السرعة المخصصة وقفز الانفنتي
RunService.Heartbeat:Connect(function(delta)
    if stealthSpeedEnabled and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local root = player.Character.HumanoidRootPart
        local hum = player.Character:FindFirstChildOfClass("Humanoid")
        if hum.MoveDirection.Magnitude > 0 then
            root.CFrame = root.CFrame + (hum.MoveDirection * (speedValue / 8) * delta * 10)
        end
    end
end)

UserInputService.JumpRequest:Connect(function()
    if infJumpEnabled and player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
        player.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

-- [[ 🎨 بناء واجهة RXT SERVER ]] --

if CoreGui:FindFirstChild("RXT_Master_UI") then CoreGui["RXT_Master_UI"]:Destroy() end
local ScreenGui = Instance.new("ScreenGui", CoreGui); ScreenGui.Name = "RXT_Master_UI"

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 360, 0, 520); Main.Position = UDim2.new(0.5, -180, 0.5, -260)
Main.BackgroundColor3 = Color3.fromRGB(12, 12, 18); Main.BorderSizePixel = 0
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 15)
local MainStroke = Instance.new("UIStroke", Main); MainStroke.Color = Color3.fromRGB(100, 80, 255); MainStroke.Thickness = 2

-- أزرار الفتح والإغلاق الذكية
local CloseBtn = Instance.new("TextButton", Main)
CloseBtn.Size = UDim2.new(0, 30, 0, 30); CloseBtn.Position = UDim2.new(1, -40, 0, 10)
CloseBtn.Text = "X"; CloseBtn.BackgroundColor3 = Color3.fromRGB(180, 0, 0); CloseBtn.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", CloseBtn)

local OpenBtn = Instance.new("TextButton", ScreenGui)
OpenBtn.Size = UDim2.new(0, 60, 0, 60); OpenBtn.Position = UDim2.new(0, 15, 0.5, -30)
OpenBtn.BackgroundColor3 = Color3.fromRGB(25, 20, 45); OpenBtn.Text = "RXT"; OpenBtn.TextColor3 = Color3.fromRGB(150, 100, 255)
OpenBtn.Font = Enum.Font.GothamBold; OpenBtn.Visible = false; Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(1,0)
Instance.new("UIStroke", OpenBtn).Color = Color3.fromRGB(150, 100, 255)

CloseBtn.MouseButton1Click:Connect(function() Main.Visible = false; OpenBtn.Visible = true end)
OpenBtn.MouseButton1Click:Connect(function() Main.Visible = true; OpenBtn.Visible = false end)

-- نظام سحب القائمة بالماوس/اللمس
local d, ds, sp; Main.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then d = true ds = i.Position sp = Main.Position end end)
UserInputService.InputChanged:Connect(function(i) if d and i.UserInputType == Enum.UserInputType.MouseMovement then local delta = i.Position - ds Main.Position = UDim2.new(sp.X.Scale, sp.X.Offset + delta.X, sp.Y.Scale, sp.Y.Offset + delta.Y) end end)
UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then d = false end end)

-- [[ 📑 نظام التبويبات ]] --
local TabHolder = Instance.new("Frame", Main)
TabHolder.Size = UDim2.new(1, 0, 0, 45); TabHolder.BackgroundColor3 = Color3.fromRGB(20, 20, 35); Instance.new("UICorner", TabHolder)
local TabList = Instance.new("UIListLayout", TabHolder); TabList.FillDirection = Enum.FillDirection.Horizontal; TabList.HorizontalAlignment = Enum.HorizontalAlignment.Center; TabList.Padding = UDim.new(0, 5)

local Pages = Instance.new("Frame", Main); Pages.Size = UDim2.new(1, -20, 1, -90); Pages.Position = UDim2.new(0, 10, 0, 70); Pages.BackgroundTransparency = 1
local function CreatePage()
    local p = Instance.new("ScrollingFrame", Pages); p.Size = UDim2.new(1, 0, 1, 0); p.BackgroundTransparency = 1; p.Visible = false; p.ScrollBarThickness = 0
    Instance.new("UIListLayout", p).Padding = UDim.new(0, 10); return p
end

local P1 = CreatePage(); local P2 = CreatePage(); local P3 = CreatePage(); local P4 = CreatePage(); P1.Visible = true

local function AddTab(txt, pg)
    local b = Instance.new("TextButton", TabHolder); b.Size = UDim2.new(0, 75, 1, 0); b.Text = txt; b.TextColor3 = Color3.new(1,1,1); b.BackgroundTransparency = 1; b.Font = Enum.Font.GothamBold; b.TextSize = 12
    b.MouseButton1Click:Connect(function() P1.Visible = false; P2.Visible = false; P3.Visible = false; P4.Visible = false; pg.Visible = true end)
end
AddTab("MAIN", P1); AddTab("EVENT", P2); AddTab("WORLD", P3); AddTab("TP", P4)

local function AddBtn(parent, txt, cb)
    local b = Instance.new("TextButton", parent); b.Size = UDim2.new(1, 0, 0, 40); b.Text = txt; b.BackgroundColor3 = Color3.fromRGB(35, 30, 60); b.TextColor3 = Color3.new(1,1,1); b.Font = Enum.Font.GothamBold; Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function() cb(b) end); return b
end

-- [[ 🎛️ أزرار التحكم ]] --

-- MAIN PAGE
AddBtn(P1, "🚫 No Ragdoll: OFF", function(b) noRagdollEnabled = not noRagdollEnabled; b.Text = noRagdollEnabled and "🚫 No Ragdoll: ON" or "🚫 No Ragdoll: OFF"; b.BackgroundColor3 = noRagdollEnabled and Color3.fromRGB(0, 120, 200) or Color3.fromRGB(35, 30, 60) end)
AddBtn(P1, "🧱 NoClip: OFF", function(b) noclipEnabled = not noclipEnabled; b.Text = noclipEnabled and "🧱 NoClip: ON" or "🧱 NoClip: OFF" end)
AddBtn(P1, "🦘 Infinity Jump: OFF", function(b) infJumpEnabled = not infJumpEnabled; b.Text = infJumpEnabled and "🦘 Infinity Jump: ON" or "🦘 Infinity Jump: OFF" end)
local SpdInput = Instance.new("TextBox", P1); SpdInput.Size = UDim2.new(1, 0, 0, 35); SpdInput.PlaceholderText = "Speed (e.g. 100)"; SpdInput.BackgroundColor3 = Color3.fromRGB(20, 20, 30); SpdInput.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", SpdInput)
AddBtn(P1, "🚀 Stealth Speed: OFF", function(b) stealthSpeedEnabled = not stealthSpeedEnabled; speedValue = tonumber(SpdInput.Text) or 50; b.Text = stealthSpeedEnabled and "🚀 Stealth Speed: ON" or "🚀 Stealth Speed: OFF" end)

-- EVENT PAGE
AddBtn(P2, "☢️ Radioactive Farm: OFF", function(b)
    radioactiveFarmEnabled = not radioactiveFarmEnabled
    b.Text = radioactiveFarmEnabled and "☢️ Radioactive Farm: ON" or "☢️ Radioactive Farm: OFF"
    b.BackgroundColor3 = radioactiveFarmEnabled and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(35, 30, 60)
end)
AddBtn(P2, "⚡ Instant E: OFF", function(b)
    instantInteractionEnabled = not instantInteractionEnabled
    if instantInteractionEnabled then for _,v in pairs(workspace:GetDescendants()) do if v:IsA("ProximityPrompt") then v.HoldDuration = 0 end end end
end)

-- WORLD PAGE
AddBtn(P3, "💤 Anti-AFK: ALWAYS ON ✅", function() end)
AddBtn(P3, "⚡ FPS BOOST", function(b) for _,v in pairs(game:GetDescendants()) do if v:IsA("BasePart") then v.Material = "SmoothPlastic" end end; b.Text = "✅ FPS BOOSTED" end)
AddBtn(P3, "👁️ Unlock Zoom", function() player.CameraMaxZoomDistance = 100000 end)
AddBtn(P3, "💡 Full Bright", function() Lighting.Brightness = 2; Lighting.ClockTime = 14 end)

-- TP PAGE
AddBtn(P4, "📍 Save Position", function() if player.Character then savedPosition = player.Character.HumanoidRootPart.CFrame end end)
AddBtn(P4, "🌀 Ghost Smooth TP", function() if savedPosition then
    local root = player.Character.HumanoidRootPart
    local dist = (root.Position - savedPosition.Position).Magnitude
    local duration = dist / 120
    local start = tick()
    local startCF = root.CFrame
    local conn; conn = RunService.Heartbeat:Connect(function()
        local elapsed = tick() - start
        if elapsed >= duration then root.CFrame = savedPosition; conn:Disconnect()
        else root.CFrame = startCF:Lerp(savedPosition, elapsed/duration); root.Velocity = Vector3.new(0,0,0) end
    end)
end end)

-- تذييل القائمة (Footer)
local Footer = Instance.new("TextLabel", Main); Footer.Size = UDim2.new(1, 0, 0, 30); Footer.Position = UDim2.new(0, 0, 1, -30); Footer.Text = "RXT SERVER | OFFICIAL MASTER V3"; Footer.TextColor3 = Color3.fromRGB(150, 100, 255); Footer.BackgroundTransparency = 1; Footer.Font = Enum.Font.GothamBold

print("👑 RXT MASTER LOADED SUCCESSFULLY!")
