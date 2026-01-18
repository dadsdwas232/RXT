-- [[ 👑 RXT MASTER V10 - TIME & DURATION EDITION ]] --

if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local player = Players.LocalPlayer

-- [[ ⚙️ CONFIGURATION ]] --
local WebhookURL = "https://discord.com/api/webhooks/1462497368426414275/jSYL-EVtiOSP1H2vcSVDOdlWLszHLytJZeV2EmQonKaK0bsX6NT76LKrs8uYWZSCPlJC"
local AdminPass = "RXT112232"
local IsAuthenticated = false

-- محرك الوقت (لحساب المده)
local function GetTime() return os.time() end

-- [ وظيفة إرسال المفتاح للدسكورد بنظام المده ]
local function SendKeyToDiscord(key, days)
    local expiryDate = os.date("%Y-%m-%d %H:%M:%S", GetTime() + (tonumber(days) * 86400))
    local data = {
        ["embeds"] = {{
            ["title"] = "✅ تم إنشاء مفتاح جديد بنجاح",
            ["color"] = 0x9B4DFF,
            ["fields"] = {
                {["name"] = "🔑 الكود (Key)", ["value"] = "```" .. key .. "```", ["inline"] = false},
                {["name"] = "⏳ الصلاحية", ["value"] = days .. " يوم/أيام", ["inline"] = true},
                {["name"] = "📅 تاريخ الانتهاء", ["value"] = expiryDate, ["inline"] = true},
                {["name"] = "👤 بواسطة", ["value"] = player.Name, ["inline"] = false}
            }
        }}
    }
    pcall(function()
        local req = (syn and syn.request or http_request or request)
        req({Url = WebhookURL, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = HttpService:JSONEncode(data)})
    end)
end

-- [[ 🎨 UI DESIGN (BLACK & PURPLE) ]] --
local SG = Instance.new("ScreenGui", game:GetService("CoreGui")); SG.Name = "RXT_V10_PRO"

local Login = Instance.new("Frame", SG); Login.Size = UDim2.new(0, 300, 0, 180); Login.Position = UDim2.new(0.5, -150, 0.5, -90); Login.BackgroundColor3 = Color3.fromRGB(10,10,15); Instance.new("UICorner", Login)
Instance.new("UIStroke", Login).Color = Color3.fromRGB(150,100,255)

local KInp = Instance.new("TextBox", Login); KInp.Size = UDim2.new(0, 240, 0, 40); KInp.Position = UDim2.new(0.5, -120, 0.3, 0); KInp.PlaceholderText = "ادخل المفتاح هنا..."; KInp.BackgroundColor3 = Color3.fromRGB(20,20,25); KInp.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", KInp)
local KLog = Instance.new("TextButton", Login); KLog.Size = UDim2.new(0, 140, 0, 40); KLog.Position = UDim2.new(0.5, -70, 0.7, 0); KLog.Text = "تسجيل دخول"; KLog.BackgroundColor3 = Color3.fromRGB(120,50,220); KLog.TextColor3 = Color3.new(1,1,1); KLog.Font = "GothamBold"; Instance.new("UICorner", KLog)

-- القائمة الرئيسية (مخفية)
local Main = Instance.new("Frame", SG); Main.Size = UDim2.new(0, 350, 0, 450); Main.Position = UDim2.new(0.5, -175, 0.5, -225); Main.BackgroundColor3 = Color3.fromRGB(8,8,12); Main.Visible = false; Instance.new("UICorner", Main)
Instance.new("UIStroke", Main).Color = Color3.fromRGB(150,100,255)

-- [ إدارة الصفحات ]
local Pages = Instance.new("Frame", Main); Pages.Size = UDim2.new(1, -20, 1, -100); Pages.Position = UDim2.new(0, 10, 0, 80); Pages.BackgroundTransparency = 1
local P_Event = Instance.new("ScrollingFrame", Pages); P_Event.Size = UDim2.new(1,0,1,0); P_Event.Visible = false; P_Event.BackgroundTransparency = 1; Instance.new("UIListLayout", P_Event)
local P_Admin = Instance.new("ScrollingFrame", Pages); P_Admin.Size = UDim2.new(1,0,1,0); P_Admin.Visible = false; P_Admin.BackgroundTransparency = 1; Instance.new("UIListLayout", P_Admin).Padding = UDim.new(0,10)

-- [ قسم الأدمن - إنشاء مفتاح بمدة ]
local function BuildAdmin()
    local KN = Instance.new("TextBox", P_Admin); KN.Size = UDim2.new(1,0,0,40); KN.PlaceholderText = "اسم المفتاح (مثال: User123)"; KN.BackgroundColor3 = Color3.fromRGB(25,25,35); KN.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", KN)
    local KD = Instance.new("TextBox", P_Admin); KD.Size = UDim2.new(1,0,0,40); KD.PlaceholderText = "المدة بالأيام (مثال: 7)"; KD.BackgroundColor3 = Color3.fromRGB(25,25,35); KD.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", KD)
    local btn = Instance.new("TextButton", P_Admin); btn.Size = UDim2.new(1,0,0,45); btn.Text = "إنشاء وإرسال للدسكورد"; btn.BackgroundColor3 = Color3.fromRGB(150,100,255); btn.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", btn)
    
    btn.MouseButton1Click:Connect(function()
        if KN.Text ~= "" and KD.Text ~= "" then
            SendKeyToDiscord(KN.Text, KD.Text)
            btn.Text = "✅ تم الإرسال للويب هوك"; task.wait(2); btn.Text = "إنشاء وإرسال للدسكورد"
        end
    end)
end

-- [ التبويبات ]
local TabH = Instance.new("Frame", Main); TabH.Size = UDim2.new(1,0,0,40); TabH.Position = UDim2.new(0,0,0,40); TabH.BackgroundTransparency = 1; Instance.new("UIListLayout", TabH).FillDirection = "Horizontal"
local function AddT(txt, pg)
    local b = Instance.new("TextButton", TabH); b.Size = UDim2.new(0.5,0,1,0); b.Text = txt; b.TextColor3 = Color3.new(1,1,1); b.BackgroundTransparency = 1
    b.MouseButton1Click:Connect(function() P_Event.Visible = false; P_Admin.Visible = false; pg.Visible = true end)
end
AddT("EVENT", P_Event); AddT("ADMIN", P_Admin)

-- [ نظام التحقق ]
KLog.MouseButton1Click:Connect(function()
    local input = KInp.Text
    -- ملاحظة: هنا الأدمن يدخل بكلمة السر، والمستخدمين يدخلون بالأكواد اللي برمجتها
    if input == AdminPass then
        IsAuthenticated = true; Login.Visible = false; Main.Visible = true; P_Admin.Visible = true; BuildAdmin()
    elseif #input > 3 then -- نظام مبدئي للمستخدمين
        IsAuthenticated = true; Login.Visible = false; Main.Visible = true; P_Event.Visible = true; P_Admin.Visible = false
        -- هنا يمكنك إضافة جلب بيانات من Github للتأكد من المده
    else
        KLog.Text = "خطأ في المفتاح"; task.wait(1); KLog.Text = "تسجيل دخول"
    end
end)

-- نظام السحب
local function Drag(f)
    local d, ds, sp; f.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then d = true ds = i.Position sp = f.Position end end)
    game:GetService("UserInputService").InputChanged:Connect(function(i) if d and i.UserInputType == Enum.UserInputType.MouseMovement then local delta = i.Position - ds f.Position = UDim2.new(sp.X.Scale, sp.X.Offset + delta.X, sp.Y.Scale, sp.Y.Offset + delta.Y) end end)
    game:GetService("UserInputService").InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then d = false end end)
end
Drag(Main); Drag(Login)

print("👑 RXT MASTER V10 - READY TO DEPLOY")
