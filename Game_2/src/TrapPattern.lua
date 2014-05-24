require('src/Pattern')

TrapPattern = Pattern:extends()

function TrapPattern:__init()
	TrapPattern.super:__init('Trap Pattern')
	self.size = 50
	self.tableSize = 4
	self.y = 0
	self.matrix = {}

	self.numOfPattern = 2
	self.randomSpawn = math.floor(math.random() * self.numOfPattern)
end

function TrapPattern:generate(horzPattern)

	-- make the matrix a multidimensional array and set them all false / also clears the matrix
	for i=0,self.tableSize do
		self.matrix[i] = {}
		for j=0,self.tableSize do
			self.matrix[i][j] = false
		end
	end

	-- random a new pattern every time
	self.randomSpawn = math.floor(math.random() * self.numOfPattern)

	local vertical = false
	
	print(self.randomSpawn)
	if(horzPattern) then
		-- x x x x x

		if(self.randomSpawn == 0) then
			self.y = math.random() * 500 + self.size
			for i=0,self.tableSize do
				self.matrix[i][0] = true 
			end
		end

		--	x
		--		x
		--			x

		if(self.randomSpawn == 1) then
			self.y = math.random() * 350 + self.size
			self.matrix[0][0] = true
			self.matrix[1][1] = true
			self.matrix[2][2] = true
		end

	else
		vertical = true

		-- x
		-- x
		-- x
		-- x
		-- x

		if(self.randomSpawn == 0) then
			self.y = math.random() * 250 + self.size
			for i=0,self.tableSize do
				self.matrix[0][i] = true
			end
		end

		--			x
		--		x
		--	x		

		if(self.randomSpawn == 1) then
			self.y = math.random() * 350 + self.size
			self.matrix[0][2] = true
			self.matrix[1][1] = true
			self.matrix[2][0] = true
		end
	end

	return self.matrix, self.y, vertical
end