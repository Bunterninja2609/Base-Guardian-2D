-- main.lua

-- Define some variables to keep track of the current state
local currentState = "offline"
local offline
local online

function love.update(dt)
    if currentState ~= "titlescreen"then
        offline = require("offline")
        online = require("online")
    end
end
