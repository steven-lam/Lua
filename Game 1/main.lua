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
  
  lost = 0
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
  
  if(key == " ") then
    lost = 0
  end
end


function love.update(dt)
  leftKey  = love.keyboard.isDown("left")
  rightKey = love.keyboard.isDown("right")
  upKey    = love.keyboard.isDown("up")
  downKey  = love.keyboard.isDown("down")
  -- spanw more enemies when all 7 are gone
	if next (enemies) == nil then	
    spawnEnemy(hero.x, hero.y)
  end 
  
  -- restricts hero's movement to inside the screen
  if (hero.x < 0) then -- if hero moves pass left border
    hero.x = 0
  elseif (hero.x > (love.window.getWidth() - hero.width)) then -- if hero moves pass right border
    hero.x = love.window.getWidth() - hero.width
  elseif (hero.y < 0) then -- if hero moves above top border
    hero.y = 0
  elseif (hero.y > (love.window.getHeight() - hero.height)) then -- if hero moves below bottom border
    hero.y = love.window.getHeight() - hero.height
  end
  
	-- keyboard actions for the hero
	if (leftKey) then
		hero.x = hero.x - hero.speed*dt*1.5
	elseif (rightKey) then
		hero.x = hero.x + hero.speed*dt*1.5
  elseif (upKey) then	
   	hero.y = hero.y - hero.speed*dt*1.5
  elseif (downKey) then	
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
    -- make the enemies follow the hero
    distX =  hero.x - v.x
    distY =  hero.y - v.y
    distance = math.sqrt(distX*distX+distY*distY)
    velocityX = distX/distance*10
    velocityY = distY/distance*10
    v.x = v.x + velocityX*dt
    v.y = v.y + velocityY*dt
  end

  -- checks if you lose
  for i,v in ipairs(enemies) do
    if checkCollision(v.x,v.y,v.width,v.height, hero.x,hero.y,hero.width,hero.height) then 
      lost = 1
    end
 end 

end

function love.draw()
	
  -- draws background
	love.graphics.setColor(255,255,255,255)
	love.graphics.draw(bg)
  
  if (lost == 1) then
    love.graphics.print("you lose",400,300)
  end
  
  -- draw the hero's coordinates
  love.graphics.setColor(255, 0, 0)
  love.graphics.print(hero.x,600,100)
  love.graphics.print(hero.y,600,125)
  
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
  if (z == 2 or z == 3) then
  shot.y = hero.y + hero.height/2
  end

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
    local quadrant = math.random(1,4) -- 4 is not included
    local hemisphere = math.random(0,2) -- 2 is not included
    if (quadrant == 1) then
      enemy.x = math.random(enemy.width, heroX - heroRadius - enemy.width + 1)  -- plus one because of last pixel is excluded
      enemy.y = math.random(enemy.height, love.window.getHeight() - enemy.height + 1)
    elseif (quadrant == 2) then
      enemy.x = math.random(heroX - heroRadius, heroX + heroRadius + 1)
      if (hemisphere == 0) then
        enemy.y = math.random(enemy.height,heroY - heroRadius - enemy.height + 1)
      else
        enemy.y = math.random(heroY + heroRadius + enemy.height, love.window.getHeight() - enemy.height + 1)
      end
    elseif (quadrant == 3) then
      enemy.x = math.random(heroX + heroRadius + 1, love.window.getWidth() - enemy.width + 1)
      enemy.y = math.random(enemy.height, love.window.getHeight() - enemy.height + 1)
    end
    -- enemy is built, insert to enemiaaes table
		table.insert(enemies, enemy)
	end
end