
--[[

     Licensed under GNU General Public License v2
      * (c) 2014, Luke Bonham

--]]

local helpers      = require("lain.helpers")
local wibox        = require("wibox")
local setmetatable = setmetatable

-- Basic template for custom widgets (asynchronous version)
-- lain.widgets.abase

local function worker(args)
    local abase    = {}
    local args     = args or {}
    local timeout  = args.timeout or 5
    local cmd      = args.cmd or ""
    local trim     = args.trim or false
    local settings = args.settings or function() end

    abase.widget = wibox.widget.textbox()

    function abase.update()
        helpers.async(cmd, function(f)
            output = f
            if trim then
              output = string.gsub(output, "\n", "")
            end
            if output ~= abase.prev then
                widget = abase.widget
                settings()
                abase.prev = output
            end
        end)
    end

    helpers.newtimer(cmd, timeout, abase.update)

    return setmetatable(abase, { __index = abase.widget })
end

return setmetatable({}, { __call = function(_, ...) return worker(...) end })
