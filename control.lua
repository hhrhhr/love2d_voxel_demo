move = {}
move.s = 64.0
move.x = 0
move.y = 0
move.z = 0
move.r = 0.0
move.h = 0

local lg = love.graphics
local sin = math.sin
local cos = math.cos
local PI = math.pi
local PI2 = PI * 2.0
local D2R = PI / 180.0

move.onKeyPressed = function(k, u, r)
    if k == "escape" then
        love.event.quit()
    end
    if k == "printscreen" then
        lg.newScreenshot():encode("tga", os.time() .. ".tga")
    end

    if k == "w" then
        move.y = -1
    elseif k == "s" then
        move.y = 1
    end
    if k == "a" then
        move.x = -1
    elseif k == "d" then
        move.x = 1
    end
    if k == "left" then
        move.r = -1
    elseif k == "right" then
        move.r = 1
    end
    if k == "up" then
        move.z = 1
    elseif k == "down" then
        move.z = -1
    end

    if k == "home" then
        camera.h = camera.h + 10
    elseif k == "end" then
        camera.h = camera.h - 10
    end
    if k == "kp+" then
        camera.distance = camera.distance + 64
        if camera.distance > 2048 then camera.distance = 2048 end
    elseif k == "kp-" then
        camera.distance = camera.distance - 64
        if camera.distance < 64 then camera.distance = 64 end
    end
    if k == "kp*" then
        camera.lod = camera.lod + 0.001
    elseif k == "kp/" then
        camera.lod = camera.lod - 0.001
        if camera.lod < 1.0 then camera.lod = 1.0 end
    end

    if k == "insert" then
        camera.fov = camera.fov + (5.0 * D2R)
        if camera.fov > 60 * D2R then camera.fov = 60 * D2R end
    elseif k == "delete" then
        camera.fov = camera.fov - (5.0 * D2R)
        if camera.fov < 15 * D2R then camera.fov = 15 * D2R end
    end

    if k == "pageup" then
        camera.near = camera.near + 4.0
        if camera.near > 256.0 then camera.near = 256.0 end
    elseif k == "pagedown" then
        camera.near = camera.near - 4.0
        if camera.near < 0.0 then camera.near = 0.0 end
    end

    if k == "m" then
        local num = math.random(1, 4)
        map.load(num)
        mini.load(num)
    end
    if k == "0" then
        camera.dot = not camera.dot
    end
end

move.onKeyReleased = function(k, u, r)
    if k == "a" or k == "d" then move.x = 0 end
    if k == "w" or k == "s" then move.y = 0 end
    if k == "right" or k == "left" then move.r = 0 end
    if k == "up" or k == "down" then move.z = 0 end
end

local function wrap(val, max)
    if val < 0.0 then
        return val + max
    elseif val > max then
        return val - max
    else
        return val
    end
end

move.onUpdate = function (dt)
    local ca = camera.angle
    local sdtcos = cos(ca) * move.s * dt
    local sdtsin = sin(ca) * move.s * dt
    if move.x ~= 0 then
        local valx = move.x * sdtcos
        local valy = move.x * sdtsin
        camera.x = wrap(camera.x + valx, map.w)
        camera.y = wrap(camera.y + valy, map.h)
    end
    if move.y ~= 0 then
        local valx = move.y * -sdtsin
        local valy = move.y * sdtcos
        camera.x = wrap(camera.x + valx, map.w)
        camera.y = wrap(camera.y + valy, map.h)
    end
    if move.z ~= 0 then
        camera.z = camera.z + move.z * move.s * dt
    end

    if move.r ~= 0 then
        local val = camera.angle
        val = val + move.r * 45.0*D2R * dt
        if val >= PI then
            val = val - PI2
        elseif val < -PI then
            val = val + PI2
        end
        camera.angle = val
    end
end
