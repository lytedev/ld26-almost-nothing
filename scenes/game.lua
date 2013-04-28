require("utils")
local Gamestate = require("hump.gamestate")
local Camera = require("hump.camera")
local Tile = require("tile")

local Game = Gamestate:new()

function flushprint(...)
    print(...)
    io.flush()
end

function Game:init()
    self.types = require("assets.types")

    self.playedSourceSound = false
    self.playedSwapSound = false
    self.levelSize = vector(0, 0)
    self.winning = false
    self.restarting = false
    self.levelId = 0
    self.level = {}
    self.inventory = {}
    self.selectedInventoryItem = 0
    self.paused = true
    self.hopeless = false

    self:loadLevel(1)
end

function Game:loadLevel(id)
    self.selectedInventoryItem = 0
    self.level = {}
    self.inventory = {}
    self.levelId = id

    local filename = "levels/level" .. id
    local fp = assetManager.assetDir .. assetManager.imageDir .. filename .. assetManager.imageExt
    if not love.filesystem.exists(fp) then
        -- Can't find next level, so player wins.
        -- print("Couldn't find next level. End of campaign?")
        self.currentLevel = 1
        switchStates("win")
        return
    end

    local img = assetManager:getImage(filename, filename, nil, true)
    local w = img:getWidth()
    local h = img:getHeight()

    self.hopeless = false
    self.levelSize = vector(w, w)
    self.cursor = vector(math.floor(w / 2), math.floor(w / 2))
    self.tileSize = math.floor(love.graphics.getWidth() / w)

    local max = (w * w)
    for i = 1, #self.types do
        self.inventory[i] = 0
    end

    for i = 1, max do
        self.level[i] = nil
    end

    for i = 1, max do
        self.level[i] = Tile()
    end

    for x = 0, self.levelSize.x - 1 do
        for y = 0, self.levelSize.y - 1 do
            local r, g, b, a = img:getPixel(x, y)
            local equivType = 1
            for i = 1, #self.types do
                local c = self.types[i].color
                if c then
                    if sameColors({r,g,b,a}, c) then
                        equivType = i
                        break
                    end
                end
            end
            self:setTileType(x, y, equivType)
        end
    end
    for x = 0, self.levelSize.x - 1 do
        for y = self.levelSize.y, h - 1 do
            local r, g, b, a = img:getPixel(x, y)
            local equivType = -1
            for i = 1, #self.types do
                local c = self.types[i].color
                if c then
                    if sameColors({r,g,b,a}, c) then
                        equivType = i
                        break
                    end
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

    self:nextInventoryItem()
end

function Game:win()
    if not self.winning then
        self.winning = true
        return
    end
end

function Game:_win()
    self.winning = false
    self.levelId = self.levelId + 1
    Game:loadLevel(self.levelId)
    local ws = assetManager:getNewSound("win")
    love.audio.play(ws)
    self.paused = true
    self.hopeless = false
end

function Game:addBlockToInventory(id)
    if not self.inventory[id] then return end
    self.inventory[id] = self.inventory[id] + 1
end

function Game:removeBlockFromInventory(id)
    if not self.inventory[id] then return end
    if self.inventory[id] < 1 then return end
    self.inventory[id] = self.inventory[id] - 1
end

function Game:idToCoords(id)
    local x = ((id - 1) % self.levelSize.x)
    local y = math.floor((id - 1) / self.levelSize.x)
    return x, y
end

function Game:coordsToId(x, y)
    if not self:tileExists(x, y) then return -1 end
    return ((y * self.levelSize.x) + x) + 1
end

function Game:tileExists(x, y)
    return not (x < 0 or x >= self.levelSize.x or y < 0 or y >= self.levelSize.y)
end

function Game:tileExistsById(id)
    return not (id < 1 or id > #self.level)
end

function Game:setTileType(x, y, typeId)
    if not self:tileExists(x, y) then return end
    return self:setTileTypeById(self:coordsToId(x, y), typeId)
end

function Game:setTileTypeById(id, typeId)
    if not self:tileExistsById(id) then return end
    local type = self.types[typeId]
    local t = Tile(type.typeId, type.time, type.cbtime, type.callback, type.color, type.name)
    self.level[id] = t
    return t
end

function Game:getTile(x, y)
    if not self:tileExists(x, y) then return end
    return self:getTileById(self:coordsToId(x, y))
end

function Game:getTileById(id)
    if not self:tileExistsById(id) then return end
    return self.level[id]
end

function Game:restart()
    if not self.restarting then
        self.restarting = true
        return
    end
end

function Game:_restart()
    local cp = self.cursor
    self:loadLevel(self.levelId)
    self.cursor = cp
    self.restarting = false
    self.paused = true
    self.hopeless = false
    local rs = assetManager:getNewSound("restart")
    love.audio.play(rs)
end

function Game:keypressed(k)
    if k == "p" or k == "enter" or k == "return" then
        self.paused = false
    end

    if k == "r" then
        self:restart()
    end

    if k == " " then
        local siiid = self.selectedInventoryItem
        local sii = self.inventory[siiid]
        if sii then
            local ctid = self:getTile(self.cursor.x, self.cursor.y).typeId
            if sii >= 1 and ctid == 1 then
                love.audio.play(assetManager:getNewSound("drop"))
                self:setTileType(self.cursor.x, self.cursor.y, siiid)
                sii = sii - 1
                self.inventory[siiid] = sii
                if sii < 1 then
                    self:nextInventoryItem()
                end
            end
        end
    end

    if k == "escape" then
        switchStates("menu")
    end
    if k == "up" or k == "w" then
        self.cursor.y = self.cursor.y - 1
    end
    if k == "down" or k == "s" then
        self.cursor.y = self.cursor.y + 1
    end
    if k == "left" or k == "a" then
        self.cursor.x = self.cursor.x - 1
    end
    if k == "right" or k == "d" then
        self.cursor.x = self.cursor.x + 1
    end
    if self.cursor.x < 0 then self.cursor.x = self.levelSize.x - 1 end
    if self.cursor.y < 0 then self.cursor.y = self.levelSize.y - 1 end
    if self.cursor.x >= self.levelSize.x then self.cursor.x = 0 end
    if self.cursor.y >= self.levelSize.y then self.cursor.y = 0 end

    if k == "q" then
        self:previousInventoryItem()
    end
    if k == "e" then
        self:nextInventoryItem()
    end
end

function Game:previousInventoryItem()
    local counter = 0
    local initialsii = self.selectedInventoryItem
    repeat
        self.selectedInventoryItem = self.selectedInventoryItem - 1
        if self.selectedInventoryItem < 1 then
            self.selectedInventoryItem = #self.types
        end
        counter = counter + 1
    until self.inventory[self.selectedInventoryItem] >= 1 or self.selectedInventoryItem == initialsii or counter == #self.types
end

function Game:nextInventoryItem()
    local counter = 0
    repeat
        self.selectedInventoryItem = self.selectedInventoryItem + 1
        if self.selectedInventoryItem > #self.types then
            self.selectedInventoryItem = 1
        end
        counter = counter + 1
    until self.inventory[self.selectedInventoryItem] >= 1 or self.selectedInventoryItem == initialsii or counter == #self.types
end

function Game:update(dt)
    if self.winning then
        self:_win()
        return
    end
    if self.restarting then
        self:_restart()
        return
    end
    if self.paused then return end
    self.playedSourceSound = false
    self.playedSwapSound = false
    local tsources = 0
    for i = 1, #self.level do
        local x, y = self:idToCoords(i)
        local t = self:getTileById(i)
        if t then
            t:update(self, x, y, dt)
            if t.typeId == 2 then tsources = tsources + 1 end
        end
    end
    if self.inventory then
        if self.inventory[2] then
            if self.inventory[2] < 1 and tsources < 1 and not self.hopeless then
                local hs = assetManager:getNewSound("hopeless")
                love.audio.play(hs)
                self.hopeless = true
            end
        end
    end
end

function Game:draw()
    for i = 1, #self.level do
        local x, y = self:idToCoords(i)
        self:getTileById(i):draw(self, x, y, self.tileSize)
    end
    love.graphics.setColor(255, 255, 255, 255)
    local cx = self.cursor.x * self.tileSize - math.ceil(self.tileSize / 2) + 1.5
    local cy = self.cursor.y * self.tileSize - math.ceil(self.tileSize / 2) + 1.5
    local cursorSize = self.tileSize - 1
    love.graphics.rectangle("line", cx + math.floor(cursorSize / 2), cy + math.floor(cursorSize / 2), cursorSize, cursorSize)

    local w = love.graphics.getWidth()
    local h = love.graphics.getHeight()
    local ih = config.screen.interfaceHeight

    local x1 = 0 - 0.5
    local y1 = h - ih + 0.5
    local x2 = w + 0.5
    local y2 = ih + 0.5
    love.graphics.setColor(0, 0, 0, 128)
    love.graphics.rectangle("fill", x1, y1, x2, y2)
    love.graphics.setColor(255, 255, 255, 32)
    love.graphics.line(x1, y1, x2, y1)

    local font = assetManager:getFont("px")
    love.graphics.setFont(font)
    local padding = math.floor(font:getHeight() / 2)
    local sty = 0
    local invx = padding
    local invy = h - padding * 4
    local invsqsz = ih / 4
    for i = 1, #self.types do
        if self.inventory[i] then
            if self.inventory[i] >= 1 then
                sty = sty + 1
                love.graphics.setColor(self.types[i].color)
                local adjinvx = invx + ((sty - 1) * 3 * invsqsz)
                love.graphics.rectangle("fill", adjinvx, invy, invsqsz, invsqsz)
                love.graphics.setColor(255, 255, 255, 255)
                if self.selectedInventoryItem == i then
                    love.graphics.rectangle("line", adjinvx - 0.5, invy - 0.5, invsqsz + 1, invsqsz + 1)
                end
                love.graphics.print(self.inventory[i], adjinvx + invsqsz + 4, invy + 7)
            end
        end
    end

    if self.hopeless then
        love.graphics.setColor(0, 0, 0, 255)
        love.graphics.printf("It's looking grim, my friend\nRestart (R)", 0.5, 51, w + 0.5, "center")
        love.graphics.setColor(255, 255, 255, 255)
        love.graphics.printf("It's looking grim, my friend\nRestart (R)", 0, 50, w, "center")
    end

    local helpText = ""
    local numItems = 0
    for i = 1, #self.types do
        if self.inventory[i] >= 1 then
            numItems = numItems + 1
        end
    end

    helpText = helpText .. "Restart (R) "
    if numItems > 1 then
        helpText = helpText .. "Switch Items (Q/E) "
    end

    if self.paused then
        helpText = helpText .. "\nUnpause (Enter) "
    else
        -- helpText = "Pause (Enter)"
    end

    local sii = self.selectedInventoryItem
    if self.inventory[sii] then
        if self.inventory[sii] >= 1 then
            helpText = helpText .. "Drop " .. self.types[sii].name .. " (Space) "
            -- local str = self.types[sii].name
            -- love.graphics.print(str, w - 10 - font:getWidth(str), invy)
        end
    end

    local bc = self:getTile(self.cursor.x, self.cursor.y)
    if bc then
        local hbn = bc.name
        local x = w - 10 - invsqsz
        local y = invy
        love.graphics.setColor(bc.color)
        love.graphics.rectangle("fill", x, y, invsqsz, invsqsz)
        love.graphics.setColor(255, 255, 255, 255)
        love.graphics.print(hbn, x - font:getWidth(hbn) - 3, y + 4)
    end

    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.print(helpText, padding, h - config.screen.interfaceHeight + padding)
end

return Game
