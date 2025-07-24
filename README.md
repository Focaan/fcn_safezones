# FCN Safezones

A robust FiveM script for creating and managing safezones on your server. Protect players, disable combat, limit vehicle speed, and more—all fully configurable!

## Features
- Create multiple safezones with custom settings
- Disable weapons and combat in zones
- Limit vehicle speed
- Make players and vehicles transparent
- Show blips and markers
- Easy to use and highly customizable

## Installation
1. **Download** or **clone** this repository.
2. **Drag and drop** the `fcn_safezones` folder into your `resources` directory.
3. Add `ensure fcn_safezones` to your `server.cfg`.

## Configuration
- Open `config.lua` to add or edit your safezones.
- Each safezone can have its own radius, label, blip, and special options.
- Example safezone configuration:

```lua
Config.Safezones = {
    {
        label = "Legion Square",
        coords = vector3(215.76, -810.12, 30.73),
        radius = 50.0,
        blip = {
            sprite = 280,
            color = 2,
            scale = 1.0,
            text = "Safezone"
        },
        notify = true,
        textUI = true,
        transparentPlayers = true,
        transparentVehicles = true,
        vehicleSpeedLimit = 30, -- mp/h
        disableVehiclePlayerCollision = true,
        showMarker = true,
        invincible = true -- set "Godmode" to players inside
    },
    -- Add more safezones as needed
}
```

## Documentation
Full documentation is available here: [https://focaan.gitbook.io/docs](https://focaan.gitbook.io/docs)

---

Enjoy and stay safe!
