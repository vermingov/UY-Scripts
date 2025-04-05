-- Function to find BOX1 in the Map folder inside workspace
local function findBOX1()
    local map = workspace:FindFirstChild("Map")
    if not map then
        warn("Map folder not found in workspace")
        return nil
    end
    
    local box = map:FindFirstChild("BOX1")
    if box then
        return box
    else
        warn("BOX1 not found in Map folder")
        return nil
    end
end

-- Function to find the ClickDetector in BOX1
local function findClickDetector(box)
    if not box then return nil end
    
    local clickDetector = box:FindFirstChild("ClickDetector")
    if clickDetector and clickDetector:IsA("ClickDetector") then
        return clickDetector
    else
        -- Search for ClickDetector in children
        for _, child in pairs(box:GetChildren()) do
            if child:IsA("ClickDetector") then
                return child
            end
        end
        warn("ClickDetector not found in BOX1")
        return nil
    end
end

-- Function to teleport the player to a specific location
local function teleportPlayer()
    local player = game.Players.LocalPlayer
    if player and player.Character then
        local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
        if humanoidRootPart then
            humanoidRootPart.CFrame = CFrame.new(-137.06, 6.63, 176.09)
        end
    end
end

-- Function to equip the Box tool from the player's backpack or inventory
local function equipBoxTool()
    local player = game.Players.LocalPlayer
    if not player then return end
    
    -- Check if the Box tool is already equipped
    if player.Character then
        local boxTool = player.Character:FindFirstChild("Box")
        if boxTool and boxTool:IsA("Tool") then
            return -- Already equipped
        end
    end
    
    -- Try to find the Box tool in the backpack
    if player.Backpack then
        local boxTool = player.Backpack:FindFirstChild("Box")
        if boxTool and boxTool:IsA("Tool") then
            -- Equip the tool
            if player.Character then
                boxTool.Parent = player.Character
            end
        end
    end
end

-- Function to remove cash using ATMHandler
local function removeCash()
    local args = {
        [1] = "RemoveCash",
        [2] = 75
    }
    
    game:GetService("ReplicatedStorage"):WaitForChild("ATMHandler"):FireServer(unpack(args))
end

-- Variable to track if the script is running
local isRunning = false

-- Cache references to improve performance
local box = findBOX1()
local clickDetector = findClickDetector(box)

-- Main loop to click the detector, teleport, equip the Box tool, and remove cash
local function clickLoop()
    if not clickDetector then
        print("Could not find the ClickDetector to click")
        return
    end
    
    -- Create a faster loop without using wait()
    local lastTime = tick()
    local interval = 0.05 -- Reduced interval for faster clicking
    
    while isRunning do
        local currentTime = tick()
        if currentTime - lastTime >= interval then
            equipBoxTool()
            fireclickdetector(clickDetector)
            teleportPlayer()
            removeCash() -- Call the function to remove cash
            lastTime = currentTime
        end
        game:GetService("RunService").Heartbeat:Wait() -- More efficient than wait()
    end
end
local userInputService = game:GetService("UserInputService")
userInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.F4 then
        isRunning = not isRunning
        if isRunning then
            print("Auto-click, teleport, tool equip, and cash removal enabled")
            task.spawn(clickLoop) -- Use task.spawn instead of direct call for better performance
        else
            print("Auto-click, teleport, tool equip, and cash removal disabled")
        end
    end
end)
print("Press F4 to toggle auto-click, teleport, tool equip, and cash removal")
