function love.load()
  -- title of game
  love.window.setTitle("SpaceBugs")
  -- icon for game
  icon = love.image.newImageData("Images/ant.png")
  love.window.setIcon(icon)
  -- background's image
	background = love.graphics.newImage("Images/background.png")
  -- bug's right and left image
  rightFace = love.graphics.newImage("Images/ant.png") 
  leftFace = love.graphics.newImage("Images/ant2.png")
  -- hero's table and stats
  hero = {}
  hero.img = love.graphics.newImage("Images/rocket.png")
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
  hero.velocityX = 0
  hero.velocityY = 0
  hero.momentum = 0
  hero.health = 100
  hero.health_frame = 0
  heroRadius = 50
  -- enemy table, count, and creates enemy
	enemies = {}
  enemyCount = 0;
  enemyID = 0;
  maxEnemy = 9
  spawnEnemy(hero.x, hero.y)
  -- game state
  lost = 0
  -- rotation values for hero's rotation
  rotation = 0
  rotationValue = 0
  newRotation = 0
  -- background's audio
  bgMusic = love.audio.newSource("Sounds/Requiem for a Dream.mp3")
  love.audio.play(bgMusic)
  bgState = true
  -- thruster's audio
  thrusters = love.audio.newSource("Sounds/thrusters.wav")
  thrusters:setVolume(.5)
  -- fullscreen state
  fsState = false
  -- dead bugs table used to draw
  enemyDeaths = {}
  deathTime = 0
  rightDeadBug = love.graphics.newImage("Images/antDeath.png")
  leftDeadBug = love.graphics.newImage("Images/antDeath2.png")
  -- the game level
  gameLevel = 1
end

function love.keypressed(key)
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
    hero.health = 100
  end
  
  if(key == "t") then
    if(bgState) then
      love.audio.pause(bgMusic)
    else
      love.audio.resume(bgMusic)
    end
    bgState = not bgState
  end
  
  if(key == "m") then
    fsState = not fsState
    if(fsState) then
      love.window.setFullscreen(true)
    else
      love.window.setFullscreen(false)
    end
  end

  if(key == "escape") then
    love.window.setFullscreen(false)
  end
end


function love.update(dt) 
  -- clears the enemy's after image 
  deathsClear()

  -- Fixes the direction the enemy's face
  enemyImageCheck()
 
  -- Updates Hero's movement
  moveHero(dt)
  
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
  
	-- shoot detection
	local remEnemy = {}
	local remShot = {}
  
	-- update shots
	for i,v in ipairs(hero.shots) do
  -- update the shots new location
  v.x = v.x + v.velocityx * dt * 25
  v.y = v.y + v.velocityy * dt * 25
  
	--mark shots that are not visible for removal
	if (v.y < 0 or v.x < 0) then
		table.insert(remShot, i)
  elseif (v.y > love.window.getHeight() or v.x > love.window.getWidth()) then
     table.insert(remShot, i)
	end

	-- check for collision with enemies
  for ii,vv in ipairs(enemies) do
		if checkCollision(v.x,v.y,2,2,vv.x,vv.y,vv.width,vv.height) then 
      if (vv.img == rightFace) then
        vv.img = rightDeadBug
      else
        vv.img = leftDeadBug
      end
			-- mark that enemy for removal
			table.insert(remEnemy, vv.rank)
			-- mark the shot to be removed
			table.insert(remShot, i)
       hero.score = hero.score + 1
		end
	end
end
  
	-- remove the marked enemies
  for i,v in ipairs(remEnemy) do 
   	for ii,vv in ipairs(enemies) do
      if(v == vv.rank) then
        -- add enemy being deleted to enemyDeaths 
        -- for after image
        local enemy = vv
        enemy.tick = 0
        table.insert(enemyDeaths,enemy)
        -- remove enemy from enemy's who are still alive
        table.remove(enemies,ii)
        -- bug's death audio
        deadBugSFX = love.audio.newSource("Sounds/bugDeath.wav")
        enemyCount = enemyCount - 1;
        love.audio.play(deadBugSFX)
        -- reduce enemyID by 1 because one enemy is gone
        enemyID = enemyID - 1
      end
    end
  end 
 
  -- remove the shots that need to be removed
  for i,v in ipairs(remShot) do 
   	table.remove(hero.shots, v)
  end 
  
  -- update enemies position
  moveEnemy(dt)

  -- if rocket touches enemy then rocket loses health
  for i,v in ipairs(enemies) do
    if checkCollision(v.x,v.y,v.width,v.height, hero.x ,hero.y ,hero.width,hero.height) then 
      heroDamage()
    end
 end 
 
  -- spawn more enemies when all enemies are gone
	if next (enemies) == nil then	
    spawnEnemy(hero.x, hero.y)
    gameLevel = gameLevel + 1
  end 
  
  -- replays background if it completed
  if(not bgMusic:isPlaying() and bgState) then
    love.audio.play(bgMusic)
  end
  
  if(hero.health < 0) then
    hero.health = 0
    lost = 1
  end
end

function love.draw()
  
  -- draws background
	love.graphics.setColor(255,255,255,255)
	love.graphics.draw(background)
  
  -- draw the rocket's health bar
  -- draw the description
  love.graphics.print("Rocket's Health : ", 500, 130)
  -- drawing white outline
  -- love.graphics.setColor(255,255,255)
  -- love.graphics.rectangle("fill", 497, 147, 106,16)
  -- drawing the health color
  if(hero.health >= 70 ) then
    love.graphics.setColor(0,255,0)
  end
  if(hero.health < 70 and hero.health >= 30) then
    love.graphics.setColor(255,102,0)
  end
  if(hero.health < 30 and hero.health > 0) then
     love.graphics.setColor(255,0,0)
  end
  love.graphics.rectangle("fill", 500, 150, hero.health,10)
  -- draw the current health to player / match current health's color
  love.graphics.print(hero.health, 610, 130)
  
  -- prints that the user lost
  if (lost == 1) then
    love.graphics.print("you lose",400,300)
  end
  
  -- draw the hero's coordinates
--  love.graphics.setColor(255, 0, 0)
--  love.graphics.print("Hero X: ",500,100)
--  love.graphics.print(hero.x,600,100)
--  love.graphics.print("Hero Y: ",500,125)
--  love.graphics.print(hero.y,600,125)
  
--  -- draw the rotation Value+++++++
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
  
  love.graphics.setColor(255,255,255,255)
  love.graphics.rectangle("line",hero.x ,hero.y ,hero.width,hero.height/2)

  -- draw the Game's level
  love.graphics.print("Level : ", 500, 200)
  love.graphics.print(gameLevel, 600, 200)
  
  -- draw the hero's score
  love.graphics.print("Score : ", 500, 225)
  love.graphics.print(hero.score, 600, 225)
  
  -- draw the enemy count
  love.graphics.print("Enemy Count : ", 500, 250)
  love.graphics.print(enemyCount, 600, 250)
  
	-- let's draw our hero
	love.graphics.setColor(255,255,255,255)
  love.graphics.draw(hero.img, hero.x + hero.img:getWidth()/2, hero.y + hero.img:getHeight()/2 , math.rad(rotation), 1, 1, hero.img:getWidth()/2, hero.img:   getHeight()/2)
	--love.graphics.rectangle("fill", hero.x, hero.y, 30, 15)

	-- enemies
	love.graphics.setColor(255,255,255,255)
	for i,v in ipairs(enemies) do
    love.graphics.draw(v.img, v.x, v.y)
		--love.graphics.rectangle("fill", v.x, v.y, v.width, v.height)
  end
  
  -- dead enemies
  for i,v in ipairs(enemyDeaths) do
    love.graphics.draw(v.img, v.x, v.y)
		--love.graphics.rectangle("fill", v.x, v.y, v.width, v.height)
  end
	-- shots
  love.graphics.setColor(255,0,0)
	for i,v in ipairs(hero.shots) do 
  --if (v.direction == 0 or v.direction == 1) then 
  --love.graphics.rectangle("fill", v.x, v.y, 2, 5)
  --elseif (v.direction == 2 or v.direction == 3) then 
  --love.graphics.rectangle("fill", v.x, v.y, 5, 2)  
  love.graphics.rectangle("fill", v.x, v.y, 2,2)
  --end
  end
end

function moveHero(dt) 
  speedUp = love.keyboard.isDown("w")
  slowDown = love.keyboard.isDown("s")
  
  -- momentum limit
  if(hero.momentum >= 15) then
    hero.momentum = 15
  elseif(hero.momentum <= 0) then
    hero.momentum = 0
  end
  
  -- keyboard actions for the hero
  hero.x = hero.x + hero.velocityX*dt*hero.momentum
  hero.y = hero.y + hero.velocityY*dt*hero.momentum
  
  -- plays thrusters audio if hero moves and changes image
  -- if not, slow hero down and changeg image to w/o thrusters
  if(speedUp) then
    love.audio.play(thrusters)
    hero.img = love.graphics.newImage("Images/rocketIgnition.png")
    hero.momentum = hero.momentum + .1
    -- updates hero's movement based on the direction he is facing
    hero.velocityX = math.sin(newRotation * (math.pi/180)) * (hero.img:getHeight()/2)
    hero.velocityY = -1 * math.cos(newRotation * (math.pi/180)) * (hero.img:getHeight()/2)
  elseif (slowDown) then
    love.audio.play(thrusters)
    hero.img = love.graphics.newImage("Images/rocketIgnition.png")
    hero.momentum = hero.momentum - .2
  else 
    hero.momentum = hero.momentum - .1
    hero.img = love.graphics.newImage("Images/rocket.png")
    love.audio.stop(thrusters)
  end
  -- verify that the rocket is in bounds
  cornerCheck()
  inBounds()
end

function moveEnemy(dt)
  for i,v in ipairs(enemies) do
    -- update enemys velocity to follow hero
    distX =  hero.x - v.x
    distY =  hero.y - v.y
    distance = math.sqrt(distX*distX+distY*distY)
    enemyNewVelocityX = distX/distance*10
    enemyNewVelocityY = distY/distance*10
    
    -- calculate enemy's old and new velocity
    enemyNewVelocityMag = math.sqrt(enemyNewVelocityX * enemyNewVelocityX
      + enemyNewVelocityY*enemyNewVelocityY)
    enemyOldVelocityMag = math.sqrt(v.velocityX * v.velocityX 
      + v.velocityY*v.velocityY)
    
    -- change enemy's momentum: same velocity = speed up / diff velocity = slow down
    if (enemyNewVelocityMag == enemyOldVelocityMag) then
      v.momentum = v.momentum + .1
    else
      if (distance > 500) then
        v.momentum = v.momentum + .1
      else
      v.momentum = v.momentum - .2
      end
    end
    
    -- update old velocity to new velocity
    v.velocityX = enemyNewVelocityX
    v.velocityY = enemyNewVelocityY
    
    -- momentum limit
    if (v.momentum <= 1.5) then
      v.momentum = 1.5
    elseif (v.momentum >= 10) then
      v.momentum = 10
    end
    
    -- update enemy's position
    v.x = v.x + v.velocityX*dt*v.momentum
    v.y = v.y + v.velocityY*dt*v.momentum
  end
end

-- checks to see if rocket went out of bound
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

-- checks if the user went out the window in a corner
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

-- the firing functions
function shoot ()
  fire = love.audio.newSource("Sounds/ShotsSFX.mp3")
	local shot = {}
	shot.x = hero.nose.x + hero.img:getWidth() / 2;
	shot.y = hero.nose.y + hero.img:getHeight() / 2;
  shot.velocityx = math.sin(newRotation * (math.pi/180)) * (hero.img:getHeight()/2)
  shot.velocityy = -1 * math.cos(newRotation * (math.pi/180)) * (hero.img:getHeight()/2)
	table.insert(hero.shots,shot)
  love.audio.play(fire)
end

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
  
  -- Creates enemies
  while (table.getn(enemies) <= maxEnemy) do 
    local repeatedEnemy = false
    local enemy = {}
		enemy.width = 50
		enemy.height = 50
    enemy.x = 0;
    enemy.y = 0;
    enemy.velocityX = 10
    enemy.velocityY = 10
    enemy.momentum = 1.5;
    enemy.img = love.graphics.newImage("Images/ant.png")
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
    
    for j,v in ipairs(enemies) do
      if (v.x == enemy.x and v.y == enemy.y) then
        repeatedEnemy = true
        break
      end
    end
    
    if(not repeatedEnemy) then
     -- enemy is built, insert to enemies table
     -- give each enemy an ID
     enemy.rank = enemyID
     enemy.x = enemy.x
     enemy.y = enemy.y
     table.insert(enemies, enemy)
     enemyCount = enemyCount + 1;
     -- increment the ID for the next enemy
     enemyID = enemyID + 1;
     end
	end
  maxEnemy = maxEnemy + 2
end

-- fixes enemy's image
function enemyImageCheck()
	for i,v in ipairs(enemies) do
    if(v.x == hero.x) then
      if(v.y > hero.x) then
        v.img = rightFace
      else
        v.img = leftFace
      end
    elseif(v.x > hero.x) then
      v.img = leftFace
    else
      v.img = rightFace
    end
  end 
end

-- clears enemy's deaths after 20 frames
function deathsClear()
  for i,v in ipairs (enemyDeaths) do
    if(v.tick == 20) then
      table.remove(enemyDeaths,i)
    else
      v.tick = v.tick+1
    end
  end
end

-- reduces rocket's health after 20 frames
function heroDamage()
  hero.health_frame = hero.health_frame + 1
  if(hero.health_frame == 10) then
    hero.health = hero.health - 1;
    hero.health_frame = 0
  end
end