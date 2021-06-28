

local function checkCollision(object1,object2)
    if (object1.x + 50 > object2.x and object1.x < object2.x + 50) and (object1.y + 50 > object2.y and object1.y < object2.y + 50)  then
        return true
    else
        return false
    end
end

local function wasVerticallyAlligned(object1,object2)
    return (object1.y + 50 > object2.y) and (object1.y < object2.y + 50)
end

local function wasHorizontallyAlligned(object1,object2)
    return (object1.x + 50 > object2.x) and (object1.x < object2.x + 50)
end

local function createWall(x,y)
    local wall = {
        image = love.graphics.newImage("Wall.png"),
        x = x,
        y = y,
        sx = 1,
        sy = 1,
        type = "wall"
    }


    return wall
end

local function resolveCollision(object1,object2)
    local xCentre1 = object1.x + 25 -- 24 is half the width of each tile
    local xCentre2 = object2.x + 25

    local yCentre1 = object1.y + 25
    local yCentre2 = object2.y + 25

    local xOverlap = 0
    local yOverlap = 0

    -- Resolve X direction first then Y direction second

    -- Assume player can ONLY collide from the right or the left, they can't collide at a corner.


    if wasVerticallyAlligned(object1,object2) then
        if xCentre1 < xCentre2 then

            xOverlap = object1.x + 50 - object2.x
            object1.x = object1.x - xOverlap
        else
            xOverlap = (object2.x + 50) - object1.x
            object1.x = object1.x + xOverlap
        end



    elseif wasHorizontallyAlligned(object1,object2) then
        if yCentre1 < yCentre2 then
            yOverlap = (object1.y + 50) - object2.y
            object1.y = object1.y - yOverlap
        else
            yOverlap = object2.y+50 - (object1.y)
            object1.y = object1.y + yOverlap
        end
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
        y = 250,
        sx = 1,
        sy = 1,
        type = "player"
    }

    testCentreX = 0
    testCentreY = 0

    -- Walls contained here
    wallList = {}

    -- Tilemap Being Made

    map = {
        {1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
        {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
        {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
        {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
        {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
        {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
        {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
        {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
        {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
        {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
        {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
        {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
        {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,1},
        {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,1,1,1,0,0,0,0,0,0,0,0,0,0,0,1},
        {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,1},
        {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,1,1,1,1,1,0,0,0,0,0,0,0,0,0,1},
        {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,1,1,1,1,1,1,0,0,0,0,0,0,0,0,1},
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
        player.y = player.y + 1
    end

    -- Every frame check collisions vs the walls in the walls list and the player.
    for i=1, #wallList do
        if checkCollision(player,wallList[i]) then

            resolveCollision(player,wallList[i])

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
