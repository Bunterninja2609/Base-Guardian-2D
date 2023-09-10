function love.load()
    love.physics.setMeter(64)
    love.graphics.setDefaultFilter("nearest", "nearest")
    love.window.setFullscreen(true, "desktop")
    World = love.physics.newWorld(0, 0, true)
    worldScale = 5
    theme = "2023"

    -- Temporary Background
    grassImage = love.graphics.newImage("textures/" .. theme .. "/grass.png")

    
    player = {}
        player.body = love.physics.newBody(World, 0, 300, "dynamic")
        player.shape = love.physics.newCircleShape(10)
        player.fixture = love.physics.newFixture(player.body, player.shape)
        player.direction = 0 * math.pi
        player.attributes = {}
            player.attributes.isInJet = true
            player.attributes.jet = {}
                player.attributes.jet.speed = 120
                player.attributes.jet.turningSpeed = 0.02
                player.attributes.jet.image = love.graphics.newImage("textures/" .. theme .. "/player.png")
                player.attributes.jet.scale = 5
                player.attributes.jet.height = 10
    enemies = {}
    enemyStats = {
        tank = {
            texture = love.graphics.newImage("textures/" .. theme .. "/tank.png"),
            speed = 1,
            range = 3,
            cooldown = 0.5,
            reloadTime = 2,
            barrage = 2,
            target = "ground",
            projectile = "shell",
            isOnGround = true,
            dropCount = 2
        }
    }
    
    
    
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
function createEnemy(type)
    local enemyTemplate = enemyStats[type]
    local enemy = {}
    enemy.x = 0
    enemy.y = 0
    enemy.speed = enemyTemplate.speed
    enemy.range = enemyTemplate.range
    enemy.cooldown = enemyTemplate.cooldown
    enemy.reloadTime = enemyTemplate.reloadTime
    enemy.barrage = enemyTemplate.barrage
    enemy.target = enemyTemplate.target
    enemy.lockedTarget = 
    if enemyTemplate.isOnGround then
        local enemy.height = 1
    else
        local enemy.height = 10
    end
end


function love.update(dt)
    if player.attributes.isInJet then
        movePlayerInJet()
    else
        
    end
    World:update(dt)
end

function love.draw()
    love.graphics.setBackgroundColor(0.2, 0.6, 0.2)
    love.graphics.setColor(1, 1, 1)
    cam:attach()

    local playerX, playerY = player.body:getX(), player.body:getY()

    -- Draw temporary Background
    for i = 0, 20, 1 do
        for j = 0, 20,1 do
            love.graphics.draw(grassImage,i * 32,j * 32)
        end
    end
    -- Draw the player shadow
    love.graphics.setColor(0, 0, 0, 0.5)
    love.graphics.draw(player.attributes.jet.image, playerX, playerY + player.attributes.jet.height, player.direction + math.pi / 2, 1, 1, player.attributes.jet.image:getWidth() / 2, player.attributes.jet.image:getHeight() / 2)
    -- Draw the player
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(player.attributes.jet.image, playerX, playerY, player.direction + math.pi / 2, 1, 1, player.attributes.jet.image:getWidth() / 2, player.attributes.jet.image:getHeight() / 2)
    
    
    cam:detach()
end



function love.keypressed(key, scancode, isrepeat)
    if key == "escape" then 
        fullscreen = not fullscreen
        love.window.setFullscreen(fullscreen, "desktop") 	
    end 
end