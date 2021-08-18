
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
  -- reload from file
  love.filesystem.load("conf-buttons.lua")()
  -- restore states
  for key,button in pairs(button_list) do
    -- only if key exists in "backup" table ...
    if button_states[key]~=nil then
      -- set state from "backup" table
      button.state=button_states[key]
    end -- endif
  end
end

local quit={10,10, 100,100}
function quit.draw(button) image_draw(images.x,button) end
function quit.action() love.event.quit() end
button_list.quit=quit

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
function toggle_label_draw(button)
  local xywh=button
  --[[
  local r,g,b=0,1,0
  love.graphics.setColor(0.2,0.2,0.2) -- grey color (border color)
  -- xywh (area border)
  love.graphics.rectangle("fill", xywh[1], xywh[2], xywh[3], xywh[4])

  love.graphics.rectangle("fill", xywh[1], xywh[2], xywh[3], xywh[4]) -- xywh
  local border=5
  love.graphics.setColor(r,g,b) -- selected color (inner color)
  -- xywh (inner area inside the border)
  love.graphics.rectangle("fill", xywh[1]+border, xywh[2]+border, xywh[3]-border*2, xywh[4]-border*2)
  -- reset
  love.graphics.setColor(1,1,1) -- reset to white
  --]]
  --love.graphics.print("text",xywh[1],xywh[2])
  draw_centered_text(xywh[1],xywh[2],xywh[3],xywh[4], button.text_label)
end
function toggle_label_action(button)
  -- clicking on the label triggers the linked button's action
  button_list[button.linked]:action()
end

space=10
size=50
toggle_1={space+100+space,space+size+space, size,size, draw=toggle_draw, action=toggle_action, state=true}
toggle_2={toggle_1[1],toggle_1[2]+toggle_1[4]+space, size,size, draw=toggle_draw, action=toggle_action, state=false}

toggle_1_label={toggle_1[1]+toggle_1[3],toggle_1[2], size*3,size, draw=toggle_label_draw, action=toggle_label_action, linked="toggle_1", text_label="toggle 1 text label"}

toggle_2_label={toggle_2[1]+toggle_2[3],toggle_2[2], size*3,size, draw=toggle_label_draw, action=toggle_label_action, linked="toggle_2", text_label="toggle 2 text label"}

local shared_state1
function visible_tab()
  return shared_state1[1]=="exclusive2"
end

toggle_1.visible=visible_tab
toggle_2.visible=visible_tab
toggle_1_label.visible=visible_tab
toggle_2_label.visible=visible_tab

button_list.toggle_1=toggle_1
button_list.toggle_2=toggle_2
button_list.toggle_1_label=toggle_1_label
button_list.toggle_2_label=toggle_2_label

---[[
-- exclusive selection
function toggle_draw_exclusive(button)  
  local current
  current=button.id==button.state[1]
  ---current=button.state
  local state
  if current then state="x" else state="empty" end
  image_draw(images[state],button)
end
function toggle_action_exclusive(button)
  button.state[1]=button.id
  --local group=button.mutex
  --for _,name in pairs(group) do button_list[name].state=false end
  --button.state=true
end

shared_state1={}
---local mutually_exclusive1={"exclusive1","exclusive2"}
button_list.exclusive1={200,10, 50,50, draw=toggle_draw_exclusive,action=toggle_action_exclusive,
  ---state=false,mutex=mutually_exclusive1}
  state=shared_state1, id="exclusive1"}
button_list.exclusive2={200+50+10,10, 50,50, draw=toggle_draw_exclusive,action=toggle_action_exclusive,
  ---state=true,mutex=mutually_exclusive1}
  state=shared_state1, id="exclusive2"}
shared_state1[1]="exclusive2"
--]]

--button_list={quit=button_quit,toggle_1=button_toggle_1,toggle_2=button_toggle_2,live_added=button_live_added} -- toggle_2=button_toggle_2,
function draw_all_buttons()
  for key,button in pairs(button_list) do
    if button.visible==nil or button.visible() then
      button_draw(button)
    end
  end
end
