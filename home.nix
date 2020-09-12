{ config, pkgs, ... }:

{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "rebores";
  home.homeDirectory = "/home/rebores";

  home.packages = [
    pkgs.xorg.xorgserver
    pkgs.flatpak
    pkgs.fish
    pkgs.tint2
    pkgs.bspwm
    pkgs.pantheon.elementary-greeter
  ];

  programs.git = {
    enable = true;
    userName = "renanreboredo";
    userEmail = "renanrreboredo@gmail.com"; 
  };

  xserver = {
    enable = true;
    libinput.enable = true;
    displayManager.elementary-greeter.enable = true;
    displayManager.elementary-greeter.autoLogin = { enable = true; user = "rebores"; };
    desktopManager.default = "xsession";
    displayManager.session = [
      {
        manage = "desktop";
        name = "xsession";
        start = ''exec $HOME/.xsession'';
      }
    ];
  };

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.

  home.stateVersion = "20.09";
}
