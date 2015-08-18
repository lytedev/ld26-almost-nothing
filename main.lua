--[[

Notes: Minimalism



]]--

-- Globals
debugText = ""
assetManager = require("assets/assetmanager")()
curState = 0

require("utils")
local Gamestate = require("hump.gamestate")

function love.load()
    love.window.setIcon(assetManager:getImage("logo", "logo", ".png", true))
    love.graphics.setFont(assetManager:getFont("pf_tempesta_seven_condensed", 16, "px"))
    love.graphics.setFont(assetManager:getFont("pf_tempesta_seven_condensed", 32, "px2"))
    love.graphics.setBackgroundColor(17, 17, 17, 255)

    love.audio.setVolume(0.7)

    local mtrk = assetManager:getMusic("almost-something")
    mtrk:setVolume(0.4)
    mtrk:setLooping(true)
    mtrk:play()
    switchStates("menu")
end

function switchStates(state)
    curState = require("scenes." .. state)
    curState:init()
end

function love.keypressed(k)
    curState:keypressed(k)
end

function love.update(dt)
    curState:update(dt)
end

function love.draw()
    curState:draw()
end
