require("src/GameObject.lua")

Bunny = GameObject:extends()

function Bunny:__init(x , y)

	--Bunny's image
	self.image = love.graphics.newImagE("images/bunny_still.png")

	-- call super class's constructor
	Bunny.super: __init()
	-- redefine properties
	self.x = 25
	self.y = 300
	self.w = self.image:getWidth()
	self.h = self.image:getHeight()
	self.jumpSpeed = 20

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
	love.graphics.draw(self.image, self.getX(), self.getY())
end