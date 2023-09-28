-- main.lua

-- Define some variables to keep track of the current state
local state = {}
state.current = "titlescreen"
local offline
local online



function love.update(dt)
    if state.current == "titlescreen"then
        
        
    elseif state.current == "offline" then
        offline = require("offline")
    elseif state.current == "online" then
        online = require("online")
    end
end
function love.draw()
    love.window.setFullscreen(true, "desktop")
    love.graphics.setBackgroundColor(0.5,0.5,1)
end
function love.keypressed(key)
    if key == "1" then
        state.current = "offline"
    end
    if key == "2" then
        state.current = "online"
    end
end
