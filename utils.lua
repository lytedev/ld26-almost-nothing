vector = require("hump.vector")
Class = require("hump.class")

local __newImage = love.graphics.newImage -- old function
function love.graphics.newImage( ... ) -- new function that sets nearest filter
   local img = __newImage( ... ) -- call old function with all arguments to this function
   img:setFilter( 'nearest', 'nearest' )
   return img
end
function love.graphics.newSmoothImage( ... )
    return __newImage( ... )
end

function sameColors(col1, col2)
    return col1[1] == col2[1] and col1[2] == col2[2] and col1[3] == col2[3] and col1[4] == col2[4]
end
