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

end

function Carrot:update(dt)
	
	-- store current speed
	local x , y = self.body:getLinearVelocity()

	-- always set y velocity to 0 so carrot doesnt fall
	self.body:setLinearVelocity(x , 0)


end

function Carrot:render()
	love.graphics.draw(self.image, self.body:getX(), self.body:getY())
end