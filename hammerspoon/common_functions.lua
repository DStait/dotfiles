local this = {}

function this.all_trim(s)
    return s:match"^%s*(.*)":match"(.-)%s*$"
end

-- https://stackoverflow.com/questions/2705793/how-to-get-number-of-entries-in-a-lua-table
function this.tablelength(T)
    local count = 0
    for _ in pairs(T) do count = count + 1 end
    return count
end


-- https://stackoverflow.com/questions/46750313/comparing-tables-in-lua-where-keys-are-tables
function this.compareTable(one, two)
    if type(one) == type(two) then
        if type(one) == "table" then
            if #one == #two then
                -- If both types are the same, both are tables and 
                -- the tables are the same size, recurse through each
                -- table entry.
                for loop=1, #one do
                    if compare(one[loop], two[loop]) == false then
                        return false
                    end
                end 
                -- All table contents match
                return true
            end
        else
            -- Values are not tables but matching types. Compare
            -- them and return if they match
            return one == two
        end
    end
    return false
end

function this.open_url(url)
    local cmd="/usr/bin/open " .. url
    local handle = io.popen(cmd)
    handle:close()
end

return this