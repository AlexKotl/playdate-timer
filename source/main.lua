import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/timer"

local gfx = playdate.graphics

local isRunning = false
local startTime = nil
local elapsedTime = 0

local function toggleStopwatch()
    if stopwatchRunning then
        elapsedTime = playdate.getCurrentTimeMilliseconds() - startTime
        stopwatchRunning = false
    else
        startTime = playdate.getCurrentTimeMilliseconds() - elapsedTime
        stopwatchRunning = true
    end
end

local function updateScreen()
    gfx.clear()

    local displayTime
    if stopwatchRunning then
        displayTime = playdate.getCurrentTimeMilliseconds() - startTime
    else
        displayTime = elapsedTime
    end

    if isRunning then
        gfx.drawText(string.format("Working: %.2f s", displayTime / 1000), 10, 100)
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
