
-- Activation Types:
--     none                    0
--     contentsClicked         1
--     actionButtonClicked     2
--     replied                 3
--     additionalActionClicked 4
creds = require 'pagerduty_credentials'

local title = "PagerDuty"
local tooltip_text = "Command+Click = Acknowledge\nOption+Click = Resolve\nCtrl+Click = Snooze"
local additional_actions_options = {"Acknowledge","Resolve"}
local pd_url = "https://api.pagerduty.com/"
local pd_view_url = creds.pd_view_url
local pd_user_id = creds.pd_user_id
local pd_user_token = creds.pd_user_token
local pd_user_email = creds.pd_user_email
local pd_notif_urgencies = {"high"}
local pd_notif_statuses = {"triggered"}
local pd_menu_urgencies = {"low", "high"}
local pd_menu_statuses = {"acknowledged", "triggered"}
local pd_headers = {Authorization = "Token token=" .. pd_user_token, Accept = "application/vnd.pagerduty+json;version=2"}
local pd_headers_post = {Authorization = "Token token=" .. pd_user_token ,Accept = "application/vnd.pagerduty+json;version=2", From = pd_user_email, ["Content-Type"] = "application/json"}


function pd_incident_acknowledge(incident)
    local body = '{"incidents": [{"type": "incident", "id": "' .. incident.id .. '", "status": "acknowledged", "title": "'.. incident.title .. '"}]}'
    local a_http_response,a_body_response, a_response_headers = hs.http.doRequest(pd_url ..  "incidents", "PUT", body, pd_headers_post)
end

function pd_incident_snooze(incident)
    local s_http_response,s_body_response, s_response_headers = hs.http.post(pd_url .. "incidents/" .. incident.id .. "/snooze", '{"duration": 60}', pd_headers_post)
end

function pd_incident_resolve(incident)
    local body = '{"incidents": [{"type": "incident", "id": "' .. incident.id .. '", "status": "resolved", "title": "'.. incident.title .. '"}]}'
    local a_http_response,a_body_response, a_response_headers = hs.http.doRequest(pd_url ..  "incidents", "PUT", body, pd_headers_post)
end

function pd_notif_action(n)
    if n:activationType() == 1 then
        local cmd="/usr/bin/open " .. pd_view_url
        local handle = io.popen(cmd)
        handle:close()
    elseif n:activationType() == 4 then
        local action_name = n:additionalActivationAction()
        if action_name == "Acknowledge" then
            pd_incident_acknowledge(incidents[1])
        elseif action_name == "Snooze" then
            pd_incident_snooze(incidents[1])
        elseif action_name == "Resolve" then
            pd_incident_resolve(incidents[1])
        end
    end
end

function pd_send_notification(text)
    -- Notification object
    local pd_notif = hs.notify.new(
        {
            title=title, 
            informativeText=text,
            withdrawAfter=15
        }
    ):send()
end

function pd_send_notification_with_actions(text)
    -- Notification object
    local pd_notif = hs.notify.new(
        -- The notification object gets passed to this function
        pd_notif_action,
        {
            title=title, 
            informativeText=text,
            withdrawAfter=15,
            additionalActions=additional_actions_options
        }
    ):send()
end

-- https://stackoverflow.com/questions/2705793/how-to-get-number-of-entries-in-a-lua-table
function tablelength(T)
    local count = 0
    for _ in pairs(T) do count = count + 1 end
    return count
end

function open_url(url)
    local cmd="/usr/bin/open " .. url
    local handle = io.popen(cmd)
    handle:close()
end

function gen_url_string(key, values)
    local url_prefix = "&" .. key .. "%5B%5D="
    local url_string = ""
    for value in pairs(values) do
        url_string = url_string .. url_prefix .. values[value]
    end

    return url_string
end

function pd_check(userID, urgencies, statuses)
    local pd_incidents_url = pd_url .. "incidents?user_ids%5B%5D=" .. userID  .. gen_url_string("urgencies", urgencies) .. gen_url_string("status", statuses)
    local pd_http_response,pd_body_response, pd_response_headers = hs.http.get(pd_incidents_url, pd_headers)
    local json_pd_result = hs.json.decode(pd_body_response)

    return json_pd_result.incidents
end


function pd_notify(incidents_table) 
    local num_incidents = tablelength(incidents_table)

    if num_incidents == 0 then
        return
    elseif incidents_table[2] == nil then
        -- only a single alert
        pd_send_notification_with_actions(incidents_table[1].title)
    else
        pd_send_notification("There are " .. num_incidents .. " triggered incidents")
    end
end

-- Possible modifiers: cmd alt shift ctrl fn
function pagerduty_menu_actions(modifiers, table_item)
    -- No modifiers
    if (modifiers.cmd == false and modifiers.alt == false and modifiers.shift == false and modifiers.ctrl == false and modifiers.fn == false) then
        open_url(table_item.incident_object.html_url)
    -- Only cmd
    elseif (modifiers.cmd == true and modifiers.alt == false and modifiers.shift == false and modifiers.ctrl == false and modifiers.fn == false) then
        -- Ack
        pd_incident_acknowledge(table_item.incident_object)
    -- Only alt
    elseif (modifiers.cmd == false and modifiers.alt == true and modifiers.shift == false and modifiers.ctrl == false and modifiers.fn == false) then
        -- Resolve
        pd_incident_resolve(table_item.incident_object)
    -- Only ctrl
    elseif (modifiers.cmd == false and modifiers.alt == false and modifiers.shift == false and modifiers.ctrl == true and modifiers.fn == false) then
        -- Snooze
        pd_incident_snooze(table_item.incident_object)
    end
end

function pagerduty_gen_menu(i)
    local num_incidents = tablelength(i)
    local menu_table = {}

    if num_incidents == 0 then
        menu_table [#menu_table + 1] = {title = "No incidents"}
    else
        for x in pairs(i) do
            local alert = i[x]
            menu_table [#menu_table + 1] = {title = "[" .. alert.urgency .. "] [".. alert.status .. "] " .. alert.title, fn = pagerduty_menu_actions, incident_object = alert, tooltip = tooltip_text}
        end
    end

    return menu_table
end

-- doEvery doesn't have option to continue on error
check_pd = hs.timer.new(60, 
    function() 
        incidents = pd_check(pd_user_id, pd_notif_urgencies, pd_notif_statuses)
        pd_notify(incidents) 
    end, 
    true
):start():fire()


pagerduty_menubar = hs.menubar.new():setTitle("Pd")
pagerduty_menubar:setMenu(function() return pagerduty_gen_menu(pd_check(pd_user_id, pd_menu_urgencies, pd_menu_statuses))end)
