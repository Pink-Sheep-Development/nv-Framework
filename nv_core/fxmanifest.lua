fx_version 'cerulean'
lua54 'yes'
game 'gta5'

author 'Pinksheepdevelopment'
description 'Nova Framework'
version '1.0.0'

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
