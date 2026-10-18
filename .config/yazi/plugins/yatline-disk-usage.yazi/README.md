# yatline-disk-usage.yazi

A [yatline.yazi](https://github.com/imsi32/yatline.yazi) addon that shows filesystem usage for the current directory's mountpoint including SSH mounts (SSHFS).

Updates automatically when changing directory, creating, deleting, moving, or yanking files.

![Demo](meta/demo.jpg)

## Requirements

- [yatline.yazi](https://github.com/imsi32/yatline.yazi)

## Installation

**Via ya pkg:**
```bash
ya pkg add pakhromov/yatline-disk-usage
```

**Manual:**
```bash
git clone https://github.com/pakhromov/yatline-disk-usage.yazi ~/.config/yazi/plugins/yatline-disk-usage.yazi
```

Add to `~/.config/yazi/init.lua` **after** yatline's own setup:
```lua
require("yatline-disk-usage"):setup()
```

Add the component to your yatline config:
```lua
{ type = "coloreds", custom = false, name = "disk-usage" }
```

## Colors

| Usage | Color |
|---|---|
| < 65% | Green |
| 65–85% | Yellow |
| > 85% | Red |
