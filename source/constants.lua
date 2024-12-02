local Constants = {}

local gfx<const> = playdate.graphics

Constants.activities = {{
    ["name"] = "work",
    ["icon"] = gfx.image.new("assets/activities/work"),
    ["ditherPattern"] = gfx.image.kDitherTypeScreen,
    ["ditherValue"] = 0
}, {
    ["name"] = "meeting",
    ["icon"] = gfx.image.new("assets/activities/meeting"),
    ["ditherPattern"] = gfx.image.kDitherTypeDiagonalLine,
    ["ditherValue"] = 0.5
}, {
    ["name"] = "gaming",
    ["icon"] = gfx.image.new("assets/activities/gaming"),
    ["ditherPattern"] = gfx.image.kDitherTypeScreen,
    ["ditherValue"] = 0.8
}, {
    ["name"] = "creativity",
    ["icon"] = gfx.image.new("assets/activities/creativity"),
    ["ditherPattern"] = gfx.image.kDitherTypeScreen,
    ["ditherValue"] = 0.3
}}

return Constants
