require("utils")

local Tile = Class{
    function(self, typeId, time, cbtime, callback, color, name)
        self.typeId = typeId or 1
        self.time = time or 0
        self.callbackTime = cbtime or 1000
        self.callback = callback or function(self, game, x, y, dt) return end
        self.color = color or {17, 17, 17, 255}
        self.name = name or "Nothing"
    end
}

function Tile:update(game, x, y, dt)
    self.time = self.time + dt
    if self.time > self.callbackTime then
        self.callback(self, game, x, y, dt)
        self.time = 0
    end
end

function Tile:draw(game, x, y, s)
    love.graphics.setColor(self.color)
    love.graphics.rectangle("fill", x * s, y * s, s, s)
    --if t.bc then
        --love.graphics.setColor(t.bc)
        --love.graphics.rectangle("line", x * s, y * s, s, s)
    --end
end

return Tile
