local love = require('love')
local Lazer = require 'Objects.Lazer'
function Player(debugging, num_lives)
    local SHIP_SIZE = 30
    local VIEW_ANGLE = math.rad(90)
    local debugging = debugging or false
    local MAX_LAZERS = 30
    local LAZER_DISTANCE = 0.6
    local EXPLOAD_DUR = 30
    local lives_x, lives_y = 45, 30

    return{
        x = love.graphics.getWidth()/2,
        y = love.graphics.getHeight()/2,
        radius = SHIP_SIZE/2,
        angle = VIEW_ANGLE,
        lazers = {},
        rotation = 0,
        thrusting = false,
        shooting = false,
        thrust = {
            x = 0,
            y = 0,
            speed = 0.5,
            big_flame = false,
            flame = 2.0
        },
        expload_time = 0,
        exploading = false,
        lives = num_lives or 3,

        drawLives = function (self, faded)
            local opacity = 1

            if faded then
                opacity = 0.2
            end

            if self.lives == 2 then
                love.graphics.setColor(1, 1, 0.5, opacity)
            elseif self.lives == 1 then
                love.graphics.setColor(1, 0.2, 0.2, opacity)
            else
                love.graphics.setColor(1, 1, 1, opacity)
            end

            for i = 1, self.lives do
                if self.exploading then
                    if i == self.lives then
                        love.graphics.setColor(1,0,0,opacity)
                    end
                end
                love.graphics.polygon("line",
                    (i* lives_x) +((4/3)*self.radius)*math.cos(VIEW_ANGLE),
                    lives_y -((4/3)*self.radius)*math.sin(VIEW_ANGLE),
                    (i* lives_x) - self.radius *((2/3)*math.cos(VIEW_ANGLE)+math.sin(VIEW_ANGLE)),
                    lives_y + self.radius *((2/3)*math.sin(VIEW_ANGLE)-math.cos(VIEW_ANGLE)),
                    (i* lives_x) - self.radius *((2/3)*math.cos(VIEW_ANGLE)-math.sin(VIEW_ANGLE)),
                    lives_y + self.radius *((2/3)*math.sin(VIEW_ANGLE)+math.cos(VIEW_ANGLE))
                )
            end
        end,

        drawFlameThrust = function(self, fillType, color)
            love.graphics.setColor(color)
            love.graphics.polygon(fillType,
                self.x - self.radius*(2/3*math.cos(self.angle)+0.5*math.sin(self.angle)),
                self.y + self.radius*(2/3*math.sin(self.angle)-0.5*math.cos(self.angle)),
                self.x - self.radius * self.thrust.flame * math.cos(self.angle),
                self.y + self.radius * self.thrust.flame * math.sin(self.angle),
                self.x - self.radius*(2/3*math.cos(self.angle)-0.5*math.sin(self.angle)),
                self.y + self.radius*(2/3*math.sin(self.angle)+0.5*math.cos(self.angle))
            )
        end,

        shootLazers = function(self)
            if self.shooting then
                if #self.lazers <= MAX_LAZERS then
                    table.insert(self.lazers,Lazer(
                    self.x,
                    self.y,
                    self.angle))
                end
            end
        end,

        destroyLazers = function(self,index)
                table.remove(self.lazers,index)
        end,

        draw = function(self, faded)
            local opacity = 1

            if faded then
                opacity = 0.2
            end

            if not self.exploading then
                if self.thrusting then
                    self:drawFlameThrust("fill", {255/255, 102/255, 25/255})
                end

                if debugging then
                love.graphics.setColor(1,0,0,opacity)
                love.graphics.rectangle("fill", self.x - 2, self.y - 2, 4, 4)
                love.graphics.circle("line", self.x, self.y, self.radius)
            end
            love.graphics.setColor(1, 1, 1, opacity)
            love.graphics.polygon("line",
                self.x +((4/3)*self.radius)*math.cos(self.angle),
                self.y -((4/3)*self.radius)*math.sin(self.angle),
                self.x - self.radius *((2/3)*math.cos(self.angle)+math.sin(self.angle)),
                self.y + self.radius *((2/3)*math.sin(self.angle)-math.cos(self.angle)),
                self.x - self.radius *((2/3)*math.cos(self.angle)-math.sin(self.angle)),
                self.y + self.radius *((2/3)*math.sin(self.angle)+math.cos(self.angle))
            )

            else
                love.graphics.setColor(1, 0, 0, opacity)
                love.graphics.circle("fill", self.x, self.y, self.radius*1.5)

                love.graphics.setColor(1, 158/255, 0, opacity)
                love.graphics.circle("fill", self.x, self.y, self.radius*1)
                
                love.graphics.setColor(1, 234/255, 0, opacity)
                love.graphics.circle("fill", self.x, self.y, self.radius*0.5)
            end

            for _,lazer in pairs(self.lazers) do
                lazer:draw(faded)
            end

        end,

        move = function(self,dt)

            self.exploading = self.expload_time > 0

            if not self.exploading then
                local friction = 0.7
                self.rotation = 360/180 * math.pi * dt
                if love.keyboard.isDown("a") or love.keyboard.isDown("left") or love.keyboard.isDown("kp4") then
                    self.angle = self.angle + self.rotation
                end
                if love.keyboard.isDown("d") or love.keyboard.isDown("right") or love.keyboard.isDown("kp6") then
                    self.angle = self.angle - self.rotation
                end

                if self.thrusting == true then
                    self.thrust.x = self.thrust.x + self.thrust.speed * math.cos(self.angle)*dt
                    self.thrust.y = self.thrust.y - self.thrust.speed * math.sin(self.angle)*dt
                    if not self.thrust.big_flame then
                        self.thrust.flame = self.thrust.flame - 1 * dt
                        if self.thrust.flame < 1.5 then
                            self.thrust.big_flame = true
                        end
                    else
                        self.thrust.flame = self.thrust.flame + 1 * dt
                        if self.thrust.flame > 2.5 then
                            self.thrust.big_flame = false
                        end
                    end
                else
                    if self.thrust.x ~= 0 or self.thrust.y ~= 0 then
                        self.thrust.x = self.thrust.x - friction * self.thrust.x*dt
                        self.thrust.y = self.thrust.y - friction * self.thrust.y*dt
                    end
                end

                self.x = self.x + self.thrust.x
                self.y = self.y + self.thrust.y

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
            end

            for index,lazer in pairs(self.lazers) do
                lazer:move(dt)

                if lazer.distance >= LAZER_DISTANCE * love.graphics.getWidth() and lazer.exploading == 0 then
                    lazer:expload(dt)
                end

                if lazer.exploading == 0 then
                    lazer:move(dt)
                elseif lazer.exploading == 2 then
                    self:destroyLazers(index)
                end
            end
        end,

        expload = function (self, dt)
            self.expload_time = math.ceil(EXPLOAD_DUR * dt)
            
        end

    }
end

return Player