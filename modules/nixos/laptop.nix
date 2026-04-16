{
  config,
  pkgs,
  ...
}: {
  # NVIDIA drivers for laptop (Optimus)
  services.xserver.videoDrivers = [
    "modesetting"
    "nvidia"
  ];

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = true;
    open = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    prime = {
      intelBusId = "PCI:1:0:0";
      nvidiaBusId = "PCI:0:2:0";
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
    };
  };

  environment.systemPackages = with pkgs; let
    patchDesktop = pkg: appName: from: to:
      lib.hiPrio (
        pkgs.runCommand "$patched-desktop-entry-for-${appName}" {} ''
          ${coreutils}/bin/mkdir -p $out/share/applications
          ${gnused}/bin/sed 's#${from}#${to}#g' < ${pkg}/share/applications/${appName}.desktop > $out/share/applications/${appName}.desktop
        ''
      );
    GPUOffloadApp = pkg: desktopName: patchDesktop pkg desktopName "^Exec=" "Exec=nvidia-offload ";
  in [
    (GPUOffloadApp steam "steam")
  ];
}
