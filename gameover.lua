local GameOver = {}

local font = nil
local go_text = nil

local font_button = nil

local buttons = {}
local marge_x = 30

function CheckCollision(x1,y1,w1,h1, x2,y2,w2,h2)
  return x1 < x2+w2 and
  x2 < x1+w1 and
  y1 < y2+h2 and
  y2 < y1+h1
end
--

function collidebutton(dt)
  local mx, my = love.mouse.getPosition()
  for i, button in ipairs(buttons) do
    if CheckCollision(mx,my,1,1,    button.x,button.y,button.width,button.height) then
      button.color = {1,0.1,0.1,1}
      button.sx = button.sx + 1.5 * dt
      button.sy = button.sy + 1.5 * dt
      if button.sx >= button.sx_max then button.sx = button.sx_max end
      if button.sy >= button.sy_max then button.sy = button.sy_max end

      if love.mouse.isDown(1) then button.func() end
    else
      button.color = button.colordef
      button.sx = button.sx - 1 * dt
      button.sy = button.sy - 1 * dt
      if button.sx <= button.sx_def then button.sx = button.sx_def end
      if button.sy <= button.sy_def then button.sy = button.sy_def end
    end
  end
end
--

local function newButton(x, y, txt, fn)
  local new = {
    x = x,
    y = y,
    width = 300,
    height = 75,
    text = txt,
    func = fn,
    color = {0.2, 0.2, 0.2},
    colordef = {0.2, 0.2, 0.2},
    sx_def = 1,
    sy_def = 1,
    sx = 1,
    sy = 1,
    sx_max = 1.2,
    sy_max = 1.2
  }
  new.drawText = love.graphics.newText(font_button, new.text)
  table.insert(buttons, new)
end

function back_to_menu()
  screen = "menu"
end

function GameOver.load()
  font = love.graphics.newFont("assets/fonts/Russo.ttf", 80)
  go_text = love.graphics.newText(font, "Game Over")

  font_button = love.graphics.newFont("assets/fonts/Russo.ttf", 30)

  newButton(0, 0, "Back on menu", back_to_menu)
  newButton(0, 0, "Exit", love.event.quit)

  local marge = (WIDTH - marge_x) / 2 - buttons[1].width 

  for i, button in ipairs(buttons) do
    button.x = marge 
    marge = marge + button.width + marge_x
  end

  for i, button in ipairs(buttons) do
    button.y = HEIGHT / 3 * 2 - button.height / 2
  end

  text_test = love.graphics.newText(font_button, "Hello World")
end
--

function GameOver.update(dt)
  collidebutton(dt)
end
--

function GameOver.draw()

  love.graphics.setColor(1, 1, 1)
  love.graphics.draw(go_text, (WIDTH - go_text:getWidth()) / 2, HEIGHT / 3 - go_text:getHeight() / 2)

  for i, button in ipairs(buttons) do
    love.graphics.setColor(button.color)
    local dec_x = math.abs(button.width - (button.width*button.sx))
    local dec_y = math.abs(button.height - (button.height*button.sy))
    love.graphics.rectangle("fill", button.x-(dec_x/2), button.y-(dec_y/2), button.width*button.sx, button.height*button.sy)
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(
      button.drawText,
      button.x + button.width / 2 - button.drawText:getWidth() / 2,
      button.y + button.height / 2 - button.drawText:getHeight() / 2
    )
  end
end

function GameOver.keypressed(key)

end

return GameOver