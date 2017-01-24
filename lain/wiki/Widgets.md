General usage
-------------

Every widget is output by a `function`.

For some widgets, `function` returns a `wibox.widget.textbox`, for others a table to be used for notification and update purposes.

Every widget may take either a table or a list of variables as argument.

If it takes a table, you have to define a function variable called `settings` in it, in order to make your customizations.

To markup the textbox, call `widget:set_markup(...)` within `settings`.

You can feed `set_markup` with predefined arguments, see the sections for all the details.

`widget` is a textbox, so you can treat it like any other `wibox.widget.textbox`.

Here follows an example:

```lua
mycpu = lain.widgets.cpu({
    settings = function()
        widget:set_markup("Cpu " .. cpu_now.usage)
    end
})
```

If you want to see more complex applications, check [awesome-copycats](https://github.com/copycat-killer/awesome-copycats).

Index
-----

- [abase](https://github.com/copycat-killer/lain/wiki/abase)
- [alsa](https://github.com/copycat-killer/lain/wiki/alsa)
- [alsabar](https://github.com/copycat-killer/lain/wiki/alsabar)
- [base](https://github.com/copycat-killer/lain/wiki/base)
- [bat](https://github.com/copycat-killer/lain/wiki/bat)
- [calendar](https://github.com/copycat-killer/lain/wiki/calendar)
- [cpu](https://github.com/copycat-killer/lain/wiki/cpu)
- [fs](https://github.com/copycat-killer/lain/wiki/fs)
- [imap](https://github.com/copycat-killer/lain/wiki/imap)
- [maildir](https://github.com/copycat-killer/lain/wiki/maildir)
- [mem](https://github.com/copycat-killer/lain/wiki/mem)
- [mpd](https://github.com/copycat-killer/lain/wiki/mpd)
- [net](https://github.com/copycat-killer/lain/wiki/net)
- [pulseaudio](https://github.com/copycat-killer/lain/wiki/pulseaudio)
- [pulsebar](https://github.com/copycat-killer/lain/wiki/pulsebar)
- [sysload](https://github.com/copycat-killer/lain/wiki/sysload)
- [temp](https://github.com/copycat-killer/lain/wiki/temp)
- [weather](https://github.com/copycat-killer/lain/wiki/weather)

Users contributed
----------------

- [gpmdp](https://github.com/copycat-killer/lain/wiki/gpmdp)
- [kbdlayout](https://github.com/copycat-killer/lain/wiki/kbdlayout)
- [moc](https://github.com/copycat-killer/lain/wiki/moc)
- [redshift](https://github.com/copycat-killer/lain/wiki/redshift)
- [task](https://github.com/copycat-killer/lain/wiki/task)
- [tpbat](https://github.com/copycat-killer/lain/wiki/tpbat)
