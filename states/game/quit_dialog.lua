local dialogWidth  = 300
local dialogHeight = 100 

function drawQuitDialog()
	love.graphics.setColor(0,0,0,100)
	love.graphics.rectangle("fill",0,0,love.graphics.getWidth(),love.graphics.getHeight())
	love.graphics.setColor(0,0,0)
	love.graphics.rectangle("fill",love.graphics.getWidth()/2 - dialogWidth / 2, love.graphics.getHeight()/2 - dialogHeight/2, dialogWidth, dialogHeight)
end

function updateQuitDialog( dt )
	
end