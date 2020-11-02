function move(dir)
    return function()
        local win = hs.window.focusedWindow()
        local frame = win:frame()
        local screenFrame = win:screen():frame()
        frame = win:screen():absoluteToLocal(frame)
        screenFrame = win:screen():absoluteToLocal(screenFrame)
        local x = frame.x
        local y = frame.y
        local w = frame.w
        local h = frame.h
  
        if dir == 'right' then
            if x < 0 then -- negative left
                frame.x = 0
            elseif x == 0 then -- attach to left
                if w < screenFrame.w * 1 / 4 then -- win width less than 25%
                    frame.w = screenFrame.w * 1 / 4
                elseif w < math.floor(screenFrame.w * 1 / 3) then -- win with less than 33%
                    frame.w = math.floor(screenFrame.w * 1 / 3)
                elseif w < screenFrame.w * 1 / 2 then -- win width less than 50%
                    frame.w = screenFrame.w * 1 / 2
                elseif w < screenFrame.w * 3 / 4 then -- win with less than 75%
                    frame.w = screenFrame.w * 3 / 4
                else
                    frame.x = screenFrame.w * 1 / 4
                    frame.w = screenFrame.w * 3 / 4
                end
            elseif x < screenFrame.w / 2 then -- win on the left side
                frame.x = screenFrame.w / 2
                frame.w = screenFrame.w / 2
            elseif x >= screenFrame.w / 2 and x < math.floor(screenFrame.w * 2 / 3) then -- win left edge in 50% - 66%
                frame.x = math.floor(screenFrame.w * 2 / 3)
                frame.w = math.floor(screenFrame.w * 1 / 3)
            elseif x >= math.floor(screenFrame.w * 2 / 3) and x < screenFrame.w * 3 / 4 then -- win left edge in 66% - 75%
                frame.x = screenFrame.w * 3 / 4
                frame.w = screenFrame.w * 1 / 4
            end
        elseif dir == 'left' then
            if x + w > screenFrame.w  then -- negative right
                frame.x = screenFrame.w - w
            elseif x + w == screenFrame.w then -- attach to right
                if w < screenFrame.w * 1 / 4 then -- win width less than 25%
                    frame.w = screenFrame.w * 1 / 4
                    frame.x = screenFrame.w - frame.w
                elseif w < math.floor(screenFrame.w * 1 / 3) then -- win with less than 33%
                    frame.w = math.floor(screenFrame.w * 1 / 3)
                    frame.x = screenFrame.w - frame.w
                elseif w < screenFrame.w * 1 / 2 then -- win width less than 50%
                    frame.w = screenFrame.w * 1 / 2
                    frame.x = screenFrame.w - frame.w
                elseif w < screenFrame.w * 3 / 4 then -- win with less than 75%
                    frame.w = screenFrame.w * 3 / 4
                    frame.x = screenFrame.w - frame.w
                else
                    frame.x = 0
                    frame.w = screenFrame.w * 3 / 4
                end
            elseif x > screenFrame.w / 2 then -- win on the right side
                frame.x = 0
                frame.w = screenFrame.w / 2
            elseif x > 0 then -- win on left side
                frame.x = 0
            elseif w > screenFrame.w / 2 then -- win larger than 50%
                frame.w = screenFrame.w * 1 / 2
            elseif w > math.floor(screenFrame.w * 1 / 3) then -- win larger than 33%
                frame.w = math.floor(screenFrame.w * 1 / 3)
            elseif w > screenFrame.w * 1 / 4 then -- win larger than 25%
                frame.w = screenFrame.w * 1 / 4
            end
        elseif dir == 'up' then
            if y == screenFrame.y then -- attach to top
                if h >= screenFrame.h / 2 then
                    frame.h = screenFrame.h / 2
                end
            elseif y + h == screenFrame.h + screenFrame.y then -- attach to bottom
                frame.y = 0
                frame.h = screenFrame.h
            else
                frame.y = 0
            end
        elseif dir == 'down' then
            if y + h == screenFrame.h + screenFrame.y then -- attach to bottom
                if h >= screenFrame.h / 2 then
                    frame.h = screenFrame.h / 2
                    frame.y = screenFrame.h - frame.h + screenFrame.y
                end
            elseif y == screenFrame.y then -- attach to top
                frame.y = 0
                frame.h = screenFrame.h
            elseif y + h > screenFrame.h then -- overflow bottom do nothing
            else
                frame.y = screenFrame.h - h + 22
            end
        end
  
        frame = win:screen():localToAbsolute(frame)
        win:setFrame(frame)
    end
  end
  
  function send_window_prev_monitor()
  local win = hs.window.focusedWindow()
  local nextScreen = win:screen():previous()
  win:moveToScreen(nextScreen)
  end
  
  function send_window_next_monitor()
  local win = hs.window.focusedWindow()
  local nextScreen = win:screen():next()
  win:moveToScreen(nextScreen)
  end