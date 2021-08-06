clicked=false

function image_draw(image,xywh)
  local sx=xywh[3]/image:getWidth()
  local sy=xywh[4]/image:getHeight()
  love.graphics.draw(image, xywh[1],xywh[2],0, sx,sy)
end

require("conf-buttons") -- conf-buttons.lua file

function button_draw(button)
  if clicked and ---love.mouse.isDown(1) and
    love.mouse.getX() >= button[1] and
    love.mouse.getX() <= (button[1]+button[3]) and
    love.mouse.getY() >= button[2] and
    love.mouse.getY() <= (button[2]+button[4])
  then
    button[6](button) -- action
  end
  button[5](button) -- draw
end

function love.mousereleased(x,y,button)
  if button==1 then
    clicked=true
  end
end

function love.draw()
  draw_all_buttons()
  clicked=false
end

function love.keypressed(key, u)
  if key == "rctrl" then -- RightControl key
    -- Configuration reload but preserve states
    conf_buttons_reload()
  end
end
