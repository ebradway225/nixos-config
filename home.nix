{
  config,
  pkgs,
  ...
}: {
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "ethanb";
  home.homeDirectory = "/home/ethanb";

  programs.git = {
    enable = true;
    userName = "Ethan Bradway";
    userEmail = "ebradway225@gmail.com";
  };

  programs.jujutsu = {
    enable = true;
    settings = {
      user = {
        name = "Ethan Bradway";
        email = "ebradway225@gmail.com";
      };
    };
  };

  # Enable bash intregration.
  programs.bash.enable = true;

  # Install fzf.
  programs.fzf.enable = true;

  home.packages = with pkgs; [
    google-chrome
    kdePackages.kate
    nil
  ];

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "25.05";
}
