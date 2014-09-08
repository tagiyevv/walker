drop = { }

dropRemoved = false



function newDrop( )
   drop_id = math.random(1,3)
   dropImage =love.graphics.newImage("textures/rain/"..drop_id..".png")
   local id = #drop+1
   drop[id] = {
         x = math.random(camera.x, camera.x+640),
         y = math.random(camera.y, camera.y+480),
         life = 0,
         removed = false
   }

        return id
end

function updateDrops(dt)
   if dropRemoved then
      dropRemoved = false
      for i = #drop, 1, -1 do
         if (drop[i].removed == true) then
            table.remove(drop, i)
         end
      end
   end

   for i,v in ipairs(drop) do
   		v.life = v.life + dt
   		if v.life > 0.05 then
   			removeDrop(i)
   		end
   end
end

function drawDrops()
   for i,v in ipairs(drop) do
   		love.graphics.draw(dropImage, v.x, v.y, 0, 1, 1)
         love.graphics.draw(dropImage, v.x+math.random(-200,200), v.y+math.random(-200,200), 0, 1, 1)
   end
end

function removeDrop(i)
   drop[i].removed = true
   dropRemoved = true
end

