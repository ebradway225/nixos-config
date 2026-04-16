{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../modules/nixos/common.nix
    ../modules/nixos/laptop.nix
  ];

  networking.hostName = "asus-gaming-laptop";
}
