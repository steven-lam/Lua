class = require('extern/30log/30log')

Screen = class()

function Screen:__init(name)
	self.name = name
	self.highScore = 0
end

function Screen:update(dt) 
end

function Screen:render()
end