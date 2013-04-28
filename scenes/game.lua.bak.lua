require("utils")
local Gamestate = require("hump.gamestate")
local Camera = require("hump.camera")
local Tile = require("tile")

local Game = Gamestate:new()

function Game:init()
    self.types = require("assets.types")
    self.winning = false
    self.currentLevel = 1
    self.paused = true
    self.selectedInventoryItem = 1
    self.inventory = {}
    self.board = {}

    self:loadLevel(self.currentLevel)
end

function Game:loadLevelFromImage(filename)
    self.inventory = {}
    self.board = {}

    local fp = assetManager.assetDir .. assetManager.imageDir .. filename .. assetManager.imageExt
    if not love.filesystem.exists(fp) then
        self.currentLevel = 1
        switchStates("menu")
        return
    end

    local img = assetManager:getImage(filename, filename, nil, true)
    local w = img:getWidth()
    local h = img:getHeight()

    self.boardSize = vector(w, w)
    self.cursorPos = vector(math.floor(w / 2), math.floor(w / 2))
    self.scale = math.floor(love.graphics.getWidth() / w)

    local max = w * w
    for i = 1, max do
        self:setTileTypeById(i, 1)
    end
    self:printBoard()

    for x = 0, self.boardSize.x - 1 do
        for y = 0, self.boardSize.y - 1 do
            local r, g, b, a = img:getPixel(x, y)
            local equivType = 1
            for i = 1, #self.types do
                local c = self.types[i].color
                if sameColors({r,g,b,a}, c) then
                    equivType = i
                    break
                end
            end
            self:setTileType(x, y, equivType)
        end
    end
    for x = 0, self.boardSize.x - 1 do
        for y = self.boardSize.y, h - 1 do
            local r, g, b, a = img:getPixel(x, y)
            local equivType = -1
            for i = 1, #self.types do
                if sameColors({r,g,b,a}, self.types[i].color) then
                    equivType = i
                    break
                end
            end
            if equivType ~= -1 and equivType ~= 1 then
                if self.inventory[equivType] then
                    self.inventory[equivType] = self.inventory[equivType] + 1
                else
                    self.inventory[equivType] = 1
                    self.selectedInventoryItem = equivType
                end
            end
        end
    end
end

function Game:printBoard()
    s = "Board: "
    for i = 1, #self.board do
        s = s .. self.board[i]
    end
    print(s .. " <")
end

function Game:getTile(x, y)
    if not self:tileExists(x, y) then
        return
    end
    local tid = self:coordsToId(x, y)
    self:getTileById(tid, id, resetsTime, resetsAll)
end

function Game:getTileById(tid)
    if tid < 1 or tid > #self.board then
        return
    end
    return self.board[tid]
end

function Game:setTileType(x, y, type, resetsTime, resetsAll)
    resetsTime = resetsTime or true
    resetsAll = resetsAll or false
    type = type or 1

    if not self:tileExists(x, y) then
        return
    end
    local tid = self:coordsToId(x, y)
    self:setTileTypeById(tid, type, resetsTime, resetsAll)
end

function Game:setTileTypeById(tid, type, resetsTime, resetsAll)
    resetsTime = resetsTime or true
    resetsAll = resetsAll or false
    type = type or 1
    if tid < 1 or tid > #self.board then
        return
    end
    local ttype = self.types[type]
    self.board[tid] = Tile(ttype.type, ttype.time, ttype.cbtime, ttype.callback, ttype.color, ttype.name)
end

function Game:win()
    if not self.winning then
        self.winning = true
        return
    end
    self.winning = false
    self.currentLevel = self.currentLevel + 1
    Game:loadLevel(self.currentLevel)
    self.paused = true
end

function Game:loadLevel(level)
    self:loadLevelFromImage("levels/level" .. level)
end

function Game:idToCoords(id)
    local x = ((id - 1) % self.boardSize.x)
    local y = math.floor((id - 1) / self.boardSize.x)
    return x, y
end

function Game:coordsToId(x, y)
    if not self:tileExists(x, y) then return -1 end
    return ((y * self.boardSize.x) + x) + 1
end

function Game:tileExists(x, y)
    return not (x < 0 or x >= self.boardSize.x or y < 0 or y >= self.boardSize.y)
end

function Game:update(dt)
    if love.keyboard.isDown("escape") then
        switchStates("menu")
    end

    if self.paused then
    else
        local s = self.scale
        local max = self.boardSize.x * self.boardSize.y
        for i = 1, max - 1 do
            local t = self:getTileById(i)
            local x, y = self:idToCoords(i)
            if t then
                t:update(game, x, y, dt)
            end
        end
    end
    if self.winning then
        self:win()
    end
end

function Game:keypressed(k)
    if k == "p" or k == "enter" or k == "return" then
        self.paused = false
    end

    if k == " " then
        print("DORP ME")
        local siiid = self.selectedInventoryItem
        local sii = self.inventory[siiid]
        if sii then
            if sii >= 1 then
                self:setTileType(self.cursorPos.x, self.cursorPos.y, siid)
                sii = sii - 1
                self.inventory[siiid] = sii
                if sii < 1 then
                    self:nextInventoryItem()
                end
            end
        end
    end

    if k == "q" then
        self:previousInventoryItem()
    end
    if k == "e" then
        self:nextInventoryItem()
    end

    if k == "r" then
        Game:loadLevel(self.currentLevel)
    end

    if k == "up" or k == "w" then
        self.cursorPos.y = self.cursorPos.y - 1
    end
    if k == "down" or k == "s" then
        self.cursorPos.y = self.cursorPos.y + 1
    end
    if k == "left" or k == "a" then
        self.cursorPos.x = self.cursorPos.x - 1
    end
    if k == "right" or k == "d" then
        self.cursorPos.x = self.cursorPos.x + 1
    end
    if self.cursorPos.x < 0 then self.cursorPos.x = self.boardSize.x - 1 end
    if self.cursorPos.y < 0 then self.cursorPos.y = self.boardSize.y - 1 end
    if self.cursorPos.x >= self.boardSize.x then self.cursorPos.x = 0 end
    if self.cursorPos.y >= self.boardSize.y then self.cursorPos.y = 0 end
end


function Game:draw()
    local s = self.scale
    local max = self.boardSize.x * self.boardSize.y
    for i = 1, max - 1 do
        local t = self:getTileById(i)
        if t then
            local x, y = self:idToCoords(i)
            t:draw(self, x, y, s)
        end
    end
    love.graphics.setLineWidth(1)

end

return Game
