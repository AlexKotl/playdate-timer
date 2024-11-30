import "screenManager"
import "screens/reportScreen"
import "screens/timerScreen"
Utils = import "utils"
Storage = import "storage"

playdate.setAutoLockDisabled(true)

local screenManager = ScreenManager:new()
local timerScreen = TimerScreen:new()
local reportScreen = ReportScreen:new()

screenManager:addScreen("report", ReportScreen)
screenManager:addScreen("timer", TimerScreen)

screenManager:showScreen("timer")

function playdate.update()
    if screenManager.activeScreen and screenManager.activeScreen.update then
        screenManager.activeScreen:update()
    end
end

function playdate.BButtonDown()
    screenManager:showScreen("report")
end
