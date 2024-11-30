TimerScreen = Screen:new()
import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/timer"
local Rabbit = import "rabbit"

local gfx<const> = playdate.graphics
local fontDefault<const> = gfx.getSystemFont()
local fontClock<const> = gfx.font.new("fonts/Clock")
playdate.setAutoLockDisabled(true)

local isRunning = false
local startTime = nil
local elapsedTime = 0
local recordedTimes = {}
-- local recordedTimes = {}
local activities<const> = {{
    ["name"] = "work",
    ["icon"] = gfx.image.new("assets/activities/work")
}, {
    ["name"] = "meeting",
    ["icon"] = gfx.image.new("assets/activities/meeting")
}, {
    ["name"] = "gaming",
    ["icon"] = gfx.image.new("assets/activities/gaming")
}, {
    ["name"] = "creativity",
    ["icon"] = gfx.image.new("assets/activities/creativity")
}}
local currentActivityNo = 1

local screenImage = gfx.image.new("assets/screen")
local rabbit = Rabbit:init()

local function checkDateAndSaveArchive()
    if recordedTimes[1] and (not recordedTimes[1]['date'] or recordedTimes[1]['date'] ~= Utils.currentDate()) then
        print("New day, resetting recorded times")

        local archiveData = Storage.load("archiveData") or {}
        table.insert(archiveData, Storage.recordedTimesToArchiveRecord(recordedTimes))
        Storage.save(archiveData, "archiveData")

        recordedTimes = {}
        Storage.save(recordedTimes, "recordedTimes")
    end
end

checkDateAndSaveArchive()

local function toggleStopwatch()
    -- Stop
    if isRunning then
        checkDateAndSaveArchive()
        local endTime = playdate.getSecondsSinceEpoch();
        elapsedTime = endTime - startTime

        table.insert(recordedTimes, {
            ["type"] = activities[currentActivityNo].name,
            ["date"] = Utils.currentDate(),
            ["elapsed"] = elapsedTime,
            ["start"] = startTime,
            ["end"] = endTime
        })
        isRunning = false
        rabbit:setAnimation("idle")
        Storage.save(recordedTimes, "recordedTimes")
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
        if record.type == 'meeting' then
            gfx.setDitherPattern(0.5, gfx.image.kDitherTypeDiagonalLine)
        elseif record.type == 'gaming' then
            gfx.setDitherPattern(0.8, gfx.image.kDitherTypeScreen)
        elseif record.type == 'creativity' then
            gfx.setDitherPattern(0.5, gfx.image.kDitherTypeHorizontalLine)
        else
            gfx.setDitherPattern(0, gfx.image.kDitherTypeScreen)
        end

        gfx.fillRect(barX, 240 - 20, barWidth, 20)
    end
    gfx.setLineWidth(3)
    gfx.drawLine(0, 240 - 20, 400, 240 - 20)
end

local function updateScreen()
    gfx.clear()
    gfx.setFont(fontDefault)
    gfx.sprite.update()
    screenImage:draw(0, 0)
    playdate.timer.updateTimers()

    local totalTime = 0
    for i, record in ipairs(recordedTimes) do
        totalTime = totalTime + record.elapsed
    end
    gfx.drawText("Today record: " .. Utils.secondsToTime(totalTime, true), 20, 20)

    if isRunning then
        local displayTime = (playdate.getSecondsSinceEpoch() - startTime)
        gfx.drawText(string.upper(activities[currentActivityNo].name), 20, 50)
        gfx.setFont(fontClock)
        gfx.drawText(Utils.secondsToTime(displayTime), 65, 110)
    else
        gfx.drawText("Press A to start working", 20, 50)
        gfx.drawText("Press B to select project", 40, 185)
        gfx.setDitherPattern(0.3, gfx.image.kDitherTypeDiagonalLine)
        for i, activity in ipairs(activities) do
            activities[i].icon:draw(36 + ((i - 1) * (64 + 25)), 110)
            if (i == currentActivityNo) then
                gfx.drawRect(36 + ((i - 1) * (64 + 25)) - 5, 110 - 5, 74, 74)
            end
        end

    end

    drawProgressbar()
end

function playdate.AButtonDown()
    toggleStopwatch()
end

function playdate.rightButtonDown()
    currentActivityNo = currentActivityNo + 1
    if currentActivityNo > #activities then
        currentActivityNo = 1
    end
end

function TimerScreen:show()
    recordedTimes = Storage.load("recordedTimes") or {}
end

function TimerScreen:hide()
end

function TimerScreen:update()
    updateScreen()
end
