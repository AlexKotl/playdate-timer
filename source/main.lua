import "screenManager"
import "screens/reportScreen"
import "screens/timerScreen"
import "screens/holeScreen"
Utils = import "utils"
Storage = import "storage"
Constants = import "constants"

playdate.setAutoLockDisabled(true)

local screenManager = ScreenManager:new()
local timerScreen = TimerScreen:new()
local reportScreen = ReportScreen:new()
local holeScreen = HoleScreen:new()

screenManager:addScreen("timer", TimerScreen)
screenManager:addScreen("report", ReportScreen)
screenManager:addScreen("hole", HoleScreen)

screenManager:showScreen("hole")

function playdate.update()
    if screenManager.activeScreen and screenManager.activeScreen.update then
        screenManager.activeScreen:update()
    end
end

function playdate.AButtonDown()
    if screenManager.activeScreen and screenManager.activeScreen.AButtonDown then
        screenManager.activeScreen:AButtonDown()
    end
end
function playdate.leftButtonDown()
    if screenManager.activeScreen and screenManager.activeScreen.leftButtonDown then
        screenManager.activeScreen:leftButtonDown()
    end
end
function playdate.rightButtonDown()
    if screenManager.activeScreen and screenManager.activeScreen.rightButtonDown then
        screenManager.activeScreen:rightButtonDown()
    end
end
function playdate.upButtonDown()
    if screenManager.activeScreen and screenManager.activeScreen.upButtonDown then
        screenManager.activeScreen:upButtonDown()
    end
end
function playdate.downButtonDown()
    if screenManager.activeScreen and screenManager.activeScreen.downButtonDown then
        screenManager.activeScreen:downButtonDown()
    end
end

function playdate.BButtonDown()
    if screenManager.activeScreenName == 'timer' then
        screenManager:showScreen("report")
    elseif screenManager.activeScreenName == 'report' then
        screenManager:showScreen("hole")
    else
        screenManager:showScreen("timer")
    end
end
