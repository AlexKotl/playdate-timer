import "CoreLibs/graphics"
import "CoreLibs/timer"

local gfx = playdate.graphics

function playdate.update()
    gfx.clear()

    local time = playdate.getCurrentTimeMilliseconds()

    print(playdate.getTime().second)

    gfx.drawText("Hello, Playdate!", 100, 80)
    gfx.drawText(playdate.getTime().second, 100, 110)
end
