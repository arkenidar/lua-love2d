local width=25
local height=25
--xywh1={50,50,width,height}
--xywh2={150+10,50,width,height}
--[[
local x1=150
local y1=80
local x2=50
local y2=200
--]]
xywh1={150,80,width,height}
xywh2={50,200,width,height}
handles={xywh1,xywh2,{250+20,50,width,height}}

function positioning_increments(items,dx,dy)
  local x,y=items[1][1],items[1][2]
  for _,item in pairs(items) do
    item[1]=x
    item[2]=y
    x=x+dx
    y=y+dy
  end
end
--positioning_increments(handles,30,10)

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
  local r,g,b=1,1,1 -- white color
  --love.graphics.setColor(r,g,b)
  ---[[
  if xywh.mouse_grab_offset~=nil then -- if grabbed
    --love.graphics.setColor(1,0,0) -- red color
    r,g,b=1,0,0 -- red color
  end
  --]]
  
  --love.graphics.rectangle("fill", xywh[1], xywh[2], xywh[3], xywh[4]) -- xywh
  
  love.graphics.setColor(0.2,0.2,0.2) -- grey color (border color)
  -- xywh (area border)
  love.graphics.rectangle("fill", xywh[1], xywh[2], xywh[3], xywh[4])

  local border=5
  love.graphics.setColor(r,g,b) -- selected color (inner color)
  -- xywh (inner area inside the border)
  love.graphics.rectangle("fill", xywh[1]+border, xywh[2]+border, xywh[3]-border*2, xywh[4]-border*2)
end

------------------------------------------

function distance(x1,y1,x2,y2)
return math.sqrt((x2-x1)*(x2-x1)+(y2-y1)*(y2-y1))
end


function draw_formula()
love.graphics.setColor(0,.7,0)
--[[
local x1=150
local y1=80
local x2=50
local y2=200
--]]
local x1=xywh1[1]+xywh1[3]/2
local y1=xywh1[2]+xywh1[4]/2
local x2=xywh2[1]+xywh1[3]/2
local y2=xywh2[2]+xywh1[4]/2

  for x=0,1000 do
    for y=0,1000 do
      -- ellipse definition
      if (
      distance(x,y,x1,y1)+
      distance(x,y,x2,y2))<300 then
        love.graphics.points({ {x,y} })
      end
    end
  end

end

------------------------------------------

function love.draw()

  -- input: front to back order
  for i = #handles,1,-1 do
    handle_grab(handles[i])
  end

  -- drawing: background
  draw_formula()

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
