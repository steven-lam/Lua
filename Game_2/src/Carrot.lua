require('src/GameObject')

Carrot = GameObject:extends()

function Carrot:__init(x , y)

	-- carrot's image
	self.image = love.graphics.newImage("images/carrot_oj.png")

	-- call super class' constructor
	Carrot.super: __init()

	-- attributes
	self.x = x
	self.y = y
	self.w = self.image:getWidth()
	self.h = self.image:getHeight()

	-- Carrots body in the world	
	self.body = love.physics.newBody( world, self.x, self.y, "dynamic")
	self.shape = love.physics.newRectangleShape(self.w, self.h)
	self.fixture = love.physics.newFixture(self.body, self.shape, 1)
	self.fixture:setUserData(self)

	--setting category for other objects to ignore collision
	self.fixture:setCategory(2)
	self.fixture:setMask(2,3,4)

end

function Carrot:update(dt)

	-- always set y velocity to 0 so carrot doesnt fall
	self.body:setLinearVelocity(-300,0)
	-- strange value i found to keep the carrot steady long enough before they exit the left screen
	self.body:applyLinearImpulse(0,-29)
	-- delete carrots that are off the screen
	if(self.body:getX() < 0) then
		self.toKill = true
	end

	if(self.body:getY() > love.window.getHeight() or self.body:getY() < 0) then
		self.toKill = true
	end 

end

function Carrot:render()
	love.graphics.draw(self.image, self.body:getX(), self.body:getY())
end