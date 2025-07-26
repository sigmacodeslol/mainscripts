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
    key = "X",
    canuse = false,
    fn = function()
        local player = game.Players.LocalPlayer
        local starterGui = game:GetService("StarterGui")
        
        local isActive = false
        local isScriptDisabled = false
        local canToggle = true
        local steppedConnection = nil
        
        local function getCharacter()
            return player.Character or player.CharacterAdded:Wait()
        end
        
        local function showNotification(message)
            starterGui:SetCore("SendNotification", {
                Title = "Script Status",
                Text = "Phase " .. message,
                Duration = 2
            })
        end
        
        local function toggleNoClip()
            if not canToggle or isScriptDisabled or not FTF.noclip.canuse then return end
            canToggle = false
        
            isActive = not isActive
            showNotification(isActive and "Enabled!" or "Disabled!")
        
            local character = getCharacter()
            local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
        
            if isActive then
                local humanoid = character:WaitForChild("Humanoid")
                diedConnection = humanoid.Died:Connect(function()
                    isActive = false
                    showNotification("Disabled due to death!")
                end)
        
                steppedConnection = RunService.Stepped:Connect(function()
                    if isActive and character and humanoidRootPart then
                        for _, part in pairs(character:GetChildren()) do
                            if part:IsA("BasePart") then
                                part.CanCollide = false
                            end
                        end
                    end
                end)
            elseif steppedConnection then
                steppedConnection:Disconnect()
                steppedConnection = nil
            end
        
            canToggle = true
        end
        
        inputConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if gameProcessed then return end
        
            local keyCode = Enum.KeyCode[FTF.noclip.key] or Enum.KeyCode.X
            if input.KeyCode == keycode then
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftAlt) then
                    FTF.noclip.canuse = not FTF.noclip.canuse
                else
                    toggleNoClip()
                end
            end
        end)
    end
}

return FTF
