-- KVN HUB | Ultimate Aimbot + ESP + Inventory | Full Loaded
-- Author: KVN | For Educational Purposes Only

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- Settings
local AimPart = "Head"
local AimbotEnabled = true
local ESPEnabled = true
local InventoryESPEnabled = true
local MaxDistance = 30
local FriendList = {} -- Add usernames manually: {"Player1", "Player2"}

-- Aim Lock Variables
local CurrentTarget = nil
local Locked = false

-- Create ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KVN_Hub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Main Frame (Draggable)
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 360, 0, 520)
MainFrame.Position = UDim2.new(0.5, -180, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
MainFrame.BackgroundTransparency = 0.15
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 12)
Corner.Parent = MainFrame

local Stroke = Instance.new("UIStroke")
Stroke.Thickness = 2
Stroke.Color = Color3.fromRGB(255, 70, 70)
Stroke.Parent = MainFrame

-- Title Bar
local TitleBar = Instance.new("TextLabel")
TitleBar.Size = UDim2.new(1, 0, 0, 35)
TitleBar.Position = UDim2.new(0, 0, 0, 0)
TitleBar.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
TitleBar.BackgroundTransparency = 0.5
TitleBar.Text = "KVN HUB [Ultimate]"
TitleBar.TextColor3 = Color3.fromRGB(255, 100, 100)
TitleBar.TextSize = 18
TitleBar.Font = Enum.Font.GothamBold
TitleBar.Parent = MainFrame

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 70, 0, 30)
CloseBtn.Position = UDim2.new(1, -80, 0, 2)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.Text = "إخفاء"
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
CloseBtn.Parent = MainFrame

-- Scrolling Frame for Buttons
local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Size = UDim2.new(1, -20, 1, -55)
ScrollFrame.Position = UDim2.new(0, 10, 0, 45)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 480)
ScrollFrame.ScrollBarThickness = 6
ScrollFrame.Parent = MainFrame

local UIList = Instance.new("UIListLayout")
UIList.Padding = UDim.new(0, 12)
UIList.SortOrder = Enum.SortOrder.LayoutOrder
UIList.Parent = ScrollFrame

-- Toggle GUI Function
local guiVisible = true
CloseBtn.MouseButton1Click:Connect(function()
    guiVisible = not guiVisible
    ScrollFrame.Visible = guiVisible
    CloseBtn.Text = guiVisible and "إخفاء" or "فتح"
    if not guiVisible then
        MainFrame.Size = UDim2.new(0, 260, 0, 40)
    else
        MainFrame.Size = UDim2.new(0, 360, 0, 520)
    end
end)

-- Helper function to create Buttons
local function CreateButton(text, desc, color)
    local btnFrame = Instance.new("Frame")
    btnFrame.Size = UDim2.new(1, 0, 0, 55)
    btnFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    btnFrame.BackgroundTransparency = 0.3
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btnFrame
    btnFrame.Parent = ScrollFrame

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 40)
    btn.Position = UDim2.new(0, 5, 0, 5)
    btn.BackgroundColor3 = color or Color3.fromRGB(70, 70, 90)
    btn.Text = text
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.TextSize = 15
    btn.Font = Enum.Font.GothamSemibold
    local btnCorner2 = Instance.new("UICorner")
    btnCorner2.CornerRadius = UDim.new(0, 6)
    btnCorner2.Parent = btn
    btn.Parent = btnFrame

    local descLabel = Instance.new("TextLabel")
    descLabel.Size = UDim2.new(1, -10, 0, 15)
    descLabel.Position = UDim2.new(0, 5, 0, 38)
    descLabel.BackgroundTransparency = 1
    descLabel.Text = desc
    descLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
    descLabel.TextSize = 11
    descLabel.Font = Enum.Font.Gotham
    descLabel.Parent = btnFrame
    return btn
end

-- AIM PART SELECTION
local aimPartText = Instance.new("TextLabel")
aimPartText.Size = UDim2.new(1, 0, 0, 25)
aimPartText.BackgroundTransparency = 1
aimPartText.Text = "🎯 جزء التصويب الحالي: HEAD"
aimPartText.TextColor3 = Color3.fromRGB(255, 200, 100)
aimPartText.TextSize = 14
aimPartText.Parent = ScrollFrame

local aimBtn = CreateButton("تغيير جزء التصويب", "Body / Head / بطن / عشوائي (كامل الجسم)", Color3.fromRGB(150, 50, 150))
local aimOptions = {"Body", "Head", "بطن", "عشوائي (كامل الجسم)"}
local aimIndex = 2
aimBtn.MouseButton1Click:Connect(function()
    aimIndex = aimIndex % 4 + 1
    local selected = aimOptions[aimIndex]
    aimPartText.Text = "🎯 جزء التصويب الحالي: " .. selected
    if selected == "Body" then AimPart = "HumanoidRootPart"
    elseif selected == "Head" then AimPart = "Head"
    elseif selected == "بطن" then AimPart = "UpperTorso"
    else AimPart = "Random" end
end)

-- AIMBOT TOGGLE
local aimbotToggle = CreateButton("تعطيل الإيم بوت", "المسافة القصوى: 30 متر فقط", Color3.fromRGB(220, 50, 50))
aimbotToggle.MouseButton1Click:Connect(function()
    AimbotEnabled = not AimbotEnabled
    aimbotToggle.Text = AimbotEnabled and "تعطيل الإيم بوت" or "تفعيل الإيم بوت"
    aimbotToggle.BackgroundColor3 = AimbotEnabled and Color3.fromRGB(220, 50, 50) or Color3.fromRGB(50, 200, 50)
end)

-- ESP BUTTON
local espBtn = CreateButton("تعطيل ESP", "رؤية اللاعبين خلف الجدران + أسماء + مسافات", Color3.fromRGB(80, 150, 200))
espBtn.MouseButton1Click:Connect(function()
    ESPEnabled = not ESPEnabled
    espBtn.Text = ESPEnabled and "تعطيل ESP" or "تفعيل ESP"
    if not ESPEnabled then
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= LocalPlayer and v.Character then
                for _, obj in pairs(v.Character:GetDescendants()) do
                    if obj:IsA("BillboardGui") and obj.Name == "KVN_ESP" then obj:Destroy() end
                end
            end
        end
    end
end)

-- INVENTORY ESP
local invBtn = CreateButton("تعطيل Inventory ESP", "يظهر تحت اللاعب: وش معه (سلاح / أداة)", Color3.fromRGB(200, 150, 50))
invBtn.MouseButton1Click:Connect(function()
    InventoryESPEnabled = not InventoryESPEnabled
    invBtn.Text = InventoryESPEnabled and "تعطيل Inventory ESP" or "تفعيل Inventory ESP"
end)

-- FRIEND LIST MANAGER
local friendBtn = CreateButton("إدارة الأصدقاء", "أضف اسم اللاعب في الكود (FriendList)", Color3.fromRGB(100, 100, 200))

-- ========================
-- ULTRA AIMBOT (LOCK + RETURN)
-- ========================
local function GetClosestPlayer()
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return nil end
    local closest = nil
    local shortest = MaxDistance
    local myPos = LocalPlayer.Character.HumanoidRootPart.Position
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local isFriend = false
            for _, f in pairs(FriendList) do
                if f == player.Name then isFriend = true break end
            end
            if isFriend then continue end
            
            local targetRoot = player.Character.HumanoidRootPart
            local dist = (targetRoot.Position - myPos).Magnitude
            if dist < shortest then
                shortest = dist
                closest = player
            end
        end
    end
    return closest
end

local function GetAimPart(character, partType)
    if partType == "Head" then return character:FindFirstChild("Head")
    elseif partType == "HumanoidRootPart" then return character:FindFirstChild("HumanoidRootPart")
    elseif partType == "UpperTorso" then return character:FindFirstChild("UpperTorso")
    elseif partType == "Random" then
        local parts = {"Head","HumanoidRootPart","UpperTorso","LeftLeg","RightArm"}
        local randPart = parts[math.random(1,#parts)]
        return character:FindFirstChild(randPart)
    else return character:FindFirstChild("Head") end
end

RunService.RenderStepped:Connect(function()
    if not AimbotEnabled then return end
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
    
    local target = GetClosestPlayer()
    if target and target.Character then
        local aimPartInstance = GetAimPart(target.Character, AimPart)
        if aimPartInstance then
            -- Super Lock: force camera CFrame
            local camPos = Camera.CFrame.Position
            local targetPos = aimPartInstance.Position
            local newCF = CFrame.new(camPos, targetPos)
            Camera.CFrame = newCF
        end
    end
end)

-- ========================
-- ESP (Box + Tracer + Name + Distance)
-- ========================
local function CreateESP(player)
    if player == LocalPlayer or not player.Character then return end
    local character = player.Character
    local humanoid = character:FindFirstChild("Humanoid")
    if not humanoid then return end
    
    local espGui = Instance.new("BillboardGui")
    espGui.Name = "KVN_ESP"
    espGui.Adornee = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Head")
    espGui.Size = UDim2.new(0, 4, 0, 3)
    espGui.StudsOffset = Vector3.new(0, 2.5, 0)
    espGui.AlwaysOnTop = true
    espGui.Parent = character
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(1, 0, 1, 0)
    mainFrame.BackgroundTransparency = 0.6
    mainFrame.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    mainFrame.BorderSizePixel = 1
    mainFrame.BorderColor3 = Color3.fromRGB(255, 255, 255)
    mainFrame.Parent = espGui
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 0, 20)
    nameLabel.Position = UDim2.new(0, 0, 1, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = player.Name .. " [" .. math.floor((character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude) .. "m]"
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.TextStrokeTransparency = 0.5
    nameLabel.TextSize = 12
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.Parent = espGui
end

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        if ESPEnabled then CreateESP(player) end
    end)
end)

for _, player in ipairs(Players:GetPlayers()) do
    if ESPEnabled and player ~= LocalPlayer then
        player.CharacterAdded:Connect(function() CreateESP(player) end)
        if player.Character then CreateESP(player) end
    end
end

-- ========================
-- INVENTORY ESP (Shows items under player)
-- ========================
local function CreateInventoryESP(player)
    if player == LocalPlayer or not player.Character or not InventoryESPEnabled then return end
    local character = player.Character
    local backpack = player:FindFirstChild("Backpack")
    local tools = {}
    
    for _, child in pairs(backpack:GetChildren()) do
        if child:IsA("Tool") then table.insert(tools, child.Name) end
    end
    for _, child in pairs(character:GetChildren()) do
        if child:IsA("Tool") then table.insert(tools, child.Name) end
    end
    
    local toolString = table.concat(tools, ", ")
    if toolString == "" then toolString = "لا شيء" end
    
    local invGui = Instance.new("BillboardGui")
    invGui.Name = "KVN_InvESP"
    invGui.Adornee = character:FindFirstChild("Head") or character:FindFirstChild("HumanoidRootPart")
    invGui.Size = UDim2.new(0, 200, 0, 50)
    invGui.StudsOffset = Vector3.new(0, -2, 0)
    invGui.AlwaysOnTop = true
    invGui.Parent = character
    
    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    bg.BackgroundTransparency = 0.4
    bg.BorderSizePixel = 0
    bg.Parent = invGui
    
    local text = Instance.new("TextLabel")
    text.Size = UDim2.new(1, 0, 1, 0)
    text.BackgroundTransparency = 1
    text.Text = "📦 " .. toolString
    text.TextColor3 = Color3.fromRGB(255, 200, 100)
    text.TextSize = 12
    text.TextWrapped = true
    text.Font = Enum.Font.Gotham
    text.Parent = invGui
end

local function UpdateAllInventoryESP()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local old = player.Character:FindFirstChild("KVN_InvESP")
            if old then old:Destroy() end
            if InventoryESPEnabled then CreateInventoryESP(player) end
        end
    end
end

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        wait(0.5)
        UpdateAllInventoryESP()
    end)
end)

-- Refresh inventory every 2 seconds
spawn(function()
    while true do
        wait(2)
        if InventoryESPEnabled then UpdateAllInventoryESP() end
    end
end)

-- Update ESP distances constantly
spawn(function()
    while true do
        wait(0.3)
        if ESPEnabled then
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("KVN_ESP") then
                    local esp = player.Character:FindFirstChild("KVN_ESP")
                    local nameLabel = esp and esp:FindFirstChild("TextLabel")
                    if nameLabel and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("HumanoidRootPart") then
                        local dist = (player.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                        nameLabel.Text = player.Name .. " [" .. math.floor(dist) .. "m]"
                    end
                end
            end
        end
    end
end)

-- Initial Inventory ESP load
wait(1)
UpdateAllInventoryESP()

-- KVN Watermark
local watermark = Instance.new("TextLabel")
watermark.Size = UDim2.new(0, 150, 0, 20)
watermark.Position = UDim2.new(0, 10, 1, -30)
watermark.BackgroundTransparency = 1
watermark.Text = "KVN | All Rights Reserved"
watermark.TextColor3 = Color3.fromRGB(150, 150, 150)
watermark.TextSize = 11
watermark.Font = Enum.Font.Gotham
watermark.Parent = ScreenGui

print("KVN HUB Loaded Successfully | Aimbot + ESP + Inventory Ready")
