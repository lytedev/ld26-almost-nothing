local Tile = require("tile")

function decaysource(tile, game, x, y, dt)
    game:setTileType(x, y, 1)
end

function source(tile, game, x, y, dt)
    if not game.playedSourceSound then
        local ss = assetManager:getNewSound("source")
        -- ss:setPitch(p)
        love.audio.play(ss)
        game.playedSourceSound = true
    end
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
        if t.typeId == 10 then
            game:restart()
            return -1
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
            local ds = assetManager:getNewSound("dissolve")
            ds:setVolume(0.5)
            love.audio.play(ds)
        end
    end
end

function tmpwalldissolve(tile, game, x, y, dt)
    for xx = x - 1, x + 1 do
        for yy = y - 1, y + 1 do
            local t = game:setTileType(xx, yy, 5)
            if t then
                t.callbackTime = 1
                t.callback = function(tile, game, x, y, dt)
                    love.audio.play(assetManager:getNewSound("shiny"))
                    game:setTileType(x, y, 4)
                end
            end
        end
    end
end

function sideswap(tile, game, x, y, dt)
    if not game.playedSwapSound then
        local ss = assetManager:getNewSound("swap")
        -- ss:setPitch(p)
        love.audio.play(ss)
        game.playedSwapSound = true
    end

    if not tile.dir then
        tile.dir = -1
    end
    local tx = x + tile.dir
    local swap = game:getTile(tx, y)
    if not swap then
        tile.dir = -tile.dir
        tx = x + tile.dir
        swap = game:getTile(tx, y)
        if not swap then return end
    end

    tile.trailType = tile.trailType or 4
    local trailtile = game:getTile(x - tile.dir, y)
    if trailtile then tile.trailType = trailtile.typeId end

    local ttp = tile.trailType
    local tid = tile.typeId
    local stid = swap.typeId
    local cbtim = tile.callbackTime
    local tdir = tile.dir
    t1 = 0
    t2 = 0
    if tid == 9 then
        t1 = game:setTileType(tx, y, stid)
        t2 = game:setTileType(x, y, tile.trailType)
    else
        t1 = game:setTileType(tx, y, tid)
        t2 = game:setTileType(x, y, tile.trailType)
    end
    t1.trailType = ttp
    t1.dir = tdir
    t1.callback = sideswap
    t1.callbackTime = 0.5
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
    {typeId = 9, time = 0, cbtime = 0, callback = sideswap, color = {120, 0, 255, 255}, name = "Side Swap"},
    {typeId = 10, time = 0, cbtime = 0, callback = nil, color = {120, 0, 0, 255}, name = "Death"},
}
