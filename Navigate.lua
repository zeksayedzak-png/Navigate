--[[
    Mobile Teleport Pro - Black Edition
    تطوير: Assistant AI
]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

-- متغيرات لتخزين الشخصية والموقع
local character = player.Character or player.CharacterAdded:Wait()
local savedPosition = nil

-- تحديث الشخصية تلقائياً عند الموت أو إعادة التحميل
player.CharacterAdded:Connect(function(newChar)
    character = newChar
end)

-- 1. إنشاء الشاشة (تأكد أنها لن تختفي عند الموت)
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ProMobileGui"
screenGui.ResetOnSpawn = false -- هذا السطر يمنع السكريبت من الاختفاء عند الموت
screenGui.Parent = player:WaitForChild("PlayerGui")

-- 2. الإطار الرئيسي (أسود وصغير)
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 160, 0, 150) -- حجم صغير ومناسب
mainFrame.Position = UDim2.new(0.5, -80, 0.4, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20) -- أسود غامق
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true -- تفعيل السحب البسيط (يعمل جيداً على Delta)
mainFrame.Parent = screenGui

-- إضافة حواف دائرية للإطار
local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = mainFrame

-- إضافة ظل خفيف (UIStroke)
local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(60, 60, 60)
mainStroke.Thickness = 1.5
mainStroke.Parent = mainFrame

-- عنوان صغير
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "TELEPORT UI"
title.TextColor3 = Color3.fromRGB(200, 200, 200)
title.Font = Enum.Font.GothamBold
title.TextSize = 12
title.Parent = mainFrame

-- 3. زر الحفظ (أخضر)
local saveBtn = Instance.new("TextButton")
saveBtn.Name = "SaveBtn"
saveBtn.Text = "SAVE POSITION"
saveBtn.Size = UDim2.new(0.85, 0, 0, 35)
saveBtn.Position = UDim2.new(0.075, 0, 0.25, 0)
saveBtn.BackgroundColor3 = Color3.fromRGB(46, 204, 113) -- أخضر زمردي
saveBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
saveBtn.Font = Enum.Font.GothamBold
saveBtn.TextSize = 12
saveBtn.Parent = mainFrame

local saveCorner = Instance.new("UICorner")
saveCorner.CornerRadius = UDim.new(0, 8)
saveCorner.Parent = saveBtn

-- 4. زر النقل (برتقالي)
local tpBtn = Instance.new("TextButton")
tpBtn.Name = "TpBtn"
tpBtn.Text = "TELEPORT"
tpBtn.Size = UDim2.new(0.85, 0, 0, 35)
tpBtn.Position = UDim2.new(0.075, 0, 0.55, 0)
tpBtn.BackgroundColor3 = Color3.fromRGB(230, 126, 34) -- برتقالي
tpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
tpBtn.Font = Enum.Font.GothamBold
tpBtn.TextSize = 12
tpBtn.Parent = mainFrame

local tpCorner = Instance.new("UICorner")
tpCorner.CornerRadius = UDim.new(0, 8)
tpCorner.Parent = tpBtn

-- 5. حالة النص
local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, 0, 0, 20)
status.Position = UDim2.new(0, 0, 0.85, 0)
status.BackgroundTransparency = 1
status.Text = "Ready"
status.TextColor3 = Color3.fromRGB(150, 150, 150)
status.Font = Enum.Font.Gotham
status.TextSize = 10
status.Parent = mainFrame

-- 6. زر الإغلاق (X)
local close = Instance.new("TextButton")
close.Size = UDim2.new(0, 20, 0, 20)
close.Position = UDim2.new(1, -25, 0, 5)
close.BackgroundTransparency = 1
close.Text = "✕"
close.TextColor3 = Color3.fromRGB(255, 100, 100)
close.TextSize = 16
close.Parent = mainFrame

-- البرمجة الوظيفية
saveBtn.MouseButton1Click:Connect(function()
    if character and character:FindFirstChild("HumanoidRootPart") then
        savedPosition = character.HumanoidRootPart.Position
        status.Text = "Location Saved!"
        status.TextColor3 = Color3.fromRGB(46, 204, 113)
        wait(1)
        status.Text = "Ready"
        status.TextColor3 = Color3.fromRGB(150, 150, 150)
    end
end)

tpBtn.MouseButton1Click:Connect(function()
    if savedPosition then
        if character and character:FindFirstChild("HumanoidRootPart") then
            character:PivotTo(CFrame.new(savedPosition + Vector3.new(0, 2, 0)))
            status.Text = "Teleported!"
            status.TextColor3 = Color3.fromRGB(230, 126, 34)
            wait(1)
            status.Text = "Ready"
            status.TextColor3 = Color3.fromRGB(150, 150, 150)
        end
    else
        status.Text = "No Position Saved!"
        status.TextColor3 = Color3.fromRGB(255, 100, 100)
    end
end)

close.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- دعم السحب للهاتف بشكل سلس
local dragging
local dragInput
local dragStart
local startPos

local function update(input)
    local delta = input.Position - dragStart
    mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

mainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)
