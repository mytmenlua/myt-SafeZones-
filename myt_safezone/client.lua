local function sendNotification(title, description, notifType)
    if Config.notify == 'ox' then
        exports.ox_lib:notify({
            title = title,
            description = description,
            type = notifType
        })
    elseif Config.notify == 'okok' then
        exports['okokNotify']:Alert(title, description, 5000, notifType)
    end
end






local pos = vector3(-1563.0394, -181.0666, 55.5256)
local lib = exports.ox_lib
local inZone = false


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)
        local isInsideAnyZone = false

        for _, zone in ipairs(Config.zones) do
            local dist = #(coords - zone.coords)

            -- marker
DrawMarker(1, zone.coords.x, zone.coords.y, zone.coords.z - 1.0, 
                0, 0, 0, 0, 0, 0, 
                50.0, 50.0, 3.0, Config.color.red, Config.color.green, Config.color.blue, 100, 
                false, true, 2, false, nil, nil, false
            )

            if dist < 25.0 then
                isInsideAnyZone = true
                SetEntityInvincible(playerPed, true)
                SetPedCanRagdoll(playerPed, false)
                DisablePlayerFiring(PlayerId(), true)
                break
            end
        end

        if isInsideAnyZone and not inZone then
            inZone = true
            sendNotification("Safezone", "Vstoupil jsi do Safezone", "success")
            
        elseif not isInsideAnyZone and inZone then
            inZone = false
            SetEntityInvincible(playerPed, false)
            SetPedCanRagdoll(playerPed, true)
            sendNotification("Safezone", "Opustil jsi Safezone", "error")
        end
    end
end)
