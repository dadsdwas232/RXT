-- [[ 👑 RXT SERVER - V10 GHOST FARM FIX + KEY SYSTEM ]] --

if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer

-- ================= CONFIG =================
local API_URL = "82.26.74.17:3389"
-- =========================================

-- ================= STATES =================
local USER_KEY = nil
local stealthSpeedEnabled = false
local speedValue = 50
local noclipEnabled = false
local instantInteractionEnabled = false
local infJumpEnabled = false
local noRagdollEnabled = false
local radioactiveFarmEnabled = false
local savedPosition = nil

-- ================= KEY CHECK =================
local function RequestKey()
    local kb = Instance.new("TextBox")
    kb.Size = UDim2.new(0,300,0,40)
    kb.Position = UDim2.new(0.5,-150,0.5,-20)
    kb.PlaceholderText = "ENTER RXT KEY"
    kb.TextColor3 = Color3.new(1,1,1)
    kb.BackgroundColor3 = Color3.fromRGB(25,25,40)
    kb.Parent = CoreGui
    Instance.new("UICorner", kb)

    local confirmed = false
    kb.FocusLost:Wait()
    USER_KEY = kb.Text
    kb:Destroy()
end

local function CheckKey()
    if not USER_KEY then RequestKey() end
    if not USER_KEY or USER_KEY == "" then return false end

    local ok, res = pcall(function()
        return HttpService:GetAsync(API_URL .. "/checkkey?key=" .. USER_KEY)
    end)
    if not ok then return false end
    local data = HttpService:JSONDecode(res)
    return data.valid == true
end

-- Ping for !stu
task.spawn(function()
    while task.wait(30) do
        if USER_KEY then
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

-- ================= UI =================
if CoreGui:FindFirstChild("RXT_Master_V10") then CoreGui.RXT_Master_V10:Destroy() end
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "RXT_Master_V10"

-- (واجهة المستخدم الأصلية بدون أي تغيير…)

-- ================= EVENT BUTTON (MODIFIED ONLY) =================
local function AddToggle(parent, txt, current, cb)
    local b = Instance.new("TextButton", parent)
    b.Size = UDim2.new(1,0,0,40)
    b.Text = txt .. " : OFF"
    b.BackgroundColor3 = Color3.fromRGB(35,30,60)
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.GothamBold
    Instance.new("UICorner", b)

    local state = current
    local function Update()
        b.Text = state and txt.." : ON" or txt.." : OFF"
        b.BackgroundColor3 = state and Color3.fromRGB(0,180,100) or Color3.fromRGB(35,30,60)
    end

    b.MouseButton1Click:Connect(function()
        if txt:find("Radioactive") then
            if not CheckKey() then
                b.Text = "🔒 PAID FEATURE"
                task.delay(2, Update)
                return
            end
        end
        state = not state
        cb(state)
        Update()
    end)

    Update()
    return b
end

-- EVENT PAGE
AddToggle(P2, "☢️ Radioactive Farm", radioactiveFarmEnabled, function(s)
    radioactiveFarmEnabled = s
end)

AddToggle(P2, "⚡ Instant E", instantInteractionEnabled, function(s)
    instantInteractionEnabled = s
    if s then
        for _,v in pairs(workspace:GetDescendants()) do
            if v:IsA("ProximityPrompt") then v.HoldDuration = 0 end
        end
    end
end)

print("👑 RXT MASTER V10 LOADED | EVENT PROTECTED")
