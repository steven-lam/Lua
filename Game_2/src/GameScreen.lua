require("src/Screen")

GameScreen = Screen:extends()

function GameScreen:__init()
	-- Create the world
	world = love.physics.newWorld( 0, 9.8 * 64, false)

	-- background
	background = love.graphics.newImage("images/map.png")
	bg_1x = 0
	bg_2x = background:getWidth()
	bg_3x = background:getWidth() * 2
	bg_scrollSpeed = 5
	-- Create a Bunny
	self.bunny = Bunny()

	-- Call super class to give this object a a name
	self.super:__init('GameScreen')

	--table to keep track of the carrots
	self.carrots = {}

end

function GameScreen:update(dt)
	-- scroll background
	ScrollBackGround()
	-- update the bunny
	self.bunny:update(dt)

	-- update the world
	world:update(dt)
end

function GameScreen:render()
	-- draw background
	DrawBackground(bg_1x, bg_2x, bg_3x)

	-- draw bunny
	self.bunny:render()

	-- draw carrots
	for i, v in ipairs (self.carrots) do
		v:render()
	end
end

function SpawnCarrots(tableToSpawmIn, posX, posY)
	table.insert(tableToSpawmIn, Carrot(posX, posY))
	tableToSpawmIn[#tableToSpawmIn].body:applyForce(-300 , 0)
end

function DrawBackground(pos_1X, pos_2X, pos_3X)
	love.graphics.draw(background, pos_1X, 0)
	love.graphics.draw(background, pos_2X, 0)
	love.graphics.draw(background, pos_3X, 0)
end

function ScrollBackGround()
	local imageWidth = background:getWidth()

	-- scroll images
	bg_1x = bg_1x - bg_scrollSpeed
	bg_2x = bg_2x - bg_scrollSpeed
	bg_3x = bg_3x - bg_scrollSpeed

	-- update images when they go out of bound
	if (bg_1x <= -imageWidth) then
		bg_1x = bg_3x + imageWidth
	end

	if(bg_2x <= -imageWidth) then
		bg_2x = bg_1x + imageWidth
	end

	if(bg_3x <= -imageWidth) then
		bg_3x = bg_2x + imageWidth
	end

end
