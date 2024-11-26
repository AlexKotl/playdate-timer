local Storage = {}

-- TODO: how to reuse from utils
local function currentDate()
    return playdate.getTime().year .. "-" .. playdate.getTime().month .. "-" .. playdate.getTime().day
end

function Storage.save(data, filename)
    local success, error = playdate.datastore.write(data, filename)
    if not success then
        print("Error saving data: " .. error)
    end
end

function Storage.load(filename)
    local data, error = playdate.datastore.read(filename)
    if not data then
        if error then
            print("Error loading data: " .. error)
        else
            print("No data file found.")
        end
        return nil
    else
        return data
    end
end

function Storage.recordedTimesToArchiveRecord(recordedTimes)
    local archiveRecord = {
        ["date"] = recordedTimes[1]["date"]
    }
    for i, record in ipairs(recordedTimes) do
        if not archiveRecord[record["type"]] then
            archiveRecord[record["type"]] = 0
        end
        archiveRecord[record["type"]] = archiveRecord[record["type"]] + record["elapsed"]
    end
    return archiveRecord
end

return Storage
