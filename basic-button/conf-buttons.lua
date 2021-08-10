
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
    button_states[key]=button[7] -- by key
  end
  -- reload from file
  love.filesystem.load("conf-buttons.lua")()
  -- restore states
  for key,button in pairs(button_list) do
    -- only if key exists in "backup" table ...
    if button_states[key]~=nil then
      -- set state from "backup" table
      button[7]=button_states[key]
    end -- endif
  end
end

button_list.quit={10,10, 100,100,
  function (button) image_draw(images.x,button) end,
  function() love.event.quit() end}

function toggle_draw(button)
  local state
  if button[7] then state="filled" else state="empty" end
  image_draw(images[state],button)
end
function toggle_action(button) button[7]=not button[7] end
button_list.toggle_1={10+100+10,10, 50,50, toggle_draw, toggle_action, true}
button_list.toggle_2={10+100+10,10+50+10, 50,50, toggle_draw, toggle_action, false}

---[[
-- exclusive selection
function toggle_draw_exclusive(button)  
  local current
  current=button.id==button[7][1]
  ---current=button[7]
  local state
  if current then state="x" else state="empty" end
  image_draw(images[state],button)
end
function toggle_action_exclusive(button)
  button[7][1]=button.id
  --local group=button.mutex
  --for _,name in pairs(group) do button_list[name][7]=false end
  --button[7]=true
end

local shared_state1={}
---local mutually_exclusive1={"exclusive1","exclusive2"}
button_list.exclusive1={200,10, 50,50, toggle_draw_exclusive,toggle_action_exclusive,
  ---false,mutex=mutually_exclusive1}
  shared_state1, id="exclusive1"}
button_list.exclusive2={200+50+10,10, 50,50, toggle_draw_exclusive,toggle_action_exclusive,
  ---true,mutex=mutually_exclusive1}
  shared_state1, id="exclusive2"}
shared_state1[1]="exclusive2"
--]]

--button_list={quit=button_quit,toggle_1=button_toggle_1,toggle_2=button_toggle_2,live_added=button_live_added} -- toggle_2=button_toggle_2,
function draw_all_buttons()
  for key,button in pairs(button_list) do
    button_draw(button)
  end
end
