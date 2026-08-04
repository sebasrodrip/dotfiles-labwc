{ config, lib, pkgs, ... }:

{
  imports =
    [ 
      ./hardware-configuration.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "nixos-vm";

  networking.networkmanager.enable = true;
  
  time.timeZone = "America/Costa_Rica";
  
 # services.xserver = {
 # 	enable = true;
 #	autoRepeatDelay = 200;
 #	autoRepeatInterval = 35;
 #	windowManager.qtile.enable = true;
 # };
  

  services.displayManager.ly.enable = true;
  
  services.pipewire.enable = true;  

  services.xserver.desktopManager.xfce.waylandSessionCompositor = ""; 
	
  users.users.nixos-vm = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    packages = with pkgs; [
      tree
    ];
  };

  programs.firefox.enable = true;
  programs.labwc.enable = true;

  nixpkgs.config.allowUnfree = true;
  #nixpkgs.overlays = [ inputs.millennium.overlays.default ];
  
  environment.systemPackages = with pkgs; [
    vim
    micro 
    wget
    git
    alacritty
    labwc
  ];
  
  fonts.packages = with pkgs; [
    nerd-fonts.iosevka
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];


 system.stateVersion = "26.05"; 

}

