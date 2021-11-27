if pcall(require, "lldebugger") then
	require("lldebugger").start()
end

io.stdout:setvbuf("no")

love.graphics.setDefaultFilter("nearest")

debug_mode = false

SceneGame = require("game")
SceneGameover = require("gameover")
SceneMenu = require("menu")

Current_scene = SceneMenu

function love.load()

	WIDTH = love.graphics.getWidth()
	HEIGHT = love.graphics.getHeight()

	screen = "game"

	SceneGame.load()
	SceneGameover.load()
	SceneMenu.load()
end

function love.update(dt)
	Current_scene.update(dt)
end

function love.draw()
	Current_scene.draw()
end

function love.keypressed(key)
	Current_scene.keypressed(key)
end

function love.mousepressed(x, y, b)

end