game = {}

-- game initialize
function game.init()
  -- the initial level
    gameLevel = 1
  -- game state
    GameStates = {"main_menu", "instructions", "practice", "game", "gameover"}
    curGameState = 1
    pauseState = false
    gameState = GameStates[1]
end
  
-- updates the game
function game.next() 
  curGameState = curGameState + 1
  if(curGameState == 6) then
    curGameState = 1
  end
  gameState = GameStates[curGameState]
end

-- pauses the game
function game:pause()
  pauseState = not pauseState
  if(pauseState) then
    gameState = "pause"
  else
    gameState = GameStates[curGameState]
  end
end

function game:restart() 
  Collider:clear()
end
