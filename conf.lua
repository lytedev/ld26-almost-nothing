function love.conf(t)
    print("TODO: EDIT CONF DETAILS")

    config = t

    t.title = "Almost Nothing"
    t.author = "Daniel \"lytedev\" Flanagan"
    t.url = "http://lytedev.com"
    t.identity = "almost-nothing"
    t.identityVersion = "Alpha 0.3"
    t.version = "0.8.0"
    t.console = false
    t.release = false

    t.screen.interfaceHeight = 50
    t.screen.width = 256
    t.screen.height = t.screen.width + t.screen.interfaceHeight
    t.screen.fullscreen = false
    t.screen.vsync = true
    t.screen.fsaa = 0

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
