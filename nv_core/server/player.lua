-- vf_base - server/player.lua (Modernized for oxmysql)

Player = {}
Player.__index = Player

function Player:GetLicense(source)
    for _, v in ipairs(GetPlayerIdentifiers(source)) do
        if v:sub(1, #"license") == "license" then
            return v
        end
    end
end

function Player:GetIdentifier(source)
    for _, v in ipairs(GetPlayerIdentifiers(source)) do
        if v:sub(1, #"steam") == "steam" or v:sub(1, #"ip") == "ip" then
            return v
        end
    end
end

function Player:Find(source, callback)
    local pLicense = self:GetLicense(source)
    MySQL.scalar("SELECT license FROM nova_players WHERE license = ?", {pLicense}, function(result)
        callback(result)
    end)
end

function Player:Add(source)
    local license = self:GetLicense(source)
    local identifier = self:GetIdentifier(source)
    MySQL.update(
        "INSERT IGNORE INTO nova_players (license, identifier, cash, bank, rank, xp) VALUES (?, ?, ?, ?, ?, ?)",
        {license, identifier, 500, 2000, 1, 0}
    )
end

function Player:Get(source, callback)
    local license = self:GetLicense(source)
    MySQL.single("SELECT * FROM nova_players WHERE license = ?", {license}, function(data)
        callback(data)
    end)
end

function Player:UpdateMoney(source, cash, bank)
    local license = self:GetLicense(source)
    MySQL.update("UPDATE nova_players SET cash = ?, bank = ? WHERE license = ?", {cash, bank, license})
end

function Player:GetInventory(source, callback)
    local license = self:GetLicense(source)
    MySQL.query("SELECT item FROM nova_inventory WHERE license = ?", {license}, function(rows)
        local items = {}
        for _, row in pairs(rows) do
            table.insert(items, row.item)
        end
        callback(items)
    end)
end

function Player:AddInventoryItem(source, item)
    local license = self:GetLicense(source)
    MySQL.update("INSERT INTO nova_inventory (license, item) VALUES (?, ?)", {license, item})
end
