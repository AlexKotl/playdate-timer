local Button = {}
Button.__index = Button

local gfx<const> = playdate.graphics
local fontBigger<const> = gfx.font.new("fonts/Pedallica/font-pedallica-fun-14")

function Button.draw(posX, posY, text, icon)
    local height = 36
    local gap = 10
    local width = gfx.getTextSize(text, fontBigger) + gap * 2
    local iconImage = nil

    if icon then
        width = width + 36 + gap
        iconImage = gfx.image.new("assets/icons/" .. icon)
    end

    gfx.setFont(fontBigger)
    gfx.setColor(1)
    gfx.fillRoundRect(posX, posY, width, height, 3)
    gfx.setColor(0)
    gfx.drawRoundRect(posX, posY, width, height, 3)
    gfx.drawText(text, posX + gap, posY + gap)
    if iconImage then
        iconImage:draw(posX + gap, posY + gap)
    end
end

return Button
