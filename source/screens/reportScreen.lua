ReportScreen = Screen:new()
import "CoreLibs/timer"

local gfx<const> = playdate.graphics
local fontDefault<const> = gfx.font.new("fonts/Cuberick/font-Cuberick-bold")
local animationTimer = nil

local archiveData = {}
local archiveByWeek = {}
local archiveWeeks = {}
local currentWeekNo = 1
local currentDayNo = 1
local daysInMonth<const> = {31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31}
local daysOfWeek<const> = {"Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"}
local reportScreenImage = gfx.image.new("assets/reportScreen")
local buttonHover = {
    left = {
        highlighted = false,
        x = 144,
        y = 12,
        width = 22,
        height = 30
    },
    right = {
        highlighted = false,
        x = 169,
        y = 12,
        width = 22,
        height = 30
    },
    up = {
        highlighted = false,
        x = 14,
        y = 12,
        width = 28,
        height = 30
    },
    down = {
        highlighted = false,
        x = 14,
        y = 45,
        width = 28,
        height = 28
    }
}

local sounds = {
    swap = playdate.sound.fileplayer.new("sounds/swap.mp3")
}

local function isLeapYear(year)
    return (year % 4 == 0 and year % 100 ~= 0) or (year % 400 == 0)
end

local function getDaysInMonth(year, month)
    if month == 2 and isLeapYear(year) then
        return 29
    end
    return daysInMonth[month]
end

-- Determine the weekday of a specific date (1 = Monday, 7 = Sunday)
local function getWeekday(year, month, day)
    -- Zeller's Congruence algorithm to calculate the day of the week
    if month < 3 then
        month = month + 12
        year = year - 1
    end
    local K = year % 100
    local J = math.floor(year / 100)
    local weekday = (day + math.floor((13 * (month + 1)) / 5) + K + math.floor(K / 4) + math.floor(J / 4) - (2 * J)) % 7
    return (weekday + 6) % 7 -- Convert to 1 = Monday, 7 = Sunday
end

-- Get the week range for a specific date
local function getWeekRange(year, month, day)
    local weekday = getWeekday(year, month, day)

    -- Calculate start and end days for the week
    local startDay = day - (weekday - 1) -- Monday
    local endDay = day + (7 - weekday) -- Sunday

    local startMonth, startYear = month, year
    local endMonth, endYear = month, year

    -- Handle start date overflow (previous month)
    if startDay < 1 then
        startMonth = startMonth - 1
        if startMonth < 1 then
            startMonth = 12
            startYear = startYear - 1
        end
        startDay = getDaysInMonth(startYear, startMonth) + startDay
    end

    -- Handle end date overflow (next month)
    if endDay > getDaysInMonth(year, month) then
        endDay = endDay - getDaysInMonth(year, month)
        endMonth = endMonth + 1
        if endMonth > 12 then
            endMonth = 1
            endYear = endYear + 1
        end
    end

    return {
        start = {
            year = startYear,
            month = startMonth,
            day = startDay
        },
        endDate = {
            year = endYear,
            month = endMonth,
            day = endDay
        }
    }
end

local function getDayOfWeek(dateString)
    -- Parse the input date string
    local year, month, day = dateString:match("(%d+)-(%d+)-(%d+)")
    year = tonumber(year)
    month = tonumber(month)
    day = tonumber(day)

    -- Adjust months and years for Zeller's Congruence
    if month < 3 then
        month = month + 12
        year = year - 1
    end

    -- Zeller's Congruence formula
    local k = year % 100
    local j = math.floor(year / 100)
    local h = (day + math.floor((13 * (month + 1)) / 5) + k + math.floor(k / 4) + math.floor(j / 4) - 2 * j) % 7
    local adjustedDay = (h + 6) % 7 -- Convert to 1 = Monday, 7 = Sunday
    return adjustedDay
end

local function hightlightButton(button)
    if buttonHover[button] then
        buttonHover[button].highlighted = true
        playdate.timer.new(100, function()
            buttonHover[button].highlighted = false
        end)
    end
end

local function resetAnimation()
    animationTimer = playdate.timer.new(500, 0, 1)
end

function ReportScreen:show()
    archiveData = Storage.load("archiveData") or {}
    -- add current day stats
    table.insert(archiveData, Storage.recordedTimesToArchiveRecord(Storage.load("recordedTimes") or {}))

    for i, record in ipairs(archiveData) do
        -- split date into year, month, day
        local year, month, day = record.date:match("(%d+)%-(%d+)%-(%d+)")
        local weekRange = getWeekRange(tonumber(year), tonumber(month), tonumber(day))
        local weekKey = string.format("%02d.%02d - %02d.%02d", weekRange.start.day, weekRange.start.month,
            weekRange.endDate.day, weekRange.endDate.month)
        local dayOfWeek = getDayOfWeek(record.date)
        if archiveByWeek[weekKey] == nil then
            archiveByWeek[weekKey] = {}
            table.insert(archiveWeeks, weekKey)
        end
        record.elapsed = (record.work or 0) + (record.meeting or 0) + (record.learning or 0) + (record.creativity or 0)
        archiveByWeek[weekKey][dayOfWeek] = record
        print(weekKey, dayOfWeek, record.date, record.elapsed)
    end

    currentWeekNo = #archiveWeeks
    resetAnimation()
end

function ReportScreen:hide()
end

function ReportScreen:update()
    gfx.clear()
    reportScreenImage:draw(0, 0)
    gfx.setFont(fontDefault)
    local weeks = archiveWeeks[currentWeekNo]:gmatch("%d%d%.%d%d");
    gfx.drawText("Week: ", 55, 18)
    gfx.drawText(weeks(0) .. " - ", 55, 37)
    gfx.drawText(weeks(0), 55, 55)
    gfx.drawText(daysOfWeek[currentDayNo], 153, 52)
    local maxTime = 0
    for i, record in pairs(archiveByWeek[archiveWeeks[currentWeekNo]]) do
        maxTime = math.max(maxTime, record.elapsed)
    end

    local pixelRate = 95 / maxTime
    local chartOffset = 195
    local chartDaysOffset = 212

    -- draw day summary
    local daySummary = archiveByWeek[archiveWeeks[currentWeekNo]][currentDayNo]
    for i, activity in ipairs(Constants.activities) do
        local timeStr = '  -'
        if daySummary and daySummary[activity.name] then
            timeStr = Utils.secondsToTime(daySummary[activity.name], true)
        end
        Constants.activities[i].icon:drawScaled(158 + i * 47, 17, 0.5)
        gfx.drawText(timeStr, 155 + i * 47, 55)
    end

    -- draw grid
    gfx.setDitherPattern(0.8, gfx.image.kDitherTypeScreen)
    for i = 0, math.floor(maxTime / 3600) do
        gfx.drawLine(20, chartOffset - i * 3600 * pixelRate, 370, chartOffset - i * 3600 * pixelRate, 2)
    end

    -- chart by days
    for day = 1, 7 do
        local record = archiveByWeek[archiveWeeks[currentWeekNo]][day]
        local x = 30 + (day - 1) * 50
        gfx.drawText(daysOfWeek[day], x, chartDaysOffset)
        if day == currentDayNo then
            gfx.setDitherPattern(0.3, gfx.image.kDitherTypeScreen)
            gfx.setLineWidth(3)
            gfx.drawRoundRect(x - 9, chartDaysOffset - 8, 45, 30, 3)
        end

        local barHeight = 3
        if record then
            local offset = 0
            for i, activity in ipairs(Constants.activities) do
                local time = record[activity.name] or 0
                barHeight = (record[activity.name] or 0) * pixelRate * animationTimer.value

                gfx.setDitherPattern(activity.ditherValue, activity.ditherPattern)
                gfx.fillRect(x + 2, chartOffset - offset - barHeight, 20, barHeight)
                offset = offset + barHeight
            end
        end
    end

    -- highlight buttons
    for button, data in pairs(buttonHover) do
        if data.highlighted then
            gfx.setDitherPattern(0.3, gfx.image.kDitherTypeScreen)
            gfx.fillRoundRect(data.x, data.y, data.width, data.height, 5)
        end
    end

    playdate.timer.updateTimers()
end

function ReportScreen.downButtonDown()
    currentDayNo = 1
    currentWeekNo = currentWeekNo - 1
    if currentWeekNo < 1 then
        currentWeekNo = 1
    else
        hightlightButton("down")
        resetAnimation()
    end
end

function ReportScreen.upButtonDown()
    currentDayNo = 1
    currentWeekNo = currentWeekNo + 1
    if currentWeekNo > #archiveWeeks then
        currentWeekNo = #archiveWeeks
    else
        hightlightButton("up")
        resetAnimation()
    end
end

function ReportScreen.leftButtonDown()
    currentDayNo = currentDayNo - 1
    hightlightButton("left")
    if currentDayNo < 1 then
        currentDayNo = 7
    end
end

function ReportScreen.rightButtonDown()
    currentDayNo = currentDayNo + 1
    hightlightButton("right")
    if currentDayNo > 7 then
        currentDayNo = 1
    end
end

function ReportScreen.BButtonDown()
    ScreenManager.instance:showScreen("hole")
    sounds.swap:play()
end
