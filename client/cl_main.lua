local zones = {}
local currentZone = nil
local isInZone = false
lib.locale()

CreateThread(function()
    for i, zone in ipairs(Config.Safezones) do
        if zone.blip then
            local blip = AddBlipForCoord(zone.coords)
            SetBlipSprite(blip, zone.blip.sprite)
            SetBlipColour(blip, zone.blip.color)
            SetBlipScale(blip, zone.blip.scale)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(zone.blip.text)
            EndTextCommandSetBlipName(blip)
        end

        zones[i] = lib.zones.sphere({
            coords = zone.coords,
            radius = zone.radius,
            debug = false,
            onEnter = function()
                currentZone = zone
                isInZone = true
                EnterSafeZone(zone)
                TriggerEvent('fcn_safezones:entered', zone.label)
            end,
            onExit = function()
                TriggerEvent('fcn_safezones:left', currentZone and currentZone.label or nil)
                ExitSafeZone(currentZone)
                currentZone = nil
                isInZone = false
            end
        })
    end
end)


exports('isInSafeZone', function()
    return isInZone
end)

exports('isInSpecificSafeZone', function(label)
    return isInZone and currentZone and currentZone.label == label
end)

AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    ResetEntityAlpha(PlayerPedId())
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if vehicle ~= 0 then
        ResetEntityAlpha(vehicle)
    end
end)

function EnterSafeZone(zone)
    if zone.notify then
        lib.notify({
            title = locale('notify_label'),
            description = locale('entered_safezone') .. zone.label,
            type = 'success'
        })
    end

    if zone.textUI then
        lib.showTextUI(locale('notify_label') .. ": " .. zone.label, {
            position = "top-center",
            icon = 'shield-halved',
            style = {
                backgroundColor = '#38A169',
            }
        })
    end

    if zone.transparentPlayers then
        SetEntityAlpha(PlayerPedId(), 150, false)
    end

    if zone.transparentVehicles then
        local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
        if vehicle ~= 0 then
            SetEntityAlpha(vehicle, 150, false)
        end
    end

    if zone.vehicleSpeedLimit then
        CreateThread(function()
            while isInZone and currentZone == zone do
                local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
                if vehicle and vehicle ~= 0 then
                    SetEntityMaxSpeed(vehicle, zone.speedLimit / 2.23694) -- Convert m/s to MPH
                end
                Wait(1000)
            end
        end)
    end

    if zone.disableVehiclePlayerCollision then
        CreateThread(function()
            while isInZone and currentZone == zone do
                SetLocalPlayerAsGhost(true)
                Wait(0)
            end
            SetLocalPlayerAsGhost(false)
        end)
    end
end

function ExitSafeZone(zone)
    if zone.notify then
        lib.notify({
            title = locale('notify_label'),
            description = locale('exited_safezone') .. zone.label,
            type = 'error'
        })
    end

    if zone.textUI then
        lib.hideTextUI()
    end

    ResetEntityAlpha(PlayerPedId())

    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if vehicle ~= 0 then
        ResetEntityAlpha(vehicle)
        SetEntityMaxSpeed(vehicle, GetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fInitialDriveMaxFlatVel'))
    end
end


CreateThread(function()
    while true do
        local sleep = 1000
        local coords = GetEntityCoords(PlayerPedId())
        local nearZone = false

        if isInZone then
            DisablePlayerFiring(PlayerId(), true)
            DisableControlAction(0, 24, true)  -- Attack
            DisableControlAction(0, 140, true) -- Melee Attack Alternate
            DisableControlAction(0, 142, true) -- Melee Attack Heavy
            DisableControlAction(0, 257, true) -- Attack 2
            sleep = 0
        end

        for _, zone in ipairs(Config.Safezones) do
            local dist = #(coords - zone.coords)
            if zone.showMarker and dist < zone.radius + 25.0 then
                local c = Config.MarkerColor
                DrawMarker(1, zone.coords.x, zone.coords.y, zone.coords.z - 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, zone.radius * 2.0, zone.radius * 2.0, 2.0, c.r, c.g, c.b, c.a, false, true, 2, false, nil, nil, false)
                nearZone = true
            end
        end

        if nearZone or isInZone then
            sleep = 0
        end
        Wait(sleep)
    end
end)
