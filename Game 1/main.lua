-- hero
  require("Extern/hero")
-- enemy
  require("Extern/enemy")
-- window functions
  require("Extern/window")
-- audio
  require("Extern/audio")
-- game
  require("Extern/game")
-- Collider
  HC = require("Extern/HardonCollider")

  x = 0
  y = 0
  shotD = false
function love.load()
  -- setup collider
    Collider = HC(100, on_collision)
  -- inits
    hero.init()
    enemy.init()
    window.init() 
    game.init()
  -- dead bugs table used to draw
    enemyDeaths = {}
    rightDeadBug = love.graphics.newImage("Images/antDeath.png")
    leftDeadBug = love.graphics.newImage("Images/antDeath2.png")
  -- start main menu bg music
    love.audio.play(main_menuAudio.music)
    testx = 600
    testy = 150
    test = false

end

-- this is called when two shapes collide
function on_collision(dt, shape_a, shape_b, mtv_x, mtv_y)

  -- check if hero collided
  if(shape_a == hero.shape or shape_b == hero.shape) then
    -- if rocket touches enemy then rocket loses health
      heroDamage()
    if(shape_a == hero.shape) then
          print('colliding:', 'hero', shape_b)
          detected = shape_b
    elseif(shape_b == hero.shape) then
          print('colliding:', shape_a, 'hero')
          detected = shape_a
    elseif(shape_a == hero.shape and shape_b == hero.shape) then
          print('colliding:', 'hero', 'hero')  
          detected = hero.shape
    end
    
    x = mtv_x;
    y = mtv_y;
    test = true
  end
    
    -- check for shot collision
    local shot, enemy_rank, enemy_shape;
    
    for i,v in ipairs(hero.shots) do
      if(shape_a == v.shape or shape_b == v.shape) then
        detected1 = shape_a
        detected2 = shape_b
      end
      if(shape_a == v.shape) then
        shot = v
        enemy_shape = shape_b
        shotD = true
        --remove shot from collider
        Collider:remove(shot.shape)
        table.remove(hero.shots,i)
        break
      elseif(shape_b == v.shape) then
        shot = v
        enemy_shape = shape_a
        shotD = true
        --remove shot from collider
        Collider:remove(shot.shape)
        table.remove(hero.shots,i)
        break
      end
    end
    -- find which enemy is the colliding one
    for i,v in ipairs(enemies) do
      if(v.shape == enemy_shape) then
        enemy_rank = v.rank; -- found the right enemy
        if (v.img == rightFace) then
          v.img = rightDeadBug
        else
          v.img = leftDeadBug
        end
        hero.score = hero.score + 1
      end
    end
    
    -- remove the marked enemies
    for i,v in ipairs(enemies) do
      if(enemy_rank == v.rank) then
        -- add enemy being deleted to enemyDeaths 
        -- for after image
        local enemy = v
        enemy.tick = 0
        table.insert(enemyDeaths,enemy)
        -- remove enemy from enemy's who are still alive
        table.remove(enemies,i)
        enemyCount = enemyCount - 1;
        --remove enemy from collider
        Collider:remove(enemy_shape)
        -- bug's death audio
        playDeadBugSFX()
        -- reduce enemyID by 1 because one enemy is gone
        enemyID = enemyID - 1
      end
    end
end

function love.keypressed(key)
  if(gameState == "main_menu") then
    if(key == "return") then
      game.next()
      love.audio.stop(main_menuAudio.music)
      love.audio.play(instructionAudio.music)
    end
  elseif(gameState == "instructions") then
    if(key == "return") then
      game.next()
      hero.init()
      enemy.init()
      love.audio.stop(instructionAudio.music)
      love.audio.play(inGameAudio.music)
      hero.shape = Collider:addRectangle(hero.x, hero.y , hero.img:getWidth()/2, hero.img: getHeight())
    end
  elseif(gameState == "game") then
    if (key == " ") then
      shoot()
    end
    -- if space is pressed
    if(key == "r") then
      lost = 0
      hero.health = 100
    end
    
    if(key == "t") then
      audio:toggle(inGameAudio)
      test=false
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
      game:pause()
      audio:toggle(inGameAudio)
    end
    
  elseif(gameState == "gameover") then
    if(key == " ") then
      -- restarts the game values
      game:restart() 
      game.next()
    end
    
  elseif(gameState == "pause") then
    if(key == "p") then
      game:pause()
      audio:toggle(inGameAudio)
    end
  end
end


function love.update(dt) 
  shotD = false;
    test = false;
-- game state: Main Menu
  if(gameState == "main_menu") then
    audio:keepPlaying(main_menuAudio)
-- game state: Instructions     
  elseif(gameState == "instructions") then
    audio:keepPlaying(instructionAudio)
-- game state: In Game  
  elseif(gameState == "game") then
      detected = hero.shape
      detected1 = hero.shape
      detected2 = hero.shape
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

    -- spawn more enemies when all enemies are gone
    if next (enemies) == nil then	
      spawnEnemy(hero.x, hero.y)
      gameLevel = gameLevel + 1
    end 
    
    -- replays background if it completed
    audio:keepPlaying(inGameAudio)
    -- checks to see if game is over
    if(hero.health < 0) then
      game.next()
    end
  elseif(gameState == "gameover") then
    love.audio.stop(inGameAudio.music)
  end
  
      -- check for collisions
    Collider:update(dt)
  
end

function love.draw()
  if (gameState == "main_menu") then
    love.graphics.setColor(255,255,255,255)
    love.graphics.draw(main_menuBG)
  elseif(gameState == "instructions") then
        love.graphics.setColor(255,255,255,255)
    love.graphics.draw(instruction)
  elseif (gameState == "game") then
    -- draws background
    love.graphics.setColor(255,255,255,255)
    love.graphics.draw(background)
    
    -- draw the rocket's health bar
    hero.healthBar()

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
  
    -- make text white  
    love.graphics.setColor(255,255,255)
    
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
  elseif(gameState == "gameover") then
    -- prints that the user lost
    love.graphics.print("you lose",375,300)
    love.graphics.print("Press space to return to main menu", 275, 320)
  -- if Game is paused
  elseif(gameState == "pause") then
    love.graphics.setColor(255,255,255)
    love.graphics.draw(pauseImage)
  end
  
  if(test) then
    local x, y = hero.shape:center()
    love.graphics.print(math.floor(x),600,400)
    love.graphics.print(math.floor(y),650,400)
 end
  
  if(gameState == "game") then
  love.graphics.setColor(255,255,255)
    detected:draw("fill")
  love.graphics.setColor(0,255,0)
    detected1:draw("fill")
    detected2:draw("fill")
    if(shotD) then
      love.graphics.print("shot collision", 500, 300)
    end
  end
end

function shootDetection(dt)
-- shoot detection
	local remShot = {}
  
	-- update shots
	for i,v in ipairs(hero.shots) do
  -- update the shots new location
  v.x = v.x + v.velocityx * dt * 25
  v.y = v.y + v.velocityy * dt * 25
  v.shape:moveTo(v.x,v.y)
  
  --mark shots that are not visible for removal
    if (v.y < 0 or v.x < 0) then
      table.insert(remShot, i)
    elseif (v.y > love.window.getHeight() or v.x > love.window.getWidth()) then
       table.insert(remShot, i)
    end
  end
  
  -- remove the shots that need to be removed
  for i,v in ipairs(remShot) do
    -- remove from collider AND shot table
    Collider:remove(hero.shots[v].shape)
   	table.remove(hero.shots, v)
  end 
end