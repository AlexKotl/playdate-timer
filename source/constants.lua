local Constants = {}

local gfx<const> = playdate.graphics

-- Activities, max 4
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

-- Hole setup
Constants.holeItems = {{
    key = "hole1",
    title = "Hole",
    category = "hole",
    description = "A hole in the ground for rabbits.",
    price = 0,
    image = gfx.image.new("assets/hole/hole1")
}, {
    key = "couch1",
    title = "Small couch",
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
    price = 100,
    image = gfx.image.new("assets/hole/desk1")
}, {
    key = "plant1",
    title = "Plant",
    category = "plant",
    description = "Small plant for small hole. Make it cozy, brings some oxygen.",
    price = 50,
    image = gfx.image.new("assets/hole/plant1")
}, {
    key = "picture1",
    title = "Creature picture",
    category = "picture",
    description = "Small picture on a wall for inspiration. Looks like a cat.",
    price = 80,
    image = gfx.image.new("assets/hole/picture1")
}, {
    key = "windows1",
    title = "Cracked windows",
    category = "windows",
    description = "Yes, they are cracked, but they bring some light and fresh air.",
    price = 0,
    image = gfx.image.new("assets/hole/windows1")
}, {
    key = "couch2",
    title = "Modern couch",
    category = "couch",
    description = "Modern couch for modern rabbits. Soft and cozy.",
    price = 300,
    image = gfx.image.new("assets/hole/couch2")
}, {
    key = "carpet2",
    title = "Scandi carpet",
    category = "carpet",
    description = "This new carpet has cool scandinavian pattern.",
    price = 200,
    image = gfx.image.new("assets/hole/carpet2")
}, {
    key = "desk2",
    title = "Desk with stump",
    category = "desk",
    description = "Good working table with a stump for sitting.",
    price = 300,
    image = gfx.image.new("assets/hole/desk2")
}, {
    key = "plant2",
    title = "Exotic plant",
    category = "plant",
    description = "This exotic plant is a bit dangerous, but looks cool.",
    price = 150,
    image = gfx.image.new("assets/hole/plant2")
}, {
    key = "picture2",
    title = "Hare picture",
    category = "picture",
    description = "Famous picture of hare from Albrecht Durer. Probably original.",
    price = 700,
    image = gfx.image.new("assets/hole/picture2")
}, {
    key = "windows2",
    title = "Big windows",
    category = "windows",
    description = "This windows are big and clean. They bring a lot of light.",
    price = 1000,
    image = gfx.image.new("assets/hole/windows2")
}, {
    key = "couch3",
    title = "Huge couch",
    category = "couch",
    description = "Huge couch can fit up to 5 rabbits. The best for parties.",
    price = 1200,
    image = gfx.image.new("assets/hole/couch3")
}, {
    key = "carpet3",
    title = "Fox carpet",
    category = "carpet",
    description = "Furry foxy carpet. Of course it's made from fake fur.",
    price = 900,
    image = gfx.image.new("assets/hole/carpet3")
}, {
    key = "desk3",
    title = "Standing table",
    category = "desk",
    description = "This adjustable working station is perfect for workaholic rabbits! Chair included.",
    price = 1000,
    image = gfx.image.new("assets/hole/desk3")
}, {
    key = "plant3",
    title = "Room tree",
    category = "plant",
    description = "Almost real size tree in a pot.",
    price = 1200,
    image = gfx.image.new("assets/hole/plant3")
}, {
    key = "picture3",
    title = "Big picture",
    category = "picture",
    description = "Big expensive picture from famous artist.",
    price = 7000,
    image = gfx.image.new("assets/hole/picture3")
}, {
    key = "windows3",
    title = "Panoramic windows",
    category = "windows",
    description = "These huge windows give you the best view.",
    price = 3000,
    image = gfx.image.new("assets/hole/windows3")
}}

return Constants
