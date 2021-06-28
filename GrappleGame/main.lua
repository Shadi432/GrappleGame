

local function checkCollision(object1,object2)
    if (object1.x + 50 > object2.x and object1.x < object2.x + 50) and (object1.y + 50 > object2.y and object1.y < object2.y + 50)  then
        return true
    else
        return false
    end
end

local function createWall(x,y)
    local wall = {
        image = love.graphics.newImage("Wall.png"),
        x = x,
        y = y,
        sx = 1,
        sy = 1
    }


    return wall
end

local function resolveCollision(object1,object2)
    local centre1 = object1.x + 24
    local centre2 = object2.x + 24

    if centre1 >= centre2 then
        left = false
        right = true
    elseif centre1 < centre2 then
        right = false
        left = true
    end
end

function love.load()
    -- 50 by 50 game
    love.window.setFullscreen(true)
    love.graphics.setBackgroundColor(1,1,1)

    -- Defining the player
    player = {
        image = love.graphics.newImage("Player.png"),
        x = 700,
        y = 50,
        sx = 1,
        sy = 1
    }

    testCentreX = 0
    testCentreY = 0

    -- Walls contained here
    wallList = {}

    -- Tilemap Being Made

    map = {
        {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
        {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
        {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
        {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
        {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
        {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
        {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
        {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
        {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
        {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
        {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
        {1,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
        {1,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,1},
        {1,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,1},
        {1,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,1},
        {1,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,1},
        {1,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,1},
        {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1}
    }


    for y=1, #map do
        for x=1, #map[y] do
            if map[y][x] == 1 then
                table.insert(wallList,createWall((x-1)*50,(y-1)*50))
            end
        end
    end
end





function love.update(dt)
    if love.keyboard.isDown("right") then
        player.x = player.x + 2
    elseif love.keyboard.isDown("left") then
        player.x = player.x - 2
    end

    if player.y < 1025 then
        player.y = player.y + 0.5
    end

    -- Every frame check collisions vs the walls in the walls list and the player.
    for i=1, #wallList do
        if checkCollision(player,wallList[i]) then

            resolveCollision(player,wallList[i])

            print("Collision detected: " .. dt)
        end
    end
end



function love.draw()
    love.graphics.setColor(1,1,1)
    love.graphics.draw(player.image,player.x,player.y,0,player.sx,player.sy)



    for i=1, #wallList do
        love.graphics.draw(wallList[i].image,wallList[i].x,wallList[i].y,0,wallList[i].sx,wallList[i].sy)
    end

    -- Test graphics

    love.graphics.setColor(235/255, 225/255, 52/255)
    
    if left then
        love.graphics.rectangle("fill",50,20,50,50)
    elseif right then
        love.graphics.rectangle("fill",1300,20,50,50)
    end
end
