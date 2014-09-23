function load()
	AdvTiledLoader = require("AdvTiledLoader/Loader")
	cron           = require("cron")
	require("camera")
	require("TEsound")
	require("states/game/player")
	require("states/game/cloud")
	require("states/game/bullets")
	require("states/game/enemies")
	require("states/game/explosion")
	require("states/game/debug")
	require("states/game/hud")
	require("states/game/pause_menu")
	require("states/game/quit_dialog")
	require("states/game/rain")
	require("states/game/ray")
	require("states/game/boss1")

	love.graphics.setBackgroundColor(51,66,80)
	bg = love.graphics.newImage("textures/background.png")
	--camera deflection
	camera.time  =  0
	camera.speed = 50
	camera.xmag  =  7
	camera.ymag  =  7
	--
	music_path = "sounds/bg_music/"
	bg_musics = {music_path.."gymnop01.ogg", music_path.."gnoss.ogg", music_path.."bwv639.ogg"}

	AdvTiledLoader.path = "maps/"
	map = AdvTiledLoader.load("map4.tmx")
	map:setDrawRange(0, 0, map.width * map.tileWidth, map.height * map.tileHeight)

	camera:setBounds(0,0, map.width * map.tileWidth - love.graphics.getWidth(), map.height * map.tileHeight - love.graphics.getHeight())

	-- PLAYER LEFT
	playerHeart = 3

	for i=1,5 do
		sr = 1
		newCloud(math.random(-2400,-160),math.random(0,150),sr,sr, math.random(16,64))
	end

	TEsound.playLooping(bg_musics,0.4)

	time = 0

	toggle_debug = false
	pause        = false --- PAUSE MENU SHIT  ---
	quit         = false --- QUIT DIALOG SHIT ---

	love.keyboard.setKeyRepeat(false)

	random_rays()


	--BOSS   find a way to organise it
	random_head_move()
	random_rocket_launch()
	random_arm_move()
end

function love.draw()

	if (not pause) then  ---NOT PAUSED ---
		camera:set()
		
		love.graphics.setColor(255,255,255)
		for i = 0, love.graphics.getWidth() / bg:getWidth() do
			love.graphics.draw(bg, i*bg:getWidth() + camera.x*0.5, (love.graphics.getHeight()-bg:getHeight() + camera.y*0.3),0,1,1,0,0)
		end
	
		drawPlayer()
		--drawClouds()
		drawEnemy()
		drawBoss()
		drawBullets()
		drawExplosion()
		drawHit()
		drawDrops()
		drawRays()


		love.graphics.setColor(255,255,255)
		map:draw()
		camera:unset()

		drawHud()
	elseif pause then --- PAUSED ---
		drawPauseMenu()
	end

	if toggle_debug then debug:draw() end 	--- DEBUG ---
end

--SHAKE IT
local shakeIt
local shake_it = false

function love.update(dt)

	newDrop()

	if shakeIt then shakeIt:update(dt) end

	if not pause then

		time = time + dt
	
		TEsound.cleanup()
	
		if dt > 0.05 then
			dt = 0.05
		end
		
		for i,v in ipairs(player) do
			camera:setPosition(player[i].x - (love.graphics.getWidth()/2)+100, player[i].y - (love.graphics.getHeight()/2))
		end

		--updateClouds(dt)
		updateBullets(dt)
		updateEnemy(dt)
		updateExplosion(dt)
		updateHit(dt)
		updatePlayer(dt)
		updateDrops(dt)
		updateRays(dt)
		updateHud(dt)
	
		updateBoss(dt)

		for i,v in ipairs(player) do
			if v.removed  then 
				shake_it = true 
				shakeIt = cron.after(2, function() shake_it = false; camera.time = 0 end)
			end
		end
		shakeCamera(dt)
	else
		updatePauseMenu(dt)
	end

end

function love.keypressed(key)
   	if key == 'escape' then
   		--quit = not quit
    	love.event.push('quit')
	elseif key == 'e' then
		for i,v in ipairs(player) do
			if #player > 0 then
				newEnemy((player[i].x+math.random(150,250)),-100,1,1)
			end
		end
	elseif key == 'p' then
		pause = not pause		
	elseif key == 'd' then
		toggle_debug = not toggle_debug
	elseif key == 's' then
		if (#player == 0) and playerHeart > 0 then
			newPlayer(camera.x+100, camera.y)
			playerHeart = playerHeart - 1
		end
	end
	player:keypressed(key)
	pausem:keypressed(key)
	bos:keypressed(key)
end

function love.keyreleased(key)
	player:keyreleased(key)
end

function shakeCamera( dt )
	if shake_it then
		camera.time = camera.time + dt
	 	if camera.time < 1.7 then 
	 		camera.x = 0.8*camera.xmag * math.sin(camera.time * camera.speed ) * math.exp(-2*camera.time)
	 		camera.y = 0.8*camera.ymag * math.sin(camera.time * camera.speed) * math.exp(-camera.time)
	 	end
	end
end

