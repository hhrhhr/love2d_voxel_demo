mini = {}
mini.w = 128
mini.h = 128
mini.s = nil
mini.img = nil
mini.q = nil
mini.lx = -mini.w * 0.5
mini.ly = mini.h * 0.5
mini.rx = mini.w * 0.5
mini.ry = mini.h * 0.5

local lg = love.graphics

mini.load = function(num)
    mini.img = lg.newImage("maps/C"..num.."W_mini.png")
    mini.img:setWrap("repeat", "repeat")
    mini.q = lg.newQuad(0, 0, mini.w, mini.h, mini.w, mini.h)
    mini.s = mini.w / map.w
end

mini.render = function()
    local w1 = mini.w
    local h1 = mini.h
    local w2 = w1 * 0.5
    local h2 = h1 * 0.5
    local h0 = screen.h
    local ph = h0 - h2

    mini.q:setViewport(camera.x * mini.s + w2, camera.y * mini.s + h2, w1, h1)
    
    lg.setColor(255,255,255)
    lg.setLineWidth(1)
    
    lg.draw(mini.img, mini.q, 0, h0 - h1)

    local x1, y1 = w2+mini.lx, ph+mini.ly
    local x2, y2 = w2+mini.rx, ph+mini.ry
    lg.line(w2, ph, x1, y1, x2, y2, w2, ph)
    lg.points(w2, ph)
end