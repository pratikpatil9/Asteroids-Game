require 'globals'
local love = require('love')
local Player = require('Objects/Player')
local Game = require "State/Game"
math.randomseed(os.time())
function love.load()
    love.mouse.setVisible(false)
    Mouse_x,Mouse_y = 0,0

    local show_debugging = true
    player = Player(show_debugging)

    game = Game()
    game:startNewGame(player)
end

function love.keypressed(key)
    if game.state.running then
        if key == "w" or key == "up" or key == "kp8" then
            player.thrusting = true
        end

        if key == "space" or key == "down" or key == "kp5" then
            player.shooting = true
        end

        if key == "escape" then
            game:changeGameState("paused")
            print(game.state.paused)
        end
    elseif game.state.paused then
        if key == "escape" then
            game:changeGameState("running")
        end
    end
        
end

function love.mousepressed(x, y, button, isTouch, presses)
    if button == 1 then
        if game.state.running then
            player.shooting = true
        end
    end
end

function love.mousereleased(x, y, button, isTouch, presses)
    if button == 1 then
        if game.state.running then
            player.shooting = false
        end
    end
end
    
function love.keyreleased(key)
    if game.state.running then
        if key == "w" or key == "up" or key == "kp8" then
            player.thrusting = false
        end
         if key == "space" or key == "down" or key == "kp5" then
            player.shooting = false
        end
    end
        
end
function love.update(dt)
    Mouse_x,Mouse_y = love.mouse.getPosition()
    if game.state.running then
        player:move(dt)
        for index,asteroid in pairs(G_asteroids) do
            asteroid:move(dt)
            if not player.exploading then
                if calculateDistance(player.x, player.y, asteroid.x, asteroid.y) < asteroid.radius then
                    player:expload(dt)
                    destory_ast = true
                end
            else
                player.expload_time = player.expload_time - 1
            end
            for _,lazer in pairs(player.lazers) do
                if calculateDistance(lazer.x, lazer.y, asteroid.x, asteroid.y) < asteroid.radius then
                    lazer:expload(dt)
                    asteroid:destroy(G_asteroids, index)
                end
            end

            if destory_ast then
                destory_ast = false
                asteroid:destroy(G_asteroids, index)
            end
        end

        player:shootLazers()
    end
end


function love.draw()
    if game.state.running or game.state.paused then
        player:drawLives(game.state.paused)
        player:draw(game.state.paused)
        for _,asteroid in pairs(G_asteroids) do
            asteroid:draw(game.state.paused)
        end
        game:draw(game.state.paused)
    end
end