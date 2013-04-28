require("utils")

local Tile = Class{
    function(self, type, time)
        self.type = type or 1
        self.time = time or 0
    end
}

function Tile:update(game, dt)
    self.time = self.time + dt
end

function Tile:draw(game, x, y, s)
    local t = game.types[self.type]
    print(t)
    love.graphics.setColor(t.c)
    love.graphics.rectangle("fill", x * s, y * s, s, s)
    if t.bc then
        love.graphics.setColor(t.bc)
        love.graphics.rectangle("line", x * s, y * s, s, s)
    end
end

return Tile
