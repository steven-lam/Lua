

function Pattern(randomPattern, horzPattern) 
	-- space difference between two carrots
	local size = 50

	-- table size
	local tableSize = 4

	-- if current pattern is vertical or not
	local vertical = false

	-- value to keep track of starting y-axis value
	local y = 0

	-- matrix to keep track of carrot spawn values
	matrix = {}
	for i=0,tableSize do
		matrix[i] = {}
		for j=0,tableSize do
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
			y = math.random() * 400 + size * 2 
			matrix[0][2] = true
			matrix[1][1] = true
			matrix[2][0] = true
			matrix[3][1] = true
			matrix[4][2] = true
		end

		-- x x x x x

		if(randomPattern == 1) then
			y = math.random() * 500 + size
			for i=0,tableSize do
				matrix[i][0] = true 
			end
		end

		-- x x x x x
		-- x x x x x

		if(randomPattern == 2) then
			y = math.random() * 450 + size
			for i=0,1 do
				for j=0, tableSize do
					matrix[j][i] = true
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
			for i=0,tableSize do
				matrix[0][i] = true
			end
		end

		-- x x
		-- x x
		-- x x
		-- x x
		-- x x 

		if(randomPattern == 1) then
			y = math.random() * 250 + size
			for i=0,1 do
				for j=0,tableSize do
					matrix[i][j] = true
				end
			end
		end

		--			x
		--		x		x
		--	x				x
		--		x		x
		--			x

		if(randomPattern == 2) then
			y = math.random() * 200 + size
			matrix[2][0] = true
			matrix[1][1] = true
			matrix[3][1] = true
			matrix[0][2] = true
			matrix[4][2] = true
			matrix[1][3] = true
			matrix[3][3] = true
			matrix[2][4] = true
		end
	end

	return matrix, y, vertical
end
