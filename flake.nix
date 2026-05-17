{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable"; # used for some packages
    nixos-grub-themes.url = "github:jeslie0/nixos-grub-themes";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    caelestia-shell = {
      # based on quickshell. See https://github.com/caelestia-dots/shell
      url = "github:caelestia-dots/shell";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    microPlugins-vivify = {
	  url = "git+https://codeberg.org/gibbert/micro-vivify";
	  flake = false;
    };
  };
  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
    nixos-grub-themes,
    caelestia-shell,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    
    pkgs = import nixpkgs {
      inherit system;

      config.allowUnfreePredicate = pkg:
        builtins.elem (nixpkgs.lib.getName pkg) [
          "hplip"
          "vivify.vim"
          "cheatsheet.nvim"
        ];
      };

    pkgs-unstable = import nixpkgs-unstable {
      inherit system;
      
      config.allowUnfreePredicate = pkg:
        builtins.elem (nixpkgs.lib.getName pkg) [
          "hplip"
          "vivify.vim"
          "cheatsheet.nvim"
        ];
    };

  in {
    nixosConfigurations = {
      laptop = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs pkgs pkgs-unstable;};
        modules = [
          ./hosts/laptop/configuration.nix
        ];
      };
    };
    # we use home-manager directly inside of configuration.nix
  };
}
