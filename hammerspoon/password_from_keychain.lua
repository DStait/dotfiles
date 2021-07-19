-----------------------------------------------------------------------------------------
--
-- Get password from MacOS keychain and paste it using security command
--
-----------------------------------------------------------------------------------------

-- read a password from a keychain
function get_item_from_keychain(name)
  -- 'name' should be saved in the login keychain
  local cmd="/usr/bin/security find-generic-password -w -s " .. name
  local handle = io.popen(cmd)
  local result = handle:read("*a")
  handle:close()
  return (result:sub(1, #string - 1))
end

-- read a item seed from keychain, generate a code and make keystrokes for it
function paste_keychain_item(item_name)
  local item = get_item_from_keychain(item_name)

  -- generate keystrokes for the result
  hs.eventtap.keyStrokes(item)
end


-----------------------------------------------------------------------------------------
--
-- Get password using sec script and paste it.
--
-----------------------------------------------------------------------------------------

function get_pass_from_sec(name)
  local cmd="~/bin/sec get " .. name
  local handle = io.popen(cmd)
  local result = handle:read("*a")
  handle:close()
  return (result:sub(1, #string - 1))
end

function paste_sec_item(item_name)
  local item = get_pass_from_sec(item_name)

  -- generate keystrokes for the result
  hs.eventtap.keyStrokes(item)
end

-----------------------------------------------------------------------------------------

