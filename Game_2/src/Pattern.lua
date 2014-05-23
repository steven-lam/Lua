

function Pattern(randomPattern) 
	-- space difference between two carrots
	size = 50
	-- table to keep track of carrot spawn values
	y = {}	
	instaSpawn = false
	--			x
	--		x   	x
	--	x 				x
	
	if(randomPattern == 0) then
		y[0] = math.random() * 450 + size * 2
		y[1] = y[0]  - size
		y[2] = y[0]  - size * 2
		y[3] = y[0]  - size
		y[4] = y[0] 
	end

	-- x x x x x

	if(randomPattern == 1) then
		y[0] = math.random() * 500 + size
		y[1] = y[0]
		y[2] = y[0]
		y[3] = y[0]
		y[4] = y[0]
	end

	--x
	--x
	--x
	--x
	--x

	if(randomPattern == 2) then
		y[0]= math.random() * 250 + size
		y[1] = y[0] + size
		y[2] = y[1] + size
		y[3] = y[2] + size
		y[4] = y[3] + size
		instaSpawn = true
	end

	return y, instaSpawn
end
