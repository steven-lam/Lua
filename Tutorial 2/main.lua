function love.load()
	hero = {}
	hero.x = 300
	hero.y = 450
	hero.speed = 100
	hero.shots = {} -- holds our fired shots
	function shoot ()
		local shot = {}
		shot.x = hero.x+hero.width/2
		shot.y = hero.y
		table.insert(hero.shots,shot)
	end

	enemies = {}
	for i=0,7 do 
		enemy = {}
		enemy.width = 40
		enemy.height = 20
		enemy.x = i * (enemy.width + 60) + 100
		enemy.y = enemy.height + 100
		table.insert(enemies, enemy)
end

function love.update(dt)
	if love.keyboard.isDown("left") then
		hero.x = hero.x - hero.speed*dt
	elseif love.keyboard.isDown("right") then
		hero.x = hero.x + hero.speed*dt
	end

	-- enemies
	for i,v in ipairs(enemies) do
		-- let them falll down slowly
		v.y = v.y + dt

		-- chek for collision with ground
		if v.y > 465 then
			-- you lose!
		end

end

function love.draw()
	-- let's draw some ground
	love.graphics.setColor(0,255,0,255)
	love.graphics.rectangle("fill", 0, 465, 800, 150)

	-- let's draw our hero
	love.graphics.setColor(255,255,0,255)
	love.graphics.rectangle("fill", hero.x, hero.y, 30, 15)

	-- enemies
	love.graphics.setColor(0,255,255,255)
	for i,v in ipairs(enemies) do
		love.graphics.rectangle("fill", v.x, v.y, v.width, v.height)
end

