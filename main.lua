c = require "bin/console/console"

function love.load()
	c.load()
end

function love.update(dt)
	c.update(dt)
end

function love.draw()
	c.draw()
end

function love.wheelmoved(x, y)
	c.wheelmoved(x, y)
end