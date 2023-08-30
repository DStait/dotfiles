require "password_from_keychain"
local cf = require "common_functions"  

-- Only continue if we have the API token
local API_KEY = cf.all_trim(get_item_from_keychain("JIRA_API_KEY"))
if API_KEY == "" then
    return
end

local api_base_url = "https://jiraservicedesk.extge.co.uk/rest/api/2/search?jql="
local browser_base_url = "https://jiraservicedesk.extge.co.uk/issues/?"
local search_string = "filter=33108"

local headers = {
    Authorization = "Bearer " .. API_KEY,
    Accept =  "application/json"
}

-- Temp for first run
old_jira_body_json = hs.json.decode('{ "issues": [] }')
check_jira = hs.timer.new(60,
    function()
        -- Get issues
        local http_r, body_r, headers_r = hs.http.get(api_base_url .. search_string, headers)
        local jira_body_json = hs.json.decode(body_r)
        local jira_num_tickets = cf.tablelength(jira_body_json.issues)
        
        -- Compare issues to not alert repeatedly for same content
        if jira_num_tickets ~= 0 and cf.compareTable(jira_body_json.issues, old_jira_body_json.issues) ~= true then
            hs.notify.new(
                function() cf.open_url(browser_base_url .. search_string) end,
                {
                    title=jira_num_tickets .. " unassigned SD Ticket(s)",
                    withdrawAfter=0,
            }):send()

            old_jira_body_json = jira_body_json
        end
    end,
    true
)

function menuToggle(modifiers, table)
    if table.checked == false then
        opex_menubar:setTitle("!OpEx!")
        check_jira:start():fire()
        opex_menubar:setMenu({
            {
                title = "Enabled",
                fn = menuToggle,
                checked = true
            }
        })
    else
        opex_menubar:setTitle("OpEx")
        check_jira:stop()
        opex_menubar:setMenu({
            {
                title = "Enabled",
                fn = menuToggle,
                checked = false
            }
        })
    end
end

-- Create a menu entry for OpEx
opex_menubar = hs.menubar.new():setTitle("OpEx")
opex_menubar:setMenu({
    {
        title = "Enabled",
        fn = menuToggle,
        checked = false
    }
})