import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/timer"

local gfx = playdate.graphics

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
        elapsedTime = playdate.getCurrentTimeMilliseconds() - startTime
        table.insert(recordedTimes, elapsedTime / 1000)
        isRunning = false
        -- log the recorded times
        for i, time in ipairs(recordedTimes) do
            print(i, time)
        end
    else
        elapsedTime = 0
        startTime = playdate.getCurrentTimeMilliseconds() - elapsedTime
        isRunning = true
    end
end

local function updateScreen()
    gfx.clear()

    local totalTime = 0
    for i, time in ipairs(recordedTimes) do
        totalTime = totalTime + time
    end
    gfx.drawText("Today record: " .. secondsToTime(totalTime), 10, 10)

    if isRunning then
        local displayTime = (playdate.getCurrentTimeMilliseconds() - startTime) / 1000
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
