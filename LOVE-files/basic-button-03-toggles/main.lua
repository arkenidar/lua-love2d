local images={}
local clicked=false

function love.load()
  images.x = love.graphics.newImage("images/icon-x.png")
  images.empty = love.graphics.newImage("images/check-empty.png")
  images.filled = love.graphics.newImage("images/check-filled.png")
end

function image_draw(image,xywh)
  local sx=xywh[3]/image:getWidth()
  local sy=xywh[4]/image:getHeight()
  love.graphics.draw(image, xywh[1],xywh[2],0, sx,sy)
end

local button_quit={10,10, 100,100,
  function (button) image_draw(images.x,button) end,
  function() love.event.quit() end}

function toggle_draw(button)
  local state
  if button[7] then state="filled" else state="empty" end
  image_draw(images[state],button)
end
function toggle_action(button) button[7]=not button[7] end
local button_toggle_1={10+100+10,10, 50,50, toggle_draw, toggle_action, true}
local button_toggle_2={10+100+10,10+50+10, 50,50, toggle_draw, toggle_action, false}

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
  button_draw(button_quit)
  button_draw(button_toggle_1)
  button_draw(button_toggle_2)
  clicked=false
end
