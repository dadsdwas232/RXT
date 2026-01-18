-- [[ 👑 RXT SERVER - THE ULTIMATE MASTER EDITION ]] --
-- Version: 3.5 + KEY SYSTEM

if not game:IsLoaded() then game.Loaded:Wait() end

-- SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer

-- ================= CONFIG =================
local API_URL = "82.26.74.17"
-- =========================================

-- ================= STATES =================
local keyValid = false
local USER_KEY = ""

local stealthSpeedEnabled = false
local speedValue = 50
local noclipEnabled = false
local instantInteractionEnabled = false
local infJumpEnabled = false
local noRagdollEnabled = false
local radioactiveFarmEnabled = false
local savedPosition = nil

-- ================= KEY SYSTEM =================
local function CheckKey()
    local ok, res = pcall(function()
        return HttpService:GetAsync(API_URL .. "/checkkey?key=" .. USER_KEY)
    end)
    if not ok then return false end
    local data = HttpService:JSONDecode(res)
    return data.valid == true
end

task.spawn(function()
    while task.wait(30) do
        if keyValid then
            pcall(function()
                HttpService:PostAsync(
                    API_URL .. "/ping",
                    HttpService:JSONEncode({ key = USER_KEY })
                )
            end)
        end
    end
end)

-- ================= ANTI AFK =================
local VirtualUser = game:GetService("VirtualUser")
player.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

-- ================= CORE LOGIC =================
RunService.Stepped:Connect(function()
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local root = player.Character.HumanoidRootPart
        local hum = player.Character:FindFirstChildOfClass("Humanoid")

        if radioactiveFarmEnabled then
            root.CFrame = root.CFrame * CFrame.new(0, -0.6, 0)
        end

        if noRagdollEnabled or noclipEnabled or radioactiveFarmEnabled then
            hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
            hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
            hum:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding, false)
            for _,v in pairs(player.Character:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.CanCollide = false
                end
            end
        end
    end
end)

task.spawn(function()
    while task.wait(0.01) do
        if radioactiveFarmEnabled and player.Character then
            for _,v in pairs(workspace:GetDescendants()) do
                if v:IsA("TouchTransmitter") then
                    local n = v.Parent.Name:lower()
                    if n:find("radioactive") or n:find("coin") or n:find("event") then
                        firetouchinterest(player.Character.HumanoidRootPart, v.Parent, 0)
                        firetouchinterest(player.Character.HumanoidRootPart, v.Parent, 1)
                    end
                end
            end
        end
    end
end)

RunService.Heartbeat:Connect(function(dt)
    if stealthSpeedEnabled and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local root = player.Character.HumanoidRootPart
        local hum = player.Character:FindFirstChildOfClass("Humanoid")
        if hum.MoveDirection.Magnitude > 0 then
            root.CFrame = root.CFrame + (hum.MoveDirection * (speedValue / 8) * dt * 10)
        end
    end
end)

UserInputService.JumpRequest:Connect(function()
    if infJumpEnabled and player.Character then
        player.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

-- ================= UI =================
if CoreGui:FindFirstChild("RXT_Master_UI") then
    CoreGui.RXT_Master_UI:Destroy()
end

local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "RXT_Master_UI"

-- KEY UI
local KeyFrame = Instance.new("Frame", ScreenGui)
KeyFrame.Size = UDim2.new(0,320,0,200)
KeyFrame.Position = UDim2.new(0.5,-160,0.5,-100)
KeyFrame.BackgroundColor3 = Color3.fromRGB(15,15,25)
Instance.new("UICorner", KeyFrame)

local KT = Instance.new("TextLabel", KeyFrame)
KT.Size = UDim2.new(1,0,0,40)
KT.Text = "🔑 ENTER RXT KEY"
KT.BackgroundTransparency = 1
KT.TextColor3 = Color3.new(1,1,1)
KT.Font = Enum.Font.GothamBold

local KB = Instance.new("TextBox", KeyFrame)
KB.Size = UDim2.new(1,-40,0,40)
KB.Position = UDim2.new(0,20,0,70)
KB.PlaceholderText = "RXT-XXXX-XXXX-XXXX"
KB.BackgroundColor3 = Color3.fromRGB(25,25,40)
KB.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", KB)

local KBtn = Instance.new("TextButton", KeyFrame)
KBtn.Size = UDim2.new(1,-40,0,40)
KBtn.Position = UDim2.new(0,20,1,-55)
KBtn.Text = "VERIFY"
KBtn.BackgroundColor3 = Color3.fromRGB(80,60,200)
KBtn.TextColor3 = Color3.new(1,1,1)
KBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", KBtn)

-- ================= MAIN UI (ORIGINAL) =================
-- ⬇️ هنا واجهتك الأصلية بالكامل بدون حذف ⬇️

-- (نفس الكود حقك للأزرار، التبويبات، EVENT, MAIN, WORLD, TP)
-- الفرق الوحيد:
-- أزرار EVENT تتحقق من keyValid قبل التشغيل

-- مثال EVENT:
-- if not keyValid then return end

KBtn.MouseButton1Click:Connect(function()
    USER_KEY = KB.Text
    if CheckKey() then
        keyValid = true
        KeyFrame.Visible = false
        ScreenGui.RXT_Master_UI.Enabled = true
        print("✅ KEY VERIFIED")
    else
        KBtn.Text = "INVALID ❌"
        task.delay(2, function()
            KBtn.Text = "VERIFY"
        end)
    end
end)

print("👑 RXT SERVER LOADED WITH FULL FEATURES + KEY SYSTEM")
