require("utils")
local Gamestate = require("hump.gamestate")
local Camera = require("hump.camera")

local Game = Gamestate:new()

function Game:init()
    self.types = require("assets.types")

    self.winning = false

    for key, val in pairs(self.types) do
        -- print("Key: " .. key .. " - Val: " .. tostring(val.f))
    end

    self.currentLevel = 1
    self.interfaceText = "Pause/Unpause (P)"
    self.paused = true

    self.inventory = {}
    self.selectedInventoryItem = 1
    self:loadLevel(self.currentLevel)
end

function Game:loadLevelFromImage(filename)
    self.inventory = {}
    self.board = {}

    local fp = assetManager.assetDir .. assetManager.imageDir .. filename .. assetManager.imageExt
    print("Trying to load fp " .. fp)
    if not love.filesystem.exists(fp) then
        print("Switching states before it's too late!")
        self.currentLevel = 1
        switchStates("win")
        return
    end
    local img = assetManager:getImage(filename, filename, nil, true)
    local w = img:getWidth()
    local h = img:getHeight()

    self.boardSize = vector(w, w)
    self.cursorPos = vector(math.floor(w / 2), math.floor(w / 2))
    print(string.format("Loading Level of Size %d, %d", w, w))
    self.scale = math.floor(love.graphics.getWidth() / w)
    print(string.format("Scale: %d", self.scale))
    local max = w * w
    for i = 1, max do
        self.board[i] = {id = 1, time = 0}
    end

    for x = 0, self.boardSize.x - 1 do
        for y = 0, self.boardSize.y - 1 do
            local r, g, b, a = img:getPixel(x, y)
            local equivType = 1
            for i = 1, #self.types do
                if sameColors({r,g,b,a}, self.types[i].c) then
                    equivType = i
                    break
                end
            end
            local id = self:coordsToId(x, y)
            if id ~= -1 then
                self.board[id].id = equivType
            end
        end
    end
    for x = 0, self.boardSize.x - 1 do
        for y = self.boardSize.y, h - 1 do
            local r, g, b, a = img:getPixel(x, y)
            local equivType = -1
            for i = 1, #self.types do
                if sameColors({r,g,b,a}, self.types[i].c) then
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
                    print("Added Inventory Item " .. equivType)
                end
            end
        end
    end
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

function Game:lose()

end

function Game:idToCoords(id)
    local x = ((i - 1) % self.boardSize.x)
    local y = math.floor((i - 1) / self.boardSize.x)
    return x, y
end

function Game:tileExists(x, y)
    return not (x < 0 or x >= self.boardSize.x or y < 0 or y >= self.boardSize.y)
end

function Game:coordsToId(x, y)
    if not self:tileExists(x, y) then return -1 end
    return ((y * self.boardSize.x) + x) + 1
end

function Game:update(dt)
    if love.keyboard.isDown("escape") then
        switchStates("menu")
    end

    if self.paused then
        self.interfaceText = "Unpause (P)"
    else
        self.interfaceText = "Pause (P)"
        local s = self.scale
        local max = self.boardSize.x * self.boardSize.y
        for i = 1, max do
            local bt = self.board[i]
            bt.time = bt.time + dt
            local id = bt.id
            local t = self.types[id]
            local x = ((i - 1) % self.boardSize.x)
            local y = math.floor((i - 1) / self.boardSize.x)
            if t.f and bt.time >= t.time then
                t.f(self, x, y, dt)
            end
        end
        if self.winning then
            self:win()
        end
    end
end

function Game:keypressed(k)
    if k == "p" then
        self.paused = not self.paused
    end

    if k == " " then
        local id = self:coordsToId(self.cursorPos.x, self.cursorPos.y)
        if self.board[id] then
            if self.board[id].id == 1 then
                if self.inventory[self.selectedInventoryItem]then
                    if self.inventory[self.selectedInventoryItem] >= 1 then
                        self.board[id].id = self.selectedInventoryItem
                        self.board[id].time = 0
                        self.inventory[self.selectedInventoryItem] = self.inventory[self.selectedInventoryItem] - 1
                        if self.inventory[self.selectedInventoryItem] < 1 then
                            repeat
                                self.selectedInventoryItem = self.selectedInventoryItem + 1
                                if self.selectedInventoryItem > #self.types then
                                    self.selectedInventoryItem = 1
                                end
                            until self.inventory[self.selectedInventoryItem]
                        end
                    end
                end
            end
        end
    end

    if k == "q" then
        repeat
            self.selectedInventoryItem = self.selectedInventoryItem - 1
            if self.selectedInventoryItem < 1 then
                self.selectedInventoryItem = #self.types
            end
        until self.inventory[self.selectedInventoryItem]
    end
    if k == "e" then
        repeat
            self.selectedInventoryItem = self.selectedInventoryItem + 1
            if self.selectedInventoryItem > #self.types then
                self.selectedInventoryItem = 1
            end
        until self.inventory[self.selectedInventoryItem]
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
    local lw = s / 8
    love.graphics.setLineWidth(lw)
    local max = self.boardSize.x * self.boardSize.y
    for i = 1, max do
        local bt = self.board[i]
        local id = bt.id
        local t = self.types[id]
        local x = ((i - 1) % self.boardSize.x)
        local y = math.floor((i - 1) / self.boardSize.x)
        love.graphics.setColor(t.c)
        love.graphics.rectangle("fill", x * s, y * s, s, s)
        if t.bc then
            love.graphics.setColor(t.bc)
            love.graphics.rectangle("line", x * s + lw / 2, y * s + lw / 2, s - lw, s - lw)
        end
    end
    love.graphics.setLineWidth(1)

    love.graphics.setColor(255, 255, 255, 255)
    local cx = self.cursorPos.x * self.scale - math.ceil(s / 2) + 1.5
    local cy = self.cursorPos.y * self.scale - math.ceil(s / 2) + 1.5
    local cursorSize = s - 1
    love.graphics.rectangle("line", cx + math.floor(cursorSize / 2), cy + math.floor(cursorSize / 2), cursorSize, cursorSize)

    love.graphics.setColor(0, 0, 0, 128)

    local w = love.graphics.getWidth()
    local h = love.graphics.getHeight()
    local ih = config.screen.interfaceHeight

    local x1 = 0 - 0.5
    local y1 = h - ih + 0.5
    local x2 = w + 0.5
    local y2 = ih + 0.5
    love.graphics.rectangle("fill", x1, y1, x2, y2)
    love.graphics.setColor(255, 255, 255, 32)
    love.graphics.line(x1, y1, x2, y1)

    local font = love.graphics.getFont()
    local padding = math.floor(font:getHeight() / 2)
    local sty = 0
    local invx = padding
    local invy = h - config.screen.interfaceHeight + padding * 2 + font:getHeight()
    local invsqsz = 16
    for i = 1, #self.types do
        if not self.inventory[i] then else
            if self.inventory[i] >= 1 then
                sty = sty + 1
                love.graphics.setColor(self.types[i].c)
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

    if self.paused then
        self.interfaceText = "Unpause (P)"
    else
        self.interfaceText = "Pause (P)"
    end

    local sii = self.selectedInventoryItem
    if self.inventory[sii] then
        if self.inventory[sii] >= 1 then
            self.interfaceText = self.interfaceText .. " | Drop " .. self.types[sii].name .. " (Space)"
            -- local str = self.types[sii].name
            -- love.graphics.print(str, w - 10 - font:getWidth(str), invy)
        end
    end

    local bc = self.board[self:coordsToId(self.cursorPos.x, self.cursorPos.y)]
    if self.types[bc.id] then
        local hbn = self.types[bc.id].name
        local x = w - 10 - invsqsz
        local y = invy
        love.graphics.setColor(self.types[bc.id].c)
        love.graphics.rectangle("fill", x, y, invsqsz, invsqsz)
        love.graphics.setColor(255, 255, 255, 255)
        love.graphics.print(hbn, x - font:getWidth(hbn) - 3, y + 4)
    end

    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.print(self.interfaceText, padding, h - config.screen.interfaceHeight + padding)
    self.interfaceText = ""
end

return Game
