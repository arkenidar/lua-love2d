
xywh1={50,50,100,100}
xywh2={150,50,100,100}

function draw_handle(xywh)
  
  love.graphics.setColor(1,1,1) -- white color
  
  local mouse={love.mouse.getX(),love.mouse.getY()}
  if love.mouse.isDown(1) then -- mouse down
    if xywh.mouse_grab_offset==nil then -- if ungrabbed
      if point_in_rectangle(mouse,xywh) then -- if inside
        -- grab
        xywh.mouse_grab_offset={mouse[1]-xywh[1],mouse[2]-xywh[2]}
      end
    end
    if xywh.mouse_grab_offset~=nil then -- if grabbed
      love.graphics.setColor(1,0,0) -- red color
      xywh[1]=mouse[1]-xywh.mouse_grab_offset[1]
      xywh[2]=mouse[2]-xywh.mouse_grab_offset[2]
    end
  else -- mouse up
    xywh.mouse_grab_offset=nil -- un-grab
  end
  
  love.graphics.rectangle("fill", xywh[1], xywh[2], xywh[3], xywh[4]) -- xywh
end

function love.draw()
  draw_handle(xywh1)
  draw_handle(xywh2)
end

function point_in_rectangle(point,xywh)
  return
    point[1]>=xywh[1] and
    point[1]<=(xywh[1]+xywh[3]) and
    point[2]>=xywh[2] and
    point[2]<=(xywh[2]+xywh[4])
end
