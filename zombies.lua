local map = require("map")

local zombies = {}

zombies.spritesheet = love.graphics.newImage("assets/images/zombie.png")
zombies.spritesheet_width = zombies.spritesheet:getWidth()
zombies.spritesheet_height = zombies.spritesheet:getHeight()
zombies.width = 60
zombies.height = 78
zombies.sx = 0.7
zombies.sy = 0.7
zombies.quads = {}
zombies.entities = {}

zombies.load_quads = function()
	zombies.quads[1] = love.graphics.newQuad(0, 0, 75, 78, zombies.spritesheet_width, zombies.spritesheet_height)
	zombies.quads[2] = love.graphics.newQuad(76, 0, 60, 78, zombies.spritesheet_width, zombies.spritesheet_height)
	zombies.quads[3] = love.graphics.newQuad(130, 0, 78, 78, zombies.spritesheet_width, zombies.spritesheet_height)
end

zombies.load_zombies = function()
	zombies.entities = {}
	local cl = map.niveaux[map.current][2]

	for i=1, #cl do
		for j=1, #cl[i] do
			if cl[i][j] == 2 then
				local zombie = {}
				zombie.x = (j-1) * 64 + 32 - (zombies.width * zombies.sx) / 2
				zombie.y = (i-1) * 64 + 32 - (zombies.height * zombies.sy) / 2
				zombie.angle = 0
				zombie.current_state = 1
				zombie.speed = 100
				zombie.vx = 0
				zombie.vy = 0
				zombie.width = 60 * zombies.sx
				zombie.height = 78 * zombies.sy
				zombie.hitbox = {}
				zombie.hitbox.x = zombie.x 
				zombie.hitbox.y = zombie.y 
				zombie.hitbox.width = zombie.width 
				zombie.hitbox.height = zombie.height

				table.insert(zombies.entities, zombie)
			end
		end
	end
end

zombies.update = function()
	for i, zombie in ipairs(zombies.entities) do
		zombie.width = 60 * zombies.sx
		zombie.height = 78 * zombies.sy
		zombie.hitbox = {}
		zombie.hitbox.x = zombie.x 
		zombie.hitbox.y = zombie.y 
		zombie.hitbox.width = zombie.width
		zombie.hitbox.height = zombie.height 

		if zombie.current_state == 1 or zombie.current_state == 3 then
			zombie.width = 80 * zombies.sx
			zombie.hitbox.width = zombie.width  
		end
	end
end


return zombies

-- Gérer le spawn des zombies