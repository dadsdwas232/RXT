-- [[ الخدمات الأساسية ]] --
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")

-- [[ إعدادات التحرك ]] --
local STEP_DISTANCE = 18 -- المسافة لتجاوز الأبواب والجدران
local TWEEN_TIME = 0.05 -- سرعة خاطفة لتجنب الأنتي شيت

-- [[ إنشاء الواجهة الرسومية UI ]] --
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local ForwardBtn = Instance.new("TextButton")
local BackwardBtn = Instance.new("TextButton")
local BlockPassesBtn = Instance.new("TextButton") -- الزر الجديد لحظر واجهات الجيم باس

-- ربط الواجهة بالـ CoreGui لمقاومة الـ Reset
ScreenGui.Name = "FinalBypassMenu"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- اللوحة الرئيسية
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.35, 0, 0.35, 0)
MainFrame.Size = UDim2.new(0, 220, 0, 200) -- مساحة كافية للزر الجديد
MainFrame.Active = true
MainFrame.Draggable = true -- سحب القائمة في أي مكان

-- العنوان
Title.Name = "Title"
Title.Parent = MainFrame
Title.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Title.BorderSizePixel = 0
Title.Size = UDim2.new(1, 0, 0, 35)
Title.Font = Enum.Font.SourceSansBold
Title.Text = "Final Bypass V3"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16

-- زر قدام (اختراق)
ForwardBtn.Name = "ForwardBtn"
ForwardBtn.Parent = MainFrame
ForwardBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
ForwardBtn.Position = UDim2.new(0.05, 0, 0.25, 0)
ForwardBtn.Size = UDim2.new(0.9, 0, 0, 35)
ForwardBtn.Font = Enum.Font.SourceSansBold
ForwardBtn.Text = "قدام (اختراق خاطف)"
ForwardBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ForwardBtn.TextSize = 15

-- زر ورا (اختراق)
BackwardBtn.Name = "BackwardBtn"
BackwardBtn.Parent = MainFrame
BackwardBtn.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
BackwardBtn.Position = UDim2.new(0.05, 0, 0.48, 0)
BackwardBtn.Size = UDim2.new(0.9, 0, 0, 35)
BackwardBtn.Font = Enum.Font.SourceSansBold
BackwardBtn.Text = "ورا (اختراق خاطف)"
BackwardBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
BackwardBtn.TextSize = 15

-- زر حظر واجهات الجيم باس نهائياً
BlockPassesBtn.Name = "BlockPassesBtn"
BlockPassesBtn.Parent = MainFrame
BlockPassesBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
BlockPassesBtn.Position = UDim2.new(0.05, 0, 0.72, 0) -- مكان مناسب في الأسفل
BlockPassesBtn.Size = UDim2.new(0.9, 0, 0, 40)
BlockPassesBtn.Font = Enum.Font.SourceSansBold
BlockPassesBtn.Text = "إزالة واجهات الشراء نهائياً"
BlockPassesBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
BlockPassesBtn.TextSize = 13

-- [[ الوظائف البرمجية ]] --

-- دالة التلبرت الخاطف والسلس
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
        
        local tweenInfo = TweenInfo.new(TWEEN_TIME, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
        local tween = TweenService:Create(hrp, tweenInfo, {CFrame = targetCFrame})
        
        tween:Play()
    end
end

-- دالة حظر وإزالة واجهات الجيم باس نهائياً
local passesBlocked = false
local function blockGamepasses()
    if passesBlocked then return end -- تفعيل مرة واحدة فقط
    passesBlocked = true
    
    local pGui = LocalPlayer:FindFirstChild("PlayerGui")
    if pGui then
        -- 1. إزالة الواجهات الموجودة حالياً
        for _, gui in ipairs(pGui:GetDescendants()) do
            if gui:IsA("Frame") or gui:IsA("ImageLabel") or gui:IsA("TextLabel") or gui:IsA("ScrollingFrame") then
                local name = gui.Name:lower()
                -- البحث عن كلمات مفتاحية متعلقة بالشراء
                if name:find("shop") or name:find("buy") or name:find("pass") or name:find("purchase") or name:find("premium") or name:find("store") then
                    pcall(function()
                        gui:Destroy() -- حذفها نهائياً
                    end)
                end
            end
        end
        
        -- 2. إيقاف ظهور واجهات جديدة (الناتجة عن الـ Popups التلقائية)
        pGui.DescendantAdded:Connect(function(descendant)
            task.wait() -- انتظار جزء من الثانية للتأكد من تحميل الاسم
            if descendant:IsA("Frame") or descendant:IsA("ImageLabel") or descendant:IsA("TextLabel") or descendant:IsA("ScrollingFrame") then
                local name = descendant.Name:lower()
                if name:find("shop") or name:find("buy") or name:find("pass") or name:find("purchase") or name:find("premium") or name:find("store") then
                    pcall(function()
                        descendant:Destroy() -- حذف أي واجهة جديدة فوراً
                    end)
                end
            end
        end)
    end
end

-- [[ ربط الأزرار بالوظائف ]] --
ForwardBtn.MouseButton1Click:Connect(function()
    phaseThroughWall("forward")
end)

BackwardBtn.MouseButton1Click:Connect(function()
    phaseThroughWall("backward")
end)

BlockPassesBtn.MouseButton1Click:Connect(function()
    blockGamepasses()
    BlockPassesBtn.Text = "تم حظر واجهات الشراء!"
    BlockPassesBtn.BackgroundColor3 = Color3.fromRGB(40, 100, 40)
    BlockPassesBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    
    task.wait(2)
    BlockPassesBtn.Text = "إزالة واجهات الشراء نهائياً"
    BlockPassesBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    BlockPassesBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
end)
