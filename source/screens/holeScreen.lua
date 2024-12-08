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
local currentBalance = 0
local isMenuVisible = false
local isConfirmationVisible = false
local selectedMenuItem = 1
local checkIcon = gfx.image.new("assets/icons/check")

local function drawMenu()
    local itemsInMenu = 5
    local menuItemHeight = 32
    local menuWidth = 250
    local infoTextWidth = 120
    local infoTextHeight = 120
    local rightColWidth = 50

    -- menu background
    gfx.setColor(1)
    gfx.fillRect(10, 10, menuWidth, menuItemHeight * itemsInMenu)
    gfx.setColor(0)
    gfx.drawRect(10, 10, menuWidth, menuItemHeight * itemsInMenu, 2)

    -- info text
    gfx.setColor(1)
    gfx.fillRect(menuWidth + 10, 10, infoTextWidth, infoTextHeight)
    gfx.setColor(0)
    gfx.drawRect(menuWidth + 10, 10, infoTextWidth, infoTextHeight, 2)
    gfx.setFont(fontDefault)
    gfx.drawTextInRect(holeItems[selectedMenuItem].description, menuWidth + 20, 20, infoTextWidth - 20, infoTextHeight)

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
                gfx.fillRect(10, 10 + ((currentPosition - 1) * menuItemHeight), menuWidth, menuItemHeight)
                gfx.setColor(1)
                gfx.setImageDrawMode(gfx.kDrawModeInverted)

            end
            gfx.drawText(item.title, 20, 20 + ((currentPosition - 1) * menuItemHeight))

            gfx.setColor(i == selectedMenuItem and 0 or 1)
            gfx.fillRect(menuWidth - rightColWidth, 12 + (currentPosition - 1) * menuItemHeight, rightColWidth,
                menuItemHeight - 4)
            local statusText = "$" .. item.price
            if item.applied then
                checkIcon:draw(menuWidth - 30, 10 + ((currentPosition - 1) * menuItemHeight))
                statusText = ""
            elseif item.purchased then
                statusText = ""
            end

            gfx.drawText(statusText, menuWidth - 40, 20 + ((currentPosition - 1) * menuItemHeight))
            gfx.setImageDrawMode(gfx.kDrawModeCopy)
            currentPosition = currentPosition + 1
        end
    end
end

local function applyItem(index, show)
    local item = holeItems[index]
    if show then
        holeItems[index].applied = true
        for i, holeItem in ipairs(holeItems) do
            if holeItem.category == item.category and holeItem.key ~= item.key then
                holeItem.applied = false
            end
        end
    else
        if item.key ~= "hole1" and item.key ~= "windows1" then
            holeItems[index].applied = false
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
    gfx.setFont(fontBigger)
    local data = Storage.load("hole") or {
        balance = 0,
        items = {{
            key = "hole1",
            purchased = true,
            applied = true
        }, {
            key = "couch1",
            purchased = true,
            applied = true
        }, {
            key = "windows1",
            purchased = true,
            applied = true
        }}
    }
    currentBalance = data.balance or 0
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
    local holeValue = 0

    for i, item in ipairs(holeItems) do
        if item.applied and item.image then
            item.image:draw(1, 1)
        end
        if item.purchased then
            holeValue = holeValue + item.price
        end
    end

    gfx.drawText("You have: $" .. currentBalance, 80, 10)
    gfx.drawText("Hole value: $" .. holeValue, 220, 10)
    if not isMenuVisible then
        -- TODO: show only if enough money
        Button.draw(10, 195, "Upgrade", "a")
    end

    if isMenuVisible then
        drawMenu()
    end
    if isConfirmationVisible then
        local item = holeItems[selectedMenuItem]
        Modal.draw("Are you sure you want to buy " .. item.title .. " for $" .. item.price .. "?", {{
            posX = 235,
            text = "Buy",
            icon = "a"
        }, {
            posX = 70,
            text = "Cancel",
            icon = "b"
        }})
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
    if isConfirmationVisible then
        currentBalance = currentBalance - holeItems[selectedMenuItem].price
        applyItem(selectedMenuItem, true)
        holeItems[selectedMenuItem].purchased = true
        saveCurrentState()
        isConfirmationVisible = false
        isMenuVisible = false
    elseif isMenuVisible then
        local item = holeItems[selectedMenuItem]
        if item.purchased then
            applyItem(selectedMenuItem, not item.applied)
            saveCurrentState()
            isMenuVisible = false
        else
            if currentBalance >= item.price then
                isConfirmationVisible = true
            end
        end

    else
        isMenuVisible = true
    end
end

function HoleScreen.BButtonDown()
    if isConfirmationVisible then
        isConfirmationVisible = false
    elseif isMenuVisible then
        isMenuVisible = false
    else
        ScreenManager.instance:showScreen("timer")
    end
end
