-- Runs the moment the game starts (global variables, window size etc...)
function love.load()
    -- Target Table
    target = {}
    target.choice = 0
    target.x = 300
    target.y = 300
    target.radius = 50
    
    -- tracks game score
    score = 0

    -- tracks time
    timer = 0
    -- gameState determines if game is active or not. 1 is main menu, 2 is the game is playing.
    gameState = 1

    gameFont = love.graphics.newFont(40)

    -- creates a table for sprites
    sprites = {}
    -- adds each sprite to the table
    sprites.sky = love.graphics.newImage('sprites/sky.png')
    sprites.target = love.graphics.newImage('sprites/target.png')
    sprites.target2 = love.graphics.newImage('sprites/target2.png')
    sprites.crosshairs = love.graphics.newImage('sprites/crosshairs.png')
    -- makes the mouse no longer visible.
    love.mouse.setVisible(false)
end

-- This function runs as the game loop. It calls every frame of the game. dt stands for delta time
function love.update(dt)
    -- this runs every second, so by subtracting dt the counter will go down 1 every second.
    -- we only want the timer counting down if the number is greater then 0, so we control that with the if statement.
    -- in case the counter does go below zero, the other if statement will catch it and force the number to zero.
    if timer > 0 then
        timer = timer - dt
    end
    if timer < 0 then
        timer = 0
        -- this resets the game when the timer hits 0
        gameState = 1
    end
end

-- this draws graphics and images to the screen.
function love.draw()
    --[[ 
    this draws the background image. 
    Since drawn items stack on top of each other, the background is first since all other items are drawn on top of it.
    ]]
    love.graphics.draw(sprites.sky, 0, 0)    
    -- set colors of font to white. it was using red before because of previous color declaration for circle.
    love.graphics.setColor(1,1,1)
    -- sets font to global variable gameFont
    love.graphics.setFont(gameFont)
    -- prints score in the upper left corner of screen
    love.graphics.print("Score: " .. score,5, 5)
    -- prints timer in the upper centerish of the screen
    -- math.ceil rounds the number up to the next highest integer, this prevents the decimal from showing.
    love.graphics.print("Time: " .. math.ceil(timer),300, 5)

    if gameState == 1 then
        love.graphics.printf("Click anywhere to begin", 0, 250, love.graphics.getWidth(), "center")
    end

    -- this draws the target sprite and assigns the position to the targetX and targetY position.
    --  also, you need to subtract the target.radius to correct for the offset position of the PNG
    -- the target being drawn should only run when game is active.
    -- target.choice determines which target will be selected
    if gameState == 2 then
        if target.choice == 1 then
        love.graphics.draw(sprites.target, target.x - target.radius, target.y - target.radius)        
        else 
            love.graphics.draw(sprites.target2, target.x - target.radius, target.y - target.radius)        
        end
    end
    -- this draws the crosshair sprite, and assigns the position to the mouseX and mouseY position.
    --  also, you need to subtract the PNG size to correct for the offset position of the PNG
    love.graphics.draw(sprites.crosshairs, love.mouse.getX()-20, love.mouse.getY()-20)    
end

--More details in link below. Using mouse pressed to determine if left click is clicking the circle to increase score.
--https://love2d.org/wiki/love.mousepressed
-- mousePressed should only run when game is active.
function love.mousepressed( x, y, button, istouch, presses )
    if button == 1 and gameState == 2 then
        -- create a local variable since this only needs calculated within love.mousepressed
        -- using the distancebetween function, x,y paramaters are passed from mousepressed
        -- using the distance between fuction, target.x and targety are passed from global variable.
        local mouseToTarget = distanceBetween(x, y, target.x, target.y)
        if mouseToTarget < target.radius then
            -- increases the score by 1 if target, if target2 is worth 2 pts plus timer increase
            if target.choice == 1 then
            score = score + 1
            else
            score = score + 2
            timer = timer + 1
            end
            -- this will determine a new random position for the target to go.
            -- math.random(0,0) you select a range of numbers you want to randomly select from. 
            -- using target.radius as the minimum will always keep the circle within view of the window.
            -- using the love.graphicsgetWidth - target.radius 
            --  and love.graphicsgetHeight - target.radius will keep the circle from going off the screen.
            target.x = math.random(target.radius,love.graphics.getWidth() - target.radius)
            target.y = math.random(target.radius,love.graphics.getHeight() - target.radius)
            -- target.choice will select from two different colored targets.
            target.choice = math.random(1,2)
        end
    -- this activates the game when user clicks mouse 1
    -- this also sets the timer to 10
    -- this also sets the score to 0
    elseif button == 1 and gameState == 1 then
        gameState = 2
        timer = 10
        score = 0
    end
end

-- in order to properly calculate the distance between where the mouse was clicked, and the target, we have to use the distance formula.
-- this function below will allow us to use the distanceBetween() function and return the distance between the target and mousepress location
function distanceBetween(x1, y1, x2, y2)
    return math.sqrt( (x2 - x1)^2 + (y2 - y1)^2 )
end