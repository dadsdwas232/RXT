--====================================================================--
--                      حقوق السكربت: K V N                           --
--====================================================================--

-- [[ الخدمات الأساسية واستدعاء بيئة المشغل الخارجي ]]
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- تأمين توافق دالة محاكاة الماوس للمشغلات الخارجية المختلفة
local mousemoverel = mousemoverel or (syn and syn.mousemoverel) or (Input and Input.MouseMove)

-- [[ إعدادات السكربت الافتراضية ]]
local Settings = {
    AimbotEnabled = false,
    AimTarget = "Head", -- الخيارات: "Head", "Random", "Stomach"
    MaxDistance = 30, -- المسافة القصوى (30 متر / ستد)
    EspEnabled = false,
    InventoryEspEnabled = false,
    FriendsList = {} -- قائمة الأصدقاء المستثنيين من الآيم بوت
}

--====================================================================--
-- [1] تصميم واجهة المستخدم (GUI) المخصصة للمشغلات الخارجية
--====================================================================--

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KVN_External_Menu"
ScreenGui.ResetOnSpawn = false

-- حماية الـ GUI من الفحص التلقائي لأنظمة الحماية (Anti-Cheat Bypass)
if getgenv and getgenv().protect_gui then
    getgenv().protect_gui(ScreenGui)
elseif syn and syn.protect_gui then
    syn.protect_gui(ScreenGui)
end
ScreenGui.Parent = game:CoreGui

-- الزر الخارجي العائم لإعادة فتح القائمة بعد إغلاقها
local OpenButton = Instance.new("TextButton")
OpenButton.Name = "OpenButton"
OpenButton.Size = UDim2.new(0, 90, 0, 35)
OpenButton.Position = UDim2.new(0, 15, 0, 15)
OpenButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
OpenButton.TextColor3 = Color3.fromRGB(0, 255, 150)
OpenButton.Text = "⚡ KVN OPEN"
OpenButton.Font = Enum.Font.SourceSansBold
OpenButton.TextSize = 14
OpenButton.Visible = false
OpenButton.Parent = ScreenGui

local obCorner = Instance.new("UICorner")
obCorner.CornerRadius = UDim.new(0, 6)
obCorner.Parent = OpenButton

-- القائمة الرئيسية
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 380, 0, 440)
MainFrame.Position = UDim2.new(0.35, 0, 0.25, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true -- تفعيل السحب والتنقل الحر عبر الشاشة للمشغل
MainFrame.Parent = ScreenGui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 10)
Corner.Parent = MainFrame

-- ترويسة القائمة والحقوق
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, -50, 0, 45)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "K V N  |  EXTERNAL EXECUTOR"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = MainFrame

-- زر الإغلاق الذكي (X)
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -40, 0, 7)
CloseButton.BackgroundTransparency = 1
CloseButton.Text = "✕"
CloseButton.TextColor3 = Color3.fromRGB(250, 60, 60)
CloseButton.Font = Enum.Font.SourceSansBold
CloseButton.TextSize = 18
CloseButton.Parent = MainFrame

CloseButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    OpenButton.Visible = true
end)

OpenButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    OpenButton.Visible = false
end)

-- حاوية الخيارات التمريرية
local Container = Instance.new("ScrollingFrame")
Container.Name = "Container"
Container.Size = UDim2.new(1, -20, 1, -65)
Container.Position = UDim2.new(0, 10, 0, 55)
Container.BackgroundTransparency = 1
Container.CanvasSize = UDim2.new(0, 0, 0, 500)
Container.ScrollBarThickness = 3
Container.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 80)
Container.Parent = MainFrame

local UIList = Instance.new("UIListLayout")
UIList.Padding = UDim.new(0, 10)
UIList.Parent = Container

-- دالة ديناميكية لإنشاء أزرار التشغيل والإيقاف (Toggles)
local function createToggle(name, text, callback)
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.Size = UDim2.new(1, 0, 0, 42)
    btn.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.Text = text .. " : [ DISABLED ]"
    btn.Font = Enum.Font.SourceSansSemibold
    btn.TextSize = 15
    
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 6)
    c.Parent = btn
    
    local enabled = false
    btn.MouseButton1Click:Connect(function()
        enabled = not enabled
        if enabled then
            btn.BackgroundColor3 = Color3.fromRGB(0, 150, 100)
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.Text = text .. " : [ ENABLED ]"
        else
            btn.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
            btn.TextColor3 = Color3.fromRGB(200, 200, 200)
            btn.Text = text .. " : [ DISABLED ]"
        end
        callback(enabled)
    end)
    btn.Parent = Container
    return btn
end

-- [ إضافة أزرار التحكم الفورية للواجهة ]

createToggle("ToggleAimbot", "Aimbot Mechanism", function(state)
    Settings.AimbotEnabled = state
end)

-- زر التبديل الدوار لتحديد مكان شبك الآيم بوت (Body / Head / Stomach)
local TargetDropdown = Instance.new("TextButton")
TargetDropdown.Name = "TargetDropdown"
TargetDropdown.Size = UDim2.new(1, 0, 0, 42)
TargetDropdown.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
TargetDropdown.TextColor3 = Color3.fromRGB(255, 185, 0)
TargetDropdown.Text = "🎯 Target Area: Head (Click to Change)"
TargetDropdown.Font = Enum.Font.SourceSansBold
TargetDropdown.TextSize = 15
local tdCorner = Instance.new("UICorner")
tdCorner.CornerRadius = UDim.new(0, 6)
tdCorner.Parent = TargetDropdown
TargetDropdown.Parent = Container

local modes = {"Head", "Stomach", "Random"}
local currentModeIndex = 1

TargetDropdown.MouseButton1Click:Connect(function()
    currentModeIndex = currentModeIndex + 1
    if currentModeIndex > #modes then currentModeIndex = 1 end
    Settings.AimTarget = modes[currentModeIndex]
    TargetDropdown.Text = "🎯 Target Area: " .. Settings.AimTarget
end)

createToggle("ToggleESP", "Wall Player ESP", function(state)
    Settings.EspEnabled = state
end)

createToggle("ToggleInvESP", "Inventory / Tools ESP", function(state)
    Settings.InventoryEspEnabled = state
end)

-- حقل إدخال أسماء الأصدقاء لحمايتهم من استهداف السكربت
local FriendInput = Instance.new("TextBox")
FriendInput.Name = "FriendInput"
FriendInput.Size = UDim2.new(1, 0, 0, 42)
FriendInput.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
FriendInput.TextColor3 = Color3.fromRGB(0, 255, 150)
FriendInput.PlaceholderText = "➕ Type Username to Whitelist..."
FriendInput.Text = ""
FriendInput.Font = Enum.Font.SourceSans
FriendInput.TextSize = 15
local fiCorner = Instance.new("UICorner")
fiCorner.CornerRadius = UDim.new(0, 6)
fiCorner.Parent = FriendInput
FriendInput.Parent = Container

FriendInput.FocusLost:Connect(function(enterPressed)
    if enterPressed and FriendInput.Text ~= "" then
        local targetName = FriendInput.Text
        Settings.FriendsList[targetName] = true
        FriendInput.Text = "✓ Secured: " .. targetName
        task.wait(1.5)
        FriendInput.Text = ""
    end
end)


--====================================================================--
-- [2] منطق البرمجة المتقدم (الآيم بوت الخارجي والمحدد بـ 30 متر)
--====================================================================--

-- دالة للحصول على جزء عشوائي تماماً من جسم العدو لتفادي كشف السكربت كآلي
local function getRandomBodyPart(character)
    local parts = {}
    for _, part in pairs(character:GetChildren()) do
        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
            table.insert(parts, part)
        end
    end
    if #parts > 0 then
        return parts[math.random(1, #parts)]
    end
    return character:FindFirstChild("Head")
end

-- البحث عن الهدف الأقرب والمطابق للمسافة (30 متر كحد أقصى)
local function getClosestTarget()
    local closestPlayer = nil
    local shortestDistance = math.huge

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            -- تخطي اللاعب إذا كان مسجلاً في القائمة البيضاء (الفريند لِست)
            if not Settings.FriendsList[player.Name] then
                
                local rootPart = player.Character.HumanoidRootPart
                -- حساب مسافة البعد الحقيقية بالمتر (Magnitude)
                local distance = (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")) 
                    and (LocalPlayer.Character.HumanoidRootPart.Position - rootPart.Position).Magnitude or math.huge
                
                -- التحقق الصارم من شرط المسافة (30 متر كحد أقصى)
                if distance <= Settings.MaxDistance then
                    -- إسقاط الإحداثيات على الشاشة لضمان توجيه الكاميرا بدقة للمشغلات الخارجية
                    local screenPos, onScreen = Camera:WorldToViewportPoint(rootPart.Position)
                    if onScreen then
                        local mousePos = UserInputService:GetMouseLocation()
                        local mouseDistance = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                        
                        if mouseDistance < shortestDistance then
                            shortestDistance = mouseDistance
                            closestPlayer = player
                        end
                    end
                end
            end
        end
    end
    return closestPlayer
end

-- تشغيل ميزة تعقب الهدف عند ضغط الزر الأيمن للفأرة (Hold Right Click)
UserInputService.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        _G.Aiming = true
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        _G.Aiming = false
    end
end)

-- حلقة التحديث المستمر المتوافقة مع الـ Render المخصص للمشغلات
RunService.RenderStepped:Connect(function()
    if Settings.AimbotEnabled and _G.Aiming then
        local target = getClosestTarget()
        if target and target.Character then
            local aimPart = nil
            
            -- تحديد نقطة الشبك والضرب المحددة من القائمة
            if Settings.AimTarget == "Head" then
                aimPart = target.Character:FindFirstChild("Head")
            elseif Settings.AimTarget == "Stomach" then
                aimPart = target.Character:FindFirstChild("UpperTorso") or target.Character:FindFirstChild("Torso")
            elseif Settings.AimTarget == "Random" then
                aimPart = getRandomBodyPart(target.Character)
            end
            
            if aimPart then
                -- توجيه الكاميرا للمشغلات (يمزج بين CFrame ومحاكاة الماوس لضمان الثبات)
                if mousemoverel then
                    local screenPos, onScreen = Camera:WorldToViewportPoint(aimPart.Position)
                    if onScreen then
                        local mousePos = UserInputService:GetMouseLocation()
                        mousemoverel((screenPos.X - mousePos.X) * 0.4, (screenPos.Y - mousePos.Y) * 0.4)
                    end
                else
                    Camera.CFrame = CFrame.new(Camera.CFrame.Position, aimPart.Position)
                end
            end
        end
    end
end)


--====================================================================--
-- [3] الـ ESP المتطور ومستكشف عتاد اللاعبين (Inventory ESP) عبر الجدران
--====================================================================--

local function createEspTags(player)
    -- إزالة الـ ESP القديم إن وجد لمنع التراكم والـ Lag
    if player.Character and player.Character:FindFirstChild("KVN_ESP_Billboard") then
        player.Character.KVN_ESP_Billboard:Destroy()
    end
    
    local character = player.Character or player.CharacterAdded:Wait()
    local head = character:WaitForChild("Head", 5)
    if not head then return end
    
    -- بناء اللوحة الشفافة فوق رأس اللاعب مع ميزة الاختراق الفوري للجدران (AlwaysOnTop)
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "KVN_ESP_Billboard"
    billboard.AlwaysOnTop = true
    billboard.Size = UDim2.new(0, 200, 0, 100)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.Parent = character
    
    local layout = Instance.new("UIListLayout")
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.VerticalAlignment = Enum.VerticalAlignment.Center
    layout.Parent = billboard

    -- نص يطابق اسم ولون فريق اللاعب بشكل متناسق (TeamColor Match)
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Name = "NameLabel"
    nameLabel.Size = UDim2.new(1, 0, 0, 20)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = player.Name
    nameLabel.TextColor3 = player.TeamColor and player.TeamColor.Color or Color3.fromRGB(255, 50, 50)
    nameLabel.Font = Enum.Font.SourceSansBold
    nameLabel.TextSize = 15
    nameLabel.Visible = false
    nameLabel.Parent = billboard

    -- نص مستكشف الأدوات والـ Inventory الفريد للنسخ
    local invLabel = Instance.new("TextLabel")
    invLabel.Name = "InvLabel"
    invLabel.Size = UDim2.new(1, 0, 0, 20)
    invLabel.BackgroundTransparency = 1
    invLabel.Text = ""
    invLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    invLabel.Font = Enum.Font.SourceSansBold
    invLabel.TextSize = 13
    invLabel.Visible = false
    invLabel.Parent = billboard
    
    -- ربط نظام الكشف بنبضات المعالج (Heartbeat) للتحديث السريع للأدوات الممسوكة والـ Backpack
    local connection
    connection = RunService.Heartbeat:Connect(function()
        if not character or not character:Parent() then
            connection:Disconnect()
            return
        end
        
        -- إظهار أو إخفاء الـ ESP بناءً على حالة الزر في القائمة
        nameLabel.Visible = Settings.EspEnabled
        
        if Settings.InventoryEspEnabled then
            invLabel.Visible = true
            local toolName = "None"
            local toolColor = Color3.fromRGB(160, 160, 160) -- لون رمادي افتراضي إذا كان فارغاً
            
            -- 1. فحص إذا كان يمسك السلاح أو الأداة بيده حالياً
            local holding = character:FindFirstChildOfClass("Tool")
            if holding then
                toolName = holding.Name
                toolColor = Color3.fromRGB(0, 255, 120) -- لون أخضر فاقع للتنبيه بالأداة النشطة
            else
                -- 2. إذا لم يكن بيده شيء، يتم فحص أول أداة بداخل الـ Backpack الخاص به فوراً
                local backpack = player:FindFirstChild("Backpack")
                if backpack then
                    local firstTool = backpack:FindFirstChildOfClass("Tool")
                    if firstTool then
                        toolName = firstTool.Name
                        toolColor = Color3.fromRGB(230, 230, 230) -- لون أبيض للأدوات المخزنة
                    end
                end
            end
            
            -- طباعة الاسم المطابق للأداة بالكامل مع المحافظة على التلوين المحدد
            invLabel.Text = "[ " .. toolName .. " ]"
            invLabel.TextColor3 = toolColor
        else
            invLabel.Visible = false
        end
    end)
end

-- تفعيل وتثبيت نظام الكشف الفوري لجميع اللاعبين بالسيرفر
for _, player in pairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        if player.Character then createEspTags(player) end
        player.CharacterAdded:Connect(function()
            task.wait(0.5)
            createEspTags(player)
        end)
    end
end

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        task.wait(0.5)
        createEspTags(player)
    end)
end)
