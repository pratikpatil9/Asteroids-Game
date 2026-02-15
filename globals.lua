package.path = package.path .. ";C:/Users/prati/AppData/Roaming/luarocks/share/lua/5.4/?.lua;C:/Users/prati/AppData/Roaming/luarocks/share/lua/5.4/?/init.lua"
local lunajson = require "lunajson"

ASTEROIDS_SIZE = 200
show_debugging = false
destory_ast = false

function calculateDistance(x1, y1, x2, y2)
    local dist_x = (x2 - x1) ^ 2
    local dist_y = (y2 - y1) ^ 2
    return math.sqrt(dist_x + dist_y)
end

function readJSON(f)
    local file = io.open("src/data/"..f, "r")
    local data = file:read("*all")
    file:close()

    return data
end