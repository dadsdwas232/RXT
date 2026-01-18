-- [[ 👑 RXT SERVER - RADIOACTIVE EVENT EDITION ]] --
-- Special: Radioactive Coin Farm | Underground Stealth | Ghost TP

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
local radioactiveFarmEnabled = false
local savedPosition = nil

-- [1] نظام مانع الطرد ومانع السقوط
local VirtualUser = game:GetService("VirtualUser")
player.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

-- [2] محرك الحركة (النزول تحت الأرض عند الفارمينج)
RunService.Stepped:Connect(function()
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local root = player.Character.HumanoidRootPart
        local hum = player.Character:FindFirstChildOfClass("Humanoid")
        
        if radioactiveFarmEnabled then
            -- النزول تحت الأرض بشوي للتخفي عن اللاعبين والحماية
            root.CFrame = root.CFrame * CFrame.new(0, -0.6, 0)
            -- تعطيل الاصطدام عشان ما تعلق في الأرض
            for _, v in pairs(player.Character:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        end

        if noRagdollEnabled then
            hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
            hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
            hum:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding, false)
        end
    end
end)

-- [3] تجميع Radioactive Coins تلقائياً
task.spawn(function()
    while task.wait(0.01) do -- سرعة استجابة فائقة
        if radioactiveFarmEnabled and player.Character then
            for _, v in pairs(workspace:GetDescendants()) do
                -- البحث عن العملات المشعة بالاسم أو النوع
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

-- [4] الواجهة (RXT SERVER)
if CoreGui:FindFirstChild("RXT_Radioactive_UI") then CoreGui["RXT_Radioactive_UI"]:Destroy() end
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "RXT_Radioactive_UI"

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 350, 0, 500)
Main.Position = UDim2.new(0.5, -175, 0.5, -250)
Main.BackgroundColor3 = Color3.fromRGB(10, 15, 10) -- لون أخضر غامق خفيف للإيفنت
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 20)
local Stroke = Instance.new("UIStroke", Main)
Stroke.Color = Color3.fromRGB(50, 255, 50); Stroke.Thickness = 2 -- توهج أخضر مشع

-- أزرار التحكم
local CloseBtn = Instance.new("TextButton", Main)
CloseBtn.Size = UDim2.new(0, 30, 0, 30); CloseBtn.Position = UDim2.new(1, -40, 0, 10)
CloseBtn.Text = "X"; CloseBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0); CloseBtn.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", CloseBtn)

local OpenBtn = Instance.new("TextButton", ScreenGui)
OpenBtn.Size = UDim2.new(0, 60, 0, 60); OpenBtn.Position = UDim2.new(0, 15, 0.5, -30)
OpenBtn.BackgroundColor3 = Color3.fromRGB(20, 40, 20); OpenBtn.Text = "RXT"; OpenBtn.TextColor3 = Color3.fromRGB(50, 255, 50)
OpenBtn.Font = Enum.Font.GothamBold; OpenBtn.Visible = false; Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(1,0)

CloseBtn.MouseButton1Click:Connect(function() Main.Visible = false; OpenBtn.Visible = true end)
OpenBtn.MouseButton1Click:Connect(function() Main.Visible = true; OpenBtn.Visible = false end)

-- نظام سحب القائمة
local d, ds, sp; Main.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then d = true ds = i.Position sp = Main.Position end end)
UserInputService.InputChanged:Connect(function(i) if d and i.UserInputType == Enum.UserInputType.MouseMovement then local delta = i.Position - ds Main.Position = UDim2.new(sp.X.Scale, sp.X.Offset + delta.X, sp.Y.Scale, sp.Y.Offset + delta.Y) end end)
UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then d = false end end)

-- التبويبات
local TabHolder = Instance.new("Frame", Main)
TabHolder.Size = UDim2.new(1, 0, 0, 45); TabHolder.BackgroundColor3 = Color3.fromRGB(20, 30, 20); Instance.new("UICorner", TabHolder)
local TabList = Instance.new("UIListLayout", TabHolder); TabList.FillDirection = Enum.FillDirection.Horizontal; TabList.HorizontalAlignment = Enum.HorizontalAlignment.Center; TabList.Padding = UDim.new(0, 10)

local Pages = Instance.new("Frame", Main); Pages.Size = UDim2.new(1, -20, 1, -85); Pages.Position = UDim2.new(0, 10, 0, 65); Pages.BackgroundTransparency = 1
local function CreatePage()
    local p = Instance.new("ScrollingFrame", Pages); p.Size = UDim2.new(1, 0, 1, 0); p.BackgroundTransparency = 1; p.Visible = false; p.ScrollBarThickness = 0
    Instance.new("UIListLayout", p).Padding = UDim.new(0, 8); return p
end
local PMain = CreatePage(); local PFarm = CreatePage(); local PTP = CreatePage(); PMain.Visible = true

local function AddTab(txt, pg)
    local b = Instance.new("TextButton", TabHolder); b.Size = UDim2.new(0, 85, 1, 0); b.Text = txt; b.TextColor3 = Color3.new(1,1,1); b.BackgroundTransparency = 1; b.Font = Enum.Font.GothamBold
    b.MouseButton1Click:Connect(function() PMain.Visible = false; PFarm.Visible = false; PTP.Visible = false; pg.Visible = true end)
end
AddTab("MAIN", PMain); AddTab("EVENT ☢️", PFarm); AddTab("TP", PTP)

local function AddBtn(parent, txt, cb)
    local b = Instance.new("TextButton", parent); b.Size = UDim2.new(1, 0, 0, 42); b.Text = txt; b.BackgroundColor3 = Color3.fromRGB(30, 45, 30); b.TextColor3 = Color3.new(1,1,1); b.Font = Enum.Font.GothamBold; Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function() cb(b) end); return b
end

-- الأزرار
AddBtn(PMain, "🚫 No Ragdoll: OFF", function(b) noRagdollEnabled = not noRagdollEnabled; b.Text = noRagdollEnabled and "🚫 No Ragdoll: ON" or "🚫 No Ragdoll: OFF" end)
AddBtn(PMain, "🦘 Infinity Jump: OFF", function(b) infJumpEnabled = not infJumpEnabled; b.Text = infJumpEnabled and "🦘 Infinity Jump: ON" or "🦘 Infinity Jump: OFF" end)
local SpdInput = Instance.new("TextBox", PMain); SpdInput.Size = UDim2.new(1, 0, 0, 35); SpdInput.PlaceholderText = "Speed..."; SpdInput.BackgroundColor3 = Color3.fromRGB(20, 30, 20); SpdInput.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", SpdInput)
AddBtn(PMain, "🚀 Stealth Speed: OFF", function(b) stealthSpeedEnabled = not stealthSpeedEnabled; speedValue = tonumber(SpdInput.Text) or 50; b.Text = stealthSpeedEnabled and "🚀 Stealth Speed: ON" or "🚀 Stealth Speed: OFF" end)

-- قسم الإيفنت
AddBtn(PFarm, "☢️ Radioactive Farm: OFF", function(b)
    radioactiveFarmEnabled = not radioactiveFarmEnabled
    b.Text = radioactiveFarmEnabled and "☢️ Radioactive Farm: ON" or "☢️ Radioactive Farm: OFF"
    b.BackgroundColor3 = radioactiveFarmEnabled and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(30, 45, 30)
end)
AddBtn(PFarm, "⚡ Instant E: OFF", function(b)
    instantInteractionEnabled = not instantInteractionEnabled
    if instantInteractionEnabled then for _,v in pairs(workspace:GetDescendants()) do if v:IsA("ProximityPrompt") then v.HoldDuration = 0 end end end
end)

-- قسم الانتقال
AddBtn(PTP, "📍 Save Position", function() if player.Character then savedPosition = player.Character.HumanoidRootPart.CFrame end end)
AddBtn(PTP, "🌀 Ghost Smooth TP", function() if savedPosition then
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

local Footer = Instance.new("TextLabel", Main); Footer.Size = UDim2.new(1, 0, 0, 30); Footer.Position = UDim2.new(0, 0, 1, -30); Footer.Text = "RXT SERVER | RADIOACTIVE SPECIAL"; Footer.TextColor3 = Color3.fromRGB(50, 255, 50); Footer.BackgroundTransparency = 1; Footer.Font = Enum.Font.GothamBold

print("👑 RXT RADIOACTIVE MASTER LOADED")
