require('src/GameObject')

Bunny = GameObject:extends()

function Bunny:__init()

	--Bunny's image
	self.image = love.graphics.newImage("images/bunny_still.png")

	-- call super class's constructor
	Bunny.super: __init()

	-- redefine properties
	self.x = love.window.getWidth() / 4
	self.y = love.window.getHeight() / 2
	self.w = self.image:getWidth()
	self.h = self.image:getHeight()
	self.bounce = -250
	self.jumpSpeed = -400
	self.score = 0

	-- Bunny's body in the world
	self.body = love.physics.newBody( world, self.x, self.y, "dynamic")
	self.shape = love.physics.newRectangleShape(self.w, self.h)
	self.fixture = love.physics.newFixture(self.body, self.shape, 1)
	self.fixture:setUserData(self)

end

function Bunny:update( dt )
	
	-- store current speed
	local x, y = self.body:getLinearVelocity()

	-- update speed
	if (love.keyboard.isDown(' ')) then
		self.body:setLinearVelocity(0 , self.jumpSpeed)
	else
		-- makes sure that the bunny never moves in the x direction
		self.body:setLinearVelocity(0, y + 10)
		self.body:setX(self.x)
	end

	-- window bound
	if (self.body:getY() > love.window.getHeight() - self:getHeight()) then
		self.body:setY(love.window.getHeight() - self:getHeight())
		self.body:setLinearVelocity(x , self.bounce)
	end

	if(self.body:getY() < 0) then
		self.body:setY(0)
	end

	-- in case rabbit ever moves out of window
	if(self.body:getX() < 0) then
		self.body:setX(0)
	end

	if(self.body:getX() > love.window.getWidth()) then
		self.body:setX(love.window.getWidth())
	end

end

function Bunny:render()
	love.graphics.draw(self.image, self.body:getX(), self.body:getY())
end