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
        local UserInputService = game:GetService("UserInputService")
        local RunService = game:GetService("RunService")
        local player = game.Players.LocalPlayer
        local starterGui = game:GetService("StarterGui")
        
        local isActive = false
        local isScriptDisabled = false
        local canToggle = true
        local steppedConnection = nil
        local diedConnection = nil
        local inputConnection = nil
        
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
        
            task.wait(0.5)
            canToggle = true
        end
        
        local function destroyScript()
            if isScriptDisabled then return end
            isScriptDisabled = true
            isActive = false
        
            -- Disconnect all event connections
            if steppedConnection then
                steppedConnection:Disconnect()
                steppedConnection = nil
            end
            if diedConnection then
                diedConnection:Disconnect()
                diedConnection = nil
            end
            if inputConnection then
                inputConnection:Disconnect()
                inputConnection = nil
            end
        
            -- Restore collision
            local character = getCharacter()
            for _, part in pairs(character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        
            starterGui:SetCore("SendNotification", {
                Title = "Script Stopped",
                Text = "Phase fully destroyed!",
                Duration = 2
            })
        
            -- Clear all local variables
            isActive = nil
            isScriptDisabled = nil
            canToggle = nil
        end
        
        inputConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if gameProcessed then return end
        
            local keyCode = Enum.KeyCode[FTF.noclip.key] or Enum.KeyCode.X
            if input.KeyCode == keyCode and not UserInputService:IsKeyDown(Enum.KeyCode.LeftAlt) then
                toggleNoClip()
            elseif input.KeyCode == Enum.KeyCode.X and UserInputService:IsKeyDown(Enum.KeyCode.LeftAlt) then
                FTF.noclip.canuse = not FTF.noclip.canuse
                showNotification("NoClip " .. (FTF.noclip.canuse and "usable!" or "unusable!"))
            end
        end)
    end
}

return FTF
