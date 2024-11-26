import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/timer"
local Rabbit = import "rabbit"

local gfx<const> = playdate.graphics
local fontDefault<const> = gfx.getSystemFont()
local fontClock<const> = gfx.font.new("fonts/Mikodacs-Clock")
playdate.setAutoLockDisabled(true)

local isRunning = false
local startTime = nil
local elapsedTime = 0
local recordedTimes = {
    --     {
    --     ["elapsed"] = 0,
    --     ["start"] = 785869484,
    --     ["end"] = 785875484
    -- }, {
    --     ["elapsed"] = 0,
    --     ["start"] = 785838284,
    --     ["end"] = 785849084
    -- }
}

local screenSprite = gfx.sprite.new(gfx.image.new("assets/screen"))
screenSprite:moveTo(200, 120)
screenSprite:add()
local rabbit = Rabbit:init()

local function secondsToTime(seconds)
    local minutes = math.floor(seconds / 60)
    local remainingSeconds = math.floor(seconds % 60)
    return string.format("%02d:%02d", minutes, remainingSeconds)
end

local function toggleStopwatch()
    -- Stop
    if isRunning then
        local endTime = playdate.getSecondsSinceEpoch();
        elapsedTime = endTime - startTime

        table.insert(recordedTimes, {
            ["elapsed"] = elapsedTime,
            ["start"] = startTime,
            ["end"] = endTime
        })
        isRunning = false
        rabbit:setAnimation("idle")

    else
        elapsedTime = 0
        startTime = playdate.getSecondsSinceEpoch()
        isRunning = true
        rabbit:setAnimation("working")
    end

end

local function drawProgressbar()
    local pixelsPerSecond<const> = 400 / 60 / 60 / 24
    local midnightTimestamp = playdate.getSecondsSinceEpoch() - playdate.getTime().hour * 3600 -
                                  playdate.getTime().minute * 60 - playdate.getTime().second
    for i, record in ipairs(recordedTimes) do
        local barX = (record.start - midnightTimestamp) * pixelsPerSecond;
        local barWidth = (record["end"] - record["start"]) * pixelsPerSecond;
        if barWidth < 3 then
            barWidth = 3
        end
        gfx.setColor(gfx.kColorBlack)
        gfx.fillRect(barX, 240 - 20, barWidth, 20)
    end
    gfx.setLineWidth(3)
    gfx.drawLine(0, 240 - 20, 400, 240 - 20)
end

local function updateScreen()
    gfx.clear()
    gfx.setFont(fontDefault)
    gfx.sprite.update()
    playdate.timer.updateTimers()

    local totalTime = 0
    for i, record in ipairs(recordedTimes) do
        totalTime = totalTime + record.elapsed
    end
    gfx.drawText("Today record: " .. secondsToTime(totalTime), 20, 20)

    if isRunning then
        local displayTime = (playdate.getSecondsSinceEpoch() - startTime)
        gfx.setFont(fontClock)
        gfx.drawText(secondsToTime(displayTime), 65, 110)
    else
        gfx.drawText("Press A to start working", 20, 50)
    end

    drawProgressbar()
end

function playdate.update()
    updateScreen()
end

function playdate.AButtonDown()
    toggleStopwatch()
end
