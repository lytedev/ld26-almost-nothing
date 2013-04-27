
function source(game, x, y, dt)
    local bid = game:coordsToId(x, y)
    if bid == -1 then
        return
    end
    local bt = game.board[bid]
    bt.time = 0

    sourceBlock(game, x,        y + 1,  dt)
    sourceBlock(game, x,        y - 1,  dt)
    sourceBlock(game, x + 1,    y,      dt)
    sourceBlock(game, x - 1,    y,      dt)
end

function walldissolve(game, x, y, dt)
    for xx = x - 1, x + 1 do
        for yy = y - 1, y + 1 do
            local bid = game:coordsToId(xx, yy)
            if bid == -1 then
                return
            end
            local bt = game.board[bid]
            if bt.id == 4 then
                bt.id = 1
            end
        end
    end
end

function sourceBlock(game, x, y, dt)
    local bid = game:coordsToId(x, y)
    if bid == -1 then
        return
    end
    local bt = game.board[bid]

    if bt.id == 3 then
        game:win()
    end

    if bt.id == 1 or bt.id == 3 or bt.id == 6 then
        bt.id = 2
        bt.time = 0
    end
end

function ending(game, x, y, dt)

end

return {
    [1] = {c = {17, 17, 17, 255}, name = "Nothing", f = nil, time = 0},
    [2] = {c = {0, 150, 255, 255}, bc = {0, 0, 0, 32}, name = "Source", f = source, time = 0.1},
    [3] = {c = {255, 80, 0, 255}, bc = {0, 0, 0, 32}, name = "End", f = ending, time = 0.1},
    [4] = {c = {128, 128, 128, 255}, name = "Wall", f = nil, time = 0},
    [5] = {c = {50, 255, 0, 255}, name = "Dissolver", f = walldissolve, time = 0},
    [6] = {c = {50, 50, 50, 255}, name = "Almost Nothing", f = nil, time = 0},
}
