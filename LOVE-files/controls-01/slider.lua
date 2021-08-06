
function slider_value_update(slider,x,y)
  local slider_handle_width=50
  if love.mouse.isDown(1) and
    -- inside slider check
    x>=(slider[1]-slider_handle_width) and
      x<=(slider[1]+slider[3]+slider_handle_width) and
    y>=slider[2] and y<=(slider[2]+slider[4])
  then
    -- slider value
    slider[5] = (x-slider[1])/slider[3]
    -- clamp it [0..1]
    slider[5] = math.min(slider[5],1) -- max 1
    slider[5] = math.max(slider[5],0) -- min 0
  end
end

function slider_draw(slider)
  
  -- slider update
  local x=love.mouse.getX()
  local y=love.mouse.getY()
  slider_value_update(slider,x,y)
  
  -- slider draw
  local slider_handle_width=10
  -- background
  love.graphics.setColor(1,1,1) -- white bg
  love.graphics.rectangle("fill", slider[1], slider[2], slider[3]+slider_handle_width, slider[4]) -- xywh
  -- slider
  local slider_color=slider[6]
  love.graphics.setColor(slider_color[1],slider_color[2],slider_color[3]) -- colored slider
  local sliderx=slider[1]+slider[5]*slider[3]
	love.graphics.rectangle("fill", sliderx,slider[2], slider_handle_width,slider[4]) -- xywh
end
