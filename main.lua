-- ╔══════════════════════════════════════════════════════════╗
-- ║              K V N  —  Premium UI Menu                  ║
-- ║                   Designed by KVN                       ║
-- ╚══════════════════════════════════════════════════════════╝

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- ══════════════════════════════════════
--  THEME CONFIGURATION
-- ══════════════════════════════════════
local Theme = {
    Background      = Color3.fromRGB(8, 8, 14),
    Surface         = Color3.fromRGB(13, 13, 22),
    SurfaceAlt      = Color3.fromRGB(18, 18, 30),
    Border          = Color3.fromRGB(40, 40, 65),
    BorderGlow      = Color3.fromRGB(80, 80, 140),
    Accent          = Color3.fromRGB(100, 80, 255),
    AccentBright    = Color3.fromRGB(140, 110, 255),
    AccentGlow      = Color3.fromRGB(80, 60, 200),
    Cyan            = Color3.fromRGB(0, 210, 255),
    CyanDim         = Color3.fromRGB(0, 140, 180),
    TextPrimary     = Color3.fromRGB(235, 235, 255),
    TextSecondary   = Color3.fromRGB(140, 140, 175),
    TextDim         = Color3.fromRGB(75, 75, 105),
    ButtonBase      = Color3.fromRGB(22, 22, 38),
    ButtonHover     = Color3.fromRGB(32, 28, 58),
    ButtonActive    = Color3.fromRGB(45, 38, 80),
    Success         = Color3.fromRGB(50, 220, 140),
    Warning         = Color3.fromRGB(255, 180, 50),
    Danger          = Color3.fromRGB(255, 70, 90),
    White           = Color3.fromRGB(255, 255, 255),
    Black           = Color3.fromRGB(0, 0, 0),
}

-- ══════════════════════════════════════
--  TWEEN HELPERS
-- ══════════════════════════════════════
local function Tween(obj, props, duration, style, direction)
    local info = TweenInfo.new(
        duration or 0.3,
        style or Enum.EasingStyle.Quint,
        direction or Enum.EasingDirection.Out
    )
    local t = TweenService:Create(obj, info, props)
    t:Play()
    return t
end

local function SpringTween(obj, props, duration)
    return Tween(obj, props, duration or 0.4, Enum.EasingStyle.Spring, Enum.EasingDirection.Out)
end

-- ══════════════════════════════════════
--  INSTANCE BUILDER
-- ══════════════════════════════════════
local function New(class, props, children)
    local inst = Instance.new(class)
    for k, v in pairs(props or {}) do
        inst[k] = v
    end
    for _, child in pairs(children or {}) do
        child.Parent = inst
    end
    return inst
end

local function Corner(radius)
    return New("UICorner", { CornerRadius = UDim.new(0, radius or 8) })
end

local function Padding(t, b, l, r)
    return New("UIPadding", {
        PaddingTop    = UDim.new(0, t or 0),
        PaddingBottom = UDim.new(0, b or 0),
        PaddingLeft   = UDim.new(0, l or 0),
        PaddingRight  = UDim.new(0, r or 0),
    })
end

local function Stroke(color, thickness, transparency)
    return New("UIStroke", {
        Color        = color or Theme.Border,
        Thickness    = thickness or 1,
        Transparency = transparency or 0,
    })
end

-- ══════════════════════════════════════
--  SCREEN GUI SETUP
-- ══════════════════════════════════════
local ScreenGui = New("ScreenGui", {
    Name            = "KVN_Menu",
    ResetOnSpawn    = false,
    ZIndexBehavior  = Enum.ZIndexBehavior.Sibling,
    DisplayOrder    = 999,
    Parent          = LocalPlayer:WaitForChild("PlayerGui"),
})

-- ══════════════════════════════════════
--  MAIN FRAME
-- ══════════════════════════════════════
local MainFrame = New("Frame", {
    Name            = "MainFrame",
    Size            = UDim2.new(0, 560, 0, 390),
    Position        = UDim2.new(0.5, -280, 0.5, -195),
    BackgroundColor3 = Theme.Background,
    BorderSizePixel = 0,
    ClipsDescendants = true,
    Parent          = ScreenGui,
}, { Corner(14) })

-- Outer glow border
local OuterBorder = New("Frame", {
    Name            = "OuterBorder",
    Size            = UDim2.new(1, 2, 1, 2),
    Position        = UDim2.new(0, -1, 0, -1),
    BackgroundTransparency = 1,
    ZIndex          = 0,
    Parent          = MainFrame,
}, {
    Corner(15),
    Stroke(Theme.Accent, 1.5, 0.3),
})

-- Ambient glow behind the window
local GlowFrame = New("Frame", {
    Size            = UDim2.new(1, 60, 1, 60),
    Position        = UDim2.new(0, -30, 0, -30),
    BackgroundColor3 = Theme.Accent,
    BackgroundTransparency = 0.85,
    ZIndex          = -1,
    Parent          = MainFrame,
}, { Corner(30) })

-- ══════════════════════════════════════
--  ANIMATED BACKGROUND GRADIENT
-- ══════════════════════════════════════
local BgGradient = New("UIGradient", {
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0,   Color3.fromRGB(10, 8, 20)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(8, 12, 25)),
        ColorSequenceKeypoint.new(1,   Color3.fromRGB(12, 8, 22)),
    }),
    Rotation = 135,
    Parent = MainFrame,
})

-- ══════════════════════════════════════
--  DECORATIVE TOP ACCENT LINE
-- ══════════════════════════════════════
local TopLine = New("Frame", {
    Size            = UDim2.new(0, 0, 0, 2),
    Position        = UDim2.new(0, 0, 0, 0),
    BackgroundColor3 = Theme.Accent,
    BorderSizePixel = 0,
    ZIndex          = 10,
    Parent          = MainFrame,
}, { Corner(1) })

New("UIGradient", {
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0,   Theme.Cyan),
        ColorSequenceKeypoint.new(0.5, Theme.AccentBright),
        ColorSequenceKeypoint.new(1,   Theme.Accent),
    }),
    Parent = TopLine,
})

-- ══════════════════════════════════════
--  HEADER BAR
-- ══════════════════════════════════════
local Header = New("Frame", {
    Name            = "Header",
    Size            = UDim2.new(1, 0, 0, 50),
    Position        = UDim2.new(0, 0, 0, 0),
    BackgroundColor3 = Theme.Surface,
    BorderSizePixel = 0,
    ZIndex          = 5,
    Parent          = MainFrame,
})

New("UIGradient", {
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(16, 14, 28)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(12, 10, 22)),
    }),
    Rotation = 90,
    Parent = Header,
})

-- Logo/Brand area
local BrandContainer = New("Frame", {
    Size            = UDim2.new(0, 200, 1, 0),
    Position        = UDim2.new(0, 16, 0, 0),
    BackgroundTransparency = 1,
    ZIndex          = 6,
    Parent          = Header,
})

-- Accent dot
local AccentDot = New("Frame", {
    Size            = UDim2.new(0, 8, 0, 8),
    Position        = UDim2.new(0, 0, 0.5, -4),
    BackgroundColor3 = Theme.Cyan,
    BorderSizePixel = 0,
    ZIndex          = 7,
    Parent          = BrandContainer,
}, { Corner(4) })

New("UIGradient", {
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Theme.AccentBright),
        ColorSequenceKeypoint.new(1, Theme.Cyan),
    }),
    Parent = AccentDot,
})

local TitleLabel = New("TextLabel", {
    Size            = UDim2.new(0, 180, 1, 0),
    Position        = UDim2.new(0, 18, 0, 0),
    BackgroundTransparency = 1,
    Text            = "KVN  MENU",
    Font            = Enum.Font.GothamBold,
    TextSize        = 15,
    TextColor3      = Theme.TextPrimary,
    TextXAlignment  = Enum.TextXAlignment.Left,
    ZIndex          = 7,
    Parent          = BrandContainer,
})

New("UIGradient", {
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Theme.White),
        ColorSequenceKeypoint.new(1, Theme.AccentBright),
    }),
    Parent = TitleLabel,
})

-- Version badge
local VersionBadge = New("Frame", {
    Size            = UDim2.new(0, 36, 0, 16),
    Position        = UDim2.new(0, 18 + 90, 0.5, -8),
    BackgroundColor3 = Theme.AccentGlow,
    ZIndex          = 7,
    Parent          = BrandContainer,
}, { Corner(4) })

New("TextLabel", {
    Size            = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    Text            = "v1.0",
    Font            = Enum.Font.GothamBold,
    TextSize        = 9,
    TextColor3      = Theme.AccentBright,
    ZIndex          = 8,
    Parent          = VersionBadge,
})

-- Close / Minimize buttons
local function MakeControlBtn(pos, color, symbol)
    local btn = New("TextButton", {
        Size            = UDim2.new(0, 26, 0, 26),
        Position        = pos,
        BackgroundColor3 = Theme.SurfaceAlt,
        Text            = symbol,
        Font            = Enum.Font.GothamBold,
        TextSize        = 11,
        TextColor3      = color,
        ZIndex          = 8,
        Parent          = Header,
    }, {
        Corner(8),
        Stroke(Theme.Border, 1, 0.4),
    })
    btn.MouseEnter:Connect(function()
        Tween(btn, { BackgroundColor3 = color, TextColor3 = Theme.Black }, 0.15)
    end)
    btn.MouseLeave:Connect(function()
        Tween(btn, { BackgroundColor3 = Theme.SurfaceAlt, TextColor3 = color }, 0.2)
    end)
    return btn
end

local CloseBtn = MakeControlBtn(UDim2.new(1, -42, 0.5, -13), Theme.Danger, "✕")
local MinBtn   = MakeControlBtn(UDim2.new(1, -74, 0.5, -13), Theme.Warning, "—")

-- Bottom border of header
New("Frame", {
    Size            = UDim2.new(1, 0, 0, 1),
    Position        = UDim2.new(0, 0, 1, -1),
    BackgroundColor3 = Theme.Border,
    BorderSizePixel = 0,
    ZIndex          = 6,
    Parent          = Header,
})

-- ══════════════════════════════════════
--  TAB BAR
-- ══════════════════════════════════════
local TabBar = New("Frame", {
    Name            = "TabBar",
    Size            = UDim2.new(1, 0, 0, 44),
    Position        = UDim2.new(0, 0, 0, 50),
    BackgroundColor3 = Theme.Surface,
    BorderSizePixel = 0,
    ZIndex          = 5,
    Parent          = MainFrame,
})

local TabLayout = New("UIListLayout", {
    FillDirection   = Enum.FillDirection.Horizontal,
    SortOrder       = Enum.SortOrder.LayoutOrder,
    Padding         = UDim.new(0, 0),
    Parent          = TabBar,
})

-- Sliding tab indicator
local TabIndicator = New("Frame", {
    Size            = UDim2.new(0, 0, 0, 2),
    Position        = UDim2.new(0, 0, 1, -2),
    BackgroundColor3 = Theme.Accent,
    BorderSizePixel = 0,
    ZIndex          = 8,
    Parent          = TabBar,
}, { Corner(1) })

New("UIGradient", {
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Theme.Cyan),
        ColorSequenceKeypoint.new(1, Theme.AccentBright),
    }),
    Parent = TabIndicator,
})

-- Bottom border of tab bar
New("Frame", {
    Size            = UDim2.new(1, 0, 0, 1),
    Position        = UDim2.new(0, 0, 1, -1),
    BackgroundColor3 = Theme.Border,
    BorderSizePixel = 0,
    ZIndex          = 6,
    Parent          = TabBar,
})

-- ══════════════════════════════════════
--  CONTENT AREA
-- ══════════════════════════════════════
local ContentHolder = New("Frame", {
    Name            = "ContentHolder",
    Size            = UDim2.new(1, 0, 1, -96),
    Position        = UDim2.new(0, 0, 0, 94),
    BackgroundTransparency = 1,
    ClipsDescendants = true,
    ZIndex          = 4,
    Parent          = MainFrame,
})

-- ══════════════════════════════════════
--  SECTION CREATION
-- ══════════════════════════════════════
local function MakeSection(title)
    local frame = New("Frame", {
        Size            = UDim2.new(1, -28, 0, 0),  -- height set by layout
        BackgroundColor3 = Theme.SurfaceAlt,
        BorderSizePixel = 0,
        AutomaticSize   = Enum.AutomaticSize.Y,
        ZIndex          = 5,
    }, {
        Corner(10),
        Stroke(Theme.Border, 1, 0.5),
        Padding(10, 10, 12, 12),
    })

    New("TextLabel", {
        Size            = UDim2.new(1, 0, 0, 18),
        BackgroundTransparency = 1,
        Text            = title:upper(),
        Font            = Enum.Font.GothamBold,
        TextSize        = 9,
        TextColor3      = Theme.TextDim,
        TextXAlignment  = Enum.TextXAlignment.Left,
        LetterSpacing   = 3,
        ZIndex          = 6,
        Parent          = frame,
    })

    New("Frame", {
        Size            = UDim2.new(1, 0, 0, 1),
        Position        = UDim2.new(0, 0, 0, 24),
        BackgroundColor3 = Theme.Border,
        BorderSizePixel = 0,
        ZIndex          = 6,
        Parent          = frame,
    })

    local content = New("Frame", {
        Size            = UDim2.new(1, 0, 0, 0),
        Position        = UDim2.new(0, 0, 0, 32),
        BackgroundTransparency = 1,
        AutomaticSize   = Enum.AutomaticSize.Y,
        ZIndex          = 6,
        Parent          = frame,
    })

    New("UIListLayout", {
        FillDirection = Enum.FillDirection.Vertical,
        SortOrder     = Enum.SortOrder.LayoutOrder,
        Padding       = UDim.new(0, 6),
        Parent        = content,
    })

    return frame, content
end

-- ══════════════════════════════════════
--  BUTTON FACTORY
-- ══════════════════════════════════════
local function MakeButton(parent, text, subtitle, accent)
    accent = accent or Theme.Accent
    local order = #parent:GetChildren()

    local btn = New("TextButton", {
        Size            = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = Theme.ButtonBase,
        Text            = "",
        AutoButtonColor = false,
        ZIndex          = 7,
        LayoutOrder     = order,
        Parent          = parent,
    }, {
        Corner(8),
        Stroke(Theme.Border, 1, 0.6),
    })

    -- Left accent bar
    local AccentBar = New("Frame", {
        Size            = UDim2.new(0, 3, 0, 22),
        Position        = UDim2.new(0, 10, 0.5, -11),
        BackgroundColor3 = accent,
        BorderSizePixel = 0,
        ZIndex          = 8,
        Parent          = btn,
    }, { Corner(2) })

    -- Button label
    New("TextLabel", {
        Size            = UDim2.new(1, -60, 0, 20),
        Position        = UDim2.new(0, 22, 0, 7),
        BackgroundTransparency = 1,
        Text            = text,
        Font            = Enum.Font.GothamSemibold,
        TextSize        = 13,
        TextColor3      = Theme.TextPrimary,
        TextXAlignment  = Enum.TextXAlignment.Left,
        ZIndex          = 8,
        Parent          = btn,
    })

    if subtitle then
        New("TextLabel", {
            Size            = UDim2.new(1, -60, 0, 13),
            Position        = UDim2.new(0, 22, 0, 24),
            BackgroundTransparency = 1,
            Text            = subtitle,
            Font            = Enum.Font.Gotham,
            TextSize        = 10,
            TextColor3      = Theme.TextSecondary,
            TextXAlignment  = Enum.TextXAlignment.Left,
            ZIndex          = 8,
            Parent          = btn,
        })
    end

    -- Arrow icon
    New("TextLabel", {
        Size            = UDim2.new(0, 20, 1, 0),
        Position        = UDim2.new(1, -28, 0, 0),
        BackgroundTransparency = 1,
        Text            = "›",
        Font            = Enum.Font.GothamBold,
        TextSize        = 18,
        TextColor3      = Theme.TextDim,
        ZIndex          = 8,
        Parent          = btn,
    })

    -- Hover/click effects
    btn.MouseEnter:Connect(function()
        Tween(btn, { BackgroundColor3 = Theme.ButtonHover }, 0.18)
        Tween(AccentBar, { BackgroundColor3 = Theme.AccentBright, Size = UDim2.new(0, 3, 0, 28) }, 0.2)
        Tween(btn:FindFirstChildOfClass("UIStroke"), { Color = accent, Transparency = 0.3 }, 0.18)
    end)

    btn.MouseLeave:Connect(function()
        Tween(btn, { BackgroundColor3 = Theme.ButtonBase }, 0.2)
        Tween(AccentBar, { BackgroundColor3 = accent, Size = UDim2.new(0, 3, 0, 22) }, 0.25)
        Tween(btn:FindFirstChildOfClass("UIStroke"), { Color = Theme.Border, Transparency = 0.6 }, 0.2)
    end)

    btn.MouseButton1Down:Connect(function()
        Tween(btn, { BackgroundColor3 = Theme.ButtonActive }, 0.08)
        SpringTween(btn, { Size = UDim2.new(1, -4, 0, 38) }, 0.15)
    end)

    btn.MouseButton1Up:Connect(function()
        Tween(btn, { BackgroundColor3 = Theme.ButtonHover }, 0.12)
        SpringTween(btn, { Size = UDim2.new(1, 0, 0, 40) }, 0.3)
    end)

    return btn
end

-- ══════════════════════════════════════
--  TOGGLE FACTORY
-- ══════════════════════════════════════
local function MakeToggle(parent, text, default)
    default = default or false
    local order = #parent:GetChildren()
    local state = default

    local row = New("Frame", {
        Size            = UDim2.new(1, 0, 0, 36),
        BackgroundColor3 = Theme.ButtonBase,
        BorderSizePixel = 0,
        ZIndex          = 7,
        LayoutOrder     = order,
        Parent          = parent,
    }, {
        Corner(8),
        Stroke(Theme.Border, 1, 0.6),
    })

    New("TextLabel", {
        Size            = UDim2.new(1, -60, 1, 0),
        Position        = UDim2.new(0, 14, 0, 0),
        BackgroundTransparency = 1,
        Text            = text,
        Font            = Enum.Font.GothamSemibold,
        TextSize        = 13,
        TextColor3      = Theme.TextPrimary,
        TextXAlignment  = Enum.TextXAlignment.Left,
        ZIndex          = 8,
        Parent          = row,
    })

    local track = New("Frame", {
        Size            = UDim2.new(0, 42, 0, 22),
        Position        = UDim2.new(1, -54, 0.5, -11),
        BackgroundColor3 = state and Theme.Accent or Theme.Border,
        BorderSizePixel = 0,
        ZIndex          = 8,
        Parent          = row,
    }, { Corner(11) })

    local thumb = New("Frame", {
        Size            = UDim2.new(0, 16, 0, 16),
        Position        = state and UDim2.new(0, 23, 0.5, -8) or UDim2.new(0, 3, 0.5, -8),
        BackgroundColor3 = Theme.White,
        BorderSizePixel = 0,
        ZIndex          = 9,
        Parent          = track,
    }, { Corner(8) })

    local clickArea = New("TextButton", {
        Size            = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text            = "",
        ZIndex          = 10,
        Parent          = row,
    })

    clickArea.MouseButton1Click:Connect(function()
        state = not state
        if state then
            Tween(track, { BackgroundColor3 = Theme.Accent }, 0.2)
            Tween(thumb, { Position = UDim2.new(0, 23, 0.5, -8) }, 0.25, Enum.EasingStyle.Back)
        else
            Tween(track, { BackgroundColor3 = Theme.Border }, 0.2)
            Tween(thumb, { Position = UDim2.new(0, 3, 0.5, -8) }, 0.25, Enum.EasingStyle.Back)
        end
    end)

    row.MouseEnter:Connect(function()
        Tween(row, { BackgroundColor3 = Theme.ButtonHover }, 0.15)
    end)
    row.MouseLeave:Connect(function()
        Tween(row, { BackgroundColor3 = Theme.ButtonBase }, 0.2)
    end)

    return row
end

-- ══════════════════════════════════════
--  SLIDER FACTORY
-- ══════════════════════════════════════
local function MakeSlider(parent, text, min, max, default)
    min = min or 0; max = max or 100; default = default or 50
    local order = #parent:GetChildren()
    local value = default
    local dragging = false

    local container = New("Frame", {
        Size            = UDim2.new(1, 0, 0, 48),
        BackgroundColor3 = Theme.ButtonBase,
        BorderSizePixel = 0,
        ZIndex          = 7,
        LayoutOrder     = order,
        Parent          = parent,
    }, {
        Corner(8),
        Stroke(Theme.Border, 1, 0.6),
        Padding(6, 6, 14, 14),
    })

    local topRow = New("Frame", {
        Size            = UDim2.new(1, 0, 0, 16),
        BackgroundTransparency = 1,
        ZIndex          = 8,
        Parent          = container,
    })

    New("TextLabel", {
        Size            = UDim2.new(0.7, 0, 1, 0),
        BackgroundTransparency = 1,
        Text            = text,
        Font            = Enum.Font.GothamSemibold,
        TextSize        = 13,
        TextColor3      = Theme.TextPrimary,
        TextXAlignment  = Enum.TextXAlignment.Left,
        ZIndex          = 8,
        Parent          = topRow,
    })

    local valueLabel = New("TextLabel", {
        Size            = UDim2.new(0.3, 0, 1, 0),
        Position        = UDim2.new(0.7, 0, 0, 0),
        BackgroundTransparency = 1,
        Text            = tostring(default),
        Font            = Enum.Font.GothamBold,
        TextSize        = 12,
        TextColor3      = Theme.AccentBright,
        TextXAlignment  = Enum.TextXAlignment.Right,
        ZIndex          = 8,
        Parent          = topRow,
    })

    local trackBg = New("Frame", {
        Size            = UDim2.new(1, 0, 0, 4),
        Position        = UDim2.new(0, 0, 1, -4),
        BackgroundColor3 = Theme.Border,
        BorderSizePixel = 0,
        ZIndex          = 8,
        Parent          = container,
    }, { Corner(2) })

    local pct = (value - min) / (max - min)

    local trackFill = New("Frame", {
        Size            = UDim2.new(pct, 0, 1, 0),
        BackgroundColor3 = Theme.Accent,
        BorderSizePixel = 0,
        ZIndex          = 9,
        Parent          = trackBg,
    }, { Corner(2) })

    New("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Theme.Cyan),
            ColorSequenceKeypoint.new(1, Theme.AccentBright),
        }),
        Parent = trackFill,
    })

    local knob = New("Frame", {
        Size            = UDim2.new(0, 14, 0, 14),
        Position        = UDim2.new(pct, -7, 0.5, -7),
        BackgroundColor3 = Theme.White,
        BorderSizePixel = 0,
        ZIndex          = 10,
        Parent          = trackBg,
    }, {
        Corner(7),
        Stroke(Theme.AccentBright, 2, 0),
    })

    local dragArea = New("TextButton", {
        Size            = UDim2.new(1, 0, 0, 28),
        Position        = UDim2.new(0, 0, 0.5, -14),
        BackgroundTransparency = 1,
        Text            = "",
        ZIndex          = 11,
        Parent          = trackBg,
    })

    local function updateSlider(input)
        local rel = (input.Position.X - trackBg.AbsolutePosition.X) / trackBg.AbsoluteSize.X
        rel = math.clamp(rel, 0, 1)
        value = math.floor(min + (max - min) * rel)
        valueLabel.Text = tostring(value)
        Tween(trackFill, { Size = UDim2.new(rel, 0, 1, 0) }, 0.05)
        Tween(knob, { Position = UDim2.new(rel, -7, 0.5, -7) }, 0.05)
    end

    dragArea.MouseButton1Down:Connect(function(x, y)
        dragging = true
        updateSlider({ Position = Vector2.new(x, y) })
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            updateSlider(input)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    container.MouseEnter:Connect(function()
        Tween(container, { BackgroundColor3 = Theme.ButtonHover }, 0.15)
    end)
    container.MouseLeave:Connect(function()
        Tween(container, { BackgroundColor3 = Theme.ButtonBase }, 0.2)
    end)

    return container
end

-- ══════════════════════════════════════
--  TAB PAGE CREATION
-- ══════════════════════════════════════
local Pages = {}

local function MakePage(name)
    local page = New("ScrollingFrame", {
        Name                    = name,
        Size                    = UDim2.new(1, 0, 1, 0),
        Position                = UDim2.new(1, 0, 0, 0),   -- starts off screen
        BackgroundTransparency  = 1,
        BorderSizePixel         = 0,
        ScrollBarThickness      = 3,
        ScrollBarImageColor3    = Theme.Accent,
        CanvasSize              = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize     = Enum.AutomaticSize.Y,
        ZIndex                  = 4,
        Parent                  = ContentHolder,
    })

    New("UIListLayout", {
        FillDirection = Enum.FillDirection.Vertical,
        SortOrder     = Enum.SortOrder.LayoutOrder,
        Padding       = UDim.new(0, 10),
        Parent        = page,
    })

    Padding(10, 10, 14, 14).Parent = page
    Pages[name] = page
    return page
end

-- ══════════════════════════════════════
--  PAGE CONTENT — MAIN
-- ══════════════════════════════════════
local PageMain = MakePage("MAIN")

local sec1, con1 = MakeSection("Quick Actions")
sec1.Parent = PageMain
MakeButton(con1, "Feature One",   "Execute the primary function",    Theme.Accent)
MakeButton(con1, "Feature Two",   "Secondary operation handler",     Theme.Cyan)
MakeButton(con1, "Feature Three", "Additional utility function",     Theme.Success)

local sec2, con2 = MakeSection("Settings")
sec2.Parent = PageMain
MakeToggle(con2, "Enable Module A",  true)
MakeToggle(con2, "Enable Module B",  false)
MakeSlider(con2, "Speed Value",      0, 100, 65)

-- ══════════════════════════════════════
--  PAGE CONTENT — MAIN 2
-- ══════════════════════════════════════
local PageMain2 = MakePage("MAIN 2")

local sec3, con3 = MakeSection("Operations")
sec3.Parent = PageMain2
MakeButton(con3, "Action Alpha",   "Run alpha sequence",    Theme.Warning)
MakeButton(con3, "Action Beta",    "Run beta sequence",     Theme.Accent)
MakeButton(con3, "Action Gamma",   "Run gamma sequence",    Theme.Cyan)
MakeButton(con3, "Action Delta",   "Run delta sequence",    Theme.Success)

local sec4, con4 = MakeSection("Parameters")
sec4.Parent = PageMain2
MakeSlider(con4, "Intensity",  0, 200, 100)
MakeSlider(con4, "Range",      0, 500, 250)
MakeToggle(con4, "Auto Mode",  true)

-- ══════════════════════════════════════
--  PAGE CONTENT — MAIN 3
-- ══════════════════════════════════════
local PageMain3 = MakePage("MAIN 3")

local sec5, con5 = MakeSection("Configuration")
sec5.Parent = PageMain3
MakeToggle(con5, "System Mode X",   false)
MakeToggle(con5, "System Mode Y",   true)
MakeToggle(con5, "System Mode Z",   false)
MakeSlider(con5, "Threshold",       0, 100, 30)

local sec6, con6 = MakeSection("Utilities")
sec6.Parent = PageMain3
MakeButton(con6, "Utility One",    "Auxiliary tool A",  Theme.Danger)
MakeButton(con6, "Utility Two",    "Auxiliary tool B",  Theme.Accent)

-- ══════════════════════════════════════
--  TAB BUTTONS
-- ══════════════════════════════════════
local TabDefs = {
    { label = "MAIN",   page = PageMain   },
    { label = "MAIN 2", page = PageMain2  },
    { label = "MAIN 3", page = PageMain3  },
}

local TabButtons = {}
local ActiveTab = nil

local function SetActiveTab(index)
    if ActiveTab == index then return end
    local prev = ActiveTab
    ActiveTab = index

    -- Slide the indicator
    local btn = TabButtons[index]
    local xPos = (index - 1) / #TabDefs
    local xSize = 1 / #TabDefs
    Tween(TabIndicator, {
        Position = UDim2.new(xPos, 4, 1, -2),
        Size     = UDim2.new(xSize, -8, 0, 2),
    }, 0.35, Enum.EasingStyle.Quint)

    -- Animate pages
    for i, def in ipairs(TabDefs) do
        local page = def.page
        if i == index then
            page.Position = UDim2.new(prev and (index > prev and 1 or -1) or 0, 0, 0, 0)
            page.GroupTransparency = 1
            Tween(page, { Position = UDim2.new(0, 0, 0, 0), GroupTransparency = 0 }, 0.3, Enum.EasingStyle.Quint)
        elseif prev and i == prev then
            Tween(page, {
                Position = UDim2.new(index > prev and -1 or 1, 0, 0, 0),
                GroupTransparency = 1
            }, 0.3, Enum.EasingStyle.Quint)
        else
            page.Position = UDim2.new(i < index and -1 or 1, 0, 0, 0)
            page.GroupTransparency = 1
        end

        local tb = TabButtons[i]
        if i == index then
            Tween(tb, { TextColor3 = Theme.TextPrimary }, 0.2)
        else
            Tween(tb, { TextColor3 = Theme.TextDim }, 0.2)
        end
    end
end

for i, def in ipairs(TabDefs) do
    local tabW = 1 / #TabDefs

    local tb = New("TextButton", {
        Size            = UDim2.new(tabW, 0, 1, 0),
        BackgroundTransparency = 1,
        Text            = def.label,
        Font            = Enum.Font.GothamBold,
        TextSize        = 11,
        TextColor3      = Theme.TextDim,
        ZIndex          = 7,
        LayoutOrder     = i,
        Parent          = TabBar,
    })

    tb.MouseEnter:Connect(function()
        if ActiveTab ~= i then
            Tween(tb, { TextColor3 = Theme.TextSecondary }, 0.15)
        end
    end)

    tb.MouseLeave:Connect(function()
        if ActiveTab ~= i then
            Tween(tb, { TextColor3 = Theme.TextDim }, 0.2)
        end
    end)

    tb.MouseButton1Click:Connect(function()
        SetActiveTab(i)
    end)

    TabButtons[i] = tb
end

-- ══════════════════════════════════════
--  FOOTER / WATERMARK
-- ══════════════════════════════════════
local Footer = New("Frame", {
    Name            = "Footer",
    Size            = UDim2.new(1, 0, 0, 28),
    Position        = UDim2.new(0, 0, 1, -28),
    BackgroundColor3 = Theme.Surface,
    BorderSizePixel = 0,
    ZIndex          = 6,
    Parent          = MainFrame,
})

New("UIGradient", {
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(12, 10, 22)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 8, 18)),
    }),
    Rotation = 90,
    Parent = Footer,
})

New("Frame", {
    Size            = UDim2.new(1, 0, 0, 1),
    Position        = UDim2.new(0, 0, 0, 0),
    BackgroundColor3 = Theme.Border,
    BorderSizePixel = 0,
    ZIndex          = 7,
    Parent          = Footer,
})

local WatermarkLabel = New("TextLabel", {
    Size            = UDim2.new(1, -20, 1, 0),
    Position        = UDim2.new(0, 10, 0, 0),
    BackgroundTransparency = 1,
    Text            = "✦  K V N  —  UI Menu  ✦",
    Font            = Enum.Font.GothamBold,
    TextSize        = 10,
    TextColor3      = Theme.TextDim,
    TextXAlignment  = Enum.TextXAlignment.Center,
    ZIndex          = 7,
    Parent          = Footer,
})

New("UIGradient", {
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0,    Theme.TextDim),
        ColorSequenceKeypoint.new(0.45, Theme.AccentBright),
        ColorSequenceKeypoint.new(0.55, Theme.Cyan),
        ColorSequenceKeypoint.new(1,    Theme.TextDim),
    }),
    Parent = WatermarkLabel,
})

-- ══════════════════════════════════════
--  DRAG SUPPORT
-- ══════════════════════════════════════
do
    local dragging, dragStart, startPos = false, nil, nil

    Header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging  = true
            dragStart = input.Position
            startPos  = MainFrame.Position
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
end

-- ══════════════════════════════════════
--  CLOSE & MINIMIZE LOGIC
-- ══════════════════════════════════════
local minimised = false
local fullHeight = 390

CloseBtn.MouseButton1Click:Connect(function()
    Tween(MainFrame, { Size = UDim2.new(0, 560, 0, 0), BackgroundTransparency = 1 }, 0.3, Enum.EasingStyle.Quint)
    task.wait(0.32)
    ScreenGui:Destroy()
end)

MinBtn.MouseButton1Click:Connect(function()
    if minimised then
        minimised = false
        Tween(MainFrame, { Size = UDim2.new(0, 560, 0, fullHeight) }, 0.4, Enum.EasingStyle.Back)
    else
        minimised = true
        Tween(MainFrame, { Size = UDim2.new(0, 560, 0, 50) }, 0.35, Enum.EasingStyle.Quint)
    end
end)

-- ══════════════════════════════════════
--  AMBIENT GLOW PULSE ANIMATION
-- ══════════════════════════════════════
local glowDir = 1
RunService.Heartbeat:Connect(function(dt)
    local t = tick()
    local pulse = 0.80 + 0.05 * math.sin(t * 1.5)
    GlowFrame.BackgroundTransparency = pulse
    -- Subtle gradient rotation
    BgGradient.Rotation = 135 + 8 * math.sin(t * 0.3)
end)

-- ══════════════════════════════════════
--  OPEN ANIMATION
-- ══════════════════════════════════════
MainFrame.Size = UDim2.new(0, 560, 0, 0)
MainFrame.BackgroundTransparency = 1
task.spawn(function()
    task.wait(0.05)
    Tween(MainFrame, {
        Size = UDim2.new(0, 560, 0, fullHeight),
        BackgroundTransparency = 0,
    }, 0.5, Enum.EasingStyle.Back)
    task.wait(0.1)
    Tween(TopLine, { Size = UDim2.new(1, 0, 0, 2) }, 0.6, Enum.EasingStyle.Quint)
    task.wait(0.15)
    SetActiveTab(1)
end)

-- ══════════════════════════════════════
--  KEYBIND  (RightShift = toggle)
-- ══════════════════════════════════════
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

print("✦ KVN Menu loaded — Press RightShift to toggle ✦")
