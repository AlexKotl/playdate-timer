import "CoreLibs/graphics"

local gfx = playdate.graphics

function playdate.update()
    gfx.clear()
    gfx.drawText("Hello, Playdate!", 100, 100)
end
