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
    ["name"] = "learning",
    ["icon"] = gfx.image.new("assets/activities/learning"),
    ["ditherPattern"] = gfx.image.kDitherTypeScreen,
    ["ditherValue"] = 0.8
}, {
    ["name"] = "creativity",
    ["icon"] = gfx.image.new("assets/activities/creativity"),
    ["ditherPattern"] = gfx.image.kDitherTypeScreen,
    ["ditherValue"] = 0.3
}}

Constants.holeItems = {{
    key = "hole1",
    title = "Basic hole",
    category = "hole",
    description = "A hole in the ground for rabbits.",
    price = 0,
    image = gfx.image.new("assets/hole/hole1")
}, {
    key = "couch1",
    title = "Basic couch",
    category = "couch",
    description = "Just simple smelly old couch.",
    price = 0,
    image = gfx.image.new("assets/hole/couch1")
}, {
    key = "carpet1",
    title = "Small carpet",
    category = "carpet",
    description = "Carpet. It's small. It smells. It's carpet.",
    price = 20,
    image = gfx.image.new("assets/hole/carpet1")
}, {
    key = "desk1",
    title = "Small desk",
    category = "desk",
    description = "Almost fits for work.",
    price = 20,
    image = gfx.image.new("assets/hole/desk1")
}, {
    key = "windows1",
    title = "Cracked windows",
    category = "windows",
    description = "Windows for sun",
    price = 0,
    image = gfx.image.new("assets/hole/windows1")
}, {
    key = "windows2",
    title = "Windows",
    category = "windows",
    description = "",
    price = 200,
    image = gfx.image.new("assets/hole/windows2")
}, {
    key = "windows3",
    title = "Big windows",
    category = "windows",
    description = "Bigger windows - more light.",
    price = 500,
    image = gfx.image.new("assets/hole/windows3")
}}

return Constants
