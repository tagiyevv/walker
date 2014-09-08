require("TEsound")
sfx_select = "sounds/select.wav"
sfx_error  = "sounds/error.wav"
return {
	new = function()
		return {
			items = {},
			selected = 1,
			animOffset = 0,
			addItem = function(self, item)
				table.insert(self.items, item)
			end,
			update = function(self, dt)
				self.animOffset = self.animOffset / (1 + dt*50)
			end,
			draw = function(self, x, y)
				local height = 30
				local width = 250
				
				love.graphics.setColor(255, 255, 255)
				love.graphics.rectangle('fill', x, y + height*(self.selected-1) + (self.animOffset * height), width, height)
				
				for i, item in ipairs(self.items) do
					if self.selected == i then
						love.graphics.setColor(0, 0, 0)
					else
						love.graphics.setColor(255,255,255)
					end
					love.graphics.setNewFont("fonts/guru.ttf",22)
					love.graphics.print(item.name, x + 5, y + height*(i-1) + 5)
				end
			end,
			keypressed = function(self, key)
				if key == 'up' then
					TEsound.play(sfx_select)
					if self.selected > 1 then
						self.selected = self.selected - 1
						self.animOffset = self.animOffset + 1
					else
						self.selected = #self.items
						self.animOffset = self.animOffset - (#self.items-1)
					end
				elseif key == 'down' then
					TEsound.play(sfx_select)
					if self.selected < #self.items then
						self.selected = self.selected + 1
						self.animOffset = self.animOffset - 1
					else
						self.selected = 1
						self.animOffset = self.animOffset + (#self.items-1)
					end
				elseif key == 'return' then
					if self.items[self.selected].action then
						self.items[self.selected]:action()
					end
				else 
					TEsound.play(sfx_error)
				end
			end
		}
	end
}
