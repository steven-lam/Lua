HC = require("Extern/HardonCollider")
enemy = {}
function enemy.init() 
  -- Creates a table of enemies
  enemies = {}
  enemyCount = 0; -- enemy counter
  enemyID = 0;    -- assigns each enemy a unique id
  maxEnemy = 9    -- max enemy count for level

  -- bug's right and left image
  rightFace = love.graphics.newImage("Images/ant.png") 
  leftFace = love.graphics.newImage("Images/ant2.png")

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
     -- give the enemy a hitbox
     enemy.shape = Collider:addRectangle(enemy.x,enemy.y,enemy.width,enemy.height);
     table.insert(enemies, enemy)
     enemyCount = enemyCount + 1;
     -- increment the ID for the next enemy
     enemyID = enemyID + 1;
     end
	end
  maxEnemy = maxEnemy + 2
end

-- Update enemies' movements
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
    elseif (v.momentum >= 8) then
      v.momentum = 8
    end
    
    -- update enemy's position
    v.x = v.x + v.velocityX*dt*v.momentum
    v.y = v.y + v.velocityY*dt*v.momentum
    v.shape:moveTo(v.x + v.width/2, v.y+v.height/2)
  end
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