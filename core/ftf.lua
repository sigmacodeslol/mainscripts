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
    fn = function()
        local Players = game:GetService("Players")
        local LocalPlayer = Players.LocalPlayer

        local function onTouched(part)
            if not FTF.noclip.enabled then return end
            if not part:IsA("BasePart") then return end
            if not part.Anchored then return end
            if not part.CanCollide then return end

            local character = LocalPlayer.Character
            if not character then return end

            local hrp = character:FindFirstChild("HumanoidRootPart")
            if not hrp then return end

            -- Prevent disabling floors
            if part.Position.Y < (hrp.Position.Y - hrp.Size.Y) then return end

            -- Passed all checks
            part.CanCollide = false
        end

        local function setup()
            local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
            local hrp = char:WaitForChild("HumanoidRootPart")
            hrp.Touched:Connect(onTouched)
        end

        if LocalPlayer.Character then
            setup()
        end
        LocalPlayer.CharacterAdded:Connect(setup)

        -- Handle key press to toggle noclip
        UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
            if gameProcessedEvent then return end
            local keyCode = Enum.KeyCode[FTF.noclip.key] or Enum.KeyCode.X
            if input.KeyCode == keyCode then
                FTF.noclip.enabled = not FTF.noclip.enabled
            end
        end)
    end
}

return FTF
