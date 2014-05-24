require('src/Screen')

EndScreen = Screen:extends()

function EndScreen:__init()
	EndScreen.super:__init('EndScreen')
	self.replayButton = false
	self.quitButton = false

end

function EndScreen:update(dt)
	gui.group.push{grow="down",pos={ love.graphics.getWidth()/2 - 50, love.graphics.getHeight()/2 + love.graphics.getHeight()/4 }	}
	if gui.Button{id = "replay", text = "Replay"} then
		self.replayButton = true
		ActiveScreen = TitleScreen()
	end
	if gui.Button{id = "Quit", text = "Quit"} then
		self.quitButton = true
		love.event.quit()
	end
	gui.group.pop{}
end

function EndScreen:render()
	love.graphics.setBackgroundColor(255,255,255)
end