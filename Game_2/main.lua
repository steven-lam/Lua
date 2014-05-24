world = nil

gui = require('extern/quickie')
require('src/Bunny')
require('src/Screen')
require('src/Carrot')
require('src/Wolf')
require('src/Trap')
require('src/TitleScreen')
require('src/GameScreen')
require('src/EndScreen')


function love.load() 

	love.window.setTitle("Hungry Bunny")
	love.graphics.setBackgroundColor(255,255,255)

	-- Quickie Setup --
    fonts = {
        [12] = love.graphics.newFont(12),
        [20] = love.graphics.newFont(20),
    }
    love.graphics.setFont(fonts[12])

    -- group defaults
    gui.group.default.size[1] = 150
    gui.group.default.size[2] = 25
    gui.group.default.spacing = 5

    -- End Quickie Setup --

	ActiveScreen = TitleScreen()

end

function love.update(dt)
	ActiveScreen:update(dt)
end

function love.draw()
	ActiveScreen:render()
	gui.core.draw()
end
