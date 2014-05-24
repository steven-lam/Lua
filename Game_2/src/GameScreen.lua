require("src/Screen")
require("src/Pattern")

GameScreen = Screen:extends()

dummy = false

function GameScreen:__init()
	local gravity = 9.8 * 64

	-- Create the world
	world = love.physics.newWorld( 0, gravity, false)
	world:setCallbacks(beginContact, endContact, preSolve, postSolve)

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

	--table to keep track of objects
	self.carrots = {}
	self.wolves = {}

	-- Carrot Spawn attributes
	self.timeTicks = 0
	self.numOfPattern = 4
	self.randomSpawn = math.floor(math.random() * self.numOfPattern)
	self.horzSpawn = true
	self.carrotSpawn = {}
	self.carrotSpawn.matrix, self.carrotSpawn.y, self.carrotSpawn.vert = Pattern(self.randomSpawn, self.horzSpawn)


	-- Wolf spawm attributes
	self.wolfSpawnTime = 7
	self.wolfImageHeight = love.graphics.newImage('images/wolf.gif') : getHeight()
	
end

function GameScreen:update(dt)

	-- scroll background
	ScrollBackGround()

	-- update the bunny
	self.bunny:update(dt)

	-- Spawn Object Logic
	self.timeTicks = self.timeTicks + 1
	if(self.timeTicks >= 100) then
		if(self.carrotSpawn.vert) then
			for i=0, 4 do
				for j=0, 4 do
					SpawnCarrots(self.carrots, self.carrotSpawn.matrix, i, j, self.carrotSpawn.y)
				end
			end
			self.horzSpawn = true
		else
			for i=0, 4 do
				for j=0, 4 do
					SpawnCarrots(self.carrots, self.carrotSpawn.matrix, i, j, self.carrotSpawn.y)
				end
			end
			if((math.random() * 2) % 2 > 1) then
				self.horzSpawn = false
			else
				self.horzSpawn = true
			end
		end

		-- random new sets of value for new pattern
		self.timeTicks = 0
		self.randomSpawn = math.floor(math.random() * self.numOfPattern)
		self.carrotSpawn.matrix, self.carrotSpawn.y, self.carrotSpawn.vert = Pattern(self.randomSpawn, self.horzSpawn)

		-- spawn wolf
		if(self.wolfSpawnTime == 0) then
			local wolf_x, wolf_y = 800, math.random() * (love.window.getHeight() - self.wolfImageHeight * 2) + self.wolfImageHeight  
					SpawnWolves(self.wolves, wolf_x, wolf_y)
			self.wolfSpawnTime = math.floor(math.random() * 7)
		else
			self.wolfSpawnTime = self.wolfSpawnTime - 1
		end
	end

	-- update carrots
	CarrotUpdate(self.carrots)

	-- update wolves
	WolvesUpdate(self.wolves)

	-- remove carrots that were eaten
	RemoveCarrots(self.carrots)

	-- remove wolfs that have eaten the bunny
	RemoveWolves(self.wolves)

	-- if bunny is dead then game is over 
	if (self.bunny.toKill) then
		ActiveScreen = EndScreen()
	end

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

	-- draw wolves
	for i, v in ipairs (self.wolves) do
		v:render()
	end

	-- draw the score
	love.graphics.print(self.bunny.score, 400, 15)

	-- check to see if spawning
	if(test) then
		love.graphics.print('spawning', 300, 15)
	end
end

-----------------------------------------------------------------------
--							Wolves
-----------------------------------------------------------------------
function SpawnWolves(tableToSpawmIn, x, y)
	table.insert(tableToSpawmIn, Wolf(x,y))
end

function WolvesUpdate(wolves)
	for i,v in ipairs (wolves) do
		v:update(dt)
	end
end

function RemoveWolves(wolves)
	for i,v in ipairs(wolves) do
		if (v.toKill == true) then
			v:kill()
			table.remove(wolves,i)
		end
	end
end

-----------------------------------------------------------------------
--							Carrots
-----------------------------------------------------------------------
function SpawnCarrots(tableToSpawmIn, matrix, x, y, startLoc)
	if (matrix[x][y]) then
		table.insert(tableToSpawmIn, Carrot(x*50+800, y * 50 + startLoc))
	end
end

function CarrotUpdate(carrots)
	for i,v in ipairs (carrots) do
		v:update(dt)
	end 
end

function RemoveCarrots(carrots)
	for i,v in ipairs(carrots) do
		if (v.toKill == true) then
			v:kill()
			table.remove(carrots, i)
		end
	end
end

-----------------------------------------------------------------------
--							Background
-----------------------------------------------------------------------
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

-----------------------------------------------------------------------
--							World Callbacks
-----------------------------------------------------------------------
function beginContact( a, b, coll )
	local tempA = a:getUserData()
	local tempB = b:getUserData()

	if (tempA:is(Bunny) and tempB:is(Carrot)) then
		local x,y = tempA.body:getLinearVelocity()
		tempB.toKill = true
		tempA.score = tempA.score + 1
		tempA.body:setLinearVelocity(0 , y)
	elseif (tempA:is(Carrot) and tempB:is(Bunny)) then
		local x,y = tempA.body:getLinearVelocity()
		tempA.toKill = true
		tempB.score = tempB.score + 1
		tempB.body:setLinearVelocity(0 , y)
	elseif (tempA:is(Bunny) and tempB:is(Wolf)) then
		local x,y = tempA.body:getLinearVelocity()
		tempA.toKill = true
		tempB.toKill = true
		tempA.body:setLinearVelocity(0, y)
	elseif(tempA:is(Wolf) and tempB:is(Bunny)) then
		local x,y = tempB.body:getLinearVelocity()
		tempA.toKill = true
		tempB.toKill = true
		tempB.body:setLinearVelocity(0, y)
	end
end

function endContact( a, b, coll )

end

function preSolve( a, b, coll )

end

function postSolve( a, b, coll )
  
end