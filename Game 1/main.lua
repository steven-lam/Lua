function love.load()
  -- hero
  require("Extern/hero")
  -- enemy
  require("Extern/enemy")
  -- window functions
  require("Extern/window")
  spawnEnemy(hero.x, hero.y)
  -- audio
  require("Extern/audio")
  -- game state
  lost = 0
  -- fullscreen state
  fsState = false
  -- dead bugs table used to draw
  enemyDeaths = {}
  deathTime = 0
  rightDeadBug = love.graphics.newImage("Images/antDeath.png")
  leftDeadBug = love.graphics.newImage("Images/antDeath2.png")
end

function love.keypressed(key)
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
  hero.rotationUpdate()
  
	-- Checks for shots' collision
  shootDetection(dt)
  
  -- update enemies position
  moveEnemy(dt)

  -- if rocket touches enemy then rocket loses health
  heroDamage()
 
  -- spawn more enemies when all enemies are gone
	if next (enemies) == nil then	
    spawnEnemy(hero.x, hero.y)
    gameLevel = gameLevel + 1
  end 
  
  -- replays background if it completed
  if(not bgMusic:isPlaying() and bgState) then
    love.audio.play(bgMusic)
  end
  
  -- checks to see if game is over
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
  hero.healthBar()
  
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
  love.graphics.print("Level : ", 200, 10)
  love.graphics.print(gameLevel, 250, 10)
  
  -- draw the hero's score
  love.graphics.print("Score : ", 460, 10)
  love.graphics.print(hero.score, 510, 10)
  
  -- draw the enemy count
  love.graphics.print("Enemy Count : ", 460, 30)
  love.graphics.print(enemyCount, 560, 30)
  
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

function shootDetection(dt)
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
end