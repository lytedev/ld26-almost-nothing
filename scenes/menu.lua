require("utils")
local Gamestate = require("hump.gamestate")

local Menu = Gamestate:new()

function Menu:init()
    self.menuItems = {
        {
            text = "Almost Nothing",
            color = {0, 150, 255, 255}
        },
        {
            text = "Play",
            callback = function() print("Play game..."); Gamestate:switch(require("scenes.game")) end
        },
        {
            text = "Help",
            callback = function() return end
        },
        {
            text = "Quit",
            callback = function() love.event.quit() end
        },
    }

    self.itemColor = {128, 128, 128, 255}
    self.selectColor = {255, 255, 255, 255}
    self.selectedItem = 2
    self:nextMenuItem()
end

function Menu:update(dt)

end

function Menu:nextMenuItem()
    repeat
        self.selectedItem = self.selectedItem + 1
        if self.selectedItem > #self.menuItems then
            self.selectedItem = 1
        end
    until self.menuItems[self.selectedItem].callback
end

function Menu:previousMenuItem()
    repeat
        self.selectedItem = self.selectedItem - 1
        if self.selectedItem < 1 then
            self.selectedItem = #self.menuItems
        end
    until self.menuItems[self.selectedItem].callback
end

function Menu:keypressed(k)
    if k == "escape" then
        love.event.quit()
    end

    if k == " " or k == "return" or k == "enter" then
        local c = self.menuItems[self.selectedItem].callback
        if c then
            c()
        end
    end

    if k == "up" or k == "w" or k == "left" or k == "a" then
        self:previousMenuItem()
    end
    if k == "down" or k == "s" or k == "right" or k == "d" then
        self:nextMenuItem()
    end
end

function Menu:draw()
    local sw = love.graphics.getWidth()
    local sh = love.graphics.getHeight()
    local font = assetManager:getFont("px2")
    love.graphics.setFont(font)
    local padding = 4
    local menuHeight = ((#self.menuItems) * (font:getHeight() + padding))
    for i = 1, #self.menuItems do
        local mi = self.menuItems[i]
        local c = self.itemColor
        if i == self.selectedItem then
            c = self.selectColor
        end
        if mi.color then
             c = mi.color
        end
        love.graphics.setColor(c)
        local x = sw / 2 - font:getWidth(mi.text) / 2
        local y = ((i - 1) * (font:getHeight() + padding)) + (sh / 2) - (menuHeight / 2)
        love.graphics.print(mi.text, x, y)
    end
    local font = assetManager:getFont("px")
    love.graphics.setColor(255, 255, 255, 64)
    love.graphics.setFont(font)
    local str1 = string.format("%s %s", config.title, config.identityVersion)
    local str2 = string.format("By %s (%s)", config.author, config.url)
    love.graphics.print(str1, 10, sh - 10 - (font:getHeight() * 2))
    love.graphics.print(str2, 10, sh - 10 - (font:getHeight() * 1))
end

return Menu
