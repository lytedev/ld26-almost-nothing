require("utils")

local AssetManager = Class{
    function(self)
        self.assetDir =     "assets/"

        self.imageDir =     "img/"
        self.fontDir =      "font/"
        self.soundDir =     "sfx/"
        self.musicDir =     "music/"

        self.imageExt =     ".png"
        self.fontExt =      ".ttf"
        self.soundExt =     ".wav"
        self.musicExt =     ".ogg"

        self.images = {}
        self.fonts = {}
        self.sounds = {}
        self.music = {}
    end
}

function AssetManager:getImage(f, key, ext, asdata)
    asdata = asdata or false
    ext = ext or self.imageExt
    key = key or f
    f = self.assetDir .. self.imageDir .. f .. ext
    if not self.images[key] then
        if not asdata then
            self.images[key] = love.graphics.newImage(f)
        else
            self.images[key] = love.image.newImageData(f)
        end
    end
    return self.images[key]
end

function AssetManager:getFont(f, size, key, ext)
    ext = ext or self.fontExt
    key = key or f
    f = self.assetDir .. self.fontDir .. f .. ext
    if not self.fonts[key] then
        self.fonts[key] = love.graphics.newFont(f, size)
    end
    return self.fonts[key]
end

function AssetManager:getNewSound(f, ext)
    ext = ext or self.soundExt
    f = self.assetDir .. self.soundDir .. f .. ext
    return love.audio.newSource(f, "stream")
end

function AssetManager:getMusic(f, ext)
    ext = ext or self.musicExt
    f = self.assetDir .. self.musicDir .. f .. ext
    return love.audio.newSource(f, "stream")
end

return AssetManager
