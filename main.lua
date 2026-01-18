-- [[ 👑 RXT MASTER V10 - DISCORD WEBHOOK EDITION ]] --

if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")
local HttpService = game:GetService("HttpService")
local player = Players.LocalPlayer

-- [[ 🔑 الإعدادات والأمان ]] --
local WebhookURL = "https://discord.com/api/webhooks/1462497368426414275/jSYL-EVtiOSP1H2vcSVDOdlWLszHLytJZeV2EmQonKaK0bsX6NT76LKrs8uYWZSCPlJC"
local AdminPass = "RXT112232"
local IsAuthenticated = false
local settings = {
    spd = false, spdVal = 50, jump = false, farm = false,
    instE = false, bright = false, zoom = false, fps = false
}
local savedPos = nil

-- [ وظيفة إرسال المفاتيح للدسكورد ]
local function SendToDiscord(keyName, days)
    local data = {
        ["embeds"] = {{
            ["title"] = "🔑 مفتاح جديد تم إنشاؤه!",
            ["description"] = "تم إضافة مفتاح جديد لقاعدة البيانات بواسطة أدمن",
            ["color"] = 0x9664FF,
            ["fields"] = {
                {["name"] = "المفتاح (Key)", ["value"] = "`" .. keyName .. "`", ["inline"] = true},
                {["name"] = "المدة", ["value"] = days .. " يوم/أيام", ["inline"] = true},
                {["name"] = "الأدمن المسؤول", ["value"] = player.Name, ["inline"] = false}
            },
            ["footer"] = {["text"] = "RXT MASTER V10 SYNC"}
        }}
    }
    pcall(function()
        local req = (syn and syn.request or http_request or request)
        req({
            Url = WebhookURL,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = HttpService:JSONEncode(data)
        })
    end)
end

-- [ وظيفة الانتقال السلس ]
local function SmoothTP(targetCF)
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end
    local root = player.Character.HumanoidRootPart
    local speed = 120
    local dist = (root.Position - targetCF.Position).Magnitude
    local duration = dist / speed
    local start = tick()
    local startCF = root.CFrame
    
    local conn; conn = RunService.Heartbeat:Connect(function()
        local elapsed = tick() - start
        if elapsed >= duration or not settings then 
            root.CFrame = targetCF
            conn:Disconnect()
        else
            root.CFrame = startCF:Lerp(targetCF, elapsed / duration)
        end
    end)
end

-- [[ 🎨 الواجهة الرئيسية ]] --
if CoreGui:FindFirstChild("RXT_V10") then CoreGui["RXT_V10"]:Destroy() end
local SG = Instance.new("ScreenGui", CoreGui); SG.Name = "RXT_V10"

-- نافذة الدخول
local Login = Instance.new("Frame", SG); Login.Size = UDim2.new(0, 260, 0, 150); Login.Position = UDim2.new(0.5, -130, 0.5, -75); Login.BackgroundColor3 = Color3.fromRGB(15,15,20); Instance.new("UICorner", Login)
local KInp = Instance.new("TextBox", Login); KInp.Size = UDim2.new(0, 200, 0, 35); KInp.Position = UDim2.new(0.5, -100, 0.25, 0); KInp.PlaceholderText = "Enter Key..."; KInp.BackgroundColor3 = Color3.fromRGB(30,30,40); KInp.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", KInp)
local KLog = Instance.new("TextButton", Login); KLog.Size = UDim2.new(0, 100, 0, 30); KLog.Position = UDim2.new(0.5, -50, 0.65, 0); KLog.Text = "LOGIN"; KLog.BackgroundColor3 = Color3.fromRGB(120,50,220); KLog.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", KLog)

-- نافذة السكربت الرئيسية
local Main = Instance.new("Frame", SG); Main.Size = UDim2.new(0, 300, 0, 400); Main.Position = UDim2.new(0.5, -150, 0.5, -200); Main.BackgroundColor3 = Color3.fromRGB(10,10,15); Main.Visible = false; Instance.new("UICorner", Main)
local MainStroke = Instance.new("UIStroke", Main); MainStroke.Color = Color3.fromRGB(150, 100, 255); MainStroke.Thickness = 2

local Logo = Instance.new("TextButton", SG); Logo.Size = UDim2.new(0, 45, 0, 45); Logo.Position = UDim2.new(0, 10, 0.5, -22); Logo.Text = "RXT"; Logo.BackgroundColor3 = Color3.fromRGB(20,10,40); Logo.TextColor3 = Color3.fromRGB(150,100,255); Logo.Font = "GothamBold"; Logo.Visible = false; Instance.new("UICorner", Logo).CornerRadius = UDim.new(1,0)

-- التبويبات
local TabH = Instance.new("Frame", Main); TabH.Size = UDim2.new(1, 0, 0, 35); TabH.Position = UDim2.new(0, 0, 0, 35); TabH.BackgroundTransparency = 1
local TabL = Instance.new("UIListLayout", TabH); TabL.FillDirection = "Horizontal"; TabL.HorizontalAlignment = "Center"

local Pages = Instance.new("Frame", Main); Pages.Size = UDim2.new(1, -10, 1, -80); Pages.Position = UDim2.new(0, 5, 0, 75); Pages.BackgroundTransparency = 1
local function CP() local p = Instance.new("ScrollingFrame", Pages); p.Size = UDim2.new(1, 0, 1, 0); p.BackgroundTransparency = 1; p.Visible = false; p.ScrollBarThickness = 0; Instance.new("UIListLayout", p).Padding = UDim.new(0, 5); return p end
local P1, P2, P3, P4 = CP(), CP(), CP(), CP(); P1.Visible = true

local function AT(t, pg)
    local b = Instance.new("TextButton", TabH); b.Size = UDim2.new(0, 65, 1, 0); b.Text = t; b.TextColor3 = Color3.new(1,1,1); b.BackgroundTransparency = 1; b.Font = "GothamBold"; b.TextSize = 10
    b.MouseButton1Click:Connect(function() P1.Visible=false; P2.Visible=false; P3.Visible=false; P4.Visible=false; pg.Visible=true end)
end
AT("MAIN", P1); AT("WORLD", P2); AT("TP", P3); AT("ADMIN", P4)

-- [ الوظائف ]
local function AddToggle(parent, txt, prop, callback)
    local b = Instance.new("TextButton", parent); b.Size = UDim2.new(1, 0, 0, 35); b.Text = txt.." : OFF"; b.BackgroundColor3 = Color3.fromRGB(25,25,35); b.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function()
        settings[prop] = not settings[prop]
        b.Text = settings[prop] and txt.." : ON" or txt.." : OFF"
        b.BackgroundColor3 = settings[prop] and Color3.fromRGB(0,150,80) or Color3.fromRGB(25,25,35)
        if callback then callback(settings[prop]) end
    end)
end

-- P1: Main Features
AddToggle(P1, "Stealth Speed", "spd")
local SBox = Instance.new("TextBox", P1); SBox.Size = UDim2.new(1,0,0,30); SBox.Text = "50"; SBox.BackgroundColor3 = Color3.fromRGB(20,20,30); SBox.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", SBox)
SBox.FocusLost:Connect(function() settings.spdVal = tonumber(SBox.Text) or 50 end)
AddToggle(P1, "Infinite Jump", "jump")
AddToggle(P1, "Ghost Farm", "farm")

-- P2: World
AddToggle(P2, "Instant E", "instE")
AddToggle(P2, "Full Bright", "bright", function(s) Lighting.Brightness = s and 2 or 1; Lighting.ClockTime = s and 14 or 12 end)
AddToggle(P2, "FPS Boost", "fps", function(s) if s then for _,v in pairs(game:GetDescendants()) do if v:IsA("BasePart") then v.Material = Enum.Material.SmoothPlastic end end end end)

-- P3: TP (Smooth)
local bS = Instance.new("TextButton", P3); bS.Size = UDim2.new(1,0,0,35); bS.Text = "Save Position"; bS.BackgroundColor3 = Color3.fromRGB(30,30,45); bS.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", bS)
bS.MouseButton1Click:Connect(function() if player.Character then savedPos = player.Character.HumanoidRootPart.CFrame; bS.Text = "Saved!" task.wait(1) bS.Text = "Save Position" end end)
local bT = Instance.new("TextButton", P3); bT.Size = UDim2.new(1,0,0,35); bT.Text = "Smooth Teleport"; bT.BackgroundColor3 = Color3.fromRGB(30,30,45); bT.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", bT)
bT.MouseButton1Click:Connect(function() if savedPos then SmoothTP(savedPos) end end)

-- P4: Admin (Discord Sync)
local function RefreshAdmin()
    for _,v in pairs(P4:GetChildren()) do if not v:IsA("UIListLayout") then v:Destroy() end end
    local KN = Instance.new("TextBox", P4); KN.Size = UDim2.new(1,0,0,35); KN.PlaceholderText = "Key Name"; KN.BackgroundColor3 = Color3.fromRGB(30,20,20); KN.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", KN)
    local KD = Instance.new("TextBox", P4); KD.Size = UDim2.new(1,0,0,35); KD.PlaceholderText = "Days"; KD.BackgroundColor3 = Color3.fromRGB(30,20,20); KD.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", KD)
    local AB = Instance.new("TextButton", P4); AB.Size = UDim2.new(1,0,0,35); AB.Text = "CREATE & SEND TO DISCORD"; AB.BackgroundColor3 = Color3.fromRGB(150,0,0); AB.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", AB)
    AB.MouseButton1Click:Connect(function() if KN.Text~="" then SendToDiscord(KN.Text, KD.Text or "1"); AB.Text = "✅ SENT!"; task.wait(1); RefreshAdmin() end end)
end

-- [[ المحرك الرئيسي ]] --
task.spawn(function()
    while task.wait(0.3) do
        if IsAuthenticated and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local root = player.Character.HumanoidRootPart
            if settings.spd then player.Character.Humanoid.WalkSpeed = settings.spdVal end
            if settings.farm then
                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("TouchTransmitter") and (v.Parent.Name:lower():find("coin") or v.Parent.Name:lower():find("radioactive")) then
                        firetouchinterest(root, v.Parent, 0); firetouchinterest(root, v.Parent, 1)
                    end
                end
            end
            if settings.instE then for _,v in pairs(workspace:GetDescendants()) do if v:IsA("ProximityPrompt") then v.HoldDuration = 0 end end end
        end
    end
end)

UIS.JumpRequest:Connect(function() if IsAuthenticated and settings.jump then player.Character.Humanoid:ChangeState("Jumping") end end)

-- [ نظام السحب ]
local function Drag(f)
    local d, ds, sp; f.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then d = true ds = i.Position sp = f.Position end end)
    UIS.InputChanged:Connect(function(i) if d and i.UserInputType == Enum.UserInputType.MouseMovement then local delta = i.Position - ds f.Position = UDim2.new(sp.X.Scale, sp.X.Offset + delta.X, sp.Y.Scale, sp.Y.Offset + delta.Y) end end)
    UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then d = false end end)
end
Drag(Main); Drag(Login)

-- [ الدخول والفتح/الإغلاق ]
KLog.MouseButton1Click:Connect(function()
    if KInp.Text == AdminPass then
        IsAuthenticated = true; Login.Visible = false; Main.Visible = true; RefreshAdmin()
    else
        KLog.Text = "WRONG"; task.wait(0.5); KLog.Text = "LOGIN"
    end
end)

local Close = Instance.new("TextButton", Main); Close.Size = UDim2.new(0, 25, 0, 25); Close.Position = UDim2.new(1, -30, 0, 5); Close.Text = "X"; Close.BackgroundColor3 = Color3.fromRGB(200,0,0); Close.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", Close)
Close.MouseButton1Click:Connect(function() Main.Visible = false; Logo.Visible = true end)
Logo.MouseButton1Click:Connect(function() Main.Visible = true; Logo.Visible = false end)

print("👑 RXT MASTER V10 LOADED - WEBHOOK SYNC ACTIVE")
