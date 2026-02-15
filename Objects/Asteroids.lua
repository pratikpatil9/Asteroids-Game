require 'globals'
local love = require "love"

function Asteroids( x, y, ast_size, level)
    local ASTEROID_VERT = 10
    local ASTROID_JAG = 0.4
    local ASTROID_SPEED = math.random(50) + level * 2
    local MIN_ASTEROID_SIZE = ASTEROIDS_SIZE/6

    local dir = -1
    if math.random() < 0.5 then
        dir = 1
    end

    local vert = math.floor(math.random(ASTEROID_VERT + 1) + ASTEROID_VERT/2)
    local offset = {}

    for i = 1, vert + 1 do
        table.insert(offset, math.random() * ASTROID_JAG * 2 + 1 - ASTROID_JAG)
    
    end


    return{
        x = x,
        y = y,
        x_vel = math.random() * ASTROID_SPEED * dir,
        y_vel = math.random() * ASTROID_SPEED * dir,
        radius = math.ceil(ast_size/2),
        angle = math.rad(math.random(math.pi)),
        vert = vert,
        offset = offset,

        draw = function (self, faded)
            local opacity = 1
            if faded then
                opacity = 0.2
            end
            love.graphics.setColor( 186/225, 189/255, 182/255, opacity)

            local points = {
                self.x + self.radius * self.offset[1]*math.cos(self.angle),
                self.y + self.radius * self.offset[1]*math.sin(self.angle)

            }

            for i = 2, self.vert do
                table.insert(points, self.x + self.radius * self.offset[i]*math.cos(self.angle + i * 2 * math.pi/self.vert))
                table.insert(points, self.y + self.radius * self.offset[i]*math.sin(self.angle + i * 2 * math.pi/self.vert))
            end

            love.graphics.polygon("line",
            points)

            if show_debugging then
                love.graphics.setColor(1,0,0)
                love.graphics.circle("line", self.x, self.y, self.radius)
            end
            
        end,

        move = function (self, dt)
            self.x = self.x + self.x_vel * dt
            self.y = self.y + self.y_vel * dt

            if self.x + self.radius < 0 then
                self.x = love.graphics.getWidth() + self.radius
            elseif self.x - self.radius > love.graphics.getWidth() then
                self.x = -self.radius
            end
            if self.y + self.radius < 0 then
                self.y = love.graphics.getHeight() + self.radius
            elseif self.y - self.radius > love.graphics.getHeight() then
                self.y = -self.radius
            end
            
        end,

        destroy = function (self, asteroid_tbl, index, game)
            if self.radius > MIN_ASTEROID_SIZE then
                table.insert(asteroid_tbl, Asteroids(self.x, self.y, self.radius/2, level))
                table.insert(asteroid_tbl, Asteroids(self.x, self.y, self.radius/2, level))
            end

            if self.radius >= ASTEROIDS_SIZE/2 then
                game.score = game.score + 20
            elseif self.radius >= MIN_ASTEROID_SIZE then
                game.score = game.score + 100
            else
                game.score = game.score + 50
            end

            if game.score > game.high_score then
                game.high_score = game.score
            end

            table.remove(asteroid_tbl, index)
            
        end

    }
    
end

return Asteroids