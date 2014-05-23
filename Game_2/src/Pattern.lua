

function Pattern(randomPattern) 
	-- space difference between two carrots
	size = 50
	-- table to keep track of carrot spawn values
	y = {}

	
	--			x
	--		x   	x
	--	x 				x
	
	if(randomPattern == 0) then
		y[0] = math.random() * 450 + 150
		y[1] = y[0]  - size
		y[2] = y[0]  - size * 2
		y[3] = y[0]  - size
		y[4] = y[0] 
	end

	return y
end
