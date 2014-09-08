
function clearLoveCallbacks()
	love.draw = nil
	love.joystickpressed = nil
	love.joystickreleased = nil
	love.keypressed = nil
	love.keyreleased = nil
	--love.load = nil
	love.mousepressed = nil
	love.mousereleased = nil
	love.update = nil
end

function loadState(name)
	state = {}
	clearLoveCallbacks()
	local path = "states/" .. name
	require(path .. "/main")
	load()
end

function load()
end

function love.load()
	loadState("menu")
end
	
function love.draw()
--	currentState.draw()
end

function love.update(dt)
--	currentState.update(dt)
end

function love.focus(bool)
end

function love.keypressed(key, unicode)
end

function love.keyreleased(key)
end

function love.mousepressed(x, y, button)
end

function love.mousereleased(x, y, button)
end

function love.quit()
end
