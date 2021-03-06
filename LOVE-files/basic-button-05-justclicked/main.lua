-- draw image scaled and fitting rectangle
function image_draw(image,xywh)
  -- scale factors
  local sx=xywh[3]/image:getWidth()
  local sy=xywh[4]/image:getHeight()
  -- provide image, position, scale
  love.graphics.draw(image, xywh[1],xywh[2],0, sx,sy)
end

-- conf-buttons.lua file
require("conf-buttons")

function button_draw(button)
  -- click just pressed (not before)
  if click_down==1 and
    -- check for mouse pointer being inside the rectagle
    love.mouse.getX() >= button[1] and
    love.mouse.getX() <= (button[1]+button[3]) and
    love.mouse.getY() >= button[2] and
    love.mouse.getY() <= (button[2]+button[4])
  then
    button[6](button) -- action
  end
  button[5](button) -- draw
end

click_down=0 -- counter for mouse button pressed
function click_get_input()
  -- click button pressing (button down)
  if love.mouse.isDown(1) and -- button 1 down
      click_down<=500 then -- prevent integer overflow
    click_down = click_down + 1 -- increment the counter
  else -- click button release (button up)
    click_down = 0 -- reset the counter to 0
  end
end

function love.draw()
  click_get_input()
  draw_all_buttons()
end

function love.keypressed(key, u)
  if key == "rctrl" then -- RightControl key
    -- Configuration reload but preserve states
    conf_buttons_reload()
  end
end
