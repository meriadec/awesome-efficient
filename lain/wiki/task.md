Attaches a [taskwarrior](http://taskwarrior.org) notification to a widget, and lets you add/search tasks from the promptbox.

```lua
lain.widgets.contrib.task.attach(widget, args)
```

`args` is an optional table which can contain:

Variable | Meaning | Type | Default
--- | --- | --- | ---
`font_size` | Notifcation font size | int | 12
`fg` | Notification popup foreground color | string | `beautiful.fg_normal`
`bg` | Notification popu background color | string | `beautiful.bg_normal`
`position` | Notification popup position | string | "top_right"
`timeout` | Notification timeout seconds | int | 7
`scr_pos` | Notification screen | int | 1
`followtag` | Display the notification on currently focused screen | boolean | false
`cmdline` | Taskwarrior command to show in the popup | string | "next"
`font` | Pop-up font | string | `beautiful.font`

The tasks are shown in a notification popup when the mouse is moved over the attached `widget`, and the popup is hidden when the mouse is moved away. By default the notification will show the output of `task next`. With `cmdline`, the parameters for the `task` process can be customized, for example if you want to [filter the tasks](https://taskwarrior.org/docs/filter.html) or show a [custom report](https://github.com/copycat-killer/lain/pull/213).

Possible values for `position` are defined [by awesome's `naughty` library](https://awesomewm.org/doc/api/libraries/naughty.html#notify).

In multiple screen setups, the default behaviour is to show a visual notification pop-up window on the first screen. By setting `followtag` to `true` it will be shown on the currently focused tag screen.

You can call the notification with a key binding like this:

```lua
awful.key({ modkey, altkey }, "t", function () lain.widgets.contrib.task.show(scr) end),
```

where ``altkey = "Mod1"`` and `scr` indicates the screen which you want the notification in.

And you can prompt to add/search a task with key bindings like these:

```lua
awful.key({ modkey,         }, "t", lain.widgets.contrib.task.prompt_add),
awful.key({ modkey, "Shift" }, "t", lain.widgets.contrib.task.prompt_search),
```
