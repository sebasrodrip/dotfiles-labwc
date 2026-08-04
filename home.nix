{ config, pkgs, pkgs-unstable, millennium,  ... }:

let
	dotfiles = "${config.home.homeDirectory}/nixos-dotfiles/config/dotfiles-labwc";
	create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;
	configs = {
		labwc = "labwc";
		yazi = "yazi";
		mpv = "mpv";
		fish = "fish";
		zellij = "zellij";
		noctalia = "noctalia";
		xdg-desktop-portal = "xdg-desktop-portal";
		xdg-desktop-portal-wlr = "xdg-desktop-portal-wlr";
		mangohud = "MangoHud";
	};
in
{
	home.username = "nixos-vm";
	home.homeDirectory = "/home/nixos-vm";
	programs.git.enable = true;
	home.stateVersion = "26.05";
	home.sessionPath = [ "$HOME/.local/bin"];
	programs.bash = {
		enable = true;
		shellAliases = {
			btw = "echo I use nixos, btw";
		};
	};

	xdg.configFile = builtins.mapAttrs
	(name: subpath: {
		source = create_symlink "${dotfiles}/.config/${subpath}";
		recursive = true;		
	}) 
	configs;

	home.file = {
		".local/bin" = {
			source = create_symlink "${dotfiles}/.local/bin";
			recursive = true;
		};
		".local/share/konsole" = {
			source = create_symlink "${dotfiles}/.local/share/konsole";
			recursive = true;
		};
	};

	home.packages = with pkgs; [
		yazi
		mpv
		fish
		zellij
		xdg-desktop-portal
		xdg-desktop-portal-wlr
		kdePackages.konsole
		kdePackages.polkit-kde-agent-1
		python3
	] ++ [
		pkgs-unstable.noctalia
		pkgs-unstable.pipx
		(pkgs-unstable.discord.override {
			withVencord = true;
		})
		pkgs-unstable.gamescope
		pkgs-unstable.mangohud
	] ++ [
		millennium.packages.${pkgs.system}.millennium-steam
	];	
}
