require('src/GameObject')

Trap = GameObject : extends()

function Trap:__init(x, y)
	-- Call traps super class constructor
	Trap.super:__init()

	self.image = love.graphics.newImage('images/trap.jpg')

	-- trap attribute
	self.x = x
	self.y= y
	self.w = self.image:getWidth()
	self.h = self.image:getHeight()

	-- trap's body in the world
	self.body = love.physics.newBody(world, self.x, self.y, "dynamic")
	self.shape = love.physics.newRectangleShape(self.w, self.h)
	self.fixture = love.physics.newFixture(self.body, self.shape, 1)
	self.fixture:setUserData(self)

	--setting category for other objects to ignore collision
	self.fixture:setCategory(4)
	self.fixture:setMask(2,3,4)
end

function Trap:update(dt)
	-- set traps x speed to constant and y speed to 0
	self.body:setLinearVelocity(-300, 0)
	-- strange value to keep the trap steady long enough before they exit the left screen
	self.body:applyLinearImpulse(0,-29)

	-- delete trap that are off the screen
	if(self.body:getX() < 0) then
		self.toKill = true
	end

	if(self.body:getY() > love.window.getHeight() or self.body:getY() < 0) then
		self.toKill = true
	end 
end

function Trap:render()
	love.graphics.draw(self.image,self.body:getX(), self.body:getY())
end