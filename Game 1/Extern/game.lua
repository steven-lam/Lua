game = {}

-- game initialize
function game.init()
  -- the initial level
    gameLevel = 1
  -- game state
    GameStates = {"main_menu", "instructions", "game", "gameover"}
    curGameState = 1
    gameState = GameStates[1]
end
  
-- updates the game
function game.next() 
  curGameState = curGameState + 1
  if(curGameState == 5) then
    curGameState = 1
  end
  gameState = GameStates[curGameState]
end