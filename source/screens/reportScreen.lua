ReportScreen = Screen:new()
local gfx<const> = playdate.graphics

function ReportScreen:show()

end

function ReportScreen:hide()
end

function ReportScreen:update()
    gfx.drawText("Press A to start working", 20, 50)
end
