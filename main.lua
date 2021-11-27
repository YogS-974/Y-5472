if pcall(require, "lldebugger") then
	require("lldebugger").start()
end

io.stdout:setvbuf("no")

love.graphics.setDefaultFilter("nearest")

debug_mode = false

local game = require("game")
local gameover = require("gameover")
local menu = require("menu")

function love.load()

	WIDTH = love.graphics.getWidth()
	HEIGHT = love.graphics.getHeight()

	screen = "game"

	game.load()
	gameover.load()
	menu.load()
end

function love.update(dt)
	if screen == "game" then game.update(dt) end
	if screen == "gameover" then gameover.update(dt) end
	if screen == "menu" then menu.update(dt) end
end

function love.draw()
	if screen == "game" then game.draw() end
	if screen == "gameover" then gameover.draw() end
	if screen == "menu" then menu.draw() end
end

function love.keypressed(key)
	if screen == "game" then game.keypressed(key) end
	if screen == "gameover" then gameover.keypressed(key) end
	if screen == "menu" then menu.keypressed(key) end
end

function love.mousepressed(x, y, b)

end