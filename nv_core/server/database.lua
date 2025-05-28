IsDatabaseVerified = false

-- Create tables
local createPlayersTable = [[
  CREATE TABLE IF NOT EXISTS nova_players (
    license VARCHAR(255) NOT NULL,
    identifier VARCHAR(255) NOT NULL,
    cash INT NOT NULL DEFAULT 0,
    bank INT NOT NULL DEFAULT 0,
    rank INT NOT NULL DEFAULT 0,
    xp INT NOT NULL DEFAULT 0
  ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
]]

local createInventoryTable = [[
  CREATE TABLE IF NOT EXISTS nova_inventory (
    license VARCHAR(255) NOT NULL,
    item VARCHAR(255) NOT NULL
  ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
]]

MySQL.query(createPlayersTable, {}, function()
    MySQL.query(createInventoryTable, {}, function()
        IsDatabaseVerified = true
        print("[nv_core] ✅ Database setup completed.")
    end)
end)
