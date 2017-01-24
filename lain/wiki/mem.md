Shows memory status (in MiB).

```lua
mymem = lain.widgets.mem()
```

### Input table

Variable | Meaning | Type | Default
--- | --- | --- | ---
`timeout` | Refresh timeout seconds | int | 2
`settings` | User settings | function | empty function

in `settings` you can use the following variables:

Variable | Meaning | Type
--- | --- | --- | ---
`mem_now.used` | Memory used (MiB) | string
`mem_now.swapused` | Swap memory used (MiB) | string
`mem_now.perc` | Memory percentage | int

### Output

A textbox.