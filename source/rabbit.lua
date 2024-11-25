local Rabbit = {}
Rabbit.__index = Rabbit

local gfx<const> = playdate.graphics
local animation = 'idle'

function Rabbit:init()
    local spriteSheet = gfx.imagetable.new("assets/rabbit")
    local animatedSprite = gfx.sprite.new()
    local self = setmetatable({}, Rabbit)
    self.animation = "idle"

    animatedSprite:moveTo(330, 50)
    animatedSprite:add()

    local frame = 5
    -- local frameCount = spriteSheet:getLength()
    local animationSpeed = 120

    local animationTimer = playdate.timer.new(animationSpeed, function()
        animatedSprite:setImage(spriteSheet:getImage(frame))

        frame = frame + 1
        if self.animation == "working" and frame > 4 then
            frame = 1
        elseif self.animation == "idle" and frame > 7 then
            frame = 5
        end
    end)
    animationTimer.repeats = true
    return self
end

function Rabbit:setAnimation(newAnimation)
    self.animation = newAnimation
end

return Rabbit
