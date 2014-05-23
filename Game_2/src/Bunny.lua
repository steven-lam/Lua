require("src/GameObject")

Bunny = GameObject:extends()

function Bunny:__init()

	--Bunny's image
	self.image = love.graphics.newImage("images/bunny_still.png")

	-- call super class's constructor
	Bunny.super: __init()
	-- redefine properties
	self.x = 25
	self.y = 300
	self.w = self.image:getWidth()
	self.h = self.image:getHeight()
	self.jumpSpeed = -250

	-- Bunny's body in our world
	self.body = love.physics.newBody( world, self.x, self.y, "dynamic")
	self.shape = love.physics.newRectangleShape(self.w, self.h)
	self.fixture = love.physics.newFixture(self.body, self.shape, 1)
	self.fixture:setUserData(self)

end

function Bunny:update( dt )
	
	-- store current speed
	local x, y = self.body:getLinearVelocity()

	-- update speed
	if love.keyboard.isDown(' ') then
		self.body:setLinearVelocity(x , self.jumpSpeed)
	end

	-- window bound
	if (self.body:getY() > love.window.getHeight() - self:getHeight()) then
		self.body:setY(love.window.getHeight() - self:getHeight())
		self.body:setLinearVelocity(x , self.jumpSpeed)
	end

	if(self.body:getY() < 0) then
		self.body:setY(0)
	end

end

function Bunny:render()
	love.graphics.draw(self.image, self.body:getX(), self.body:getY())
end