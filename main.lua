--[[

Notes: Minimalism



]]--

-- Globals
debugText = ""
assetManager = require("assets/assetmanager")()

require("utils")
local Gamestate = require("hump.gamestate")

function love.load()
    Gamestate.registerEvents()
    Gamestate.switch(require("scenes.menu"))
    love.graphics.setFont(assetManager:getFont("pf_tempesta_seven_condensed", 8, "px"))
    love.graphics.setFont(assetManager:getFont("pf_tempesta_seven_condensed", 16, "px2"))
    love.graphics.setBackgroundColor(17, 17, 17, 255)
end

function love.update(dt)

end

function love.draw()
end
