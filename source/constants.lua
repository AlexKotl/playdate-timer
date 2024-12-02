local Constants = {}

local gfx<const> = playdate.graphics

Constants.activities = {{
    ["name"] = "work",
    ["icon"] = gfx.image.new("assets/activities/work")
}, {
    ["name"] = "meeting",
    ["icon"] = gfx.image.new("assets/activities/meeting")
}, {
    ["name"] = "gaming",
    ["icon"] = gfx.image.new("assets/activities/gaming")
}, {
    ["name"] = "creativity",
    ["icon"] = gfx.image.new("assets/activities/creativity")
}}

return Constants
