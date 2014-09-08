function load()
  loaded = 0
  files = { '*' }
end

function love.update( dt )

  if #files then
    file = table.remove( files )
    loadFile( file )
    loaded = loaded + 1
    return
  end
  loadstate("menu")
end

function love.draw(  )
  love.graphics.print( 200, 20, "Loading" )
  love.graphics.rectangle( "fill", 50, 50, 25*i, 50 )
end