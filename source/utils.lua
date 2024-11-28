local Utils = {}

function Utils.secondsToTime(seconds, showHours)
    showHours = showHours or false
    local hours = math.floor(seconds / 3600)
    local minutes = math.floor(seconds / 60)
    local remainingSeconds = math.floor(seconds % 60)
    if showHours then
        minutes = minutes - hours * 60
        return string.format("%02d:%02d", hours, minutes)
    end
    return string.format("%02d:%02d", minutes, remainingSeconds)
end

function Utils.currentDate()
    return playdate.getTime().year .. "-" .. playdate.getTime().month .. "-" .. playdate.getTime().day
end

return Utils
