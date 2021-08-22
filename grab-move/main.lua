handles={}
handles[1]={50,50,500,50} -- xywh
handles[2]={100,100+20,500,50} -- xywh

function rectangular(xywh,r,g,b)
  love.graphics.setColor(1,1,1) -- white color (border color)
  -- xywh (area border)
  love.graphics.rectangle("fill", xywh[1], xywh[2], xywh[3], xywh[4]) -- xywh

  local border=5
  love.graphics.setColor(r,g,b) -- selected color (inner color)
  -- xywh (inner area inside the border)
  love.graphics.rectangle("fill", xywh[1]+border, xywh[2]+border, xywh[3]-border*2, xywh[4]-border*2)
  
  -- reset
  love.graphics.setColor(1,1,1) -- reset to white
end
---
function handle_area_action(handle)
  local continue --- =true
  
  local xywh=handle
  local mouse=mouse_coordinates()
  if click_down==1 -- mouse just clicked
  and point_in_rectangle(mouse,xywh) -- if inside
  then
    -- grab
    xywh.mouse_grab_offset={mouse[1]-xywh[1],mouse[2]-xywh[2]}
    continue=false -- grab only one, stop propagation
  else
    continue=true
  end
  
  if xywh.mouse_grab_offset~=nil then -- if grabbed
    xywh[1]=mouse[1]-xywh.mouse_grab_offset[1]
    xywh[2]=mouse[2]-xywh.mouse_grab_offset[2]
  end
  
  if not love.mouse.isDown(1) then -- mouse up
    xywh.mouse_grab_offset=nil -- un-grab
  end
  
  
  --love.graphics.setColor(0,0,1) -- blue color
  if xywh.mouse_grab_offset~=nil then
    --love.graphics.setColor(1,0,0) -- red color (grabbed)
    
    -- when grabbed:
    -- bring to front (back-to-front drawing order)
    -- remove it (copy Lua table without it)
    local handles_new={}
    for _,value in pairs(handles) do
      if value~=handle then -- without it
        table.insert(handles_new,value) -- copy
      end
    end
    -- insert at the end
    table.insert(handles_new,handle)
    handles=handles_new
    -- end of: bring to front
  end -- end of if


  --------- begin delete button
  local button_delete={xywh[1]+(xywh[3]-xywh[4]),xywh[2], xywh[4],xywh[4]}
  
  function button_delete.draw(button)
    love.graphics.setColor(0,1,0) -- green color
    local xywh=button
    love.graphics.rectangle("fill", xywh[1], xywh[2], xywh[3], xywh[4]) -- xywh (button)
  end
  
  function button_delete.action(button)
    -- click just pressed
    if click_down==1 and
      -- check for mouse pointer being inside the rectagle
      point_in_rectangle(mouse_coordinates(),button)
    then
      
      -- remove it (copy Lua table without it)
      local handles_new={}
      for _,value in pairs(handles) do
        if value~=handle then -- without it
          table.insert(handles_new,value) -- copy
        end
      end
      handles=handles_new
      
    end -- end if
  end -- end function
  handle.button_delete=button_delete
  ------------ end button_delete
  
  handle.button_delete:action()
  
  local area= {xywh[1], xywh[2]+xywh[4], xywh[3], 4*xywh[4]}
   
  -- click just pressed
  if click_down==1 and
    -- check for mouse pointer being inside the rectagle
    point_in_rectangle(mouse_coordinates(),area)
  then
    continue=false
  end

  return continue -- continue (propagate) or not?
end
function handle_area_draw(handle)
  local xywh=handle
  ----------
  love.graphics.setColor(0,0,1) -- blue color
  if xywh.mouse_grab_offset~=nil then
    love.graphics.setColor(1,0,0) -- red color (grabbed)
  end
  love.graphics.rectangle("fill", xywh[1], xywh[2], xywh[3]-xywh[4], xywh[4]) -- xywh (handle)
  
  -- button_delete
  handle.button_delete:draw()
  
  -- TODO draw rectangle with border rectangular(xywh,r,g,b)
  --rectangular(xywh,1,1,1)
  ---[[
  love.graphics.setColor(0.5,0.5,0.5) -- grey color
  love.graphics.rectangle("fill", xywh[1], xywh[2]+xywh[4], xywh[3], 4*xywh[4]) -- xywh (area border)

  love.graphics.setColor(1,1,1) -- white color
  love.graphics.rectangle("fill", xywh[1]+10, xywh[2]+xywh[4]+10, xywh[3]-20, 4*xywh[4]-20) -- xywh (area)
  --]]
end

-- methods
for _,handle in pairs(handles) do
  handle.draw=handle_area_draw
  handle.action=handle_area_action
end
---
function point_in_rectangle(point,xywh)
  return
    point[1]>=xywh[1] and
    point[1]<=(xywh[1]+xywh[3]) and
    point[2]>=xywh[2] and
    point[2]<=(xywh[2]+xywh[4])
end
function mouse_coordinates()
  return {love.mouse.getX(),love.mouse.getY()}
end
------------------------------------------
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
------------------------------------------
function love.draw()
  
  -- input: click_get_input()
  click_get_input()
  
  local items=handles
  -- input: front to back order
  for i = #items,1,-1 do
    local continue
    continue=items[i]:action()
    if not continue then break end
  end

  -- drawing: back to front order
  for i = 1,#items,1 do
    items[i]:draw()
  end
  
end
