ScreenManager = {}
ScreenManager.__index = ScreenManager

function ScreenManager:new()
    local instance = {
        screens = {},
        activeScreen = nil
    }
    setmetatable(instance, ScreenManager)
    return instance
end

function ScreenManager:addScreen(name, screen)
    self.screens[name] = screen
end

function ScreenManager:showScreen(name)
    if self.activeScreen and self.activeScreen.hide then
        self.activeScreen:hide()
    end
    self.activeScreen = self.screens[name]
    if self.activeScreen and self.activeScreen.show then
        self.activeScreen:show()
    end
end

Screen = {}
Screen.__index = Screen

function Screen:new()
    local instance = {}
    setmetatable(instance, Screen)
    return instance
end

function Screen:show()
    -- Code to initialize screen
end

function Screen:hide()
    -- Code to clean up screen
end

function Screen:update()
    -- Code to update screen
end
