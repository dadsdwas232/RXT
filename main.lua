-- [[ 👑 RXT SERVER - V10 | KEY SYSTEM EDITION ]] --

if not game:IsLoaded() then game.Loaded:Wait() end

-- ===============================
-- 🔑 KEY SYSTEM CONFIG
-- ===============================
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local player = Players.LocalPlayer

local VALID_KEY = "RXT24"
local KEY_DURATION = 24 * 60 * 60
local KEY_FILE = "RXT_KEY_" .. player.UserId .. ".json"

local WEBHOOK = "https://discord.com/api/webhooks/1462497368426414275/jSYL-EVtiOSP1H2vcSVDOdlWLszHLytJZeV2EmQonKaK0bsX6NT76LKrs8uYWZSCPlJC"
local IMAGE_ID = "86991492020004"

-- ===============================
-- 🔧 FUNCTIONS
-- ===============================
local function sendWebhook(title, message)
    if not syn or not syn.request then return end
    syn.request({
        Url = WEBHOOK,
        Method = "POST",
        Headers = {["Content-Type"] = "application/json"},
        Body = HttpService:JSONEncode({
            username = "RXT V10",
            embeds = {{
                title = title,
                description = message,
                color = 0x9B59B6,
                footer = { text = "RXT SERVER" }
            }}
        })
    })
end

local function isKeyValid()
    if isfile(KEY_FILE) then
        local data = HttpService:JSONDecode(readfile(KEY_FILE))
        return os.time() - data.time < KEY_DURATION
    end
    return false
end

local function saveKey()
    writefile(KEY_FILE, HttpService:JSONEncode({ time = os.time() }))
end

-- ===============================
-- 🔐 KEY UI
-- ===============================
if not isKeyValid() then
    local gui = Instance.new("ScreenGui", CoreGui)
    gui.Name = "RXT_KEY_UI"

    local frame = Instance.new("Frame", gui)
    frame.Size = UDim2.new(0, 330, 0, 300)
    frame.Position = UDim2.new(0.5, -165, 0.5, -150)
    frame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 15)

    local img = Instance.new("ImageLabel", frame)
    img.Size = UDim2.new(0, 90, 0, 90)
    img.Position = UDim2.new(0.5, -45, 0, 15)
    img.Image = "rbxthumb://type=Asset&id=" .. IMAGE_ID .. "&w=420&h=420"
    img.BackgroundTransparency = 1

    local box = Instance.new("TextBox", frame)
    box.Size = UDim2.new(1, -40, 0, 40)
    box.Position = UDim2.new(0, 20, 0, 130)
    box.PlaceholderText = "Enter Key"
    box.Text = ""
    box.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    box.TextColor3 = Color3.new(1, 1, 1)
    box.Font = Enum.Font.GothamBold
    Instance.new("UICorner", box)

    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(1, -40, 0, 40)
    btn.Position = UDim2.new(0, 20, 0, 190)
    btn.Text = "Activate"
    btn.BackgroundColor3 = Color3.fromRGB(120, 50, 220)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", btn)

    btn.MouseButton1Click:Connect(function()
        if box.Text == VALID_KEY then
            saveKey()

            sendWebhook(
                "✅ Script Activated",
                "**User:** " .. player.Name .. "\n**UserId:** " .. player.UserId
            )

            gui:Destroy()
        else
            btn.Text = "❌ Wrong Key"
            task.wait(1)
            btn.Text = "Activate"
        end
    end)

    repeat task.wait() until not gui.Parent
end

-- ===============================
-- 📢 SEND START WEBHOOK
-- ===============================
sendWebhook(
    "🚀 Script Loaded",
    "**User:** " .. player.Name .. "\n**UserId:** " .. player.UserId
)

-- ===============================
-- 🎨 MAIN UI
-- ===============================
if CoreGui:FindFirstChild("RXT_Master_V10") then
    CoreGui.RXT_Master_V10:Destroy()
end

local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "RXT_Master_V10"

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 360, 0, 520)
Main.Position = UDim2.new(0.5, -180, 0.5, -260)
Main.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
Main.BorderSizePixel = 0
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 15)

-- 🖼️ Logo
local logo = Instance.new("ImageLabel", Main)
logo.Size = UDim2.new(0, 40, 0, 40)
logo.Position = UDim2.new(0, 10, 0, 10)
logo.Image = "rbxthumb://type=Asset&id=" .. IMAGE_ID .. "&w=420&h=420"
logo.BackgroundTransparency = 1

-- ===============================
-- 📂 TABS
-- ===============================
local Pages = Instance.new("Frame", Main)
Pages.Size = UDim2.new(1, -20, 1, -80)
Pages.Position = UDim2.new(0, 10, 0, 60)
Pages.BackgroundTransparency = 1

local function CreatePage()
    local p = Instance.new("ScrollingFrame", Pages)
    p.Size = UDim2.new(1, 0, 1, 0)
    p.ScrollBarThickness = 0
    p.BackgroundTransparency = 1
    p.Visible = false
    Instance.new("UIListLayout", p).Padding = UDim.new(0, 10)
    return p
end

local DEV = CreatePage()
DEV.Visible = true

-- ===============================
-- 🔨 DEV TAB
-- ===============================
local devText = Instance.new("TextLabel", DEV)
devText.Size = UDim2.new(1, 0, 0, 100)
devText.Text = "🔨 Dev\n\nتم التطوير من قبل\n3zf and rxt\n\nاتمنى تستمعون ❤️"
devText.TextColor3 = Color3.new(1, 1, 1)
devText.BackgroundTransparency = 1
devText.Font = Enum.Font.GothamBold
devText.TextWrapped = true

-- ===============================
-- 📝 FEEDBACK SYSTEM
-- ===============================
local function feedbackBox(title)
    local box = Instance.new("TextBox", DEV)
    box.Size = UDim2.new(1, 0, 0, 70)
    box.PlaceholderText = title
    box.Text = ""
    box.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    box.TextColor3 = Color3.new(1, 1, 1)
    box.Font = Enum.Font.Gotham
    Instance.new("UICorner", box)

    local send = Instance.new("TextButton", DEV)
    send.Size = UDim2.new(1, 0, 0, 35)
    send.Text = "Send"
    send.BackgroundColor3 = Color3.fromRGB(0, 180, 120)
    send.TextColor3 = Color3.new(1, 1, 1)
    send.Font = Enum.Font.GothamBold
    Instance.new("UICorner", send)

    send.MouseButton1Click:Connect(function()
        if box.Text ~= "" then
            sendWebhook(
                title,
                "**User:** " .. player.Name .. "\n**Message:**\n" .. box.Text
            )
            box.Text = ""
            send.Text = "✅ Sent"
            task.wait(1)
            send.Text = "Send"
        end
    end)
end

feedbackBox("💡 اقتراحات")
feedbackBox("⚠️ شكاوي")

print("👑 RXT V10 Loaded Successfully")
