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
	self.jumpSpeed = 20

	-- Bunny's body in our world
	self.body = love.physics.newBody( world, self.x, self.y, "static")
	self.shape = love.physics.newRectangleShape(self.w, self.h)
	self.fixture = love.physics.newFixture(self.body, self.shape, 1)
	self.fixture:setUserData(self)

end

function Bunny:update( dt )
	
	-- store current speed
	local x, y = self.body:getLinearVelocity()

	-- update speed
	if love.keyboard.isDown('space') then
		self.body:setLinearVelocity( x , self.jumpSpeed)
	end

end

function Bunny:render()
	love.graphics.draw(self.image, self.body:getX(), self.body:getY())
end