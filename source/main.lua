import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/timer"
import "screenManager"
import "screens/reportScreen"

local gfx<const> = playdate.graphics
local fontDefault<const> = gfx.getSystemFont()
local fontClock<const> = gfx.font.new("fonts/Clock")
playdate.setAutoLockDisabled(true)

local screenManager = ScreenManager:new()

local reportScreen = ReportScreen:new()
-- local gameScreen = GameScreen:new()

-- Register screens
screenManager:addScreen("report", ReportScreen)
-- screenManager:addScreen("game", gameScreen)

-- Show the initial screen
screenManager:showScreen("report")

function playdate.update()
    if screenManager.activeScreen and screenManager.activeScreen.update then
        screenManager.activeScreen:update()
    end
end
