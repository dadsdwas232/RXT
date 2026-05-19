--[[
    Script Name: KVN Hub (Advanced AIMBOT + ESP)
    Supported Executor: Any external (Synapse X, Krnl, ScriptWare, etc.)
    Rights: K V N
--]]

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")

-- Player
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Variables
local AimlockEnabled = false
local ESPEnabled = false
local InventoryESPEnabled = false
local AimPart = "Head" -- Default: Head, Body, Random
local FriendList = {}
local Target = nil
local ESPObjects = {}
local InventoryObjects = {}

-- UI Elements
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local DragButton = Instance.new("TextButton")
local CloseButton = Instance.new("TextButton")
local OpenButton = Instance.new("TextButton")
local ContentFrame = Instance.new("Frame")

-- Buttons
local AimButton = Instance.new("TextButton")
local AimBodyButton = Instance.new("TextButton")
local AimHeadButton = Instance.new("TextButton")
local AimRandomButton = Instance.new("TextButton")
local ESPToggle = Instance.new("TextButton")
local InventoryToggle = Instance.new("TextButton")
local FriendListButton = Instance.new("TextButton")

-- UI Config
ScreenGui.Name = "KVN_Hub"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

MainFrame.Size = UDim2.new(0, 350, 0, 450)
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -225)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
MainFrame.BorderSizePixel = 0
MainFrame.BackgroundTransparency = 0.1
MainFrame.Parent = ScreenGui

-- Dragging logic
local dragging = false
local dragInput, dragStart, startPos

DragButton.Size = UDim2.new(1, 0, 0, 30)
DragButton.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
DragButton.Text = "KVN HUB [DRAG]"
DragButton.TextColor3 = Color3.fromRGB(255, 255, 255)
DragButton.Parent = MainFrame

CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -30, 0, 0)
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.Parent = MainFrame

OpenButton.Size = UDim2.new(0, 60, 0, 60)
OpenButton.Position = UDim2.new(0, 10, 0.5, -30)
OpenButton.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
OpenButton.Text = "OPEN"
OpenButton.TextColor3 = Color3.fromRGB(255, 255, 255)
OpenButton.Visible = false
OpenButton.Parent = ScreenGui

ContentFrame.Size = UDim2.new(1, 0, 1, -30)
ContentFrame.Position = UDim2.new(0, 0, 0, 30)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

-- Aim Button
AimButton.Size = UDim2.new(0, 200, 0, 40)
AimButton.Position = UDim2.new(0.5, -100, 0, 10)
AimButton.BackgroundColor3 = Color3.fromRGB(70, 70, 90)
AimButton.Text = "AIMBOT [OFF]"
AimButton.TextColor3 = Color3.fromRGB(255, 255, 255)
AimButton.Parent = ContentFrame

-- Body part selection
AimBodyButton.Size = UDim2.new(0, 100, 0, 30)
AimBodyButton.Position = UDim2.new(0, 10, 0, 60)
AimBodyButton.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
AimBodyButton.Text = "Body"
AimBodyButton.Parent = ContentFrame

AimHeadButton.Size = UDim2.new(0, 100, 0, 30)
AimHeadButton.Position = UDim2.new(0, 120, 0, 60)
AimHeadButton.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
AimHeadButton.Text = "Head"
AimHeadButton.Parent = ContentFrame

AimRandomButton.Size = UDim2.new(0, 100, 0, 30)
AimRandomButton.Position = UDim2.new(0, 230, 0, 60)
AimRandomButton.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
AimRandomButton.Text = "Random"
AimRandomButton.Parent = ContentFrame

-- ESP Toggle
ESPToggle.Size = UDim2.new(0, 200, 0, 40)
ESPToggle.Position = UDim2.new(0.5, -100, 0, 110)
ESPToggle.BackgroundColor3 = Color3.fromRGB(70, 70, 90)
ESPToggle.Text = "ESP [OFF]"
ESPToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
ESPToggle.Parent = ContentFrame

-- Inventory ESP Toggle
InventoryToggle.Size = UDim2.new(0, 200, 0, 40)
InventoryToggle.Position = UDim2.new(0.5, -100, 0, 160)
InventoryToggle.BackgroundColor3 = Color3.fromRGB(70, 70, 90)
InventoryToggle.Text = "INVENTORY ESP [OFF]"
InventoryToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
InventoryToggle.Parent = ContentFrame

-- Friend List Button
FriendListButton.Size = UDim2.new(0, 200, 0, 40)
FriendListButton.Position = UDim2.new(0.5, -100, 0, 210)
FriendListButton.BackgroundColor3 = Color3.fromRGB(70, 70, 90)
FriendListButton.Text = "FRIEND LIST (0)"
FriendListButton.TextColor3 = Color3.fromRGB(255, 255, 255)
FriendListButton.Parent = ContentFrame

-- Functions
local function UpdateAimText()
    local status = AimlockEnabled and "ON" or "OFF"
    AimButton.Text = "AIMBOT [" .. status .. "]"
end

local function UpdateESPText()
    ESPToggle.Text = ESPEnabled and "ESP [ON]" or "ESP [OFF]"
end

local function UpdateInventoryText()
    InventoryToggle.Text = InventoryESPEnabled and "INVENTORY ESP [ON]" or "INVENTORY ESP [OFF]"
end

local function IsFriend(plr)
    for _, v in pairs(FriendList) do
        if v == plr.Name then return true end
    end
    return false
end

local function GetClosestPlayer()
    local closest = nil
    local shortestDistance = 30 -- 30 meters max
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character.Humanoid.Health > 0 and not IsFriend(v) then
            local part = v.Character.HumanoidRootPart
            local pos, onScreen = Camera:WorldToScreenPoint(part.Position)
            local distance = (LocalPlayer.Character.HumanoidRootPart.Position - part.Position).Magnitude
            if distance <= shortestDistance then
                local screenPos, onScreen = Camera:WorldToScreenPoint(part.Position)
                if onScreen then
                    shortestDistance = distance
                    closest = v
                end
            end
        end
    end
    return closest
end

local function GetAimPart(character)
    if AimPart == "Head" then
        return character:FindFirstChild("Head")
    elseif AimPart == "Body" then
        return character:FindFirstChild("UpperTorso") or character:FindFirstChild("HumanoidRootPart")
    elseif AimPart == "Random" then
        local parts = {"Head", "UpperTorso", "LowerTorso", "HumanoidRootPart"}
        local chosen = parts[math.random(1, #parts)]
        return character:FindFirstChild(chosen)
    end
    return character:FindFirstChild("Head")
end

-- AIMBOT Logic
RunService.RenderStepped:Connect(function()
    if AimlockEnabled and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local targetPlayer = GetClosestPlayer()
        if targetPlayer and targetPlayer.Character then
            local aimPart = GetAimPart(targetPlayer.Character)
            if aimPart then
                local screenPos, onScreen = Camera:WorldToScreenPoint(aimPart.Position)
                if onScreen then
                    mousemoveabs(screenPos.X, screenPos.Y)
                end
            end
        end
    end
end)

-- ESP Drawing
local function CreateESP(player)
    if ESPObjects[player] then return end
    local billboard = Instance.new("BillboardGui")
    local textLabel = Instance.new("TextLabel")
    
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.AlwaysOnTop = true
    billboard.StudsOffset = Vector3.new(0, 2.5, 0)
    billboard.Parent = player.Character
    
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = player.Name .. "\n" .. (player.Character and player.Character:FindFirstChild("Humanoid") and math.floor(player.Character.Humanoid.Health) or "Dead")
    textLabel.TextColor3 = IsFriend(player) and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    textLabel.TextStrokeTransparency = 0.5
    textLabel.TextScaled = true
    textLabel.Parent = billboard
    
    ESPObjects[player] = billboard
end

local function RemoveESP(player)
    if ESPObjects[player] then
        ESPObjects[player]:Destroy()
        ESPObjects[player] = nil
    end
end

local function UpdateESP()
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character.Humanoid.Health > 0 then
            if ESPEnabled then
                CreateESP(v)
            else
                RemoveESP(v)
            end
        else
            RemoveESP(v)
        end
    end
end

-- Inventory ESP
local function GetInventoryItems(player)
    local items = {}
    if player.Backpack then
        for _, item in pairs(player.Backpack:GetChildren()) do
            table.insert(items, item.Name)
        end
    end
    if player.Character then
        for _, item in pairs(player.Character:GetChildren()) do
            if item:IsA("Tool") then
                table.insert(items, item.Name)
            end
        end
    end
    return items
end

local function CreateInventoryESP(player)
    if InventoryObjects[player] then return end
    local billboard = Instance.new("BillboardGui")
    local textLabel = Instance.new("TextLabel")
    
    billboard.Size = UDim2.new(0, 300, 0, 100)
    billboard.AlwaysOnTop = true
    billboard.StudsOffset = Vector3.new(0, 3.5, 0)
    billboard.Parent = player.Character
    
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = "Items: " .. table.concat(GetInventoryItems(player), ", ")
    textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    textLabel.TextScaled = true
    textLabel.TextWrapped = true
    textLabel.Parent = billboard
    
    InventoryObjects[player] = billboard
end

local function RemoveInventoryESP(player)
    if InventoryObjects[player] then
        InventoryObjects[player]:Destroy()
        InventoryObjects[player] = nil
    end
end

local function UpdateInventoryESP()
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character.Humanoid.Health > 0 then
            if InventoryESPEnabled then
                CreateInventoryESP(v)
                -- Update text every 2 seconds
                if not v.InventoryUpdater then
                    v.InventoryUpdater = true
                    spawn(function()
                        while InventoryESPEnabled and v and v.Character do
                            wait(2)
                            if InventoryObjects[v] and InventoryObjects[v]:FindFirstChild("TextLabel") then
                                InventoryObjects[v].TextLabel.Text = "Items: " .. table.concat(GetInventoryItems(v), ", ")
                            end
                        end
                    end)
                end
            else
                RemoveInventoryESP(v)
                v.InventoryUpdater = nil
            end
        else
            RemoveInventoryESP(v)
        end
    end
end

-- Loop for ESP updates
spawn(function()
    while wait(0.3) do
        UpdateESP()
        UpdateInventoryESP()
    end
end)

-- Friend List GUI
local function ShowFriendList()
    local friendFrame = Instance.new("Frame")
    local friendListBox = Instance.new("ScrollingFrame")
    local addButton = Instance.new("TextButton")
    local inputBox = Instance.new("TextBox")
    
    friendFrame.Size = UDim2.new(0, 300, 0, 400)
    friendFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
    friendFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    friendFrame.BorderSizePixel = 0
    friendFrame.Parent = ScreenGui
    
    friendListBox.Size = UDim2.new(1, -20, 1, -100)
    friendListBox.Position = UDim2.new(0, 10, 0, 40)
    friendListBox.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
    friendListBox.Parent = friendFrame
    
    addButton.Size = UDim2.new(0, 100, 0, 30)
    addButton.Position = UDim2.new(0, 10, 1, -40)
    addButton.Text = "Add Friend"
    addButton.Parent = friendFrame
    
    inputBox.Size = UDim2.new(0, 150, 0, 30)
    inputBox.Position = UDim2.new(0, 120, 1, -40)
    inputBox.PlaceholderText = "Player Name"
    inputBox.Parent = friendFrame
    
    local function RefreshFriendList()
        for _, v in pairs(friendListBox:GetChildren()) do
            if v:IsA("TextButton") then v:Destroy() end
        end
        local y = 0
        for _, name in pairs(FriendList) do
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 0, 30)
            btn.Position = UDim2.new(0, 0, 0, y)
            btn.Text = name .. " [REMOVE]"
            btn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
            btn.Parent = friendListBox
            btn.MouseButton1Click:Connect(function()
                for i, v in pairs(FriendList) do
                    if v == name then
                        table.remove(FriendList, i)
                        break
                    end
                end
                RefreshFriendList()
                FriendListButton.Text = "FRIEND LIST (" .. #FriendList .. ")"
            end)
            y = y + 35
        end
        FriendListButton.Text = "FRIEND LIST (" .. #FriendList .. ")"
    end
    
    addButton.MouseButton1Click:Connect(function()
        if inputBox.Text ~= "" then
            table.insert(FriendList, inputBox.Text)
            RefreshFriendList()
            inputBox.Text = ""
        end
    end)
    
    RefreshFriendList()
    
    friendFrame.ChildRemoved:Connect(function()
        RefreshFriendList()
    end)
    
    -- Close friend frame after 30 sec or manually
    wait(30)
    friendFrame:Destroy()
end

-- Button Events
AimButton.MouseButton1Click:Connect(function()
    AimlockEnabled = not AimlockEnabled
    UpdateAimText()
end)

AimBodyButton.MouseButton1Click:Connect(function()
    AimPart = "Body"
end)

AimHeadButton.MouseButton1Click:Connect(function()
    AimPart = "Head"
end)

AimRandomButton.MouseButton1Click:Connect(function()
    AimPart = "Random"
end)

ESPToggle.MouseButton1Click:Connect(function()
    ESPEnabled = not ESPEnabled
    UpdateESPText()
end)

InventoryToggle.MouseButton1Click:Connect(function()
    InventoryESPEnabled = not InventoryESPEnabled
    UpdateInventoryText()
end)

FriendListButton.MouseButton1Click:Connect(function()
    ShowFriendList()
end)

CloseButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    OpenButton.Visible = true
end)

OpenButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    OpenButton.Visible = false
end)

-- Dragging
DragButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Initial updates
UpdateAimText()
UpdateESPText()
UpdateInventoryText()
