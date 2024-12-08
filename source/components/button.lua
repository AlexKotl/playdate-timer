local Button = {}
Button.__index = Button

local gfx<const> = playdate.graphics
local fontBigger<const> = gfx.font.new("fonts/Roobert/Roobert-10-Bold")

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
    gfx.setLineWidth(2)
    gfx.fillRoundRect(posX, posY, width, height, 4)
    gfx.setColor(0)
    gfx.drawRoundRect(posX, posY, width, height, 4)
    gfx.drawText(text, posX + gap + (iconImage and 36 or 0), posY + gap)
    if iconImage then
        iconImage:draw(posX + 3, posY + 3)
    end
end

return Button
