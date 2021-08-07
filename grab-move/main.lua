
xywh={50,50,500,50} -- handle

mouse_grab_offset=nil

function love.draw()
  
  love.graphics.setColor(0,0,1) -- blue color
  
  mouse={love.mouse.getX(),love.mouse.getY()}
  if love.mouse.isDown(1) then
    love.graphics.setColor(1,0,0) -- red color
    if mouse_grab_offset==nil and
        point_in_rectangle(mouse,xywh) then
      mouse_grab_offset={mouse[1]-xywh[1],mouse[2]-xywh[2]}
    else
      xywh[1]=mouse[1]-mouse_grab_offset[1]
      xywh[2]=mouse[2]-mouse_grab_offset[2]
    end
  else
    mouse_grab_offset=nil
  end
  
  love.graphics.rectangle("fill", xywh[1], xywh[2], xywh[3], xywh[4]) -- xywh

  love.graphics.setColor(1,1,1) -- white color
  love.graphics.rectangle("fill", xywh[1], xywh[2]+xywh[4], xywh[3], 4*xywh[4]) -- xywh
end

function point_in_rectangle(point,xywh)
  return
    point[1]>=xywh[1] and
    point[1]<=(xywh[1]+xywh[3]) and
    point[2]>=xywh[2] and
    point[2]<=(xywh[2]+xywh[4])
end
