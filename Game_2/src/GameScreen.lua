require("src/Screen")

GameScreen = Screen:extends()

function GameScreen:__init()
	-- Create the world
	world = love.physics.newWorld( 0, 9.8 * 64, false)
	
	-- Create a Bunny
	self.bunny = Bunny()

	-- Call super class to give this object a a name
	self.super:__init('GameScreen')

	--table to keep track of the carrots
	self.carrots = {}

end

function GameScreen:update(dt)
	-- update the bunny
	self.bunny:update(dt)

	SpawnCarrots(self.carrots, 400, 400)

	-- update the world
	world:update(dt)
end

function GameScreen:render()
	self.bunny:render()

	for i, v in ipairs (self.carrots) do
		v:render()
	end
end

function SpawnCarrots(tableToSpawmIn, posX, posY)
	table.insert(tableToSpawmIn, Carrot(posX, posY))
	tableToSpawmIn[#tableToSpawmIn].body:applyForce(-300 , 0)
end
