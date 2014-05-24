class = require('extern/30log/30log')

Pattern = class()

function Pattern:__init(name)
	-- Pattern's name
	self.name = name

	-- space difference between two carrots
	self.size = 0

	-- table size
	self.tableSize = 4

	-- value to keep track of starting y-axis value
	self.y = 0

	-- matrix to keep track of carrot spawn values
	self.matrix = {}

	-- number of pattern sets
	self.numOfPattern = 0

	-- random spawn number
	self.randomSpawn = 0

	-- make the matrix a multidimensional array and set them all false / also clears the matrix
	for i=0,self.tableSize do
		self.matrix[i] = {}
		for j=0,self.tableSize do
			self.matrix[i][j] = false
		end
	end
end

function Pattern:generate(randomPattern, horzPattern)
end
