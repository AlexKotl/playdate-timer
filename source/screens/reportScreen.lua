ReportScreen = Screen:new()
local gfx<const> = playdate.graphics

local archiveData = {}
local archiveByWeek = {}
local archiveWeeks = {}
local currentWeekNo = 1
local daysInMonth<const> = {31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31}
local daysOfWeek<const> = {"Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"}

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

function getDayOfWeek(dateString)
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
    local adjustedDay = (h + 6) % 7 + 1 -- Convert to 1 = Monday, 7 = Sunday
    return adjustedDay
end

function ReportScreen:show()
    archiveData = Storage.load("archiveData") or {}

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
        record.elapsed = (record.work or 0) + (record.meeting or 0) + (record.gaming or 0) + (record.creativity or 0)
        archiveByWeek[weekKey][dayOfWeek] = record
        print(weekKey, dayOfWeek, record.elapsed)
    end

    currentWeekNo = #archiveWeeks
end

function ReportScreen:hide()
end

function ReportScreen:update()
    gfx.clear()
    gfx.drawText("Week: " .. archiveWeeks[currentWeekNo], 20, 20)
    local maxTime = 0
    for i, record in pairs(archiveByWeek[archiveWeeks[currentWeekNo]]) do
        maxTime = math.max(maxTime, record.elapsed)
    end
    local pixelRate = 100 / maxTime
    gfx.drawText("Max time: " .. Utils.secondsToTime(maxTime, true), 20, 50)

    for day = 1, 7 do
        local record = archiveByWeek[archiveWeeks[currentWeekNo]][day]
        local x = 30 + (day - 1) * 50
        gfx.drawText(daysOfWeek[day], x, 210)
        local barHeight = 3
        if record then
            barHeight = record.elapsed * pixelRate
        end
        gfx.fillRect(x + 2, 190 - barHeight, 20, barHeight)

    end
end

function playdate.leftButtonDown()
    currentWeekNo = currentWeekNo - 1
    if currentWeekNo < 1 then
        currentWeekNo = 1
    end
end

function playdate.rightButtonDown()
    currentWeekNo = currentWeekNo + 1
    if currentWeekNo > #archiveWeeks then
        currentWeekNo = #archiveWeeks
    end
end
