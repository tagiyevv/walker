love.filesystem.load("states/game/player.lua")

hudFont = love.graphics.newFont("fonts/manaspc.ttf",11)
trans  	= love.graphics.newImage("textures/trans.png")

hudX = 0
hudY = 0
hudWidth  = 640
hudHeight = 60


health_bar = love.graphics.newImage("textures/health_bar.png")
health_quads = {}

for i = 0,96 do
	health_quads[i] = love.graphics.newQuad(i*2, 0, 2, 12, 188, 12)
end

function updateHud( dt )

end  

function drawHud( )
	love.graphics.draw(trans,0,0)

	love.graphics.setColor(0,0,0,255)
	love.graphics.rectangle("line",hudX + 439, hudY + 19, 190,14)
	love.graphics.setColor(0,0,0,200)
	love.graphics.line(hudX + 439 + 190,      hudY + 19 + 2,
					   hudX + 439 + 190 + 2 , hudY + 19 + 2,	
					   hudX + 439 + 190 + 2 , hudY + 19 + 2 + 14,
					   hudX + 439 + 2 ,       hudY + 19 + 2 + 14,
					   hudX + 439 + 2 ,       hudY + 19 + 14)
	love.graphics.setColor(0,0,0)
	for i,v in ipairs(player) do		
		love.graphics.setColor(255,255,255)
		for j = 0,math.floor(93*player[i].health/100) do
			love.graphics.draw(health_bar, health_quads[j], hudX + 440 + 2*j,hudY + 20)
		end

		love.graphics.setColor(0,0,0,150)
		love.graphics.print(player[i].health.."/100", hudX + 440 + 96 + 2, hudY + 28 + 2)
		love.graphics.setColor(255,255,255)
		love.graphics.print(player[i].health.."/100", hudX + 440 + 96, hudY + 28)
	end


	love.graphics.setFont(hudFont)
	love.graphics.setColor(0,0,0,150)
	love.graphics.print("HEALTH", hudX + 440 + 8 + 2, hudY + 28 + 2)
	love.graphics.setColor(255,255,255)
	love.graphics.print("HEALTH", hudX + 440 + 8, hudY + 28)

	love.graphics.print("pl: ", hudX + 10  + 16, hudY + 8 + 16)

	love.graphics.setColor(0,0,0,200)
	for i = 1,3 do
		love.graphics.rectangle("line",hudX + 10 + i*18 + 3, hudY + 8 + 3, 11, 11)
	end
	love.graphics.setColor(255,255,255)
	for i = 1,playerHeart do
		love.graphics.rectangle("fill",hudX + 10 + i*18, hudY + 8, 11, 11)
	end
	for i = 1,3 do
		love.graphics.rectangle("line",hudX + 10 + i*18, hudY + 8, 11, 11)
	end


end