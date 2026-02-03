require 'globals'
love = require "love"

function Lazer(x , y, angle)
    local LAZER_SPEED = 500
    local exploadingEnum = {
        not_exploading = 0,
        exploading = 1,
        done_exploading = 2
    }
    local EXPOAD_DUR = 0.2

    return {
        x = x,
        y = y,
        xVelocity = LAZER_SPEED * math.cos(angle),
        yVelocity = -LAZER_SPEED * math.sin(angle),
        distance = 0,
        exploading = 0,
        expload_time = 0,
        

        draw = function (self, faded)
            local opacity = 1
            if faded then
                opacity = 0.2
            end

            if self.exploading < exploadingEnum.exploading then
                love.graphics.setColor(1,1,1,opacity)
                love.graphics.setPointSize(3)
                love.graphics.points(self.x , self.y)
            else
                love.graphics.setColor(1, 104/255, 0, opacity)

                love.graphics.circle("fill", self.x, self.y, 7*1.5)
                
                love.graphics.setColor(1, 234/255, 0, opacity)

                love.graphics.circle("fill", self.x, self.y, 7*1)
            end
        
        end,

        move = function (self, dt)
            self.x = self.x + self.xVelocity * dt
            self.y = self.y + self.yVelocity * dt

            if self.x < 0 then
                self.x = love.graphics.getWidth()
            elseif self.x > love.graphics.getWidth() then
                self.x = 0
            end
            if self.y < 0 then
                self.y = love.graphics.getHeight()
            elseif self.y > love.graphics.getHeight() then
                self.y = 0
            end

            self.distance = self.distance + LAZER_SPEED * dt
        end,

        expload = function (self, dt)
            self.expload_time = math.ceil(EXPOAD_DUR * dt)
            if self.expload_time > EXPOAD_DUR then
                self.exploading = 2
            end
            
        end
    }
        
end

return Lazer