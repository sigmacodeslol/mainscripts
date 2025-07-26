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
    canuse = true,
    fn = function()
        local function setNoclip(state)
            if not LocalPlayer.Character then return end
            local humanoidRootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
            if not humanoidRootPart or not humanoid then return end

            FTF.noclip.enabled = state

            for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") and part ~= humanoidRootPart then
                    part.CanCollide = not state
                end
            end
        end

        local function onInputBegan(input, gameProcessedEvent)
            if gameProcessedEvent then return end
            if input.KeyCode == Enum.KeyCode[FTF.noclip.key] then
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftAlt) or UserInputService:IsKeyDown(Enum.KeyCode.RightAlt) then
                    FTF.noclip.canuse = not FTF.noclip.canuse
                elseif FTF.noclip.canuse then
                    setNoclip(not FTF.noclip.enabled)
                end
            end
        end

        if not FTF.noclip.called then
            FTF.noclip.called = true
            UserInputService.InputBegan:Connect(onInputBegan)

            RunService.Stepped:Connect(function()
                if FTF.noclip.enabled and LocalPlayer.Character then
                    local humanoidRootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if humanoidRootPart then
                        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                            if part:IsA("BasePart") and part ~= humanoidRootPart then
                                part.CanCollide = false
                            end
                        end
                    end
                end
            end)
        end
    end
}

FTF.noclip.fn()

return FTF
