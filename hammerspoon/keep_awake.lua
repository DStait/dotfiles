function kill_caffeine()
  local app_name = "caffeinate"
  local x = io.popen("killall " .. app_name)
end

function keepAwake()
  local ka_debug = false
  if ka_debug then print("!!! keep_awake running in debug mode !!!") end

  -- Check if Caffeine is running
  local app_name = "caffeinate"
  local cmd="ps aux | grep -v grep | grep -v Z | grep " .. app_name
  local handle = io.popen(cmd)
  local result = handle:read("*a")
  handle:close()

  if string.find(result, app_name) then
    caffeine_active = true
  else
    caffeine_active = false
  end


  local time_830am = 30600
  local time_9am = 32400
  local time_6pm = 64800
  cur_time = hs.timer.localTime()
  if ka_debug then print("CURRENT TIME: " .. cur_time) end
  if (cur_time > time_830am and cur_time < time_6pm) then
    -- Start caffeine if it is not running already
    if caffeine_active then
      if ka_debug then print(app_name .. " already active") end
      return
    else
      if ka_debug then  print(app_name .. " not active, starting..") end
      c = io.popen(app_name .. " -dimsu")
    end
  elseif not caffeine_active then
    if ka_debug then  print("Nothing to do") end
    return
  else
    -- Kill caffeine if it is running
    if ka_debug then  print("Out of working hours, killing " .. app_name) end
    local x = io.popen("killall " .. app_name)
  end

end

print("Loaded keep_awake")
keepAwakeTimer = hs.timer.doEvery(180, keepAwake)
