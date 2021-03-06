HC = require("Extern/HardonCollider")

hero = {}

function hero.init()
-- hero's table and stats
  hero.img = love.graphics.newImage("Images/rocket.png")
  hero.x = 400
  hero.y = 300
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
  hero.health = 100
  hero.health_frame = 0
  heroRadius = 50
  
-- rotation values for hero's rotation
  rotation = 0
  rotationValue = 0
  newRotation = 0
-- velocity limits
  velocityLimit = 1750
end
  
  -- Hero's movements
function moveHero(dt) 
  speedUp = love.keyboard.isDown("up")
  slowDown = love.keyboard.isDown("down")
  
  -- keyboard actions for the hero
  hero.x = hero.x + hero.velocityX*dt*.1
  hero.y = hero.y + hero.velocityY*dt*.1
  hero.shape:moveTo(hero.x + hero.width/2, hero.y+hero.height/2)
  -- plays thrusters audio if hero moves and changes image
  -- if not, slow hero down and changeg image to w/o thrusters
  if(speedUp) then
    love.audio.play(thrusters)
    hero.img = love.graphics.newImage("Images/rocketIgnition.png")
    -- updates hero's movement based on the direction he is facing
    hero.velocityX = math.sin(newRotation * (math.pi/180)) * (hero.img:getHeight()/2) + hero.velocityX 
    hero.velocityY = -1 * math.cos(newRotation * (math.pi/180)) * (hero.img:getHeight()/2) + hero.velocityY
  -- if rocket is slowing down
  elseif (slowDown) then
    love.audio.play(thrusters)
    hero.img = love.graphics.newImage("Images/rocketIgnition.png")
    -- X velocity
    if(hero.velocityX > 0 )then
      hero.velocityX = hero.velocityX - 15
    elseif(hero.velocityX < 0) then
      hero.velocityX = hero.velocityX + 15
    end
    -- Y velocity
    if(hero.velocityY > 0 )then
      hero.velocityY = hero.velocityY - 15
    elseif(hero.velocityY < 0) then
      hero.velocityY = hero.velocityY + 15
    end
  -- if rocket is not speeding up/slowing down then slow it down
  else 
    -- X velocity
    if(hero.velocityX > 0 )then
      hero.velocityX = hero.velocityX - 10
    elseif(hero.velocityX < 0) then
      hero.velocityX = hero.velocityX + 10
    end
    -- Y velocity
    if(hero.velocityY > 0 )then
      hero.velocityY = hero.velocityY - 10
    elseif(hero.velocityY < 0) then
      hero.velocityY = hero.velocityY + 10
    end
    hero.img = love.graphics.newImage("Images/rocket.png")
    love.audio.stop(thrusters)
  end
  -- limit the velocity's X
  if(hero.velocityX >= velocityLimit) then
    hero.velocityX = velocityLimit
  elseif (hero.velocityX <= -1 * velocityLimit) then
    hero.velocityX = -1 * velocityLimit
  end
  -- limit the velocity's Y
  if(hero.velocityY >= velocityLimit) then
    hero.velocityY = velocityLimit
  elseif (hero.velocityY <= -1 * velocityLimit) then
    hero.velocityY = -1 * velocityLimit
  end
  -- verify that the rocket is in bounds
  cornerCheck()
  inBounds()
end

-- update hero's image based on rotation
function hero.rotationUpdate()
  if (love.keyboard.isDown("left") and love.keyboard.isDown("right")) then
      rotation = rotation
  elseif (love.keyboard.isDown("right")) then
      rotation =  rotation + math.pi 
  elseif (love.keyboard.isDown("left")) then
      rotation = rotation - math.pi 
  end
  
  -- Keeps the bounds for angle from 0-360
  if (rotation < 0) then
    rotation = (math.abs(rotation))
    newRotation = -1 * rotation % 360
    rotation = -1 * rotation
  else
    newRotation = rotation % 360
  end
  
  -- Have to continuously update the nose
  hero.nose.x = math.sin(newRotation * (math.pi/180)) * (hero.img:getHeight()/2) + hero.x
  hero.nose.y = hero.y - math.cos(newRotation * (math.pi/180)) * (hero.img:getHeight()/2)
  hero.shape:setRotation(newRotation * math.pi/180)
end

-- reduces hero's health after 20 frames
function heroDamage()
  hero.health_frame = hero.health_frame + 1
  if(hero.health_frame == 10) then
      hero.health = hero.health - 1
      hero.health_frame = 0
  end
end

-- the firing functions
function shoot ()
  fire = love.audio.newSource("Sounds/ShotsSFX.mp3")
	local shot = {}
	shot.x = hero.nose.x + hero.img:getWidth() / 2 
	shot.y = hero.nose.y + hero.img:getHeight() / 2 + 1
  shot.velocityx = math.sin(newRotation * (math.pi/180)) * (hero.img:getHeight()/2)
  shot.velocityy = -1 * math.cos(newRotation * (math.pi/180)) * (hero.img:getHeight()/2)
  shot.shape = Collider:addRectangle(shot.x, shot.y, 2,2)
  shot.damage = 1
	table.insert(hero.shots,shot)
  love.audio.play(fire)
end

function hero.healthBar()
  -- draw the description
  love.graphics.print("Rocket's Health : ", 300, 10)
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
  love.graphics.rectangle("fill", 300, 30, hero.health,10)
  -- draw the current health to player / match current health's color
  love.graphics.print(hero.health, 410, 10)
 end
 
 -- checking collision
function checkCollision(ax1,ay1,aw,ah, bx1,by1,bw,bh)
	local ax2,ay2,bx2,by2 = ax1 + aw, ay1 + ah, bx1 + bw, by1 + bh 
	return ax1 < bx2 and ax2 > bx1 and ay1 < by2 and ay2 > by1
end