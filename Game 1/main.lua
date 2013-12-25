function love.load()
	bg = love.graphics.newImage("bg.png")
  heroRadius = 50
	hero = {}
	hero.x = 300
	hero.y = 450
	hero.width = 30
	hero.height = 15
	hero.speed = 150
	hero.shots = {} -- holds our fired shots

	enemies = {}
  spawnEnemy(hero.x, hero.y)
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
    spawnEnemy(hero.x, hero.y)
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

--function checkLocation (heroX, heroY, enemyX, enemyY)
--	leftX  = heroX - 50
--	rightX = heroX + 50
--	topY   = heroY - 50
--	bottomY = heroY + 50
--end
-- checking collision
function checkCollision(ax1,ay1,aw,ah, bx1,by1,bw,bh)
	local ax2,ay2,bx2,by2 = ax1 + aw, ay1 + ah, bx1 + bw, by1 + bh 
	return ax1 < bx2 and ax2 > bx1 and ay1 < by2 and ay2 > by1
end

-- enemy spawning function that takes in hero's location
function spawnEnemy(heroX, heroY)
  -- Grabs window dimensions
  local top  = 0 
  local bottom = love.window.getHeight()
  local left = 0
  local right = love.window.getWidth()
  -- Creates 7 enemy
  for i=0,7 do 
    local enemy = {}
		enemy.width = 50
		enemy.height = 50
    enemy.x = 0;
    enemy.y = 0;
    local quadrant = math.random(1,5) -- 5 is not included
    local hemisphere = math.random(0,2) -- 2 is not included
    if (quadrant == 1) then
      enemy.x = math.random(enemy.width, heroX - heroRadius - enemy.width + 1)  -- plus one because of last pixel is excluded
      enemy.y = math.random(enemy.height, love.window.getHeight() - enemy.height + 1)
    elseif (quadrant == 2) then
      enemy.x = math.random(heroX - heroRadius, heroX + 1)
      if (hemisphere == 0) then
        enemy.y = math.random(enemy.height,heroY - heroRadius - enemy.height + 1)
      else
        enemy.y = math.random(heroY + heroRadius + enemy.height, love.window.getHeight() - enemy.height + 1)
      end
    elseif (quadrant == 3) then
      enemy.x = math.random(heroX + 1, heroX + heroRadius + 1)
      if (hemisphere == 0) then
        enemy.y = math.random(enemy.height, heroY - heroRadius - enemy.height + 1)
      else 
        enemy.y = math.random(heroY + heroRadius + enemy.height, love.window.getHeight() - enemy.height + 1)
      end 
    elseif (quadrant == 4) then
      enemy.x = math.random(heroX + heroRadius + 1, love.window.getWidth() - enemy.width + 1)
      enemy.y = math.random(enemy.height, love.window.getHeight() - enemy.height + 1)
    end
    -- enemy is built, insert to enemies table
		table.insert(enemies, enemy)
	end
end