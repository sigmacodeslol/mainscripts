local TeleportService = game:GetService("TeleportService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

-- Configuration
local MAX_WAIT_TIME = 30 -- Maximum wait time in seconds
local CHECK_INTERVAL = 0.1 -- Interval to check if game is loaded
local RETRY_ATTEMPTS = 3 -- Number of teleport retry attempts

-- Function to display notification to the player
local function notifyPlayer(message)
    local player = Players.LocalPlayer
    if player then
        local playerGui = player:WaitForChild("PlayerGui")
        local screenGui = Instance.new("ScreenGui")
        screenGui.Parent = playerGui
        
        local textLabel = Instance.new("TextLabel")
        textLabel.Size = UDim2.new(0, 200, 0, 50)
        textLabel.Position = UDim2.new(0.5, -100, 0.5, -25)
        textLabel.Text = message
        textLabel.TextScaled = true
        textLabel.BackgroundTransparency = 0.5
        textLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        textLabel.Parent = screenGui
        
        -- Remove notification after 5 seconds
        task.spawn(function()
            task.wait(5)
            screenGui:Destroy()
        end)
    end
end

-- Function to wait for game to load with timeout
local function waitForGameLoaded(timeout)
    local elapsed = 0
    while not game:IsLoaded() and elapsed < timeout do
        elapsed = elapsed + CHECK_INTERVAL
        task.wait(CHECK_INTERVAL)
    end
    
    if not game:IsLoaded() then
        notifyPlayer("Failed to load game in time")
        return false
    end
    return true
end

-- Function to attempt teleport with retries
local function attemptTeleport(placeId, jobId, maxRetries)
    for attempt = 1, maxRetries do
        local success, result = pcall(function()
            TeleportService:TeleportToPlaceInstance(placeId, jobId)
        end)
        
        if success then
            return true
        elseif attempt == maxRetries then
            notifyPlayer("All teleport attempts failed")
            return false
        else
            task.wait(1) -- Wait before retrying
        end
    end
    return false
end

-- Main execution
local function main()
    if not waitForGameLoaded(MAX_WAIT_TIME) then
        return
    end
    
    attemptTeleport(game.PlaceId, game.JobId, RETRY_ATTEMPTS)
end

-- Run with error handling
local success, errorMessage = pcall(main)
if not success then
    notifyPlayer("Teleport script failed")
end
