-- movement_timer.lua

-- Activation Types:
--     none                    0
--     contentsClicked         1
--     actionButtonClicked     2
--     replied                 3
--     additionalActionClicked 4


local title = "Movement Notification"
local text = "You've been sitting too long! \nMove!"
local button_title = "Restart Timer"
local additional_actions_options = {"Postpone 5 Minutes","Postpone 15 Minutes","Postpone 30 Minutes"}
-- how often we want to be notified. 
local countdown_time = hs.timer.hours(1)


function timerSetNextTrigger(mins)
    local seconds = hs.timer.minutes(mins)
    timer:setNextTrigger(seconds)
    timer:start()
    update_timer_menubar()
end

-- Notification action function
function move_notif_action(n)
    local activation_type_num = n:activationType()
    if activation_type_num == 1 then
        timer:start()
        update_timer_menubar()
    elseif activation_type_num == 2 then
        timer:start()
        update_timer_menubar()
    elseif activation_type_num == 3 then
        -- Do nothing
    elseif activation_type_num == 4 then
        local action_name = n:additionalActivationAction()
        local mins_delay = string.match(action_name,"[0-9]+")
        timerSetNextTrigger(mins_delay)
    end
end

-- Timer action function
function timer_action()
    -- Stop the timer so it doesn't keep running
    timer:stop()
    -- Send the notification
    move_notif:send()
end

function update_timer_menubar()
    if timer:running() == false then
        timer_menubar:setTitle("X")
        return
    end
    local time_left = timer:nextTrigger()
    local time_left_mins = tonumber(string.format("%.0f", time_left / 60))
    timer_menubar:setTitle(time_left_mins .. "m")
end

-- Notification object
move_notif = hs.notify.new(
    -- The notification object gets passed to this function
    move_notif_action,
    {
        title=title, 
        informativeText=text,
        actionButtonTitle=button_title,
        hasActionButton=true,
        withdrawAfter=0,
        additionalActions=additional_actions_options
    }
)

if timer == nil then
    timer = hs.timer.new(countdown_time, timer_action)
    timer:start()
end


timer_menubar = hs.menubar.new()
timer_menubar:setMenu({
    {title = "Enable", fn = function() timer:start() update_timer_menubar() end},
    {title = "Disable", fn = function() timer:stop() update_timer_menubar() end},
    {title = "Set 5 Mins", fn = function() timerSetNextTrigger(5)end},
    {title = "Set 15 Mins", fn = function() timerSetNextTrigger(15)end},
    {title = "Set 30 Mins", fn = function() timerSetNextTrigger(30)end},
    {title = "Set 60 Mins", fn = function() timerSetNextTrigger(60)end}
})
update_menubar = hs.timer.doEvery(30, update_timer_menubar):fire()


