require("utils")

local AssetManager = Class{
    function(self)
        self.assetDir =     "assets/"

        self.imageDir =     "img/"
        self.fontDir =      "font/"
        self.soundDir =     "sfx/"

        self.imageExt =     ".png"
        self.fontExt =      ".ttf"
        self.soundExt =     ".ogg"

        self.images = {}
        self.fonts = {}
        self.sounds = {}
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

function AssetManager:getSound(f, key, ext)
    ext = ext or self.soundExt
    key = key or f
    f = self.assetDir .. self.soundDir .. f .. ext
    if not self.sounds[key] then
        self.sounds[key] = love.graphics.newSound(f)
    end
    return self.sounds[key]
end

return AssetManager
