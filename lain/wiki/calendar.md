Attaches a calendar notification to a widget.

```lua
lain.widgets.calendar.attach(widget, args)
```

- Left click / scroll down: switch to previous month.
- Right click / scroll up: switch to next month.

`args` is an optional table which can contain:

Variable | Meaning | Type | Default
--- | --- | --- | ---
`cal` | custom call for `cal` | string | "/usr/bin/cal --color=always"
`followtag` | Display the notification on currently focused screen | boolean | false
`icons` | Path to calendar icons | string | [lain/icons/cal/white](https://github.com/copycat-killer/lain/tree/master)
`notification_preset` | Notification preset | table | [`naughty.config.defaults`](https://awesomewm.org/apidoc/libraries/naughty.html#config.defaults)

You can reset `cal` any way you like (using `-w` to display weeks as well, for instance), but **be always sure to have the flag `--color=always`**, otherwise the highlighting (which is basically an exploit of `cal`) will not work.

The notification will show an icon of the current day number, and output from ``cal`` with current day highlighted.

You can call the notification with a key binding like this:

```lua
awful.key({ altkey }, "c", function ()
    lain.widgets.calendar:show(7)
end),
```

where ``altkey = "Mod1"`` and ``show`` argument is an optional integer, meaning timeout seconds.

You can also call it defining a notification screen with a third argument like this:

```lua
awful.key({ altkey }, "c", function ()
    lain.widgets.calendar:show(7, 0, my_scr_number)
end),
```

In multiple screen setups, the default behaviour is to show a visual notification pop-up window on the first screen. By setting `followtag` to `true` it will be shown on the currently focused tag screen.

### Note

* Naughty notifications require `notification_preset.font` to be **monospaced**, in order to correctly display the output.