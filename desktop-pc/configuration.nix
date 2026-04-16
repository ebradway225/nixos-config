{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./disk-config.nix
    ../modules/nixos/common.nix
    ../modules/nixos/desktop.nix
  ];

  networking.hostName = "desktop-pc";
}
