game = {}

-- game initialize
function game.init()
  -- the initial level
    gameLevel = 1
  -- game state
    GameStates = {"main_menu", "game", "gameover"}
    curGameState = 1
    gameState = GameStates[1]
end
  
-- updates the game
function game.next() 
  curGameState = curGameState + 1
  if(curGameState == 4) then
    curGameState = 1
  end
  gameState = GameStates[curGameState]
end