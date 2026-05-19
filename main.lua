--====================================================================--
--                      حقوق السكربت: K V N                           --
--====================================================================--

-- [[ الخدمات الأساسية ]]
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- [[ إعدادات السكربت الافتراضية ]]
local Settings = {
    AimbotEnabled = false,
    AimTarget = "Head", -- الخيارات: "Head", "Random", "Stomach"
    MaxDistance = 30, -- المسافة المحددة (30 متر / ستد)
    EspEnabled = false,
    InventoryEspEnabled = false,
    FriendsList = {} -- قائمة الأصدقاء المستثنيين من الآيم بوت
}

--====================================================================--
-- [1] تصميم واجهة المستخدم (GUI) ودالة السحب والإغلاق
--====================================================================--

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KVN_Admin_Menu"
ScreenGui.ResetOnSpawn = false
-- حماية الواجهة من الظهور في لقطات الشاشة أو برامج الحماية للمشغلات الحديثة
if syn and syn.protect_gui then syn.protect_gui(ScreenGui) end
ScreenGui.Parent = game:CoreGui

-- الزر الخارجي لإعادة فتح القائمة بعد إغلاقها
local OpenButton = Instance.new("TextButton")
OpenButton.Name = "OpenButton"
OpenButton.Size = UDim2.new(0, 80, 0, 35)
OpenButton.Position = UDim2.new(0, 10, 0, 10)
OpenButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
OpenButton.TextColor3 = Color3.fromRGB(0, 255, 150)
OpenButton.Text = "KVN OPEN"
OpenButton.Font = Enum.Font.SourceSansBold
OpenButton.TextSize = 16
OpenButton.Visible = false
OpenButton.Parent = ScreenGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 400, 0, 450)
MainFrame.Position = UDim2.new(0.35, 0, 0.25, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true -- تفعيل ميزة السحب الافتراضية للمشغلات
MainFrame.Parent = ScreenGui

-- زوايا دائرية للقائمة
local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 8)
Corner.Parent = MainFrame

-- عنوان القائمة والحقوق
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, -40, 0, 40)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "KVN PREMIUM MENU"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 20
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = MainFrame

-- زر الإغلاق (X)
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -35, 0, 5)
CloseButton.BackgroundTransparency = 1
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 50, 50)
CloseButton.Font = Enum.Font.SourceSansBold
CloseButton.TextSize = 20
CloseButton.Parent = MainFrame

CloseButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    OpenButton.Visible = true
end)

OpenButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    OpenButton.Visible = false
end)

-- حاوية الأزرار والخيارات
local Container = Instance.new("ScrollingFrame")
Container.Name = "Container"
Container.Size = UDim2.new(1, -20, 1, -60)
Container.Position = UDim2.new(0, 10, 0, 50)
Container.BackgroundTransparency = 1
Container.CanvasSize = UDim2.new(0, 0, 0, 550)
Container.ScrollBarThickness = 4
Container.Parent = MainFrame

local UIList = Instance.new("UIListLayout")
UIList.Padding = UDim.new(0, 10)
UIList.Parent = Container

-- دالة مساعدة لإنشاء الأزرار التبديلية (Toggle)
local function createToggle(name, text, callback)
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Text = text .. " : OFF"
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 16
    
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 5)
    c.Parent = btn
    
    local enabled = false
    btn.MouseButton1Click:Connect(function()
        enabled = not enabled
        if enabled then
            btn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
            btn.Text = text .. " : ON"
        else
            btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            btn.Text = text .. " : OFF"
        end
        callback(enabled)
    end)
    btn.Parent = Container
    return btn
end

-- [ إنشاء أزرار التحكم بالـ GUI ]

-- 1. تفعيل الآيم بوت
createToggle("ToggleAimbot", "Aimbot", function(state)
    Settings.AimbotEnabled = state
end)

-- 2. قائمة اختيار مكان الاستهداف (Dropdown مصغر)
local TargetDropdown = Instance.new("TextButton")
TargetDropdown.Name = "TargetDropdown"
TargetDropdown.Size = UDim2.new(1, 0, 0, 40)
TargetDropdown.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
TargetDropdown.TextColor3 = Color3.fromRGB(255, 200, 0)
TargetDropdown.Text = "Target: Head (Click to Cycle)"
TargetDropdown.Font = Enum.Font.SourceSansBold
TargetDropdown.TextSize = 16
local tdCorner = Instance.new("UICorner")
tdCorner.CornerRadius = UDim.new(0, 5)
tdCorner.Parent = TargetDropdown
TargetDropdown.Parent = Container

local modes = {"Head", "Stomach", "Random"}
local currentModeIndex = 1

TargetDropdown.MouseButton1Click:Connect(function()
    currentModeIndex = currentModeIndex + 1
    if currentModeIndex > #modes then currentModeIndex = 1 end
    Settings.AimTarget = modes[currentModeIndex]
    TargetDropdown.Text = "Target: " .. Settings.AimTarget
end)

-- 3. تفعيل الـ ESP لروية اللاعبين من خلف الجدران
createToggle("ToggleESP", "Player ESP", function(state)
    Settings.EspEnabled = state
end)

-- 4. تفعيل الـ Inventory ESP لرؤية أدوات اللاعبين
createToggle("ToggleInvESP", "Inventory ESP", function(state)
    Settings.InventoryEspEnabled = state
end)

-- 5. خانة إدخال اسم لإضافته للأصدقاء المستثنيين
local FriendInput = Instance.new("TextBox")
FriendInput.Name = "FriendInput"
FriendInput.Size = UDim2.new(1, 0, 0, 40)
FriendInput.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
FriendInput.TextColor3 = Color3.fromRGB(255, 255, 255)
FriendInput.PlaceholderText = "Type Player Name to Whitelist..."
FriendInput.Text = ""
FriendInput.Font = Enum.Font.SourceSans
FriendInput.TextSize = 16
local fiCorner = Instance.new("UICorner")
fiCorner.CornerRadius = UDim.new(0, 5)
fiCorner.Parent = FriendInput
FriendInput.Parent = Container

FriendInput.FocusLost:Connect(function(enterPressed)
    if enterPressed and FriendInput.Text ~= "" then
        local targetName = FriendInput.Text
        Settings.FriendsList[targetName] = true
        FriendInput.Text = "Added: " .. targetName
        task.wait(1)
        FriendInput.Text = ""
    end
end)


--====================================================================--
-- [2] منطق البرمجة (الآيم بوت المتطور - مسافة 30 متر)
--====================================================================--

-- دالة للحصول على جزء عشوائي من الجسم
local function getRandomBodyPart(character)
    local parts = {}
    for _, part in pairs(character:GetChildren()) do
        if part:IsA("BasePart") then
            table.insert(parts, part)
        end
    end
    if #parts > 0 then
        return parts[math.random(1, #parts)]
    end
    return character:FindFirstChild("Head")
end

-- دالة تحديد الهدف الأقرب بناءً على الشروط المطلوبة
local function getClosestTarget()
    local closestPlayer = nil
    local shortestDistance = math.huge

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            -- 1. التأكد أن اللاعب ليس في قائمة الأصدقاء (Whitelist)
            if not Settings.FriendsList[player.Name] then
                
                local rootPart = player.Character.HumanoidRootPart
                -- حساب المسافة الفعلية بينك وبين اللاعب الآخر بالمتر (Magnitude)
                local distance = (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")) 
                    and (LocalPlayer.Character.HumanoidRootPart.Position - rootPart.Position).Magnitude or math.huge
                
                -- 2. التحقق من شرط المسافة (أقل من أو يساوي 30 متر)
                if distance <= Settings.MaxDistance then
                    -- حساب المسافة على الشاشة لتوجيه الكاميرا بسلاسة
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

-- تشغيل الآيم بوت مع توجيه الكاميرا تلقائياً عند الضغط على الزر الأيمن للفأرة
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

RunService.RenderStepped:Connect(function()
    if Settings.AimbotEnabled and _G.Aiming then
        local target = getClosestTarget()
        if target and target.Character then
            local aimPart = nil
            
            -- تحديد مكان الشبك بناءً على اختيارك من القائمة
            if Settings.AimTarget == "Head" then
                aimPart = target.Character:FindFirstChild("Head")
            elseif Settings.AimTarget == "Stomach" then
                aimPart = target.Character:FindFirstChild("UpperTorso") or target.Character:FindFirstChild("Torso")
            elseif Settings.AimTarget == "Random" then
                aimPart = getRandomBodyPart(target.Character)
            end
            
            if aimPart then
                -- توجيه الكاميرا بسلاسة نحو الهدف المختار
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, aimPart.Position)
            end
        end
    end
end)


--====================================================================--
-- [3] نظام الـ ESP المتطور (رؤية الجدران + كشف الأدوات بالنسخ واللون)
--====================================================================--

local function createEspTags(player)
    -- تجنب تكرار الـ ESP لنفس اللاعب
    if player.Character and player.Character:FindFirstChild("KVN_ESP_Billboard") then
        player.Character.KVN_ESP_Billboard:Destroy()
    end
    
    local character = player.Character or player.CharacterAdded:Wait()
    local head = character:WaitForChild("Head", 5)
    if not head then return end
    
    -- إنشاء اللوحة فوق رأس اللاعب لتعمل من خلف الجدران (AlwaysOnTop)
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

    -- نص اسم اللاعب
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Name = "NameLabel"
    nameLabel.Size = UDim2.new(1, 0, 0, 20)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = player.Name
    nameLabel.TextColor3 = player.TeamColor and player.TeamColor.Color or Color3.fromRGB(255, 0, 0) -- نفس لون فريقه أو أحمر افتراضي
    nameLabel.Font = Enum.Font.SourceSansBold
    nameLabel.TextSize = 16
    nameLabel.Visible = false
    nameLabel.Parent = billboard

    -- نص الأدوات (Inventory)
    local invLabel = Instance.new("TextLabel")
    invLabel.Name = "InvLabel"
    invLabel.Size = UDim2.new(1, 0, 0, 20)
    invLabel.BackgroundTransparency = 1
    invLabel.Text = ""
    invLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    invLabel.Font = Enum.Font.SourceSansItalic
    invLabel.TextSize = 14
    invLabel.Visible = false
    invLabel.Parent = billboard
    
    -- تحديث الـ ESP بشكل مستمر للكشف الديناميكي
    local connection
    connection = RunService.Heartbeat:Connect(function()
        if not character or not character:Parent() then
            connection:Disconnect()
            return
        end
        
        -- التحكم في ظهور اسم اللاعب (ESP الأساسي)
        nameLabel.Visible = Settings.EspEnabled
        
        -- التحكم في ظهور الأدوات (Inventory ESP) والنسخ المطابق للاسم واللون
        if Settings.InventoryEspEnabled then
            invLabel.Visible = true
            local toolName = "Empty"
            local toolColor = Color3.fromRGB(150, 150, 150)
            
            -- فحص الأداة الممسوكة باليد حالياً
            local holding = character:FindFirstChildOfClass("Tool")
            if holding then
                toolName = holding.Name
                toolColor = Color3.fromRGB(0, 255, 100) -- لون مميز للأداة الممسوكة
            else
                -- فحص أول أداة في الحقيبة إذا لم يكن يمسك شيئاً
                local backpack = player:FindFirstChild("Backpack")
                if backpack then
                    local firstTool = backpack:FindFirstChildOfClass("Tool")
                    if firstTool then
                        toolName = firstTool.Name
                        toolColor = Color3.fromRGB(200, 200, 200)
                    end
                end
            end
            
            invLabel.Text = "[" .. toolName .. "]"
            invLabel.TextColor3 = toolColor
        else
            invLabel.Visible = false
        end
    end)
end

-- تفعيل الـ ESP لكل اللاعبين الحاليين والقادمين للسيرفر
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
