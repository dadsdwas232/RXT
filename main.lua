-- [[ 👑 RXT SERVER - ULTIMATE PRIVATE SCRIPT ]] --
-- Credits: RXT SERVER | Ghost Fast TP | Anti-AFK | No Ragdoll | Infinity Jump | Custom Speed

if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")
local player = Players.LocalPlayer

-- [ الإعدادات ]
local stealthSpeedEnabled = false
local speedValue = 50
local noclipEnabled = false
local godModeEnabled = false
local clickTpEnabled = false
local instantInteractionEnabled = false
local infJumpEnabled = false
local noRagdollEnabled = false
local savedPosition = nil

-- [1] نظام مانع الطرد (Anti-AFK)
local VirtualUser = game:GetService("VirtualUser")
player.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

-- [2] مانع السقوط (No Ragdoll)
RunService.Stepped:Connect(function()
    if noRagdollEnabled and player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
        local hum = player.Character:FindFirstChildOfClass("Humanoid")
        hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
        hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
        hum:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding, false)
    end
end)

-- [3] الانتقال الشبح السريع
local function ghostTP(targetCFrame)
    if not player.Character or not targetCFrame then return end
    local root = player.Character.HumanoidRootPart
    local distance = (root.Position - targetCFrame.Position).Magnitude
    local speed = 120 
    local duration = distance / speed
    local startTime = tick()
    local startCFrame = root.CFrame
    
    local connection
    connection = RunService.Heartbeat:Connect(function()
        local elapsed = tick() - startTime
        local fraction = elapsed / duration
        if fraction >= 1 then
            root.CFrame = targetCFrame
            connection:Disconnect()
        else
            root.CFrame = startCFrame:Lerp(targetCFrame, fraction)
            root.Velocity = Vector3.new(0, 0, 0)
        end
    end)
end

-- [4] محركات الحركة
RunService.Heartbeat:Connect(function(delta)
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local root = player.Character.HumanoidRootPart
        if stealthSpeedEnabled then
            local hum = player.Character:FindFirstChildOfClass("Humanoid")
            if hum.MoveDirection.Magnitude > 0 then
                root.CFrame = root.CFrame + (hum.MoveDirection * (speedValue / 8) * delta * 10)
            end
        end
        if noclipEnabled then
            for _, v in pairs(player.Character:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        end
        if godModeEnabled then player.Character.Humanoid.Health = 100 end
    end
end)

UserInputService.JumpRequest:Connect(function()
    if infJumpEnabled and player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
        player.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

-- [5] الواجهة (RXT SERVER)
if CoreGui:FindFirstChild("RXT_Final_UI") then CoreGui["RXT_Final_UI"]:Destroy() end
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "RXT_Final_UI"

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 350, 0, 520)
Main.Position = UDim2.new(0.5, -175, 0.5, -260)
Main.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
Main.Visible = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 20)

-- زر الإغلاق X
local CloseBtn = Instance.new("TextButton", Main)
CloseBtn.Size = UDim2.new(0, 35, 0, 35)
CloseBtn.Position = UDim2.new(1, -40, 0, 5)
CloseBtn.Text = "X"
CloseBtn.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
CloseBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", CloseBtn)

-- زر الفتح الصغير (الدائرة)
local OpenBtn = Instance.new("TextButton", ScreenGui)
OpenBtn.Size = UDim2.new(0, 60, 0, 60)
OpenBtn.Position = UDim2.new(0, 10, 0.5, -30)
OpenBtn.BackgroundColor3 = Color3.fromRGB(20, 15, 35)
OpenBtn.Text = "RXT"
OpenBtn.TextColor3 = Color3.fromRGB(200, 150, 255)
OpenBtn.Font = Enum.Font.GothamBold
OpenBtn.Visible = false
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(1, 0)
Instance.new("UIStroke", OpenBtn).Color = Color3.fromRGB(200, 150, 255)

CloseBtn.MouseButton1Click:Connect(function() Main.Visible = false; OpenBtn.Visible = true end)
OpenBtn.MouseButton1Click:Connect(function() Main.Visible = true; OpenBtn.Visible = false end)

-- نظام سحب القائمة
local d, ds, sp; Main.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then d = true ds = i.Position sp = Main.Position end end)
UserInputService.InputChanged:Connect(function(i) if d and i.UserInputType == Enum.UserInputType.MouseMovement then local delta = i.Position - ds Main.Position = UDim2.new(sp.X.Scale, sp.X.Offset + delta.X, sp.Y.Scale, sp.Y.Offset + delta.Y) end end)
UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then d = false end end)

-- التبويبات
local TabHolder = Instance.new("Frame", Main)
TabHolder.Size = UDim2.new(1, 0, 0, 45); TabHolder.BackgroundColor3 = Color3.fromRGB(25, 20, 45); Instance.new("UICorner", TabHolder)
local TabList = Instance.new("UIListLayout", TabHolder); TabList.FillDirection = Enum.FillDirection.Horizontal; TabList.HorizontalAlignment = Enum.HorizontalAlignment.Center; TabList.Padding = UDim.new(0, 10)

local Pages = Instance.new("Frame", Main); Pages.Size = UDim2.new(1, -20, 1, -85); Pages.Position = UDim2.new(0, 10, 0, 65); Pages.BackgroundTransparency = 1
local function CreatePage()
    local p = Instance.new("ScrollingFrame", Pages); p.Size = UDim2.new(1, 0, 1, 0); p.BackgroundTransparency = 1; p.Visible = false; p.ScrollBarThickness = 0
    Instance.new("UIListLayout", p).Padding = UDim.new(0, 10); return p
end
local PMain = CreatePage(); local PWorld = CreatePage(); local PTP = CreatePage(); PMain.Visible = true

local function AddTab(txt, pg)
    local b = Instance.new("TextButton", TabHolder); b.Size = UDim2.new(0, 85, 1, 0); b.Text = txt; b.TextColor3 = Color3.new(1,1,1); b.BackgroundTransparency = 1; b.Font = Enum.Font.GothamBold
    b.MouseButton1Click:Connect(function() PMain.Visible = false; PWorld.Visible = false; PTP.Visible = false; pg.Visible = true end)
end
AddTab("MAIN", PMain); AddTab("WORLD", PWorld); AddTab("TP", PTP)

local function AddBtn(parent, txt, cb)
    local b = Instance.new("TextButton", parent); b.Size = UDim2.new(1, 0, 0, 45); b.Text = txt; b.BackgroundColor3 = Color3.fromRGB(35, 30, 60); b.TextColor3 = Color3.new(1,1,1); b.Font = Enum.Font.GothamBold; Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function() cb(b) end); return b
end

-- [ MAIN ]
AddBtn(PMain, "🛡️ God Mode: OFF", function(b) godModeEnabled = not godModeEnabled; b.Text = godModeEnabled and "🛡️ God Mode: ON" or "🛡️ God Mode: OFF"; b.BackgroundColor3 = godModeEnabled and Color3.fromRGB(150, 0, 50) or Color3.fromRGB(35, 30, 60) end)
AddBtn(PMain, "🚫 No Ragdoll: OFF", function(b) noRagdollEnabled = not noRagdollEnabled; b.Text = noRagdollEnabled and "🚫 No Ragdoll: ON" or "🚫 No Ragdoll: OFF"; b.BackgroundColor3 = noRagdollEnabled and Color3.fromRGB(0, 100, 150) or Color3.fromRGB(35, 30, 60) end)
AddBtn(PMain, "🧱 NoClip: OFF", function(b) noclipEnabled = not noclipEnabled; b.Text = noclipEnabled and "🧱 NoClip: ON" or "🧱 NoClip: OFF" end)
AddBtn(PMain, "🦘 Infinity Jump: OFF", function(b) infJumpEnabled = not infJumpEnabled; b.Text = infJumpEnabled and "🦘 Infinity Jump: ON" or "🦘 Infinity Jump: OFF" end)

local SpdInput = Instance.new("TextBox", PMain); SpdInput.Size = UDim2.new(1, 0, 0, 40); SpdInput.PlaceholderText = "Speed Value (50-200)..."; SpdInput.BackgroundColor3 = Color3.fromRGB(20, 20, 35); SpdInput.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", SpdInput)
AddBtn(PMain, "🚀 Stealth Speed: OFF", function(b) stealthSpeedEnabled = not stealthSpeedEnabled; speedValue = tonumber(SpdInput.Text) or 50; b.Text = stealthSpeedEnabled and "🚀 Stealth Speed: ON" or "🚀 Stealth Speed: OFF" end)

-- [ WORLD ]
AddBtn(PWorld, "💤 Anti-AFK: ACTIVE ✅", function() end)
AddBtn(PWorld, "⚡ FPS BOOST", function(b) for _,v in pairs(game:GetDescendants()) do if v:IsA("BasePart") then v.Material = "SmoothPlastic" end end; b.Text = "✅ FPS BOOSTED" end)
AddBtn(PWorld, "👁️ Unlock Zoom", function() player.CameraMaxZoomDistance = 100000 end)

-- [ TP ]
AddBtn(PTP, "📍 Save Position", function() if player.Character then savedPosition = player.Character.HumanoidRootPart.CFrame end end)
AddBtn(PTP, "🌀 Ghost Fast TP", function() if savedPosition then ghostTP(savedPosition) end end)
AddBtn(PTP, "🖱️ Click TP: OFF", function(b) clickTpEnabled = not clickTpEnabled; b.Text = clickTpEnabled and "🖱️ Click TP: ON" or "🖱️ Click TP: OFF" end)
AddBtn(PTP, "⚡ Instant E: OFF", function(b) instantInteractionEnabled = not instantInteractionEnabled; b.Text = instantInteractionEnabled and "⚡ Instant E: ON" or "⚡ Instant E: OFF"; if instantInteractionEnabled then for _,v in pairs(workspace:GetDescendants()) do if v:IsA("ProximityPrompt") then v.HoldDuration = 0 end end end end)

-- حقوق الأسفل
local Footer = Instance.new("TextLabel", Main)
Footer.Size = UDim2.new(1, 0, 0, 30); Footer.Position = UDim2.new(0, 0, 1, -30)
Footer.Text = "RXT SERVER | OFFICIAL EXCLUSIVE"; Footer.TextColor3 = Color3.fromRGB(150, 150, 255); Footer.BackgroundTransparency = 1; Footer.Font = Enum.Font.GothamBold; Footer.TextSize = 12

print("👑 RXT SERVER - LOADED SUCCESSFULLY")
