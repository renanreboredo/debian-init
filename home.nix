{ pkgs, ... }:

{
  home.packages = with pkgs; [
    dmenu     # for app launcher
    feh       # for background image
    i3
    i3lock    # screen lock
    i3status  # sys info
    scrot     # for screenshot

    # xorg.utilmacros
    # xorg.xcursorgen
    # xorg.xcursorthemes
  ];

  nixpkgs.config.packageOverrides = pkgs: {
    i3 = pkgs.stdenv.lib.overrideDerivation pkgs.i3 (oldAttrs: rec {
        src = pkgs.fetchgit {
            url = "http://github.com/Airblader/i3.git";
            rev = "refs/heads/gaps-next";
            sha256 = "81b2c65663c3ce13a7e62f233d5d902fe50dd0356b7a239807f30230c40670d5";
        };

        postUnpack = ''
            find .
            echo -n "4.10.2 (2015-07-14, branch \\\"gaps-next\\\")" > ./i3/I3_VERSION
            echo -n "4.10.2" > ./i3/VERSION
        '';
        });
    };

  services.xserver = {
    windowManager = {
      i3.enable = true;
      default = "i3";
    };

    # displayManager = {
    #   sessionCommands = "i3status &";
    # };

    desktopManager = {
      default = "none";
      xterm.enable = false;
    };
  };
}

# {
#   # Let Home Manager install and manage itself.
#   programs.home-manager.enable = true;

#   # Home Manager needs a bit of information about you and the
#   # paths it should manage.
#   home.username = "rebores";
#   home.homeDirectory = "/home/rebores";

#   home.packages = [
#     pkgs.xorg.xorgserver
#     pkgs.flatpak
#     pkgs.fish
#     pkgs.tint2
#     pkgs.bspwm
#     pkgs.pantheon.elementary-greeter
#   ];

#   programs.git = {
#     enable = true;
#     userName = "renanreboredo";
#     userEmail = "renanrreboredo@gmail.com"; 
#   };

#   xserver = {
#     enable = true;
#     libinput.enable = true;
#     displayManager.elementary-greeter.enable = true;
#     displayManager.elementary-greeter.autoLogin = { enable = true; user = "rebores"; };
#     desktopManager.default = "xsession";
#     displayManager.session = [
#       {
#         manage = "desktop";
#         name = "xsession";
#         start = ''exec $HOME/.xsession'';
#       }
#     ];
#   };

#   # This value determines the Home Manager release that your
#   # configuration is compatible with. This helps avoid breakage
#   # when a new Home Manager release introduces backwards
#   # incompatible changes.
#   #
#   # You can update Home Manager without changing this value. See
#   # the Home Manager release notes for a list of state version
#   # changes in each release.

#   home.stateVersion = "20.09";
# }
