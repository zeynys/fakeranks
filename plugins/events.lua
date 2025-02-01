local playerRanks = {}
local usermessage = {}
local rankType = 12

AddEventHandler("OnRankUpdate", function(event, playerid, rankIdx, rankSkillID, rankShortName, rankPoints, rankName, points)
    if rankType == 11 then
        playerRanks[playerid] = points
        ranks:GetRankPoints(playerid, points)
    else
        playerRanks[playerid] = rankSkillID
        ranks:GetRankSkillID(playerid, rankSkillID)
    end
end)

function CalculateRankByPoints(points)
    for i = #Ranks, 1, -1 do
        if points >= Ranks[i][3] then
            return i
        end
    end
    return 1
end

AddEventHandler("OnPlayerSpawn", function (event)
    local playerid = event:GetInt("userid")
    local player = GetPlayer(playerid)
    if not player or not player:IsValid() then return end

   NextTick(function ()
        local points = exports["ranks"]:FetchPoints(playerid)
        ranks:GetRankPoints(playerid, points)
        local rank = CalculateRankByPoints(points)
        ranks:GetRankSkillID(playerid, Ranks[rank][1]) 
   end)
end)

AddEventHandler("OnClientKeyStateChange", function(event, playerid, key, pressed)
    if key == "tab" and pressed == true then
        if usermessage:IsValidMessage() then
            print("calling")
            usermessage:SendToPlayer(playerid)
        end
    end
    return EventResult.Continue
end)

AddEventHandler("OnMapLoad", function (event)
    usermessage = UserMessage("ServerRankRevealAll")
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

    Ranks = {
        { 0,  "Unranked", config:Fetch("ranks.ranks.Unranked"), "Unranked" },
        { 1,  "Silver1",  config:Fetch("ranks.ranks.Silver1"),  "Silver I" },
        { 2,  "Silver2",  config:Fetch("ranks.ranks.Silver2"),  "Silver II" },
        { 3,  "Silver3",  config:Fetch("ranks.ranks.Silver3"),  "Silver III" },
        { 4,  "Silver4",  config:Fetch("ranks.ranks.Silver4"),  "Silver IV" },
        { 5,  "Silver5",  config:Fetch("ranks.ranks.Silver5"),  "Silver Elite" },
        { 6,  "SEM",      config:Fetch("ranks.ranks.SEM"),      "Silver Elite Master" },
        { 7,  "GN1",      config:Fetch("ranks.ranks.GN1"),      "Gold Nova I" },
        { 8,  "GN2",      config:Fetch("ranks.ranks.GN2"),      "Gold Nova II" },
        { 9,  "GN3",      config:Fetch("ranks.ranks.GN3"),      "Gold Nova III" },
        { 10, "GN4",      config:Fetch("ranks.ranks.GN4"),      "Gold Nova Master" },
        { 11, "MG1",      config:Fetch("ranks.ranks.MG1"),      "Master Guardian I" },
        { 12, "MG2",      config:Fetch("ranks.ranks.MG2"),      "Master Guardian II" },
        { 13, "MGE",      config:Fetch("ranks.ranks.MGE"),      "Master Guardian Elite" },
        { 14, "DMG",      config:Fetch("ranks.ranks.DMG"),      "Distinguished Master Guardian" },
        { 15, "LE",       config:Fetch("ranks.ranks.LE"),       "Legendary Eagle" },
        { 16, "LEM",      config:Fetch("ranks.ranks.LEM"),      "Legendary Eagle Master" },
        { 17, "SMFC",     config:Fetch("ranks.ranks.SMFC"),     "Supreme" },
        { 18, "Global",   config:Fetch("ranks.ranks.Global"),   "Global Elite" }
    }

end)