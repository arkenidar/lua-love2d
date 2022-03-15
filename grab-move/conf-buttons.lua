
images={}
images.x = love.graphics.newImage("images/icon-x.png")
images.empty = love.graphics.newImage("images/check-empty.png")
images.filled = love.graphics.newImage("images/check-filled.png")

button_list={}

-- Configuration reload but preserve states
function conf_buttons_reload()
  
  -- save states ("backup table")
  local button_states={}
  for key,button in pairs(button_list) do      
    button_states[key]=button.state -- by key
  end
  
  local handles_backup_copy = handles
    
  -- reload from file
  love.filesystem.load("main.lua")()
  
  -- restore states
  for key,button in pairs(button_list) do
    -- only if key exists in "backup" table ...
    if button_states[key]~=nil then
      -- set state from "backup" table
      button.state=button_states[key]
    end -- endif
  end
  
  handles = handles_backup_copy
  
end

----

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
----------------------------
local quit={10,10, 100,100}
function quit.draw(button) image_draw(images.x,button) end
function quit.action() love.event.quit() end
---button_list.quit=quit
----------------------------

function toggle_draw(button)
  local state
  if button.state then state="filled" else state="empty" end
  image_draw(images[state],button)
end
function toggle_action(button) button.state=not button.state end

function draw_centered_text(rectX, rectY, rectWidth, rectHeight, text)
	local font       = love.graphics.getFont()
	local textWidth  = font:getWidth(text)
	local textHeight = font:getHeight()
	love.graphics.print(text, rectX+rectWidth/2, rectY+rectHeight/2, 0, 1, 1, textWidth/2, textHeight/2)
end
function draw_vertically_centered_text(text, rectX,rectY, rectWidth,rectHeight)
	local font       = love.graphics.getFont()
	---local textWidth  = font:getWidth(text)
	local textHeight = font:getHeight()
  
	love.graphics.print(text, rectX, rectY+rectHeight/2 -textHeight/2)
end

function toggle_label_draw(button)
  local xywh=button
  --rectangular(xywh,0,1,0)
  --love.graphics.print(button.text_label,xywh[1],xywh[2])
  draw_vertically_centered_text(button.text_label, xywh[1],xywh[2],xywh[3],xywh[4])
end
function toggle_label_action(button)
  -- clicking on the label triggers the linked button's action
  button_list[button.linked]:action()
end

space=10
size=50
toggle_1={space*2,space+size+space, size,size, draw=toggle_draw, action=toggle_action, state=true}
toggle_2={toggle_1[1],toggle_1[2]+toggle_1[4]+space, size,size, draw=toggle_draw, action=toggle_action, state=false}

toggle_1_label={toggle_1[1]+toggle_1[3],toggle_1[2], size*3,size, draw=toggle_label_draw, action=toggle_label_action, linked="toggle_1", text_label="toggle 1 text label @@@@"}

toggle_2_label={toggle_2[1]+toggle_2[3],toggle_2[2], size*3,size, draw=toggle_label_draw, action=toggle_label_action, linked="toggle_2", text_label="toggle 2 text label @@@@@@@@"}

function label_set_text_label(label,text)
	local font       = love.graphics.getFont()
	local textWidth  = font:getWidth(text)
  label[3] = textWidth
end
label_set_text_label(toggle_1_label,toggle_1_label.text_label)
label_set_text_label(toggle_2_label,toggle_2_label.text_label)
--[[
function label_text(label, new_text)
  if new_text~=nil then
    label.text_label = new_text
  end
  label_set_text_label(label, label.text_label)
end
toggle_1_label.text=label_text
toggle_2_label.text=label_text
toggle_1_label:text()
toggle_2_label:text()
--]]

---local shared_state1
function visible_tab_2()
  ---return shared_state1[1]=="exclusive2"
  return button_list.exclusive2.state
end

toggle_1.visible=visible_tab_2
toggle_2.visible=visible_tab_2
toggle_1_label.visible=visible_tab_2
toggle_2_label.visible=visible_tab_2

button_list.toggle_1=toggle_1
button_list.toggle_2=toggle_2
button_list.toggle_1_label=toggle_1_label
button_list.toggle_2_label=toggle_2_label

---[[
-- exclusive selection
function toggle_draw_exclusive(button)  
  local current
  ---current=button.id==button.state[1]
  current=button.state
  --[[
  local state
  if current then state="x" else state="empty" end
  image_draw(images[state],button)
  --]]
  local r,g,b
  if current then r,g,b=1,1,1 else r,g,b=0,0,0 end
  rectangular(button,r,g,b)
end
function toggle_action_exclusive(button)
  ---button.state[1]=button.id
  local group=button.mutex
  for _,name in pairs(group) do button_list[name].state=false end
  button.state=true
end

---shared_state1={}
local mutually_exclusive1={"exclusive1","exclusive2"}
exclusive1={toggle_1[1],10, 100,50, draw=toggle_draw_exclusive,action=toggle_action_exclusive,
  --state=false,
  mutex=mutually_exclusive1}
  ---state=shared_state1, id="exclusive1"}
exclusive2={exclusive1[1]+exclusive1[3]+10,10, exclusive1[3],exclusive1[4], draw=toggle_draw_exclusive,action=toggle_action_exclusive,
  --state=true,
  mutex=mutually_exclusive1}
  --state=shared_state1, id="exclusive2"}
---shared_state1[1]="exclusive2"
--]]
button_list.exclusive1=exclusive1
button_list.exclusive2=exclusive2
toggle_action_exclusive(exclusive2) -- settings

panel_background={toggle_1[1]-10,toggle_1[2]-10, 3*100,130}
function panel_background.draw(button)
  rectangular(button,0,0,0)
  ---draw_centered_text(button[1],button[2],button[3],button[4],"panel text")
end
function panel_background.action() end
button_list.panel_background=panel_background


panel_tab1={toggle_1[1]-10,toggle_1[2]-10, panel_background[3],panel_background[4]}
function panel_tab1.draw(button)
  ---rectangular(button,0,0,0)
  draw_centered_text(button[1],button[2],button[3],button[4],"panel text")
end
function panel_tab1.action() end
function visible_tab_1()
  return button_list.exclusive1.state
end
panel_tab1.visible=visible_tab_1
button_list.panel_tab1=panel_tab1


--button_list={quit=button_quit,toggle_1=button_toggle_1,toggle_2=button_toggle_2,live_added=button_live_added} -- toggle_2=button_toggle_2,
button_list_back_to_front={
panel_background,

exclusive1,exclusive2,

toggle_1,toggle_1_label,
toggle_2,toggle_2_label,

panel_tab1,

--quit
}
function draw_all_buttons()
  for key,button in ipairs(button_list_back_to_front) do
    if button.visible==nil or button.visible() then
      button_draw(button)
    end
  end
end
function action_all_buttons()
  for key,button in ipairs(button_list_back_to_front) do
    if button.visible==nil or button.visible() then
      button_action(button)
    end
  end
end
----------
function button_draw(button)
  -- WIP: button_action(button) was here
  button:draw()
end
-- WIP: button_action(button) was in button_draw()
function button_action(button)
  -- click just pressed (not before)
  if click_down==1 and
    -- check for mouse pointer being inside the rectagle
    point_in_rectangle(mouse_coordinates(),button)
  then
    button:action()
  end
end

-- draw image scaled and fitting rectangle
function image_draw(image,xywh)
  -- scale factors
  local sx=xywh[3]/image:getWidth()
  local sy=xywh[4]/image:getHeight()
  -- provide image, position, scale
  love.graphics.draw(image, xywh[1],xywh[2],0, sx,sy)
end
-------------
function love.keypressed(key)
  if key == "f5" then
    conf_buttons_reload()
  elseif key == "f6" then
    love.event.quit("restart")
  elseif key == "escape" then
    love.event.quit()
  end
end
