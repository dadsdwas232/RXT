--[[ 
    💀 ULTIMATE DESYNC X  💀
    يجمع بين أقوى 5 تقنيات ديسنك:
    - RakNet Desync (متطلب المشغل)
    - FastFlag Physics Break
    - Glitch Mode (شخصية متشنجة)
    - Lag Switch 
    - Advanced Network Abuse
    - Void Mode & No Respawn Lock

    !! تنبيه: بعض الميزات تحتاج مشغل يدعمها مثل Delta Executor !!
]]

local Player = game.Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local RootPart = Character:WaitForChild("HumanoidRootPart")
local Humanoid = Character:WaitForChild("Humanoid")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

-- منع تكرار التشغيل
local oldGui = game:GetService("CoreGui"):FindFirstChild("UltimateDesyncPanelX")
if oldGui then oldGui:Destroy() end

-- =================== GUI المتطورة ===================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UltimateDesyncPanelX"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ResetOnSpawn = false

-- الإطار الرئيسي العائم
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 420, 0, 320)
MainFrame.Position = UDim2.new(0.5, -210, 0.25, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MainFrame.BackgroundTransparency = 0.15
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 20)
Corner.Parent = MainFrame

local Shadow = Instance.new("UIShadow")
Shadow.Parent = MainFrame

local Gradient = Instance.new("UIGradient")
Gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(15, 15, 35)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(5, 5, 20))
})
Gradient.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 45)
Title.BackgroundTransparency = 1
Title.Text = "💀 ULTIMATE DESYNC X | STATUS: 🔴"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.Parent = MainFrame

local Line = Instance.new("Frame")
Line.Size = UDim2.new(0.9, 0, 0, 1)
Line.Position = UDim2.new(0.05, 0, 0, 48)
Line.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
Line.BackgroundTransparency = 0.5
Line.Parent = MainFrame

-- إحصائيات حية
local PingLabel = Instance.new("TextLabel")
PingLabel.Size = UDim2.new(0.5, 0, 0, 25)
PingLabel.Position = UDim2.new(0.05, 0, 0.18, 0)
PingLabel.BackgroundTransparency = 1
PingLabel.Text = "📡 Ping: -- ms"
PingLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
PingLabel.Font = Enum.Font.Gotham
PingLabel.TextSize = 12
PingLabel.TextXAlignment = Enum.TextXAlignment.Left
PingLabel.Parent = MainFrame

local ModeLabel = Instance.new("TextLabel")
ModeLabel.Size = UDim2.new(0.5, 0, 0, 25)
ModeLabel.Position = UDim2.new(0.5, 0, 0.18, 0)
ModeLabel.BackgroundTransparency = 1
ModeLabel.Text = "⚙️ Mode: None"
ModeLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
ModeLabel.Font = Enum.Font.Gotham
ModeLabel.TextSize = 12
ModeLabel.TextXAlignment = Enum.TextXAlignment.Left
ModeLabel.Parent = MainFrame

-- =================== أزرار الميزات ===================
local Functions = {
    RakNet = {Name = "🌀 RakNet Desync", Active = false, Button = nil},
    FastFlag = {Name = "⚡ FastFlag Break", Active = false, Button = nil},
    Glitch = {Name = "👾 Glitch Mode", Active = false, Button = nil},
    LagSwitch = {Name = "🐌 Lag Switch", Active = false, Button = nil},
    NetworkAbuse = {Name = "🌐 Network Abuse", Active = false, Button = nil},
    VoidMode = {Name = "🕳️ Void Mode", Active = false, Button = nil},
    NoRespawn = {Name = "☠️ No Respawn", Active = false, Button = nil},
    SlowPlayers = {Name = "🐢 Slow Others", Active = false, Button = nil}
}

local function CreateButton(funcKey, yPos)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(0.44, 0, 0, 32)
    Btn.Position = UDim2.new(0.05 + (funcKey:find("RakNet") and 0 or 0.51), 0, yPos, 0)
    Btn.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    Btn.Text = Functions[funcKey].Name
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = 12
    Btn.Parent = MainFrame
    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 8)
    BtnCorner.Parent = Btn
    Functions[funcKey].Button = Btn
    return Btn
end

-- ترتيب الأزرار
CreateButton("RakNet", 0.28)
CreateButton("FastFlag", 0.28)
CreateButton("Glitch", 0.4)
CreateButton("LagSwitch", 0.4)
CreateButton("NetworkAbuse", 0.52)
CreateButton("VoidMode", 0.52)
CreateButton("NoRespawn", 0.64)
CreateButton("SlowPlayers", 0.64)

-- زر تفعيل الكل (Emergency Panic)
local PanicBtn = Instance.new("TextButton")
PanicBtn.Size = UDim2.new(0.92, 0, 0, 38)
PanicBtn.Position = UDim2.new(0.04, 0, 0.78, 0)
PanicBtn.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
PanicBtn.Text = "💀 ACTIVATE ALL / PANIC OFF"
PanicBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
PanicBtn.Font = Enum.Font.GothamBold
PanicBtn.TextSize = 14
PanicBtn.Parent = MainFrame
local PanicCorner = Instance.new("UICorner")
PanicCorner.CornerRadius = UDim.new(0, 10)
PanicCorner.Parent = PanicBtn

-- أزرارة التحكم
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 32, 0, 32)
CloseBtn.Position = UDim2.new(1, -42, 0, 8)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 20
CloseBtn.Parent = MainFrame

local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Size = UDim2.new(0, 32, 0, 32)
MinimizeBtn.Position = UDim2.new(1, -80, 0, 8)
MinimizeBtn.BackgroundTransparency = 1
MinimizeBtn.Text = "━"
MinimizeBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.TextSize = 22
MinimizeBtn.Parent = MainFrame

-- =================== قلب السكربت (التقنيات المتقدمة) ===================
local activeMethods = {}
local loops = {}

-- تحديث البينغ
local function updatePing()
    local stats = game:GetService("Stats"):FindFirstChild("Network")
    if stats and stats:FindFirstChild("Ping") then
        local ping = math.floor(stats.Ping.Value)
        PingLabel.Text = string.format("📡 Ping: %d ms", ping)
        if ping > 150 then
            PingLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
            MainFrame.BackgroundColor3 = Color3.fromRGB(40, 0, 0)
        elseif ping > 80 then
            PingLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
            MainFrame.BackgroundColor3 = Color3.fromRGB(25, 20, 35)
        else
            PingLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
            MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        end
    end
end

spawn(function()
    while wait(1) do updatePing() end
end)

-- 🔥 1. RakNet Desync (يحتاج مشغل مثل Delta)
local function toggleRakNet(state)
    if state then
        local success, res = pcall(function()
            if getrenv()._G.raknet and getrenv()._G.raknet.desync then
                getrenv()._G.raknet.desync(true)
            elseif syn and syn.raknet then
                syn.raknet.desync(true)
            else
                warn("[RakNet] Executor might not support this feature")
            end
        end)
        if not success then warn("[RakNet] Feature not supported in this executor") end
    else
        pcall(function()
            if getrenv()._G.raknet and getrenv()._G.raknet.desync then
                getrenv()._G.raknet.desync(false)
            elseif syn and syn.raknet then
                syn.raknet.desync(false)
            end
        end)
    end
end

-- ⚡ 2. FastFlag Break (تعطيل الفيزياء)
local origWorldStep = nil
local origPhysicsSender = nil
local function toggleFastFlag(state)
    if state then
        origWorldStep = getfflag("WorldStepMax")
        origPhysicsSender = getfflag("DFIntS2PhysicsSenderRate")
        setfflag("WorldStepMax", "-99999999999")
        setfflag("DFIntS2PhysicsSenderRate", "1")
        setfflag("FFlagSimIslandizerManager", "false")
        sethiddenproperty(game:GetService("Workspace"), "PhysicsSenderRate", 1)
    else
        if origWorldStep then setfflag("WorldStepMax", origWorldStep) end
        if origPhysicsSender then setfflag("DFIntS2PhysicsSenderRate", origPhysicsSender) end
        setfflag("FFlagSimIslandizerManager", "true")
    end
end

-- 👾 3. Glitch Mode (تشنج الجسم للسيرفر)
local glitchLoop = nil
local function toggleGlitch(state)
    if state then
        glitchLoop = RunService.RenderStepped:Connect(function()
            if activeMethods.Glitch then
                pcall(function()
                    local randomVel = Vector3.new(math.random(-150, 150), math.random(-80, 80), math.random(-150, 150))
                    if RootPart then RootPart.Velocity = randomVel end
                    wait(0.03)
                    if RootPart then RootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0) end
                end)
            end
        end)
    else
        if glitchLoop then glitchLoop:Disconnect() end
        pcall(function()
            if RootPart then
                RootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                RootPart.Velocity = Vector3.new(0, 0, 0)
            end
        end)
    end
end

-- 🐌 4. Lag Switch (تقطيع الشبكة)
local lagLoop = nil
local function toggleLagSwitch(state)
    if state then
        lagLoop = RunService.Heartbeat:Connect(function()
            if activeMethods.LagSwitch then
                pcall(function()
                    for i = 1, 10 do
                        local remote = Instance.new("RemoteEvent")
                        remote.Name = "LagBuffer_" .. i
                        remote.Parent = game:GetService("ReplicatedStorage")
                        remote:FireServer()
                        game:GetService("Debris"):AddItem(remote, 0.05)
                    end
                end)
                wait(0.1)
            end
        end)
    else
        if lagLoop then lagLoop:Disconnect() end
    end
end

-- 🌐 5. Network Abuse (تدمير ملكية الشبكة)
local netLoop = nil
local fakeChar = nil
local function toggleNetworkAbuse(state)
    if state then
        if fakeChar then fakeChar:Destroy() end
        fakeChar = Character:Clone()
        fakeChar.Name = "FakeClone_" .. Player.Name
        fakeChar.Parent = workspace
        for _, part in ipairs(fakeChar:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Transparency = 0.9
                part.Color = Color3.fromRGB(255, 0, 255)
                part.Material = Enum.Material.Neon
                part.CanCollide = false
            elseif part:IsA("Humanoid") then
                part.PlatformStand = true
            end
        end
        netLoop = RunService.RenderStepped:Connect(function()
            if activeMethods.NetworkAbuse then
                pcall(function()
                    RootPart:SetNetworkOwner(nil)
                    wait(0.01)
                    RootPart:SetNetworkOwner(Player)
                    if fakeChar and fakeChar:FindFirstChild("HumanoidRootPart") then
                        fakeChar:SetPrimaryPartCFrame(RootPart.CFrame + Vector3.new(0, 100, 0))
                    end
                end)
            end
        end)
    else
        if netLoop then netLoop:Disconnect() end
        if fakeChar then fakeChar:Destroy() end
        pcall(function() RootPart:SetNetworkOwner(nil) wait(0.1) RootPart:SetNetworkOwner(Player) end)
    end
end

-- 🕳️ 6. Void Mode (عدم الموت)
local voidLoop = nil
local function toggleVoidMode(state)
    if state then
        voidLoop = RunService.Stepped:Connect(function()
            if activeMethods.VoidMode and RootPart and RootPart.Position.Y < 0 then
                RootPart.CFrame = RootPart.CFrame + Vector3.new(0, 150, 0)
                if Humanoid.Health > 0 then Humanoid.Health = Humanoid.MaxHealth end
            end
        end)
    else
        if voidLoop then voidLoop:Disconnect() end
    end
end

-- ☠️ 7. No Respawn (يمنع الريسبون)
local function toggleNoRespawn(state)
    if state then
        pcall(function()
            local resScript = Instance.new("LocalScript")
            resScript.Name = "AntiRespawn"
            resScript.Parent = Player.PlayerGui
            local code = [[
                local plr = game.Players.LocalPlayer
                plr.CharacterAdded:Connect(function()
                    if plr.Character then
                        plr.Character:BreakJoints()
                    end
                end)
                plr.CharacterAdded:Wait()
                plr.Character:BreakJoints()
            ]]
            resScript.Source = code
        end)
    else
        local anti = Player.PlayerGui:FindFirstChild("AntiRespawn")
        if anti then anti:Destroy() end
    end
end

-- 🐢 8. Slow Players (يبطئ اللاعبين الاخرين - تجريبي)
local slowLoop = nil
local function toggleSlowPlayers(state)
    if state then
        slowLoop = RunService.RenderStepped:Connect(function()
            if activeMethods.SlowPlayers then
                for _, v in ipairs(game.Players:GetPlayers()) do
                    if v ~= Player and v.Character and v.Character:FindFirstChild("Humanoid") then
                        v.Character.Humanoid.WalkSpeed = 8
                        v.Character.Humanoid.JumpPower = 20
                    end
                end
            end
        end)
    else
        if slowLoop then slowLoop:Disconnect() end
        for _, v in ipairs(game.Players:GetPlayers()) do
            if v.Character and v.Character:FindFirstChild("Humanoid") then
                v.Character.Humanoid.WalkSpeed = 16
                v.Character.Humanoid.JumpPower = 50
            end
        end
    end
end

-- ربط الوظائف
local function setMethodState(method, state)
    activeMethods[method] = state
    if method == "RakNet" then toggleRakNet(state)
    elseif method == "FastFlag" then toggleFastFlag(state)
    elseif method == "Glitch" then toggleGlitch(state)
    elseif method == "LagSwitch" then toggleLagSwitch(state)
    elseif method == "NetworkAbuse" then toggleNetworkAbuse(state)
    elseif method == "VoidMode" then toggleVoidMode(state)
    elseif method == "NoRespawn" then toggleNoRespawn(state)
    elseif method == "SlowPlayers" then toggleSlowPlayers(state)
    end
end

-- معالجة الأزرار
for method, data in pairs(Functions) do
    data.Button.MouseButton1Click:Connect(function()
        local newState = not data.Active
        data.Active = newState
        data.Button.BackgroundColor3 = newState and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(30, 30, 45)
        setMethodState(method, newState)
    end)
end

-- زر الطوارئ
PanicBtn.MouseButton1Click:Connect(function()
    local anyActive = false
    for method, data in pairs(Functions) do
        if data.Active then anyActive = true break end
    end
    if anyActive then
        for method, data in pairs(Functions) do
            if data.Active then
                data.Active = false
                data.Button.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
                setMethodState(method, false)
            end
        end
        PanicBtn.Text = "💀 ACTIVATE ALL"
        PanicBtn.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
        Title.Text = "💀 ULTIMATE DESYNC X | STATUS: 🔴"
        ModeLabel.Text = "⚙️ Mode: None"
    else
        for method, data in pairs(Functions) do
            if not data.Active then
                data.Active = true
                data.Button.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
                setMethodState(method, true)
            end
        end
        PanicBtn.Text = "💀 PANIC OFF"
        PanicBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
        Title.Text = "💀 ULTIMATE DESYNC X | STATUS: 🟢"
        ModeLabel.Text = "⚙️ Mode: ALL ACTIVE"
    end
end)

-- أزرار التحكم
local minimized = false
MinimizeBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        MainFrame:TweenSize(UDim2.new(0, 420, 0, 55), "Out", "Quad", 0.25)
        MinimizeBtn.Text = "□"
        for _, data in pairs(Functions) do data.Button.Visible = false end
        PanicBtn.Visible = false
        PingLabel.Visible = false
        ModeLabel.Visible = false
        Line.Visible = false
    else
        MainFrame:TweenSize(UDim2.new(0, 420, 0, 320), "Out", "Quad", 0.25)
        MinimizeBtn.Text = "━"
        wait(0.15)
        for _, data in pairs(Functions) do data.Button.Visible = true end
        PanicBtn.Visible = true
        PingLabel.Visible = true
        ModeLabel.Visible = true
        Line.Visible = true
    end
end)

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui.Enabled = not ScreenGui.Enabled
end)

-- تأثير الانزلاق عند الظهور
MainFrame.BackgroundTransparency = 1
MainFrame.Size = UDim2.new(0, 0, 0, 320)
MainFrame.Position = UDim2.new(0.5, 0, 0.25, 0)
TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Size = UDim2.new(0, 420, 0, 320),
    Position = UDim2.new(0.5, -210, 0.25, 0)
}):Play()
for i = 0, 1, 0.04 do
    MainFrame.BackgroundTransparency = 0.15 * (1 - i) + 0.85 * i
    wait(0.01)
end

-- إعادة تشغيل السكربت عند موت الشخصية
Player.CharacterAdded:Connect(function(newChar)
    Character = newChar
    RootPart = Character:WaitForChild("HumanoidRootPart")
    Humanoid = Character:WaitForChild("Humanoid")
    for method, data in pairs(Functions) do
        if data.Active then
            setMethodState(method, false)
            wait(0.1)
            setMethodState(method, true)
        end
    end
end)

print("═══════════════════════════════════════════════════════")
print("✅ ULTIMATE DESYNC X | جاهز 100%")
print("⚙️ اضغط على الأزرار لتفعيل الكل أو كل ميزة على حدة")
print("⚠️ بعض الميزات تحتاج مشغل متطور مثل Delta Executor")
print("═══════════════════════════════════════════════════════")
