local QBCore = exports['qb-core']:GetCoreObject()
local inWatch = false

-- steps is the last amount of steps since saving
local m_steps = 0

-- count is the steps measured since last save
local m_count = 0
-- the next time in ticks it should save
local m_nextSave

-- Functions

local function openWatch()
    SendNUIMessage({
        action = "openWatch",
        stepData = getSteps(),
        watchData = {}
    })
    SetNuiFocus(true, true)
    inWatch = true
end

local function closeWatch()
    SetNuiFocus(false, false)
end

local function round(num, numDecimalPlaces)
    local mult = 10^(numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end

-- Events
-- dIRECTION dATA
CreateThread(function()
    while true do
        -- update DIRECTION every 500ms
        Wait(500)
        local blip = GetFirstBlipInfoId(8)
        local blipX = 0.0
        local blipY = 0.0
        local pp=GetVehiclePedIsUsing(PlayerPedId())
        if blip ~= 0 then
            local coord = GetBlipCoords(GetFirstBlipInfoId(8))
            if pp ~= 0 then
                local chk,dir,_,dist = GenerateDirectionsToCoord(coord.x,coord.y,coord.z, true) 
                SendNUIMessage({
                    action = "directionData",
                    direction = dir,
                    distance = dist
                })
            else
                local dist = (#(GetEntityCoords(PlayerPedId()) - GetBlipCoords(GetFirstBlipInfoId(8))))
                SendNUIMessage({
                    action = "directionData",
                    direction = "onFoot",
                    distance = dist
                })
            end

        else
            SendNUIMessage({
                action = "directionData",
                direction = "noblip",
                distance = "noblip"
            }) 
        end
    end
end)
-- STAPPEN TELLER 2.0 

CreateThread(function()
    -- retrieve old steps count from kvp
    m_steps = GetResourceKvpFloat("stappenteller_steps")
    reset()

    while true do
        -- update step count every 500ms
    Wait(500)
        
    local _, walkDist = StatGetFloat(`mp0_dist_walking`)
    local _, runDist  = StatGetFloat(`mp0_dist_running`)
    local distance = walkDist + runDist
    SendNUIMessage({
        action = "stepsData",
        steps = m_steps,
    })
        -- meters to steps
    m_count = distance * 1.31233595800525

    if GetGameTimer() > m_nextSave then
        saveSteps()
    end
    end
end)

-- reset resets the local gta dist stats used for counting
function reset()
    StatSetFloat(`mp0_dist_walking`, 0.0, true)
    StatSetFloat(`mp0_dist_running`, 0.0, true)

    -- save every 20 seconds
    m_nextSave = GetGameTimer() + 20000
end

-- getSteps gets the amount of steps
function getSteps()
    return math.floor(m_steps + m_count)
end

-- saveSteps saves the amount of steps to KVP and stappenteller 2.0
function saveSteps()
    m_steps = getSteps()
    m_count = 0
    reset()
    SetResourceKvpFloat("stappenteller_steps", m_steps) -- Indra was here
end

RegisterNUICallback('close', function()
    closeWatch()
end)

RegisterNetEvent('qb-fitbit:use', function()
  openWatch()
end)

-- NUI Callbacks

RegisterNUICallback('setFoodWarning', function(data)
    local foodValue = tonumber(data.value)

    TriggerServerEvent('qb-fitbit:server:setValue', 'food', foodValue)

    QBCore.Functions.Notify('Fitbit: Hunger warning set to '..foodValue..'%')
end)

RegisterNUICallback('setThirstWarning', function(data)
    local thirstValue = tonumber(data.value)

    TriggerServerEvent('qb-fitbit:server:setValue', 'thirst', thirstValue)

    QBCore.Functions.Notify('Fitbit: Thirst warning set to '..thirstValue..'%')
end)


RegisterNUICallback('setStepCount', function(data)

    QBCore.Functions.Notify('Fitbit: Step counter reset!')
    StatSetFloat(`mp0_dist_walking`, 0.0, true)
    StatSetFloat(`mp0_dist_running`, 0.0, true)
    m_steps = 0
    SetResourceKvpFloat("stappenteller_steps", data.value) -- Ojow zoveel stappen heb je gemaakt.
end)



-- Threads

CreateThread(function()
    while true do
        Wait(5 * 60 * 1000)
        if LocalPlayer.state.isLoggedIn then
            QBCore.Functions.TriggerCallback('qb-fitbit:server:HasFitbit', function(hasItem)
                if hasItem then
                    local PlayerData = QBCore.Functions.GetPlayerData()
                    if PlayerData.metadata["fitbit"].food ~= nil then
                        if PlayerData.metadata["hunger"] < PlayerData.metadata["fitbit"].food then
                            TriggerEvent("chatMessage", "FITBIT ", "warning", "Your hunger is "..round(PlayerData.metadata["hunger"], 2).."%")
                            PlaySound(-1, "Event_Start_Text", "GTAO_FM_Events_Soundset", 0, 0, 1)
                        end
                    end
                    if PlayerData.metadata["fitbit"].thirst ~= nil then
                        if PlayerData.metadata["thirst"] < PlayerData.metadata["fitbit"].thirst  then
                            TriggerEvent("chatMessage", "FITBIT ", "warning", "Your thirst is "..round(PlayerData.metadata["thirst"], 2).."%")
                            PlaySound(-1, "Event_Start_Text", "GTAO_FM_Events_Soundset", 0, 0, 1)
                        end
                    end
                end
            end, "fitbit")
        end
    end
end)
