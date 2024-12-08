TimerScreen = Screen:new()
import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/timer"
local Rabbit = import "rabbit"

local gfx<const> = playdate.graphics
local fontBigger<const> = gfx.font.new("fonts/Roobert/Roobert-10-Bold")
local fontDefault<const> = gfx.font.new("fonts/Cuberick/font-Cuberick-bold")
local fontClock<const> = gfx.font.new("fonts/Clock/Clock")
gfx.setFontTracking(1)
playdate.setAutoLockDisabled(true)

local isRunning = false
local startTime = nil
local elapsedTime = 0
local recordedTimes = {}
local currentActivityNo = 1
local isDaySummaryVisible = false
local daySummaryText = ""

local screenImage = gfx.image.new("assets/screen")
local rabbit = Rabbit:init()

local function checkDateAndSaveArchive()
    if recordedTimes[1] and (not recordedTimes[1]['date'] or recordedTimes[1]['date'] ~= Utils.currentDate()) then
        print("New day, resetting recorded times")

        local archiveData = Storage.load("archiveData") or {}
        local totalTime = 0;
        for i, record in ipairs(recordedTimes) do
            totalTime = totalTime + record.elapsed
        end
        table.insert(archiveData, Storage.recordedTimesToArchiveRecord(recordedTimes))
        Storage.save(archiveData, "archiveData")

        recordedTimes = {}
        Storage.save(recordedTimes, "recordedTimes")

        -- adding balance
        local holeData = Storage.load("hole") or {}
        local earned = math.ceil(totalTime / 3600 * 10)
        holeData.balance = (holeData.balance or 0) + earned
        Storage.save(holeData, "hole")

        isDaySummaryVisible = true
        daySummaryText =
            "Past day you have tracked " .. Utils.secondsToTime(totalTime, true) .. ". Rabbit has earned $" .. earned ..
                "."
    end
end

local function toggleStopwatch()
    -- Stop
    if isRunning then
        checkDateAndSaveArchive()
        local endTime = playdate.getSecondsSinceEpoch();
        elapsedTime = endTime - startTime

        table.insert(recordedTimes, {
            ["type"] = Constants.activities[currentActivityNo].name,
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
        local activity = {}
        for i, act in ipairs(Constants.activities) do
            if act.name == record.type then
                activity = act
                break
            end
        end
        gfx.setDitherPattern(activity['ditherValue'] or 0, activity['ditherPattern'] or gfx.image.kDitherTypeScreen)
        gfx.fillRect(barX, 240 - 20, barWidth, 20)
    end
    gfx.setLineWidth(3)
    gfx.drawLine(0, 240 - 20, 400, 240 - 20)
end

local function updateScreen()
    gfx.clear()
    gfx.sprite.update()
    screenImage:draw(0, 0)
    playdate.timer.updateTimers()

    local totalTime = 0
    for i, record in ipairs(recordedTimes) do
        totalTime = totalTime + record.elapsed
    end
    gfx.setFont(fontBigger)

    gfx.drawText("Today record: " .. Utils.secondsToTime(totalTime, true), 20, 20)

    if isRunning then
        local displayTime = (playdate.getSecondsSinceEpoch() - startTime)
        gfx.drawText(string.upper(Constants.activities[currentActivityNo].name), 20, 50)
        gfx.setFont(fontClock)
        gfx.drawText(Utils.secondsToTime(displayTime), 65, 110)
        if displayTime > 3600 then
            toggleStopwatch()
        end
    else
        gfx.setFont(fontDefault)
        gfx.drawText("Press A to start working", 30, 189)
        gfx.setDitherPattern(0.3, gfx.image.kDitherTypeDiagonalLine)
        for i, activity in ipairs(Constants.activities) do
            Constants.activities[i].icon:draw(36 + ((i - 1) * (64 + 25)), 110)
            if (i == currentActivityNo) then
                gfx.drawRect(36 + ((i - 1) * (64 + 25)) - 5, 110 - 5, 74, 74)
            end
        end
    end

    if isDaySummaryVisible then
        Modal.draw(daySummaryText, {{
            posX = 70,
            text = "Fine",
            icon = "a"
        }})
    end

    drawProgressbar()
end

function TimerScreen.AButtonDown()
    if isDaySummaryVisible then
        isDaySummaryVisible = false
        return
    end
    toggleStopwatch()
end

function TimerScreen.BButtonDown()
    if isDaySummaryVisible then
        isDaySummaryVisible = false
        return
    end

    if isRunning then
        toggleStopwatch()
    end
    ScreenManager.instance:showScreen("report")
end

function TimerScreen.rightButtonDown()
    currentActivityNo = currentActivityNo + 1
    if currentActivityNo > #Constants.activities then
        currentActivityNo = #Constants.activities
    end
end

function TimerScreen.leftButtonDown()
    currentActivityNo = currentActivityNo - 1
    if currentActivityNo < 1 then
        currentActivityNo = 1
    end
end

function TimerScreen:show()
    recordedTimes = Storage.load("recordedTimes") or {}
    rabbit:setAnimation("idle")
    checkDateAndSaveArchive()
end

function TimerScreen:hide()
    rabbit:stopAnimation()
end

function TimerScreen:update()
    updateScreen()
end
