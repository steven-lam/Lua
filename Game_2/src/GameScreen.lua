require("src/Screen")

GameScreen = Screen:extends()

function GameScreen:__init()
	-- Create the world
	world = love.physics.newWorld( 0, 9.8 * 64, false)
	
	-- Create a Bunny
	self.bunny = Bunny()

	-- Call super class to give this object a a name
	self.super:__init('GameScreen')
end

function GameScreen:update(dt)
	-- update the bunny
	self.bunny:update(dt)

	-- update the world
	world:update(dt)
end

function GameScreen:render()
	self.bunny:render()
end