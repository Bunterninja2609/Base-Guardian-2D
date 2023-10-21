--Variables
    love.physics.setMeter(64)
    love.graphics.setDefaultFilter("nearest", "nearest")
    love.window.setFullscreen(true, "desktop")
    World = love.physics.newWorld(0, 0, true)
    baseZoom = 3
    additionalZoom = 0
    worldScale = baseZoom + additionalZoom
    theme = "2023"
    particle1 = love.graphics.newImage("textures/"..theme.."/particle1.png")
    selectedTower = "gun"
    worldColor = {0.1,0.1,0.1}

    collisionClass = {
        air = 1,
        ground = 2,
        friendly = 3,
        enemy = 4,
        projectile = 5
    }
    -- Temporary Background
    grassImage = love.graphics.newImage("textures/" .. theme .. "/grass.png")
    grassTextures = {}
    grassTextures[1] = love.graphics.newQuad(0, 0, 32, 32, grassImage)
    grassTextures[2] = love.graphics.newQuad(32, 0, 32, 32, grassImage)
    grassTextures[3] = love.graphics.newQuad(32, 32, 32, 32, grassImage)
    grassTextures[4] = love.graphics.newQuad(0, 32, 32, 32, grassImage)

    player = {}
        player.buildmode = false
        player.buildZoom = 2
        player.body = love.physics.newBody(World, 1000, 300, "dynamic")
        player.shape = love.physics.newCircleShape(5)
        player.fixture = love.physics.newFixture(player.body, player.shape)
        player.fixture:setCategory(collisionClass.friendly, collisionClass.ground)
        player.fixture:setMask(collisionClass.ground, collisionClass.enemy, collisionClass.friendly)
            player.jet = {}
            player.jet.body = love.physics.newBody(World, 0, 300, "dynamic")
            player.jet.shape = love.physics.newCircleShape(10)
            player.jet.fixture = love.physics.newFixture(player.jet.body, player.jet.shape)
            player.jet.fixture:setCategory(collisionClass.friendly, collisionClass.air)
            player.jet.fixture:setMask(collisionClass.ground, collisionClass.enemy, collisionClass.friendly)
            player.jet.direction = 0 * math.pi
            player.jet.wantedDirection = 0 * math.pi
            
            player.attributes = {}
                player.attributes.isInJet = true
                player.attributes.jet = {}
                    player.attributes.jet.health = 200
                    player.attributes.jet.maxHealth = 200
                    player.attributes.jet.speed = 150
                    player.attributes.jet.turningSpeed = 0.05
                    player.attributes.jet.image = love.graphics.newImage("textures/" .. theme .. "/player.png")
                    player.attributes.jet.crosshair = love.graphics.newImage("textures/" .. theme .. "/crosshair.png")
                    player.attributes.jet.scale = 3
                    player.attributes.jet.height = 10
                    player.attributes.jet.WASDamingMode = true
                    player.attributes.jet.cooldown = 0.1
                    player.attributes.jet.cooldownTimer = player.attributes.jet.cooldown

                    player.attributes.jet.upgrades = {
                        research = {
                            isBought = false,
                            price = {7,"gold"},
                            unlocked = {
                                mobility = {
                                    isBought = true,
                                    price = {0, "free"},
                                    unlocked = {}
                                },
                                weapons = {},
                                shields = {}
                            }
                        }
                    }
        
    enemies = {}
    enemyStats = {
        tank = {
            texture = love.graphics.newImage("textures/" .. theme .. "/tank.png"),
            speed = 25,
            health = 60,
            turningSpeed = 0.05,
            range = 100,
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
            speed = 30,
            health = 10,
            turningSpeed = 0.025,
            range = 150,
            cooldown = 0.2,
            reloadTime = 3,
            barrage = 6,
            target = "optional",
            projectile = "missile",
            isOnGround = false,
            dropCount = 6
        },
        mobileSurfaceToAir = {
            texture = love.graphics.newImage("textures/" .. theme .. "/antiair.png"),
            speed = 40,
            health = 50,
            turningSpeed = 0.03,
            range = 150,
            cooldown = 0.1,
            reloadTime = 5,
            barrage = 5,
            target = "air",
            projectile = "missile",
            isOnGround = true,
            dropCount = 7
        },
        mortar = {
            texture = love.graphics.newImage("textures/" .. theme .. "/tank.png"),
            speed = 1,
            health = 30,
            turningSpeed = 1,
            range = 1000,
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
            health = 60,
            turningSpeed = 0.015,
            range = 175,
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
            health = 200,
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
        base.body = love.physics.newBody(World, 1000, 300, "static")
        base.shape = love.physics.newChainShape(true, 32, 0, 16, 0, 0, 16, 0, 48, 16, 64, 32, 64,  32,57, 16, 57, 7, 48, 7, 16, 16, 7, 32, 7)
        base.fixture = love.physics.newFixture(base.body, base.shape)
        base.texture = love.graphics.newImage("textures/" .. theme .. "/base.png")
        base.layer1 = love.graphics.newQuad(32, 0, 32, 64, base.texture)
        base.layer2 = love.graphics.newQuad(0, 0, 32, 64, base.texture)
        base.communictaionDistance = 64

    projectiles = {}
    projectileTemplates = {
        bullet = {
            speed = 200,
            dmg = 10,
            aoe = 0,
            hasAutoAim = false
        },
        missile = {
            speed = 150,
            dmg = 20,
            aoe = 10,
            hasAutoAim = true
        },
        shell = {
            speed = 60,
            dmg = 15,
            aoe = 0,
            hasAutoAim = false
        },
        bomb = {
            speed = 10,
            dmg = 90,
            aoe = 15,
            hasAutoAim = false
        },
        grenade = {
            speed = 10,
            dmg = 20,
            aoe = 15,
            hasAutoAim = false
        }
    }
    tiles = {}
    towertemplates = {
        communication = {
            texture = love.graphics.newImage("textures/".. theme .. "/tower/communication.png"),
            range = 50,
            isCommunication = true,
            cooldown = 0,
            barrage = 0,
            projectile = "none",
            target = "none",
            health = 200,

        },
        bigCommunication = {
            texture = love.graphics.newImage("textures/".. theme .. "/tower/communication.png"),
            range = 100,
            isCommunication = true,
            cooldown = 0,
            barrage = 0,
            projectile = "none",
            target = "none",
            health = 250,

        },
        gun = {
            texture = love.graphics.newImage("textures/".. theme .. "/tower/gun.png"),
            range = 200,
            isCommunication = false,
            cooldown = 0.5,
            barrage = 10,
            projectile = "bullet",
            target = "optional",
            health = 300,

        },
        minigun = {
            texture = love.graphics.newImage("textures/".. theme .. "/tower/minigun.png"),
            range = 100,
            isCommunication = false,
            cooldown = 0.01,
            barrage = 20,
            projectile = "bullet",
            target = "optional",
            health = 400,

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
    particleSystem = {}
    particleSystem.muzzleFlash = love.graphics.newParticleSystem(love.graphics.newImage("textures/"..theme.."/particle1.png"), 256)
    particleSystem.muzzleFlash:setParticleLifetime(0, 0.2)
    explosions = {}

    mouseX = (cam.x + love.mouse.getX() / worldScale - love.graphics.getWidth() / 2 / worldScale)
    mouseY = (cam.y + love.mouse.getY() / worldScale - love.graphics.getHeight() / 2 / worldScale) 

    waves = 36
--
function movePlayer()
    local wantedY = 0
    local wantedX = 0
    baseZoom = 10
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
    player.body:setLinearVelocity(wantedX * 20,wantedY * 20)
    cam.x = player.body:getX()
    cam.y = player.body:getY()

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

    local currentVelocityX, currentVelocityY = player.jet.body:getLinearVelocity()
    local currentSpeed = math.sqrt(currentVelocityX^2 + currentVelocityY^2)

    if currentSpeed > 0 then
        local currentDirection = math.atan2(currentVelocityY, currentVelocityX)
        player.jet.direction = currentDirection
    end

    if wantedX ~= 0 or wantedY ~= 0 then
        player.jet.wantedDirection = math.atan2(wantedY, wantedX)

        -- Calculate the difference between the wanted direction and player's current direction
        local directionDifference = player.jet.wantedDirection - player.jet.direction

        -- Ensure smooth turning within [-pi, pi] range
        if directionDifference > math.pi then
            directionDifference = directionDifference - 2 * math.pi
        elseif directionDifference < -math.pi then
            directionDifference = directionDifference + 2 * math.pi
        end

        -- Apply smooth turning
        player.jet.direction = player.jet.direction + directionDifference * player.attributes.jet.turningSpeed
        player.jet.x = player.jet.fixture:getBody():getX()
        player.jet.y = player.jet.fixture:getBody():getY()

        if player.attributes.jet.health <= 0 then
            createExplosionParticles(player.jet.x, player.jet.y, 12, 5)
            player.attributes.isInJet = false
        end
    end

    player.jet.body:setLinearVelocity(math.cos(player.jet.direction) * player.attributes.jet.speed, math.sin(player.jet.direction) * player.attributes.jet.speed)

    cam.x = player.jet.body:getX()
    cam.y = player.jet.body:getY()
    baseZoom = player.attributes.jet.scale
    if player.attributes.jet.cooldownTimer <= 0 then
        if love.mouse.isDown(1) then
            createProjectile("bullet" ,player.jet.body:getX() , player.jet.body:getY() ,player.jet.direction , 500 ,currentSpeed, 15, 15, true, 100)
            player.attributes.jet.cooldownTimer = player.attributes.jet.cooldown
        end
    else
        player.attributes.jet.cooldownTimer = player.attributes.jet.cooldownTimer - dt
    end
end
function createWave()
    for i = 1, 8 * math.atan(waves^(1/3)), 1 do
        createEnemy("tank")
    end
    for i = 1, waves/3 - 5.5, 1 do
        createEnemy("mobileSurfaceToAir")
    end
    for i = 1, (math.cos((waves * math.pi)%1) + 1) * waves/4, 1 do
        createEnemy("mortar")
    end
    for i = 1, 2* 1.1^(waves-19)-0.3, 1 do
        createEnemy("jet1")
    end
    for i = 1, waves/3 - 9, 1 do
        createEnemy("jet2")
    end
    for i = 1, 0.0001 * 1.2^(waves+20)-2, 1 do
        createEnemy("bomber1")
    end
end
--enemies--
    function createEnemy(type)
        local enemyTemplate = enemyStats[type]

        local enemy = {}  
            enemy.texture = enemyTemplate.texture
            enemy.body = love.physics.newBody(World, 100, math.random(0, 100), "dynamic")
            enemy.body:setAngularDamping(1000)
            enemy.shape = love.physics.newCircleShape(enemy.texture:getWidth() / 2)
            enemy.fixture = love.physics.newFixture(enemy.body, enemy.shape)
            enemy.x = 0
            enemy.y = 0
            enemy.health = enemyTemplate.health
            enemy.maxHealth = enemyTemplate.health
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
            enemy.lockedTarget = base.fixture
            enemy.direction = 0 * math.pi
        if enemyTemplate.isOnGround then
            enemy.fixture:setCategory(collisionClass.enemy, collisionClass.ground)
            enemy.fixture:setMask(collisionClass.air, collisionClass.enemy)
            enemy.height = 1
        else
            enemy.fixture:setCategory(collisionClass.enemy, collisionClass.air)
            enemy.fixture:setMask(collisionClass.ground, collisionClass.enemy)
            enemy.height = 10
        end
        table.insert(enemies, enemy)
    end
    function updateEnemies(dt)
        for i, enemy in ipairs(enemies) do
            enemy.lockedTarget = player.jet.fixture
            if enemy.target == "ground" then    
                for j, tower in ipairs(tiles) do
                    if love.physics.getDistance(enemy.fixture, tower.fixture) < love.physics.getDistance(enemy.fixture, enemy.lockedTarget) then
                        enemy.lockedTarget = tower.fixture
                    end
                end
                if love.physics.getDistance(enemy.fixture, base.fixture) < love.physics.getDistance(enemy.fixture, enemy.lockedTarget)  or #tiles <= 0 then
                    enemy.lockedTarget = base.fixture
                end

            elseif enemy.target == "air" then
                enemy.lockedTarget = player.jet.fixture

            elseif enemy.target == "optional" then
                enemy.lockedTarget = player.jet.fixture
                for j, tower in ipairs(tiles) do
                    if love.physics.getDistance(enemy.fixture, tower.fixture) < love.physics.getDistance(enemy.fixture, enemy.lockedTarget) then
                        enemy.lockedTarget = tower.fixture
                    end
                end
                if love.physics.getDistance(enemy.fixture, base.fixture) < love.physics.getDistance(enemy.fixture, enemy.lockedTarget) or #tiles <= 0 then
                    enemy.lockedTarget = base.fixture
                end
                if love.physics.getDistance(enemy.fixture, player.fixture) < love.physics.getDistance(enemy.fixture, enemy.lockedTarget) then
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
            if love.physics.getDistance(enemy.fixture, enemy.lockedTarget) > enemy.range then
                enemy.body:setLinearVelocity(math.cos(enemy.direction) * enemy.speed, math.sin(enemy.direction) * enemy.speed)
            else
                enemy.body:setLinearVelocity(0, 0)
            end
            enemy.x = enemy.body:getX()
            enemy.y = enemy.body:getY()
            
            
            if enemy.reloadTimer <= 0 then
                if enemy.cooldownTimer < 0 and love.physics.getDistance(enemy.fixture, enemy.lockedTarget) < enemy.range + 50 then
                    createProjectile(enemy.projectile, enemy.x, enemy.y, enemy.direction, 150, currentSpeed, 7, 7, false, enemy.range, enemy.lockedTarget)
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
        
            if enemy.health <= 0 then
                createExplosionParticles(enemy.body:getX(), enemy.body:getY(), 8, 3)
                enemy.body:destroy()
                table.remove(enemies, i)
            end
        end
        
    end
    function drawEnemies()
        for i, enemy in ipairs(enemies) do
            -- draw enemy shadow
            love.graphics.setColor(0, 0, 0, 0.5)
            love.graphics.draw(enemy.texture, enemy.x, enemy.y  + enemy.height, enemy.direction + 0.5 * math.pi, 1, 1, enemy.texture:getWidth() / 2, enemy.texture:getHeight() / 2)  

            -- draw enemy
            love.graphics.setColor(worldColor)
            love.graphics.draw(enemy.texture, enemy.x, enemy.y, enemy.direction + 0.5 * math.pi, 1, 1, enemy.texture:getWidth() / 2, enemy.texture:getHeight() / 2)    
            love.graphics.draw(enemy.texture, enemy.x, enemy.y, enemy.direction + 0.5 * math.pi, 1, 1, enemy.texture:getWidth() / 2, enemy.texture:getHeight() / 2)
            love.graphics.setColor(1, 0, 0)   
            love.graphics.rectangle("fill", enemy.x  - enemy.texture:getWidth() / 2, enemy.y - enemy.texture:getHeight() / 2, enemy.texture:getWidth(), 3) 
            love.graphics.setColor(0, 1, 0)
            love.graphics.rectangle("fill", enemy.x  - enemy.texture:getWidth() / 2, enemy.y - enemy.texture:getHeight() / 2, enemy.texture:getWidth() * enemy.health / enemy.maxHealth, 3) 
        end
    end
--///////--

--projectiles--
    function createProjectile(type, x, y, direction, speed, momentum, offsetX, offsetY, isShotByPlayer, range, target) 
        local projectile = {}
            template = projectileTemplates[type]
            projectile.direction = direction
            projectile.timer = range
            projectile.body = love.physics.newBody(World, x + math.cos(projectile.direction) * offsetX, y + math.sin(projectile.direction) * offsetY, "dynamic")
            projectile.body:setAngularDamping(50)
            projectile.image = love.graphics.newImage("textures/" .. theme .. "/bullet.png")
            projectile.shape = love.physics.newCircleShape(1)
            projectile.fixture = love.physics.newFixture(projectile.body, projectile.shape)
            projectile.target = target
            projectile.speed = template.speed + momentum
            projectile.hasAutoAim = template.hasAutoAim
            projectile.body:setAngle(projectile.direction)

            projectile.damage = template.dmg
            projectile.fixture:setCategory(collisionClass.projectile)
            if not isShotByPlayer then
                projectile.fixture:setMask(collisionClass.projectile, collisionClass.enemy, collisionClass.ground, collisionClass.air)
            else
                projectile.fixture:setMask(collisionClass.projectile, collisionClass.friendly, collisionClass.ground, collisionClass.air)
            end
            projectile.isShotByPlayer = isShotByPlayer

            projectile.particle = {}
            projectile.particle.trail = love.graphics.newParticleSystem(love.graphics.newImage("textures/"..theme.."/particle1.png"), 256)
            projectile.particle.trail:setParticleLifetime(0, 0.17)
            projectile.particle.trail:setColors(1,1,0,1 ,1,0.5,0,1 ,0,0,0,1 ,0,0,0,0.5)
            projectile.particle.trail:setSpread(0.5)
            projectile.particle.trail:setSpeed(20, 30)
            projectile.particle.trail:setSizes(1, 2)
            projectile.particle.trail:setSizeVariation(0.5)

            projectile.body:setLinearVelocity(math.cos(projectile.direction) * projectile.speed, math.sin(projectile.direction) * projectile.speed)
            
            particleSystem.muzzleFlash:setColors(1,1,0,1 ,1,0.5,0,1 ,0,0,0,1)
            particleSystem.muzzleFlash:setSpread(0.5)
            particleSystem.muzzleFlash:setSpeed(100 + momentum, 200 + momentum)
            particleSystem.muzzleFlash:setPosition(projectile.body:getX(), projectile.body:getY())
            particleSystem.muzzleFlash:setDirection(projectile.direction)
            particleSystem.muzzleFlash:setSizes(0.5, 1.5)
            particleSystem.muzzleFlash:setSizeVariation(1)
            particleSystem.muzzleFlash:emit(64)

        table.insert(projectiles, projectile)
    end
    function updateProjectiles(dt)
        for i, projectile in ipairs(projectiles) do
            local shouldBreak = false
            if projectile.hasAutoAim then
                projectile.body:setAngle(math.atan2(projectile.target:getBody():getY() - projectile.body:getY(), projectile.target:getBody():getX() - projectile.body:getX()) + (-projectile.direction * 0.5))
                projectile.direction = projectile.body:getAngle()
                projectile.body:setLinearVelocity(math.cos(projectile.direction + math.random(-0.5 * math.pi, 0.5 * math.pi)) * projectile.speed, math.sin(projectile.direction + math.random(-0.5 * math.pi, 0.5 * math.pi)) * projectile.speed)
            end
            
            projectile.particle.trail:setSpeed(100, 200)
            projectile.particle.trail:setPosition(projectile.body:getX(), projectile.body:getY())
            projectile.particle.trail:setDirection(projectile.direction - math.pi * 1)
            projectile.particle.trail:emit(8)
            projectile.particle.trail:update(dt)
            if projectile.isShotByPlayer then
                for j, enemy in ipairs(enemies) do
                    if projectile.body:isTouching(enemy.body) then
                        createExplosionParticles(projectile.body:getX(), projectile.body:getY(), 3, 2)
                        projectile.body:destroy()
                        enemy.health = enemy.health - 10
                        table.remove(projectiles, i)
                        break
                    end
                end
            else
                if projectile.body:isTouching(player.jet.body) then
                    createExplosionParticles(projectile.body:getX(), projectile.body:getY(), 4, 2)
                    projectile.body:destroy()
                    player.attributes.jet.health = player.attributes.jet.health - 10
                    table.remove(projectiles, i)
                    break
                end
                for j, tower in ipairs(tiles) do
                    if projectile.body:isTouching(tower.body) then
                        createExplosionParticles(projectile.body:getX(), projectile.body:getY(), 3, 2)
                        projectile.body:destroy()
                        tower.health = tower.health - 10
                        table.remove(projectiles, i)
                        break
                    end
                end
            
            end
            projectile.timer = projectile.timer - 1
            if projectile.timer <= 0 and not projectile.body:isDestroyed() then
                createExplosionParticles(projectile.body:getX(), projectile.body:getY(), 2, 1)
                projectile.body:destroy()
                table.remove(projectiles, i)
            end
        end
    end
    function drawProjectiles() 
        for i, projectile in ipairs(projectiles) do
            love.graphics.setColor(0, 0, 0, 0.3)
            love.graphics.draw(projectile.particle.trail, 0 ,0 + projectile.timer / 10)
            
            love.graphics.draw(projectile.image, projectile.body:getX(), projectile.body:getY()  + projectile.timer / 10, projectile.direction + math.pi / 2, 1, 1, projectile.image:getWidth() / 2, projectile.image:getHeight() / 2)


            love.graphics.setColor(worldColor, 1)
            love.graphics.draw(projectile.particle.trail, 0 ,0)
            love.graphics.draw(projectile.image, projectile.body:getX(), projectile.body:getY(), projectile.direction + math.pi / 2, 1, 1, projectile.image:getWidth() / 2, projectile.image:getHeight() / 2)
        end
    end
--///////////--

--Explosion particles--
    function createExplosionParticles(x, y, strength, time)
        local explosion = {}
        explosion.particle = love.graphics.newParticleSystem(particle1, 2^10)
        explosion.particle:setColors(1,1,0,1 ,1,0.5,0,1 ,0,0,0,0.8)
        explosion.particle:setSpread(2 * math.pi)
        explosion.particle:setParticleLifetime(0.0,time)
        explosion.particle:setSizes(1, 5)
        explosion.particle:setSizeVariation(1)
        explosion.particle:setSpeed(0, 50)
        explosion.particle:moveTo(x, y)
        explosion.particle:emit(2^strength)
        table.insert(explosions, explosion)
    end
    function updateExplosionParticles(dt)
        for i, explosion in ipairs(explosions) do
            explosion.particle:update(dt)
        end
    end
    function drawExplosionParticles()
        for i, explosion in ipairs(explosions) do
            love.graphics.draw(explosion.particle, 0 , 0)
        end
    end
--///////////////////--

--towerdefense--
    function createTower(x, y, type)
        local isInCommunicationrange = false
        local isOverlapping = false
        for i, tower in ipairs(tiles) do
            if tower.isCommunication and math.sqrt((x - tower.x)^2 + (y - tower.y)^2) < tower.range and math.sqrt((x - tower.x)^2 + (y - tower.y)^2) > 16 then
                isInCommunicationrange = true
            end
        end
        if x < base.body:getX() and x > base.body:getX() - base.communictaionDistance then
            isInCommunicationrange = true
        end
        for i, tower in ipairs(tiles) do
            if math.sqrt((x - tower.x)^2 + (y - tower.y)^2) < 32 then
                isOverlapping = true
            end
        end

        if isInCommunicationrange and not isOverlapping then
            local template = towertemplates[type]
            local tower = {}
            tower.texture = template.texture
            tower.layer1 = love.graphics.newQuad(0, 0, tower.texture:getWidth() * 1/3, tower.texture:getHeight(), tower.texture)
            tower.layer2 = love.graphics.newQuad(0 + tower.texture:getWidth() * 1/3, 0, tower.texture:getWidth() * 1/3, tower.texture:getHeight(), tower.texture)
            tower.layer3 = love.graphics.newQuad(0 + tower.texture:getWidth() * 2/3, 0, tower.texture:getWidth() * 1/3, tower.texture:getHeight(), tower.texture)
            tower.x = x
            tower.y = y
            tower.isCommunication = template.isCommunication
            tower.range = template.range
            tower.type = template.type
            tower.maxHealth = template.health
            tower.health = template.health
            tower.cooldown = template.cooldown
            tower.cooldownTimer = template.cooldown
            tower.barrage = template.barrage
            tower.direction = 0 * math.pi
            tower.target = "none"
            tower.body = love.physics.newBody(World, tower.x, tower.y, "static")
            tower.shape = love.physics.newCircleShape(tower.texture:getHeight() / 2)
            tower.fixture = love.physics.newFixture(tower.body, tower.shape)
            tower.fixture:setCategory(collisionClass.ground, collisionClass.friendly)
            tower.isConnected = true
            table.insert(tiles, tower)
        end
    end
    function updateTower(dt)
        for i, tower in ipairs(tiles) do
            if not (tower.target == "none" or tower.target:isDestroyed()) then
                for j, enemy in ipairs(enemies) do
                    if love.physics.getDistance(tower.fixture, enemy.fixture) < love.physics.getDistance(tower.fixture, tower.target) then
                        tower.target = enemy.fixture
                        tower.direction = math.atan2(tower.target:getBody():getY() - tower.y, tower.target:getBody():getX() - tower.x)  
                    end
                end
            elseif tower.target == "none" or tower.target:isDestroyed()then
                if #enemies > 0 then
                    tower.target = enemies[1].fixture
                end
                for j, enemy in ipairs(enemies) do
                    if love.physics.getDistance(tower.fixture, enemy.fixture) < love.physics.getDistance(tower.fixture, tower.target) then
                        tower.target = enemy.fixture
                        tower.direction = math.atan2(tower.target:getBody():getY() - tower.y, tower.target:getBody():getX() - tower.x)  
                    end
                end
                if tower.target == "none" then
                    tower.direction = math.pi
                end
            elseif tower.target:isDestroyed() then
                tower.target = "none"
            end

            if tower.cooldownTimer <= 0 and not tower.isCommunication and tower.target ~= "none" then
                createProjectile("bullet", tower.x, tower.y, tower.direction, 100, 0, 1, 1, true, 300)
                tower.cooldownTimer = tower.cooldown
            else
                tower.cooldownTimer = tower.cooldownTimer - dt
            end

            if tower.health <= 0 then
                createExplosionParticles(tower.x, tower.y, 10, 1)
                tower.body:destroy()
                table.remove(tiles, i)
            end
        end
    end
    function drawTower()
        for i, tower in ipairs(tiles) do
            if tower.isCommunication and player.buildmode then
                love.graphics.setColor(0, 1, 0, 0.3)
                love.graphics.circle("fill", tower.x, tower.y, tower.range)
                love.graphics.setColor(0, 1, 0, 0.3)
                love.graphics.circle("line", tower.x, tower.y, tower.range)
            end
        end
        for i, tower in ipairs(tiles) do
            love.graphics.setColor(0, 0, 0, 0.5)
            love.graphics.draw(tower.texture, tower.layer1, tower.x, tower.y + 1, 0, 1, 1, tower.texture:getWidth() / 6, tower.texture:getHeight() / 2)

            love.graphics.setColor(1,1,1)
            love.graphics.draw(tower.texture, tower.layer1, tower.x, tower.y, 0, 1, 1, tower.texture:getWidth() / 6, tower.texture:getHeight() / 2)
 
            love.graphics.setColor(0, 0, 0, 0.5)
            love.graphics.draw(tower.texture, tower.layer2, tower.x, tower.y + 1, tower.direction + 0.5 * math.pi, 1, 1, tower.texture:getWidth() / 6, tower.texture:getHeight() / 2)

            love.graphics.setColor(1,1,1)
            love.graphics.draw(tower.texture, tower.layer2, tower.x, tower.y, tower.direction + 0.5 * math.pi, 1, 1, tower.texture:getWidth() / 6, tower.texture:getHeight() / 2)

            love.graphics.setColor(0, 0, 0, 0.5)
            love.graphics.draw(tower.texture, tower.layer3, tower.x, tower.y + 1, 0, 1, 1, tower.texture:getWidth() / 6, tower.texture:getHeight() / 2)

            love.graphics.setColor(worldColor)
            love.graphics.draw(tower.texture, tower.layer3, tower.x, tower.y, 0, 1, 1, tower.texture:getWidth() / 6, tower.texture:getHeight() / 2)

            love.graphics.setColor(1, 0, 0)   
        love.graphics.rectangle("fill", tower.x  - tower.texture:getWidth() / 6, tower.y - tower.texture:getHeight() / 2, tower.texture:getWidth() / 3, 1) 
        love.graphics.setColor(0, 1, 0)
        love.graphics.rectangle("fill", tower.x  - tower.texture:getWidth() / 6, tower.y - tower.texture:getHeight() / 2, (tower.texture:getWidth() * tower.health / tower.maxHealth) / 3, 1) 
        end
    end
--////////////--

--User Interface--
    function drawToggleButton(x, y, width, height, text, font, toggleTable, toggleKey)
        -- Check for mouse position and click
        local mouseX, mouseY = love.mouse.getPosition()

        -- Check if the mouse is within the button's boundaries
        local isMouseInsideButton = mouseX >= x and mouseX <= x + width and
                                    mouseY >= y and mouseY <= y + height

        -- Handle button click
        if love.mouse.isDown(1) and not mouseClick and isMouseInsideButton then
            toggleTable[toggleKey] = not toggleTable[toggleKey] 
            mouseClick = true  -- Set the flag to true when a tower is placed
        end
        if not love.mouse.isDown(1) then
            mouseClick = false
        end

        -- Draw button based on state
        if toggleTable[toggleKey] then
            love.graphics.setColor(0, 255, 0) -- Green when toggled on
        else
            love.graphics.setColor(255, 0, 0) -- Red when toggled off
        end

        love.graphics.rectangle("fill", x, y, width, height)

        -- Reset color to white for other drawing
        love.graphics.setColor(255, 255, 255)

        -- Draw text on the button
        local buttonText = toggleTable[toggleKey] and "ON" or "OFF"
        if text then
            buttonText = text
        end
        local textWidth = font:getWidth(buttonText)
        local textHeight = font:getHeight(buttonText)
        local textX = x + (width - textWidth) / 2
        local textY = y + (height - textHeight) / 2
        love.graphics.print(buttonText, textX, textY)
    end

    function drawPlayerHealthBar(x, y, width, heigth)

    
        love.graphics.setColor(1, 0 ,0)
        love.graphics.rectangle("fill", x, y, width, heigth)
        if player.attributes.jet.health / player.attributes.jet.maxHealth > 0 then
            love.graphics.setColor(0, 1 ,0)
            love.graphics.rectangle("fill", x, y, width * player.attributes.jet.health / player.attributes.jet.maxHealth, heigth)
        end
    end
--//////////////--
function love.update(dt)
    worldScale = baseZoom + additionalZoom
    mouseX = (cam.x + love.mouse.getX() / worldScale - love.graphics.getWidth() / 2 / worldScale)
    mouseY = (cam.y + love.mouse.getY() / worldScale - love.graphics.getHeight() / 2 / worldScale) 
    
    if player.buildmode then
        worldColor = {0.3,0.3,0.3}
        cam.x = base.body:getX()
        cam.y = base.body:getY()
        baseZoom = player.buildZoom
        if love.mouse.isDown(1) and not mouseClick then
            createTower(mouseX, mouseY, selectedTower)
            mouseClick = true  -- Set the flag to true when a tower is placed
        end

        if not love.mouse.isDown(1) then
            mouseClick = false
        end
    elseif player.attributes.isInJet then
        worldColor = {1,1,1}
        movePlayerInJet(dt)
    else
        worldColor = {1,1,1}
        movePlayer()
    end
    if not player.buildmode then
        updateEnemies(dt)
        updateProjectiles(dt)
        updateTower(dt)
        particleSystem.muzzleFlash:update(dt)
        updateExplosionParticles(dt)
        World:update(dt)
    end
end
function love.draw()
    love.graphics.setBackgroundColor(0.2, 0.6, 0.2)
    love.graphics.setColor(worldColor)
    cam:attach()
        local playerX, playerY = player.jet.body:getX(), player.jet.body:getY()
        
        -- Draw temporary Background
        for i = -40, 60, 1 do
            for j = -40, 60, 1 do
                love.graphics.draw(grassImage, grassTextures[(math.floor(i/2)+j)%3+1],i * 32,j * 32)
            end
        end
        drawEnemies()
        
        if player.buildmode then
            love.graphics.setColor(0, 1, 0, 0.3)
            love.graphics.rectangle("fill", base.body:getX(), - 10^10, - base.communictaionDistance, 10^20)
            love.graphics.setColor(0, 1, 0, 0.3)
            love.graphics.rectangle("line", base.body:getX(), - 10^10, - base.communictaionDistance, 10^20)
        end
        drawTower()
        love.graphics.setColor(worldColor)
        love.graphics.draw(base.texture, base.layer1, base.body:getX(), base.body:getY())
        drawProjectiles()
        
        -- draw player jet shadow
        love.graphics.setColor(0, 0, 0, 0.5)
        love.graphics.draw(player.attributes.jet.image, playerX, playerY + player.attributes.jet.height, player.jet.direction + math.pi / 2, 1, 1, player.attributes.jet.image:getWidth() / 2, player.attributes.jet.image:getHeight() / 2)
        -- Draw muzzle flash
        love.graphics.setColor(worldColor)
        love.graphics.draw(particleSystem.muzzleFlash, 0 ,0)
        
        -- Draw the player jet 
            love.graphics.draw(player.attributes.jet.image, playerX, playerY, player.jet.direction + math.pi / 2, 1, 1, player.attributes.jet.image:getWidth() / 2, player.attributes.jet.image:getHeight() / 2)
            drawExplosionParticles()

            love.graphics.draw(player.attributes.jet.crosshair, playerX + math.cos(player.jet.direction) * 50, playerY + math.sin(player.jet.direction) * 50, 0, 1, 1, player.attributes.jet.crosshair:getWidth() / 2, player.attributes.jet.crosshair:getHeight() / 2)
            love.graphics.setColor(1, 0, 0)
            love.graphics.draw(player.attributes.jet.crosshair, playerX + math.cos(player.jet.wantedDirection) * 50, playerY + math.sin(player.jet.wantedDirection) * 50, 0, 1, 1, player.attributes.jet.crosshair:getWidth() / 2, player.attributes.jet.crosshair:getHeight() / 2)
        -- Draw base layer 2

        love.graphics.circle("fill", player.body:getX(), player.body:getY(), 5)
        love.graphics.setColor(1, 1, 1, 1)
        if player.body:getX() > 0 + base.body:getX() and player.body:getX() < 32 + base.body:getX() and player.body:getY() > 0 + base.body:getY() and player.body:getY() < 64 + base.body:getY() then 
            love.graphics.setColor(1, 1, 1, 0.5)
        end
        love.graphics.draw(base.texture, base.layer2, base.body:getX(), base.body:getY())
        



    cam:detach()
    drawToggleButton(100, 100, 100, 50, "WASD Steering", love.graphics.getFont(), player.attributes.jet, "WASDamingMode")
    drawToggleButton(100, 200, 100, 50, "buildmode", love.graphics.getFont(), player, "buildmode")
    drawPlayerHealthBar(20, 20, 500, 10)
end

function love.keypressed(key, scancode, isrepeat)
    if key == "escape" then 
        fullscreen = not fullscreen
        love.window.setFullscreen(fullscreen, "desktop") 	
    end 
    if key == "m" then
        waves = waves + 1
        createWave()
    end 
    if key == "q" then 
        player.buildmode = not player.buildmode
    end 
    if key == "space" then 
        createTower(player.jet.body:getX(), player.jet.body:getY(), "gun")
    end 
    if key == "e" then
        player.attributes.isInJet = not player.attributes.isInJet
    end
    if key == "1" then
        selectedTower = "gun"
    end
    if key == "2" then
        selectedTower = "communication"
    end
    if key == "3" then
        selectedTower = "bigCommunication"
    end
    if key == "4" then
        selectedTower = "minigun"
    end


end

function love.wheelmoved(x, y)
    if player.buildmode then
        additionalZoom = additionalZoom + y / 100
    else
        additionalZoom = 0
    end
    if additionalZoom < -2 * worldScale then
        additionalZoom = -2 * worldScale
    end
end
--Hello World