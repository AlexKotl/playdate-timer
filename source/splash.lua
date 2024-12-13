local Splash = {}
Splash.__index = Splash

import "CoreLibs/timer"

local gfx<const> = playdate.graphics
local minRadius<const> = 50
local maxRadius<const> = 200
local delayBetweenPartials<const> = 400
local partialExplosionDuration<const> = 1000
local partialsCount<const> = 8

function Splash:init()
    self.partials = {}
    return self
end

function Splash:run()
    for i = 1, partialsCount do
        print('init partial', i)
        table.insert(self.partials, {
            x = math.random(30, 370),
            y = math.random(20, 220),
            radius = math.random(minRadius, maxRadius),
            initTimer = playdate.timer.new(i * delayBetweenPartials, function()
                if self.partials[i] then
                    self.partials[i].timer = playdate.timer.new(partialExplosionDuration, 0, 1)
                    -- at this point we may add new timer to remove partial
                end
            end)
        })
    end

    playdate.timer.new(partialsCount * delayBetweenPartials + partialExplosionDuration, function()
        self:destroy()
    end)
end

function Splash:destroy()
    self.partials = {}
end

function Splash:draw()
    for i, partial in ipairs(self.partials) do
        gfx.setColor(gfx.kColorBlack)
        if partial.timer then

            gfx.setDitherPattern(partial.timer.value, gfx.image.kDitherTypeScreen)
            gfx.fillCircleAtPoint(partial.x, partial.y, partial.radius * partial.timer.value)
        end
    end
end

return Splash
