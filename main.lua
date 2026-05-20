--[[
╔══════════════════════════════════════════════════════════════════╗
║                    K V N  —  Premium UI  v2                     ║
║                  Full Redesign  |  discord.gg/4wxph9Ynz6        ║
╚══════════════════════════════════════════════════════════════════╝
  Toggle visibility : RightShift
  Drag              : Click & drag the top bar
--]]

-- ─────────────────────────────────────────────
--  SERVICES
-- ─────────────────────────────────────────────
local Players          = game:GetService("Players")
local TweenService     = game:GetService("TweenService")
local RunService       = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local HttpService      = game:GetService("HttpService")
local LocalPlayer      = Players.LocalPlayer

-- ─────────────────────────────────────────────
--  PALETTE
-- ─────────────────────────────────────────────
local C = {
    Bg          = Color3.fromRGB(7,  7,  13),
    BgMid       = Color3.fromRGB(10, 10, 18),
    BgHigh      = Color3.fromRGB(14, 14, 25),
    Panel       = Color3.fromRGB(11, 11, 20),
    PanelHi     = Color3.fromRGB(17, 17, 30),
    PanelHover  = Color3.fromRGB(22, 22, 38),
    Border      = Color3.fromRGB(35, 35, 60),
    BorderHi    = Color3.fromRGB(60, 55, 110),

    -- Accent family
    A1          = Color3.fromRGB(112, 80, 255),   -- violet
    A2          = Color3.fromRGB(80,  55, 200),   -- deep violet
    A3          = Color3.fromRGB(0,   200, 255),  -- cyan
    A4          = Color3.fromRGB(160, 110, 255),  -- lavender
    AGlow       = Color3.fromRGB(60,  40, 160),

    -- Semantic
    Green       = Color3.fromRGB(50,  210, 130),
    Yellow      = Color3.fromRGB(255, 185, 50),
    Red         = Color3.fromRGB(255, 65,  85),
    Pink        = Color3.fromRGB(255, 80,  180),

    -- Text
    T1          = Color3.fromRGB(235, 235, 255),
    T2          = Color3.fromRGB(145, 140, 185),
    T3          = Color3.fromRGB(70,  68, 105),
    White       = Color3.fromRGB(255, 255, 255),
    Black       = Color3.fromRGB(0,   0,   0),
}

-- ─────────────────────────────────────────────
--  TWEEN SHORTCUTS
-- ─────────────────────────────────────────────
local function tw(obj, props, t, style, dir)
    local ti = TweenInfo.new(t or .28, style or Enum.EasingStyle.Quint, dir or Enum.EasingDirection.Out)
    local tween = TweenService:Create(obj, ti, props)
    tween:Play()
    return tween
end

local function twSpring(obj, props, t)
    return tw(obj, props, t or .45, Enum.EasingStyle.Spring, Enum.EasingDirection.Out)
end

-- ─────────────────────────────────────────────
--  INSTANCE HELPER
-- ─────────────────────────────────────────────
local function N(cls, p, kids)
    local i = Instance.new(cls)
    for k, v in pairs(p or {}) do i[k] = v end
    for _, c in pairs(kids or {}) do c.Parent = i end
    return i
end

local function Rnd(r)  return N("UICorner",  { CornerRadius = UDim.new(0, r or 8) }) end
local function Pad(t,b,l,r) return N("UIPadding",{PaddingTop=UDim.new(0,t or 0),PaddingBottom=UDim.new(0,b or 0),PaddingLeft=UDim.new(0,l or 0),PaddingRight=UDim.new(0,r or 0)}) end
local function Str(col,thk,trn) return N("UIStroke",{Color=col or C.Border,Thickness=thk or 1,Transparency=trn or 0}) end
local function Grad(c0,c1,rot)
    return N("UIGradient",{
        Color    = ColorSequence.new(c0, c1),
        Rotation = rot or 90,
    })
end

-- ─────────────────────────────────────────────
--  SCREEN GUI
-- ─────────────────────────────────────────────
-- Remove old instance if re-running
local old = LocalPlayer:FindFirstChild("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild("KVN_v2")
if old then old:Destroy() end

local ScreenGui = N("ScreenGui",{
    Name           = "KVN_v2",
    ResetOnSpawn   = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    DisplayOrder   = 999,
    Parent         = LocalPlayer:WaitForChild("PlayerGui"),
})

-- ─────────────────────────────────────────────
--  ROOT WINDOW  (640 × 420)
-- ─────────────────────────────────────────────
local W, H = 640, 430
local Root = N("Frame",{
    Name             = "Root",
    Size             = UDim2.new(0, W, 0, H),
    Position         = UDim2.new(0.5, -W/2, 0.5, -H/2),
    BackgroundColor3 = C.Bg,
    BorderSizePixel  = 0,
    ClipsDescendants = true,
    Parent           = ScreenGui,
},{Rnd(14)})

-- Outer stroke (glow border)
local OuterStroke = Str(C.A1, 1.5, 0.45)
OuterStroke.Parent = Root

-- Background ambient glow layer
local BgGlow = N("Frame",{
    Size             = UDim2.new(1, 120, 1, 120),
    Position         = UDim2.new(0,-60,0,-60),
    BackgroundColor3 = C.A1,
    BackgroundTransparency = 0.88,
    ZIndex           = 0,
    Parent           = Root,
},{Rnd(60)})

-- Mesh-style background gradient
N("UIGradient",{
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0,   Color3.fromRGB(9,  7, 18)),
        ColorSequenceKeypoint.new(0.4, Color3.fromRGB(7,  9, 16)),
        ColorSequenceKeypoint.new(1,   Color3.fromRGB(10, 7, 20)),
    }),
    Rotation = 145,
    Parent   = Root,
})

-- ─────────────────────────────────────────────
--  TOP CHROMATIC BAR
-- ─────────────────────────────────────────────
local TopBar = N("Frame",{
    Size             = UDim2.new(0, 0, 0, 2),
    Position         = UDim2.new(0, 0, 0, 0),
    BackgroundColor3 = C.A1,
    BorderSizePixel  = 0,
    ZIndex           = 20,
    Parent           = Root,
},{Rnd(1)})
N("UIGradient",{
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0,   C.A3),
        ColorSequenceKeypoint.new(0.4, C.A4),
        ColorSequenceKeypoint.new(0.7, C.A1),
        ColorSequenceKeypoint.new(1,   C.Pink),
    }),
    Parent = TopBar,
})

-- ─────────────────────────────────────────────
--  TITLE BAR  (drag handle)
-- ─────────────────────────────────────────────
local TitleBar = N("Frame",{
    Name             = "TitleBar",
    Size             = UDim2.new(1, 0, 0, 46),
    Position         = UDim2.new(0, 0, 0, 2),
    BackgroundColor3 = C.BgMid,
    BorderSizePixel  = 0,
    ZIndex           = 10,
    Parent           = Root,
})
N("UIGradient",{
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(13,12,24)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(9, 8, 17)),
    }),
    Rotation = 90,
    Parent   = TitleBar,
})

-- Title text
local TitleTxt = N("TextLabel",{
    Size             = UDim2.new(0, 200, 1, 0),
    Position         = UDim2.new(0, 18, 0, 0),
    BackgroundTransparency = 1,
    Text             = "KVN",
    Font             = Enum.Font.GothamBold,
    TextSize         = 16,
    TextColor3       = C.White,
    TextXAlignment   = Enum.TextXAlignment.Left,
    ZIndex           = 11,
    Parent           = TitleBar,
})
N("UIGradient",{
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, C.White),
        ColorSequenceKeypoint.new(0.5, C.A4),
        ColorSequenceKeypoint.new(1, C.A3),
    }),
    Parent = TitleTxt,
})

-- Sub-title
N("TextLabel",{
    Size             = UDim2.new(0, 200, 0, 14),
    Position         = UDim2.new(0, 18, 0.5, 2),
    BackgroundTransparency = 1,
    Text             = "PREMIUM UI  ·  v2.0",
    Font             = Enum.Font.Gotham,
    TextSize         = 9,
    TextColor3       = C.T3,
    TextXAlignment   = Enum.TextXAlignment.Left,
    ZIndex           = 11,
    Parent           = TitleBar,
})

-- CONTROL BUTTONS (top-right)
local function CtrlBtn(offset, col, sym)
    local b = N("TextButton",{
        Size             = UDim2.new(0, 28, 0, 28),
        Position         = UDim2.new(1, offset, 0.5, -14),
        BackgroundColor3 = C.PanelHi,
        Text             = sym,
        Font             = Enum.Font.GothamBold,
        TextSize         = 11,
        TextColor3       = col,
        ZIndex           = 12,
        AutoButtonColor  = false,
        Parent           = TitleBar,
    },{Rnd(8), Str(C.Border, 1, 0.3)})
    b.MouseEnter:Connect(function() tw(b,{BackgroundColor3=col, TextColor3=C.Black},.14) end)
    b.MouseLeave:Connect(function() tw(b,{BackgroundColor3=C.PanelHi, TextColor3=col},.18) end)
    b.MouseButton1Down:Connect(function() tw(b,{Size=UDim2.new(0,24,0,24),Position=UDim2.new(1,offset+2,.5,-12)},.08) end)
    b.MouseButton1Up:Connect(function()   tw(b,{Size=UDim2.new(0,28,0,28),Position=UDim2.new(1,offset,.5,-14)},.15) end)
    return b
end

local BtnClose = CtrlBtn(-40, C.Red,    "✕")
local BtnMin   = CtrlBtn(-74, C.Yellow, "–")

-- Title bar bottom divider
N("Frame",{
    Size=UDim2.new(1,0,0,1), Position=UDim2.new(0,0,1,-1),
    BackgroundColor3=C.Border, BorderSizePixel=0, ZIndex=11, Parent=TitleBar,
})

-- ─────────────────────────────────────────────
--  LEFT SIDEBAR  (profile + tabs)
-- ─────────────────────────────────────────────
local SIDEBAR_W = 158
local Sidebar = N("Frame",{
    Name             = "Sidebar",
    Size             = UDim2.new(0, SIDEBAR_W, 1, -48),
    Position         = UDim2.new(0, 0, 0, 48),
    BackgroundColor3 = C.Panel,
    BorderSizePixel  = 0,
    ZIndex           = 8,
    Parent           = Root,
})
N("UIGradient",{
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(12,11,22)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(9, 8, 17)),
    }),
    Rotation = 180,
    Parent   = Sidebar,
})

-- Right edge divider line
N("Frame",{
    Size=UDim2.new(0,1,1,0), Position=UDim2.new(1,-1,0,0),
    BackgroundColor3=C.Border, BorderSizePixel=0, ZIndex=9, Parent=Sidebar,
})

-- ── PROFILE AREA ──────────────────────────
local ProfileArea = N("Frame",{
    Size             = UDim2.new(1, 0, 0, 120),
    Position         = UDim2.new(0, 0, 0, 14),
    BackgroundTransparency = 1,
    ZIndex           = 9,
    Parent           = Sidebar,
})

-- Avatar circle bg (glow ring)
local AvatarRingOuter = N("Frame",{
    Size             = UDim2.new(0, 60, 0, 60),
    Position         = UDim2.new(0.5, -30, 0, 0),
    BackgroundColor3 = C.A1,
    BackgroundTransparency = 0.3,
    ZIndex           = 9,
    Parent           = ProfileArea,
},{Rnd(30)})
N("UIGradient",{
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0,   C.A3),
        ColorSequenceKeypoint.new(0.5, C.A1),
        ColorSequenceKeypoint.new(1,   C.Pink),
    }),
    Parent = AvatarRingOuter,
})

-- Inner circle (clips image)
local AvatarFrame = N("Frame",{
    Size             = UDim2.new(0, 54, 0, 54),
    Position         = UDim2.new(0.5,-27, 0.5,-27),
    BackgroundColor3 = C.BgHigh,
    ZIndex           = 10,
    Parent           = AvatarRingOuter,
},{Rnd(27)})

-- Avatar image (headshot)
local AvatarImg = N("ImageLabel",{
    Size             = UDim2.new(1,0,1,0),
    BackgroundTransparency = 1,
    Image            = "https://www.roblox.com/headshot-thumbnail/image?userId="..LocalPlayer.UserId.."&width=150&height=150&format=png",
    ZIndex           = 11,
    Parent           = AvatarFrame,
},{Rnd(27)})

-- Username
local UsernameLbl = N("TextLabel",{
    Size             = UDim2.new(1, -10, 0, 18),
    Position         = UDim2.new(0, 5, 0, 68),
    BackgroundTransparency = 1,
    Text             = LocalPlayer.Name,
    Font             = Enum.Font.GothamBold,
    TextSize         = 12,
    TextColor3       = C.T1,
    TextXAlignment   = Enum.TextXAlignment.Center,
    ZIndex           = 9,
    Parent           = ProfileArea,
})

-- Discord animated label
local DiscordStatic  = "discord.gg/4wxph9Y"
local DiscordSuffix  = "nz6"
local DiscordLbl = N("TextLabel",{
    Size             = UDim2.new(1, -10, 0, 14),
    Position         = UDim2.new(0, 5, 0, 88),
    BackgroundTransparency = 1,
    Text             = DiscordStatic .. DiscordSuffix,
    Font             = Enum.Font.Gotham,
    TextSize         = 9,
    TextColor3       = C.A3,
    TextXAlignment   = Enum.TextXAlignment.Center,
    ZIndex           = 9,
    TextTruncate     = Enum.TextTruncate.None,
    Parent           = ProfileArea,
})

-- Copy Discord button
local CopyBtn = N("TextButton",{
    Size             = UDim2.new(1, -24, 0, 24),
    Position         = UDim2.new(0, 12, 0, 106),
    BackgroundColor3 = C.AGlow,
    Text             = "⧉  COPY DISCORD",
    Font             = Enum.Font.GothamBold,
    TextSize         = 9,
    TextColor3       = C.A4,
    ZIndex           = 9,
    AutoButtonColor  = false,
    Parent           = ProfileArea,
},{Rnd(6), Str(C.A2, 1, 0.3)})
N("UIGradient",{
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(30,20,70)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(20,14,50)),
    }),
    Rotation = 90,
    Parent   = CopyBtn,
})

CopyBtn.MouseEnter:Connect(function() tw(CopyBtn,{BackgroundColor3=C.A2},.15) end)
CopyBtn.MouseLeave:Connect(function() tw(CopyBtn,{BackgroundColor3=C.AGlow},.2) end)

local copyDebounce = false
CopyBtn.MouseButton1Click:Connect(function()
    if copyDebounce then return end
    copyDebounce = true
    -- Copy to clipboard (executor environments support this)
    pcall(function() setclipboard("https://discord.gg/4wxph9Ynz6") end)
    local orig = CopyBtn.Text
    tw(CopyBtn, {TextColor3=C.Green}, .1)
    CopyBtn.Text = "✓  COPIED!"
    task.wait(1.5)
    CopyBtn.Text = orig
    tw(CopyBtn, {TextColor3=C.A4}, .2)
    copyDebounce = false
end)

-- Divider below profile
N("Frame",{
    Size=UDim2.new(1,-24,0,1), Position=UDim2.new(0,12,0,138),
    BackgroundColor3=C.Border, BorderSizePixel=0, ZIndex=9, Parent=Sidebar,
})

-- ── TAB LIST ──────────────────────────────
local TabList = N("Frame",{
    Size             = UDim2.new(1, 0, 1, -148),
    Position         = UDim2.new(0, 0, 0, 148),
    BackgroundTransparency = 1,
    ZIndex           = 9,
    Parent           = Sidebar,
})
N("UIListLayout",{
    FillDirection = Enum.FillDirection.Vertical,
    SortOrder     = Enum.SortOrder.LayoutOrder,
    Padding       = UDim.new(0, 3),
    Parent        = TabList,
})
Pad(6,6,8,8).Parent = TabList

-- Tab definitions
local TAB_DEFS = {
    { name = "MAIN",   icon = "⬡",  color = C.A1  },
    { name = "MAIN 2", icon = "⬡",  color = C.A3  },
    { name = "MAIN 3", icon = "⬡",  color = C.Green },
    { name = "DEV",    icon = "◈",  color = C.Pink },
}

-- ─────────────────────────────────────────────
--  CONTENT AREA
-- ─────────────────────────────────────────────
local ContentArea = N("Frame",{
    Name             = "ContentArea",
    Size             = UDim2.new(1, -SIDEBAR_W, 1, -48),
    Position         = UDim2.new(0, SIDEBAR_W, 0, 48),
    BackgroundTransparency = 1,
    ClipsDescendants = true,
    ZIndex           = 7,
    Parent           = Root,
})

-- ─────────────────────────────────────────────
--  FOOTER / WATERMARK
-- ─────────────────────────────────────────────
local Footer = N("Frame",{
    Size             = UDim2.new(1,-SIDEBAR_W,0,26),
    Position         = UDim2.new(0,SIDEBAR_W,1,-26),
    BackgroundColor3 = Color3.fromRGB(8,8,15),
    BorderSizePixel  = 0,
    ZIndex           = 10,
    Parent           = Root,
})
N("Frame",{Size=UDim2.new(1,0,0,1),BackgroundColor3=C.Border,BorderSizePixel=0,ZIndex=11,Parent=Footer})
local WMark = N("TextLabel",{
    Size=UDim2.new(1,0,1,0),
    BackgroundTransparency=1,
    Text="✦  K V N  ·  Premium UI  ✦",
    Font=Enum.Font.GothamBold,
    TextSize=9,
    TextColor3=C.T3,
    ZIndex=11,
    Parent=Footer,
})
N("UIGradient",{
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0,   C.T3),
        ColorSequenceKeypoint.new(0.4, C.A4),
        ColorSequenceKeypoint.new(0.6, C.A3),
        ColorSequenceKeypoint.new(1,   C.T3),
    }),
    Parent = WMark,
})

-- ─────────────────────────────────────────────
--  COMPONENT HELPERS  (buttons, toggles, sliders)
-- ─────────────────────────────────────────────

-- Section card
local function Section(parent, title, order)
    local card = N("Frame",{
        Size             = UDim2.new(1, -20, 0, 0),
        AutomaticSize    = Enum.AutomaticSize.Y,
        BackgroundColor3 = C.PanelHi,
        BorderSizePixel  = 0,
        ZIndex           = 12,
        LayoutOrder      = order or 0,
        Parent           = parent,
    },{Rnd(10), Str(C.Border,1,0.55), Pad(10,10,12,12)})

    -- Section header row
    local hdr = N("Frame",{
        Size=UDim2.new(1,0,0,20),
        BackgroundTransparency=1, ZIndex=13, Parent=card,
    })
    -- tiny accent line
    local aline = N("Frame",{
        Size=UDim2.new(0,3,0,14),
        Position=UDim2.new(0,0,.5,-7),
        BackgroundColor3=C.A1, BorderSizePixel=0, ZIndex=14, Parent=hdr,
    },{Rnd(2)})
    N("TextLabel",{
        Size=UDim2.new(1,-12,1,0), Position=UDim2.new(0,10,0,0),
        BackgroundTransparency=1,
        Text=title:upper(),
        Font=Enum.Font.GothamBold, TextSize=9,
        TextColor3=C.T3,
        TextXAlignment=Enum.TextXAlignment.Left,
        ZIndex=13, Parent=hdr,
    })

    N("Frame",{Size=UDim2.new(1,0,0,1),Position=UDim2.new(0,0,0,26),
        BackgroundColor3=C.Border,BorderSizePixel=0,ZIndex=13,Parent=card})

    local body = N("Frame",{
        Size=UDim2.new(1,0,0,0),
        Position=UDim2.new(0,0,0,34),
        AutomaticSize=Enum.AutomaticSize.Y,
        BackgroundTransparency=1, ZIndex=13, Parent=card,
    })
    N("UIListLayout",{
        FillDirection=Enum.FillDirection.Vertical,
        SortOrder=Enum.SortOrder.LayoutOrder,
        Padding=UDim.new(0,5),
        Parent=body,
    })

    return card, body, aline
end

-- Action Button
local function Btn(parent, label, sub, accent, order)
    accent = accent or C.A1
    local b = N("TextButton",{
        Size=UDim2.new(1,0,0,42),
        BackgroundColor3=C.Panel,
        Text="", AutoButtonColor=false,
        ZIndex=14, LayoutOrder=order or 0,
        Parent=parent,
    },{Rnd(8), Str(C.Border,1,0.6)})

    local accentBar = N("Frame",{
        Size=UDim2.new(0,3,0,20),
        Position=UDim2.new(0,10,.5,-10),
        BackgroundColor3=accent,
        BorderSizePixel=0, ZIndex=15, Parent=b,
    },{Rnd(2)})

    N("TextLabel",{
        Size=UDim2.new(1,-50,0,16),
        Position=UDim2.new(0,22,0,7),
        BackgroundTransparency=1,
        Text=label, Font=Enum.Font.GothamSemibold,
        TextSize=13, TextColor3=C.T1,
        TextXAlignment=Enum.TextXAlignment.Left,
        ZIndex=15, Parent=b,
    })

    if sub then
        N("TextLabel",{
            Size=UDim2.new(1,-50,0,12),
            Position=UDim2.new(0,22,0,24),
            BackgroundTransparency=1,
            Text=sub, Font=Enum.Font.Gotham,
            TextSize=10, TextColor3=C.T3,
            TextXAlignment=Enum.TextXAlignment.Left,
            ZIndex=15, Parent=b,
        })
    end

    -- Chevron
    N("TextLabel",{
        Size=UDim2.new(0,18,1,0), Position=UDim2.new(1,-26,0,0),
        BackgroundTransparency=1, Text="›",
        Font=Enum.Font.GothamBold, TextSize=20,
        TextColor3=C.T3, ZIndex=15, Parent=b,
    })

    b.MouseEnter:Connect(function()
        tw(b,{BackgroundColor3=C.PanelHover},.15)
        tw(accentBar,{BackgroundColor3=C.A4, Size=UDim2.new(0,3,0,28)},.18)
        tw(b:FindFirstChildOfClass("UIStroke"),{Color=accent,Transparency=.25},.15)
    end)
    b.MouseLeave:Connect(function()
        tw(b,{BackgroundColor3=C.Panel},.2)
        tw(accentBar,{BackgroundColor3=accent, Size=UDim2.new(0,3,0,20)},.22)
        tw(b:FindFirstChildOfClass("UIStroke"),{Color=C.Border,Transparency=.6},.2)
    end)
    b.MouseButton1Down:Connect(function()
        tw(b,{BackgroundColor3=C.PanelHi},.07)
        twSpring(b,{Size=UDim2.new(1,-4,0,40)},.12)
    end)
    b.MouseButton1Up:Connect(function()
        tw(b,{BackgroundColor3=C.PanelHover},.1)
        twSpring(b,{Size=UDim2.new(1,0,0,42)},.25)
    end)
    return b
end

-- Toggle
local function Toggle(parent, label, default, order)
    local state = default or false
    local row = N("Frame",{
        Size=UDim2.new(1,0,0,38),
        BackgroundColor3=C.Panel,
        BorderSizePixel=0, ZIndex=14, LayoutOrder=order or 0,
        Parent=parent,
    },{Rnd(8), Str(C.Border,1,0.6)})

    N("TextLabel",{
        Size=UDim2.new(1,-62,1,0), Position=UDim2.new(0,14,0,0),
        BackgroundTransparency=1,
        Text=label, Font=Enum.Font.GothamSemibold,
        TextSize=13, TextColor3=C.T1,
        TextXAlignment=Enum.TextXAlignment.Left,
        ZIndex=15, Parent=row,
    })

    local track = N("Frame",{
        Size=UDim2.new(0,44,0,22),
        Position=UDim2.new(1,-56,.5,-11),
        BackgroundColor3=state and C.A1 or C.Border,
        BorderSizePixel=0, ZIndex=15, Parent=row,
    },{Rnd(11)})

    local thumb = N("Frame",{
        Size=UDim2.new(0,16,0,16),
        Position=state and UDim2.new(0,25,.5,-8) or UDim2.new(0,3,.5,-8),
        BackgroundColor3=C.White,
        BorderSizePixel=0, ZIndex=16, Parent=track,
    },{Rnd(8)})

    local hitbox = N("TextButton",{
        Size=UDim2.new(1,0,1,0), BackgroundTransparency=1,
        Text="", ZIndex=17, Parent=row,
    })
    hitbox.MouseButton1Click:Connect(function()
        state = not state
        if state then
            tw(track,{BackgroundColor3=C.A1},.2)
            twSpring(thumb,{Position=UDim2.new(0,25,.5,-8)},.3)
        else
            tw(track,{BackgroundColor3=C.Border},.2)
            twSpring(thumb,{Position=UDim2.new(0,3,.5,-8)},.3)
        end
    end)
    row.MouseEnter:Connect(function() tw(row,{BackgroundColor3=C.PanelHover},.15) end)
    row.MouseLeave:Connect(function() tw(row,{BackgroundColor3=C.Panel},.2) end)
    return row
end

-- Slider
local function Slider(parent, label, min, max, default, order)
    min=min or 0; max=max or 100; default=default or 50
    local val = default
    local dragging = false

    local cont = N("Frame",{
        Size=UDim2.new(1,0,0,52),
        BackgroundColor3=C.Panel,
        BorderSizePixel=0, ZIndex=14, LayoutOrder=order or 0,
        Parent=parent,
    },{Rnd(8), Str(C.Border,1,0.6), Pad(8,8,14,14)})

    local topRow = N("Frame",{
        Size=UDim2.new(1,0,0,16),
        BackgroundTransparency=1, ZIndex=15, Parent=cont,
    })
    N("TextLabel",{
        Size=UDim2.new(.7,0,1,0),
        BackgroundTransparency=1, Text=label,
        Font=Enum.Font.GothamSemibold, TextSize=13, TextColor3=C.T1,
        TextXAlignment=Enum.TextXAlignment.Left, ZIndex=15, Parent=topRow,
    })
    local valLbl = N("TextLabel",{
        Size=UDim2.new(.3,0,1,0), Position=UDim2.new(.7,0,0,0),
        BackgroundTransparency=1, Text=tostring(default),
        Font=Enum.Font.GothamBold, TextSize=12, TextColor3=C.A3,
        TextXAlignment=Enum.TextXAlignment.Right, ZIndex=15, Parent=topRow,
    })

    local trackBg = N("Frame",{
        Size=UDim2.new(1,0,0,4),
        Position=UDim2.new(0,0,1,-4),
        BackgroundColor3=C.Border,
        BorderSizePixel=0, ZIndex=15, Parent=cont,
    },{Rnd(2)})

    local pct = (val-min)/(max-min)
    local fill = N("Frame",{
        Size=UDim2.new(pct,0,1,0),
        BackgroundColor3=C.A1,
        BorderSizePixel=0, ZIndex=16, Parent=trackBg,
    },{Rnd(2)})
    N("UIGradient",{
        Color=ColorSequence.new({
            ColorSequenceKeypoint.new(0,C.A3),
            ColorSequenceKeypoint.new(1,C.A4),
        }),
        Parent=fill,
    })

    local knob = N("Frame",{
        Size=UDim2.new(0,14,0,14),
        Position=UDim2.new(pct,-7,.5,-7),
        BackgroundColor3=C.White,
        BorderSizePixel=0, ZIndex=17, Parent=trackBg,
    },{Rnd(7), Str(C.A4,2,0)})

    local drag = N("TextButton",{
        Size=UDim2.new(1,0,0,30),
        Position=UDim2.new(0,0,.5,-15),
        BackgroundTransparency=1, Text="", ZIndex=18, Parent=trackBg,
    })

    local function update(inputX)
        local rel = math.clamp((inputX - trackBg.AbsolutePosition.X)/trackBg.AbsoluteSize.X,0,1)
        val = math.round(min + (max-min)*rel)
        valLbl.Text = tostring(val)
        tw(fill,{Size=UDim2.new(rel,0,1,0)},.04)
        tw(knob,{Position=UDim2.new(rel,-7,.5,-7)},.04)
    end

    drag.MouseButton1Down:Connect(function(x,y) dragging=true; update(x) end)
    UserInputService.InputChanged:Connect(function(inp)
        if dragging and inp.UserInputType==Enum.UserInputType.MouseMovement then update(inp.Position.X) end
    end)
    UserInputService.InputEnded:Connect(function(inp)
        if inp.UserInputType==Enum.UserInputType.MouseButton1 then dragging=false end
    end)
    cont.MouseEnter:Connect(function() tw(cont,{BackgroundColor3=C.PanelHover},.15) end)
    cont.MouseLeave:Connect(function() tw(cont,{BackgroundColor3=C.Panel},.2) end)
    return cont
end

-- ─────────────────────────────────────────────
--  PAGE FACTORY
-- ─────────────────────────────────────────────
local Pages = {}

local function MakePage(id)
    local scroll = N("ScrollingFrame",{
        Name=id,
        Size=UDim2.new(1,0,1,-26),  -- leaves footer visible
        Position=UDim2.new(0,0,0,0),
        BackgroundTransparency=1,
        BorderSizePixel=0,
        ScrollBarThickness=3,
        ScrollBarImageColor3=C.A1,
        CanvasSize=UDim2.new(0,0,0,0),
        AutomaticCanvasSize=Enum.AutomaticSize.Y,
        ZIndex=11,
        Visible=false,
        Parent=ContentArea,
    })
    N("UIListLayout",{
        FillDirection=Enum.FillDirection.Vertical,
        SortOrder=Enum.SortOrder.LayoutOrder,
        Padding=UDim.new(0,10),
        Parent=scroll,
    })
    Pad(12,12,10,10).Parent = scroll
    Pages[id] = scroll
    return scroll
end

-- ─────────────────────────────────────────────
--  BUILD  PAGE CONTENTS
-- ─────────────────────────────────────────────

-- PAGE: MAIN
local PM = MakePage("MAIN")
local s1, b1, al1 = Section(PM,"Quick Actions",1)
N("UIGradient",{Color=ColorSequence.new(C.A1,C.A2),Parent=al1})
Btn(b1,"Feature One",   "Primary function",          C.A1, 1)
Btn(b1,"Feature Two",   "Secondary operation",        C.A3, 2)
Btn(b1,"Feature Three", "Utility handler",            C.Green, 3)

local s2, b2, al2 = Section(PM,"Configuration",2)
N("UIGradient",{Color=ColorSequence.new(C.A3,C.A2),Parent=al2})
Toggle(b2,"Module Alpha",  true,  1)
Toggle(b2,"Module Beta",   false, 2)
Slider(b2,"Speed",         0, 200, 75, 3)
Slider(b2,"Intensity",     0, 100, 40, 4)

-- PAGE: MAIN 2
local PM2 = MakePage("MAIN 2")
local s3, b3, al3 = Section(PM2,"Operations",1)
N("UIGradient",{Color=ColorSequence.new(C.A3,C.CyanDim or C.A2),Parent=al3})
Btn(b3,"Action Alpha",  "Run sequence A",  C.A3, 1)
Btn(b3,"Action Beta",   "Run sequence B",  C.A4, 2)
Btn(b3,"Action Gamma",  "Run sequence C",  C.Yellow, 3)
Btn(b3,"Action Delta",  "Run sequence D",  C.Green, 4)

local s4, b4, al4 = Section(PM2,"Parameters",2)
N("UIGradient",{Color=ColorSequence.new(C.Yellow,C.A1),Parent=al4})
Slider(b4,"Range",     0, 500, 200, 1)
Slider(b4,"Threshold", 0, 100,  55, 2)
Toggle(b4,"Auto Mode", true,  3)
Toggle(b4,"Passive",   false, 4)

-- PAGE: MAIN 3
local PM3 = MakePage("MAIN 3")
local s5, b5, al5 = Section(PM3,"System",1)
N("UIGradient",{Color=ColorSequence.new(C.Green,C.A2),Parent=al5})
Toggle(b5,"Mode X",    false, 1)
Toggle(b5,"Mode Y",    true,  2)
Toggle(b5,"Mode Z",    false, 3)

local s6, b6, al6 = Section(PM3,"Utilities",2)
N("UIGradient",{Color=ColorSequence.new(C.Red,C.A1),Parent=al6})
Btn(b6,"Utility Alpha", "Auxiliary A", C.Red,    1)
Btn(b6,"Utility Beta",  "Auxiliary B", C.A4,     2)
Btn(b6,"Utility Gamma", "Auxiliary C", C.Yellow, 3)
Slider(b6,"Multiplier",0,10,3,4)

-- PAGE: DEV
local PDev = MakePage("DEV")

-- Dev card (special centered profile card)
local devCard = N("Frame",{
    Size=UDim2.new(1,-20,0,0),
    AutomaticSize=Enum.AutomaticSize.Y,
    BackgroundColor3=C.PanelHi,
    BorderSizePixel=0,
    ZIndex=12, LayoutOrder=1,
    Parent=PDev,
},{Rnd(12), Str(C.Border,1,0.5), Pad(20,20,20,20)})

-- Inner glow on dev card
N("UIGradient",{
    Color=ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(20,14,38)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(14,10,26)),
    }),
    Rotation=135,
    Parent=devCard,
})

-- Dev avatar ring
local devRing = N("Frame",{
    Size=UDim2.new(0,80,0,80),
    Position=UDim2.new(.5,-40,0,0),
    BackgroundColor3=C.Pink,
    BackgroundTransparency=0.2,
    ZIndex=13, Parent=devCard,
},{Rnd(40)})
N("UIGradient",{
    Color=ColorSequence.new({
        ColorSequenceKeypoint.new(0,   C.Pink),
        ColorSequenceKeypoint.new(0.5, C.A4),
        ColorSequenceKeypoint.new(1,   C.A3),
    }),
    Parent=devRing,
})

local devInner = N("Frame",{
    Size=UDim2.new(0,72,0,72),
    Position=UDim2.new(.5,-36,.5,-36),
    BackgroundColor3=C.BgHigh,
    ZIndex=14, Parent=devRing,
},{Rnd(36)})

-- Dev avatar: same player headshot as placeholder; swap UserId for dev's actual id
N("ImageLabel",{
    Size=UDim2.new(1,0,1,0),
    BackgroundTransparency=1,
    Image="https://www.roblox.com/headshot-thumbnail/image?userId="..LocalPlayer.UserId.."&width=150&height=150&format=png",
    ZIndex=15, Parent=devInner,
},{Rnd(36)})

-- "real ?" label
N("TextLabel",{
    Size=UDim2.new(1,0,0,22),
    Position=UDim2.new(0,0,0,88),
    BackgroundTransparency=1,
    Text="real ?",
    Font=Enum.Font.GothamBold,
    TextSize=16,
    TextColor3=C.T1,
    TextXAlignment=Enum.TextXAlignment.Center,
    ZIndex=13, Parent=devCard,
})

local devSubLbl = N("TextLabel",{
    Size=UDim2.new(1,0,0,16),
    Position=UDim2.new(0,0,0,112),
    BackgroundTransparency=1,
    Text="Developer  ·  KVN",
    Font=Enum.Font.Gotham,
    TextSize=11,
    TextColor3=C.T3,
    TextXAlignment=Enum.TextXAlignment.Center,
    ZIndex=13, Parent=devCard,
})
N("UIGradient",{
    Color=ColorSequence.new({
        ColorSequenceKeypoint.new(0,C.A4),
        ColorSequenceKeypoint.new(1,C.A3),
    }),
    Parent=devSubLbl,
})

-- Badge row
local badgeRow = N("Frame",{
    Size=UDim2.new(1,0,0,28),
    Position=UDim2.new(0,0,0,136),
    BackgroundTransparency=1,
    ZIndex=13, Parent=devCard,
})
N("UIListLayout",{
    FillDirection=Enum.FillDirection.Horizontal,
    HorizontalAlignment=Enum.HorizontalAlignment.Center,
    SortOrder=Enum.SortOrder.LayoutOrder,
    Padding=UDim.new(0,8),
    Parent=badgeRow,
})

local function DevBadge(text, col)
    local bg = N("Frame",{
        Size=UDim2.new(0,0,0,24),
        AutomaticSize=Enum.AutomaticSize.X,
        BackgroundColor3=col,
        BackgroundTransparency=0.75,
        ZIndex=14, Parent=badgeRow,
    },{Rnd(12), Str(col,1,0.4), Pad(0,0,10,10)})
    N("TextLabel",{
        Size=UDim2.new(0,0,1,0),
        AutomaticSize=Enum.AutomaticSize.X,
        BackgroundTransparency=1,
        Text=text, Font=Enum.Font.GothamBold,
        TextSize=9, TextColor3=col,
        ZIndex=15, Parent=bg,
    })
end

DevBadge("UI DESIGNER", C.A4)
DevBadge("DEVELOPER",   C.A3)
DevBadge("KVN CREW",    C.Pink)

-- ─────────────────────────────────────────────
--  SIDEBAR TAB BUTTONS  +  PAGE SWITCHING
-- ─────────────────────────────────────────────
local TabBtns   = {}
local ActiveIdx = nil

local function SwitchTab(idx)
    if ActiveIdx == idx then return end
    local prev = ActiveIdx
    ActiveIdx  = idx

    for i, def in ipairs(TAB_DEFS) do
        local page = Pages[def.name]
        local btn  = TabBtns[i]

        if i == idx then
            -- Slide in
            local fromX = (prev and idx > prev) and 30 or -30
            page.Position = UDim2.new(0, fromX, 0, 0)
            page.GroupTransparency = 1
            page.Visible = true
            tw(page,{Position=UDim2.new(0,0,0,0), GroupTransparency=0},.3,Enum.EasingStyle.Quint)

            -- Active tab style
            tw(btn,{BackgroundColor3=C.AGlow},.2)
            tw(btn:FindFirstChildOfClass("UIStroke"),{Color=C.A1,Transparency=0.2},.2)
            local lbl = btn:FindFirstChild("Label")
            if lbl then tw(lbl,{TextColor3=C.T1},.2) end
            local ico = btn:FindFirstChild("Icon")
            if ico then tw(ico,{TextColor3=def.color},.2) end

        else
            -- Slide out
            if page.Visible and prev and i == prev then
                local toX = (idx > prev) and -30 or 30
                tw(page,{Position=UDim2.new(0,toX,0,0), GroupTransparency=1},.25,Enum.EasingStyle.Quint)
                task.delay(0.27, function() page.Visible=false end)
            else
                page.Visible=false
            end

            -- Inactive tab style
            tw(btn,{BackgroundColor3=C.Panel},.2)
            local stroke = btn:FindFirstChildOfClass("UIStroke")
            if stroke then tw(stroke,{Color=C.Border,Transparency=0.6},.2) end
            local lbl = btn:FindFirstChild("Label")
            if lbl then tw(lbl,{TextColor3=C.T3},.2) end
            local ico = btn:FindFirstChild("Icon")
            if ico then tw(ico,{TextColor3=C.T3},.2) end
        end
    end
end

for i, def in ipairs(TAB_DEFS) do
    local btn = N("TextButton",{
        Name = def.name,
        Size = UDim2.new(1,0,0,36),
        BackgroundColor3 = C.Panel,
        Text = "",
        AutoButtonColor = false,
        ZIndex = 9,
        LayoutOrder = i,
        Parent = TabList,
    },{Rnd(8), Str(C.Border,1,0.6)})

    -- Icon
    N("TextLabel",{
        Name="Icon",
        Size=UDim2.new(0,20,1,0),
        Position=UDim2.new(0,10,0,0),
        BackgroundTransparency=1,
        Text=def.icon,
        Font=Enum.Font.GothamBold,
        TextSize=13,
        TextColor3=C.T3,
        ZIndex=10, Parent=btn,
    })

    -- Label
    N("TextLabel",{
        Name="Label",
        Size=UDim2.new(1,-38,1,0),
        Position=UDim2.new(0,34,0,0),
        BackgroundTransparency=1,
        Text=def.name,
        Font=Enum.Font.GothamBold,
        TextSize=11,
        TextColor3=C.T3,
        TextXAlignment=Enum.TextXAlignment.Left,
        ZIndex=10, Parent=btn,
    })

    -- Accent dot (hidden when inactive)
    local dot = N("Frame",{
        Name="Dot",
        Size=UDim2.new(0,4,0,4),
        Position=UDim2.new(1,-10,.5,-2),
        BackgroundColor3=def.color,
        BackgroundTransparency=1,
        BorderSizePixel=0, ZIndex=10, Parent=btn,
    },{Rnd(2)})

    btn.MouseEnter:Connect(function()
        if ActiveIdx ~= i then
            tw(btn,{BackgroundColor3=C.PanelHover},.15)
            local lbl = btn:FindFirstChild("Label")
            if lbl then tw(lbl,{TextColor3=C.T2},.15) end
        end
    end)
    btn.MouseLeave:Connect(function()
        if ActiveIdx ~= i then
            tw(btn,{BackgroundColor3=C.Panel},.2)
            local lbl = btn:FindFirstChild("Label")
            if lbl then tw(lbl,{TextColor3=C.T3},.2) end
        end
    end)
    btn.MouseButton1Click:Connect(function() SwitchTab(i) end)

    TabBtns[i] = btn
end

-- ─────────────────────────────────────────────
--  DRAGGING
-- ─────────────────────────────────────────────
do
    local dragging, ds, sp = false, nil, nil
    TitleBar.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            ds = inp.Position
            sp = Root.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(inp)
        if dragging and inp.UserInputType == Enum.UserInputType.MouseMovement then
            local d = inp.Position - ds
            Root.Position = UDim2.new(sp.X.Scale, sp.X.Offset+d.X, sp.Y.Scale, sp.Y.Offset+d.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then dragging=false end
    end)
end

-- ─────────────────────────────────────────────
--  CLOSE  /  MINIMIZE
-- ─────────────────────────────────────────────
local isMinimised  = false
local FULL_H       = H

BtnClose.MouseButton1Click:Connect(function()
    tw(Root, {Size=UDim2.new(0,W,0,0), BackgroundTransparency=1}, .35, Enum.EasingStyle.Quint)
    tw(OuterStroke, {Transparency=1}, .25)
    task.delay(0.38, function() ScreenGui:Destroy() end)
end)

BtnMin.MouseButton1Click:Connect(function()
    if isMinimised then
        isMinimised = false
        tw(Root,{Size=UDim2.new(0,W,0,FULL_H)},.4,Enum.EasingStyle.Back)
    else
        isMinimised = true
        tw(Root,{Size=UDim2.new(0,W,0,48)},.35,Enum.EasingStyle.Quint)
    end
end)

-- ─────────────────────────────────────────────
--  OPEN ANIMATION
-- ─────────────────────────────────────────────
Root.Size                = UDim2.new(0,W,0,0)
Root.BackgroundTransparency = 1
OuterStroke.Transparency = 1

task.spawn(function()
    task.wait(0.06)
    tw(Root,{Size=UDim2.new(0,W,0,FULL_H), BackgroundTransparency=0},.55,Enum.EasingStyle.Back)
    tw(OuterStroke,{Transparency=0.45},.5)
    task.wait(0.12)
    tw(TopBar,{Size=UDim2.new(1,0,0,2)},.65,Enum.EasingStyle.Quint)
    task.wait(0.25)
    SwitchTab(1)
end)

-- ─────────────────────────────────────────────
--  AMBIENT EFFECTS  (heartbeat, lightweight)
-- ─────────────────────────────────────────────
local hbConn
hbConn = RunService.Heartbeat:Connect(function()
    if not Root or not Root.Parent then hbConn:Disconnect() return end
    local t = tick()
    -- glow breathe
    BgGlow.BackgroundTransparency = 0.84 + 0.04 * math.sin(t * 1.4)
    -- outer stroke shimmer
    OuterStroke.Transparency = 0.35 + 0.12 * math.sin(t * 0.9)
end)

-- ─────────────────────────────────────────────
--  DISCORD TYPING ANIMATION
-- ─────────────────────────────────────────────
task.spawn(function()
    local cursor = "|"
    while ScreenGui and ScreenGui.Parent do
        -- Erase suffix one char at a time
        for i = #DiscordSuffix, 0, -1 do
            if not ScreenGui.Parent then return end
            DiscordLbl.Text = DiscordStatic .. string.sub(DiscordSuffix,1,i) .. cursor
            task.wait(0.07)
        end
        task.wait(0.35)
        -- Retype suffix
        for i = 1, #DiscordSuffix do
            if not ScreenGui.Parent then return end
            DiscordLbl.Text = DiscordStatic .. string.sub(DiscordSuffix,1,i) .. cursor
            task.wait(0.09)
        end
        -- Blink cursor a couple times
        for _ = 1, 3 do
            if not ScreenGui.Parent then return end
            DiscordLbl.Text = DiscordStatic .. DiscordSuffix .. " "
            task.wait(0.4)
            DiscordLbl.Text = DiscordStatic .. DiscordSuffix .. cursor
            task.wait(0.4)
        end
        task.wait(0.6)
    end
end)

-- ─────────────────────────────────────────────
--  KEYBIND  —  RightShift to toggle visibility
-- ─────────────────────────────────────────────
UserInputService.InputBegan:Connect(function(inp, gp)
    if gp then return end
    if inp.KeyCode == Enum.KeyCode.RightShift then
        Root.Visible = not Root.Visible
    end
end)

print("✦ KVN Menu v2 loaded — RightShift to toggle ✦")
