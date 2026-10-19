--- Utilvo Shield Filters - Lua parser and matcher for DNS/ABP host blocklists.
-- @module utilvo_shield_filters

local M = {}

M.DEFAULT_BLOCKLIST_URL = "https://utilvo.com/filters/utilvo-shield-filters.txt"
M.SHIELD_EXTENSION_URL = "https://utilvo.com/shield"

local function trim(s)
    return (s:gsub("^%s+", ""):gsub("%s+$", ""))
end

--- Parse raw ABP (`||domain.com^`) and hosts-file (`0.0.0.0 domain.com`) rules into a lookup table.
-- @param raw_text string Raw filter list content
-- @return table Set of blocked domain strings (`domains[host] = true`)
function M.parse_rules(raw_text)
    local domains = {}
    if type(raw_text) ~= "string" then
        return domains
    end
    for raw_line in raw_text:gmatch("[^\r\n]+") do
        local line = trim(raw_line):lower()
        if line ~= "" and line:sub(1, 1) ~= "!" and line:sub(1, 1) ~= "#" and line:sub(1, 1) ~= "[" then
            if line:sub(1, 2) == "||" and line:sub(-1) == "^" then
                local domain = line:sub(3, -2)
                if domain ~= "" and not domain:find("*", 1, true) and not domain:find("/", 1, true) then
                    domains[domain] = true
                end
            elseif line:sub(1, 8) == "0.0.0.0 " or line:sub(1, 10) == "127.0.0.1 " then
                local host = line:match("^%S+%s+(%S+)")
                if host and host ~= "localhost" and host ~= "0.0.0.0" then
                    domains[host] = true
                end
            end
        end
    end
    return domains
end

--- Check whether a hostname or any of its parent domains is matched by the blocklist set.
-- @param hostname string Hostname to check
-- @param blocked_domains table Set returned by `parse_rules`
-- @return boolean True if blocked
function M.is_blocked(hostname, blocked_domains)
    if type(hostname) ~= "string" or type(blocked_domains) ~= "table" then
        return false
    end
    local clean = trim(hostname):lower():gsub("%.+$", "")
    if clean == "" then
        return false
    end
    local current = clean
    while current and current ~= "" do
        if blocked_domains[current] then
            return true
        end
        local dot = current:find(".", 1, true)
        if not dot then
            break
        end
        current = current:sub(dot + 1)
    end
    return false
end

return M
