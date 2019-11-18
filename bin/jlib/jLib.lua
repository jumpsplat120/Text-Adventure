local path    = ...
local folder  = string.match(path, ".*/")  or ""
local bitser  = require(folder .. "bitser")
local inspect = require(folder .. "inspect")

--[[
			___  ___       ___  ________     
		   |\  \|\  \     |\  \|\   __  \    
		   \ \  \ \  \    \ \  \ \  \|\ /_   
		 __ \ \  \ \  \    \ \  \ \   __  \  
		|\  \\_\  \ \  \____\ \  \ \  \|\  \ 
		\ \________\ \_______\ \__\ \_______\
		 \|________|\|_______|\|__|\|_______|

		Made by Antimony Apodaca - v0.6.0
	Unlicense License - http://unlicense.org/

	I'm bad at versioning well, but the most updated
	version will always be on Github. If you got this
	from anywhere else it may not be the most updated
	version.

	Modules required in same folder as jLib...  bitser.lua
												inspect.lua

--]]

local jLib    = {
	window = {},
	color  = {
		clear      = {0,0,0,0}    --NO COLOR
		white      = {1,1,1,1}    --#FFFFFF
		grey       = {.5,.5,.5,1} --#7F7F7F
		gray       = {.5,.5,.5,1} --#7F7F7F
		black      = {0,0,0,1}    --#000000
		red        = {1,0,0,1}    --#FF0000
		green      = {0,1,0,1}    --#00FF00
		blue       = {0,0,1,1}    --#0000FF
		yellow     = {1,1,0,1}    --#FFFF00
		magenta    = {1,0,1,1}    --#FF00FF
		light_blue = {0,1,1,1}    --#00FFFF
		purple     = {.5,0,1,1}   --#FF6600
		orange     = {1,.5,0,1}   --#6600FF 
	},
	mouse  = {
		x = love.mouse.getX()
		y = love.mouse.getY()
	},
	error  = {
		state      = false,
		bg_color   = {0,1,1,1}, --light_blue
		text_color = {1,1,1,1}, --white
		message    = "Default Error Message"
	},
	time   = {
		runtime = 0
		dt      = 0
	},
	logging = true
}

jLib.window.width, jLib.window.height, jLib.window.flags = love.window.getMode()
jLib.window.cx = jLib.window.width / 2
jLib.window.cy = jLib.window.height / 2

math.randomseed(os.time())

-----------------------------FUNCTIONS-----------------------------

--For use in LOVE; place in love.update() after all other updated elements.
function jLib.update(dt)
	jLib.time.runtime = jLib.time.runtime + dt
	jLib.time.dt = dt
end

--For use in LOVE; place in love.draw() after all other drawn elements.
function jLib.draw()
	local win, err
	
	win = jLib.window
	err = jLib.error
	
	if err.state then
		local bgColor, textColor, text
		
		bgColor   = err.bg_color
		textColor = err.text_color
		text      = err.message
		
		local x, y, wrap, align
		
		x     = win.cx
		y     = win.cy
		wrap  = win.width 
		align = "center"
		
		love.graphics.clear()
		love.graphics.setBackgroundColor(bgColor)
		love.graphics.setColor(textColor)
		love.graphics.printf(text, x, y, wrap, align)
	end
end

--FOR use in LOVE; place in love.mousemoved() after all other elements.
function jLib.mousemoved(x, y, dx, dy)
	jLib.mouse.x = x
	jLib.mouse.y = y
end

--Wrapper function for inspect. Returns the readable string
function jLib.read(table)
	return inspect(table)
end

--Call jLib.setError(any_string or true) to cause a custom error screen that isn't actually an error. Pass error false or no arg to turn custom error off
function jLib.setError(err)
	local error = jLib.error
	
	if err then
		error.message = err or "A generic error was thrown!"
		error.state   = true
	else
		error.message = "Default Error Message"
		error.state   = false
	end
	
	jLib.error = error
end

--Helper function that checks to see if a table is empty
function jLib.isEmpty(table)
	if next(table) == nil then return true else return false end
end

--Wrapper function for bitser serialization
function jLib.stringify(t)
	return bitser.dumps(t)
end

--Wrapper function for bister deserialization
function jLib.destringify(str)
	return bitser.loads(str)
end

--Map one range to another
function jLib.map(from_min, from_max, to_min, to_max, input)
	return (input - from_min) * (to_max - to_min) / (from_max - from_min) + to_min
end

--Helper function to determine if a number is even or not
function jLib.isEven(num)
	return num % 2 == 0
end

--Returns the input if between two values, else returns the min if smaller than and max if bigger than
function jLib.constrain(min, max, input)
	return (input < min and min) or (input > max and max) or input
end

--Returns direction in radians. Assumes pointing to right
function jLib.getDir(fromX, fromY, toX, toY)
	return math.atan2(toY - fromY, toX - fromX)
end

--Converts radians to degrees
function jLib.radToDeg(num)
	return num * 180 / math.pi
end

--Converts degrees to radians
function jLib.degToRad(num)
	return num * math.pi / 180
end

-- Returns the HSV equivalent of the given RGB-defined color. Taken from here: https://gist.github.com/GigsD4X/8513963 and modified by me. RGB = 0 - 255
function jLib.RGBtoHSV(r, g, b)
	local h, s, v
	
	local min = math.min(r, g, b)
	local max = math.max(r, g, b)
	
	local vdt = max - min
	
	v = max
	
	if not (max == 0) then
		s = vdt / max
		if r == max then
			h = (g - b) / vdt
		elseif g == max then
			h = 2 + (b - r) / vdt
		else
			h = 4 + (r - g) / vdt
		end
		
		h = h * 60
		
		if h < 0 then h = h + 360 end
		
		return h, s, v
	else 
		return -1, 0, v
	end
end

--Returns the RGB equivalent of the given HSV-defined color. Taken from here: https://gist.github.com/GigsD4X/8513963 and modified by me H = 0 - 359, SV = 0 - 1
function jLib.HSVtoRGB(h, s, v)
	if s == 0 then return v, v, v end
	
	--HUE_SECTOR, HUE_SECTOR_OFFSET
	local hsec, hsecoff
	local p, q, t
	
	hsec = math.floor(h / 60)
	hsecoff = (h / 60) - hsec

	p = v * (1 - s)
	q = v * (1 - s * hsecoff)
	t = v * (1 - s * (1 - hsecoff))

	if     hsec == 0 then return v, t, p
	elseif hsec == 1 then return q, v, p
	elseif hsec == 2 then return p, v, t
	elseif hsec == 3 then return p, q, v
	elseif hsec == 4 then return t, p, v
	elseif hsec == 5 then return v, p, q
	end
end

--Returns a cycling sine wave that starts at zero, and goes up to 'size' and down to '-size' at 'speed' cycles a second. Use offset to change when it starts cycling, to avoid all instances of jLib.sineWave cycling at the same time.
function jLib.sineWave(size, speed, offset)
	local speed  = speed  or 1
	local size   = size   or 1
	local offset = offset or 0
	
	return math.sin((jLib.time.runtime + offset) * speed) * size
end

--Simple helper function that returns a string timestamp of the moment the function was called. Used internally for jLib.log
function jLib.timestamp()
	local time = os.date("*t")
	return "[" .. string.format("%02d", time.hour) .. ":" .. string.format("%02d", time.min) .. ":" .. string.format("%02d", time.sec) .. "]"
end

--Simple log function that allows you to print a message to console along with the time the message is being printed.
function jLib.log(str)
	if jLib.logging then print(jLib.timestamp() .. " " .. str) end
end

return jLib