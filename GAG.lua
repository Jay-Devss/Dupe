local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Backpack = LocalPlayer:WaitForChild("Backpack")
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

-- GUI Setup
local screenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
screenGui.Name = "JayDupeGui"
screenGui.ResetOnSpawn = false

local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 250, 0, 200)
frame.Position = UDim2.new(0, 20, 0, 20)
frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
frame.BorderSizePixel = 0
frame.BackgroundTransparency = 0.1
frame.Name = "MainFrame"
frame.Active = true
frame.Draggable = true

local uiCorner = Instance.new("UICorner", frame)
uiCorner.CornerRadius = UDim.new(0, 10)

-- Title Label
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, -40, 0, 25)
title.Position = UDim2.new(0, 10, 0, 5)
title.Text = "Jay Dupe Script"
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundTransparency = 1
title.Font = Enum.Font.SourceSansBold
title.TextSize = 18
title.TextXAlignment = Enum.TextXAlignment.Left

-- Close Button
local closeBtn = Instance.new("TextButton", frame)
closeBtn.Size = UDim2.new(0, 25, 0, 25)
closeBtn.Position = UDim2.new(1, -30, 0, 5)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(1, 0)

closeBtn.MouseButton1Click:Connect(function()
	screenGui:Destroy()
end)

-- Function to create styled buttons
local function createButton(name, yPos, callback)
	local button = Instance.new("TextButton", frame)
	button.Size = UDim2.new(0.9, 0, 0, 35)
	button.Position = UDim2.new(0.05, 0, 0, yPos)
	button.Text = name
	button.TextColor3 = Color3.new(1, 1, 1)
	button.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
	button.Font = Enum.Font.SourceSans
	button.TextSize = 16
	Instance.new("UICorner", button).CornerRadius = UDim.new(0, 8)
	button.MouseButton1Click:Connect(callback)
end

-- Duplication Logic
createButton("Dupe Pet", 40, function()
	local tool = Character:FindFirstChildOfClass("Tool")
	if tool then
		tool.Parent = Backpack
		wait()
		local newTool = tool:Clone()
		local newAge = math.random(1, 5)
		newTool.Name = newTool.Name:gsub("Age %d+", "Age " .. newAge)
		newTool.Parent = Backpack
	end
end)

createButton("Dupe Seed", 85, function()
	local tool = Character:FindFirstChildOfClass("Tool")
	if tool and tool.Name:find("Seed") then
		tool.Parent = Backpack
		wait()

		local baseName, count = tool.Name:match("^(.-)%s%[X(%d+)%]$")
		if baseName and count then
			local newCount = tonumber(count) + 1
			tool.Name = baseName .. " [X" .. newCount .. "]"
		else
			tool.Name = tool.Name .. " [X2]"
		end
	end
end)

createButton("Dupe Fruit", 130, function()
	local tool = Character:FindFirstChildOfClass("Tool")
	if tool then
		tool.Parent = Backpack
		wait()
		local newTool = tool:Clone()
		newTool.Parent = Backpack
	end
end)

-- Resize Handle
local resizeHandle = Instance.new("Frame", frame)
resizeHandle.Size = UDim2.new(0, 20, 0, 20)
resizeHandle.Position = UDim2.new(1, -20, 1, -20)
resizeHandle.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
resizeHandle.BorderSizePixel = 0
resizeHandle.Active = true
resizeHandle.Draggable = false

local resizing = false

resizeHandle.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		resizing = true
	end
end)

resizeHandle.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		resizing = false
	end
end)

resizeHandle.InputChanged:Connect(function(input)
	if resizing and input.UserInputType == Enum.UserInputType.MouseMovement then
		local mouse = game:GetService("UserInputService"):GetMouseLocation()
		local newWidth = math.clamp(mouse.X - frame.AbsolutePosition.X, 150, 600)
		local newHeight = math.clamp(mouse.Y - frame.AbsolutePosition.Y, 100, 400)
		frame.Size = UDim2.new(0, newWidth, 0, newHeight)
	end
end)
