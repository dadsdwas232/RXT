-- [[ 👑 RXT SERVER - V10 PRO (FULL CODE) ]] --
-- Key: RXT24

if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")
local player = Players.LocalPlayer

-- [ إعدادات الهوية ]
local AssetID = "rbxassetid://86991492020004"
local CorrectKey = "RXT24"

-- [[ 🛡️ نظام الدخول والتحميل ]] --
local function Launch()
    local KeyGui = Instance.new("ScreenGui", CoreGui)
    
    -- واجهة التحقق
    local KeyMain = Instance.new("Frame", KeyGui)
    KeyMain.Size = UDim2.new(0, 350, 0, 250)
    KeyMain.Position = UDim2.new(0.5, -175, 0.5, -125)
    KeyMain.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    Instance.new("UICorner", KeyMain)
    local Stroke = Instance.new("UIStroke", KeyMain); Stroke.Color = Color3.fromRGB(150, 100, 255); Stroke.Thickness = 2

    local Logo = Instance.new("ImageLabel", KeyMain)
    Logo.Size = UDim2.new(0, 80, 0, 80); Logo.Position = UDim2.new(0.5, -40, 0.1, 0)
    Logo.Image = AssetID; Logo.BackgroundTransparency = 1

    local Input = Instance.new("TextBox", KeyMain)
    Input.Size = UDim2.new(0, 250, 0, 40); Input.Position = UDim2.new(0.5, -125, 0.5, 10)
    Input.PlaceholderText = "Enter Key: RXT24"; Input.Text = ""; Input.BackgroundColor3 = Color3.fromRGB(30,30,40); Input.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", Input)

    local Btn = Instance.new("TextButton", KeyMain)
    Btn.Size = UDim2.new(0, 150, 0, 40); Btn.Position = UDim2.new(0.5, -75, 0.75, 10)
    Btn.Text = "ACTIVATE"; Btn.BackgroundColor3 = Color3.fromRGB(120, 50, 220); Btn.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", Btn)

    Btn.MouseButton1Click:Connect(function()
        if Input.Text == CorrectKey then
            -- واجهة التحميل بعد المفتاح
            Input:Destroy(); Btn:Destroy(); Logo:TweenPosition(UDim2.new(0.5, -40, 0.3, 0))
            local LText = Instance.new("TextLabel", KeyMain)
            LText.Size = UDim2.new(1,0,0,30); LText.Position = UDim2.new(0,0,0.7,0); LText.Text = "LOADING RXT V10..."; LText.TextColor3 = Color3.new(1,1,1); LText.BackgroundTransparency = 1
            
            task.wait(1.5)
            KeyGui:Destroy()
            StartScript() -- تشغيل كودك الأصلي
        else
            Input.Text = ""; Input.PlaceholderText = "INVALID KEY"; Input.PlaceholderColor3 = Color3.new(1,0,0)
        end
    end)
end

function StartScript()
    -- [[ ⚙️ إعدادات كودك الأصلية ]] --
    local stealthSpeedEnabled = false
    local speedValue = 50
    local noclipEnabled = false
    local instantInteractionEnabled = false
    local infJumpEnabled = false
    local noRagdollEnabled = false
    local radioactiveFarmEnabled = false
    local savedPosition = nil

    -- [[ 🛠️ وظائف النظام الخلفية (من كودك) ]] --
    task.spawn(function()
        local VU = game:GetService("VirtualUser")
        player.Idled:Connect(function() VU:CaptureController() VU:ClickButton2(Vector2.new()) end)
    end)

    RunService.Stepped:Connect(function()
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            local hum = player.Character.Humanoid
            local root = player.Character:FindFirstChild("HumanoidRootPart")
            hum.WalkSpeed = stealthSpeedEnabled and speedValue or 16
            if radioactiveFarmEnabled and root then
                for _, v in pairs(player.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
                root.Velocity = Vector3.new(root.Velocity.X, 0, root.Velocity.Z)
            end
        end
    end)

    UserInputService.JumpRequest:Connect(function()
        if infJumpEnabled and player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
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
                            firetouchinterest(root, p, 0) task.wait() firetouchinterest(root, p, 1)
                        end
                    end
                end
            end
        end
    end)

    -- [[ 🎨 الواجهة (مع إضافة صورتك فوق يسار) ]] --
    if CoreGui:FindFirstChild("RXT_Master_V10") then CoreGui["RXT_Master_V10"]:Destroy() end
    local ScreenGui = Instance.new("ScreenGui", CoreGui); ScreenGui.Name = "RXT_Master_V10"

    local Main = Instance.new("Frame", ScreenGui)
    Main.Size = UDim2.new(0, 360, 0, 520); Main.Position = UDim2.new(0.5, -180, 0.5, -260)
    Main.BackgroundColor3 = Color3.fromRGB(12, 12, 18); Main.BorderSizePixel = 0
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 15)
    Instance.new("UIStroke", Main).Color = Color3.fromRGB(150, 100, 255)

    -- الشعار فوق يسار
    local TopLogo = Instance.new("ImageLabel", Main)
    TopLogo.Size = UDim2.new(0, 40, 0, 40); TopLogo.Position = UDim2.new(0, 10, 0, 10)
    TopLogo.Image = AssetID; TopLogo.BackgroundTransparency = 1; Instance.new("UICorner", TopLogo).CornerRadius = UDim.new(1,0)

    local CloseBtn = Instance.new("TextButton", Main)
    CloseBtn.Size = UDim2.new(0, 35, 0, 35); CloseBtn.Position = UDim2.new(1, -45, 0, 10)
    CloseBtn.Text = "X"; CloseBtn.BackgroundColor3 = Color3.fromRGB(120, 50, 220); CloseBtn.TextColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", CloseBtn)

    -- نظام التبويبات (نفس كودك تماماً)
    local TabHolder = Instance.new("Frame", Main)
    TabHolder.Size = UDim2.new(1, -110, 0, 45); TabHolder.Position = UDim2.new(0, 60, 0, 5); TabHolder.BackgroundTransparency = 1
    local TabList = Instance.new("UIListLayout", TabHolder); TabList.FillDirection = Enum.FillDirection.Horizontal; TabList.Padding = UDim.new(0, 5)

    local Pages = Instance.new("Frame", Main); Pages.Size = UDim2.new(1, -20, 1, -90); Pages.Position = UDim2.new(0, 10, 0, 70); Pages.BackgroundTransparency = 1
    local function CreatePage()
        local p = Instance.new("ScrollingFrame", Pages); p.Size = UDim2.new(1, 0, 1, 0); p.BackgroundTransparency = 1; p.Visible = false; p.ScrollBarThickness = 0
        Instance.new("UIListLayout", p).Padding = UDim.new(0, 10); return p
    end
    local P1 = CreatePage(); local P2 = CreatePage(); local P3 = CreatePage(); local P4 = CreatePage(); P1.Visible = true

    local function AddTab(t, pg)
        local b = Instance.new("TextButton", TabHolder); b.Size = UDim2.new(0, 60, 1, 0); b.Text = t; b.TextColor3 = Color3.new(1,1,1); b.BackgroundTransparency = 1; b.Font = Enum.Font.GothamBold; b.TextSize = 10
        b.MouseButton1Click:Connect(function() P1.Visible = false; P2.Visible = false; P3.Visible = false; P4.Visible = false; pg.Visible = true end)
    end
    AddTab("MAIN", P1); AddTab("EVENT", P2); AddTab("WORLD", P3); AddTab("TP", P4)

    local function AddToggle(parent, txt, current, cb)
        local b = Instance.new("TextButton", parent); b.Size = UDim2.new(1, 0, 0, 40); b.Text = txt .. " : OFF"; b.BackgroundColor3 = Color3.fromRGB(35, 30, 60); b.TextColor3 = Color3.new(1,1,1); b.Font = Enum.Font.GothamBold; Instance.new("UICorner", b)
        local state = current
        local function Update()
            b.Text = state and txt .. " : ON" or txt .. " : OFF"
            b.BackgroundColor3 = state and Color3.fromRGB(0, 180, 100) or Color3.fromRGB(35, 30, 60)
        end
        b.MouseButton1Click:Connect(function() state = not state; cb(state); Update() end)
        Update(); return b
    end

    -- رجعت كل الأزرار اللي كانت بكودك
    AddToggle(P1, "🚫 No Ragdoll", noRagdollEnabled, function(s) noRagdollEnabled = s end)
    AddToggle(P1, "🧱 NoClip", noclipEnabled, function(s) noclipEnabled = s end)
    AddToggle(P1, "🦘 Infinity Jump", infJumpEnabled, function(s) infJumpEnabled = s end)
    local SpdInput = Instance.new("TextBox", P1); SpdInput.Size = UDim2.new(1, 0, 0, 35); SpdInput.PlaceholderText = "Speed (50)"; SpdInput.BackgroundColor3 = Color3.fromRGB(20, 20, 30); SpdInput.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", SpdInput); SpdInput.Text = "50"
    AddToggle(P1, "🚀 Stealth Speed", stealthSpeedEnabled, function(s) stealthSpeedEnabled = s; speedValue = tonumber(SpdInput.Text) or 50 end)

    AddToggle(P2, "☢️ Radioactive Farm", radioactiveFarmEnabled, function(s) radioactiveFarmEnabled = s end)
    AddToggle(P2, "⚡ Instant E", instantInteractionEnabled, function(s) instantInteractionEnabled = s if s then for _,v in pairs(workspace:GetDescendants()) do if v:IsA("ProximityPrompt") then v.HoldDuration = 0 end end end end)

    AddToggle(P3, "⚡ FPS BOOST", false, function(s) if s then for _,v in pairs(game:GetDescendants()) do if v:IsA("BasePart") then v.Material = "SmoothPlastic" end end end end)
    AddToggle(P3, "👁️ Unlock Zoom", false, function(s) if s then player.CameraMaxZoomDistance = 100000 end end)
    AddToggle(P3, "💡 Full Bright", false, function(s) if s then Lighting.Brightness = 2; Lighting.ClockTime = 14 end end)

    local bSave = Instance.new("TextButton", P4); bSave.Size = UDim2.new(1, 0, 0, 40); bSave.Text = "📍 Save Position"; bSave.BackgroundColor3 = Color3.fromRGB(35, 30, 60); bSave.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", bSave)
    bSave.MouseButton1Click:Connect(function() if player.Character then savedPosition = player.Character.HumanoidRootPart.CFrame; bSave.Text = "✅ Saved!" task.wait(1) bSave.Text = "📍 Save Position" end end)

    local bTP = Instance.new("TextButton", P4); bTP.Size = UDim2.new(1, 0, 0, 40); bTP.Text = "🌀 Ghost Smooth TP"; bTP.BackgroundColor3 = Color3.fromRGB(35, 30, 60); bTP.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", bTP)
    bTP.MouseButton1Click:Connect(function()
        if savedPosition then
            local root = player.Character.HumanoidRootPart; local dist = (root.Position - savedPosition.Position).Magnitude
            local duration = dist / 120; local start = tick(); local startCF = root.CFrame
            local conn; conn = RunService.Heartbeat:Connect(function()
                local elapsed = tick() - start
                if elapsed >= duration then root.CFrame = savedPosition; conn:Disconnect()
                else root.CFrame = startCF:Lerp(savedPosition, elapsed/duration); root.Velocity = Vector3.new(0,0,0) end
            end)
        end
    end)

    -- تنبيه التفعيل أسفل اليمين
    local Notif = Instance.new("TextLabel", ScreenGui)
    Notif.Size = UDim2.new(0, 250, 0, 50); Notif.Position = UDim2.new(1, -260, 1, -60); Notif.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    Notif.Text = "✅ تم تفعيل الـ 24 ساعة"; Notif.TextColor3 = Color3.fromRGB(0, 255, 150); Notif.Font = Enum.Font.GothamBold; Instance.new("UICorner", Notif)
    task.delay(5, function() Notif:Destroy() end)

    CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)
end

Launch() -- تشغيل نظام المفتاح
