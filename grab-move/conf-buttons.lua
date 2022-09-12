
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

----------------------------
quit={10,10, 50,50} -- global variable not local (then exported from this file to "main.lua")
function quit.draw(button)
  love.graphics.setColor(1,1,1) -- reset color (white)
  image_draw(images.x,button)
end
function quit.action()
  love.event.quit()
end
button_list.quit=quit
----------------------------

function toggle_draw(button)
  love.graphics.setColor(0,0,0)
  
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
  love.graphics.setColor(0,0,0)
   
  local xywh=button
  --rectangular(xywh,0,1,0) -- prototype remnants, TODO: remove
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
--[[ -- excessive engineering here, so I kept it basic
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

-- TODO visibles (visible items) can be grouped (show/hide groups of visibles e.g. for tabbed view)
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
  if current then r,g,b=1,0,0 else r,g,b=0.5,0.5,0.5 end -- current? red else grey
  rectangular(button,r,g,b) -- draw "exclusive-selection button"
end
function toggle_action_exclusive(button)
  ---button.state[1]=button.id
  local group=button.mutex -- mutex (mutually exclusive selection, mut.ex.)
  for _,name in pairs(group) do button_list[name].state=false end
  button.state=true
end

---shared_state1={} -- TODO remove remnants of previous implementation. kept for historical reference
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
toggle_action_exclusive(exclusive1) -- settings -- was: exclusive2 (when I focused there)

panel_background={toggle_1[1]-10,toggle_1[2]-10, 3*100,130}
function panel_background.draw(button)
  rectangular(button,0,1,0) -- TODO color settings (was: green)
  ---draw_centered_text(button[1],button[2],button[3],button[4],"panel text")
end
function panel_background.action() end
button_list.panel_background=panel_background


panel_tab1={toggle_1[1]-10,toggle_1[2]-10, panel_background[3],panel_background[4]}
panel_tab1.draggable={tx=0,ty=0}
function panel_tab1.draw(button)
  local draggable=panel_tab1.draggable
  love.graphics.push() -- geometric transforms stack push
  love.graphics.translate(draggable.tx, draggable.ty)
  
  ---rectangular(button,0,0,0) -- prototyping
  ---draw_centered_text(button[1],button[2],button[3],button[4],"panel text (tab1, scissored and draggable!)")
  
  -- TODO draw image (with clipping i.e. love.graphics.setScissor)
  local border_size = 5 -- settings
  love.graphics.setScissor( -- scissors enabled and configured
    -- this is reliable, not below
  button[1]+border_size,
  button[2]+border_size,
  button[3]-border_size*2,
  button[4]-border_size*2
  )
  
  love.graphics.setColor(0,0,0) -- black color
  draw_centered_text(button[1],button[2],button[3],button[4],"panel text (tab1, scissored and draggable!)")
  
  -- draw image that is visually clipped by button region (panel button in this case)
  
  local text_string="A****************************************************************************************************Z"
  local border=5
  -- draw rectangle (x,y,width,height)
  local image_button
  local width,height
  local x,y=button[1]+30,button[2]+80
  width=200 -- some chosen width
  
  local wrap_limit=width-2*border
  local font=love.graphics.getFont()
  local wrapped_width,wrapped_text=font:getWrap(text_string, wrap_limit)
  -- calculated height
  height=2*border+font:getHeight()*#wrapped_text
  
  -- rectangle (xywh)
  image_button={x,y,width,height}
  --- first draw rectangular background for text
  rectangular(image_button,0,1,1) -- color settings (currently: green-blue)
  --- then draw text on rectangular background
  -- draw text_string inside rectangular drawing (with borders, and wraplimit)
  love.graphics.printf(text_string,x+border,y+border,wrap_limit)
  
  ----------------------------------
  -- TODO: investigate panel_background's kind of unreliable positioning
  -- ... falling back to: love.graphics.rectangle() and image_draw() (see below)
  local padding = 5
  local xywh = { -- panel_background
    button[1]+padding,
    button[2]+padding,
    button[3]-padding*2,
    button[4]-padding*2,
  }
  -- xywh=button -- DEBUG
  --love.graphics.setColor(1,0,0) -- red color (debug color)
  -- xywh (area border) -- TODO copied from: "rectangular(xywh,r,g,b)"
  ---love.graphics.rectangle("fill", xywh[1], xywh[2], xywh[3], xywh[4]) -- xywh
  
  -- TODO scissors above not here
  ----love.graphics.setScissor( -- scissors enabled
  ----xywh[1],xywh[2],xywh[3],xywh[4]) -- scissors configured
 
  -- @ draw inside scissored region (bottom-right)
  ----love.graphics.rectangle("fill",xywh[1]+30,xywh[2]+80,xywh[3],xywh[4])
  ----image_draw(images.x, {xywh[1]+30,xywh[2]+80,xywh[3],xywh[4]} )
  
  -- @ draw inside scissored region (top-left)
  ---love.graphics.rectangle("fill",xywh[1]-30,xywh[2]-80,xywh[3],xywh[4])
  image_draw(images.x, {xywh[1]-30,xywh[2]-80,xywh[3],xywh[4]} )
--rectangular({button[1]-30,button[2]-80,button[3],button[4]},0,1,1) -- TODO

  -- scissors disabled
  love.graphics.setScissor()
  
  love.graphics.pop() -- pop from geometric transforms stack
end

panel_tab1.act=true -- used in function button_action(button)
function panel_tab1.action(obj)
  if on_top and obj.on_top then
    obj:on_top() -- action only if on_top
  end
end
function panel_tab1.on_top(obj)
  local draggable=obj.draggable
  local mx = love.mouse.getX()
  local my = love.mouse.getY()
  if love.mouse.isDown(1) and
    -- panel_tab1 is draggable
    point_in_rectangle({mx,my},obj)
  then
    if not draggable.mouse_pressed then
      draggable.mouse_pressed = true
      draggable.dx = draggable.tx-mx
      draggable.dy = draggable.ty-my
    else
      draggable.tx = mx+draggable.dx
      draggable.ty = my+draggable.dy
    end
  elseif draggable.mouse_pressed then
    draggable.mouse_pressed = false
  end
end
function visible_tab_1()
  return button_list.exclusive1.state
end
panel_tab1.visible=visible_tab_1
button_list.panel_tab1=panel_tab1

-- TODO "live_added"
--button_list={quit=button_quit,toggle_1=button_toggle_1,toggle_2=button_toggle_2,live_added=button_live_added} -- toggle_2=button_toggle_2,
button_list_back_to_front={

exclusive1,exclusive2, -- tabs

panel_background, -- tabs area

-- clip begin
--- add button action to clip (really?) TODO decide

panel_tab1, -- tab1

-- tab2
toggle_1,toggle_1_label,
toggle_2,toggle_2_label,

-- clip end
--- add button action to un-clip

--quit, -- TODO remove?

}

function draw_all_buttons()
  for key,button in ipairs(button_list_back_to_front) do
    if button.visible==nil or button.visible() then
      button_draw(button)
    end
  end
  ---button_draw(quit) -- always draw on top of the rest (the previous)
end
function action_all_buttons()
  for key,button in ipairs(button_list_back_to_front) do
    if button.visible==nil or button.visible() then
      button_action(button)
    end
  end
  ---button_action(quit) -- always draw on top of the rest (the previous)
end
----------
function button_draw(button)
  -- WIP: button_action(button) was here
  button:draw()
end
-- WIP: button_action(button) was in button_draw()
function button_action(button)
  -- click just pressed (not before)
  if button.act or
    (
    click_down==1 and
    -- check for mouse pointer being inside the rectagle
    point_in_rectangle(mouse_coordinates(),button)
    )
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
