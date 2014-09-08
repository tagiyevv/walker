love.filesystem.load("states/game/player.lua")
love.filesystem.load("states/game/enemies.lua")

bullet = { }

bulletRemoved = false

bulletImage = love.graphics.newImage("textures/bullet.gif")


function newBullet(x,y,sx,sy,X_Vel,tag) 

	local id = #bullet+1
	bullet[id] = {
   		tag = tag,
   		hit = false,
		x = x,
		y = y,
		sx = sx,
		sy = sy,
		X_Vel = X_Vel,
		removed = false,
		hit_state = false,
		time = 0,
		frame = 0,
		speed = 1,
		frame_count = 5,
	}

	return id
end

function updateBullets(dt)
   	if bulletRemoved then
      	bulletRemoved = false
      	for i = #bullet, 1, -1 do
        	if (bullet[i].removed == true) then
           		table.remove(bullet, i)
         	end
      	end
   	end
   
   	for i,v in ipairs(bullet) do
   		for j,w in ipairs(player) do
      		if (v.removed == false) then
        		v.x = v.x + bullet[i].X_Vel * dt
        		if v.tag == "foo" then
        			g = world.gravity
        		else
        			g = world.gravity*4
        		end
        		v.y = v.y + .5*g*dt^2
      		end


      		if (bullet[i].x > player[j].x + 640) or ( bullet[i].x < player[j].x - 340 ) then
        		removeBullet(i)
      		end
      	end
   end


end

function drawBullets()
   	for i,v in ipairs(bullet) do
      	love.graphics.draw(bulletImage, v.x, v.y, 0, v.sx, v.sy)
   	end
end

function removeBullet(i)
   bullet[i].removed = true
   bulletRemoved = true
end


-- bullet hit --

hit = {}

sheet_hit = love.graphics.newImage("textures/bullet_hit.png")
--sfx_hit = ""

anims_hit = {}

for i = 0,4 do
	anims_hit[i] = love.graphics.newQuad((i*50),0,50,46,250,46)
end

function newHit(x,y)   --- hit sounds and animations will be added ---

	local id = #hit+1
	hit[id] = {
		x = x,
		y = y,
		removed = false,
		time = 0,
		frame = 0,
		speed = 0.6,
		frame_count = 5,
	}

	return id
end

function updateHit( dt )
	if hitRemoved then
		hitRemoved = false
		for i=#hit,1,-1 do
			if (hit[i].removed == true) then
				table.remove(hit,i)
			end
		end
	end

	for i,v in ipairs(hit) do
		if not v.removed then
			hit[i].time = hit[i].time + dt
			frame_hit_time = hit[i].speed / hit[i].frame_count

			if hit[i].time > frame_hit_time then
				hit[i].time = hit[i].time - frame_hit_time
				hit[i].frame = hit[i].frame + 1
				--if hit[i].frame == 1 then
				--	TEsound.play(sfx_hit,{"hit"},1,1)
				--end
			end
		end
	end 
end

function drawHit()

	for i,v in ipairs(hit) do
		if not hit[i].removed then
			if hit[i].frame < 4 then
				love.graphics.draw(sheet_hit, anims_hit[hit[i].frame], v.x, v.y)
			end
		end
	end

end

function removeHit(i)
	hit[i].removed = true
	hitRemoved = true
end

