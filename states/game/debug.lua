function debug:update( dt )
end
debugFont = love.graphics.newFont(12)

function debug:draw()
	love.graphics.setFont(debugFont)
	love.graphics.setColor(255,255,255,255)
	dy = 16
	love.graphics.print("--DEBUG--", 16, 0, 0, 1, 1)
	love.graphics.print("memory usage: "..string.format("%.2f",collectgarbage('count')).." kB",16,dy,0,1,1)
	love.graphics.print("jump.frame: ".. jump.frame,16,dy*2,0,1,1)
	love.graphics.print("player shoot state: ".. tostring(shoot.state),16,dy*3,0,1,1)
	love.graphics.print("camera time: "..string.format("%.2f", camera.time),16,dy*4,0,1,1)
	love.graphics.print("en. shoot frame: "..shoot_en.frame,16,dy*5,0,1,1)
	love.graphics.print("map width: "..(map.width * map.tileWidth), 16, dy*6, 0, 1, 1)
	love.graphics.print("bullets: "..#bullet,16,dy*7,0,1,1)
	love.graphics.print("camera pos x: ".. camera.x, 16, dy*8, 0,1,1)
	love.graphics.print("posx distr ".. dist, 16, dy*9, 0,1,1)
	love.graphics.print("shoot frame: ".. shoot.frame, 16, dy*10, 0,1,1)
	love.graphics.print("player #: ".. #player,16,dy*11,0,1,1)
	love.graphics.print("enemy #: ".. #enemy,16,dy*12,0,1,1)
	love.graphics.print("camera.x:  ".. camera.x,16,dy*13,0,1,1)
	--love.graphics.print("flash".. tostring(flash),16,dy*13,0,1,1)
	--love.graphics.print("delx ".. tt,16,dy*14,0,1,1)

end