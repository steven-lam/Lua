audio = {}

-- main menu's audio
  main_menuAudio = {}
  main_menuAudio.state = true
  main_menuAudio.music = love.audio.newSource("Sounds/main_menu.mp3")
  
-- instruction's audio
  instructionAudio = {}
  instructionAudio.state = true
  instructionAudio.music = love.audio.newSource("Sounds/instructions.mp3")
  
-- in game's background's audio
  inGameAudio = {}
  inGameAudio.state = true
  inGameAudio.music = love.audio.newSource("Sounds/Requiem for a Dream.mp3")
  
-- thruster's audio
  thrusters = love.audio.newSource("Sounds/thrusters.wav")
  thrusters:setVolume(.5)
  
-- toggles any song
function audio:toggle(song)
  if(song.state) then
    love.audio.pause(song.music)
  else
    love.audio.resume(song.music)
  end
  song.state = not song.state
end

-- keeps playing a song if it stopped
function audio:keepPlaying(song) 
  if(song.music:isStopped()) then
    love.audio.play(song.music)
  end
end

-- Dead bug sound effect
function playDeadBugSFX()
  deadBugSFX = love.audio.newSource("Sounds/bugDeath.wav")
  love.audio.play(deadBugSFX)
end