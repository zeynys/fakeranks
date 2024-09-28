local playerRanks = {}
local usermessage = UserMessage("ServerRankRevealAll")
local rankType = 12

AddEventHandler("OnRankUpdate", function(event, playerid, rankIdx, rankSkillID, rankShortName, rankPoints, rankName, points)
    if rankType == 11 then
        playerRanks[playerid] = points
    else
        playerRanks[playerid] = rankSkillID
    end
end)

AddEventHandler("OnGameTick", function (event, ...)
    for playerid, data in next,playerRanks,nil do
        local player = GetPlayer(playerid)
        if player and player:IsValid() then
            local controller = player:CCSPlayerController()
            controller.CompetitiveWins = 10
            controller.CompetitiveRankType = rankType
            controller.CompetitiveRanking = data
        end
    end
end)

AddEventHandler("OnClientKeyStateChange", function(event, playerid, key, pressed)
    if key == "tab" and pressed == true then
        if usermessage:IsValidMessage() then
            usermessage:SendToPlayer(playerid)
        end
    end
    return EventResult.Continue
end)

AddEventHandler("OnPluginStart", function (event)
    config:Create("fakeranks", {
        type_node = "All the types are the following: matchmaking, wingman, premier",
        type = "matchmaking"
    })

    if config:Fetch("fakeranks.type") == "wingman" then
        rankType = 7
    elseif config:Fetch("fakeranks.type") == "premier" then
        rankType = 11
    else
        rankType = 12
    end
end)