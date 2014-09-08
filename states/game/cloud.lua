cloud = { }

cloudRemoved = false

cloudImage = love.graphics.newImage("textures/cloud.gif")

function newCloud(x,y,sx,sy,X_Vel)
   local id = #cloud+1
 --------------------------GENELLESTIRILECEK...
   cloud[id] = {
         x = x,
         y = y,
         sx = sx,
         sy = sy,
         X_Vel = X_Vel,
         removed = false
   }

        return id
end

function updateClouds(dt)
   if cloudRemoved then
      cloudRemoved = false
      for i = #cloud, 1, -1 do
         if (cloud[i].removed == true) then
            table.remove(cloud, i)
         end
      end
   end
   
   for i,v in ipairs(cloud) do
      if (v.removed == false) then
         v.x = v.x + cloud[i].X_Vel * dt
      end
      if (cloud[i].x > map.width * map.tileWidth) then
         removeCloud(i)
      end
   end
end

function drawClouds()
   for i,v in ipairs(cloud) do
      love.graphics.setColor(0,0,0,30)
      vertices = {
         v.x,
         v.y + 32*v.sy,
         
         v.x + 194*v.sx,
         v.y +  32*v.sy,
         
         v.x + 194*v.sx - 160,
         v.y +  32*v.sy + 300,
         
         v.x - 160,
         v.y + 300 + 32*v.sy
         }

      love.graphics.polygon("fill", vertices)
      love.graphics.setColor(255,255,255)
      love.graphics.draw(cloudImage, v.x, v.y, 0, v.sx, v.sy)
   end
end

function removeCloud(i)
   cloud[i].removed = true
   cloudRemoved = true
end
