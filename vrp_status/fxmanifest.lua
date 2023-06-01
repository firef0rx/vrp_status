-- The NUI is not made by me personally! I don't want to steal anyone's work. I made this script for reference. Credits for NUI: https://github.com/iP4STRANA90

fx_version "cerulean"
game "gta5"

name "vRP2 Status"
description "vRP2 Framework NUI"
version "1.1"

dependency "vrp"

shared_script "@vrp/lib/utils.lua"
server_script "source/vrp.lua"
client_script "source/client.lua"

ui_page "web/ui.html"

files {
   "web/**/*"
}

lua54 "yes"
