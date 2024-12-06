HoleScreen = Screen:new()

local gfx<const> = playdate.graphics
local fontBigger<const> = gfx.font.new("fonts/Pedallica/font-pedallica-fun-14")
local fontDefault<const> = gfx.font.new("fonts/Cuberick/font-Cuberick-bold")
local holeItems = {{
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
    price = 100,
    image = gfx.image.new("assets/hole/desk1")
}, {
    key = "windows1",
    title = "Windows",
    category = "windows",
    description = "Windows for sun",
    price = 0,
    image = gfx.image.new("assets/hole/windows1")
}, {
    key = "windows2",
    title = "Windows without cracks",
    category = "windows",
    description = "",
    price = 0,
    image = gfx.image.new("assets/hole/windows2")
}, {
    key = "windows3",
    title = "Big windows",
    category = "windows",
    description = "",
    price = 0,
    image = gfx.image.new("assets/hole/windows3")
}}
local currentBalance = 0
local isMenuVisible = false
local selectedMenuItem = 1

local function drawMenu()
    local itemHeight = 32
    local itemsInMenu = 5
    local menuWidth = 220

    -- menu background
    gfx.setColor(1)
    gfx.fillRect(10, 10, menuWidth, itemHeight * itemsInMenu)
    gfx.setColor(0)
    gfx.drawRect(10, 10, menuWidth, itemHeight * itemsInMenu, 2)

    -- info text
    gfx.setColor(1)
    gfx.fillRect(menuWidth + 10, 10, 140, 100)
    gfx.setColor(0)
    gfx.drawRect(menuWidth + 10, 10, 140, 100, 2)
    gfx.setFont(fontDefault)
    gfx.drawTextInRect(holeItems[selectedMenuItem].description, menuWidth + 20, 20, 125, 90)

    local i = 1
    local currentPosition = 1
    local startIndex = 1
    local endIndex = itemsInMenu
    if selectedMenuItem > itemsInMenu - 1 then
        startIndex = selectedMenuItem + 2 - itemsInMenu
        endIndex = selectedMenuItem + 1
    end
    gfx.setFont(fontBigger)
    for i, item in ipairs(holeItems) do
        if i >= startIndex and i <= endIndex then
            if i == selectedMenuItem then
                gfx.setColor(0)
                gfx.fillRect(10, 10 + ((currentPosition - 1) * itemHeight), 220, itemHeight)
                gfx.setColor(1)
                gfx.setImageDrawMode(gfx.kDrawModeInverted)

            end
            gfx.drawText((item.applied and "+ " or "") .. item.title, 20, 20 + ((currentPosition - 1) * itemHeight))
            gfx.drawText("$" .. item.price, 170, 20 + ((currentPosition - 1) * itemHeight))
            gfx.setImageDrawMode(gfx.kDrawModeCopy)
            currentPosition = currentPosition + 1
        end
    end
end

local function saveCurrentState()
    local data = {
        balance = currentBalance,
        items = {}
    }
    for i, item in ipairs(holeItems) do
        if item.purchased then
            table.insert(data.items, {
                key = item.key,
                purchased = item.purchased,
                applied = item.applied
            })
        end
    end
    Storage.save(data, "hole")
end

function HoleScreen:show()
    currentBalance = 200
    gfx.setFont(fontBigger)
    local data = Storage.load("hole") or {}
    currentBalance = data.balance or 300
    for i, item in ipairs(data.items or {}) do
        for j, holeItem in ipairs(holeItems) do
            if holeItem.key == item.key then
                holeItem.purchased = item.purchased
                holeItem.applied = item.applied
            end
        end
    end
end

function HoleScreen:hide()
end

function HoleScreen:update()
    gfx.clear()

    for i, item in ipairs(holeItems) do
        if item.applied and item.image then
            item.image:draw(1, 1)
        end
    end

    gfx.drawText("You have: $" .. currentBalance, 100, 10)

    if isMenuVisible then
        drawMenu()
    end
end

function HoleScreen.downButtonDown()
    selectedMenuItem = selectedMenuItem + 1
    if selectedMenuItem > #holeItems then
        selectedMenuItem = #holeItems
    end
end

function HoleScreen.upButtonDown()
    selectedMenuItem = selectedMenuItem - 1
    if selectedMenuItem < 1 then
        selectedMenuItem = 1
    end
end

function HoleScreen.leftButtonDown()

end

function HoleScreen.rightButtonDown()

end

function HoleScreen.AButtonDown()
    if isMenuVisible then
        -- buy item
        local item = holeItems[selectedMenuItem]
        holeItems[selectedMenuItem].applied = not item.applied
        holeItems[selectedMenuItem].purchased = true
        saveCurrentState()

        isMenuVisible = false
    else
        isMenuVisible = true
    end
end

function HoleScreen.BButtonDown()
    if isMenuVisible then
        isMenuVisible = false
    else
        ScreenManager.instance:showScreen("timer")
    end
end
