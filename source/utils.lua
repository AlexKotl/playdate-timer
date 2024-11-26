local Utils = {}

function Utils.secondsToTime(seconds)
    local minutes = math.floor(seconds / 60)
    local remainingSeconds = math.floor(seconds % 60)
    return string.format("%02d:%02d", minutes, remainingSeconds)
end

function Utils.currentDate()
    return playdate.getTime().year .. "-" .. playdate.getTime().month .. "-" .. playdate.getTime().day
end

return Utils
