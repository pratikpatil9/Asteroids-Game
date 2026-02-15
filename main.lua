require 'globals'
local love = require('love')
local Player = require('Objects/Player')
local Game = require "State/Game"
local Menu = require "State.Menu"
math.randomseed(os.time())
function love.load()
    love.mouse.setVisible(false)
    local save_data = readJSON("save.json")
    mouse_x,mouse_y = 0,0
    mouse_radius = 10
    player = Player()
    game = Game(save_data)
    menu = Menu(game, player)
    clicked_mouse = false
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
        else
            clicked_mouse = true
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
    mouse_x,mouse_y = love.mouse.getPosition()
    if game.state.running then
        player:move(dt)
        for index,asteroid in pairs(G_asteroids) do
            asteroid:move(dt)
            if not player.exploading then
                if calculateDistance(player.x, player.y, asteroid.x, asteroid.y) < asteroid.radius then
                    player:expload(dt)
                    destroy_ast = true
                end
            else
                player.expload_time = player.expload_time - 1
                if player.expload_time == 0 then
                    if player.lives - 1 <=  0 then
                        game:changeGameState("ended")
                        game:gameOver()
                        return
                    end
                    player = Player(player.lives - 1)
                end
            end
            for _,lazer in pairs(player.lazers) do
                if calculateDistance(lazer.x, lazer.y, asteroid.x, asteroid.y) < asteroid.radius then
                    lazer:expload(dt)
                    asteroid:destroy(G_asteroids, index)
                end
            end

            if destroy_ast then
                if player.lives - 1 <= 0 then
                    if player.expload_time == 0 then
                        destroy_ast = false
                        asteroid:destroy(G_asteroids, index,game)
                    end
                else
                    destroy_ast = false
                    asteroid:destroy(G_asteroids, index,game)
                end
            end
        end

        player:shootLazers()
    elseif game.state.menu then
        menu:run(clicked_mouse, mouse_x,mouse_y,mouse_radius)
        clicked_mouse = false
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
    elseif game.state.menu then
        menu:draw()
    elseif game.state.ended then
        game:draw()
    end

    if not game.state.running then
        love.graphics.circle("fill", mouse_x, mouse_y,mouse_radius)
    end
end