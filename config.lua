Config = {}

Config.MarkerColor = { r = 0, g = 255, b = 0, a = 80 } -- color of the marker (default green = r = 0, g = 255, b = 0, a = 80 )

Config.Safezones = {
    {
        label = "Mirror Park",
        coords = vector3(1370.3716, -581.9411, 74.3803),
        radius = 25.0,
        showMarker = true, -- show the marker using the radius
        blip = false,
        textUI = true, -- Show text UI when entering
        notify = true, -- Show notification when entering / exiting
        transparentPlayers = true, -- Make players transparent
        transparentVehicles = true, -- Make vehicles transparent
        vehicleSpeedLimit = true, -- Limit vehicle speed in safezone
        speedLimit = 20.0, -- Speed limit in safezone (the value is in mp/h) (the vehicleSpeedLimit has to be on)
        disableVehiclePlayerCollision = true, -- disable vehicle-player collision in safezones
        invincible = true -- set "Godmode" to players inside
    },
}
