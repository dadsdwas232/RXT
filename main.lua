--[[
    DesyncController v4.0
    Fixed drag, fixed movement, polished UI
]]

-- ========== Services ==========
local Players       = game:GetService("Players")
local TweenService  = game:GetService("TweenService")
local UIS           = game:GetService("UserInputService")
local RunService    = game:GetService("RunService")
local CoreGui       = game:GetService("CoreGui")

local player    = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid  = character:WaitForChild("Humanoid")
local rootPart  = character:WaitForChild("HumanoidRootPart")

-- ========== Cleanup old ==========
local old = CoreGui:FindFirstChild("DesyncPanel_v4")
if old then old:Destroy() end

-- ========== State ==========
local desyncActive = false
local bv, bg       = nil, nil
local desyncConn   = nil   -- RenderStepped connection (not a thread)

-- ========== Helpers ==========
local ti = TweenInfo.new

local function tween(obj, t, props)
    TweenService:Create(obj, ti(t, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), props):Play()
end

-- ========== GUI ==========
local sg = Instance.new("ScreenGui")
sg.Name           = "DesyncPanel_v4"
sg.ResetOnSpawn   = false
sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
sg.IgnoreGuiInset = true
sg.Parent         = CoreGui

-- Main frame
local mf = Instance.new("Frame")
mf.Size             = UDim2.new(0, 370, 0, 200)
mf.Position         = UDim2.new(0.5, -185, 0.25, 0)
mf.BackgroundColor3 = Color3.fromRGB(10, 12, 24)
mf.BorderSizePixel  = 0
mf.ClipsDescendants = true
mf.Parent           = sg

Instance.new("UICorner", mf).CornerRadius = UDim.new(0, 16)

local mfStroke = Instance.new("UIStroke", mf)
mfStroke.Color       = Color3.fromRGB(60, 120, 255)
mfStroke.Thickness   = 1.5
mfStroke.Transparency = 0.35

local mfGrad = Instance.new("UIGradient", mf)
mfGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0,   Color3.fromRGB(16, 20, 42)),
    ColorSequenceKeypoint.new(1,   Color3.fromRGB(9,  11, 22)),
})
mfGrad.Rotation = 120

-- ── Title bar ──
local tb = Instance.new("Frame", mf)
tb.Size             = UDim2.new(1, 0, 0, 50)
tb.BackgroundColor3 = Color3.fromRGB(16, 20, 44)
tb.BorderSizePixel  = 0
Instance.new("UICorner", tb).CornerRadius = UDim.new(0, 16)
-- fill bottom corners
local tbFix = Instance.new("Frame", tb)
tbFix.Size             = UDim2.new(1, 0, 0, 16)
tbFix.Position         = UDim2.new(0, 0, 1, -16)
tbFix.BackgroundColor3 = Color3.fromRGB(16, 20, 44)
tbFix.BorderSizePixel  = 0

-- Icon
local icn = Instance.new("TextLabel", tb)
icn.Size               = UDim2.new(0, 34, 0, 34)
icn.Position           = UDim2.new(0, 12, 0.5, -17)
icn.BackgroundTransparency = 1
icn.Text               = "⚡"
icn.TextSize           = 20
icn.Font               = Enum.Font.GothamBold
icn.TextColor3         = Color3.fromRGB(90, 160, 255)

-- Title text
local ttl = Instance.new("TextLabel", tb)
ttl.Size               = UDim2.new(1, -120, 0, 24)
ttl.Position           = UDim2.new(0, 50, 0, 7)
ttl.BackgroundTransparency = 1
ttl.Text               = "DESYNC CONTROLLER"
ttl.TextColor3         = Color3.fromRGB(215, 228, 255)
ttl.Font               = Enum.Font.GothamBold
ttl.TextSize           = 16
ttl.TextXAlignment     = Enum.TextXAlignment.Left

local ver = Instance.new("TextLabel", tb)
ver.Size               = UDim2.new(1, -120, 0, 14)
ver.Position           = UDim2.new(0, 50, 0, 31)
ver.BackgroundTransparency = 1
ver.Text               = "v4.0  ·  drag to move"
ver.TextColor3         = Color3.fromRGB(60, 80, 140)
ver.Font               = Enum.Font.Gotham
ver.TextSize           = 10
ver.TextXAlignment     = Enum.TextXAlignment.Left

-- Title bar buttons
local function mkBtn(xOff, label, col)
    local b = Instance.new("TextButton", tb)
    b.Size               = UDim2.new(0, 26, 0, 26)
    b.Position           = UDim2.new(1, xOff, 0.5, -13)
    b.BackgroundColor3   = Color3.fromRGB(25, 30, 55)
    b.BackgroundTransparency = 0.2
    b.Text               = label
    b.TextColor3         = col
    b.Font               = Enum.Font.GothamBold
    b.TextSize           = 13
    b.AutoButtonColor    = false
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 7)

    b.MouseEnter:Connect(function()
        tween(b, 0.1, {BackgroundColor3 = col, TextColor3 = Color3.new(1,1,1)})
    end)
    b.MouseLeave:Connect(function()
        tween(b, 0.1, {BackgroundColor3 = Color3.fromRGB(25,30,55), TextColor3 = col})
    end)
    return b
end

local closeBtn = mkBtn(-10, "✕", Color3.fromRGB(255, 75, 75))
local minBtn   = mkBtn(-44, "—", Color3.fromRGB(180, 180, 200))

-- ── Status row ──
local statusDot = Instance.new("Frame", mf)
statusDot.Size             = UDim2.new(0, 10, 0, 10)
statusDot.Position         = UDim2.new(0, 16, 0, 66)
statusDot.BackgroundColor3 = Color3.fromRGB(255, 75, 75)
statusDot.BorderSizePixel  = 0
Instance.new("UICorner", statusDot).CornerRadius = UDim.new(1, 0)

local statusTxt = Instance.new("TextLabel", mf)
statusTxt.Size             = UDim2.new(1, -40, 0, 22)
statusTxt.Position         = UDim2.new(0, 34, 0, 59)
statusTxt.BackgroundTransparency = 1
statusTxt.Text             = "OFFLINE  —  Ready"
statusTxt.TextColor3       = Color3.fromRGB(255, 90, 90)
statusTxt.Font             = Enum.Font.GothamBold
statusTxt.TextSize         = 13
statusTxt.TextXAlignment   = Enum.TextXAlignment.Left

-- ── Divider ──
local div = Instance.new("Frame", mf)
div.Size             = UDim2.new(1, -28, 0, 1)
div.Position         = UDim2.new(0, 14, 0, 92)
div.BackgroundColor3 = Color3.fromRGB(30, 40, 80)
div.BorderSizePixel  = 0

-- ── Toggle button ──
local tog = Instance.new("TextButton", mf)
tog.Size             = UDim2.new(1, -28, 0, 60)
tog.Position         = UDim2.new(0, 14, 0, 102)
tog.BackgroundColor3 = Color3.fromRGB(190, 40, 40)
tog.Text             = "▶   ACTIVATE DESYNC"
tog.TextColor3       = Color3.fromRGB(255, 255, 255)
tog.Font             = Enum.Font.GothamBold
tog.TextSize         = 16
tog.AutoButtonColor  = false
tog.BorderSizePixel  = 0
Instance.new("UICorner", tog).CornerRadius = UDim.new(0, 12)

local togGrad = Instance.new("UIGradient", tog)
togGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(220, 50, 50)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(160, 28, 28)),
})
togGrad.Rotation = 90

-- glow behind button
local glow = Instance.new("Frame", mf)
glow.Size             = UDim2.new(1, -16, 0, 70)
glow.Position         = UDim2.new(0, 8, 0, 97)
glow.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
glow.BackgroundTransparency = 0.82
glow.BorderSizePixel  = 0
glow.ZIndex           = 0
Instance.new("UICorner", glow).CornerRadius = UDim.new(0, 14)

-- ── Hover effects on toggle ──
tog.MouseEnter:Connect(function()
    tween(tog, 0.12, {BackgroundTransparency = 0.1})
end)
tog.MouseLeave:Connect(function()
    tween(tog, 0.12, {BackgroundTransparency = 0})
end)

-- ========== DRAG (fixed) ==========
-- Uses RunService.RenderStepped so it never misses a frame,
-- and reads absolute mouse position to avoid sub-frame delta bugs.
do
    local dragging = false
    local dragOffX, dragOffY = 0, 0

    -- InputBegan on the whole titleBar frame (not buttons — buttons have their own sinks)
    tb.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            -- offset from top-left of frame to mouse
            local abs = mf.AbsolutePosition
            dragOffX = inp.Position.X - abs.X
            dragOffY = inp.Position.Y - abs.Y
        end
    end)

    UIS.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    RunService.RenderStepped:Connect(function()
        if not dragging then return end
        local mp = UIS:GetMouseLocation()
        -- clamp inside screen
        local vp = game.Workspace.CurrentCamera.ViewportSize
        local nx = math.clamp(mp.X - dragOffX, 0, vp.X - mf.AbsoluteSize.X)
        local ny = math.clamp(mp.Y - dragOffY, 0, vp.Y - mf.AbsoluteSize.Y)
        mf.Position = UDim2.new(0, nx, 0, ny)
    end)
end

-- ========== Minimize / Close ==========
local minimized   = false
local sizeOpen    = UDim2.new(0, 370, 0, 200)
local sizeClosed  = UDim2.new(0, 370, 0, 50)

minBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    tween(mf, 0.22, {Size = minimized and sizeClosed or sizeOpen})
    minBtn.Text = minimized and "□" or "—"
end)

closeBtn.MouseButton1Click:Connect(function()
    sg.Enabled = not sg.Enabled
end)

-- ========== UI state updater ==========
local function setUI(on)
    if on then
        statusDot.BackgroundColor3 = Color3.fromRGB(60, 230, 120)
        tween(statusDot, 0.2, {BackgroundColor3 = Color3.fromRGB(60, 230, 120)})
        statusTxt.Text      = "ACTIVE  —  Running"
        statusTxt.TextColor3 = Color3.fromRGB(70, 240, 130)
        tog.Text            = "■   DEACTIVATE DESYNC"
        tween(tog,  0.2, {BackgroundColor3 = Color3.fromRGB(35, 165, 80)})
        tween(glow, 0.2, {BackgroundColor3 = Color3.fromRGB(40, 180, 85)})
        togGrad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(50, 190, 95)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(28, 130, 60)),
        })
        mfStroke.Color = Color3.fromRGB(50, 210, 100)
    else
        tween(statusDot, 0.2, {BackgroundColor3 = Color3.fromRGB(255, 75, 75)})
        statusTxt.Text       = "OFFLINE  —  Ready"
        statusTxt.TextColor3 = Color3.fromRGB(255, 90, 90)
        tog.Text             = "▶   ACTIVATE DESYNC"
        tween(tog,  0.2, {BackgroundColor3 = Color3.fromRGB(190, 40, 40)})
        tween(glow, 0.2, {BackgroundColor3 = Color3.fromRGB(200, 40, 40)})
        togGrad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(220, 50, 50)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(160, 28, 28)),
        })
        mfStroke.Color = Color3.fromRGB(60, 120, 255)
    end
end

-- ========== Physics helpers ==========
local function cleanPhysics()
    if bv and bv.Parent then bv:Destroy() end
    if bg and bg.Parent then bg:Destroy() end
    bv, bg = nil, nil
end

--[[
    The FIXED movement approach:
    Instead of BodyVelocity (which blocks ALL movement including player input),
    we use a lightweight RenderStepped loop that only fires random velocity
    bursts. The humanoid WalkSpeed is kept normal so the player can still move.
    BodyVelocity is created with ZERO MaxForce on Y so gravity/jumping works.
]]
local function startDesync()
    if desyncActive then return end
    desyncActive = true
    setUI(true)
    cleanPhysics()

    -- No BodyVelocity/BodyGyro at all — they break normal movement.
    -- Instead, fire random AssemblyLinearVelocity bursts every N frames
    -- while preserving humanoid control.
    local tick = 0
    desyncConn = RunService.Heartbeat:Connect(function(dt)
        if not desyncActive then return end
        tick = tick + dt
        if tick < 0.09 then return end
        tick = 0
        pcall(function()
            if rootPart and rootPart.Parent then
                -- Add random lateral impulse — NOT override, just add on top
                -- This creates desync visually without removing player control
                local cur = rootPart.AssemblyLinearVelocity
                rootPart.AssemblyLinearVelocity = Vector3.new(
                    cur.X + math.random(-90, 90),
                    cur.Y,   -- keep Y so jumping still works
                    cur.Z + math.random(-90, 90)
                )
            end
        end)
    end)

    print("[DesyncController v4] ACTIVE")
end

local function stopDesync()
    if not desyncActive then return end
    desyncActive = false

    if desyncConn then
        desyncConn:Disconnect()
        desyncConn = nil
    end

    cleanPhysics()

    pcall(function()
        if rootPart and rootPart.Parent then
            rootPart.AssemblyLinearVelocity  = Vector3.zero
            rootPart.AssemblyAngularVelocity = Vector3.zero
        end
    end)

    setUI(false)
    print("[DesyncController v4] STOPPED")
end

-- ========== Toggle button ==========
tog.MouseButton1Click:Connect(function()
    -- Press animation
    tween(tog, 0.07, {Size = UDim2.new(1, -36, 0, 56)})
    task.wait(0.07)
    tween(tog, 0.1,  {Size = UDim2.new(1, -28, 0, 60)})

    if desyncActive then stopDesync() else startDesync() end
end)

-- ========== Character respawn ==========
player.CharacterAdded:Connect(function(newChar)
    local was = desyncActive
    if was then stopDesync() end

    character = newChar
    humanoid  = newChar:WaitForChild("Humanoid")
    rootPart  = newChar:WaitForChild("HumanoidRootPart")

    if was then
        task.wait(0.4)
        startDesync()
    end
end)

-- ========== Entrance animation ==========
mf.Size     = UDim2.new(0, 370, 0, 0)
mf.Position = UDim2.new(0.5, -185, 0.25, 0)
mf.BackgroundTransparency = 1

task.spawn(function()
    task.wait(0.05)
    TweenService:Create(mf,
        TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        {Size = sizeOpen, BackgroundTransparency = 0}
    ):Play()
end)

print("╔══════════════════════════════════╗")
print("║   DesyncController v4.0  Ready  ║")
print("║   Drag title bar  ·  [—] min    ║")
print("║   [✕] toggle visibility         ║")
print("╚══════════════════════════════════╝")
