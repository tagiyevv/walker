love.filesystem.load("states/game/enemy.lua")
explosion = {}

explosionRemoved = false

sheet_explosion = love.graphics.newImage("textures/explosion2.png")
sfx_explosion = "sounds/explosion.ogg"

anims_explosion = {}

for i=0,14 do
	anims_explosion[i] = love.graphics.newQuad((i*96),0,96,96,1440,96)
end

function newExplosion( x,y )
	local id = #explosion + 1
	explosion[id] ={
		x = x,
		y = y,
		state = false,
		time = 0,
		frame = 0,
		speed = 1,
		frame_count = 15,
		removed = false,
	}

	return id
end

function updateExplosion( dt )
	if explosionRemoved then
		explosionRemoved = false
		for i=#explosion,1,-1 do
			if (explosion[i].removed == true) then
				table.remove(explosion,i)
			end
		end
	end

	for i,v in ipairs(explosion) do
		if not v.removed then
			explosion[i].time = explosion[i].time + dt
			frame_ex_time = explosion[i].speed / explosion[i].frame_count

			if explosion[i].time > frame_ex_time then
				explosion[i].time = explosion[i].time - frame_ex_time
				explosion[i].frame = explosion[i].frame + 1
				if explosion[i].frame == 1 then
					TEsound.play(sfx_explosion,{"explosion"},1,1)
				end
			end
		end
	end 
end

function drawExplosion()
	for i,v in ipairs(explosion) do
		if not explosion[i].removed then
			if explosion[i].frame < 14 then
				love.graphics.draw(sheet_explosion, anims_explosion[explosion[i].frame], v.x-50, v.y-46)
			end
		end
	end
end

function removeExplosion(i)
	explosion[i].removed = true
	explosionRemoved = true
end


