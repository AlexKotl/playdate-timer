local Modal = {}
Modal.__index = Modal

local gfx<const> = playdate.graphics
local fontBigger<const> = gfx.font.new("fonts/Roobert/Roobert-10-Bold")

function Modal.draw(text, buttons)
    local windowWidth = 300
    local windowHeight = 150
    gfx.setDitherPattern(0.3, gfx.image.kDitherTypeScreen)
    gfx.fillRect(0, 0, 400, 240)
    gfx.setColor(1)
    gfx.fillRect(50, 50, windowWidth, windowHeight)
    gfx.setColor(0)
    gfx.drawRect(50, 50, windowWidth, windowHeight, 2)
    gfx.setFont(fontBigger)
    gfx.drawTextInRect(text, 70, 70, 260, windowHeight)

    for i, button in ipairs(buttons) do
        Button.draw(button.posX or 70, windowHeight, button.text or "", button.icon)
    end
end

return Modal
