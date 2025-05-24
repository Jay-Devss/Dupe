local player = game.Players.LocalPlayer
local backpack = player:WaitForChild("Backpack")
local character = player.Character or player.CharacterAdded:Wait()

local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.ResetOnSpawn = false

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 250)
frame.Position = UDim2.new(0.5, -150, 0.5, -125)
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

local uiCorner = Instance.new("UICorner", frame)
uiCorner.CornerRadius = UDim.new(0, 12)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, -40, 0, 40)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Jay Dupe Script"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.TextXAlignment = Enum.TextXAlignment.Left

local closeButton = Instance.new("TextButton", frame)
closeButton.Size = UDim2.new(0, 40, 0, 40)
closeButton.Position = UDim2.new(1, -40, 0, 0)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Font = Enum.Font.GothamBold
closeButton.TextSize = 20
closeButton.AutoButtonColor = true
local closeCorner = Instance.new("UICorner", closeButton)
closeCorner.CornerRadius = UDim.new(1, 0)

closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

local layout = Instance.new("UIListLayout", frame)
layout.Padding = UDim.new(0, 10)
layout.FillDirection = Enum.FillDirection.Vertical
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.VerticalAlignment = Enum.VerticalAlignment.Center
layout.SortOrder = Enum.SortOrder.LayoutOrder

local function createButton(text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 50)
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 20
    btn.Text = text
    btn.AutoButtonColor = true
    btn.Parent = frame
    local corner = Instance.new("UICorner", btn)
    corner.CornerRadius = UDim.new(0, 12)
    btn.MouseButton1Click:Connect(callback)
end

createButton("Dupe Pet", function()
    local tool = character:FindFirstChildOfClass("Tool")
    if tool and tool.Name:find("Age") then
        tool.Parent = backpack
        wait()
        local base = tool.Name:gsub("%[Age %d+%]", "")
        local randomAge = math.random(1, 5)
        local clone = tool:Clone()
        clone.Name = base .. "[Age " .. randomAge .. "]"
        clone.Parent = backpack
    end
end)

createButton("Dupe Seed", function()
    local tool = character:FindFirstChildOfClass("Tool")
    if tool and tool.Name:find("Seed") then
        tool.Parent = backpack
        wait()
        local current = tonumber(tool.Name:match("%[X(%d+)%]")) or 1
        local base = tool.Name:gsub(" %[X%d+%]", "")
        local newName = base .. " [X" .. (current + 1) .. "]"
        tool.Name = newName
    end
end)

createButton("Dupe Fruit", function()
    local tool = character:FindFirstChildOfClass("Tool")
    if tool and tool.Name:find("KG") then
        tool.Parent = backpack
        wait()
        local clone = tool:Clone()
        clone.Parent = backpack
    end
end)

local resizeHandle = Instance.new("Frame", frame)
resizeHandle.Size = UDim2.new(0, 20, 0, 20)
resizeHandle.Position = UDim2.new(1, -20, 1, -20)
resizeHandle.BackgroundColor3 = Color3.fromRGB(90, 90, 90)
resizeHandle.ZIndex = 10
resizeHandle.Active = true

local resizeCorner = Instance.new("UICorner", resizeHandle)
resizeCorner.CornerRadius = UDim.new(1, 0)

local dragging = false
local lastPos

resizeHandle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        lastPos = input.Position
    end
end)

resizeHandle.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

resizeHandle.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
        local delta = input.Position - lastPos
        frame.Size = UDim2.new(0, math.max(200, frame.Size.X.Offset + delta.X), 0, math.max(150, frame.Size.Y.Offset + delta.Y))
        lastPos = input.Position
    end
end)

frame:GetPropertyChangedSignal("Size"):Connect(function()
    resizeHandle.Position = UDim2.new(1, -20, 1, -20)
end)
