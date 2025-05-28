fx_version 'cerulean'
lua54 'yes'
game 'gta5'

author 'FiveM-Scripts'
description 'Venomous Freemode Core'
version '1.1.3'

resource_type 'gametype' { name = 'nv-framework' }

dependencies {
    'oxmysql'
}

shared_scripts {
    '@ox_lib/init.lua',
    'config/freemode.lua'
}

client_scripts {
    'config/spawn.lua',
    'config/vehicles.lua',
    'utils/player.lua',
    'utils/screens.lua',
    'utils/vehicles.lua',
    'client/spawn.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/database.lua',
    'server/player.lua',
    'server/general.lua'
}

exports {
    'GetInventory'
}

server_exports {
    'AddInventoryItem',
    'GetInventoryItems'
}
