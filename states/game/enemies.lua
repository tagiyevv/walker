love.filesystem.load("states/game/player.lua")
love.filesystem.load("states/game/explosion.lua")
love.filesystem.load("states/game/bullets.lua")

enemy = {}

enemyRemoved = false

anims_en = {}

shoot_en = {
	state = false,
	time = 0,
	frame = 0,
	speed = 1,
	frame_count = 12,
}

local gunCoolClock
local gunReady = true

pass = 0

sheet_en = love.graphics.newImage("textures/enemy1.png")
sfx_shot_en = "sounds/enemy_shot_1.wav"

flash = false

anims_en["shoot"] = {}

for i=0,11 do
	anims_en["shoot"][i] = love.graphics.newQuad((i*100), 0, 100, 100, 1200, 100)
end

world = {
		gravity = 1035,
		ground = 512,
		}

function enemy:shoot()
	shoot_en.state = true
end

function enemy:stop()	
	self.x_vel = 0		
end

function enemy:collide( event,i )
	if event == "floor" then
		enemy[i].y_vel = 0
		enemy[i].standing = true
	end
	if event == "cieling" then
		enemy[i].y_vel = 0
	end
end

function newEnemy( x,y)
	local id = #enemy+1
	enemy[id] = {
		x = x,
		y = y,
		sx = 1,
		sy = 1,
		removed = false,
		x_vel = 0,
		y_vel = 5,
		speed = 50,
		flySpeed = 1500,
		state = "",
		h = 100,
		w = 100,
		standing = false,
		health = 8,
		}

	return id
end

function updateEnemy( dt )

	if gunCoolClock then gunCoolClock:update(dt) end

	if enemyRemoved then
		enemyRemoved = false
		for i=#enemy,1, -1 do
			if (enemy[i].removed == true) then
				table.remove(enemy,i)
			end
		end
	end

	for i,v in ipairs(enemy) do
		if (v.removed == false) then

			if enemy[i].y == 130 then shoot_en.state = true end

			pass = pass + dt

			--if shoot_en.frame > 10 then	
			--	shoot_en.state = false	
			--end
				if (pass > 0.8) then  --- REASON OF THE GLICH ---
					shoot_en.state = true 
				end


			if shoot_en.state then
				shoot_en.time = shoot_en.time+dt
				
				frame_time = shoot_en.speed/shoot_en.frame_count
				
				if shoot_en.time > frame_time then
					shoot_en.time = shoot_en.time-frame_time
					shoot_en.frame = shoot_en.frame + 1
					if shoot_en.state == true and (shoot_en.frame == 1 or shoot_en.frame == 5 or shoot_en.frame == 9) then 
						TEsound.play(sfx_shot_en,{"shot_en"},0.2,1.9)
						gunReady = true
					end

					if shoot_en.frame > 11 then  
						shoot_en.frame = 0
						shoot_en.state = false
						pass = 0
					end
				end
			end
		   
			local halfX = enemy[i].w / 2
			local halfY = enemy[i].h / 2

			enemy[i].y_vel = enemy[i].y_vel + (world.gravity * dt)

			enemy[i].y_vel = math.clamp(enemy[i].y_vel, -enemy[i].flySpeed, enemy[i].flySpeed)

			local nextY = enemy[i].y + (enemy[i].y_vel * dt)

			if enemy[i].y_vel > 0 then
				if not (enemy:isColliding(map, enemy[i].x - halfX, nextY + halfY))
					and not(enemy:isColliding(map, enemy[i].x + halfX -1, nextY + halfY)) then
					enemy[i].y = nextY
					enemy[i].standing = false
				else
					enemy[i].y = nextY  - ((nextY + halfY) % map.tileHeight)
					enemy:collide("floor",i)
				end

			end

			if shoot_en.state and shoot_en.frame == 1 and gunReady then  
				newBullet(enemy[i].x - 38, enemy[i].y + 12, 0.3, 0.3, -250,"fiend")
				gunReady = false
			end
			gunCoolClock = cron.after(3, function() gunReady = true end)

			if shoot_en.state and shoot_en.frame == 5 and gunReady then  
				newBullet(enemy[i].x - 40, enemy[i].y + 17, 0.3, 0.3, -250,"fiend")
				gunReady = false
			end
			gunCoolClock = cron.after(3, function() gunReady = true end)

			if shoot_en.state and shoot_en.frame == 9 and gunReady then  
				newBullet(enemy[i].x - 36, enemy[i].y + 19, 0.3, 0.3, -250,"fiend")
				gunReady = false
			end
			gunCoolClock = cron.after(3, function() gunReady = true end)

			explosion.state = false

			for j,w in ipairs(bullet) do
				flash = false

				if (bullet[j].tag =="foo")and(bullet[j].x > enemy[i].x-20)and(bullet[j].x<enemy[i].x+20)and(bullet[j].y < enemy[i].y+40)and(bullet[j].y > enemy[i].y-20) then
					enemy[i].health = enemy[i].health - 3
					newHit(w.x-12,w.y-20) --- MISPLACED ---
					flash = true

					removeBullet(j)
					if enemy[i].health < 0 then
						removeEnemy(i)
						newExplosion(v.x,v.y)
					end
				end
			end
		end
	end

end

function drawFlash()
	for i,v in ipairs(enemy) do
		if flash then
			love.graphics.circle( "fill", v.x, v.y ,10, 100 )
		end
	end
end


function drawEnemy()
	for i,v in ipairs(enemy) do
		if not enemy[i].removed then
				love.graphics.setColor(50,205,50)
				love.graphics.rectangle( "fill", v.x - v.w/2 + 6, v.y - v.h/2 + 6, v.health*3, 6 )
				love.graphics.setColor(255,255,255)
			if shoot_en.state then
				love.graphics.draw(sheet_en, anims_en["shoot"][shoot_en.frame], v.x - v.w/2, v.y - v.h/2)
			else	
				love.graphics.draw(sheet_en, anims_en["shoot"][0], v.x - v.w/2, v.y - v.h/2)
			end
		end
	end
end

function removeEnemy(i)
   enemy[i].removed = true
   enemyRemoved = true
end

function enemy:isColliding(map, x, y)
	local layer = map.tl["Solid"]
	local tileX, tileY = math.floor(x / map.tileWidth), math.floor(y / map.tileHeight)
	local tile = layer.tileData(tileX, tileY)
	return not(tile == nil)
end
