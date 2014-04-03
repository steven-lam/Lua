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
  
  -- Hero's movements
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

-- reduces hero's health after 20 frames
function heroDamage()
  hero.health_frame = hero.health_frame + 1
  if(hero.health_frame == 10) then
    hero.health = hero.health - 1;
    hero.health_frame = 0
  end
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