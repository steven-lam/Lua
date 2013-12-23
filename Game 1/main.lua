function love.load()
	bg = love.graphics.newImage("bg.png")

	hero = {}
	hero.x = 300
	hero.y = 450
	hero.width = 30
	hero.height = 15
	hero.speed = 150
	hero.shots = {} -- holds our fired shots

	enemies = {}
	for i=0,7 do 
		enemy = {}
		enemy.width = 40
		enemy.height = 20
		enemy.x = math.random(40,800)
		enemy.y = math.random(20,465)
		table.insert(enemies, enemy)
	end
end

function love.keyreleased(key)
	if(key == "w") then
		shoot(0)
	elseif(key == "s") then 
		shoot(1)
	elseif(key == "a") then 
		shoot(2)	
	elseif(key == "d") then 
		shoot(3)			
	end
end


function love.update(dt)
	if next (enemies) == nil then	
	for i=0,7 do 
		enemy = {}
		enemy.width = 40
		enemy.height = 20
		enemy.x = math.random(40,800)
		enemy.y = math.random(20,465)
		table.insert(enemies, enemy)
	end
  end 
	-- keyboard actions for the hero
	if love.keyboard.isDown("left") then
		hero.x = hero.x - hero.speed*dt*1.5
	elseif love.keyboard.isDown("right") then
		hero.x = hero.x + hero.speed*dt*1.5
   elseif love.keyboard.isDown("up") then	
   	hero.y = hero.y - hero.speed*dt*1.5
   elseif love.keyboard.isDown("down") then	
      hero.y = hero.y + hero.speed*dt*1.5	
	end
	-- shoot detection
	local remEnemy = {}
	local remShot = {}
	-- update those shots
	for i,v in ipairs(hero.shots) do
		-- move them up up up
		if (v.direction == 0) then 
		v.y = v.y - dt * 300
		elseif (v.direction == 1) then 
		v.y = v.y + dt * 300
		elseif (v.direction == 2) then 
		v.x = v.x - dt * 300
		elseif (v.direction == 3) then 
		v.x = v.x + dt * 300
	   end 

		--mark shots that are not visible for removal
		if v.y < 0 then
			table.insert(remShot, i)
		end

		-- check for collision with enemies
		for ii,vv in ipairs(enemies) do
			if checkCollision(v.x,v.y,2,5,vv.x,vv.y,vv.width,vv.height) then 
				-- mark that enemy for removal
				table.insert(remEnemy, ii)
				-- mark the shot to be removed
				table.insert(remShot, i)
			end
		end
	end
	-- remove the marked enemies
  for i,v in ipairs(remEnemy) do 
   	table.remove(enemies, v)
  end 
 
  for i,v in ipairs(remShot) do 
   	table.remove(hero.shots, v)
  end 
  -- update those enemies
  for i,v in ipairs(enemies) do
  -- let them falll down slowly
	v.y = v.y + dt

	-- check for collision with ground
	   if v.y > 465 then
	    	-- you lose!
	   end	
  end
end

function love.draw()
	-- draws background
	love.graphics.setColor(255,255,255,255)
	love.graphics.draw(bg)

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

	-- shots
	for i,v in ipairs(hero.shots) do 
		if (v.direction == 0 or v.direction == 1) then 
		love.graphics.rectangle("fill", v.x, v.y, 2, 5)
		elseif (v.direction == 2 or v.direction == 3) then 
		love.graphics.rectangle("fill", v.x, v.y, 5, 2)  
	end
	end
end

function shoot (z)
	local shot = {}
	shot.x = hero.x + hero.width/2
	shot.y = hero.y
	shot.direction = z

	table.insert(hero.shots,shot)
end

-- checking collision
function checkCollision(ax1,ay1,aw,ah, bx1,by1,bw,bh)
	local ax2,ay2,bx2,by2 = ax1 + aw, ay1 + ah, bx1 + bw, by1 + bh 
	return ax1 < bx2 and ax2 > bx1 and ay1 < by2 and ay2 > by1
end
