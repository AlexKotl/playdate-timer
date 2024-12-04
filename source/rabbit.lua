local Rabbit = {}
Rabbit.__index = Rabbit

local gfx<const> = playdate.graphics
local animation = 'idle'
local animationRepeats = 10
local animationTimer = nil

function Rabbit:init()
    local spriteSheet = gfx.imagetable.new("assets/rabbit")
    local animatedSprite = gfx.sprite.new()
    local self = setmetatable({}, Rabbit)
    self.animation = "idle"

    animatedSprite:moveTo(265, 40)
    animatedSprite:add()

    local frame = 5
    local animationSpeed = 120

    animationTimer = playdate.timer.new(animationSpeed, function()
        animatedSprite:setImage(spriteSheet:getImage(frame))
        animationRepeats = animationRepeats - 1
        if animationRepeats == 0 then
            animationTimer.repeats = false
        end

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
    print('Setting animation to', newAnimation)
    animationRepeats = 50
    animationTimer.repeats = true
    self.animation = newAnimation
end

return Rabbit
