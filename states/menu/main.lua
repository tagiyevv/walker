love.filesystem.load("states/menu/menu.lua")
menu = require('states/menu/menu')

imageLogo      = love.graphics.newImage("textures/walkertextlogo.png")	
bg_slide_image = love.graphics.newImage("textures/background.png")
line           = love.graphics.newImage("textures/line.png")

function load()
	require("TEsound")

	TEsound.playLooping("sounds/bg_music/castamere.ogg","bg_music", 0.2)

	game_menu = menu.new()
	game_menu:addItem{
		name = "START GAME",
		action = function()
			loadState("game")
			TEsound.stop("bg_music")
		end
	}
	game_menu:addItem{
		name = "ABOUT",
		action = function()
			---
		end
	}
	game_menu:addItem{
		name = "QUIT",
		action = function()
			love.event.push("quit")
		end
	}
end

dark_time  = 0
bg_slide_x = 70
alpha = 0
fade_in = false
function love.update( dt ) 
	game_menu:update(dt)

	local dt_local = 0.05
	bg_slide_x = bg_slide_x - 0.3

	if bg_slide_x < -320 then
		dark_time = dark_time + dt 
		alpha = alpha + 80*dt
		alpha = math.floor(alpha)
		if alpha > 250 then
			alpha = 255
			bg_slide_x = 70
			fade_in = true
		end
	end
	if fade_in then
		alpha = alpha - 60*dt
		alpha = math.floor(alpha)
		if alpha < 5 then 
			alpha = 0
			fade_in = false
		end
	end
end

function love.draw()
	love.graphics.setBackgroundColor(51,66,80)
	love.graphics.setColor(255,255,255)
	love.graphics.draw(bg_slide_image, bg_slide_x, love.graphics.getHeight()-bg_slide_image:getHeight())
	love.graphics.setColor(0,0,0,alpha)
	love.graphics.rectangle("fill", 70, 0, 150, 480)
	love.graphics.setColor(0,0,0)
	love.graphics.rectangle("fill", 0, 0, 70, 480 )
	love.graphics.rectangle("fill",220,0,420,480)
	love.graphics.setColor(255,255,255)
	for i = 0, love.graphics.getHeight() / line:getWidth() +1 do
		love.graphics.draw(line, 70, line:getWidth()*i, - math.pi/2)
		love.graphics.draw(line, 220, line:getWidth()*i, math.pi / 2)
	end



	love.graphics.setColor(255,255,255)
	love.graphics.setNewFont("fonts/guru.ttf",12)
	love.graphics.draw(imageLogo, 320, 40, 0, 1, 1 )
	love.graphics.print("version: V0.2.1",470,110)
	game_menu:draw(320,300)
end

function love.keypressed(key)
	game_menu:keypressed(key)
end
