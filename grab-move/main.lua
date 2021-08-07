
handle_1={50,50,500,50,mouse_grab_offset=nil} -- handle 1
handle_2={100,100,500,50,mouse_grab_offset=nil} -- handle 2
handle_grabbed_one=nil

function handle_area_draw(handle)
  local xywh=handle
  local mouse_down=love.mouse.isDown(1)
  love.graphics.setColor(0,0,1) -- blue color
  
  mouse={love.mouse.getX(),love.mouse.getY()}
  if
    handle_grabbed_one==nil and -- grab only one
    mouse_down and
    point_in_rectangle(mouse,xywh)
  then
    -- grab
    handle_grabbed_one=handle -- grab only one
    
    if handle.mouse_grab_offset==nil then
      handle.mouse_grab_offset={mouse[1]-xywh[1],mouse[2]-xywh[2]}
    end
  end
  
  if mouse_down and handle.mouse_grab_offset~=nil then
    xywh[1]=mouse[1]-handle.mouse_grab_offset[1]
    xywh[2]=mouse[2]-handle.mouse_grab_offset[2]
  end
  if not mouse_down then
    handle.mouse_grab_offset=nil
    handle_grabbed_one=nil
  end
  
  if handle_grabbed_one==handle then
    love.graphics.setColor(1,0,0) -- red color (grabbed)
  end
  love.graphics.rectangle("fill", xywh[1], xywh[2], xywh[3], xywh[4]) -- xywh (handle)

  love.graphics.setColor(1,1,1) -- white color
  love.graphics.rectangle("fill", xywh[1], xywh[2]+xywh[4], xywh[3], 4*xywh[4]) -- xywh (area)
end

function point_in_rectangle(point,xywh)
  return
    point[1]>=xywh[1] and
    point[1]<=(xywh[1]+xywh[3]) and
    point[2]>=xywh[2] and
    point[2]<=(xywh[2]+xywh[4])
end

button_quit={10,10, 100,100,
  function (button)
    love.graphics.setColor(0,1,0) -- green color
    local xywh=button
    love.graphics.rectangle("fill", xywh[1], xywh[2], xywh[3], xywh[4]) -- xywh (button)
  end,
  function() love.event.quit() end}
function button_draw(button)
  -- click pressed
  if love.mouse.isDown(1) and
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

function love.draw()
  handle_area_draw(handle_1)
  handle_area_draw(handle_2)
  button_draw(button_quit)
end

