local FTF = {}
local _loadhttpUrl = "https://raw.githubusercontent.com/sigmacodeslol/mainscripts/refs/heads/master/loadhttp.lua"
local loadhttp = loadstring(game:HttpGet(_loadhttpUrl))()("!HozDm3gFd")

function FTF:rejoin()
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
end

return FTF
