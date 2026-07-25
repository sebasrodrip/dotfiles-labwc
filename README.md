# dotfiles-labwc

My personal dotfiles for a labwc-based Wayland setup.

## Contents

| Program | Config path |
|---|---|
| [labwc](https://labwc.github.io/) | `.config/labwc` |
| [noctalia](https://docs.noctalia.dev) v5 | `.config/noctalia` |
| [yazi](https://yazi-rs.github.io/) | `.config/yazi` |
| [fish](https://fishshell.com/) | `.config/fish` |
| [zellij](https://zellij.dev/) | `.config/zellij` |
| [mpv](https://mpv.io/) | `.config/mpv` |
| [MangoHud](https://github.com/flightlessmango/MangoHud) | `.config/mangohud` |
| [Millennium](https://steambrew.app/) | `.config/millennium` |
| xdg-desktop-portal / xdg-desktop-portal-wlr | `.config/xdg-desktop-portal*` |
| Personal scripts (incl. gpu-screen-recorder helpers) | `Scripts/` |

## Install

```bash
git clone https://github.com/sebasrodrip/dotfiles-labwc.git ~/dotfiles-labwc
cd ~/dotfiles-labwc
./install.sh
```

This symlinks each config folder into place (e.g. `~/.config/labwc` → `~/dotfiles-labwc/.config/labwc`). If a real file/folder already exists at the destination, the script skips it and warns instead of overwriting — back it up manually first if needed.

`~/Scripts` is just a personal, non-standard folder — not on `$PATH` by default. Add it yourself if you want to call scripts by name:

```fish
fish_add_path ~/Scripts
```

## Notes

- Some config in `mpv/` is adapted from [https://github.com/noelsimbolon/mpv-config] — credit to them.
- Requires labwc, yazi, noctalia v5, fish, zellij, mpv, MangoHud, and Millennium to be installed separately; this repo only contains config, not the packages themselves.
