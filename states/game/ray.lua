ray = { }

rayRemoved = false

local rayCastClock
local rayReady = true

local consolationClock
local consolationReady = true

function newRay(x, x1, x2)
   local id = #ray+1

   ray[id] = {
         x1 = x1,
         x2 = x2,
         x = x,
         y = 0,
         sx = 1,
         sy = 1,
         life = 0,
         max_life = math.random(2,3),
         alpha = 255,
         fade = false,
         removed = false
   }

        return id
end

function updateRays(dt)

   if rayCastClock then rayCastClock:update(dt) end

   if consolationClock then consolationClock:update(dt) end

   if rayRemoved then
      rayRemoved = false
      for i = #ray, 1, -1 do
         if (ray[i].removed == true) then
            table.remove(ray, i)
         end
      end
   end
  
   for i,v in ipairs(ray) do
      v.life = v.life + dt
      v.alpha = 64*math.sin(math.pi*v.life/v.max_life)
      v.alpha = math.floor(v.alpha)
      if v.alpha < 2 then v.alpha = 0 end
      if v.life > v.max_life then
         removeRay(i)
      end
   end
end

function drawRays()
   for i,v in ipairs(ray) do
      love.graphics.setColor(255,255,255,v.alpha)
      vertices = {
         v.x + v.x2,
         v.y,
         
         v.x + v.x1 + v.x2,
         v.y,
         
         v.x + v.x1 - 112 + v.x2,
         v.y + 480,
         
         v.x - 112 + v.x2,
         v.y + 480 
         }

      love.graphics.polygon("fill", vertices)
   end
end

function removeRay(i)
   ray[i].removed = true
   rayRemoved = true
end


function loadRayConsolation(loc_x)
   if rayReady then
      newRay(loc_x, 164,0)
      rayReady = false
   end
   rayCastClock = cron.after(0.5, function()
      rayReady = true 
      if rayReady then
         newRay(loc_x, math.random(80,100),46)
         rayReady = false
         rayCastClock = cron.after(0.8, function()
            rayReady = true
            newRay(loc_x,math.random(10,16), math.random(200,210))
            rayReady = false
            rayCastClock = cron.after(0.2, function()
               rayReady = true
               newRay(loc_x,math.random(44,56), math.random(57,63))
               rayReady = false
               rayCastClock = cron.after(0.2, function()
               rayReady = true
               end)
            end)
         end)
      end
   end)

end

random_int = {4,8,13}

function random_rays()
   if consolationReady then
      loadRayConsolation(camera.x + math.random(80,550))
      consolationReady = false
   end
   consolationClock = cron.after(random_int[math.random(1,3)], function()
      random_rays()
      consolationReady = true
   end)
end