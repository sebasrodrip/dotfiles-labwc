#!/usr/bin/env bash
#MADE WITH CLAUDE
set -e

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
mkdir -p ~/.config ~/.local/bin

link() {
    local src="$1" dst="$2"
    if [ -e "$dst" ] && [ ! -L "$dst" ]; then
        echo "!! $dst already exists and isn't a symlink — skipping. Back it up first."
        return
    fi
    ln -sfn "$src" "$dst"
    echo "linked $dst -> $src"
}

link "$DOTFILES/.config/labwc"    ~/.config/labwc
link "$DOTFILES/.config/yazi"     ~/.config/yazi
link "$DOTFILES/.config/noctalia" ~/.config/noctalia

for f in "$DOTFILES"/Scripts/*; do
    [ -f "$f" ] && link "$f" ~/.local/bin/"$(basename "$f")"
done

echo "Dotfiles linked."
