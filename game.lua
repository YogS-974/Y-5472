local Game = {}
local map = require("map")
local player = require("player")
local zombies = require("zombies")

map.current = 1
local current_map = nil

local general_bullet = {}
general_bullet.image = love.graphics.newImage('assets/images/bullet.png')
general_bullet.scale = 0.3
general_bullet.speed = 300

local tourelles = {}
local tourelle_img = love.graphics.newImage("assets/images/tourelle.png")
local tourelle_scale = 0.12
local tourelle_width = tourelle_img:getWidth() * tourelle_scale
local tourelle_height = tourelle_img:getHeight() * tourelle_scale
local tourelle_ox = tourelle_width / 2 / tourelle_scale
local tourelle_oy = tourelle_height / 2 / tourelle_scale
local tourelle_timer = 0
local tourelles_bullets = {}

function collide(xA, yA, wA, hA, xB, yB, wB, hB)
	return( (xA + wA >= xB) and (xA <= xB + wB) and (yA + hA >= yB) and (yA <= yB - hB) )
end

function change_level()
	map.current = map.current + 1
	player.bullets = {}
	tourelles_bullets = {}

	if map.current > #map.niveaux then
		map.current = 1
	end

	map.collide_zones = {}
	map.load_collide_zones()

	player.y = 320
	if map.current % 2 == 1 then
		player.x = 75
		player.angle = 0
	else
		player.x = WIDTH - 75 - player.width
		player.angle = 180
	end

	current_map = map.niveaux[map.current][1]
	current_layer = map.niveaux[map.current][2]

	load_tourelles()
	zombies.load_zombies()
end

function load_tourelles()
	tourelles = {}
	local cl = map.niveaux[map.current][2]
	for i=1, #cl do
		for j=1, #cl[i] do
			if cl[i][j] == 1 then
				local tourelle = {}
				tourelle.c = j
				tourelle.l = i
				tourelle.x = (tourelle.c - 1) * map.WIDTH_TILE + map.WIDTH_TILE / 2
				tourelle.y = (tourelle.l - 1) * map.HEIGHT_TILE + map.HEIGHT_TILE / 2 
				tourelle.angle = 0

				table.insert(tourelles, tourelle)
			end
		end
	end
	tourelle_timer = 0
end

function tourelles_shoot(x, y, angle)
	local bullet = {}
	bullet.angle = angle 
	bullet.x = x + math.cos(bullet.angle) * tourelle_width / 2
	bullet.y = y + math.sin(bullet.angle) * tourelle_width / 2
	bullet.vx = math.cos(bullet.angle) * 700
	bullet.vy = math.sin(bullet.angle) * 700

	table.insert(tourelles_bullets, bullet)
end

function calculate_angle(xA, yA, xB, yB)
	return math.atan2(yB-yA, xB-xA)
end

function newGame()
	map.current = 1
	current_map = map.niveaux[map.current][1]
	current_layer = map.niveaux[map.current][2]
	map.load_collide_zones()

	player.bullets = {}
	player.y = 320
	if map.current % 2 == 1 then
		player.x = 75
		player.angle = 0
	else
		player.x = WIDTH - 75 - player.width
		player.angle = 180
	end

	player.life.amount = 10

	load_tourelles()
	tourelles_bullets = {}
	zombies.load_zombies()
end

function Game.load()
	current_map = map.niveaux[map.current][1]
	current_layer = map.niveaux[map.current][2]
	map.collide_zones = {}

	player.load()
	map.load_collide_zones()
	load_tourelles()
	zombies.load_quads()
	zombies.load_zombies()
end

function Game.update(dt)
	current_map = map.niveaux[map.current][1]
	current_layer = map.niveaux[map.current][2]


	player.update(dt)

	for i, bullet in ipairs(player.bullets) do
		bullet.x = bullet.x + bullet.vx * dt
		bullet.y = bullet.y + bullet.vy * dt
	end

	for i, bullet in ipairs(tourelles_bullets) do
		bullet.x = bullet.x + bullet.vx * dt
		bullet.y = bullet.y + bullet.vy * dt
	end

	local bullet_id = #player.bullets
	while bullet_id > 0 do
		local bullet = player.bullets[bullet_id]

		if bullet.x < 0 or bullet.x > WIDTH or bullet.y < 0 or bullet.y > HEIGHT then
			table.remove(player.bullets, bullet_id)
		end

		local l = math.floor(bullet.y / map.WIDTH_TILE) + 1
		local c = math.floor(bullet.x / map.HEIGHT_TILE) + 1

		if c > 0  and c < 16 and l > 0 and l < 11 then
			if current_map[l][c] == 245 then
				table.remove(player.bullets, bullet_id)
			end

			if current_layer[l][c] == 1 then
				table.remove(player.bullets, bullet_id)
			end
		end

		bullet_id = bullet_id - 1
	end

	local bullet_id = #tourelles_bullets
	while bullet_id > 0 do
		local bullet = tourelles_bullets[bullet_id]

		if bullet.x < 0 or bullet.x > WIDTH or bullet.y < 0 or bullet.y > HEIGHT then
			table.remove(tourelles_bullets, bullet_id)
		end

		local l = math.floor(bullet.y / map.WIDTH_TILE) + 1
		local c = math.floor(bullet.x / map.HEIGHT_TILE) + 1

		if c > 0  and c < 16 and l > 0 and l < 11 then
			if current_map[l][c] == 245 then
				table.remove(tourelles_bullets, bullet_id)
			end

			if current_layer[l][c] == 1 then
				table.remove(tourelles_bullets, bullet_id)
			end


			if bullet.x > player.hitbox.x and bullet.x < player.hitbox.x + player.hitbox.size and bullet.y > player.hitbox.y and bullet.y < player.hitbox.y + player.hitbox.size then
				player.life.amount = player.life.amount - 1
				table.remove(tourelles_bullets, bullet_id)

				if player.life.amount < 1 then
					Current_scene = SceneGameover
				end
			end
		end

		bullet_id = bullet_id - 1
	end


	tourelle_timer = tourelle_timer + dt
	for i, tourelle in ipairs(tourelles) do
		tourelle.angle = calculate_angle(tourelle.x, tourelle.y, player.x, player.y)
	end

	if tourelle_timer > 1 then
		for i, tourelle in ipairs(tourelles) do
			tourelles_shoot(tourelle.x, tourelle.y, tourelle.angle)
		end
		tourelle_timer = 0
	end

	for i, zombie in ipairs(zombies.entities) do
		zombie.angle = calculate_angle(zombie.x, zombie.y, player.x, player.y)
		zombie.vx = math.cos(zombie.angle) * zombie.speed
		zombie.vy = math.sin(zombie.angle) * zombie.speed

		local collision = false

		for j, otherZombie in ipairs(zombies.entities) do
			if zombie ~= otherZombie then
				if (zombie.hitbox.x + zombie.vx * dt + zombie.hitbox.width < otherZombie.hitbox.x) or
				(zombie.hitbox.x + zombie.vx * dt > otherZombie.hitbox.x + otherZombie.hitbox.width) or
				(zombie.hitbox.y + zombie.vy * dt + zombie.hitbox.height < otherZombie.hitbox.y) or 
				(zombie.hitbox.y + zombie.vy * dt > otherZombie.hitbox.y + otherZombie.hitbox.height) then

				else
					collision = true
				end
			end
		end

		for i, box in ipairs(map.collide_zones) do
			if (zombie.hitbox.x + zombie.vx * dt + zombie.hitbox.width < box.x) or
			(zombie.hitbox.x + zombie.vx * dt > box.x + box.width) or
			(zombie.hitbox.y + zombie.vy * dt + zombie.hitbox.height < box.y) or 
			(zombie.hitbox.y + zombie.vy * dt > box.y + box.height) then

			else
				collision = true
			end
		end

		if not collision then
			zombie.x = zombie.x + zombie.vx * dt 
			zombie.y = zombie.y + zombie.vy * dt 
			zombies.control_position(zombie)
		else
			for i, box in ipairs(map.collide_zones) do
				if (zombie.hitbox.x + zombie.vx * dt + zombie.hitbox.width < box.x) or
				(zombie.hitbox.x + zombie.vx * dt > box.x + box.width) or
				(zombie.hitbox.y + zombie.hitbox.height < box.y) or
				(zombie.hitbox.y > box.y + box.height) then

				else
					collision = true
				end
			end

			if not collision then
				zombie.x = zombie.x + zombie.vx * dt
			else
				for i, box in ipairs(map.collide_zones) do
					if (zombie.hitbox.x + zombie.hitbox.width < box.x) or
					(zombie.hitbox.x > box.x + box.width) or
					(zombie.hitbox.y + zombie.vy * dt + zombie.hitbox.height < box.y) or
					(zombie.hitbox.y + zombie.vy * dt> box.y + box.height) then
	
					else
						collision = true
					end
				end
	
				if not collision then
					zombie.y = zombie.y + zombie.vy * dt
				end
			end
		end

		--Changement de state

		if zombie.angle >= math.rad(45) and zombie.angle <= math.rad(135) then
			zombies.change_state(1, zombie)
		elseif zombie.angle >= math.rad(135) and zombie.angle <= math.rad(225) then
			zombies.change_state(2, zombie)
		elseif zombie.angle <= math.rad(-45) and zombie.angle >= math.rad(-135) then
			zombies.change_state(3, zombie)
		elseif zombie.angle >= math.rad(-45) and zombie.angle <= math.rad(45) then
			zombies.change_state(4, zombie)
		end

		for j, otherZombie in ipairs(zombies.entities) do
			if zombie ~= otherZombie then
				if not (zombie.hitbox.x + zombie.vx * dt + zombie.hitbox.width < otherZombie.hitbox.x) and
				not (zombie.hitbox.x + zombie.vx * dt > otherZombie.hitbox.x + otherZombie.hitbox.width) and
				not (zombie.hitbox.y + zombie.vy * dt + zombie.hitbox.height < otherZombie.hitbox.y) and 
				not (zombie.hitbox.y + zombie.vy * dt > otherZombie.hitbox.y + otherZombie.hitbox.height) then

					zombies.ecarte_zombies(zombie, otherZombie, dt)
				end
			end
		end
	end
	zombies.update()
end

function Game.draw()
	love.graphics.setColor(1, 1, 1, 1)

	for i=1, #current_map do
		for j=1, #current_map[i] do
			love.graphics.draw(
				map.tilesheet,
				map.tiles[current_map[i][j]],
				(j - 1) * map.WIDTH_TILE,
				(i - 1) * map.HEIGHT_TILE
			)
		end
	end

	love.graphics.setColor(1, 1, 1, 1)

	for i, tourelle in ipairs(tourelles) do
		love.graphics.draw(
			tourelle_img,
			tourelle.x,
			tourelle.y,
			tourelle.angle - math.pi,
			tourelle_scale,
			tourelle_scale,
			tourelle_ox,
			tourelle_oy
		)
	end

	player.draw()

	love.graphics.setColor(1, 1, 1, 1)

	for i, zombie in ipairs(zombies.entities) do
		if zombie.current_state	< 4 then
			love.graphics.draw(
				zombies.spritesheet,
				zombies.quads[zombie.current_state],
				zombie.x,
				zombie.y,
				0,
				zombies.sx,
				zombies.sy)
		else
			love.graphics.draw(
				zombies.spritesheet,
				zombies.quads[2],
				zombie.x + zombie.width,
				zombie.y,
				0,
				-zombies.sx,
				zombies.sy)
		end
	end

	for i, bullet in ipairs(player.bullets) do
		love.graphics.draw(
			general_bullet.image,
			bullet.x,
			bullet.y,
			math.rad(bullet.angle),
			general_bullet.scale,
			general_bullet.scale,
			general_bullet.image:getWidth() / 2,
			general_bullet.image:getHeight() / 2)
	end

	for i, bullet in ipairs(tourelles_bullets) do
		love.graphics.draw(
			general_bullet.image,
			bullet.x,
			bullet.y,
			bullet.angle - math.pi,
			general_bullet.scale,
			general_bullet.scale,
			general_bullet.image:getWidth(),
			general_bullet.image:getHeight())
	end


	-- Système de vies (à améliorer)
	if player.life.amount > 0 then
		local cursor_x = 5
		for i=1, player.life.amount do
			love.graphics.draw(player.life.img, cursor_x, 0, player.life.scale, player.life.scale)
			cursor_x = cursor_x + player.life.width - 20
		end
	end
 
	if debug_mode == true then
		love.graphics.setColor(0, 0, 1, 1)
		for i=1, #map.collide_zones do
			love.graphics.rectangle("line", map.collide_zones[i].x, map.collide_zones[i].y, map.collide_zones[i].width, map.collide_zones[i].height)
		end

		love.graphics.setColor(0,1,0,1)
		for i, bullet in ipairs(player.bullets) do
			love.graphics.circle("fill", bullet.x, bullet.y, 4)
		end

		love.graphics.setColor(1, 0, 0, 1)
		for i, zombie in ipairs(zombies.entities) do
			love.graphics.rectangle("line", zombie.hitbox.x, zombie.hitbox.y, zombie.hitbox.width, zombie.hitbox.height)
		end
	end
end

function Game.keypressed(key)
	player.keypressed(key)

	if key == "a" and debug_mode then
		change_level()
	end


	-- A enlever
	if key == "space" then
		debug_mode = not debug_mode
	end
end

return Game