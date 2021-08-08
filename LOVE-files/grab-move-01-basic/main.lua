
xywh1={50,50,100,100}
xywh2={150+10,50,100,100}
handles={xywh1,xywh2,{250+20,50,100,100}}

function mouse_coordinates()
  return {love.mouse.getX(),love.mouse.getY()}
end

handle_currently_grabbed=nil
function handle_grab(handle)
  local xywh=handle
  local mouse=mouse_coordinates()
  if love.mouse.isDown(1) then -- mouse down
    if xywh.mouse_grab_offset==nil then -- if ungrabbed
      if point_in_rectangle(mouse,xywh) -- if inside
      and handle_currently_grabbed==nil -- if none is grabbed already
      then
        -- grab
        handle_currently_grabbed=handle
        xywh.mouse_grab_offset={mouse[1]-xywh[1],mouse[2]-xywh[2]}
      end
    end
    if xywh.mouse_grab_offset~=nil then -- if grabbed
      xywh[1]=mouse[1]-xywh.mouse_grab_offset[1]
      xywh[2]=mouse[2]-xywh.mouse_grab_offset[2]
    end
  else -- mouse up
    xywh.mouse_grab_offset=nil -- un-grab
    handle_currently_grabbed=nil
  end

end

function handle_draw(handle)
  local xywh=handle
  love.graphics.setColor(1,1,1) -- white color
  if xywh.mouse_grab_offset~=nil then -- if grabbed
    love.graphics.setColor(1,0,0) -- red color
  end

  love.graphics.rectangle("fill", xywh[1], xywh[2], xywh[3], xywh[4]) -- xywh
end

function love.draw()

  -- input: front to back order
  for i = #handles,1,-1 do
    handle_grab(handles[i])
  end

  -- drawing: back to front order
  for i = 1,#handles,1 do
    handle_draw(handles[i])
  end

end

function point_in_rectangle(point,xywh)
  return
    point[1]>=xywh[1] and
    point[1]<=(xywh[1]+xywh[3]) and
    point[2]>=xywh[2] and
    point[2]<=(xywh[2]+xywh[4])
end
