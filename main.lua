-- main.lua

-- Define some variables to keep track of the current state
local FPS = 0
local state = {}
state.current = "titlescreen"
local offline
local online
local width = love.graphics.getWidth()
local height = love.graphics.getHeight()
love.graphics.setDefaultFilter("nearest", "nearest")

function love.draw()
    love.graphics.draw(love.graphics.newImage("textures/title.png"),0,0,0,width/130, height/100)
end
function love.keypressed(key)
    offline = require("offline")
end
