-- [[ 🔑 نظام الدخول الموحد لسكربت RXT ]] --
local GlobalKey = "FREE24"
local DaysActive = 2 -- (حط 0 للإيقاف الشامل)

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")

-- [ وظيفة إشعار النجاح ]
local function SuccessNotify()
    local NotifyGui = Instance.new("ScreenGui", CoreGui)
    local Frame = Instance.new("Frame", NotifyGui)
    Frame.Size = UDim2.new(0, 280, 0, 60); Frame.Position = UDim2.new(1, -290, 1, -70); Frame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    Instance.new("UICorner", Frame); local Stroke = Instance.new("UIStroke", Frame); Stroke.Color = Color3.fromRGB(150, 100, 255); Stroke.Thickness = 2
    local Label = Instance.new("TextLabel", Frame); Label.Size = UDim2.new(1, 0, 1, 0); Label.BackgroundTransparency = 1; Label.TextColor3 = Color3.new(1, 1, 1)
    Label.Text = "تم تفعيل الـ 24 ساعة بنجاح ✅"; Label.Font = "GothamBold"; Label.TextSize = 14
    task.wait(4); NotifyGui:Destroy()
end

-- [ واجهة تسجيل الدخول ]
if CoreGui:FindFirstChild("RXT_Auth") then CoreGui["RXT_Auth"]:Destroy() end
local AuthGui = Instance.new("ScreenGui", CoreGui); AuthGui.Name = "RXT_Auth"
local LoginFrame = Instance.new("Frame", AuthGui); LoginFrame.Size = UDim2.new(0, 300, 0, 180); LoginFrame.Position = UDim2.new(0.5, -150, 0.5, -90); LoginFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
Instance.new("UICorner", LoginFrame); Instance.new("UIStroke", LoginFrame).Color = Color3.fromRGB(120, 50, 220)
local KInp = Instance.new("TextBox", LoginFrame); KInp.Size = UDim2.new(0, 240, 0, 40); KInp.Position = UDim2.new(0.5, -120, 0.3, 0); KInp.PlaceholderText = "Enter Key..."; KInp.BackgroundColor3 = Color3.fromRGB(20, 20, 30); KInp.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", KInp)
local KLog = Instance.new("TextButton", LoginFrame); KLog.Size = UDim2.new(0, 140, 0, 40); KLog.Position = UDim2.new(0.5, -70, 0.7, 0); KLog.Text = "LOGIN"; KLog.BackgroundColor3 = Color3.fromRGB(120, 50, 220); KLog.TextColor3 = Color3.new(1,1,1); KLog.Font = "GothamBold"; Instance.new("UICorner", KLog)

local function RunOriginalScript()
    -- [[ كودك الأصلي بالكامل دون نقص ]] --
    if not game:IsLoaded() then game.Loaded:Wait() end
    local RunService = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")
    local Lighting = game:GetService("Lighting")
    local player = Players.LocalPlayer

    local stealthSpeedEnabled = false
    local speedValue = 50
    local noclipEnabled = false
    local instantInteractionEnabled = false
    local infJumpEnabled = false
    local noRagdollEnabled = false
    local radioactiveFarmEnabled = false
    local savedPosition = nil

    task.spawn(function()
        local VU = game:GetService("VirtualUser")
        player.Idled:Connect(function() VU:CaptureController(); VU:ClickButton2(Vector2.new()) end)
    end)

    RunService.Stepped:Connect(function()
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            local hum = player.Character.Humanoid
            local root = player.Character:FindFirstChild("HumanoidRootPart")
            if stealthSpeedEnabled then hum.WalkSpeed = speedValue else hum.WalkSpeed = 16 end
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
                            firetouchinterest(root, p, 0); task.wait(); firetouchinterest(root, p, 1)
                        end
                    end
                end
            end
        end
    end)

    if CoreGui:FindFirstChild("RXT_Master_V10") then CoreGui["RXT_Master_V10"]:Destroy() end
    local ScreenGui = Instance.new("ScreenGui", CoreGui); ScreenGui.Name = "RXT_Master_V10"
    local Main = Instance.new("Frame", ScreenGui); Main.Size = UDim2.new(0, 360, 0, 520); Main.Position = UDim2.new(0.5, -180, 0.5, -260); Main.BackgroundColor3 = Color3.fromRGB(12, 12, 18); Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 15)
    local MainStroke = Instance.new("UIStroke", Main); MainStroke.Color = Color3.fromRGB(150, 100, 255); MainStroke.Thickness = 2

    local CloseBtn = Instance.new("TextButton", Main); CloseBtn.Size = UDim2.new(0, 35, 0, 35); CloseBtn.Position = UDim2.new(0, 10, 0, 10); CloseBtn.Text = "X"; CloseBtn.BackgroundColor3 = Color3.fromRGB(120, 50, 220); CloseBtn.TextColor3 = Color3.new(1, 1, 1); CloseBtn.Font = Enum.Font.GothamBold; CloseBtn.TextSize = 22; Instance.new("UICorner", CloseBtn)
    local OpenBtn = Instance.new("TextButton", ScreenGui); OpenBtn.Size = UDim2.new(0, 60, 0, 60); OpenBtn.Position = UDim2.new(0, 15, 0.5, -30); OpenBtn.BackgroundColor3 = Color3.fromRGB(30, 20, 50); OpenBtn.Text = "RXT"; OpenBtn.TextColor3 = Color3.fromRGB(150, 100, 255); OpenBtn.Font = Enum.Font.GothamBold; OpenBtn.Visible = false; Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(1,0); Instance.new("UIStroke", OpenBtn).Color = Color3.fromRGB(150, 100, 255)
    CloseBtn.MouseButton1Click:Connect(function() Main.Visible = false; OpenBtn.Visible = true end); OpenBtn.MouseButton1Click:Connect(function() Main.Visible = true; OpenBtn.Visible = false end)

    local TabHolder = Instance.new("Frame", Main); TabHolder.Size = UDim2.new(1, -60, 0, 45); TabHolder.Position = UDim2.new(0, 50, 0, 5); TabHolder.BackgroundTransparency = 1
    Instance.new("UIListLayout", TabHolder).FillDirection = Enum.FillDirection.Horizontal; TabHolder.UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center; TabHolder.UIListLayout.Padding = UDim.new(0, 5)

    local Pages = Instance.new("Frame", Main); Pages.Size = UDim2.new(1, -20, 1, -90); Pages.Position = UDim2.new(0, 10, 0, 70); Pages.BackgroundTransparency = 1
    local function CreatePage()
        local p = Instance.new("ScrollingFrame", Pages); p.Size = UDim2.new(1, 0, 1, 0); p.BackgroundTransparency = 1; p.Visible = false; p.ScrollBarThickness = 0
        Instance.new("UIListLayout", p).Padding = UDim.new(0, 10); return p
    end
    local P1 = CreatePage(); local P2 = CreatePage(); local P3 = CreatePage(); local P4 = CreatePage(); P1.Visible = true

    local function AddTab(t, pg)
        local b = Instance.new("TextButton", TabHolder); b.Size = UDim2.new(0, 70, 1, 0); b.Text = t; b.TextColor3 = Color3.new(1,1,1); b.BackgroundTransparency = 1; b.Font = Enum.Font.GothamBold; b.TextSize = 11
        b.MouseButton1Click:Connect(function() P1.Visible = false; P2.Visible = false; P3.Visible = false; P4.Visible = false; pg.Visible = true end)
    end
    AddTab("MAIN", P1); AddTab("EVENT", P2); AddTab("WORLD", P3); AddTab("TP", P4)

    local function AddToggle(parent, txt, current, cb)
        local b = Instance.new("TextButton", parent); b.Size = UDim2.new(1, 0, 0, 40); b.Text = txt .. " : OFF"; b.BackgroundColor3 = Color3.fromRGB(35, 30, 60); b.TextColor3 = Color3.new(1,1,1); b.Font = Enum.Font.GothamBold; Instance.new("UICorner", b)
        local state = current
        local function Update() b.Text = state and txt .. " : ON" or txt .. " : OFF"; b.BackgroundColor3 = state and Color3.fromRGB(0, 180, 100) or Color3.fromRGB(35, 30, 60) end
        b.MouseButton1Click:Connect(function() state = not state; cb(state); Update() end); Update()
    end

    AddToggle(P1, "🚫 No Ragdoll", noRagdollEnabled, function(s) noRagdollEnabled = s end)
    AddToggle(P1, "🧱 NoClip", noclipEnabled, function(s) noclipEnabled = s end)
    AddToggle(P1, "🦘 Infinity Jump", infJumpEnabled, function(s) infJumpEnabled = s end)
    local SpdInput = Instance.new("TextBox", P1); SpdInput.Size = UDim2.new(1, 0, 0, 35); SpdInput.PlaceholderText = "Speed (16-100)"; SpdInput.BackgroundColor3 = Color3.fromRGB(20, 20, 30); SpdInput.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", SpdInput); SpdInput.Text = "50"
    AddToggle(P1, "🚀 Stealth Speed", stealthSpeedEnabled, function(s) stealthSpeedEnabled = s; speedValue = tonumber(SpdInput.Text) or 50 end)
    AddToggle(P2, "☢️ Radioactive Farm", radioactiveFarmEnabled, function(s) radioactiveFarmEnabled = s end)
    AddToggle(P2, "⚡ Instant E", instantInteractionEnabled, function(s) instantInteractionEnabled = s; if s then for _,v in pairs(workspace:GetDescendants()) do if v:IsA("ProximityPrompt") then v.HoldDuration = 0 end end end end)
    AddToggle(P3, "⚡ FPS BOOST", false, function(s) if s then for _,v in pairs(game:GetDescendants()) do if v:IsA("BasePart") then v.Material = "SmoothPlastic" end end end end)
    AddToggle(P3, "👁️ Unlock Zoom", false, function(s) if s then player.CameraMaxZoomDistance = 100000 end end)
    AddToggle(P3, "💡 Full Bright", false, function(s) if s then Lighting.Brightness = 2; Lighting.ClockTime = 14 end end)

    local bSave = Instance.new("TextButton", P4); bSave.Size = UDim2.new(1, 0, 0, 40); bSave.Text = "📍 Save Position"; bSave.BackgroundColor3 = Color3.fromRGB(35, 30, 60); bSave.TextColor3 = Color3.new(1,1,1); bSave.Font = Enum.Font.GothamBold; Instance.new("UICorner", bSave)
    bSave.MouseButton1Click:Connect(function() if player.Character then savedPosition = player.Character.HumanoidRootPart.CFrame; bSave.Text = "✅ Position Saved!"; task.wait(1); bSave.Text = "📍 Save Position" end end)
    local bTP = Instance.new("TextButton", P4); bTP.Size = UDim2.new(1, 0, 0, 40); bTP.Text = "🌀 Ghost Smooth TP"; bTP.BackgroundColor3 = Color3.fromRGB(35, 30, 60); bTP.TextColor3 = Color3.new(1,1,1); bTP.Font = Enum.Font.GothamBold; Instance.new("UICorner", bTP)
    bTP.MouseButton1Click:Connect(function() if savedPosition then local root = player.Character.HumanoidRootPart; local dist = (root.Position - savedPosition.Position).Magnitude; local duration = dist / 120; local start = tick(); local startCF = root.CFrame; local conn; conn = RunService.Heartbeat:Connect(function() local elapsed = tick() - start; if elapsed >= duration then root.CFrame = savedPosition; conn:Disconnect() else root.CFrame = startCF:Lerp(savedPosition, elapsed/duration); root.Velocity = Vector3.new(0,0,0) end end) end end)

    local Footer = Instance.new("TextLabel", Main); Footer.Size = UDim2.new(1, 0, 0, 30); Footer.Position = UDim2.new(0, 0, 1, -30); Footer.Text = "RXT SERVER | V10 SAFE EDITION"; Footer.TextColor3 = Color3.fromRGB(150, 100, 255); Footer.BackgroundTransparency = 1; Footer.Font = Enum.Font.GothamBold
end

KLog.MouseButton1Click:Connect(function()
    if KInp.Text == GlobalKey then
        if DaysActive > 0 then AuthGui:Destroy(); SuccessNotify(); RunOriginalScript() else KLog.Text = "المفتاح معطل" end
    else KLog.Text = "المفتاح خاطئ"; task.wait(1); KLog.Text = "LOGIN" end
end)
