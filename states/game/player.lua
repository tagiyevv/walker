love.filesystem.load("states/game/bullets.lua")
love.filesystem.load("states/game/explosion.lua")

local  cron = require("cron")

player = {}

playerRemoved = false

anims = {}

walk = {
		time = 0,
		frame = 0,
		speed = 0.7,
		frame_count = 8,
		}

shoot = {
		state = false,
		time = 0,
		frame = 0,
		speed = 0.9,
		frame_count = 13,
	}

jump = {
		state = false,
		speed = 1.0,
		time = 0,
		frame = 0,
		frame_count = 13,
		}

sfx_move_right 	= "sounds/robostep.wav"
sfx_shot 		= "sounds/cannon.ogg"

sheet = love.graphics.newImage("textures/rustbug.png")
shade = love.graphics.newImage("textures/shade.png")

anims["idle_right"] = love.graphics.newQuad(0, 40, 70, 40, 910, 160)
anims["idle_left"] = love.graphics.newQuad(0, 40, 70, 40, 910, 160)

anims["jump"] = {}
for i = 0,12 do
	anims["jump"][i] = love.graphics.newQuad((i*70), 80, 70, 40, 910, 160)
end

anims["walk_right"] = {}
anims["walk_left"]	= {}
anims["shoot"]		= {} 

for i=0,7 do
	anims["walk_right"][i] = love.graphics.newQuad((i*70), 0, 70, 40, 910, 160)
	anims["walk_left"][i] =	love.graphics.newQuad(560-((i+1)*70), 0, 70, 40, 910, 160)
end

for i=0,12 do
	anims["shoot"][i] = love.graphics.newQuad((i*70), 40, 70, 40, 910, 160)
end

anims["hoover_right"] = {}
anims["hoover_left"] = {}

for i=0,11 do
	anims["hoover_right"][i] = love.graphics.newQuad(70+(i*70), 120, 70, 40, 910, 160)
	anims["hoover_left"][i] =	love.graphics.newQuad(840-((i+1)*70), 120, 70, 40, 910, 160)
end	

local gunCoolClock
local gunReady = true

function player:jump()
	jump.frame = 0
	for i,v in ipairs(player) do
		if player[i].standing then	
			player[i].y_vel = player[i].jump_vel
			player[i].standing = false
		end 
		jump.state = true 
	end
end

function player:right()
	for i,v in ipairs(player) do
		player[i].x_vel = player[i].speed
		last_direction = 1
		move_right = true
		move_left = false
	end
end

function player:left()
	for i,v in ipairs(player) do
		player[i].x_vel = -1 * (player[i].speed)
		move_left = true
		move_right = false
	end
end

function player:shoot()
	shoot.state = true
end

--function player:hoover()
--	hoover.state = true
--end

function player:stop()
	for i,v in ipairs(player) do
		player[i].x_vel = 0		
	end
end

function player:collide( event )
	for i,v in ipairs(player) do
		if event == "floor" then
			player[i].y_vel = 0
			player[i].standing = true
		end
		if event == "cieling" then
			player[i].y_vel = 0
		end
	end
end

function newPlayer( x,y )
	local id = #player + 1
	player[id] = {
		x=x,
		y=y,
		x_vel = 0,
		y_vel = 0,
		jump_vel = -512,
		speed = 50,
		flySpeed = 1500,
		state = "",
		h = 40,
		w = 70,
		standing = false,
		removed = false,
		health = 100,
		}

	return id
end

function updatePlayer( dt )

	if gunCoolClock then gunCoolClock:update(dt) end
	
	if playerRemoved then
		playerRemoved = false
		for i=#player,1, -1 do
			if (player[i].removed == true) then
				table.remove(player,i)
			end
		end
	end

	for i,v in ipairs(player) do
		if not v.removed then
			--if gunCoolDownClock then gunCoolDownClock:update(dt) end

			if love.keyboard.isDown("right") then
				player:right()
			end
			if love.keyboard.isDown("left") then
				player:left()
			end
			if love.keyboard.isDown("up") then
				player:jump()
			end
		
			if move_right then
				walk.time = walk.time+dt
				shoot.state = false

				frame_time = walk.speed/walk.frame_count
			
				if walk.time > frame_time then
					walk.time = walk.time-frame_time
	
					if walk.frame == 0 and not jump.state then
	   					TEsound.play(sfx_move_right)
					end
	
					walk.frame=walk.frame+1
	
					if walk.frame>7 then walk.frame=0 end

				end
			end
	
			if move_left then
	
				walk.time = walk.time+dt
				shoot.state = false
	
				frame_time = walk.speed/walk.frame_count

				if walk.time > frame_time then
					walk.time = walk.time-frame_time
	
					if walk.frame == 0 and not jump.state then
	       				TEsound.play(sfx_move_right,{"left"},0.8,.96)
					end
	
					walk.frame=walk.frame+1
	
					if walk.frame>7 then walk.frame=0 end

				end
			end
	
			if shoot.state then
				shoot.time = shoot.time+dt
				
				frame_time = shoot.speed/shoot.frame_count
				
				if shoot.time > frame_time then
					shoot.time = shoot.time-frame_time
					shoot.frame=shoot.frame+1
					if shoot.frame == 3 then 
						TEsound.play(sfx_shot,{"shot"},.7,1)
					end
					if shoot.frame > 12 then shoot.frame = 0; gunReady = true end
				end
			end	
	
			if jump.state then
				jump.time = jump.time + dt
				frame_time = jump.speed / jump.frame_count
	
				if jump.time > frame_time then
					jump.time = jump.time - frame_time
					jump.frame = jump.frame + 1
					if jump.frame > 12 then jump.frame = 0 end
				end
	    	end
	
	    	if player.y_vel == 0 then jump.frame = 0 end
		    
			local halfX = player[i].w / 2
			local halfY = player[i].h / 2
	
			player[i].y_vel = player[i].y_vel + (world.gravity * dt)
	
			player[i].x_vel = math.clamp(player[i].x_vel, -player[i].speed, player[i].speed)
			player[i].y_vel = math.clamp(player[i].y_vel, -player[i].flySpeed, player[i].flySpeed)
	
			
			local nextY = player[i].y + (player[i].y_vel * dt)
			if player[i].y_vel < 0 then
				if not (player:isColliding(map, player[i].x - halfX + 5, nextY -halfY))
					and not (player:isColliding(map, player[i].x + halfX -1 -15, nextY - halfY)) then
					player[i].y = nextY
					player[i].standing = false
				else
					player[i].y = nextY + map.tileHeight - ((nextY -halfY) % map.tileHeight)
					player:collide("cieling")
				end
			end
			if player[i].y_vel > 0 then
				if not (player:isColliding(map, player[i].x - halfX + 5, nextY + halfY))
					and not(player:isColliding(map, player[i].x + halfX -1 - 15, nextY + halfY)) then
				
					player[i].y = nextY
					player[i].standing = false
				
				else
					player[i].y = nextY  - ((nextY + halfY) % map.tileHeight)
					player:collide("floor")
				end
			end

	
			local nextX = player[i].x + (player[i].x_vel * dt)
			if player[i].x_vel > 0 then
				if not(player:isColliding(map, nextX + halfX - 15, player[i].y - halfY)) -- -15 IS THE IMAGE CUT
					and not (player:isColliding(map, nextX + halfX - 15 , player[i].y + halfY -1 )) then
					player[i].x = nextX
				else
					player[i].x = nextX - ((nextX + halfX - 15) % map.tileWidth)
				end
			elseif player[i].x_vel < 0 then
				if not(player:isColliding(map, nextX - halfX + 5 , player[i].y - halfY))
					and not (player:isColliding(map, nextX - halfX + 5 , player[i].y + halfY -1 )) then
					player[i].x = nextX
				else
					player[i].x =nextX + map.tileWidth - ((nextX - halfX + 5) % map.tileWidth)
				end
			end
	
			player[i].state = player:getState()
			if player[i].standing then jump.state = false end
	
			--BULLET
			if shoot.state and shoot.frame == 5 and gunReady then
				newBullet(player[i].x + 12, player[i].y - 6,.7,.7, 512,"foo")
				gunReady = false
			end
			gunCoolClock = cron.after(0.7, function()
				gunReady = true 
			end)

			for j,w in ipairs(bullet) do
				
				if (bullet[j].tag =="fiend") and (bullet[j].x > player[i].x-math.random(10,20))and(bullet[j].x<player[i].x+math.random(-10,0))and(bullet[j].y < player[i].y+20)and(bullet[j].y > player[i].y-20) then
					player[i].health = player[i].health - 4
					newHit(w.x-12,w.y-20) --- MISPLACED ---

					removeBullet(j)
					if player[i].health < 0 then
						player[i].health = 0
						removePlayer(i)
						newExplosion(v.x + 16,v.y - 32)
					end
				end
			end
		end
	end
end

function drawPlayer()
	for i,v in ipairs(player) do
		if not player[i].removed then
				love.graphics.setColor(255,255,255)
			if move_right then
				if jump.state then
					love.graphics.draw(sheet, anims["jump"][jump.frame], v.x - v.w/2, v.y - v.h/2)
				else
					love.graphics.draw(sheet, anims["walk_right"][walk.frame], v.x - v.w/2, v.y - v.h/2)
				end	
		
			elseif move_left then
				if jump.state then
					if jump.frame>12 then jump.frame=0 end
					love.graphics.draw(sheet, anims["jump"][jump.frame], v.x - v.w/2, v.y - v.h/2)
				else
					love.graphics.draw(sheet, anims["walk_left"][walk.frame], v.x - v.w/2, v.y - v.h/2)
				end
		
			elseif shoot.state then
				love.graphics.draw(sheet, anims["shoot"][shoot.frame], v.x - v.w/2, v.y - v.h/2)
			
			elseif jump.state then
				if walk.frame>7 then walk.frame=0 end
				love.graphics.draw(sheet, anims["jump"][jump.frame], v.x - v.w/2, v.y - v.h/2)
			
			else
				if last_direction == 1 then 
					if jump.state then
						love.graphics.draw(sheet, anims["jump"][jump.frame], v.x - v.w/2, v.y - v.h/2)
					else
						love.graphics.draw(sheet, anims["idle_right"], v.x - v.w/2, v.y - v.h/2)
					end
				else	
					if jump.state then
						love.graphics.draw(sheet, anims["jump"][jump.frame], v.x - v.w/2, v.y - v.h/2)
					else
						love.graphics.draw(sheet, anims["idle_left"], v.x - v.w/2, v.y - v.h/2)
					end
				end
			end
		end
	end
end

function removePlayer(i)
   player[i].removed = true
   playerRemoved = true
end

function player:isColliding(map, x, y)
	local layer = map.tl["Solid"]
	local tileX, tileY = math.floor(x / map.tileWidth), math.floor(y / map.tileHeight)
	local tile = layer.tileData(tileX, tileY)
	return not(tile == nil)
end

function player:getState()
	for i,v in ipairs(player) do
		local tempState = ""
		if player[i].standing then
			if player[i].x_vel > 0 then
				tempState = "right"
			elseif player[i].x_vel < 0 then
				tempState = "left"
			else
				tempState = "stand"
			end
		end
		if player[i].y_vel > 0 then
			tempState = "fall"
		elseif player[i].y_vel < 0 then
			tempState = "jump"
		else
			tempState = "stand"
		end
	end
end

function player:keyreleased( key )
	for i,v in ipairs(player) do
		if (key =="left") or (key == "right") then
			player[i].x_vel = 0
			move_right = false
			move_left = false
			walk.frame=0
			walk.time=0
		end
		
		if key == ' ' and #player > 0 then
			last_direction = 2
        	shoot.state = false
			walk.frame=0
			walk.time=0
    	end
	
	end
end

function player:keypressed( key , isrepeat)
	if (key ==' ') then
		shoot.state = true
	end
end
