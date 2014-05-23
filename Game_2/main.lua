world = nil

require('src/Bunny')
require('src/Screen')
require('src/Carrot')
require('src/GameScreen')

function love.load() 

	love.window.setTitle("Hungry Bunny")
	love.graphics.setBackgroundColor(255,255,255)
	ActiveScreen = GameScreen()

end

function love.update(dt)
	ActiveScreen:update(dt)
end

function love.draw()
	ActiveScreen:render()
end
