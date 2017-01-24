Shows and controls PulseAudio volume with a progressbar; provides tooltips, notifications, and color changes at mute/unmute switch.

```lua
volume = lain.widgets.pulsebar()
```

* Left click: launch `pavucontrol`.
* Right click: mute/unmute.
* Scroll wheel: increase/decrase volume.
* Middle click: set volume to 100%.

### Input table

The table and all of its variables are optional.

Variable | Meaning | Type | Default
--- | --- | --- | ---
`timeout` | Refresh timeout seconds | int | 5
`settings` | User settings | function | empty function
`width` | Bar width | int | 63
`height` | Bar height | int | 1
`ticks` | Set bar ticks on | boolean | false
`ticks_size` | Ticks size | int | 7
`vertical` | Set the bar vertical | boolean | false
`cmd` | pulseaudio command | string | same as [here](https://github.com/copycat-killer/lain/wiki/pulseaudio)
`sink` | Mixer sink | int | 0
`step` | Step at which volume is increased/decreased | string | "1%"
`colors` | Bar colors | table | see **colors**
`notifications` | Notifications settings | table | see **notifications**
`followtag` | Display the notification on currently focused screen | boolean | false

### Colors

Variable | Meaning | Type | Default
--- | --- | --- | ---
`background` | Bar backgrund color | string | `beautiful.bg_normal`
`mute` | Bar mute color | string | "#EB8F8F"
`unmute` | Bar unmute color | string | "#A4CE8A"

### Notifications

Variable | Meaning | Type | Default
--- | --- | --- | ---
`font` | Notifications font | string | The one defined in `beautiful.font`
`font_size` | Notifications font size | string | "11"
`color` | Notifications color | string | `beautiful.fg_normal`

`settings` can use the following variables:

Variable | Meaning | Type | Values
--- | --- | --- | ---
`volume_now.left` | Left volume | int | 0-100
`volume_now.right` | Right volume | int | 0-100
`volume_now.muted` | Muted status | string | "yes", "no"
### output table

Variable | Meaning | Type
--- | --- | ---
`bar` | The widget | `wibox.widget.progressbar`
`channel` | pulse channel | string
`card` | pulse card | string
`step` | Increase/decrease step | string
`notify` | The notification | function
`update` | Update state | function

In multiple screen setups, the default behaviour is to show a visual notification pop-up window on the first screen. By setting `followtag` to `true` it will be shown on the currently focused tag screen.

You can control the widget with key bindings like these:

```lua
-- PulseAudio volume control
awful.key({ altkey }, "Up",
	function ()
		os.execute(string.format("pactl set-sink-volume %d +1%%", volume.sink))
		volume.update()
	end),
awful.key({ altkey }, "Down",
	function ()
		os.execute(string.format("pactl set-sink-volume %d -1%%", volume.sink))
		volume.update()
	end),
awful.key({ altkey }, "m",
	function ()
		os.execute(string.format("pactl set-sink-mute %d toggle", volume.sink))
		volume.update()
	end),
awful.key({ altkey, "Control" }, "m",
	function ()
		os.execute(string.format("pactl set-sink-volume %d 100%%", volume.sink))
		volume.update()
	end),
awful.key({ altkey, "Control" }, "0",
	function ()
		os.execute(string.format("pactl set-sink-volume %d 0%%", volume.sink))
		volume.update()
	end),
```

where `altkey = "Mod1"`.
