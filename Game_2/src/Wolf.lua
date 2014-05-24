require('src/GameObject')

Wolf = GameObject:extends()

function Wolf:__init(x , y) 
	-- call super class constructor
	Wolf.super:__init()

	self.image = love.graphics.newImage('images/wolf.gif')

	-- wolf attributes
	self.x = x 
	self.y = y
	self.w = self.image:getWidth()
	self.h = self.image:getHeight()


	-- wolf body in the world	
	self.body = love.physics.newBody( world, self.x, self.y, "dynamic")
	self.shape = love.physics.newRectangleShape(self.w, self.h)
	self.fixture = love.physics.newFixture(self.body, self.shape, 1)
	self.fixture:setUserData(self)

	--setting category for other objects to ignore collision
	self.fixture:setCategory(3)
	self.fixture:setMask(2)
end

function Wolf:update(dt)
	-- set wolves speed to be constant
	self.body:setLinearVelocity(-1000, 0)

	-- delete wolves that are off the screen
	if(self.body:getX() < 0) then
		self.toKill = true
	end

	if(self.body:getY() > love.window.getHeight() or self.body:getY() < 0) then
		self.toKill = true
	end 
end

function Wolf:render()
	love.graphics.draw(self.image, self.body:getX(), self.body:getY())
end