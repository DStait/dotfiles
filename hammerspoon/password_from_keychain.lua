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

