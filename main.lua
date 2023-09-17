function love.load()
    love.physics.setMeter(64)
    love.graphics.setDefaultFilter("nearest", "nearest")
    love.window.setFullscreen(true, "desktop")
    World = love.physics.newWorld(0, 0, true)
    worldScale = 3
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
                player.attributes.jet.speed = 150
                player.attributes.jet.turningSpeed = 0.1
                player.attributes.jet.image = love.graphics.newImage("textures/" .. theme .. "/player.png")
                player.attributes.jet.scale = 3
                player.attributes.jet.height = 10
                player.attributes.jet.WASDamingMode = true
                player.attributes.jet.cooldown = 0.1
                player.attributes.jet.cooldownTimer = player.attributes.jet.cooldown
    
    enemies = {}
    enemyStats = {
        tank = {
            texture = love.graphics.newImage("textures/" .. theme .. "/tank.png"),
            speed = 25,
            turningSpeed = 0.05,
            range = 3,
            cooldown = 0.5,
            reloadTime = 2,
            barrage = 2,
            target = "ground",
            projectile = "shell",
            isOnGround = true,
            dropCount = 2
        },
        jet1 = {
            texture = love.graphics.newImage("textures/" .. theme .. "/jet1.png"),
            speed = 100,
            turningSpeed = 0.025,
            range = 10,
            cooldown = 0.2,
            reloadTime = 3,
            barrage = 6,
            target = "optional",
            projectile = "missiles",
            isOnGround = false,
            dropCount = 6
        },
        mobileSurfaceToAir = {
            texture = love.graphics.newImage("textures/" .. theme .. "/antiair.png"),
            speed = 35,
            turningSpeed = 0.03,
            range = 30,
            cooldown = 0.1,
            reloadTime = 2,
            barrage = 10,
            target = "air",
            projectile = "missiles",
            isOnGround = true,
            dropCount = 7
        },
        mortar = {
            texture = love.graphics.newImage("textures/" .. theme .. "/tank.png"),
            speed = 1,
            turningSpeed = 1,
            range = 100,
            cooldown = 0.1,
            reloadTime = 5,
            barrage = 3,
            target = "ground",
            projectile = "grenade",
            isOnGround = true,
            dropCount = 4
        },
        jet2 = {
            texture = love.graphics.newImage("textures/" .. theme .. "/player.png"),
            speed = 120,
            turningSpeed = 0.015,
            range = 15,
            cooldown = 0.1,
            reloadTime = 3,
            barrage = 30,
            target = "air",
            projectile = "bullet",
            isOnGround = false,
            dropCount = 3
        },
        bomber1 = {
            texture = love.graphics.newImage("textures/" .. theme .. "/Bomber1.png"),
            speed = 75,
            turningSpeed = 0.02,
            range = 1,
            cooldown = 0.1,
            reloadTime = 5,
            barrage = 5,
            target = "ground",
            projectile = "bomb",
            isOnGround = false,
            dropCount = 5
        }
    }
    base = {}
        base.body = love.physics.newBody(World, 1000, 300, "dynamic")
        base.shape = love.physics.newCircleShape(10)
        base.fixture = love.physics.newFixture(base.body, base.shape)
    
    projectiles = {}
    tiles = {}
    
    
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
    
    particleSystem = love.graphics.newParticleSystem(player.attributes.jet.image, 256)
    particleSystem:setParticleLifetime(2, 3)
    end

function movePlayerInJet(dt)
    local wantedY = 0
    local wantedX = 0
    if player.attributes.jet.WASDamingMode then
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
    else
        wantedX = (love.mouse.getX() - love.graphics.getWidth() / 2 ) * worldScale
        wantedY = (love.mouse.getY() - love.graphics.getHeight() / 2 ) * worldScale
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
        player.x = player.fixture:getBody():getX()
        player.y = player.fixture:getBody():getY()
    end

    player.body:setLinearVelocity(math.cos(player.direction) * player.attributes.jet.speed, math.sin(player.direction) * player.attributes.jet.speed)

    cam.x = player.body:getX()
    cam.y = player.body:getY()
    if player.attributes.jet.cooldownTimer <= 0 then
        if love.mouse.isDown(1) then
            createProjectile("bullet" ,player.body:getX() , player.body:getY() ,player.direction , 100 ,currentSpeed)
            player.attributes.jet.cooldownTimer = player.attributes.jet.cooldown
        end
    else
        player.attributes.jet.cooldownTimer = player.attributes.jet.cooldownTimer - dt
    end

end
function createEnemy(type)
    local enemyTemplate = enemyStats[type]

    local enemy = {}  
        enemy.texture = enemyTemplate.texture
        enemy.body = love.physics.newBody(World, math.random(-1000, 1000), math.random(-1000, 1000), "dynamic")
        enemy.shape = love.physics.newCircleShape(10)
        enemy.fixture = love.physics.newFixture(enemy.body, enemy.shape)
        enemy.x = 0
        enemy.y = 0
        enemy.speed = enemyTemplate.speed
        enemy.turningSpeed = enemyTemplate.turningSpeed
        enemy.range = enemyTemplate.range
        enemy.cooldown = enemyTemplate.cooldown
        enemy.cooldownTimer = enemy.cooldown

        enemy.reloadTime = enemyTemplate.reloadTime
        enemy.reloadTimer = enemy.reloadTime

        enemy.barrage = enemyTemplate.barrage
        enemy.barrageCounter = enemy.barrage

        enemy.target = enemyTemplate.target
        enemy.projectile = enemyTemplate.projectile
        enemy.lockedTarget = player.fixture
        enemy.direction = 0 * math.pi
    if enemyTemplate.isOnGround then
        enemy.height = 1
    else
        enemy.height = 10
    end
    table.insert(enemies, enemy)
end

function updateEnemies(dt)
    for i, enemy in ipairs(enemies) do
        for j, tile in ipairs(tiles) do
            if love.physics.getDistance(enemy.fixture, tile.fixture) < love.physics.getDistance(enemy.fixture, enemy.lockedTarget) then
                enemy.lockedTarget = player.fixture
            end
        end
        local wantedX = enemy.lockedTarget:getBody():getX() - enemy.x
        local wantedY = enemy.lockedTarget:getBody():getY() - enemy.y
        local currentVelocityX, currentVelocityY = enemy.body:getLinearVelocity()
        local currentSpeed = math.sqrt(currentVelocityX^2 + currentVelocityY^2)
        local directionDifference = 0

        if currentSpeed > 0 then
            local currentDirection = math.atan2(currentVelocityY, currentVelocityX)
            enemy.direction = currentDirection
        end

        if wantedX ~= 0 or wantedY ~= 0 then
            local wantedDirection = math.atan2(wantedY, wantedX)

            -- Calculate the difference between the wanted direction and player's current direction
            directionDifference = wantedDirection - enemy.direction

            -- Ensure smooth turning within [-pi, pi] range
            if directionDifference > math.pi then
                directionDifference = directionDifference - 2 * math.pi
            elseif directionDifference < -math.pi then
                directionDifference = directionDifference + 2 * math.pi
            end
        end
        local wantedDirection = math.atan2(wantedY, wantedX)
        enemy.direction = enemy.direction + directionDifference * enemy.turningSpeed
        enemy.body:setLinearVelocity(math.cos(enemy.direction) * enemy.speed, math.sin(enemy.direction) * enemy.speed)
        enemy.x = enemy.body:getX()
        enemy.y = enemy.body:getY()
        
        
        if enemy.reloadTimer <= 0 then
            if enemy.cooldownTimer < 0 then
                createProjectile(enemy.projectile, enemy.x, enemy.y, enemy.direction, 150, currentSpeed)
                enemy.cooldownTimer = enemy.cooldown
                enemy.barrageCounter = enemy.barrageCounter - 1
                if enemy.barrageCounter <= 0 then
                    enemy.reloadTimer = enemy.reloadTime
                end
            else
                enemy.cooldownTimer = enemy.cooldownTimer - dt
            end
        else
            enemy.barrageCounter = enemy.barrage
            enemy.reloadTimer = enemy.reloadTimer - dt
        end
    
    end
end


function createProjectile(type, x, y, direction, speed, momentum) 
    
    local projectile = {}
        projectile.direction = direction
        projectile.body = love.physics.newBody(World, x + math.cos(projectile.direction) * 10, y + math.sin(projectile.direction) * 10, "dynamic")
        projectile.shape = love.physics.newCircleShape(1)
        projectile.fixture = love.physics.newFixture(projectile.body, projectile.shape)
        
        projectile.body:setLinearVelocity(math.cos(projectile.direction) * (speed + momentum), math.sin(projectile.direction) * (speed + momentum))
        particleSystem:setPosition(projectile.body:getX(), projectile.body:getY())
        particleSystem:setRotation(projectile.direction)
        particleSystem:emit(32)

    table.insert(projectiles, projectile)
end
function updateProjectiles(dt)
    for i = #projectiles, 1, -1 do
        local projectile = projectiles[i]
        for j, enemy in ipairs(enemies) do
            
        end
    end
end

function drawProjectiles() 
    for i, projectile in ipairs(projectiles) do
        love.graphics.circle("line", projectile.body:getX(), projectile.body:getY(), 1)
    end
end


function drawEnemies()
    for i, enemy in ipairs(enemies) do
        -- draw enemy shadow
        love.graphics.setColor(0, 0, 0, 0.5)
        love.graphics.draw(enemy.texture, enemy.x, enemy.y  + enemy.height, enemy.direction + 0.5 * math.pi, 1, 1, enemy.texture:getWidth() / 2, enemy.texture:getHeight() / 2)  
        -- draw enemy
        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(enemy.texture, enemy.x, enemy.y, enemy.direction + 0.5 * math.pi, 1, 1, enemy.texture:getWidth() / 2, enemy.texture:getHeight() / 2)    
    end
end








function love.update(dt)
    mouseX = (love.mouse.getX() - love.graphics.getWidth() / 2 ) * worldScale
    mouseY = (love.mouse.getY() - love.graphics.getHeight() / 2 ) * worldScale
    updateEnemies(dt)
    updateProjectiles()
    particleSystem:update(dt)
    if player.attributes.isInJet then
        movePlayerInJet(dt)
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
    drawEnemies()
    drawProjectiles()
    love.graphics.draw(particleSystem, 0 ,0)
    -- draw player jet shadow
    love.graphics.setColor(0, 0, 0, 0.5)
    love.graphics.draw(player.attributes.jet.image, playerX, playerY + player.attributes.jet.height, player.direction + math.pi / 2, 1, 1, player.attributes.jet.image:getWidth() / 2, player.attributes.jet.image:getHeight() / 2)
    -- Draw the player jet
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(player.attributes.jet.image, playerX, playerY, player.direction + math.pi / 2, 1, 1, player.attributes.jet.image:getWidth() / 2, player.attributes.jet.image:getHeight() / 2)
    -- Draw Enemies
    
    cam:detach()
end



function love.keypressed(key, scancode, isrepeat)
    if key == "escape" then 
        fullscreen = not fullscreen
        love.window.setFullscreen(fullscreen, "desktop") 	
    end 
    if key == "e" then 
        createEnemy("tank")
    end 
    if key == "q" then 
        player.attributes.jet.WASDamingMode = not player.attributes.jet.WASDamingMode
    end 
    if key == "space" then
        createProjectile("bullet",player.body:getX(), player.body:getY(), player.direction, 200)
    end
end
--Hello World