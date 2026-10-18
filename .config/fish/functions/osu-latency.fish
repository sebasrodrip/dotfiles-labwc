function osu-latency
    set -l osu_path (NIXPKGS_ALLOW_UNFREE=1 nix build --extra-experimental-features 'nix-command flakes' --impure --no-link --print-out-paths path:$HOME/osu-latency-tweaker)
    OSU_LATENCY_TWEAKER_FREQ=192000 OSU_LATENCY_TWEAKER_PERIOD=-256 NIXPKGS_ALLOW_UNFREE=1 vblank_mode=0 \
                nix run --extra-experimental-features 'nix-command flakes' --impure github:nix-community/nixGL -- $osu_path/bin/osu-lazer
end
