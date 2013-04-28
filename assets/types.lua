local Tile = require("tile")

function decaysource(tile, game, x, y, dt)
    game:setTileType(x, y, 1)
end

function source(tile, game, x, y, dt)
    if sourceSpread(tile, game, x + 1, y, dt) == -1 then return end
    if sourceSpread(tile, game, x - 1, y, dt) == -1 then return end
    if sourceSpread(tile, game, x, y + 1, dt) == -1 then return end
    if sourceSpread(tile, game, x, y - 1, dt) == -1 then return end

    game:setTileType(x, y, 7)
end

function sourceSpread(tile, game, x, y, dt)
    local t = game:getTile(x, y)
    if t then
        if t.typeId == 1 or t.typeId == 5 then
            game:setTileType(x, y, 2)
        end
        if t.typeId == 3 then
            game:win()
            return -1
        end
    end
end

function walldissolve(tile, game, x, y, dt)
    for xx = x - 1, x + 1 do
        for yy = y - 1, y + 1 do
            game:setTileType(xx, yy, 1)
        end
    end
end

function tmpwalldissolve(tile, game, x, y, dt)
    for xx = x - 1, x + 1 do
        for yy = y - 1, y + 1 do
            local t = game:setTileType(xx, yy, 5)
            t.callbackTime = 1
            t.callback = function(tile, game, x, y, dt)
                game:setTileType(x, y, 4)
            end
        end
    end
end

return {
    {typeId = nil, time = nil, cbtime = nil, callback = nil, color = nil, name = nil},
    {typeId = 2, time = 0, cbtime = 0.2, callback = source, color = {0, 150, 255, 255}, name = "Source"},
    {typeId = 3, time = 0, cbtime = 1000, callback = nil, color = {255, 80, 0, 255}, name = "End"},
    {typeId = 4, time = 0, cbtime = 1000, callback = nil, color = {128, 128, 128, 255}, name = "Wall"},
    {typeId = 5, time = 0, cbtime = 1000, callback = nil, color = {50, 50, 50, 255}, name = "Almost Nothing"},
    {typeId = 6, time = 0, cbtime = 0, callback = walldissolve, color = {50, 255, 0, 255}, name = "Dissolver"},
    {typeId = 7, time = 0, cbtime = 0.4, callback = decaysource, color = {0, 120, 250, 255}, name = "Decayed Source"},
    {typeId = 8, time = 0, cbtime = 0, callback = tmpwalldissolve, color = {200, 200, 0, 255}, name = "Fizzle"},
}
