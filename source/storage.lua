local Storage = {}

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

return Storage
