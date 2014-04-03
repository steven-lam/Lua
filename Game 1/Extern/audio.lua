-- background's audio
  bgMusic = love.audio.newSource("Sounds/Requiem for a Dream.mp3")
  love.audio.play(bgMusic)
  bgState = true
-- thruster's audio
  thrusters = love.audio.newSource("Sounds/thrusters.wav")
  thrusters:setVolume(.5)