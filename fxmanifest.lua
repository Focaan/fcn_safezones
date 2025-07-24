fx_version 'cerulean'
game 'gta5'
lua54 "yes"

author 'Focaan'
description 'Safezone system with configurable options'
version '1.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua'
}

files {
  'locales/*.json'
}

client_scripts {
    'client/*.lua'
}
