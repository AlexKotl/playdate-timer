HoleScreen = Screen:new()

local gfx<const> = playdate.graphics

function HoleScreen:show()

end

function HoleScreen:hide()
end

function HoleScreen:update()
    gfx.clear()
    gfx.drawText("Hole", 20, 20)

end

function HoleScreen.downButtonDown()

end

function HoleScreen.upButtonDown()

end

function HoleScreen.leftButtonDown()

end

function HoleScreen.rightButtonDown()

end
