import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/timer"

local gfx = playdate.graphics
local fontDefault = gfx.getSystemFont()
local fontClock = gfx.font.new("fonts/Mikodacs-Clock")

local isRunning = false
local startTime = nil
local elapsedTime = 0
local recordedTimes = {}

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

    else
        elapsedTime = 0
        startTime = playdate.getSecondsSinceEpoch()
        isRunning = true
    end
end

local function updateScreen()
    gfx.clear()
    gfx.setFont(fontDefault)

    local totalTime = 0
    for i, record in ipairs(recordedTimes) do
        totalTime = totalTime + record.elapsed
    end
    gfx.drawText("Today record: " .. secondsToTime(totalTime), 10, 10)

    if isRunning then
        local displayTime = (playdate.getSecondsSinceEpoch() - startTime)
        gfx.setFont(fontClock)
        gfx.drawText(secondsToTime(displayTime), 10, 100)
    else
        gfx.drawText("Press A to start working", 10, 100)
    end

end

function playdate.update()
    updateScreen()
end

function playdate.AButtonDown()
    toggleStopwatch()
end
