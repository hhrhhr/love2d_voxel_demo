require("control")
require("minimap")
require("map")

local lg = love.graphics
local R2D = 180.0 / math.pi

screen = screen or {}
map = map or {}
camera = camera or {}
mini = mini or {}
move = move or {}
util = util or {}


function love.load()
    screen.onResize()
    map.load(1)
    mini.load(1)
    lg.setLineStyle("rough")
    lg.setPointSize(2)
end

function love.keypressed(k, u, r)
    move.onKeyPressed(k, u, r)
end

function love.keyreleased(k, u, r)
    move.onKeyReleased(k, u, r)
end

function love.update(dt)
    move.onUpdate(dt)
end

local fmt = [[
FPS: %2d; X,Y,Z = %.1f, %.1f, %.1f; dist: %4d; hor: %4d LOD: %.3f; ang: %5.1f
FOV: %2d; near: %.0f; aspect: %.3f
]]
function love.draw()
    map.render()
    mini.render()
    
    local str = fmt:format(love.timer.getFPS(), camera.x, camera.y, camera.z,
        camera.distance, camera.h, camera.lod, camera.angle * R2D,
        camera.fov * R2D * 2.0, camera.near, screen.a)
    lg.print(str, 0, 0)
end
