local love = require "love"

local Button = require "Components.Button"

function Menu(game, player)
    local funcs = {
        new_game = function ()
            game:startNewGame(player)
        end,
        quit_game = function ()
            love.event.quit()
        end
    }
    local buttons = {
        Button(funcs.new_game, nil, nil, love.graphics.getWidth()/3, 50, "New Game", "center", "h3", love.graphics.getWidth()/3, love.graphics.getHeight()*0.25),
        Button(nil, nil, nil, love.graphics.getWidth()/3, 50, "Settings", "center", "h3", love.graphics.getWidth()/3, love.graphics.getHeight()*0.4),
        Button(funcs.quit_game, nil, nil, love.graphics.getWidth()/3, 50, "Quit", "center", "h3", love.graphics.getWidth()/3, love.graphics.getHeight()*0.55)
    }
    return {
        focused = "",
        run = function (self,clicked,mouse_x,mouse_y, cursor_radius)
            for _,button in pairs(buttons) do
                if button:checkHover(mouse_x,mouse_y,cursor_radius) then
                    if clicked then
                        button:click()
                    end
                    button:setTextColor(0.8,0.2,0.2)
                else
                    button:setTextColor(1,1,1)
                end

            end
                
        end,
        draw = function (self)
            for _,button in pairs(buttons) do
                button:draw()
            end
            
        end
    }
    
end

return Menu