if Config.enableTextChat then
    StopResource('chat')
else
    StartResource('chat')
end

-- Stop default scoreboard
StopResource('scoreboard')

-- Load player money values
RegisterServerEvent('nv_core:LoadPlayer')
AddEventHandler('nv_core:LoadPlayer', function()
    local src = source
    Player:Find(src, function(data)
        if data then
            local bank = data.bank
            local cash = data.cash
            local rank = data.rank
            local xp = data.xp

            TriggerClientEvent('nv_core:DisplayCashValue', src, cash)
            TriggerClientEvent('nv_core:DisplayBankValue', src, bank)
        end
    end)
end)

-- Optional: Disable or move this if you're self-hosting
PerformHttpRequest(
    "https://raw.githubusercontent.com/Pink-Sheep-Development/nv-framework/master/nv_core/fxmanifest.lua",
    function(errorCode, result, headers)
        local version = GetResourceMetadata(GetCurrentResourceName(), 'version', 0)
        if result and result:find(version) == nil then
            print("^1[nv_core] WARNING: You may be running an outdated version.^0")
        end
    end,
    "GET",
    "",
    { ["Content-Type"] = "application/json" }
)
