j = require "bin/jlib/jLib"
c = require "bin/console/console"

function love.load()
	c.load()
end

function love.update(dt)
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

function c.readwrite(text)
end