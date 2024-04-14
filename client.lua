QBCore = exports['qb-core']:GetCoreObject()

PlayerJob = {}
local DutyBlips = {}

-- Functions
local function CreateDutyBlips(playerId, playerLabel, playerLocation)
    local ped = GetPlayerPed(playerId)
    if playerId ~= PlayerId() then
        local blip = GetBlipFromEntity(ped)
        if not DoesBlipExist(blip) then
            if NetworkIsPlayerActive(playerId) then
                blip = AddBlipForEntity(ped)
            else
                blip = AddBlipForCoord(playerLocation.x, playerLocation.y, playerLocation.z)
            end
            SetBlipSprite(blip, 1)
            ShowHeadingIndicatorOnBlip(blip, true)
            SetBlipRotation(blip, math.ceil(playerLocation.w))
            SetBlipScale(blip, 1.0)
            SetBlipColour(blip, 5)
            SetBlipCategory(blip, 7)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName('STRING')
            AddTextComponentSubstringPlayerName(playerLabel)
            EndTextCommandSetBlipName(blip)
            DutyBlips[#DutyBlips + 1] = blip
        end
    end
end

RegisterNetEvent('jobblips:client:UpdateBlips', function(players)
    if PlayerJob and PlayerJob.onduty then
        if DutyBlips then
            for _, v in pairs(DutyBlips) do
                RemoveBlip(v)
            end
        end
        DutyBlips = {}
        if PlayerJob.name ~= 'unemployed' then
            if players then
                for _, data in pairs(players) do
                    if PlayerJob.name == data.job then
                        local id = GetPlayerFromServerId(data.source)
                        CreateDutyBlips(id, data.label, data.location)
                    end
                end
            end
        end
    end
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(JobInfo)
    AddTextEntry('BLIP_OTHPLYR', PlayerJob.label)
    if DutyBlips then
        for _, v in pairs(DutyBlips) do
            RemoveBlip(v)
        end
    end
    DutyBlips = {}
    PlayerJob = JobInfo
end)

AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        local player = QBCore.Functions.GetPlayerData()
        PlayerJob = player.job
    end
end)

AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    local player = QBCore.Functions.GetPlayerData()
    PlayerJob = player.job
    TriggerServerEvent('jobblips:server:UpdateBlips')
    AddTextEntry('BLIP_OTHPLYR', PlayerJob.label)
    if DutyBlips then
        for _, v in pairs(DutyBlips) do
            RemoveBlip(v)
        end
    end
    DutyBlips = {}
end)

RegisterNetEvent('QBCore:Client:SetDuty', function(newDuty)
    PlayerJob.onduty = newDuty
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    PlayerJob = {}
    if DutyBlips then
        for _, v in pairs(DutyBlips) do
            RemoveBlip(v)
        end
        DutyBlips = {}
    end
end)

CreateThread(function()
    Caffe = AddBlipForCoord(288.27, -920.12, 29.47)
    SetBlipSprite (Caffe, 214)
    SetBlipDisplay(Caffe, 4)
    SetBlipScale  (Caffe, 0.5)
    SetBlipAsShortRange(Caffe, true)
    SetBlipColour(Caffe, 75)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName("Sen_itiCafe")
    EndTextCommandSetBlipName(Caffe)
end) 