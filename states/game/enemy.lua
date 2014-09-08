love.filesystem.load("states/game/bullets.lua")

anims_en = {}

shoot_en = {
	state = false,
	time = 0,
	frame = 0,
	speed = 1,
	frame_count = 12,
}

pass = 0

sheet_en = love.graphics.newImage("textures/enemy1.png")
sfx_shot_en = "sounds/enemy_shot_1.wav"

anims_en["shoot"] = {}

for i=0,11 do
	anims_en["shoot"][i] = love.graphics.newQuad((i*100), 0, 100, 100, 1200, 100)
end

world = {
		gravity = 1035,
		ground = 512,
		}

enemy = {
		x=556,
		y=-100,
		x_vel = 0,
		y_vel = 5,
		speed = 50,
		flySpeed = 1500,
		state = "",
		h = 100,
		w = 100,
		standing = false,
		}

function enemy:shoot()
	shoot_en.state = true
end

function enemy:stop()	
	self.x_vel = 0		
end

function enemy:collide( event )
	if event == "floor" then
		self.y_vel = 0
		self.standing = true
	end
	if event == "cieling" then
		self.y_vel = 0
	end
end

function enemy:update( dt )
	if self.y_vel == 0 then shoot_en.state = true end

	pass = pass + dt

	if shoot_en.frame > 10 then	
		shoot_en.state = false	
	end
	if pass > 0.6 then 
		shoot_en.state = true 
		pass = 0
	end

	if shoot_en.state then
		shoot_en.time = shoot_en.time+dt
		
		frame_time = shoot.speed/shoot.frame_count
		
		if shoot_en.time > frame_time then
			shoot_en.time = shoot_en.time-frame_time
			shoot_en.frame = shoot_en.frame + 1
			if shoot_en.state == true and (shoot_en.frame == 1 or shoot_en.frame == 5 or shoot_en.frame == 9) then 
				TEsound.play(sfx_shot_en,{"shot_en"},0.2,1.9)
			end

			if shoot_en.frame > 11 then  
				shoot_en.frame = 0 
			end
		end
	end
   
	local halfX = self.w / 2
	local halfY = self.h / 2

	self.y_vel = self.y_vel + (world.gravity * dt)

	self.y_vel = math.clamp(self.y_vel, -self.flySpeed, self.flySpeed)

	local nextY = self.y + (self.y_vel * dt)

	if self.y_vel > 0 then
		if not (self:isColliding(map, self.x - halfX, nextY + halfY))
			and not(self:isColliding(map, self.x + halfX -1, nextY + halfY)) then
			self.y = nextY
			self.standing = false
		else
			self.y = nextY  - ((nextY + halfY) % map.tileHeight)
			self:collide("floor")
		end
	end

	if shoot_en.state and shoot_en.frame == 1 then  
		newBullet(enemy.x - 38, enemy.y + 12, 0.3, 0.3, -250)
	end

	if shoot_en.state and shoot_en.frame == 5 then  
		newBullet(enemy.x - 40, enemy.y + 17, 0.3, 0.3, -250)
	end

	if shoot_en.state and shoot_en.frame == 9 then  
		newBullet(enemy.x - 36, enemy.y + 19, 0.3, 0.3, -250)
	end

end

function enemy:isColliding(map, x, y)
	local layer = map.tl["Solid"]
	local tileX, tileY = math.floor(x / map.tileWidth), math.floor(y / map.tileHeight)
	local tile = layer.tileData(tileX, tileY)
	return not(tile == nil)
end

function enemy:draw()
	if shoot_en.state then
		love.graphics.draw(sheet_en, anims_en["shoot"][shoot_en.frame], enemy.x - enemy.w/2, enemy.y - enemy.h/2)
	else	
		love.graphics.draw(sheet_en, anims_en["shoot"][0], enemy.x - enemy.w/2, enemy.y - enemy.h/2)
	end
end