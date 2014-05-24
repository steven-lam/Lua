require('src/Pattern')

CarrotPattern = Pattern:extends()

function CarrotPattern:__init()
	CarrotPattern.super:__init('Carrot Pattern')
	self.size = 50
	self.tableSize = 4
	self.y = 0
	self.matrix = {}

	self.numOfPattern = 4
	self.randomSpawn = math.floor(math.random() * self.numOfPattern)
end

function CarrotPattern:generate(horzPattern)
	-- random a new pattern every time
	self.randomSpawn = math.floor(math.random() * self.numOfPattern)
	
	-- if current pattern is vertical or not
	local vertical = false

	-- self.matrix to keep track of carrot spawn values
	for i=0,self.tableSize do
		self.matrix[i] = {}
		for j=0,self.tableSize do
			self.matrix[i][j] = false
		end
	end
	---------------------------------------------
	-- if pattern requested is horizontal
	if(horzPattern) then
		--			x
		--		x   	x
		--	x 				x
		
		if(self.randomSpawn == 0) then
			self.y = math.random() * 300 + self.size * 2 
			self.matrix[0][2] = true
			self.matrix[1][1] = true
			self.matrix[2][0] = true
			self.matrix[3][1] = true
			self.matrix[4][2] = true
		end

		-- x x x x x

		if(self.randomSpawn == 1) then
			self.y = math.random() * 500 + self.size
			for i=0,self.tableSize do
				self.matrix[i][0] = true 
			end
		end

		-- x x x x x
		-- x x x x x

		if(self.randomSpawn == 2) then
			self.y= math.random() * 450 + self.size
			for i=0,1 do
				for j=0, self.tableSize do
					self.matrix[j][i] = true
				end
			end
		end

		--	x				x
		--		x		x
		--			x

		if(self.randomSpawn == 3) then
			self.y = math.random() * 300 + self.size * 2 
			self.matrix[0][0] = true
			self.matrix[1][1] = true
			self.matrix[2][2] = true
			self.matrix[3][1] = true
			self.matrix[4][0] = true
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

		-- x x
		-- x x
		-- x x
		-- x x
		-- x x 

		if(self.randomSpawn == 1) then
			self.y = math.random() * 250 + self.size
			for i=0,1 do
				for j=0,self.tableSize do
					self.matrix[i][j] = true
				end
			end
		end

		--			x
		--		x		x
		--	x				x
		--		x		x
		--			x

		if(self.randomSpawn == 2) then
			self.y = math.random() * 200 + self.size
			self.matrix[2][0] = true
			self.matrix[1][1] = true
			self.matrix[3][1] = true
			self.matrix[0][2] = true
			self.matrix[4][2] = true
			self.matrix[1][3] = true
			self.matrix[3][3] = true
			self.matrix[2][4] = true
		end

		--			x
		--	x	x	x	x	x
		--		x	x	x	
		--	x				x

		if(self.randomSpawn == 3) then
			self.y = math.random() * 250 + self.size
			self.matrix[2][0] = true
			for i=0,4 do
				self.matrix[i][1] = true
			end
			for j=1,3 do
				self.matrix[j][2] = true
			end
			self.matrix[0][3] = true
			self.matrix[4][3] = true
		end
	end

	return self.matrix, self.y, vertical
end

