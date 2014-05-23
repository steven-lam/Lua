class = require "extern/30log/30log"

GameObject = class()

function GameObject:__init()
	self.x = 0
	self.y = 0
	self.w = 0
	self.h = 0
end

function GameObject:update(dt) 
end

function GameObject:render()
end

function GameObject:getX()
	return self.body:getX()
end

function GameObject:getY()
	return self.body:getY()
end

function GameObject:getWidth()
	return self.w
end

function GameObject:getHeight()
	return self.h
end

