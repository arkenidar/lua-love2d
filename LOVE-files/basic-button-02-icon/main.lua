function button_draw_quit(button)
  -- background
  love.graphics.setColor(1,1,1) -- white bg
  love.graphics.rectangle("fill", button[1], button[2], button[3], button[4]) -- xywh
end

function love.load()
icon_x = love.graphics.newImage("icon-x.png")
end
function button_draw_quit(button)
love.graphics.draw(icon_x, button[1], button[2])
end

local button={10,10,100,100,button_draw_quit,function()  love.event.quit() end}

function button_draw(button)
  if love.mouse.isDown(1) and
    love.mouse.getX() >= button[1] and
    love.mouse.getX() <= (button[1]+button[3]) and
    love.mouse.getY() >= button[2] and
    love.mouse.getY() <= (button[2]+button[4])
  then
    button[6](button) -- action
  end
  button[5](button) -- draw
end

function love.draw()
  button_draw(button)
end
