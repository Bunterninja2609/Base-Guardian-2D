-- main.lua

-- Define some variables to keep track of the current state
local state = {}
state.current = "titlescreen"
local offline
local online
local width = love.graphics.getWidth()
local height = love.graphics.getHeight()

function drawMode(x, y, localWidth, localHeight, mode)
    
    love.graphics.setColor(0 ,0 ,0 ,0.5)
    love.graphics.rectangle("fill", x + 10, y + 10, localWidth, localHeight, 30)
    love.graphics.setColor(1 ,1 ,1 ,1)
    love.graphics.rectangle("fill", x , y , localWidth, localHeight, 30)

    love.graphics.setColor(0 ,0 ,0 ,1)
    love.graphics.rectangle("fill", x + 20 , y + 230, localWidth - 40, localHeight - 300, 10)


end

function love.update(dt)
    if state.current == "titlescreen"then
        width = love.graphics.getWidth()
        height = love.graphics.getHeight()
        
    elseif state.current == "offline" then
        offline = require("offline")
    elseif state.current == "online" then
        online = require("online")
    end
end
function love.draw()
    love.window.setFullscreen(true, "desktop")
    love.graphics.setBackgroundColor(0.5,0.5,1)
    love.graphics.setBackgroundColor(0.5, 0.5, 0.5)
    drawMode( 50, 50, 550, height - 100, 10, nil)
    drawMode( width - 50 -550, 50, 550, height - 100, 10, nil)
    
    
end
function love.keypressed(key)
    if key == "1" then
        state.current = "offline"
    end
    if key == "2" then
        state.current = "online"
    end
end
