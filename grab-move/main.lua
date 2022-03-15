
-- debugging support (/pkulchenko/MobDebug setup, works also in ZeroBrane Studio)

-- https://github.com/pkulchenko/MobDebug/blob/master/examples/start.lua
-- https://raw.githubusercontent.com/pkulchenko/MobDebug/master/src/mobdebug.lua

-- don't activate debugging if not specified this way
if arg[#arg]=="-debug" then
  -- activate debugging
  require("mobdebug").start()
end

-- conf-buttons.lua file
require("conf-buttons")

handles={}
handles[1]={50,50,500,50} -- xywh
handles[2]={100,100+20,500,60} -- xywh

inner={nil,nil, 100,100, offset={20,70}, super=handles[2]}
function inner.draw(item)
  local xywh=item
  xywh[1]=item.offset[1]+item.super[1]
  xywh[2]=item.offset[2]+item.super[2]
  --[[
  love.graphics.setColor(1,0,0)
  love.graphics.rectangle("fill", xywh[1], xywh[2], xywh[3], xywh[4])
  love.graphics.setColor(1,1,1)
  --]]
  
  -- position them (layouting)
  local space=10
  local size=50
  
  exclusive1[1]=xywh[1]
  exclusive1[2]=xywh[2]+space
  exclusive2[1]=exclusive1[1]+space+exclusive1[3]
  exclusive2[2]=exclusive1[2]
  
  panel_background[1]=exclusive1[1]
  panel_background[2]=exclusive1[2]+exclusive1[4]
  
  toggle_1[1]=panel_background[1]+space
  toggle_1[2]=panel_background[2]+space
  toggle_2[1]=toggle_1[1]
  toggle_2[2]=toggle_1[2]+toggle_1[4]+space
  toggle_1_label[1]=toggle_1[1]+toggle_1[3]
  toggle_1_label[2]=toggle_1[2]
  toggle_2_label[1]=toggle_2[1]+toggle_2[3]
  toggle_2_label[2]=toggle_2[2]
  
  panel_tab1[1]=panel_background[1]
  panel_tab1[2]=panel_background[2]
  
  -- draw them
  draw_all_buttons()
end
function inner.action(item)
  --draw_all_buttons() WIP
  action_all_buttons()
end
handles[2].sub={inner}

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
    local xywh=button
    --love.graphics.setColor(0,1,0) -- green color
    love.graphics.rectangle("fill", xywh[1], xywh[2], xywh[3], xywh[4]) -- xywh (button)
    image_draw(images.x,xywh)
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
  
  -- action() of inner items (TODO WIP)
  local items=handle.sub
  if items==nil then items={} end
  for _,item in pairs(items) do
    item:action()
    
  end
  
  local area= {xywh[1], xywh[2]+xywh[4], xywh[3], 4*xywh[4]} -- TODO custom area size
  handle.area = area
  
  -- click just pressed
  if click_down==1 and
    -- check for mouse pointer being inside the rectagle
    point_in_rectangle(mouse_coordinates(),area)
  then
    continue=false
    
    ---[[ bring to front (back-to-front drawing order)
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
    --]]
  end

  return continue -- continue (propagate) or not?
end -- end function handle_area_action()
function handle_area_draw(handle)
  local xywh=handle
  local area = handle.area
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
  love.graphics.rectangle("fill", xywh[1], xywh[2]+xywh[4], xywh[3], area[4]) -- xywh (area border)

  love.graphics.setColor(0,0,0) -- black color
  love.graphics.rectangle("fill", xywh[1]+10, xywh[2]+xywh[4]+10, xywh[3]-20, area[4]-20) -- xywh (area)
  --]]
  
  -- draw inner items (TODO WIP)
  local items=handle.sub
  if items==nil then items={} end
  for _,item in pairs(items) do
    item:draw()
    
  end
  
  -- WIP TODO
  ---handle1[1]
  --draw_all_buttons()
  
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
  local continue
  for i = #items,1,-1 do
    continue=items[i]:action()
    if not continue then break end
  end
  -- when/event: "click on the background"
  if continue and click_down==1 then
    -- reload the app (some app state is kept)
    conf_buttons_reload()
  end

  -- drawing: back to front order
  for i = 1,#items,1 do
    items[i]:draw()
  end
  
  -- TODO WIP
  ---draw_all_buttons()
end
