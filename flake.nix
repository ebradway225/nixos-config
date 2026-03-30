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
  }: let
    forAllSystems = nixpkgs.lib.genAttrs (import systems);
    lib = nixpkgs.lib // home-manager.lib;
  in {
    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

    checks = forAllSystems (system: {
      pre-commit = inputs.git-hooks.lib.${system}.run {
        src = ./.;
        hooks = {
          alejandra.enable = true;
        };
      };
    });

    nixosConfigurations = {
      asus-gaming-laptop = nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";
        modules = [
          ./asus-gaming-laptop/configuration.nix
        ];
        specialArgs = { inherit inputs; };
      };

      # nixos-anywhere --flake .#desktop-pc --generate-hardware-config nixos-generate-config ./desktop-pc/hardware-configuration.nix desktop-pc
      desktop-pc = nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";
        modules = [
          ./desktop-pc/configuration.nix
          disko.nixosModules.disko
          ./desktop-pc/hardware-configuration.nix
        ];
        specialArgs = { inherit inputs; };
      };
    };

    homeConfigurations = {
      "ethanb@asus-gaming-laptop" = lib.homeManagerConfiguration {
        modules = [./home.nix];
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = {inherit inputs;};
      };

      "ethanb@desktop-pc" = lib.homeManagerConfiguration {
        modules = [./home.nix];
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = {inherit inputs;};
      };
    };
  };
}
