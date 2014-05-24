class = require('extern/30log/30log')

Pattern = class()

function Pattern:__init(name)
	-- Pattern's name
	self.name = name

	-- space difference between two carrots
	self.size = 0

	-- table size
	self.tableSize = 0

	-- value to keep track of starting y-axis value
	self.y = 0

	-- matrix to keep track of carrot spawn values
	self.matrix = {}

	-- number of pattern sets
	self.numOfPattern = 0

	-- random spawn number
	self.randomSpawn = 0
end

function Pattern:generate(randomPattern, horzPattern)
end
