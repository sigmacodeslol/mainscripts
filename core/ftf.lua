local FTF = {}
local _loadhttpUrl = "https://raw.githubusercontent.com/sigmacodeslol/mainscripts/refs/heads/master/loadhttp.lua"
local loadhttp = loadstring(game:HttpGet(_loadhttpUrl))()("!HozDm3gFd")
local UserInputService = game:GetService("UserInputService")

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
    fn = function()
        local Players = game:GetService("Players")
        local LocalPlayer = Players.LocalPlayer
        local Workspace = game:GetService("Workspace")

        local function toggleNoclip()
            if not FTF.noclip.canuse then return end
            FTF.noclip.enabled = not FTF.noclip.enabled
            
            -- Get all parts in Workspace
            for _, part in pairs(Workspace:GetDescendants()) do
                if part:IsA("BasePart") and part.Anchored then
                    part.CanCollide = not FTF.noclip.enabled
                end
            end
        end

        local function setup()
            local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
            -- No need for Touched connection since we're toggling all parts
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
                else
                    toggleNoclip()
                end
            end
        end)
    end
}

return FTF
