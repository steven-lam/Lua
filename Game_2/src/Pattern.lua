

function Pattern(randomPattern, horzPattern) 
	-- space difference between two carrots
	local size = 50

	-- table size
	local tableSize = 5

	-- if current pattern is vertical or not
	local vertical = false

	-- value to keep track of starting y-axis value
	local y = 0

	-- matrix to keep track of carrot spawn values
	matrix = {}
	for i=1,tableSize do
		mt[i] = {}
		for j=1,tableSize do
			matrix[i][j] = false
		end
	end
	---------------------------------------------
	-- if pattern requested is horizontal
	if(horzPattern) then
		--			x
		--		x   	x
		--	x 				x
		
		if(randomPattern == 0) then
			y = math.random() * 450 + size * 2 
			matrix[1][3] = true
			matrix[2][2] = true
			matrix[3][1] = true
			matrix[4][2] = true
			matrix[5][3] = true
		end

		-- x x x x x

		if(randomPattern == 1) then
			y = math.random() * 500 + size
			for i=1,tableSize do
				matrix[0][i] = true 
			end
		end

		-- x x x x x
		-- x x x x x

		if(randomPattern = 2) then
			y = math.random() * 500 + size
			for i=1,2 do
				for j=1, tableSize do
					matrix[i][j] = true
				end
			end
		end
	else
		vertical = true
		-- x
		-- x
		-- x
		-- x
		-- x

		if(randomPattern == 0) then
			y = math.random() * 250 + size
			for i=1,tableSize do
				matrix[i][0] = true
			end
		end

		-- x x
		-- x x
		-- x x
		-- x x
		-- x x 

		if(randomPattern == 1) then
			y = math.random() * 250 + size
			for i=1,2 do
				for j=1,tableSize do
					matrix[j][i] = true
				end
			end
		end

		if(randomPattern == 2) then
			y = math.random() * 250 + size
			matrix[3][1] = true
			matrix[2][2] = true
			matrux[4][2] = true
			matrix[1][3] = true
			matrix[5][3] = true
			matrix[2][4] = true
			matrix[4][4] = true
			matrix[3][5] = true
		end
	end

	return matrix, y, vertical
end
