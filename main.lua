-- [[ المكتبات والخدمات الأساسية ]] --
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")

-- [[ إعدادات التخطي المتقدمة ]] --
local STEP_DISTANCE = 18 -- زيادة المسافة لتجاوز سماكة الأبواب والجدران المغلقة
local TWEEN_TIME = 0.05  -- سرعة خاطفة جداً لخدع حماية الأنتي شيت والسيرفر

-- [[ إنشاء الواجهة الرسومية UI ]] --
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local ForwardBtn = Instance.new("TextButton")
local BackwardBtn = Instance.new("TextButton")
local BypassObjectsBtn = Instance.new("TextButton")

ScreenGui.Name = "AdvancedBypassMenu"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- اللوحة الرئيسية
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.35, 0, 0.35, 0)
MainFrame.Size = UDim2.new(0, 220, 0, 200)
MainFrame.Active = true
MainFrame.Draggable = true -- سحب القائمة في أي مكان بالماوس

-- العنوان
Title.Name = "Title"
Title.Parent = MainFrame
Title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Title.BorderSizePixel = 0
Title.Size = UDim2.new(1, 0, 0, 35)
Title.Font = Enum.Font.SourceSansBold
Title.Text = "Advanced Bypass V2"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16

-- زر قدام
ForwardBtn.Name = "ForwardBtn"
ForwardBtn.Parent = MainFrame
ForwardBtn.BackgroundColor3 = Color3.fromRGB(46, 139, 87)
ForwardBtn.Position = UDim2.new(0.05, 0, 0.25, 0)
ForwardBtn.Size = UDim2.new(0.9, 0, 0, 35)
ForwardBtn.Font = Enum.Font.SourceSansBold
ForwardBtn.Text = "قدام (اختراق خاطف)"
ForwardBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ForwardBtn.TextSize = 15

-- زر ورا
BackwardBtn.Name = "BackwardBtn"
BackwardBtn.Parent = MainFrame
BackwardBtn.BackgroundColor3 = Color3.fromRGB(178, 34, 34)
BackwardBtn.Position = UDim2.new(0.05, 0, 0.48, 0)
BackwardBtn.Size = UDim2.new(0.9, 0, 0, 35)
BackwardBtn.Font = Enum.Font.SourceSansBold
BackwardBtn.Text = "ورا (اختراق خاطف)"
BackwardBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
BackwardBtn.TextSize = 15

-- زر تخطي قيود الأغراض والأبواب
BypassObjectsBtn.Name = "BypassObjectsBtn"
BypassObjectsBtn.Parent = MainFrame
BypassObjectsBtn.BackgroundColor3 = Color3.fromRGB(30, 144, 255)
BypassObjectsBtn.Position = UDim2.new(0.05, 0, 0.72, 0)
BypassObjectsBtn.Size = UDim2.new(0.9, 0, 0, 40)
BypassObjectsBtn.Font = Enum.Font.SourceSansBold
BypassObjectsBtn.Text = "تخطي حماية الأغراض والأزرار"
BypassObjectsBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
BypassObjectsBtn.TextSize = 13

-- [[ الوظائف البرمجية ]] --

-- دالة التلبرت الخاطف والسلس (ينقلك قبل استيعاب الأنتي شيت للـ NoClip)
local function phaseThroughWall(direction)
    local character = LocalPlayer.Character
    local hrp = character and character:FindFirstChild("HumanoidRootPart")
    
    if hrp then
        local targetCFrame
        if direction == "forward" then
            targetCFrame = hrp.CFrame * CFrame.new(0, 0, -STEP_DISTANCE)
        elseif direction == "backward" then
            targetCFrame = hrp.CFrame * CFrame.new(0, 0, STEP_DISTANCE)
        end
        
        -- التعديل هنا: سرعة قصيرة جداً ومستقيمة (Linear) لمنع الارتداد الخلفي (Rubberbanding)
        local tweenInfo = TweenInfo.new(TWEEN_TIME, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
        local tween = TweenService:Create(hrp, tweenInfo, {CFrame = targetCFrame})
        
        tween:Play()
    end
end

-- دالة تعديل الأغراض والأزرار في الماب لتخطي الحماية المحلية
local function bypassMapObjects()
    -- 1. إزالة اللوحات الإعلانية المزعجة من الشاشة
    local pGui = LocalPlayer:FindFirstChild("PlayerGui")
    if pGui then
        for _, gui in ipairs(pGui:GetDescendants()) do
            if gui:IsA("Frame") or gui:IsA("ImageLabel") or gui:IsA("TextLabel") then
                local name = gui.Name:lower()
                if name:find("shop") or name:find("buy") or name:find("pass") or name:find("purchase") or name:find("premium") then
                    gui.Visible = false
                end
            end
        end
    end

    -- 2. فتح وتعديل جميع أزرار التفاعل (ProximityPrompts) حتى لو كانت مقفلة خلف جيم باس
    for _, prompt in ipairs(Workspace:GetDescendants()) do
        if prompt:IsA("ProximityPrompt") then
            prompt.RequiresLineOfSight = false -- التفاعل حتى لو كان خلف جدار
            prompt.MaxActivationDistance = 35  -- زيادة مدى التفاعل لمسافة بعيدة
            prompt.HoldDuration = 0            -- جعل التفعيل فورياً بدون انتظار
        end
    end
    
    -- 3. محاولة محاكاة امتلاك الأدوات الأساسية إذا كانت مخزنة في الـ ReplicatedStorage
    local repStorage = game:GetService("ReplicatedStorage")
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    if backpack then
        for _, obj in ipairs(repStorage:GetDescendants()) do
            if obj:IsA("Tool") and not backpack:FindFirstChild(obj.Name) then
                -- نسخ الأداة إلى حقيبتك محلياً لتجربة تشغيلها
                pcall(function()
                    local clone = obj:Clone()
                    clone.Parent = backpack
                end)
            end
        end
    end
end

-- [[ ربط الأزرار بالوظائف ]] --
ForwardBtn.MouseButton1Click:Connect(function()
    phaseThroughWall("forward")
end)

BackwardBtn.MouseButton1Click:Connect(function()
    phaseThroughWall("backward")
end)

BypassObjectsBtn.MouseButton1Click:Connect(function()
    bypassMapObjects()
    BypassObjectsBtn.Text = "تم التعديل وجلب الأدوات!"
    BypassObjectsBtn.BackgroundColor3 = Color3.fromRGB(40, 160, 40)
    
    -- إعادة المحاولة بعد 3 ثواني تلقائياً للأغراض الجديدة التي ترسبن
    task.wait(3)
    BypassObjectsBtn.Text = "تخطي حماية الأغراض والأزرار"
    BypassObjectsBtn.BackgroundColor3 = Color3.fromRGB(30, 144, 255)
end)
