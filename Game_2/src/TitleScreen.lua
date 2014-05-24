require('src/Screen')

TitleScreen = Screen:extends()

function TitleScreen:__init() 
	TitleScreen.super:__init("TitleScreen")
	self.startButton = false


end 

function TitleScreen:update(dt)
	gui.group.push{grow="down",pos={ love.graphics.getWidth()/2 - 50, love.graphics.getHeight()/2 + love.graphics.getHeight()/4 }	}
	if gui.Button{id = "start", text = "Start"} then
		self.start_button = true
		ActiveScreen = GameScreen()
	end
	gui.group.pop{}
end

function TitleScreen:render()
	love.graphics.setBackgroundColor(255,255,255)
end