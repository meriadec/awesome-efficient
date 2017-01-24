Welcome to the Lain wiki!

Dependency
------------

Package | Requested by | Reasons of choice
--- | --- | ---
[curl](https://curl.haxx.se) | widgets accessing network resources | 1. faster and simpler to use than [LuaSocket](https://github.com/diegonehab/luasocket); 2. it's in the core of almost every distro; 3. can be called [asynchronously](https://awesomewm.org/doc/api/libraries/awful.spawn.html#easy_async)

Installation
------------

### Arch Linux

[AUR package](https://aur.archlinux.org/packages/lain-git/)

### Other distributions

```shell
git clone https://github.com/copycat-killer/lain.git ~/.config/awesome/lain
```

Also available via [LuaRocks](https://luarocks.org/modules/aajjbb/lain).

Usage
--------

First, include it into your `rc.lua`:

```lua
local lain = require("lain")
```

Then check out the submodules you want:

- [Layouts](https://github.com/copycat-killer/lain/wiki/Layouts)
- [Widgets](https://github.com/copycat-killer/lain/wiki/Widgets)
- [Utilities](https://github.com/copycat-killer/lain/wiki/Utilities)