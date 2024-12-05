HoleScreen = Screen:new()

local gfx<const> = playdate.graphics
local holeItems<const> = {
    hole1 = {
        title = "Basic hole",
        category = "hole",
        description = "A hole in the ground for rabbits.",
        price = 0,
        image = gfx.image.new("assets/hole/hole1")
    },
    couch1 = {
        title = "Basic couch",
        category = "couch",
        description = "Just simple smelly old couch.",
        price = 0,
        image = gfx.image.new("assets/hole/couch1")
    },
    carpet1 = {
        title = "Small carpet",
        category = "carpet",
        description = "Carpet. It's small. It smells. It's carpet.",
        price = 20,
        image = gfx.image.new("assets/hole/carpet1")
    },
    desk1 = {
        title = "Small desk",
        category = "desk",
        description = "Almost fits for work.",
        price = 100,
        image = gfx.image.new("assets/hole/desk1")
    },
    windows1 = {
        title = "Windows",
        category = "windows",
        description = "Windows for sun",
        price = 0,
        image = gfx.image.new("assets/hole/windows1")
    }
}
local currentItems = {"hole1", "couch1", "carpet1", "desk1", "windows1"}
local currentBalance = 0
local isMenuVisible = true
local selectedMenuItem = 1

local function drawMenu()
    local itemHeight = 40

    gfx.setColor(1)
    gfx.fillRect(10, 10, 220, 220)
    gfx.setColor(0)
    gfx.drawRect(10, 10, 220, 220)

    -- for each values holeItems

    local i = 0
    for key, item in pairs(holeItems) do

        gfx.drawText(item.title, 20, 20 + (i * itemHeight))
        -- gfx.drawText(item.description, 20, 40 + (i * itemHeight))
        -- gfx.drawText("Price: $" .. item.price, 20, 60 + (i * itemHeight))
        i = i + 1
    end
end

function HoleScreen:show()
    currentBalance = 200
end

function HoleScreen:hide()
end

function HoleScreen:update()
    gfx.clear()

    for i, item in ipairs(currentItems) do
        local item = holeItems[item]
        if item.image then
            item.image:draw(1, 1)
        end
    end

    gfx.drawText("You have: $" .. currentBalance, 100, 10)

    if isMenuVisible then
        drawMenu()
    end
end

function HoleScreen.downButtonDown()

end

function HoleScreen.upButtonDown()

end

function HoleScreen.leftButtonDown()

end

function HoleScreen.rightButtonDown()

end
