-- [[ 👑 RXT SERVER - EVENT & STEALTH EDITION ]] --
-- Features: Event Farm | Ghost TP | No Ragdoll | Fixed UI Toggle

if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local player = Players.LocalPlayer

-- [ الإعدادات ]
local stealthSpeedEnabled = false
local speedValue = 50
local noclipEnabled = false
local instantInteractionEnabled = false
local infJumpEnabled = false
local noRagdollEnabled = false
local eventFarmEnabled = false
local savedPosition = nil

-- [1] مانع الطرد ومانع الراقدول
local VirtualUser = game:GetService("VirtualUser")
player.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

RunService.Stepped:Connect(function()
    if noRagdollEnabled and player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
        local hum = player.Character:FindFirstChildOfClass("Humanoid")
        hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
        hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
        hum:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding, false)
    end
end)

-- [2] ميزة تجميع العملات/الإيفنت (تلقائي)
task.spawn(function()
    while task.wait(0.1) do
        if eventFarmEnabled and player.Character then
            -- يبحث عن أي شيء اسمه Coin أو Event أو Gift أو Package
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("TouchTransmitter") and (v.Parent.Name:lower():find("coin") or v.Parent.Name:lower():find("event") or v.Parent.Name:lower():find("gift")) then
                    firetouchinterest(player.Character.HumanoidRootPart, v.Parent, 0)
                    firetouchinterest(player.Character.HumanoidRootPart, v.Parent, 1)
                end
            end
        end
    end
end)

-- [3] الواجهة المتطورة (RXT SERVER)
if CoreGui:FindFirstChild("RXT_Final_V2") then CoreGui["RXT_Final_V2"]:Destroy() end
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "RXT_Final_V2"

-- القائمة الرئيسية
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 360, 0, 500)
Main.Position = UDim2.new(0.5, -180, 0.5, -250)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
Main.BorderSizePixel = 0
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 15)
local Stroke = Instance.new("UIStroke", Main)
Stroke.Color = Color3.fromRGB(100, 80, 200); Stroke.Thickness = 2

-- زر الإغلاق X
local CloseBtn = Instance.new("TextButton", Main)
CloseBtn.Size = UDim2.new(0, 35, 0, 35); CloseBtn.Position = UDim2.new(1, -45, 0, 10)
CloseBtn.Text = "X"; CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50); CloseBtn.TextColor3 = Color3.new(1, 1, 1)
CloseBtn.Font = Enum.Font.GothamBold; Instance.new("UICorner", CloseBtn)

-- زر الفتح (اللوجو العائم) - تم تعديله ليظهر بوضوح
local OpenBtn = Instance.new("TextButton", ScreenGui)
OpenBtn.Size = UDim2.new(0, 65, 0, 65)
OpenBtn.Position = UDim2.new(0, 20, 0.5, -32)
OpenBtn.BackgroundColor3 = Color3.fromRGB(30, 25, 50)
OpenBtn.Text = "RXT"
OpenBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
OpenBtn.Font = Enum.Font.GothamBold
OpenBtn.TextSize = 18
OpenBtn.Visible = false
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(1, 0)
local BtnStroke = Instance.new("UIStroke", OpenBtn)
BtnStroke.Color = Color3.fromRGB(150, 100, 255); BtnStroke.Thickness = 3

CloseBtn.MouseButton1Click:Connect(function() Main.Visible = false; OpenBtn.Visible = true end)
OpenBtn.MouseButton1Click:Connect(function() Main.Visible = true; OpenBtn.Visible = false end)

-- سحب القائمة
local d, ds, sp; Main.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then d = true ds = i.Position sp = Main.Position end end)
UserInputService.InputChanged:Connect(function(i) if d and i.UserInputType == Enum.UserInputType.MouseMovement then local delta = i.Position - ds Main.Position = UDim2.new(sp.X.Scale, sp.X.Offset + delta.X, sp.Y.Scale, sp.Y.Offset + delta.Y) end end)
UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then d = false end end)

-- التبويبات
local TabHolder = Instance.new("Frame", Main)
TabHolder.Size = UDim2.new(1, 0, 0, 50); TabHolder.BackgroundColor3 = Color3.fromRGB(25, 25, 35); Instance.new("UICorner", TabHolder)
local TabList = Instance.new("UIListLayout", TabHolder); TabList.FillDirection = Enum.FillDirection.Horizontal; TabList.HorizontalAlignment = Enum.HorizontalAlignment.Center; TabList.Padding = UDim.new(0, 5)

local Pages = Instance.new("Frame", Main); Pages.Size = UDim2.new(1, -20, 1, -90); Pages.Position = UDim2.new(0, 10, 0, 70); Pages.BackgroundTransparency = 1
local function CreatePage()
    local p = Instance.new("ScrollingFrame", Pages); p.Size = UDim2.new(1, 0, 1, 0); p.BackgroundTransparency = 1; p.Visible = false; p.ScrollBarThickness = 0
    Instance.new("UIListLayout", p).Padding = UDim.new(0, 10); return p
end
local PMain = CreatePage(); local PEvent = CreatePage(); local PTP = CreatePage(); PMain.Visible = true

local function AddTab(txt, pg)
    local b = Instance.new("TextButton", TabHolder); b.Size = UDim2.new(0, 90, 1, 0); b.Text = txt; b.TextColor3 = Color3.new(1,1,1); b.BackgroundTransparency = 1; b.Font = Enum.Font.GothamBold
    b.MouseButton1Click:Connect(function() PMain.Visible = false; PEvent.Visible = false; PTP.Visible = false; pg.Visible = true end)
end
AddTab("MAIN", PMain); AddTab("EVENT 🏆", PEvent); AddTab("TP", PTP)

local function AddBtn(parent, txt, cb)
    local b = Instance.new("TextButton", parent); b.Size = UDim2.new(1, 0, 0, 45); b.Text = txt; b.BackgroundColor3 = Color3.fromRGB(40, 35, 65); b.TextColor3 = Color3.new(1,1,1); b.Font = Enum.Font.GothamBold; Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function() cb(b) end); return b
end

-- [ MAIN ]
AddBtn(PMain, "🚫 No Ragdoll: OFF", function(b) noRagdollEnabled = not noRagdollEnabled; b.Text = noRagdollEnabled and "🚫 No Ragdoll: ON" or "🚫 No Ragdoll: OFF"; b.BackgroundColor3 = noRagdollEnabled and Color3.fromRGB(0, 120, 200) or Color3.fromRGB(40, 35, 65) end)
AddBtn(PMain, "🦘 Infinity Jump: OFF", function(b) infJumpEnabled = not infJumpEnabled; b.Text = infJumpEnabled and "🦘 Infinity Jump: ON" or "🦘 Infinity Jump: OFF" end)
local SpdInput = Instance.new("TextBox", PMain); SpdInput.Size = UDim2.new(1, 0, 0, 40); SpdInput.PlaceholderText = "Enter Speed (e.g. 100)"; SpdInput.BackgroundColor3 = Color3.fromRGB(25, 25, 40); SpdInput.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", SpdInput)
AddBtn(PMain, "🚀 Stealth Speed: OFF", function(b) stealthSpeedEnabled = not stealthSpeedEnabled; speedValue = tonumber(SpdInput.Text) or 50; b.Text = stealthSpeedEnabled and "🚀 Stealth Speed: ON" or "🚀 Stealth Speed: OFF" end)

-- [ EVENT ]
AddBtn(PEvent, "💰 Auto Farm Coins: OFF", function(b) 
    eventFarmEnabled = not eventFarmEnabled
    b.Text = eventFarmEnabled and "💰 Auto Farm Coins: ON" or "💰 Auto Farm Coins: OFF"
    b.BackgroundColor3 = eventFarmEnabled and Color3.fromRGB(0, 180, 100) or Color3.fromRGB(40, 35, 65)
end)
AddBtn(PEvent, "⚡ Instant E (Proximity): OFF", function(b) 
    instantInteractionEnabled = not instantInteractionEnabled
    b.Text = instantInteractionEnabled and "⚡ Instant E: ON" or "⚡ Instant E: OFF"
    if instantInteractionEnabled then for _,v in pairs(workspace:GetDescendants()) do if v:IsA("ProximityPrompt") then v.HoldDuration = 0 end end end
end)

-- [ TP ]
AddBtn(PTP, "📍 Save Position", function() if player.Character then savedPosition = player.Character.HumanoidRootPart.CFrame end end)
AddBtn(PTP, "🌀 Ghost Fast TP", function() if savedPosition then
    local root = player.Character.HumanoidRootPart
    local dist = (root.Position - savedPosition.Position).Magnitude
    local duration = dist / 150 -- سرعة 150 صاروخية
    local start = tick()
    local startCF = root.CFrame
    local conn; conn = RunService.Heartbeat:Connect(function()
        local elapsed = tick() - start
        if elapsed >= duration then root.CFrame = savedPosition; conn:Disconnect()
        else root.CFrame = startCF:Lerp(savedPosition, elapsed/duration); root.Velocity = Vector3.new(0,0,0) end
    end)
end end)

print("👑 RXT SERVER - EVENT UPDATE READY")
