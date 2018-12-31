local cairo         = require("lgi").cairo
local gears         = require("gears")
local wibox         = require("wibox")
local beautiful     = require("beautiful")
local naughty       = require("naughty")
local lain          = require("lain")
local freedesktop   = require("freedesktop")
local awful         = require("awful")
                      require("awful.autofocus")
local smartBorders  = require("modules/smart-borders")

local ENABLE_SMART_BORDERS = false
local HIDPI = os.getenv("HIDPI") == "1"

local topBarHeight = 40
if HIDPI then
  topBarHeight = 70
end

if awesome.startup_errors then
  naughty.notify({
    preset = naughty.config.presets.critical,
    title = "Oops, there were errors during startup!",
    text = awesome.startup_errors,
  })
end

do
  local in_error = false
  awesome.connect_signal("debug::error", function (err)
    if in_error then return end
    in_error = true
    naughty.notify({ preset = naughty.config.presets.critical,
    title = "An error happened",
    text = tostring(err) })
    in_error = false
  end)
end

local function runOnce(cmd)
  findme = cmd
  firstspace = cmd:find(" ")
  if firstspace then
    findme = cmd:sub(0, firstspace-1)
  end
  awful.spawn.with_shell(string.format("pgrep -u $USER -x %s > /dev/null || (%s)", findme, cmd))
end

runOnce("kitty")

beautiful.init(os.getenv("HOME") .. "/.config/awesome/theme.lua")

local modkey     = "Mod4"
local altkey     = "Mod1"
local terminal   = "kitty"
local editor     = "nvim"
local browser    = os.getenv("BROWSER")
local tagnames   = { " 1 ", " 2 ", " 3 ", " 4 ", " 5 ", " 6 ", " 7 " }

local initialLayouts = {
  awful.layout.suit.tile.left,
  awful.layout.suit.tile.left,
  awful.layout.suit.tile.left,
  awful.layout.suit.tile.left,
  awful.layout.suit.tile.left,
  awful.layout.suit.tile.left,
  awful.layout.suit.tile.left,
}

awful.layout.layouts = {
  awful.layout.suit.tile.left,
  lain.layout.centerwork,
  awful.layout.suit.fair,
  awful.layout.suit.tile.bottom,
  awful.layout.suit.tile,
  -- awful.layout.suit.fair.horizontal,
  -- awful.layout.suit.floating,
  -- awful.layout.suit.tile,
  -- awful.layout.suit.tile.left,
  -- awful.layout.suit.tile.bottom,
  -- awful.layout.suit.tile.top,
  -- awful.layout.suit.fair,
  -- awful.layout.suit.fair.horizontal,
  -- awful.layout.suit.spiral,
  -- awful.layout.suit.spiral.dwindle,
  -- awful.layout.suit.max,
  -- awful.layout.suit.max.fullscreen,
  -- awful.layout.suit.magnifier,
  -- awful.layout.suit.corner.nw,
  -- awful.layout.suit.corner.ne,
  -- awful.layout.suit.corner.sw,
  -- awful.layout.suit.corner.se,
}

lain.layout.termfair.nmaster        = 3
lain.layout.termfair.ncol           = 1
lain.layout.termfair.center.nmaster = 3
lain.layout.termfair.center.ncol    = 1

rightMenu = awful.menu({
  items = {
    { "quit", function() awesome.quit() end},
  }
})

local markup = lain.util.markup
local separators = lain.util.separators

local function infoText(widget, value, unit, label)
  widget:set_markup(
    " "
    .. label
    .. ""
    .. markup("#BF616Aaa", "<b>" .. value .. "</b>")
    -- .. markup("#BF616Aaa", "<b>" .. value .. "</b>")
    .. markup("#ffffff22", unit)
    -- .. markup("#BF616A99", unit)
    .. " "
  )
end

local textClock = lain.widgets.abase({
  timeout  = 60,
  cmd      = " date +'%a %d %b %R'",
  trim     = true,
  settings = function()
    words = {}
    for word in output:gmatch("%w+") do table.insert(words, word) end
    widget:set_markup(markup("#65737e", " " .. words[1] .. " " .. words[2] .. " " .. words[3] .. " " .. markup("#ddd", words[4] .. ":" .. words[5]) .. ""))
  end
})

lain.widgets.calendar.attach(textClock, {
  notification_preset = {
    font = beautiful.font,
    fg   = beautiful.fg_widget,
    bg   = beautiful.bg_widget
  }
})

-- MEM
local memwidget = lain.widgets.mem({ settings = function() infoText(widget, mem_now.used, "mb", "mem") end })

-- CPU
local cpuwidget = lain.widgets.cpu({ settings = function() infoText(widget, cpu_now.usage, "%", "cpu") end })

-- Temp
local tempwidget = lain.widgets.temp({ settings = function() infoText(widget, coretemp_now, "°C", "temp") end })

-- Systray
local systray = wibox.widget.systray()
systray.set_base_size(25)

-- ALSA volume
local volume = lain.widgets.alsa({ settings = function() infoText(widget, volume_now.level, "%", "vol") end })

-- Net
local netwidget = lain.widgets.net({
  settings = function()
    widget:set_markup(markup("#7AC82E", " " .. net_now.received)
    .. "" ..
    markup("#46A8C3", " " .. net_now.sent .. " "))
  end
})

-- Battery
local bat = lain.widgets.bat({
  settings = function()
    infoText(widget, bat_now.perc, "%", "bat")
  end
})

local taglist_buttons = awful.util.table.join(
  awful.button({ }, 1, function(t) t:view_only() end),
  awful.button({ modkey }, 1, function(t)
    if client.focus then
      client.focus:move_to_tag(t)
    end
  end),
  awful.button({ }, 3, awful.tag.viewtoggle),
  awful.button({ modkey }, 3, function(t)
    if client.focus then
      client.focus:toggle_tag(t)
    end
  end),
  awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
  awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
)

local tasklist_buttons = awful.util.table.join(
  awful.button({ }, 1, function (c)
    if c == client.focus then
      c.minimized = true
    else
      c.minimized = false
      if not c:isvisible() and c.first_tag then
        c.first_tag:view_only()
      end
      client.focus = c
      c:raise()
    end
  end),
  awful.button({ }, 4, function ()
    awful.client.focus.byidx(1)
  end),
  awful.button({ }, 5, function ()
    awful.client.focus.byidx(-1)
end))

local function set_wallpaper(s)
  if beautiful.wallpaper then
    local wallpaper = beautiful.wallpaper
    if type(wallpaper) == "function" then
      wallpaper = wallpaper(s)
    end
    gears.wallpaper.maximized(wallpaper, s, true)
  end
end

local function updateScreenPadding(nb)
  local screen = awful.screen.focused()
  local v = screen.padding.top + nb
  awful.screen.padding(screen, { top = v, right = v, bottom = v, left = v })
end

screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
  set_wallpaper(s)
  awful.screen.padding(s, { top = beautiful.screen_padding, right = beautiful.screen_padding, bottom = beautiful.screen_padding, left = beautiful.screen_padding })
  awful.tag(tagnames, s, initialLayouts)

  s.mylayoutbox = awful.widget.layoutbox(s)
  s.mylayoutbox:buttons(awful.util.table.join(
    awful.button({ }, 1, function () awful.layout.inc( 1) end),
    awful.button({ }, 3, function () awful.layout.inc(-1) end),
    awful.button({ }, 4, function () awful.layout.inc( 1) end),
    awful.button({ }, 5, function () awful.layout.inc(-1) end)
  ))

  s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, taglist_buttons)
  s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, tasklist_buttons)

  s.mywibox = awful.wibar({
    position = "top",
    border_width = 0,
    border_color = "#22272f",
    screen = s,
    height = topBarHeight,
    visible = false,
  })

  local WIDGET_MARGIN = 0
  if HIDPI then
    WIDGET_MARGIN = 8
  end

  s.mywibox:setup {
    layout = wibox.layout.align.horizontal,
    {
      -- Left widgets
      layout = wibox.layout.fixed.horizontal,
      wibox.layout.margin(s.mytaglist, WIDGET_MARGIN, WIDGET_MARGIN + 20, WIDGET_MARGIN, WIDGET_MARGIN),
    },
    -- Middle widget
    wibox.layout.margin(s.mytasklist, WIDGET_MARGIN, WIDGET_MARGIN, WIDGET_MARGIN, WIDGET_MARGIN),
    {
      -- Right widgets
      layout = wibox.layout.fixed.horizontal,
      wibox.layout.margin(systray, 5, 0, 5, 0),
      netwidget,
      wibox.layout.margin(volume, 20, 0, 0, 0),
      memwidget,
      cpuwidget,
      bat,
      -- tempwidget,
      wibox.layout.margin(textClock, 20, 10, 0, 0),
      --                                 L  R  T  B
      -- wibox.layout.margin(s.mylayoutbox, 5, 2, 1, 2),
    },
  }
end)

root.buttons(awful.util.table.join(
  awful.button({ }, 3, function () rightMenu:toggle() end),
  awful.button({ }, 4, awful.tag.viewnext),
  awful.button({ }, 5, awful.tag.viewprev)
))

globalkeys = awful.util.table.join(
    awful.key({ }, "XF86AudioRaiseVolume", function () awful.util.spawn("amixer set Master 5%+", false) end),
    awful.key({ }, "XF86AudioLowerVolume", function () awful.util.spawn("amixer set Master 5%-", false) end),

    awful.key({ modkey }, "Left", awful.tag.viewprev),
    awful.key({ modkey }, "Right", awful.tag.viewnext),
    awful.key({ modkey }, "Tab", awful.tag.history.restore),

    awful.key({ modkey }, "t", function()
      awful.client.focus.bydirection("down")
      if client.focus then client.focus:raise() end
    end),

    awful.key({ modkey }, "n", function()
      awful.client.focus.bydirection("up")
      if client.focus then client.focus:raise() end
    end),

    awful.key({ modkey }, "h", function()
      awful.client.focus.bydirection("left")
      if client.focus then client.focus:raise() end
    end),

    awful.key({ modkey }, "s", function()
      awful.client.focus.bydirection("right")
      if client.focus then client.focus:raise() end
    end),

    -- Screen browsing
    awful.key({ modkey, "Shift" }, "s", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Shift" }, "h", function () awful.screen.focus_relative(-1) end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "t", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "n", function () awful.client.swap.byidx( -1)    end),

    -- Resizing & Moving (for floating client)
   awful.key({ modkey, "Shift" }, "Left",  function () awful.client.moveresize( 0, 0, -1, 0) end),
   awful.key({ modkey, "Shift" }, "Right", function () awful.client.moveresize( 0, 0,  1, 0) end),
   awful.key({ modkey, "Shift" }, "Up",    function () awful.client.moveresize( 0, 0, 0, -1) end),
   awful.key({ modkey, "Shift" }, "Down",  function () awful.client.moveresize( 0, 0, 0,  1) end),
   awful.key({ modkey, "Control" }, "Down",  function () awful.client.moveresize(  0,  1,   0,   0) end),
   awful.key({ modkey, "Control" }, "Up",    function () awful.client.moveresize(  0, -1,   0,   0) end),
   awful.key({ modkey, "Control" }, "Left",  function () awful.client.moveresize(-1,   0,   0,   0) end),
   awful.key({ modkey, "Control" }, "Right", function () awful.client.moveresize( 1,   0,   0,   0) end),

    -- On the fly useless gaps change
    awful.key({ altkey, "Control" }, "+", function () lain.util.useless_gaps_resize(10) end),
    awful.key({ altkey, "Control" }, "-", function () lain.util.useless_gaps_resize(-10) end),

    awful.key({ altkey, "Shift", "Control" }, "+", function () updateScreenPadding(10) end),
    awful.key({ altkey, "Shift", "Control" }, "-", function () updateScreenPadding(-10) end),

    awful.key({ altkey }, "Tab", function ()
      awful.client.focus.history.previous()
      if client.focus then
        client.focus:raise()
      end
    end),

    -- Show/Hide Wibox
    awful.key({ modkey }, "b", function ()
      for s in screen do
        s.mywibox.visible = not s.mywibox.visible
      end
    end),

    -- Standard program
    awful.key({ modkey }, "Return",       function () awful.spawn(terminal) end),
    awful.key({ modkey, "Control" }, "r",                       awesome.restart),

    awful.key({ modkey, "Control" }, "h", function () awful.tag.incmwfact(0.005) end),
    awful.key({ modkey, "Control" }, "s", function () awful.tag.incmwfact(-0.005) end),
    awful.key({ modkey, "Control" }, "t", function () awful.client.incwfact( 0.02) end),
    awful.key({ modkey, "Control" }, "n", function () awful.client.incwfact(-0.02) end),

    awful.key({ modkey }, "space",          function ()  awful.layout.inc(1) end),
    awful.key({ modkey, "Shift" }, "space", function () awful.layout.inc(-1) end),

    -- ALSA volume control
    awful.key({ altkey }, "Up", function ()
      os.execute(string.format("amixer set %s 1%%+", volume.channel))
      volume.update()
    end),
    awful.key({ altkey }, "Down", function ()
      os.execute(string.format("amixer set %s 1%%-", volume.channel))
      volume.update()
    end),

    awful.key({ modkey }, "c", function () awful.spawn(browser) end),
    awful.key({ modkey }, "l", function () awful.util.spawn("slock", false) end),
    awful.key({ modkey }, "r", function () awful.util.spawn("rofi -show run", false) end),
    awful.key({ modkey, "Shift" }, "r", function () awful.util.spawn("rofi -show window", false) end),
    awful.key({ modkey }, "-", function () awful.util.spawn("s", false) end),
    awful.key({ modkey, "Shift" }, "-", function () awful.spawn.with_shell("escrotum -s '%Y-%m-%d_$wx$h.png' | xargs add-shadow", false) end)
)

clientkeys = awful.util.table.join(
  awful.key({ modkey }, "f", function (c)
    c.fullscreen = not c.fullscreen
    if ENABLE_SMART_BORDERS == true then
      if c.fullscreen == false then
        smartBorders.set(c, true)
      end
    end
    c:raise()
  end),

  awful.key({ modkey }, "m", function (c)
    c.maximized = not c.maximized
    if ENABLE_SMART_BORDERS == true then
      if c.maximized == false then
        smartBorders.set(c, true)
      end
    end
    c:raise()
  end),

  awful.key({ modkey }, "w", function (c) c.focusable = false end),
  awful.key({ modkey, "Shift" }, "c", function (c) c:kill() end),
  awful.key({ modkey, "Control" }, "space", awful.client.floating.toggle),
  awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
  awful.key({ modkey }, "p", function (c) c.ontop = not c.ontop end)
)

for i = 1, 9 do
  globalkeys = awful.util.table.join(globalkeys,
    -- go to tag
    awful.key({ modkey }, "#" .. i + 9, function ()
      local screen = awful.screen.focused()
      local tag = screen.tags[i]
      if tag then
        tag:view_only()
      end
    end),

    -- move client to tag
    awful.key({ modkey, "Shift" }, "#" .. i + 9, function ()
      if client.focus then
        local tag = client.focus.screen.tags[i]
        if tag then
          client.focus:move_to_tag(tag)
        end
      end
    end),

    -- toggle tag on focused client.
    awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9, function ()
      if client.focus then
        local tag = client.focus.screen.tags[i]
        if tag then
          client.focus:toggle_tag(tag)
        end
      end
    end)
  )
end

clientbuttons = awful.util.table.join(
  awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
  awful.button({ modkey }, 1, awful.mouse.client.move),
  awful.button({ modkey }, 3, awful.mouse.client.resize)
)

root.keys(globalkeys)

awful.rules.rules = {
  -- all clients
  {
    rule = { },
    properties = {
      border_width = beautiful.border_width,
      border_color = beautiful.border_normal,
      focus = awful.client.focus.filter,
      maximized_horizontal = false,
      maximized_vertical = false,
      maximized = false,
      raise = true,
      keys = clientkeys,
      buttons = clientbuttons,
      screen = awful.screen.preferred,
      placement = awful.placement.no_overlap+awful.placement.no_offscreen,
      size_hints_honor = false,
    }
  },
  -- titlebars
  {
    rule_any = {
      type = { "dialog", "normal" }
    },
    properties = { titlebars_enabled = true }
  },
  -- glava
  {
    rule = { class = "GLava" },
    properties = {
      floating = true,
      buttons = nil,
      keys = nil,
      focusable = false,
      geometry = { height = 300, width = 2560, y = 1440 - 300 + 16 },
      sticky = true,
      below = true,
      titlebars_enabled = false,
    },
  },
  -- feh
  {
    rule = { class = "feh" },
    properties = {
      floating = true,
      buttons = nil,
      keys = nil,
      sticky = true,
      titlebars_enabled = false,
    },
  },
}

client.connect_signal("manage", function (c)
  if awesome.startup and
    not c.size_hints.user_position
    and not c.size_hints.program_position then
    -- Prevent clients from being unreachable after screen count changes.
    awful.placement.no_offscreen(c)
  end
end)

if ENABLE_SMART_BORDERS == true then
  client.connect_signal("request::titlebars", function(c) smartBorders.set(c, true) end)
  client.connect_signal("property::size", smartBorders.set)
end

client.connect_signal("mouse::enter", function(c)
  if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
    and awful.client.focus.filter(c) then
    client.focus = c
  end
end)

client.connect_signal("focus", function(c)
  -- no border for maximized clients
  if c.maximized_horizontal == true and c.maximized_vertical == true then
    c.border_width = 0
  elseif #awful.client.visible(mouse.screen) > 1 then
    c.border_width = beautiful.border_width
    c.border_color = beautiful.border_focus
  else
    c.border_width = 0
  end
end)

client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
