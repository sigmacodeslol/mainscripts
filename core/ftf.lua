local FTF = {}
local _loadhttpUrl = "https://raw.githubusercontent.com/sigmacodeslol/mainscripts/refs/heads/master/loadhttp.lua"
local loadhttp = loadstring(game:HttpGet(_loadhttpUrl))()("!HozDm3gFd")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

FTF.rejoin = {
    fn = function()
        local TeleportService = game:GetService("TeleportService")
        local Players = game:GetService("Players")
        local LocalPlayer = Players.LocalPlayer
        
        local function rejoinGame()
            local placeId = game.PlaceId
            local jobId = game.JobId
        
            if placeId and jobId then
                TeleportService:TeleportToPlaceInstance(placeId, jobId, LocalPlayer)
            else
                TeleportService:Teleport(placeId, LocalPlayer)
            end
        end
        rejoinGame()
    end
}

FTF.noclip = {
    enabled = false,
    called = false,
    key = "X", -- Default key as a string
    canuse = true, -- Added canuse flag
    steppedConnection = nil,
    diedConnection = nil,
    fn = function()
        local Workspace = game:GetService("Workspace")

        local function getCharacter()
            return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        end

        local function showNotification(message)
            -- Placeholder for notification (user can replace with actual notification system)
            print(message)
        end

        local function toggleNoclip()
            if not FTF.noclip.canuse then return end
            FTF.noclip.enabled = not FTF.noclip.enabled

            if FTF.noclip.enabled then
                local character = getCharacter()
                local humanoid = character:WaitForChild("Humanoid")
                local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

                -- Disable noclip on death
                FTF.noclip.diedConnection = humanoid.Died:Connect(function()
                    FTF.noclip.enabled = false
                    showNotification("Noclip disabled due to death!")
                end)

                -- Handle noclip for character parts
                FTF.noclip.steppedConnection = RunService.Stepped:Connect(function()
                    if FTF.noclip.enabled and character and humanoidRootPart then
                        for _, part in pairs(character:GetChildren()) do
                            if part:IsA("BasePart") then
                                part.CanCollide = false
                            end
                        end
                    end
                end)

                -- Toggle all workspace parts except baseplate
                for _, part in pairs(Workspace:GetDescendants()) do
                    if part:IsA("BasePart") and part.Anchored and part.Name ~= "Baseplate" then
                        part.CanCollide = false
                    end
                end
            else
                -- Re-enable collisions for workspace parts except baseplate
                for _, part in pairs(Workspace:GetDescendants()) do
                    if part:IsA("BasePart") and part.Anchored and part.Name ~= "Baseplate" then
                        part.CanCollide = true
                    end
                end

                -- Disconnect stepped connection if it exists
                if FTF.noclip.steppedConnection then
                    FTF.noclip.steppedConnection:Disconnect()
                    FTF.noclip.steppedConnection = nil
                end
                -- Disconnect died connection if it exists
                if FTF.noclip.diedConnection then
                    FTF.noclip.diedConnection:Disconnect()
                    FTF.noclip.diedConnection = nil
                end
            end
        end

        local function setup()
            local char = getCharacter()
            -- Setup character-specific connections
            if FTF.noclip.enabled then
                toggleNoclip() -- Re-apply noclip if enabled
            end
        end

        if LocalPlayer.Character then
            setup()
        end
        LocalPlayer.CharacterAdded:Connect(setup)

        -- Handle key press to toggle noclip or canuse
        UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
            if gameProcessedEvent then return end
            local keyCode = Enum.KeyCode[FTF.noclip.key] or Enum.KeyCode.X
            if input.KeyCode == keyCode then
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftAlt) or UserInputService:IsKeyDown(Enum.KeyCode.RightAlt) then
                    FTF.noclip.canuse = not FTF.noclip.canuse
                    showNotification("Noclip canuse set to: " .. tostring(FTF.noclip.canuse))
                else
                    toggleNoclip()
                end
            end
        end)
    end
}

return FTF
