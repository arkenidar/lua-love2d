-- sliders (slider controls)
require("slider")
local sliders={
  --        x,y     width,height  value color
  red =    {50,100, 100,50,       0.75, {1,0,0}},
  green =  {50,160, 100,50,       0.75, {0,1,0}},
  blue =   {50,220, 100,50,       0.75, {0,0,1}},
}
function love.draw()  
  slider_draw(sliders.red)
  slider_draw(sliders.green)
  slider_draw(sliders.blue)
    
  -- item colored with given values
  local item_color = {sliders.red[5],sliders.green[5],sliders.blue[5]}
  love.graphics.setColor(item_color[1],item_color[2],item_color[3]) -- colored item
  love.graphics.rectangle("fill", 10,10, 50,50) -- xywh
end