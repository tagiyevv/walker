menu_item = {}
menu_item[1] = {
	x = love.graphics.getWidth()/2,
	y = love.graphics.getHeight()/2,
	}
menu_item[2] = {
	x = love.graphics.getWidth()/2 + 360,
	y = love.graphics.getHeight()/2,
	}
menu_item[3] = {
	x = love.graphics.getWidth()/2 + 360 * 2,
	y = love.graphics.getHeight()/2,
	}

item_count = #menu_item

pausem = {}

turn_menu_right = false
turn_menu_left  = false

function drawPauseMenu()
	love.graphics.setColor(0,0,0)
	love.graphics.rectangle("fill",0,0,love.graphics.getWidth(),love.graphics.getHeight())
	love.graphics.setColor(255,255,255)
	love.graphics.rectangle("fill",280, 20, 5, 210)

	love.graphics.setNewFont("fonts/guru.ttf",36)
	love.graphics.print("PAUSE\nMENU", 40, 70)
	love.graphics.print("PAUSED>",menu_item[1].x, menu_item[1].y)

	love.graphics.setNewFont("fonts/guru.ttf",36)
	love.graphics.print("<",menu_item[2].x - 24, menu_item[2].y)
	love.graphics.print("CONTROLS>", menu_item[2].x, menu_item[2].y)
	love.graphics.setNewFont("fonts/guru.ttf",24)
	love.graphics.print("move : arrows", menu_item[2].x, menu_item[2].y + 16 +   24)
	love.graphics.print("shoot: space",  menu_item[2].x, menu_item[2].y + 16 + 2*24)
	love.graphics.print("pause: P",      menu_item[2].x, menu_item[2].y + 16 + 3*24)
	love.graphics.print("quit : ESC",      menu_item[2].x, menu_item[2].y + 16 + 4*24)

	love.graphics.setNewFont("fonts/guru.ttf",36)
	love.graphics.print("<",menu_item[3].x - 24, menu_item[3].y)
	love.graphics.print("ABOUT", menu_item[3].x, menu_item[3].y)
	love.graphics.setNewFont("fonts/guru.ttf",24)
	love.graphics.print("bla bla", menu_item[3].x, menu_item[3].y + 16 + 24)
	love.graphics.setColor(0,0,0,200)
	love.graphics.rectangle("fill",0,240,280,240)
end

dist = 0

function updatePauseMenu( dt )
	dt_local = 0.05

	if turn_menu_right then
		turn_menu_left = false
		for i,v in ipairs(menu_item) do v.x = v.x - 800 * dt_local end
		dist = dist + 800 * dt_local
		if dist > 320 then
			turn_menu_right = false
			dist = 0
		end
	elseif turn_menu_left then
		turn_menu_right = false
		for i,v in ipairs(menu_item) do v.x = v.x + 800 * dt_local end
		dist = dist + 800 * dt_local
		if dist > 320 then
			turn_menu_left = false
			dist = 0
		end
	end
end

n = 1

function pausem:keypressed( key )
	if (key == "right") and (n < item_count) and (dist <1 ) then
		turn_menu_right = true
		n = n + 1 
	elseif (key == "left") and (n > 1) and (dist < 1) then
		turn_menu_left = true
		n = n - 1 
	end
end
