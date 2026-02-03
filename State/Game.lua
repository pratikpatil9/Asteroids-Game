require "globals"
local love = require "love"
local Text = require "../Components/Text"
local Asteroids = require "../Objects/Asteroids"


function Game()
    return{
        level = 1,
        state = {
            menu = false,
            paused = false,
            running = true,
            ended = false
        },

        changeGameState = function(self, state)
            self.state.menu = state == "menu"
            self.state.paused = state == "paused"
            self.state.running = state == "running"
            self.state.ended = state == "ended"
        
        end,

        startNewGame = function (self,Player)
            G_asteroids = {

            }
            local ast_x = math.floor(math.random(love.graphics.getWidth()))
            local ast_y = math.floor(math.random(love.graphics.getHeight()))

            table.insert(G_asteroids,1,Asteroids(ast_x, ast_y, ASTEROIDS_SIZE, self.level))
            
        end,

        draw = function (self,faded)
            if faded then
                Text(
                    "PAUSED",
                    0,
                    love.graphics.getHeight()*0.4,
                    "h1",
                    false,
                    false,
                    love.graphics.getWidth(),
                    "center"
                ):draw()
                
            end
            
        end
    }
end

return Game