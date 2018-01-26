local D2R = math.pi / 180.0
local lg = love.graphics
local li = love.image
local sin = math.sin
local cos = math.cos

screen = {}
screen.w = nil
screen.h = nil
screen.a = nil
screen.lod = 3

map = {}
map.w = nil
map.h = nil
map.w_ = nil
map.h_ = nil
map.color = nil
map.alt = nil

camera = {}
camera.angle = -45.0 * D2R
camera.distance = 256.0
camera.x = 568.0
camera.y = 230.0
camera.z = 78.0
camera.h = nil
camera.lod = 1.01
camera.fov = 75.0 * D2R * 0.5
camera.near = 4.0
camera.dot = false

screen.onResize = function(x, y)
    screen.w = x or love.graphics.getWidth()
    screen.h = y or love.graphics.getHeight()
    screen.a = screen.w / screen.h
    camera.h = screen.h / 3
end

map.load = function(num)
    map.color = li.newImageData("maps/C"..num.."W.png")
    map.w, map.h = map.color:getDimensions()
    map.w_, map.h_ = map.w - 1, map.h - 1

    map.alt = li.newImageData("maps/C"..num.."D.png")
end

map.render = function()
    lg.setLineWidth(screen.lod)
    local hy = {}   -- y-buffer
    for i = 0, screen.w-1 do hy[i] = screen.h end

    local la = camera.angle - camera.fov
    local ra = camera.angle + camera.fov
    local ll = 1.0 / cos(camera.fov)
    local sla, cla = sin(la) * ll, -cos(la) * ll
    local sra, cra = sin(ra) * ll, -cos(ra) * ll

    local z = camera.near
    local dz = 1.0
    local scale = 256.0 / sin(camera.fov) / ll
    local plx, ply, prx, pry

    while z < camera.distance do
        plx, ply = sla * z, cla * z
        prx, pry = sra * z, cra * z
        local dx = (prx - plx) / screen.w
        local dy = (pry - ply) / screen.w
        local dxi = plx + camera.x
        local dyi = ply + camera.y

        for i = 0, screen.w-1, screen.lod do
            -- wrap
            local mx = bit.band(dxi, map.w_) -- [0, width-1]
            local my = bit.band(dyi, map.h_) -- [0, height-1]

            local h = map.alt:getPixel(mx, my)
            local y1 = (camera.z - h) * scale / z + camera.h -- top
            local y2 = hy[i]                                 -- bottom
            if y1 < y2 then
                lg.setColor(map.color:getPixel(mx, my))
                if camera.dot then
                    lg.points(i, y1)
                else
                    lg.line(i, y1, i, y2)
                end
                hy[i] = y1
            end
            dxi = dxi + dx*screen.lod
            dyi = dyi + dy*screen.lod
        end
        z = z + dz
        dz = dz * camera.lod
    end
    mini.lx = plx * mini.s
    mini.ly = ply * mini.s
    mini.rx = prx * mini.s
    mini.ry = pry * mini.s
end