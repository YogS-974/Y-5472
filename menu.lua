local menu = {}

function menu.load()

end

function menu.update(dt)

end

function menu.draw()

end

function menu.keypressed(key)
	if key == "space" then 
		screen = "game"
		newGame()
	end
end

return menu