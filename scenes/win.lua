require("utils")
local Gamestate = require("hump.gamestate")

local Win = Gamestate:new()

function Win:init()
    self.potato = assetManager:getImage("potato")
    self.potatoAngle = 0
end

function Win:keypressed(k)
    if k == "escape" or k == "enter" or k == "return" then
        switchStates("menu")
    end
end

function Win:update(dt)
    self.potatoAngle = self.potatoAngle + 1 * dt
end

function Win:draw()
    local sw = love.graphics.getWidth()
    local sh = love.graphics.getHeight()
    local ih = config.screen.interfaceHeight / 2
    local x1 = 0 - 0.5
    local y1 = sh - ih + 0.5
    local x2 = sw + 0.5
    local y2 = ih + 0.5

    love.graphics.setFont(assetManager:getFont("px2"))
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.printf("You have won!\n\nCongratulations!", 10, 40, sw - 20, "center")

    love.graphics.setColor(0, 0, 0, 128)
    love.graphics.rectangle("fill", x1, y1, x2, y2)
    love.graphics.setColor(255, 255, 255, 32)
    love.graphics.line(x1, y1, x2, y1)
    local font = assetManager:getFont("px")
    love.graphics.setFont(font)

    love.graphics.setColor(255, 255, 255, 255)
    local scale = sw / 64
    local pw = self.potato:getWidth()
    local ph = self.potato:getHeight()
    local scw = pw * scale
    local sch = ph * scale
    local px = sw / 2
    local py = sh / 1.8
    love.graphics.draw(self.potato, px, py, self.potatoAngle, scale, scale, pw / 2, ph / 2)

    love.graphics.setColor(255, 255, 255, 255)
    local str = string.format("Press Escape to return to the menu")
    local tx = sw / 2 - font:getWidth(str) / 2
    local ty = sh - font:getHeight() / 2 - ih / 2
    love.graphics.print(str, tx, ty)
end

return Win
