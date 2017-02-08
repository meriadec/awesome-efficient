
--[[
                                                  
     Licensed under GNU General Public License v2 
      * (c) 2013, Luke Bonham                     
                                                  
--]]

local async        = require("lain.helpers").async
local icons_dir    = require("lain.helpers").icons_dir
local markup       = require("lain.util.markup")
local awful        = require("awful")
local naughty      = require("naughty")
local os           = { date   = os.date }
local string       = { format = string.format,
                       gsub   = string.gsub }
local tonumber     = tonumber
local setmetatable = setmetatable

-- Calendar notification
-- lain.widgets.calendar
local calendar = { offset = 0 }

function calendar.hide()
    if not calendar.notification then return end
    naughty.destroy(calendar.notification)
    calendar.notification = nil
end

function calendar.show(t_out, inc_offset, scr)
    calendar.hide()

    local today = os.date("%d")
    local offs = inc_offset or 0
    local f

    calendar.offset = calendar.offset + offs

    local current_month = (offs == 0 or calendar.offset == 0)

    if current_month then -- today highlighted
        calendar.offset = 0
        calendar.notify_icon = string.format("%s%s.png", calendar.icons, today)
        f = calendar.cal
    else -- no current month showing, no day to highlight
       local month = tonumber(os.date("%m"))
       local year  = tonumber(os.date("%Y"))

       month = month + calendar.offset

       while month > 12 do
           month = month - 12
           year = year + 1
       end

       while month < 1 do
           month = month + 12
           year = year - 1
       end

       calendar.notify_icon = nil
       f = string.format("%s %s %s", calendar.cal, month, year)
    end

    if calendar.followtag then
        calendar.notification_preset.screen = awful.screen.focused()
    else
        calendar.notification_preset.screen = src or 1
    end

    async(string.format("%s -c '%s'", awful.util.shell, f), function(ws)
        fg, bg = calendar.notification_preset.fg, calendar.notification_preset.bg
        ws = ws:gsub("%c%[7m%d+%c%[27m", markup.bold(markup.color(bg, fg, today)))
        calendar.notification = naughty.notify({
            preset  = calendar.notification_preset,
            text    = ws:gsub("\n*$", ""),
            icon    = calendar.notify_icon,
            timeout = t_out or calendar.notification.preset.timeout or 5
        })
    end)
end

function calendar.attach(widget, args)
    local args                   = args or {}
    calendar.cal                 = args.cal or "/usr/bin/cal --color=never"
    calendar.followtag           = args.followtag or false
    calendar.icons               = args.icons or icons_dir .. "cal/white/"
    calendar.notification_preset = args.notification_preset

    if not calendar.notification_preset then
        calendar.notification_preset      = naughty.config.defaults
        calendar.notification_preset.font = "Monospace 10"
        calendar.notification_preset.fg   = "#FFFFFF"
        calendar.notification_preset.bg   = "#000000"
    end

    widget:connect_signal("mouse::enter", function () calendar.show(0, 0, calendar.scr_pos) end)
    widget:connect_signal("mouse::leave", function () calendar.hide() end)
    widget:buttons(awful.util.table.join(awful.button({ }, 1, function ()
                                             calendar.show(0, -1, calendar.scr_pos) end),
                                         awful.button({ }, 3, function ()
                                             calendar.show(0, 1, calendar.scr_pos) end),
                                         awful.button({ }, 4, function ()
                                             calendar.show(0, -1, calendar.scr_pos) end),
                                         awful.button({ }, 5, function ()
                                             calendar.show(0, 1, calendar.scr_pos) end)))
end

return setmetatable(calendar, { __call = function(_, ...) return create(...) end })
