function love.load()
	bg = love.graphics.newImage("bg.png")
  heroRadius = 50
  hero = {}
  hero.img = love.graphics.newImage("spacerocket2.png")
	hero.x = 300
	hero.y = 450
	hero.width = 25
	hero.height = 50
	hero.speed = 150
  hero.score = 0
	hero.shots = {} -- holds our fired shots
  hero.nose = {}
  hero.nose.x = hero.x
  hero.nose.y = hero.y - hero.img:getHeight()/2
  
	enemies = {}
  
  enemyCount = 0;
  spawnEnemy(hero.x, hero.y)

  lost = 0
  rotation = 0
  rotationValue = 0
  newRotation = 0
end

function love.keyreleased(key)
--	if(key == "w") then
--		shoot(0)
--	elseif(key == "s") then 
--		shoot(1)
--	elseif(key == "a") then 
--		shoot(2)	
--	elseif(key == "d") then 
--		shoot(3)	
  if (key == " ") then
    shoot()
	end
  
  -- if space is pressed
  if(key == "r") then
    lost = 0
  end
  
end


function love.update(dt)  
  leftKey  = love.keyboard.isDown("a")
  rightKey = love.keyboard.isDown("d")
  upKey    = love.keyboard.isDown("w")
  downKey  = love.keyboard.isDown("s")
  
  -- Rotates the hero's image
  if (love.keyboard.isDown("left") and love.keyboard.isDown("right")) then
      rotation = rotation;
  elseif (love.keyboard.isDown("right")) then
      rotation =  rotation + math.pi 
  elseif (love.keyboard.isDown("left")) then
      rotation = rotation - math.pi 
  end
  
  -- Have to continuously update the nose
  -- Keeps the bounds for angle from 0-360
  if (rotation < 0) then
    rotation = (math.abs(rotation))
    newRotation = -1 * rotation % 360
    rotation = -1 * rotation
  else
    newRotation = rotation % 360
  end
  
  hero.nose.x = math.sin(newRotation * (math.pi/180)) * (hero.img:getHeight()/2) + hero.x
  hero.nose.y = hero.y - math.cos(newRotation * (math.pi/180)) * (hero.img:getHeight()/2)
  
--  if enemyCount == nil then
--    spawnEnemy(hero.x, hero.y)
--  end
  
  --spawn more enemies when all 8 are gone
	if next (enemies) == nil then	
    spawnEnemy(hero.x, hero.y)
  end 
  
	-- keyboard actions for the hero
	if (leftKey and not rightKey and not upKey and not downKey) then
		hero.x = hero.x - hero.speed*dt*1.5
	elseif (not leftKey and rightKey and not upKey and not downKey) then
		hero.x = hero.x + hero.speed*dt*1.5
  elseif (not leftKey and not rightKey and upKey and not downKey) then	
   	hero.y = hero.y - hero.speed*dt*1.5
  elseif (not leftKey and not rightKey and not upKey and downKey) then	
    hero.y = hero.y + hero.speed*dt*1.5	
  elseif (leftKey and not rightKey and upKey and not downKey) then
    hero.x = hero.x - hero.speed*dt*1.5
    hero.y = hero.y - hero.speed*dt*1.5
  elseif (leftKey and not rightKey and not upKey and downKey) then
    hero.x = hero.x - hero.speed*dt*1.5
    hero.y = hero.y + hero.speed*dt*1.5
  elseif (not leftKey and rightKey and upKey and not downKey) then
    hero.x = hero.x + hero.speed*dt*1.5
    hero.y = hero.y - hero.speed*dt*1.5 
  elseif (not leftKey and rightKey and not upKey and downKey) then
    hero.x = hero.x + hero.speed*dt*1.5
    hero.y = hero.y + hero.speed*dt*1.5 
	end
  cornerCheck()
  inBounds()
  
	-- shoot detection
	local remEnemy = {}
	local remShot = {}
  
	-- update those shots
	for i,v in ipairs(hero.shots) do
--		if (v.direction == 0) then 
--		v.y = v.y - dt * 300
--		elseif (v.direction == 1) then 
--		v.y = v.y + dt * 300
--		elseif (v.direction == 2) then 
--		v.x = v.x - dt * 300
--		elseif (v.direction == 3) then 
--		v.x = v.x + dt * 300
  v.x = v.x + v.velocityx * dt * 25
  v.y = v.y + v.velocityy * dt * 25

	--end 

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
        hero.score = hero.score + 1
			end
		end
	end
  
	-- remove the marked enemies
  for i,v in ipairs(remEnemy) do 
   	table.remove(enemies, v)
   enemyCount = enemyCount - 1;
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
    v.x = v.x + velocityX*dt*1.5
    v.y = v.y + velocityY*dt*1.5
  end

  -- checks if you lose
  for i,v in ipairs(enemies) do
    if checkCollision(v.x,v.y,v.width,v.height, hero.x,hero.y,hero.width,hero.height) then 
      lost = 1
    end
 end 

end

function love.draw()
	local value = rotation
  -- draws background
	love.graphics.setColor(255,255,255,255)
	love.graphics.draw(bg)
  
  if (lost == 1) then
    love.graphics.print("you lose",400,300)
  end
  
  -- draw the hero's coordinates
--  love.graphics.setColor(255, 0, 0)
--  love.graphics.print("Hero X: ",500,100)
--  love.graphics.print(hero.x,600,100)
--  love.graphics.print("Hero Y: ",500,125)
--  love.graphics.print(hero.y,600,125)
  
--  -- draw the rotation Value
--  love.graphics.print("rotation: ",500,150)
--  love.graphics.print(rotation,600,150)
  
--  -- draw the rotation Value
--  love.graphics.print("newRotation: ",500,175)
--  love.graphics.print(newRotation,600,175)
  
--  -- draw the rotation Value
--  love.graphics.print("nose X : ",500,200)
--  love.graphics.print(hero.nose.x,600,200)
--  love.graphics.print("nose Y : ",500,225)
--  love.graphics.print(hero.nose.y,600,225)
  
  -- draw the hero's score
  love.graphics.print("Score : ",350,10)
  love.graphics.print(hero.score,450,10)
  
  love.graphics.print("Enemy Count : ", 500, 250)
  love.graphics.print(enemyCount, 600, 250)
  
	-- let's draw our hero
	love.graphics.setColor(255,255,255,255)
  love.graphics.draw(hero.img, hero.x + hero.img:getWidth()/2, hero.y + hero.img:getHeight()/2 , math.rad(rotation), 1, 1, hero.img:getWidth()/2, hero.img:   getHeight()/2)
	--love.graphics.rectangle("fill", hero.x, hero.y, 30, 15)

	-- enemies
	love.graphics.setColor(0,255,255,255)
	for i,v in ipairs(enemies) do
		love.graphics.rectangle("fill", v.x, v.y, v.width, v.height)
  end

	-- shots
	for i,v in ipairs(hero.shots) do 
--		if (v.direction == 0 or v.direction == 1) then 
--		love.graphics.rectangle("fill", v.x, v.y, 2, 5)
--		elseif (v.direction == 2 or v.direction == 3) then 
--		love.graphics.rectangle("fill", v.x, v.y, 5, 2)  
  love.graphics.rectangle("fill", v.x, v.y, 2,2)
--	end
	end
end

function inBounds ()
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
end

function cornerCheck()
  if(hero.x < 0 and hero.y < 0) then
    hero.x = 0
    hero.y = 0
  elseif (hero.x < 0 and hero.y > love.window.getHeight() - hero.height) then
    hero.x = 0
    hero.y = love.window.getHeight() - hero.height
  elseif (hero.x > love.window.getWidth() - hero.width and hero.y < 0) then
    hero.x = love.window.getWidth() - hero.width
    hero.y = 0
  elseif (hero.x > love.window.getWidth() - hero.width and hero.y > love.window.getHeight() - hero.height) then
    hero.x = love.window.getWidth() - hero.width
    hero.y = love.window.getHeight() - hero.height
  end
end
function shoot ()
  fire = love.audio.newSource("gun-gunshot-01.wav")
	local shot = {}
	shot.x = hero.nose.x + hero.img:getWidth() / 2;
	shot.y = hero.nose.y + hero.img:getHeight() / 2;
  shot.velocityx = math.sin(newRotation * (math.pi/180)) * (hero.img:getHeight()/2)
  shot.velocityy = -1 * math.cos(newRotation * (math.pi/180)) * (hero.img:getHeight()/2)
	table.insert(hero.shots,shot)
  love.audio.play(fire)
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
   enemyCount = enemyCount + 1;
	end
end