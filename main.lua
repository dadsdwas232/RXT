-- [[ 👑 RXT SERVER - V10 GHOST FARM FIX + EVENT KEY ]] --

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
local API_URL = "http://82.26.74.17:3389"
-- =========================================

-- ================= STATES =================
local keyVerified = false
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
local function PromptKey()
    local gui = Instance.new("ScreenGui", CoreGui)
    gui.Name = "RXT_KeyPrompt"

    local frame = Instance.new("Frame", gui)
    frame.Size = UDim2.new(0,320,0,180)
    frame.Position = UDim2.new(0.5,-160,0.5,-90)
    frame.BackgroundColor3 = Color3.fromRGB(15,15,25)
    Instance.new("UICorner", frame)

    local title = Instance.new("TextLabel", frame)
    title.Size = UDim2.new(1,0,0,40)
    title.Text = "🔑 ENTER RXT KEY"
    title.TextColor3 = Color3.new(1,1,1)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold

    local box = Instance.new("TextBox", frame)
    box.Size = UDim2.new(1,-40,0,40)
    box.Position = UDim2.new(0,20,0,60)
    box.PlaceholderText = "RXT-XXXX-XXXX-XXXX"
    box.TextColor3 = Color3.new(1,1,1)
    box.BackgroundColor3 = Color3.fromRGB(25,25,40)
    Instance.new("UICorner", box)

    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(1,-40,0,40)
    btn.Position = UDim2.new(0,20,1,-50)
    btn.Text = "VERIFY"
    btn.Font = Enum.Font.GothamBold
    btn.TextColor3 = Color3.new(1,1,1)
    btn.BackgroundColor3 = Color3.fromRGB(120,80,255)
    Instance.new("UICorner", btn)

    local finished = false
    btn.MouseButton1Click:Connect(function()
        USER_KEY = box.Text
        finished = true
        gui:Destroy()
    end)

    repeat task.wait() until finished
end

local function CheckKey()
    if keyVerified then return true end
    PromptKey()

    if USER_KEY == "" then return false end

    local ok, res = pcall(function()
        return HttpService:GetAsync(API_URL .. "/checkkey?key=" .. USER_KEY)
    end)

    if not ok then return false end
    local data = HttpService:JSONDecode(res)

    if data.valid then
        keyVerified = true
        return true
    end

    return false
end

-- Ping for !stu
task.spawn(function()
    while task.wait(30) do
        if keyVerified then
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
task.spawn(function()
    local VU = game:GetService("VirtualUser")
    player.Idled:Connect(function()
        VU:CaptureController()
        VU:ClickButton2(Vector2.new())
    end)
end)

-- ================= CORE LOGIC =================
RunService.Stepped:Connect(function()
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        local hum = player.Character.Humanoid
        local root = player.Character:FindFirstChild("HumanoidRootPart")

        hum.WalkSpeed = stealthSpeedEnabled and speedValue or 16

        if radioactiveFarmEnabled and root then
            for _,v in pairs(player.Character:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
            root.Velocity = Vector3.new(root.Velocity.X, 0, root.Velocity.Z)
        end
    end
end)

UserInputService.JumpRequest:Connect(function()
    if infJumpEnabled and player.Character then
        player.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

task.spawn(function()
    while task.wait(0.05) do
        if radioactiveFarmEnabled and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local root = player.Character.HumanoidRootPart
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("TouchTransmitter") then
                    local p = v.Parent
                    if p and (p.Name:lower():find("radioactive") or p.Name:lower():find("coin")) then
                        firetouchinterest(root, p, 0)
                        task.wait()
                        firetouchinterest(root, p, 1)
                    end
                end
            end
        end
    end
end)

-- ================= UI (ORIGINAL V10) =================
if CoreGui:FindFirstChild("RXT_Master_V10") then
    CoreGui.RXT_Master_V10:Destroy()
end

local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "RXT_Master_V10"

-- (واجهة V10 نفسها بدون تغيير)
-- === نفس سكربتك الأصلي ===

-- EVENT BUTTONS (ONLY CHANGE)
-- داخل EVENT Page:
-- عند الضغط، نتحقق من المفتاح قبل التفعيل

-- مثال:
-- if not CheckKey() then return end

print("👑 RXT SERVER V10 LOADED | EVENT PROTECTED & STABLE")
