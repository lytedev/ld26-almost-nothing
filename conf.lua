function love.conf(t)
    config = t

    t.title = "Almost Nothing"
    t.author = "Daniel \"lytedev\" Flanagan"
    t.url = "http://lytedev.com"
    t.identity = "almost-nothing"
    t.identityVersion = "1.1d"
    t.version = "0.9.2"
    t.console = false
    t.release = false

    t.window.interfaceHeight = 128
    t.window.width = 512
    t.window.height = t.window.width + t.window.interfaceHeight
    t.window.fullscreen = false
    t.window.vsync = true
    t.window.fsaa = 0

    t.modules.joystick = false
    t.modules.audio = true
    t.modules.keyboard = true
    t.modules.event = true
    t.modules.image = true
    t.modules.graphics = true
    t.modules.timer = true
    t.modules.mouse = true
    t.modules.sound = true
    t.modules.physics = true
end
