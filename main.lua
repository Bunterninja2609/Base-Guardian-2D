-- main.lua

-- Define some variables to keep track of the current state
local state = {}
state.current = "titlescreen"
local offline
local online
local width = love.graphics.getWidth()
local height = love.graphics.getHeight()
local mouseY = love.mouse.getY()
local mouseX = love.mouse.getX()

function drawMode(x, y, localWidth, localHeight, mode)
    local offset = 0
    if mouseX > x and mouseX < x + localWidth and mouseY > y and mouseY < y + localHeight then
        offset = 20
        if love.mouse.isDown(1) then
            state.current = mode
        end
    end
    
    love.graphics.setColor(0 ,0 ,0 ,0.5)
    love.graphics.rectangle("fill", x + 10 - offset, y + 10 - offset, localWidth + 2*offset, localHeight + 2*offset, 30)
    love.graphics.setColor(1 ,1 ,1 ,1)
    love.graphics.rectangle("fill", x - offset , y - offset , localWidth + 2*offset, localHeight + 2*offset, 30)

    if mode == "offline" then
        love.graphics.setColor(0 ,1 ,0 ,1 )
    else
        love.graphics.setColor(1 ,0 ,0 ,1 )
    end
    love.graphics.rectangle("fill", x + 20  - offset, y + 230 - offset, localWidth - 40 + 2*offset, localHeight - 300 + 2*offset, 10)


end

function love.update(dt)
    if state.current == "titlescreen"then
        mouseY = love.mouse.getY()
        mouseX = love.mouse.getX()
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
    drawMode( 50, 50, 550, height - 100, "offline")
    drawMode( width - 50 -550, 50, 550, height - 100, "online")
    
    
end
function love.keypressed(key)
    if key == "1" then
        state.current = "offline"
    end
    if key == "2" then
        state.current = "online"
    end
end
