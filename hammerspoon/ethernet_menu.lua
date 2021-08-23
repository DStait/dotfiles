local ethernet_menubar
local ethernet_menubar_icon_path = "./icons/ethernet_status.png"
local ethernet_menubar_icon = hs.image.imageFromPath(ethernet_menubar_icon_path):size({w=22,h=22})


function ethernet_gen_menu(i)
    local ethernet_menu_table = {}

    ethernet_menu_table [#ethernet_menu_table + 1] = {title = "Interface Name: " .. hs.network.interfaceName()}
    ethernet_menu_table [#ethernet_menu_table + 1] = {title = "IP Address: " .. hs.network.interfaceDetails().IPv4.Addresses[1]}

    return ethernet_menu_table
end

function ethernet_check()
    local interfaceName = hs.network.interfaceName()
    -- Assume we are on Ethernet if not using WiFi
    if  interfaceName ~= "Wi-Fi" and interfaceName ~=  nil then
        -- Check if item is in menubar otherwise menu table gets blanked when timer runs
        if ethernet_menubar:isInMenuBar() ~= true then
            ethernet_menubar:returnToMenuBar():setIcon(ethernet_menubar_icon)
            ethernet_menubar:setMenu(function() return ethernet_gen_menu() end)
        end
    else
        -- WiFi is connected so remove from the menu bar
        ethernet_menubar:removeFromMenuBar()
    end
end

ethernet_menubar = hs.menubar.new():setIcon(ethernet_menubar_icon):removeFromMenuBar()
check_ethernet_timer = hs.timer.new(5, ethernet_check, true):start():fire()