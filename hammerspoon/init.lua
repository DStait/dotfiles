require "password_from_keychain"
require "chrome_active_tab_with_name"
require "open_app"
require 'movement_timer'
require 'pagerduty'
local am = require('app-management')
-- Load and install the Hyper key extension. Binding to F18
local hyper = require('hyper')
hyper.install('F18')


-- Cmd-Shift-F11 - type linux password
hs.hotkey.bind({"cmd", "shift"}, "F11", function()
  paste_keychain_item("LINUX_PASSWORD")
end)
-- Cmd-Shift-F12 - type sudo -i and  linux password
hs.hotkey.bind({"cmd", "shift"}, "F12", function()
  hs.eventtap.keyStrokes("sudo -i")
  hs.eventtap.keyStroke({}, "return")
  paste_keychain_item("LINUX_PASSWORD")
end)

-- Quick Reloading of Hammerspoon
hyper.bindKey('r', function()
    hs.alert.show("Hammerspoon reloading")
    hs.timer.doAfter(0.5, hs.reload)
end)

-- Global Application Keyboard Shortcuts
hyper.bindShiftKey('p', function()
    hs.spotify.displayCurrentTrack()
end)

hyper.bindCtrlKey('c', function()
  hs.application.launchOrFocus("/Users/dstait/Applications/Chrome Apps.localized/Google Calendar.app")
end)

-- Open chrome tabs
hyper.bindKey('s', chrome_active_tab_with_name("Slack"))
hyper.bindKey('g', chrome_active_tab_with_name("Vonage Mail"))
hyper.bindKey('a', chrome_active_tab_with_name("PagerDuty"))
hyper.bindKey('j', chrome_active_tab_with_name("Kanban"))

-- Open Apps
hyper.bindKey('b', open("Chrome"))
hyper.bindKey('c', open("Visual Studio Code"))
hyper.bindKey('t', open("Alacritty"))
hyper.bindKey('e', open("Finder"))
hyper.bindKey('/', function() hs.eventtap.keyStroke({"ctrl", "alt", "cmd"}, "s") end)

-- Show the bundleID of the currently open window
hyper.bindCommandShiftKey('b', function() 
    local bundleId = hs.window.focusedWindow():application():bundleID()
    hs.alert.show(bundleId)
    hs.pasteboard.setContents(bundleId)
end)

-- Switch to and From App
hyper.bindKey('\'', function() am.switchToAndFromApp("com.barebones.bbedit") end)
hyper.bindKey(']', function() am.switchToAndFromApp("io.alacritty") end)
hyper.bindKey('[', function() am.switchToAndFromApp("com.microsoft.VSCode") end)
hyper.bindKey('p', function() am.switchToAndHideApp("com.spotify.client") end)

