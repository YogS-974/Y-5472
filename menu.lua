local menu = {}

function menu.load()

end

function menu.update(dt)

end

function menu.draw()

end

function menu.keypressed(key)
	if key == "space" then 
		Current_scene = SceneGame
		newGame()
	end
end

return menu