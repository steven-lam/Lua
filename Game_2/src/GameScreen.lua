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

	--table to keep track of the carrots
	self.carrots = {}

	test = false
	self.timeTicks = 0
	self.numOfPattern = 4
	self.randomSpawn = math.floor(math.random() * self.numOfPattern)
	--self.randomSpawn = 3
	self.horzSpawn = true
	self.carrotSpawn = {}
	self.carrotSpawn.matrix, self.carrotSpawn.y, self.carrotSpawn.vert = Pattern(self.randomSpawn, self.horzSpawn)
end

function GameScreen:update(dt)
	-- scroll background
	ScrollBackGround()

	-- update the bunny
	self.bunny:update(dt)
	if(love.keyboard.isDown('b')) then
		if(test) then
			test = false
		else
			test = true
		end
	end

	if (test) then
		-- spawn some carrots
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
		self.timeTicks = 0
		self.randomSpawn = math.floor(math.random() * self.numOfPattern)
		self.carrotSpawn.matrix, self.carrotSpawn.y, self.carrotSpawn.vert = Pattern(self.randomSpawn, self.horzSpawn)
		end
	end
	-- update carrots
	CarrotUpdate(self.carrots)

	-- remove carrots that were eaten
	for i,v in ipairs( self.carrots ) do
		if v.toKill == true then
			v:kill()
			table.remove(self.carrots, i)
		end
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

	-- draw the score
	love.graphics.print(self.bunny.score, 400, 15)

	-- check to see if spawning
	if(test) then
		love.graphics.print('spawning', 300, 15)
	end
end

function SpawnCarrots(tableToSpawmIn, matrix, x, y, startLoc)
	if(matrix[x][y]) then
		table.insert(tableToSpawmIn, Carrot(x*50+800, y * 50 + startLoc))
	end
end

function CarrotUpdate(carrots)
	for i,v in ipairs (carrots) do
		v:update(dt)
	end 
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

-- world callbacks
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
	end
end

function endContact( a, b, coll )

end

function preSolve( a, b, coll )

end

function postSolve( a, b, coll )
  
end