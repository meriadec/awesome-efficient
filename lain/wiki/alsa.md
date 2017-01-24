Shows ALSA volume with a textbox.

```lua
volumewidget = lain.widgets.alsa()
```

### Input table

Variable | Meaning | Type | Default
--- | --- | --- | ---
`timeout` | Refresh timeout seconds | int | 5
`cmd` | Alsa mixer command | string | "amixer"
`channel` | Mixer channel | string | "Master"
`togglechannel` | Toggle channel | string | `nil`
`settings` | User settings | function | empty function

`cmd` is useful if you need to pass additional arguments to amixer. For instance, users with multiple sound cards may define `cmd = "amixer -c X"` in order to set amixer with card `X`.

`settings` can use the following variables:

Variable | Meaning | Type | Values
--- | --- | --- | ---
`volume_now.level` | Volume level | int | 0-100
`volume_now.status` | Device status | string | "on", "off"

### Output table

Variable | Meaning | Type
--- | --- | ---
`widget` | The widget | `wibox.widget.textbox`
`channel` | ALSA channel | string
`update` | Update `widget` | function


### Toggle channel

In case mute toggling can't be mapped to master channel (this happens, for instance, when you are using an HDMI output), define togglechannel as your S/PDIF device. You can get the device ID with `scontents` command.

For instance, if card number is 1 and S/PDIF number is 3:

```shell
$ amixer -c 1 scontents
Simple mixer control 'Master',0
  Capabilities: volume
  Playback channels: Front Left - Front Right
  Capture channels: Front Left - Front Right
  Limits: 0 - 255
  Front Left: 255 [100%]
  Front Right: 255 [100%]
Simple mixer control 'IEC958',0
  Capabilities: pswitch pswitch-joined
  Playback channels: Mono
  Mono: Playback [on]
Simple mixer control 'IEC958',1
  Capabilities: pswitch pswitch-joined
  Playback channels: Mono
  Mono: Playback [on]
Simple mixer control 'IEC958',2
  Capabilities: pswitch pswitch-joined
  Playback channels: Mono
  Mono: Playback [on]
Simple mixer control 'IEC958',3
  Capabilities: pswitch pswitch-joined
  Playback channels: Mono
  Mono: Playback [on]
```

you have to set `togglechannel = "IEC958,3"`.

### Keybindings

You can control the widget with keybindings like these:

```lua
-- ALSA volume control
awful.key({ altkey }, "Up",
	function ()
		os.execute(string.format("amixer set %s 1%%+", volume.channel))
		volume.update()
	end),
awful.key({ altkey }, "Down",
	function ()
		os.execute(string.format("amixer set %s 1%%-", volume.channel))
		volume.update()
	end),
awful.key({ altkey }, "m",
	function ()
		os.execute(string.format("amixer set %s toggle", volume.togglechannel or volume.channel))
		volume.update()
	end),
awful.key({ altkey, "Control" }, "m",
	function ()
		os.execute(string.format("amixer set %s 100%%", volume.channel))
		volume.update()
	end),
awful.key({ altkey, "Control" }, "0",
	function ()
		os.execute(string.format("amixer set %s 0%%", volume.channel))
		volume.update()
	end),
```

where `altkey = "Mod1"`.