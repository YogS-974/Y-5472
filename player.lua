local player = {}
local map = require("map")

player.spritesheet = love.graphics.newImage("assets/images/soldier.png")
player.width = 43
player.height = 22
player.quads = {}
player.current_frame = 1
player.angle = 0
player.scale = 1.5
player.x = 75
player.y = 320 
player.vx = 0
player.vy = 0
player.speed = 200
player.ox = 11
player.oy = 11
player.direction = 0
player.hitbox = {}
player.hitbox.x = player.x 
player.hitbox.y = player.y 
player.hitbox.size = 22
player.bullets = {}
player.life = {}
player.life.amount = 10
player.life.img = love.graphics.newImage("assets/images/coeur.png")
player.life.scale = 0.03
player.life.width = player.life.img:getWidth() * player.life.scale
player.life.height = player.life.img:getHeight() * player.life.scale


local bullet_image = love.graphics.newImage("assets/images/bullet.png")
local ox_bullet = bullet_image:getWidth() / 2
local oy_bullet = bullet_image:getHeight() / 2

function player.shoot()
	local bullet = {}
	bullet.angle = player.angle + 180
	bullet.vx = math.cos(math.rad(bullet.angle + 180)) * 700 
	bullet.vy = math.sin(math.rad(bullet.angle + 180)) * 700


	if player.direction == 1 then
		bullet.x = player.x - player.ox + player.width + oy_bullet
		bullet.y = player.y
	elseif player.direction == 2 then
		bullet.x = player.x - player.ox + player.width 
		bullet.y = player.y - player.oy + player.width
	elseif player.direction == 3 then
		bullet.x = player.x 
		bullet.y = player.y - player.oy + player.width + oy_bullet
	elseif player.direction == 4 then
		bullet.x = player.x + player.ox - player.width 
		bullet.y = player.y - player.oy + player.width 
	elseif player.direction == 5 then
		bullet.x = player.x + player.ox - player.width - oy_bullet
		bullet.y = player.y
	elseif player.direction == 6 then
		bullet.x = player.x + player.ox - player.width 
		bullet.y = player.y + player.oy - player.width
	elseif player.direction == 7 then
		bullet.x = player.x 
		bullet.y = player.y + player.oy - player.width - oy_bullet
	elseif player.direction == 8 then
		bullet.x = player.x - player.ox + player.width 
		bullet.y = player.y + player.oy - player.width 
	end

	table.insert(player.bullets, bullet)
end

function player.move(dt)
	local last_x = player.x 
	local last_y = player.y 

	local collision = false

	for i, box in ipairs(map.collide_zones) do
		if (player.hitbox.x + player.vx * dt + player.hitbox.size < box.x) or
		 (player.hitbox.x + player.vx * dt > box.x + box.width) or
		 (player.hitbox.y + player.vy * dt + player.hitbox.size < box.y) or 
		 (player.hitbox.y + player.vy * dt > box.y + box.height) then

		else
			collision = true
		end
	end

	if not collision then
		player.x = player.x + player.vx * dt 
		player.y = player.y + player.vy * dt 
	end


	if player.hitbox.x - player.width + player.ox < 0 and (player.angle == 180 or player.angle == 225 or player.angle == 135) then
		player.x = last_x
	end

	if player.hitbox.x + player.hitbox.size + player.width - player.ox > WIDTH and (player.angle == 0 or player.angle == 45 or player.angle == 315) then
		player.x = last_x
	end

	if player.hitbox.y - player.width + player.oy < 0 and (player.angle == 270 or player.angle == 225 or player.angle == 315) then
		player.y = last_y
	end

	if player.hitbox.y + player.hitbox.size + player.width - player.oy > HEIGHT and (player.angle == 90 or player.angle == 45 or player.angle == 135) then
		player.y = last_y
	end
end


function player.load_quads()
	for i=1, 3 do
		player.quads[i] = love.graphics.newQuad(
			(i - 1) * player.width,
			0,
			player.width,
			player.height,
			player.spritesheet:getWidth(),
			player.spritesheet:getHeight())
	end
end

function player.load()
	player.load_quads()
end

function player.update(dt)
	player.hitbox.x = player.x - player.ox 
	player.hitbox.y = player.y - player.oy

	if love.keyboard.isDown("right") and love.keyboard.isDown("down") then
		player.angle = 45
		player.vx = math.cos(math.rad(player.angle)) * player.speed
		player.vy = math.sin(math.rad(player.angle)) * player.speed

		player.current_frame = player.current_frame + 3 * dt 
		if player.current_frame >= 4 then player.current_frame = 2 end

	elseif love.keyboard.isDown("down") and love.keyboard.isDown("left") then
		player.angle = 135
		player.vx = math.cos(math.rad(player.angle)) * player.speed
		player.vy = math.sin(math.rad(player.angle)) * player.speed

		player.current_frame = player.current_frame + 3 * dt 
		if player.current_frame >= 4 then player.current_frame = 2 end

	elseif love.keyboard.isDown("left") and love.keyboard.isDown("up") then
		player.angle = 225
		player.vx = math.cos(math.rad(player.angle)) * player.speed
		player.vy = math.sin(math.rad(player.angle)) * player.speed

		player.current_frame = player.current_frame + 3 * dt 
		if player.current_frame >= 4 then player.current_frame = 2 end

	elseif love.keyboard.isDown("up") and love.keyboard.isDown("right") then
		player.angle = 315
		player.vx = math.cos(math.rad(player.angle)) * player.speed
		player.vy = math.sin(math.rad(player.angle)) * player.speed

		player.current_frame = player.current_frame + 3 * dt 
		if player.current_frame >= 4 then player.current_frame = 2 end

	elseif love.keyboard.isDown("right") and not love.keyboard.isDown("left") then
		player.angle = 0
		player.vx = math.cos(math.rad(player.angle)) * player.speed
		player.vy = math.sin(math.rad(player.angle)) * player.speed

		player.current_frame = player.current_frame + 3 * dt 
		if player.current_frame >= 4 then player.current_frame = 2 end

	elseif love.keyboard.isDown("down") and not love.keyboard.isDown("up") then
		player.angle = 90
		player.vx = math.cos(math.rad(player.angle)) * player.speed
		player.vy = math.sin(math.rad(player.angle)) * player.speed

		player.current_frame = player.current_frame + 3 * dt 
		if player.current_frame >= 4 then player.current_frame = 2 end

	elseif love.keyboard.isDown("left") and not love.keyboard.isDown("right") then
		player.angle = 180
		player.vx = math.cos(math.rad(player.angle)) * player.speed
		player.vy = math.sin(math.rad(player.angle)) * player.speed

		player.current_frame = player.current_frame + 3 * dt 
		if player.current_frame >= 4 then player.current_frame = 2 end

	elseif love.keyboard.isDown("up") and not love.keyboard.isDown("down") then
		player.angle = 270
		player.vx = math.cos(math.rad(player.angle)) * player.speed
		player.vy = math.sin(math.rad(player.angle)) * player.speed

		player.current_frame = player.current_frame + 3 * dt 
		if player.current_frame >= 4 then player.current_frame = 2 end
	else
		player.vx = 0
		player.vy = 0

		player.current_frame = 1
	end

	player.move(dt)
	player.direction = player.angle / 45 + 1
end

function player.draw()
	love.graphics.draw(
		player.spritesheet,
		player.quads[math.floor(player.current_frame)],
		player.x,
		player.y,
		math.rad(player.angle),
		player.scale,
		player.scale,
		player.ox,
		player.oy)

	if debug_mode == true then
		love.graphics.setColor(1, 0, 0, 1)
		love.graphics.rectangle("line", player.hitbox.x, player.hitbox.y, player.hitbox.size, player.hitbox.size)
	end
end	

function player.keypressed(key)
	if key == "s" then
		player.shoot()
	end
end

return player