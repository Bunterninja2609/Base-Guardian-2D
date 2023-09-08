function love.load()
    love.physics.setMeter(64)
    love.graphics.setDefaultFilter("nearest", "nearest")
    love.window.setFullscreen(true, "desktop")

    grassImage = love.graphics.newImage("grass.png")

    World = love.physics.newWorld(0, 0, true)
    player = {}
        player.body = love.physics.newBody(World, 0, 300, "dynamic")
        player.shape = love.physics.newCircleShape(10)
        player.fixture = love.physics.newFixture(player.body, player.shape)
        player.direction = 0 * math.pi
        player.attributes = {}
        player.attributes.jet = {}
        player.attributes.jet.isInJet = true
        player.attributes.jet.speed = 100
        player.attributes.jet.turningSpeed = 0.01
        player.attributes.jet.image = love.graphics.newImage("player.png")
        player.attributes.jet.scale = 5
        player.attributes.jet.height = 5
    
    
    cam = {}
    cam.x = 0
    cam.y = 0
    cam.vfX = 0
    cam.vfY = 0
    cam.position = love.math.newTransform(cam.x, cam.y)
    
    cam.attach = function()
        cam.position = love.math.newTransform(cam.x, cam.y)
        love.graphics.push()
        love.graphics.scale(worldScale)
        love.graphics.translate(-cam.x + cam.vfX + love.graphics.getWidth() / 2 / worldScale, -cam.y + cam.vfY + love.graphics.getHeight() / 2 / worldScale)
    end
    cam.detach = function()
        love.graphics.pop()
    end
    worldScale = 5
end

function movePlayerInJet()
    local wantedY = 0
    local wantedX = 0

    if love.keyboard.isDown("w") then
        wantedY = -1  -- Move up
    elseif love.keyboard.isDown("s") then
        wantedY = 1   -- Move down
    end

    if love.keyboard.isDown("a") then
        wantedX = -1  -- Move left
    elseif love.keyboard.isDown("d") then
        wantedX = 1   -- Move right
    end

    local currentVelocityX, currentVelocityY = player.body:getLinearVelocity()
    local currentSpeed = math.sqrt(currentVelocityX^2 + currentVelocityY^2)

    if currentSpeed > 0 then
        local currentDirection = math.atan2(currentVelocityY, currentVelocityX)
        player.direction = currentDirection
    end

    if wantedX ~= 0 or wantedY ~= 0 then
        local wantedDirection = math.atan2(wantedY, wantedX)

        -- Calculate the difference between the wanted direction and player's current direction
        local directionDifference = wantedDirection - player.direction

        -- Ensure smooth turning within [-pi, pi] range
        if directionDifference > math.pi then
            directionDifference = directionDifference - 2 * math.pi
        elseif directionDifference < -math.pi then
            directionDifference = directionDifference + 2 * math.pi
        end

        -- Apply smooth turning
        player.direction = player.direction + directionDifference * player.attributes.jet.turningSpeed
    end

    player.body:setLinearVelocity(math.cos(player.direction) * player.attributes.jet.speed, math.sin(player.direction) * player.attributes.jet.speed)

    cam.x = player.body:getX()
    cam.y = player.body:getY()
end


function love.update(dt)
    if player.attributes.jet.isInJet then
        movePlayerInJet()
    else
        
    end
    World:update(dt)
end

function love.draw()
    love.graphics.setBackgroundColor(0.2, 0.6, 0.2)
    cam:attach()

    local playerX, playerY = player.body:getX(), player.body:getY()
    love.graphics.setColor(1, 1, 1)
    for i = 0, 20, 1 do
        for j = 0, 20,1 do
            love.graphics.draw(grassImage,i * 32,j * 32)
        end
    end
    -- Draw the player image with rotation
    love.graphics.setColor(0, 0, 0, 0.5)
    love.graphics.draw(player.attributes.jet.image, playerX, playerY + player.attributes.jet.height, player.direction + math.pi / 2, 1, 1, player.attributes.jet.image:getWidth() / 2, player.attributes.jet.image:getHeight() / 2)
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(player.attributes.jet.image, playerX, playerY, player.direction + math.pi / 2, 1, 1, player.attributes.jet.image:getWidth() / 2, player.attributes.jet.image:getHeight() / 2)
    

    -- Draw other elements
    
    love.graphics.rectangle("fill", 0, 0, 200, 20)
    
    cam:detach()
end



function love.keypressed(key, scancode, isrepeat)
    if key == "escape" then 
        fullscreen = not fullscreen
        love.window.setFullscreen(fullscreen, "desktop") 	
    end 
end