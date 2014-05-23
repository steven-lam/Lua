require("src/Screen")

GameScreen = Screen:extends()

function GameScreen:__init()
	-- Create the world
	world = love.physics.newWorld( 0, 0, false)
	
	-- Create a Bunny
	self.bunny = Bunny()

	-- Call super class to give this object a a name
	self.super:__init('GameScreen')
end

function GameScreen:update(dt)
	
	self.bunny:update(dt)

	world:update(dt)
end

function GameScreen:render()
	self.bunny:render()
end