local Rabbit = {}
Rabbit.__index = Rabbit

local gfx<const> = playdate.graphics
local animation = 'idle'

local animationRepeats = 0
local animationTimer = nil
local animatedSprite = nil
local spriteSheet = nil

function Rabbit:init()
    self.spriteSheet = gfx.imagetable.new("assets/rabbit")
    local self = setmetatable({}, Rabbit)
    self.animatedSprite = gfx.sprite.new()
    self.animation = "idle"

    self.animatedSprite:moveTo(265, 40)
    self.animatedSprite:add()

    return self
end

function Rabbit:setAnimation(newAnimation)
    self.animation = newAnimation

    local animationSpeed = 120
    local frame = 5
    -- How many frames to show begore sleep
    animationRepeats = 100

    if self.animationTimer then
        self.animationTimer:remove()
    end
    self.animationTimer = playdate.timer.new(animationSpeed, function()
        self.animatedSprite:setImage(self.spriteSheet:getImage(frame))
        animationRepeats = animationRepeats - 1
        if animationRepeats < 0 then
            self.animationTimer:remove()
        end

        frame = frame + 1
        if self.animation == "working" and frame > 4 then
            frame = 1
        elseif self.animation == "idle" and frame > 7 then
            frame = 5
        end
    end)
    self.animationTimer.repeats = true
end

function Rabbit:stopAnimation()
    self.animationTimer:remove()
end

return Rabbit
