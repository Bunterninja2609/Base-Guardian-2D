-- main.lua

-- Define some variables to keep track of the current state
local state = {}
state.current = "titlescreen"
local offline
local online



function love.update(dt)
    if state.current ~= "titlescreen"then
        offline = require("offline")
        online = require("online")
    end
end
function love.draw()
    love.window.setFullscreen(true, "desktop")
    love.graphics.setBackgroundColor(0.5,0.5,1)
end
function love.keypressed(key)
    if key == "return" then
        state.current = "offline"
    end
end
