#!/usr/bin/env bash
#MADE USING CLAUDE
set -e

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

mkdir -p ~/.config ~/.local/bin

ln -sfn "$DOTFILES/config/labwc" ~/.config/labwc
ln -sfn "$DOTFILES/config/yazi" ~/.config/yazi
ln -sfn "$DOTFILES/config/noctalia" ~/.config/noctalia

for f in "$DOTFILES"/local/bin/*; do
	ln -sf "$f" ~/.local/bin/"$(basename "f")""
done

echo "Dotfiles linked."
