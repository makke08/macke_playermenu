local isMenuOpen = false

-- Function to toggle the NUI menu
function TogglePlayerList()
    isMenuOpen = not isMenuOpen

    -- If the menu is open, get player data and send it to the UI
    if isMenuOpen then
        local players = {}
        for _, player in ipairs(GetActivePlayers()) do
            local playerID = GetPlayerServerId(player)
            local playerName = GetPlayerName(player)
            table.insert(players, {id = playerID, name = playerName})
        end

        -- Send the player data to the NUI (UI)
        SetNuiFocus(true, true)
        SendNUIMessage({
            type = "open",
            players = players
        })
    else
        -- Close the menu
        SetNuiFocus(false, false)
        SendNUIMessage({
            type = "close"
        })
    end
end

-- Listen for the HOME key to open the player list
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        if IsControlJustReleased(1, 213) then -- HOME key
            TogglePlayerList()
        end
    end
end)

-- NUI callback to close the menu
RegisterNUICallback('close', function(data, cb)
    TogglePlayerList()
    cb('ok')
end)
