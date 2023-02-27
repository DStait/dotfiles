-- Spoons
-- hs.loadSpoon('Shade')

require "lua_functions"
require "password_from_keychain"
require "chrome_active_tab_with_name"
require "open_app"
-- require 'movement_timer'
if file_exists('pagerduty_credentials.lua') then require 'pagerduty' end
-- Dummy file, for username as personal machines use a different username
if file_exists('/Users/dominicstait/.DS_Store') then require 'keep_awake' end
-- Secrets that are kept outside of git
if file_exists('secrets.lua') then require 'secrets' end

require 'ethernet_menu'
local am = require('app-management')
--
-- Load and install the Hyper key extension. Binding to F18
local hyper = require('hyper')
hyper.install('F18')

require "window_management"
require "window_keybinding"

hs.hotkey.bind({"command", "shift"}, "w", function()
    hs.eventtap.keyStrokes(WORK_EMAIL)
end)

hs.hotkey.bind({"cmd", "shift"}, "v", function()
  hs.eventtap.keyStrokes(hs.pasteboard.getContents())
end)

-- Quick Reloading of Hammerspoon
hyper.bindKey('r', function()
    hs.alert.show("Hammerspoon reloading")
    kill_caffeine()
    hs.timer.doAfter(0.5, hs.reload)
end)

-- Global Application Keyboard Shortcuts
hyper.bindShiftKey('p', function()
    hs.spotify.displayCurrentTrack()
end)

-- Open tot
hyper.bindKey('/', function() hs.eventtap.keyStroke({"ctrl", "alt", "cmd"}, "s") end)

-- Show the bundleID of the currently open window
hyper.bindCommandShiftKey('b', function() 
    local bundleId = hs.window.focusedWindow():application():bundleID()
    hs.alert.show(bundleId)
    hs.pasteboard.setContents(bundleId)
end)

local app_terminal = "org.alacritty"
local app_editor = "com.microsoft.VSCode"
local app_music = "com.spotify.client"
local app_browser = "org.mozilla.firefox"
local app_email = "com.microsoft.Outlook"
local app_messenger = "com.tinyspeck.slackmacgap"
local app_meetings = "com.microsoft.teams"
local app_notes = "com.microsoft.onenote.mac"

-- Switch to and From App
hyper.bindKey(']', function() am.switchToAndFromApp(app_terminal) end)
hyper.bindKey('[', function() am.switchToAndFromApp(app_editor) end)
hyper.bindKey('p', function() am.switchToAndHideApp(app_music) end)


hyper.bindKey('q', function() am.switchToAndHideApp(app_messenger) end)
hyper.bindKey('w', function() am.switchToAndHideApp(app_email) end)
hyper.bindKey('e', function() am.switchToAndHideApp(app_meetings) end)

hyper.bindKey('a', function() am.switchToAndHideApp(app_browser) end)
hyper.bindKey('s', function() am.switchToAndHideApp(app_editor) end)
hyper.bindKey('d', function() am.switchToAndHideApp(app_terminal) end)

hyper.bindKey('z', function() am.switchToAndHideApp(app_music) end)
hyper.bindKey('x', function() am.switchToAndHideApp(app_notes) end)
