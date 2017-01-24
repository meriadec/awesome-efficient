Shows and controls PulseAudio volume with a textbox.

```lua
volumewidget = lain.widgets.pulseaudio()
```

### Input table

Variable | Meaning | Type | Default
--- | --- | --- | ---
`timeout` | Refresh timeout seconds | int | 5
`cmd` | PulseAudio command | string | [link](https://github.com/copycat-killer/lain/blob/master/widgets/pulseaudio.lua#L29)
`scallback` | PulseAudio Sink callback | function | nil
`settings` | User settings | function | empty function

`cmd` catch infos from current default sink. You can redefine it, being sure that the ouput is something like this:

```shell
* index: 0
    volume: front-left: 18340 /  28% / -33.18 dB,   front-right: 18340 /  28% / -33.18 dB
    muted: no
    device.string = "front:1"
```

**Note:** you can set PulseAudio default sink like this: `pacmd set-default-sink #sink`.

If `sed` doesn't work, you can try with `grep`:

```shell
pacmd list-sinks | grep -e $(pactl info | grep -e 'ink' | cut -d' ' -f3) -e 'volume: front' -e 'muted'
```

`scallback` is a callback function to update `cmd`, in case you switch between audio channels and therefore PulseAudio sink changes. If default `cmd` works for you, you can tell `scallback` to work in the same way:

```lua
scallback = function()
    return "pacmd list-sinks | sed -n -e '0,/*/d' -e '/base volume/d' -e '/volume:/p' -e '/muted:/p'"
end
```

`settings` can use the following variables:

Variable | Meaning | Type | Values
--- | --- | --- | ---
`volume_now.index` | Sink index | string | >= "0"
`volume_now.sink` | Sink name | string | sink name or "N/A"
`volume_now.muted` | Sink mute status | string | "yes", "no", "N/A"
`volume_now.channel` | Sink channels | table of string integers | `volume_now.channel[i]`, where `i >= 1`
`volume_now.left` | Front left level | string | "0"-"100"
`volume_now.right` | Front right level | string | "0"-"100"

`volume_now.channel` is a table of your pulseaudio sink channels. Fetch a channel level like this: `volume_now.channel[i]`, where `i >= 1`.

`volume_now.{left,right}` are pointers for `volume_now.{channel[1], channel[2]}` (stereo).

### Output table

Variable | Meaning | Type
--- | --- | ---
`widget` | The widget | `wibox.widget.textbox`
`update` | Update `widget` | function

You can control the widget with key bindings like these:

```lua
-- PulseAudio volume control
awful.key({ altkey }, "Up",
    function ()
        os.execute(string.format("pactl set-sink-volume %d +1%%", volumewidget.sink))
        volumewidget.update()
    end),
awful.key({ altkey }, "Down",
    function ()
        os.execute(string.format("pactl set-sink-volume %d -1%%", volumewidget.sink))
        volumewidget.update()
    end),
awful.key({ altkey }, "m",
    function ()
        os.execute(string.format("pactl set-sink-mute %d toggle", volumewidget.sink))
        volumewidget.update()
    end),
awful.key({ altkey, "Control" }, "m",
    function ()
        os.execute(string.format("pactl set-sink-volume %d 100%%", volume.sink))
        volumewidget.update()
    end),
awful.key({ altkey, "Control" }, "0",
    function ()
        os.execute(string.format("pactl set-sink-volume %d 0%%", volume.sink))
        volumewidget.update()
    end),
```

where `altkey = "Mod1"`.

### Example

```lua
-- PulseAudio volume (based on multicolor theme)
volumewidget = lain.widgets.pulseaudio({
    settings = function()
        vlevel = volume_now.left .. "-" .. volume_now.right .. "% | " .. volume_now.sink
        if volume_now.muted == "yes" then
            vlevel = vlevel .. " M"
        end

        widget:set_markup(lain.util.markup("#7493d2", vlevel))
    end
})
```
