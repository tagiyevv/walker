
local headClock
local backClock
local barmClock
local headReady = true
local backReady = true
local barmReady = true

--local rand_int = {3,5,4,2}


boss = {
	body = {
		time  = 0,
		frame = 0,
		speed = 1,
		frame_count = 2 
		},
	head = {
		time  = 0,
		frame = 0,
		speed = 1,
		frame_count = 15,
		state = false
		},
	back = {
		time  = 0,
		frame = 0,
		speed = 2.3,
		frame_count = 13,
		state = false
		},
	front_arm = {
		time  = 0,
		frame = 0,
		speed = 1.1,
		frame_count = 2,
		state = false
	},
	back_arm = {
		time  = 0,
		frame = 0,
		speed = 1.1,
		frame_count = 8,
		state = false
	}
}

bos ={}
anims_boss = {}
anims_boss["body"] = {}
anims_boss["head"] = {}
anims_boss["back"] = {}
anims_boss["front_arm"] = {}
anims_boss["back_arm"] ={}


boss_body = love.graphics.newImage("textures/boss/boss1_body.png")
boss_head = love.graphics.newImage("textures/boss/boss1_head.png")
boss_back = love.graphics.newImage("textures/boss/boss1_back1.png")
boss_front_arm = love.graphics.newImage("textures/boss/boss1_front_arm.png")
boss_back_arm = love.graphics.newImage("textures/boss/boss1_back_arm.png")



for i = 0,1 do
	anims_boss["body"][i] = love.graphics.newQuad((i*78), 0, 78, 86, 156, 86)
end

for i = 0,14 do
	anims_boss["head"][i] = love.graphics.newQuad((i*93), 0, 93, 120, 1395, 120)
end
for i = 0,12 do
	anims_boss["back"][i] = love.graphics.newQuad((i*65), 0, 65, 70, 845, 70)
end
for i = 0,1 do
	anims_boss["front_arm"][i] = love.graphics.newQuad((i*85), 0, 85, 74, 170, 74)
end
for i = 0,7 do
	anims_boss["back_arm"][i] = love.graphics.newQuad((i*127), 0, 127, 119, 1016, 119)
end


boss_abs = {
	x = 2400 - 76,
	y = 202
}

function bos:rocket(  )
	boss.back.state = true
end

function bos:move_head( )
	boss.head.state = true
end
function bos:move_back_arm(  )
	boss.back_arm.state = true
end

function updateBoss( dt )

	if headClock then headClock:update(dt) end
	if backClock then backClock:update(dt) end
	if barmClock then barmClock:update(dt) end

	if boss.back.state then
		boss.back.time = boss.back.time + dt
		
		frame_time = boss.back.speed / boss.back.frame_count
		
		if boss.back.time > frame_time then
			boss.back.time = boss.back.time - frame_time
			boss.back.frame = boss.back.frame + 1

			if boss.back.frame > 12 then  
				boss.back.frame = 0 
				boss.back.state = false
			end
		end
	end

	if boss.head.state then
		boss.head.time = boss.head.time + dt
		
		frame_time = boss.head.speed / boss.head.frame_count
		
		if boss.head.time > frame_time then
			boss.head.time = boss.head.time - frame_time
			boss.head.frame = boss.head.frame + 1

			if boss.head.frame > 14 then  
				boss.head.frame = 0 
				boss.head.state = false
			end
		end
	end

	if boss.back_arm.state then
		boss.back_arm.time = boss.back_arm.time + dt
		
		frame_time = boss.back_arm.speed / boss.back_arm.frame_count
		
		if boss.back_arm.time > frame_time then
			boss.back_arm.time = boss.back_arm.time - frame_time
			boss.back_arm.frame = boss.back_arm.frame + 1

			if boss.back_arm.frame > 7 then  
				boss.back_arm.frame = 0 
				boss.back_arm.state = false
			end
		end
	end



end

function drawBoss()
	love.graphics.setColor(255,255,255,255)

	if not boss.back_arm.state then
		love.graphics.draw(boss_back_arm, anims_boss["back_arm"][0],boss_abs.x - 117 , boss_abs.y -30)
	else
		love.graphics.draw(boss_back_arm, anims_boss["back_arm"][boss.back_arm.frame],boss_abs.x -117, boss_abs.y -30)
	end

	love.graphics.draw(boss_body, anims_boss["body"][0],boss_abs.x, boss_abs.y)
	
	if not boss.back.state then
		love.graphics.draw(boss_back, anims_boss["back"][0],boss_abs.x + 9, boss_abs.y -34)
	else
		love.graphics.draw(boss_back, anims_boss["back"][boss.back.frame],boss_abs.x + 9, boss_abs.y -34)
	end
	if not boss.head.state then
		love.graphics.draw(boss_head, anims_boss["head"][0],boss_abs.x -55, boss_abs.y-61)
	else
		love.graphics.draw(boss_head, anims_boss["head"][boss.head.frame],boss_abs.x - 55, boss_abs.y -61)
	end

	love.graphics.draw(boss_front_arm, anims_boss["front_arm"][0],boss_abs.x - 26, boss_abs.y + 14 )
end

function bos:keypressed( key )
	if ( key == 'l') then
		bos:rocket()
	end
end

function random_head_move()
   if headReady then
      bos:move_head()
      headReady = false
   end
   headClock = cron.after(math.random(2,5), function()
      random_head_move()
      headReady = true
   end)
end

function random_arm_move()
   if barmReady then
      bos:move_back_arm()
      barmReady = false
   end
   barmClock = cron.after(math.random(2,5), function()
      random_arm_move()
      barmReady = true
   end)
end


function random_rocket_launch()  ---why you no work???  OK I got it and fixed it... then why is it still here? who knows... :P
   if backReady then
      bos:rocket()
      backReady = false
   end
   backClock = cron.after(math.random(7,10), function()
      backReady = true
      random_rocket_launch()
   end)
end