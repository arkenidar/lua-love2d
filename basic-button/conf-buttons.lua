
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
button_list.toggle_1={10+100+10,10, 50,50, draw=toggle_draw, action=toggle_action, state=true}
button_list.toggle_2={10+100+10,10+50+10, 50,50, draw=toggle_draw, action=toggle_action, state=false}

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

local shared_state1={}
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
    button_draw(button)
  end
end
