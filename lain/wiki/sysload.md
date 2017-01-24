Shows the current system load.

```lua
mysysload = lain.widgets.sysload()
```

### Input table

Variable | Meaning | Type | Default
--- | --- | --- | ---
`timeout` | Refresh timeout seconds | int | 2
`settings` | User settings | function | empty function

`settings` can use strings `load_1`, `load_5` and `load_15`, which are the load averages over 1, 5, and 15 minutes.

### Output

A textbox.
