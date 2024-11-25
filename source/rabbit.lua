local Rabbit = {}
Rabbit.__index = Rabbit

local gfx<const> = playdate.graphics

function Rabbit:init()
    local spriteSheet = gfx.imagetable.new("assets/rabbit")
    local animatedSprite = gfx.sprite.new()

    animatedSprite:moveTo(330, 50)

    animatedSprite:add()

    local frame = 1
    local frameCount = spriteSheet:getLength()
    local animationSpeed = 100

    local animationTimer = playdate.timer.new(animationSpeed, function()
        animatedSprite:setImage(spriteSheet:getImage(frame))

        frame = frame + 1
        if frame > frameCount then
            frame = 1
        end
    end)
    animationTimer.repeats = true

    return {}
end

return Rabbit
