{
  config,
  pkgs,
  ...
}: {
  # NVIDIA drivers for desktop
  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # Xbox controller
  hardware.xone.enable = true;

  # OpenSSH
  services.openssh.enable = true;

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHrjbgjxWslXGZttleWWd6HJWgFlOthbbSq9q/EElBFN ethanb@asus-gaming-laptop"
  ];
}
