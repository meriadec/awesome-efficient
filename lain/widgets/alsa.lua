
--[[
                                                  
     Licensed under GNU General Public License v2 
      * (c) 2013, Luke Bonham                     
      * (c) 2010, Adrian C. <anrxc@sysphere.org>  
                                                  
--]]

local helpers      = require("lain.helpers")
local shell        = require("awful.util").shell
local wibox        = require("wibox")
local string       = { match  = string.match,
                       format = string.format }
local setmetatable = setmetatable

-- ALSA volume
-- lain.widgets.alsa
local alsa = helpers.make_widget_textbox()

local function worker(args)
    local args     = args or {}
    local timeout  = args.timeout or 5
    local settings = args.settings or function() end

    alsa.cmd           = args.cmd or "amixer"
    alsa.channel       = args.channel or "Master"
    alsa.togglechannel = args.togglechannel

    if alsa.togglechannel then
        alsa.cmd = { shell, "-c", string.format("%s get %s; %s get %s",
        alsa.cmd, alsa.channel, alsa.cmd, alsa.togglechannel) }
    end

    alsa.last = {}

    function alsa.update()
        helpers.async(alsa.cmd, function(mixer)
            local l,s = string.match(mixer, "([%d]+)%%.*%[([%l]*)")
            if alsa.last.level ~= l or alsa.last.status ~= s then
                volume_now = { level = l, status = s }
                widget = alsa.widget
                settings()
                alsa.last = volume_now
            end
        end)
    end

    timer_id = string.format("alsa-%s-%s", alsa.cmd, alsa.channel)

    helpers.newtimer(timer_id, timeout, alsa.update)

    return alsa
end

return setmetatable(alsa, { __call = function(_, ...) return worker(...) end })
