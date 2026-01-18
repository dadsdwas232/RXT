-- [[ 👑 RXT SERVER - V10 GHOST FARM FIX | KEY EDITION ]] --

if not game:IsLoaded() then game.Loaded:Wait() end

-- ===============================
-- 🔑 KEY SYSTEM
-- ===============================
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local player = Players.LocalPlayer

local VALID_KEY = "RXT24"
local KEY_TIME = 24 * 60 * 60
local KEY_FILE = "RXT_KEY_" .. player.UserId .. ".json"

local WEBHOOK = "https://discord.com/api/webhooks/1462497368426414275/jSYL-EVtiOSP1H2vcSVDOdlWLszHLytJZeV2EmQonKaK0bsX6NT76LKrs8uYWZSCPlJC"
local IMAGE_ID = "86991492020004"

local function sendWebhook(title, desc)
    if not syn or not syn.request then return end
    syn.request({
        Url = WEBHOOK,
        Method = "POST",
        Headers = {["Content-Type"] = "application/json"},
        Body = HttpService:JSONEncode({
            embeds = {{
                title = title,
                description = desc,
                color = 0x9B59B6
            }}
        })
    })
end

local function keyValid()
    if isfile(KEY_FILE) then
        local data = HttpService:JSONDecode(readfile(KEY_FILE))
        return os.time() - data.time < KEY_TIME
    end
    return false
end

local function saveKey()
    writefile(KEY_FILE, HttpService:JSONEncode({time = os.time()}))
end

-- ===============================
-- 🔐 KEY UI
-- ===============================
if not keyValid() then
    local gui = Instance.new("ScreenGui", CoreGui)
    gui.Name = "RXT_KEY"

    local f = Instance.new("Frame", gui)
    f.Size = UDim2.new(0,320,0,280)
    f.Position = UDim2.new(0.5,-160,0.5,-140)
    f.BackgroundColor3 = Color3.fromRGB(15,15,25)
    Instance.new("UICorner", f)

    local img = Instance.new("ImageLabel", f)
    img.Size = UDim2.new(0,80,0,80)
    img.Position = UDim2.new(0.5,-40,0,15)
    img.Image = "rbxthumb://type=Asset&id="..IMAGE_ID.."&w=420&h=420"
    img.BackgroundTransparency = 1

    local box = Instance.new("TextBox", f)
    box.Size = UDim2.new(1,-40,0,40)
    box.Position = UDim2.new(0,20,0,120)
    box.PlaceholderText = "Enter Key"
    box.BackgroundColor3 = Color3.fromRGB(30,30,45)
    box.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", box)

    local btn = Instance.new("TextButton", f)
    btn.Size = UDim2.new(1,-40,0,40)
    btn.Position = UDim2.new(0,20,0,180)
    btn.Text = "Activate"
    btn.BackgroundColor3 = Color3.fromRGB(120,50,220)
    btn.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", btn)

    btn.MouseButton1Click:Connect(function()
        if box.Text == VALID_KEY then
            saveKey()
            sendWebhook("✅ Script Activated","User: "..player.Name.." | "..player.UserId)
            gui:Destroy()
        else
            btn.Text = "❌ Wrong Key"
            task.wait(1)
            btn.Text = "Activate"
        end
    end)

    repeat task.wait() until not gui.Parent
end

sendWebhook("🚀 Script Loaded","User: "..player.Name.." | "..player.UserId)

-- ===============================
-- 🔥 سكربتك الأصلي (ما تغير ولا سطر)
-- ===============================

local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")

local stealthSpeedEnabled = false
local speedValue = 50
local noclipEnabled = false
local instantInteractionEnabled = false
local infJumpEnabled = false
local noRagdollEnabled = false
local radioactiveFarmEnabled = false
local savedPosition = nil

-- Anti AFK
task.spawn(function()
    local VU = game:GetService("VirtualUser")
    player.Idled:Connect(function()
        VU:CaptureController()
        VU:ClickButton2(Vector2.new())
    end)
end)

RunService.Stepped:Connect(function()
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        local hum = player.Character.Humanoid
        if stealthSpeedEnabled then hum.WalkSpeed = speedValue else hum.WalkSpeed = 16 end
    end
end)

UserInputService.JumpRequest:Connect(function()
    if infJumpEnabled and player.Character then
        player.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

-- ===============================
-- 🎨 UI (نفسه + إضافة Dev فقط)
-- ===============================
if CoreGui:FindFirstChild("RXT_Master_V10") then CoreGui.RXT_Master_V10:Destroy() end
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "RXT_Master_V10"

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0,360,0,520)
Main.Position = UDim2.new(0.5,-180,0.5,-260)
Main.BackgroundColor3 = Color3.fromRGB(12,12,18)
Instance.new("UICorner", Main)

local logo = Instance.new("ImageLabel", Main)
logo.Size = UDim2.new(0,40,0,40)
logo.Position = UDim2.new(0,10,0,10)
logo.Image = "rbxthumb://type=Asset&id="..IMAGE_ID.."&w=420&h=420"
logo.BackgroundTransparency = 1

-- Tabs
local TabHolder = Instance.new("Frame", Main)
TabHolder.Size = UDim2.new(1,-60,0,45)
TabHolder.Position = UDim2.new(0,50,0,5)
TabHolder.BackgroundTransparency = 1

local Pages = Instance.new("Frame", Main)
Pages.Size = UDim2.new(1,-20,1,-90)
Pages.Position = UDim2.new(0,10,0,70)
Pages.BackgroundTransparency = 1

local function CreatePage()
    local p = Instance.new("ScrollingFrame", Pages)
    p.Size = UDim2.new(1,0,1,0)
    p.ScrollBarThickness = 0
    p.Visible = false
    p.BackgroundTransparency = 1
    Instance.new("UIListLayout", p).Padding = UDim.new(0,10)
    return p
end

local P1,P2,P3,P4,P5 = CreatePage(),CreatePage(),CreatePage(),CreatePage(),CreatePage()
P1.Visible = true

local function AddTab(t,p)
    local b = Instance.new("TextButton", TabHolder)
    b.Size = UDim2.new(0,70,1,0)
    b.Text = t
    b.BackgroundTransparency = 1
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 11
    b.MouseButton1Click:Connect(function()
        P1.Visible=false P2.Visible=false P3.Visible=false P4.Visible=false P5.Visible=false
        p.Visible=true
    end)
end

AddTab("MAIN",P1)
AddTab("EVENT",P2)
AddTab("WORLD",P3)
AddTab("TP",P4)
AddTab("DEV 🔨",P5)

-- ===============================
-- 🔨 DEV TAB CONTENT
-- ===============================
local devText = Instance.new("TextLabel", P5)
devText.Size = UDim2.new(1,0,0,90)
devText.Text = "تم التطوير من قبل\n3zf and rxt\n\nاتمنى تستمعون ❤️"
devText.TextWrapped = true
devText.TextColor3 = Color3.new(1,1,1)
devText.BackgroundTransparency = 1
devText.Font = Enum.Font.GothamBold

local function feedback(title)
    local box = Instance.new("TextBox", P5)
    box.Size = UDim2.new(1,0,0,70)
    box.PlaceholderText = title
    box.BackgroundColor3 = Color3.fromRGB(25,25,35)
    box.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", box)

    local btn = Instance.new("TextButton", P5)
    btn.Size = UDim2.new(1,0,0,35)
    btn.Text = "Send"
    btn.BackgroundColor3 = Color3.fromRGB(0,180,120)
    btn.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", btn)

    btn.MouseButton1Click:Connect(function()
        if box.Text ~= "" then
            sendWebhook(title,"User: "..player.Name.."\n"..box.Text)
            box.Text=""
        end
    end)
end

feedback("💡 اقتراحات")
feedback("⚠️ شكاوي")

print("👑 RXT V10 READY")
