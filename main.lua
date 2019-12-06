j = require "bin/jlib/jLib"
c = require "bin/console/console"

function love.load()
	c.startWith("Welcome to Atrai, newcomer. I haven't seen you around these parts before. What is your name?")
	c.load()
end

function love.update(dt)
	think()
	c.update(dt)
	j.update(dt)
end

function love.draw()
	c.draw()
	j.draw()
end

function love.mousemoved(x, y, dx, dy)
	j.mousemoved(x, y, dx, dy)
end

function love.wheelmoved(x, y)
	c.wheelmoved(x, y)
end

-----------------------------------

local game = {
	step  = 1,
	stats = {},
	dictionary = {
		greeting  = {"hello", "hi", "yo"},
		positive  = {"yes", "yup", "mhm", "okay", "uh huh"},
		negative  = {"no", "nope", "no thanks", "uh uh"}
	},
	think = {
		timer = 0,
		dot   = 1,
		prev  = 0
	}
}

local at = {
	function(text)
		local stats = game.stats		
		
		stats.name = text
	end
}

function start_thinking(sec)
	game.think.timer = j.runtime + sec
end

function think()
	local time, think, timer, prev, dot, wait, text
	
	time  = j.time.runtime
	think = game.think
	timer = think.timer
	prev  = think.prev
	dot   = think.dot
	wait  = timer - time
	
	if j.round(timer) ~= prev then
		prev = j.round(timer)
		dot = j.inc(dot)
		dot = dot > 3 and 1 or dot
	end
	
	text = dot == 1 and ".  " or dot == 2 and " . " or dot == 3 and "  ." or false
	
	if c.text.str == text then return else c.text.str[#c.text.str] = text end
end

function roughMatch(text, array)
	local found
	
	for i = 1, #array do
		local check = string.match(text:lower(), array[i])

		if check then 
			found = check
			break
		end
	end
	
	return found or false
end

function responseTo(text, current_step)
	response = current_step(text) or "There is no response for " .. text
	
	return text, response
end

function c.readwrite(text)
	if text then
		start_thinking()
		return responseTo(text, at[game.step])
	end
end