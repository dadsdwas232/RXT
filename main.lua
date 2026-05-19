--[[
    =========================================
    [+] Script Name: K V N Premium Hub
    [+] Supported: Exploits / Executors
    [+] Creator: K V N
    =========================================
--]]

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

-- تفعيل الميزات واختياراتها
local Settings = {
    AimbotEnabled = false,
    AimPart = "Head", -- الخيارات: "Head", "Abdomen", "Random"
    MaxDistance = 30, -- المسافة المحددة (30 متر)
    EspEnabled = false,
    InventoryEspEnabled = false,
    Friends = {} -- قائمة الأصدقاء (يتم إدخال أسماء اللاعبين هنا)
}

------------------------------------------------------------------------
-- [1] بناء واجهة المستخدم (GUI) بحقوق K V N
------------------------------------------------------------------------

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KVN_Hub"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- اللوحة الرئيسية (Main Frame)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 320, 0, 420)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -210)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true -- ميزة السحب بحرية
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

-- العنوان والحقوق
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Title.Text = "K V N  |  PREMIUM HUB"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 8)
TitleCorner.Parent = Title

-- حاوية الأزرار لتنظيمها بشكل تلقائي
local Container = Instance.new("ScrollingFrame")
Container.Size = UDim2.new(1, -20, 1, -60)
Container.Position = UDim2.new(0, 10, 0, 50)
Container.BackgroundTransparency = 1
Container.ScrollBarThickness = 4
Container.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 8)
UIListLayout.Parent = Container

-- دالة مساعدة لإنشاء الأزرار بسلاسة
local function CreateToggleButton(name, text, default, callback)
    local Button = Instance.new("TextButton")
    Button.Name = name
    Button.Size = UDim2.new(1, 0, 0, 40)
    Button.Font = Enum.Font.GothamSemibold
    Button.TextSize = 14
    Button.BorderSizePixel = 0
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = Button

    local state = default
    local function update()
        if state then
            Button.BackgroundColor3 = Color3.fromRGB(46, 204, 113) -- أخضر تفعيل
            Button.Text = text .. " [ON]"
            Button.TextColor3 = Color3.fromRGB(255, 255, 255)
        else
            Button.BackgroundColor3 = Color3.fromRGB(45, 45, 45) -- رمادي تعطيل
            Button.Text = text .. " [OFF]"
            Button.TextColor3 = Color3.fromRGB(200, 200, 200)
        end
    end
    
    Button.MouseButton1Click:Connect(function()
        state = not state
        update()
        callback(state)
    end)
    
    update()
    Button.Parent = Container
    return Button
end

------------------------------------------------------------------------
-- [2] إضافة الأزرار والتحكم بالقائمة الفرعية للأيم بوت
------------------------------------------------------------------------

-- تفعيل/تعطيل الأيم بوت
CreateToggleButton("ToggleAimbot", "Aimbot", Settings.AimbotEnabled, function(val)
    Settings.AimbotEnabled = val
end)

-- أزرار تحديد مكان شبك الأيم بوت (Dropdown محاكي)
local TargetPanel = Instance.new("Frame")
TargetPanel.Size = UDim2.new(1, 0, 0, 35)
TargetPanel.BackgroundTransparency = 1
TargetPanel.Parent = Container

local UIListHorizontal = Instance.new("UIListLayout")
UIListHorizontal.FillDirection = Enum.FillDirection.Horizontal
UIListHorizontal.Padding = UDim.new(0, 5)
UIListHorizontal.Parent = TargetPanel

local function CreatePartButton(partName, displayName)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(0.31, 0, 1, 0)
    Btn.BackgroundColor3 = Settings.AimPart == partName and Color3.fromRGB(52, 152, 219) or Color3.fromRGB(40, 40, 40)
    Btn.Text = displayName
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.Font = Enum.Font.Gotham
    Btn.TextSize = 12
    
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 4)
    c.Parent = Btn
    
    Btn.MouseButton1Click:Connect(function()
        Settings.AimPart = partName
        for _, v in pairs(TargetPanel:GetChildren()) do
            if v:IsA("TextButton") then
                v.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            end
        end
        Btn.BackgroundColor3 = Color3.fromRGB(52, 152, 219) -- أزرق عند الاختيار
    end)
    Btn.Parent = TargetPanel
end

CreatePartButton("Head", "الرأس")
CreatePartButton("Abdomen", "البطن")
CreatePartButton("Random", "عشوائي")

-- تفعيل/تعطيل الـ ESP والجدران
CreateToggleButton("ToggleESP", "Wall ESP", Settings.EspEnabled, function(val)
    Settings.EspEnabled = val
end)

-- تفعيل/تعطيل كشف الـ Inventory مع الألوان والأسماء الأصلية
CreateToggleButton("ToggleInvESP", "Show Inventory Items", Settings.InventoryEspEnabled, function(val)
    Settings.InventoryEspEnabled = val
end)

-- إدخال وإدارة قائمة الأصدقاء (Friend List GUI)
local FriendInput = Instance.new("TextBox")
FriendInput.Size = UDim2.new(1, 0, 0, 35)
FriendInput.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
FriendInput.PlaceholderText = "اكتب اسم اللاعب لإضافته للأصدقاء..."
FriendInput.Text = ""
FriendInput.TextColor3 = Color3.fromRGB(255, 255, 255)
FriendInput.Font = Enum.Font.Gotham
FriendInput.TextSize = 12
local fC = Instance.new("UICorner") fC.CornerRadius = UDim.new(0, 4) fC.Parent = FriendInput
FriendInput.Parent = Container

FriendInput.FocusLost:Connect(function(enterPressed)
    if enterPressed and FriendInput.Text ~= "" then
        local targetName = FriendInput.Text
        Settings.Friends[targetName] = true
        FriendInput.Text = "تمت إضافة: " .. targetName
        task.wait(1)
        FriendInput.Text = ""
    end
end)

-- ميزة إخفاء وإظهار الواجهة عبر زر LeftControl
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.LeftControl then
        MainFrame.Visible = not MainFrame.Visible
    end
end)


------------------------------------------------------------------------
-- [3] المنطق البرمجي: الأيم بوت (Aimbot) بمسافة 30 متر وضد الأصدقاء
------------------------------------------------------------------------

local function GetClosestPlayer()
    local closestPlayer = nil
    local shortestDistance = math.huge

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChildOfClass("Humanoid") and player.Character.Humanoid.Health > 0 then
            
            -- التحقق من قائمة الأصدقاء (تخطي إذا كان صديقاً)
            if Settings.Friends[player.Name] then continue end

            -- حساب المسافة الحقيقية بالمتر (Studs / 3.57 تعادل المتر تقريباً، وهنا وضعنا 100 ستاود لتساوي 30 متر بدقة)
            local distance = (LocalPlayer.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
            if distance <= 100 then -- 100 Studs = حوالي 28-30 متر داخل روبلوكس
                
                -- حساب المسافة على الشاشة بالنسبة للماوس
                local pos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)
                if onScreen then
                    local mousePos = UserInputService:GetMouseLocation()
                    local mouseDistance = (Vector2.new(pos.X, pos.Y) - mousePos).Magnitude
                    
                    if mouseDistance < shortestDistance then
                        closestPlayer = player
                        shortestDistance = mouseDistance
                    end
                end
            end
        end
    end
    return closestPlayer
end

-- تشغيل الأيم بوت عند الضغط المطول على الماوس الأيمن
local Aiming = false
UserInputService.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        Aiming = true
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        Aiming = false
    end
end)

RunService.RenderStepped:Connect(function()
    if Settings.AimbotEnabled and Aiming then
        local target = GetClosestPlayer()
        if target and target.Character then
            local aimPartName = Settings.AimPart
            
            -- ميزة العشوائي للجسم بالكامل
            if aimPartName == "Random" then
                local parts = {"Head", "UpperTorso", "LowerTorso", "LeftUpperArm", "RightUpperArm"}
                aimPartName = parts[math.random(1, #parts)]
            elseif aimPartName == "Abdomen" then
                aimPartName = target.Character:FindFirstChild("LowerTorso") and "LowerTorso" or "Torso"
            end
            
            local targetPart = target.Character:FindFirstChild(aimPartName)
            if targetPart then
                workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, targetPart.Position)
            end
        end
    end
end)


------------------------------------------------------------------------
-- [4] المنطق البرمجي: الرادار والـ ESP والـ Inventory لكل الناس
------------------------------------------------------------------------

local function CreateEsp(player)
    local Highlight = Instance.new("Highlight")
    Highlight.Name = "KVN_ESP"
    Highlight.FillColor = Color3.fromRGB(255, 0, 0)
    Highlight.FillTransparency = 0.5
    Highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    Highlight.OutlineTransparency = 0
    Highlight.Adornee = player.Character
    Highlight.Parent = CoreGui

    -- واجهة فوق رأس اللاعب لعرض الـ Inventory والأسماء
    local Billboard = Instance.new("BillboardGui")
    Billboard.Name = "KVN_Billboard"
    Billboard.Size = UDim2.new(0, 200, 0, 50)
    Billboard.AlwaysOnTop = true
    Billboard.ExtentsOffset = Vector3.new(0, 3, 0)
    Billboard.Adornee = player.Character:FindFirstChild("HumanoidRootPart")
    Billboard.Parent = CoreGui

    local TextLabel = Instance.new("TextLabel")
    TextLabel.Size = UDim2.new(1, 0, 1, 0)
    TextLabel.BackgroundTransparency = 1
    TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextLabel.Font = Enum.Font.GothamBold
    TextLabel.TextSize = 12
    TextLabel.TextStrokeTransparency = 0
    TextLabel.Parent = Billboard

    -- تحديث الـ ESP والأدوات بشكل مستمر
    local connection
    connection = RunService.RenderStepped:Connect(function()
        if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
            Highlight:Destroy()
            Billboard:Destroy()
            connection:Disconnect()
            return
        end

        -- التحكم بالرؤية عبر الأزرار
        Highlight.Enabled = Settings.EspEnabled
        Billboard.Enabled = Settings.EspEnabled
        
        if Settings.InventoryEspEnabled then
            local holding = "Nothing"
            local tool = player.Character:FindFirstChildOfClass("Tool")
            
            -- إذا كان يمسك الأداة في يده، يتم جلب الاسم واللون الأصلي لها
            if tool then
                holding = tool.Name
                -- محاكاة ألوان متناسقة للأدوات لتظهر بنظام "نسخ ولصق" رائع
                TextLabel.Text = player.Name .. "\n[Holding: " .. holding .. "]"
                TextLabel.TextColor3 = Color3.fromRGB(241, 196, 15) -- لون ذهبي مميز للأدوات الحاملة
            else
                -- فحص الحقيبة الخلفية إذا لم يكن يحملها بيده
                local bTool = player:FindFirstChild("Backpack") and player.Backpack:FindFirstChildOfClass("Tool")
                if bTool then
                    holding = bTool.Name
                end
                TextLabel.Text = player.Name .. "\n[Inv: " .. holding .. "]"
                TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            end
        else
            TextLabel.Text = player.Name
            TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        end
    end)
end

-- تفعيل الـ ESP تلقائياً لكل من يدخل السيرفر
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        task.wait(1)
        CreateEsp(player)
    end)
end)

for _, player in pairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        if player.Character then
            CreateEsp(player)
        end
        player.CharacterAdded:Connect(function()
            task.wait(1)
            CreateEsp(player)
        end)
    end
end
