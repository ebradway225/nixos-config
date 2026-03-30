{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.05";

    alejandra.url = "github:kamadorueda/alejandra/4.0.0";
    alejandra.inputs.nixpkgs.follows = "nixpkgs";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    git-hooks.url = "github:cachix/git-hooks.nix";
    git-hooks.inputs.nixpkgs.follows = "nixpkgs";

    treefmt.url = "github:numtide/treefmt";
    treefmt.inputs.nixpkgs.follows = "nixpkgs";

    nixos-hardware.url = "github:NixOS/nixos-hardware";
    nixos-hardware.inputs.nixpkgs.follows = "nixpkgs";

    systems.url = "github:nix-systems/default";
  };

  outputs = inputs @ {
    alejandra,
    disko,
    nixpkgs,
    home-manager,
    git-hooks,
    treefmt,
    nixos-hardware,
    systems,
    ...
  }: {
    nixosConfigurations = {
      asus-gaming-laptop = nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";
        modules = [
          ./asus-gaming-laptop/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.ethanb = ./home.nix;

            # Optionally, use home-manager.extraSpecialArgs to pass
            # arguments to home.nix

            environment.systemPackages = [alejandra.defaultPackage.${system}];
          }
        ];
      };

      # nixos-anywhere --flake .#desktop-pc --generate-hardware-config nixos-generate-config ./desktop-pc/hardware-configuration.nix desktop-pc
      desktop-pc = nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";
        modules = [
          ./desktop-pc/configuration.nix
          disko.nixosModules.disko
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.ethanb = ./home.nix;

            # Optionally, use home-manager.extraSpecialArgs to pass
            # arguments to home.nix

            environment.systemPackages = [alejandra.defaultPackage.${system}];
          }
          ./desktop-pc/hardware-configuration.nix
        ];
      };
    };
  };
}
