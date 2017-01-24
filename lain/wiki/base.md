This is a simple template widget.

Basically, all it does is to execute an input `cmd`, and to fill its textbox with the output.

```lua
mybase = lain.widgets.base()
```

### Input table

Variable | Meaning | Type | Default
--- | --- | --- | ---
`timeout` | Refresh timeout seconds | int | 5
`cmd` | The command to execute | string | empty string
`settings` | User settings | function | empty function

`settings` can use the string `output`, which is the output of `cmd`.

### Output table

Variable | Meaning | Type
--- | --- | ---
`widget` | The widget | `wibox.widget.textbox`
`update` | Update `widget` | function

The `update` function can be used to refresh the widget before `timeout` expires.
