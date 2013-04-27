require("utils")
local Gamestate = require("hump.gamestate")

local Help = Gamestate:new()

function Help:init()
    self.helpPages = {
        {
            title = "Winning",
            text = "To win a level in Almost Nothing, you must get a blue block to touch the orange block. A simple concept, but with the addition of other elements and obstacles, this can become fairly difficult! There will be many times when you need to restart the level, which you can do by pressing the R key.",
        },
        {
            title = "Pausing",
            text = "You can pause the game at any time with the P key. Pausing is an important aspect of the game that allows you to stop and think or make a fast move before it's too late.",
        },
        {
            title = "Placing Blocks",
            text = "To place a block, move your cursor over a placeable area (the darkest squares in every level) with the arrow keys or WASD and press the Spacebar.\n\nNote that you can ONLY place blocks on Nothing blocks. Even Almost Nothing blocks are enough to keep you from placing a block.",
        },
    }

    self.currentPage = 1
end

function Help:nextPage()
    repeat
        self.currentPage = self.currentPage + 1
        if self.currentPage > #self.helpPages then
            self.currentPage = 1
        end
    until self.helpPages[self.currentPage]
end

function Help:previousPage()
    repeat
        self.currentPage = self.currentPage - 1
        if self.currentPage < 1 then
            self.currentPage = #self.helpPages
        end
    until self.helpPages[self.currentPage]
end

function Help:keypressed(k)
    if k == "escape" then
        switchStates("menu")
    end

    if k == "up" or k == "w" or k == "left" or k == "a" then
        self:previousPage()
    end
    if k == "down" or k == "s" or k == "right" or k == "d" then
        self:nextPage()
    end
end

function Help:draw()
    local page = self.helpPages[self.currentPage]
    local font = assetManager:getFont("px")
    local sw = love.graphics.getWidth()
    local sh = love.graphics.getHeight()
    if page then

        local tfont = assetManager:getFont("px2")
        love.graphics.setColor(255, 255, 255, 255)
        love.graphics.setFont(tfont)
        love.graphics.print(page.title, 10, 5)

        love.graphics.setColor(255, 255, 255, 128)
        love.graphics.setFont(font)
        love.graphics.printf(page.text, 10, 36, sw - 20, "left")
    end

    local npages = #self.helpPages
    local ih = 32
    local x1 = 0 - 0.5
    local y1 = sh - ih + 0.5
    local x2 = sw + 0.5
    local y2 = ih + 0.5
    love.graphics.setColor(0, 0, 0, 128)
    love.graphics.rectangle("fill", x1, y1, x2, y2)
    love.graphics.setColor(255, 255, 255, 32)
    love.graphics.line(x1, y1, x2, y1)

    love.graphics.setColor(255, 255, 255, 128)
    local str = string.format("Page %d of %d", self.currentPage, npages)
    local tx = sw / 2 - font:getWidth(str) / 2
    local ty = sh - font:getHeight() / 2 - ih / 2
    love.graphics.print(str, tx, ty)
    love.graphics.print("<<", 10, ty)
    love.graphics.print(">>", sw - font:getWidth(">>") - 10, ty)
end

return Help
