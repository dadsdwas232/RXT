-- [[ المكتبات والخدمات الأساسية ]] --
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")

-- [[ إعدادات التحريك ]] --
local STEP_DISTANCE = 14 -- المسافة (4 خطوات تقريباً)
local TWEEN_TIME = 0.25 -- سرعة الحركة (كل ما كانت أقل كل ما كان أسرع، بس 0.25 تعتبر Smooth وآمنة)

-- [[ إنشاء الواجهة الرسومية UI ]] --
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local ForwardBtn = Instance.new("TextButton")
local BackwardBtn = Instance.new("TextButton")
local RemovePassesBtn = Instance.new("TextButton")

-- ربط الواجهة بالـ CoreGui عشان ما تختفي إذا مت
ScreenGui.Name = "SmoothBypassUI"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- اللوحة الرئيسية (القابلة للسحب)
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.4, 0, 0.4, 0)
MainFrame.Size = UDim2.new(0, 200, 0, 180)
MainFrame.Active = true
MainFrame.Draggable = true -- تفعيل ميزة السحب في أي مكان

-- العنوان
Title.Name = "Title"
Title.Parent = MainFrame
Title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Title.BorderSizePixel = 0
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Font = Enum.Font.SourceSansBold
Title.Text = "Smooth Bypass Menu"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16

-- زر التقديم (قدام)
ForwardBtn.Name = "ForwardBtn"
ForwardBtn.Parent = MainFrame
ForwardBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
ForwardBtn.Position = UDim2.new(0.05, 0, 0.25, 0)
ForwardBtn.Size = UDim2.new(0.9, 0, 0, 35)
ForwardBtn.Font = Enum.Font.SourceSansBold
ForwardBtn.Text = "قدام (Forward)"
ForwardBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ForwardBtn.TextSize = 16

-- زر الترجيع (ورا)
BackwardBtn.Name = "BackwardBtn"
BackwardBtn.Parent = MainFrame
BackwardBtn.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
BackwardBtn.Position = UDim2.new(0.05, 0, 0.50, 0)
BackwardBtn.Size = UDim2.new(0.9, 0, 0, 35)
BackwardBtn.Font = Enum.Font.SourceSansBold
BackwardBtn.Text = "ورا (Backward)"
BackwardBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
BackwardBtn.TextSize = 16

-- زر إزالة إعلانات الجيم باسات
RemovePassesBtn.Name = "RemovePassesBtn"
RemovePassesBtn.Parent = MainFrame
RemovePassesBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
RemovePassesBtn.Position = UDim2.new(0.05, 0, 0.75, 0)
RemovePassesBtn.Size = UDim2.new(0.9, 0, 0, 30)
RemovePassesBtn.Font = Enum.Font.SourceSans
RemovePassesBtn.Text = "إزالة لوحات الشراء"
RemovePassesBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
RemovePassesBtn.TextSize = 14

-- [[ الوظائف البرمجية (Functions) ]] --

-- دالة التحريك السلس (Smooth Tween)
local function teleportSmooth(direction)
    local character = LocalPlayer.Character
    local hrp = character and character:FindFirstChild("HumanoidRootPart")
    
    if hrp then
        -- حساب الاتجاه بناءً على نظرة اللاعب (LookVector)
        local targetCFrame
        if direction == "forward" then
            targetCFrame = hrp.CFrame * CFrame.new(0, 0, -STEP_DISTANCE)
        elseif direction == "backward" then
            targetCFrame = hrp.CFrame * CFrame.new(0, 0, STEP_DISTANCE)
        end
        
        -- إنشاء الـ Tween لاختراق الجدار بسلاسة
        local tweenInfo = TweenInfo.new(TWEEN_TIME, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
        local tween = TweenService:Create(hrp, tweenInfo, {CFrame = targetCFrame})
        
        tween:Play()
    end
end

-- دالة تنظيف الجيم باسات والـ Popups المزعجة
local function removeGamepasses()
    local pGui = LocalPlayer:FindFirstChild("PlayerGui")
    if pGui then
        -- البحث عن أي لوحة واجهة تحتوي على كلمات متعلقة بالشراء وإخفائها
        for _, gui in ipairs(pGui:GetDescendants()) do
            if gui:IsA("Frame") or gui:IsA("ImageLabel") then
                local name = gui.Name:lower()
                if name:find("shop") or name:find("buy") or name:find("pass") or name:find("purchase") or name:find("store") then
                    gui.Visible = false
                end
            end
        end
    end
    
    -- إخفاء اللوحات المزعجة الناتجة عن الـ Purchase Prompt الأساسي لروبلوكس (إذا أمكن محلياً)
    game:GetService("MarketplaceService").PromptGamePassPurchaseFinished:Connect(function()
        -- محاولة إغلاق أي سكوربت داخلي يحاول فتح المتجر تلقائياً
    end)
end

-- [[ ربط الأزرار بالوظائف ]] --
ForwardBtn.MouseButton1Click:Connect(function()
    teleportSmooth("forward")
end)

BackwardBtn.MouseButton1Click:Connect(function()
    teleportSmooth("backward")
end)

RemovePassesBtn.MouseButton1Click:Connect(function()
    removeGamepasses()
    RemovePassesBtn.Text = "تم إخفاء اللوحات المزعجة"
    RemovePassesBtn.BackgroundColor3 = Color3.fromRGB(40, 100, 40)
end)
