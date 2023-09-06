function love.load()
    love.physics.setMeter(64)
    World = love.physics.newWorld(0, 0, true)
    player = {}
    player.body = love.physics.newBody(World, 0, 300, "dynamic")
    player.shape = love.physics.newCircleShape(10)
    player.fixture = love.physics.newFixture(player.body, player.shape)
    player.direction = 0 * math.pi
    player.attributes = {}
    player.attributes.speed = 10
    player.attributes.turningSpeed = 0.01
    cam = {}
end

function movePlayer()
    local wantedDirection = player.direction
    if love.keyboard.isDown("w") then
        wantedDirection = 1.5 * math.pi
    elseif love.keyboard.isDown("s") then
        wantedDirection = 0.5 * math.pi
    elseif love.keyboard.isDown("a") then
        wantedDirection = math.pi
    elseif love.keyboard.isDown("d") then
        wantedDirection = 0
    end

    local directionDifference = wantedDirection - player.direction
    player.direction = player.direction + directionDifference * player.attributes.turningSpeed
    player.body:setLinearVelocity(math.cos(player.direction) * player.attributes.speed, math.sin(player.direction) * player.attributes.speed)
end

function love.update(dt)
    movePlayer()
    World:update(dt)
end

function love.draw()
    love.graphics.push()
        love.graphics.scale(1)
        
        love.graphics.circle("fill", player.body:getX(), player.body:getY(), 10)
        love.graphics.rectangle("fill", 0, 0, 200, 20)
    love.graphics.pop()
end
