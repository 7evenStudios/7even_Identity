fx_version 'cerulean'
game 'gta5'

shared_script 'config.lua'
server_script 'server/main.lua'
client_script 'client/main.lua'

ui_page 'html/index.html'
files {
  'html/index.html',
  'html/assets/**'
}

dependencies {
  'es_extended',
  'oxmysql'
}