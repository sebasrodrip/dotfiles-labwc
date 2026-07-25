#!/usr/bin/env bash
#MADE USING CLAUDE
set -e

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
mkdir -p ~/.config ~/.local/share

link() {
    local src="$1" dst="$2"
    if [ -e "$dst" ] && [ ! -L "$dst" ]; then
        echo "!! $dst already exists and isn't a symlink — skipping. Back it up first."
        return
    fi
    ln -sfn "$src" "$dst"
    echo "linked $dst -> $src"
}

# Window manager
link "$DOTFILES/.config/labwc"    ~/.config/labwc

# Shell / terminal
link "$DOTFILES/.config/fish"     ~/.config/fish
link "$DOTFILES/.config/zellij"  ~/.config/zellij

# File manager
link "$DOTFILES/.config/yazi"    ~/.config/yazi

# Shell/desktop UI
link "$DOTFILES/.config/noctalia" ~/.config/noctalia

# Media / gaming
link "$DOTFILES/.config/mpv"       ~/.config/mpv
link "$DOTFILES/.config/MangoHud"  ~/.config/MangoHud
link "$DOTFILES/.config/millennium" ~/.config/millennium

# XDG portals
link "$DOTFILES/.config/xdg-desktop-portal"      ~/.config/xdg-desktop-portal
link "$DOTFILES/.config/xdg-desktop-portal-wlr"  ~/.config/xdg-desktop-portal-wlr

# Terminal emulator profiles
link "$DOTFILES/.local/share/konsole" ~/.local/share/konsole

# Personal scripts
link "$DOTFILES/Scripts" ~/Scripts

echo "Dotfiles linked."
