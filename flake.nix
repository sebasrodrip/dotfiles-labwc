{
	description  = "NixOS";
	inputs = {
		nixpkgs.url = "nixpkgs/nixos-26.05";
		nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
		millennium.url = "github:SteamClientHomebrew/Millennium?dir=packages/nix";
		home-manager = {
			url = "github:nix-community/home-manager/release-26.05";
			inputs.nixpkgs.follows = "nixpkgs";
		};	
	};

	outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, millennium,  ... }:
	  let
	  	system = "x86_64-linux";
	  	pkgs-unstable = import nixpkgs-unstable {
	  		inherit system;
	  		config.allowUnfree = true;
	  	};

	  in {
		nixosConfigurations.nixos-vm = nixpkgs.lib.nixosSystem {
			inherit system;
			specialArgs = { inherit pkgs-unstable millennium; };
			modules = [
				./configuration.nix
				home-manager.nixosModules.home-manager
				{
					home-manager = {
						useGlobalPkgs = true;
						useUserPackages = true;
						users.nixos-vm = import ./home.nix;
						backupFileExtension = "backup";
						extraSpecialArgs = { inherit pkgs-unstable millennium; };
					};
				}
			];
		};
	
	};

}
