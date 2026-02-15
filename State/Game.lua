require "globals"
local love = require "love"
local Text = require "../Components/Text"
local Asteroids = require "../Objects/Asteroids"


function Game(save_data)
    return{
        level = 1,
        state = {
            menu = true,
            paused = false,
            running = false,
            ended = false
        },
        score = 0,
        high_score = save_data.high_score or 0,
        screen_text = {},
        game_over_showing = false,

        changeGameState = function(self, state)
            self.state.menu = state == "menu"
            self.state.paused = state == "paused"
            self.state.running = state == "running"
            self.state.ended = state == "ended"
        
        end,

        gameOver = function (self)
            self.screen_text = {
                Text(
                    "Game Over",
                    0,
                    love.graphics.getHeight() * 0.4,
                    "h1",
                    true,
                    true,
                    love.graphics.getWidth(),
                    "center"
                )
            }
            self.game_over_showing = true
        end,

        startNewGame = function (self,Player)
            self:changeGameState("running")
            G_asteroids = {

            }
            local ast_x = math.floor(math.random(love.graphics.getWidth()))
            local ast_y = math.floor(math.random(love.graphics.getHeight()))

            table.insert(G_asteroids,1,Asteroids(ast_x, ast_y, ASTEROIDS_SIZE, self.level))
            
        end,

        draw = function (self,faded)
            local opacity = 1
            if faded then
                opacity = 0.5
            end

            for index,text in pairs(self.screen_text) do
                if self.game_over_showing then
                    self.game_over_showing = text:draw(self.screen_text,index)
                    
                    if not self.game_over_showing then
                        self:changeGameState("menu")
                    end
                else
                    text:draw(self.screen_text,index)
                end
        
            end

            Text(
                "SCORE:"..self.score,
                -20,
                10,
                "h4",
                false,
                false,
                love.graphics.getWidth(),
                "right",
                faded and opacity or 0.6
            ):draw()

            Text(
                "HIGHSCORE:"..self.score,
                0,
                10,
                "h5",
                false,
                false,
                love.graphics.getWidth(),
                "center",
                faded and opacity or 0.5
            ):draw()

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