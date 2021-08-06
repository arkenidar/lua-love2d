
images={}
images.x = love.graphics.newImage("images/icon-x.png")
images.empty = love.graphics.newImage("images/check-empty.png")
images.filled = love.graphics.newImage("images/check-filled.png")

button_list={}

-- Configuration reload but preserve states
function conf_buttons_reload()
  -- save states
  local button_states={}
  for key,button in pairs(button_list) do      
    button_states[key]=button[7]
  end
  -- reload from file
  love.filesystem.load("conf-buttons.lua")()
  -- restore states
  for key,button in pairs(button_list) do
    button_list[key][7]=button_states[key]
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

button_list.live_added={200,10, 50,50, toggle_draw,toggle_action, true}

--button_list={quit=button_quit,toggle_1=button_toggle_1,toggle_2=button_toggle_2,live_added=button_live_added} -- toggle_2=button_toggle_2,
function draw_all_buttons()
  for key,button in pairs(button_list) do
    button_draw(button)
  end
end
