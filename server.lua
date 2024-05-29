local QBCore = exports['qb-core']:GetCoreObject()

-- Functions
local function UpdateBlips()
    local dutyPlayers = {}
    local players = QBCore.Functions.GetQBPlayers()
    for _, v in pairs(players) do
        if v and v.PlayerData.job.onduty then
            local coords = GetEntityCoords(GetPlayerPed(v.PlayerData.source))
            local heading = GetEntityHeading(GetPlayerPed(v.PlayerData.source))
            dutyPlayers[#dutyPlayers + 1] = {
                source = v.PlayerData.source,
                label = v.PlayerData.charinfo.firstname .. ' ' .. v.PlayerData.charinfo.lastname,
                job = v.PlayerData.job,
                location = {
                    x = coords.x,
                    y = coords.y,
                    z = coords.z,
                    w = heading
                }
            }
        end
    end
    TriggerClientEvent('jobblips:client:UpdateBlips', -1, dutyPlayers)
end


CreateThread(function()
    Wait(20000)
    while true do
        Wait(5000)
        UpdateBlips()
    end
end)
