-- main.lua

-- Define some variables to keep track of the current state
local FPS = 0
local state = {}
state.current = "titlescreen"
local offline
local online
local width = love.graphics.getWidth()
local height = love.graphics.getHeight()

function drawMode(x, y, localWidth, localHeight, mode)
    
    offset = 0
    if love.mouse.getX() > x and love.mouse.getY() > y and love.mouse.getX() < x + localWidth and love.mouse.getY() < y + localHeight then
        offset = 10
    end
    love.graphics.setColor(0 ,0 ,0 ,0.5)
    love.graphics.rectangle("fill", x + 10 + offset*2, y + 10 + offset*2, localWidth - offset, localHeight - offset, 30)
    love.graphics.setColor(1 ,1 ,1 ,1)
    love.graphics.rectangle("fill", x - offset, y - offset, localWidth + offset*2, localHeight + offset*2, 30)

    love.graphics.setColor(0 ,0 ,0 ,1)
    love.graphics.rectangle("fill", x + 20 - offset, y + 230 - offset, localWidth - 40 + offset*2, localHeight - 300 + offset*2, 10)
    love.graphics.print((localWidth - 40 + offset*2).."   "..(localHeight - 300 + offset*2),x , y)
    if love.mouse.isDown(1) then
        state.current = mode
    end

end

function love.update(dt)
    FPS = 1 / dt
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
    love.graphics.setBackgroundColor(0.5, 0.5, 0.5)


    drawMode( 50, 50, width/2 - 100, height - 100, "online")
    drawMode(width/2 + 50, 50, width/2 - 100, height - 100, "offline")
    
    love.graphics.print(math.floor(FPS), 100, 100)
    
end
function love.keypressed(key)
    if key == "1" then
        state.current = "offline"
    end
    if key == "2" then
        state.current = "online"
    end
end
