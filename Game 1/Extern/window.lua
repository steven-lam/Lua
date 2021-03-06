window = {}

function window.init()
-- title of game
  love.window.setTitle("SpaceBugs")
-- icon for game
  icon = love.image.newImageData("Images/ant.png")
  love.window.setIcon(icon)
-- main menu's background image
  main_menuBG = love.graphics.newImage("Images/main_menu.png")
-- instruction's image
  instruction = love.graphics.newImage("Images/instructions.png")
-- In game's background image
  background = love.graphics.newImage("Images/background.png")
-- pause screen's image
  pauseImage = love.graphics.newImage("Images/pause.png")
-- fullscreen state
  fsState = false
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