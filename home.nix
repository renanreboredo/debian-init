{ config, pkgs, ... }:

let
  homedir = builtins.getEnv "HOME";
  hostname = builtins.getEnv "HOSTNAME";
  gitCommitTemplate = ./lib/git-commit-template;
  gpgid = "D09299626FA78AF8";
  cmdtree = pkgs.stdenv.mkDerivation {
    name = "cmdtree";
    src = fetchGit {
      url = "https://git.sr.ht/~jb55/cmdtree";
      ref = "master";
      rev = "5606078e8fa02462f0208d9f9cad98c7673812e6";
    };
    buildPhase = ''
      cp ${./lib/cfg.def.h} ./cfg.def.h
      make
    '';
    installPhase = ''
      mkdir -p $out/bin
      cp ./cmdtree $out/bin
    '';
    buildInputs = [ pkgs.xorg.libX11 pkgs.xorg.libXft ];
  };

  base16-scheme = "spacemacs";
  base16 = pkgs.stdenv.mkDerivation {
    name = "base16-builder";
    src = builtins.fetchTarball {
      url = "https://github.com/auduchinok/base16-builder/archive/51e3ad4d447fc3f1f539d0bfe33c851728fb6b5f.tar.gz";
      sha256 = "1qir689h38c6jr7fbbqbc3029544zgv41lrrqdcq26kcwxcwjrz1";
    };
    nativeBuildInputs = [pkgs.ruby];
    buildPhase = "${pkgs.ruby}/bin/ruby base16 -s schemes/${base16-scheme}.yml";
    installPhase = ''
      mkdir -p $out
      cp -r output/* $out
    '';
  };
  theme = lib.removeSuffix "\n" (builtins.readFile "${homedir}/.local/share/xtheme");
  xresources = "${base16}/xresources/base16-${base16-scheme}.${theme}.xresources";

  colors = { # derived from spacemacs
    "dark" = {
      highlight = "#5d4d7a";
      background = "#292b2e";
      foreground = "#b2b2b2";
    };
    "light" = {
      highlight = "#67b11d";
      background = "#f6f1e1";
      foreground = "#655370";
    };
  };
in
{
  imports = [
    ./lib/common.nix
    ./lib/email.nix
  ];
  home = {
    keyboard.options = [ "caps:ctrl_modifier" ];
    file = {
      mutt = {
        text = (builtins.readFile ./lib/muttrc) +
          (builtins.readFile ./lib/mutt/solarized.muttrc);
        target = ".muttrc";
      };
      mailcap = {
        source = ./lib/mailcap;
        target = ".mailcap";
      };
    };

    packages = with pkgs; [
      beets
      bind
      blueman
      cmdtree
      dict
      dmenu
      dolphin
      exercism
      feh
      flameshot
      glibcLocales # rofi locale fix -- https://github.com/rycee/home-manager/issues/354#issuecomment-415914278
      gnumake
      gnupg
      gopher
      hledger-ui
      hledger-web
      keybase-gui
      ledger
      libnotify
      minitube
      mononoki
      mplayer
      msmtp
      muchsync
      mumble
      neomutt
      obs-studio
      pandoc
      pasystray
      pavucontrol
      pdftk
      pinentry
      qutebrowser
      sqlite
      tdesktop
      terminus
      texlive.combined.scheme-full
      usbutils
      utillinux
      vlc
      xdotool
      xorg.xmodmap
      xournal
      xterm
      yank
      youtube-dl
      zathura

      # languages i regularly use
      clojure
      (haskellPackages.ghcWithPackages (ps: with ps; [hledger])) # for hledger scripting
      guile
      ocaml
      python3
      lispPackages.quicklisp
      sbcl
    ];
  };
  fonts.fontconfig.enable = true;

  xresources = {
    properties = {
      "XTerm*font" = "-*-FiraMono-medium-r-normal--18-*-*-*-*-*-iso10646-1";
      "XTerm*faceName" = "FireMono";
      "XTerm*faceSize" = "10";
      "XTerm*termName" = "xterm-256color";
      "XTerm*metaSendsEscape" = true;
      "XTerm*utf8" = true;
      #"Xautolock.time:" = 1;
      #"Xautolock.locker:" = "xlock";
      #"Xautolock.corners:" = "+0-0";
      #"Xautolock.cornerdelay:" = 3;
      #"Xautolock.notify:" = 30;
      #"Xautolock.notifier:" = "notify-send -u critical -t 10000 -- 'Locking screen in 30 seconds'";
    };
    extraConfig = builtins.readFile(xresources);
  };

  services = {
    lorri.enable = true;
    emacs.enable = true;
    network-manager-applet.enable = true;

    kbfs.enable = true;
    keybase.enable = true;

    mbsync = {
      enable = true; #if hostname == "lithium" then true else false;
      frequency = "*:0/15";
      postExec = "${pkgs.notmuch}/bin/notmuch new";
    };

    polybar = {
      # https://github.com/0x746866/dots/blob/master/polybar/config
      enable = true;
      config = {
        "bar/top" = {
          background = colors."${theme}".background;
          font-0 = "FiraSans:size=16";
          font-1 = "Font Awesome 5:pixelsize=11;1";
          font-2 = "MaterialIcons:size=10:antialias=false;2";
          foreground = colors."${theme}".foreground;
          height = "30";
          module-margin = 1;
          modules-center = "date";
          modules-left = "volume-bar";
          modules-right = [ "battery" "cpu" "mem" "temp" ];
          monitor = "\${env:MONITOR:HDMI-1}";
          monitor-fallback = "\${env:MONITOR:eDP-1}";
          radius = 0;
          separator = "|";
          tray-background = colors."${theme}".background;
          tray-detached = false;
          tray-maxsize = 16;
          tray-offset-x = 0;
          tray-offset-y = 0;
          tray-padding = 0;
          tray-position = "right";
          tray-scale = 1;
          width = "100%";
        };
        "module/date" = {
          type = "internal/date";
          internal = 5;
          date = "%Y.%m.%d";
          time = "%H.%M";
          label = "%date%..%time%";
        };
        "module/battery" = {
          type = "internal/battery";
          battery = "BAT0";
          adapter = "AC";
          full-at = 99;
        };
        "module/volume-bar" = {
          type = "internal/volume";
          bar-volume-font = 2;
          bar-volume-width = 9;
          format-volume = "<label-volume><bar-volume>";
          label-volume = " .) ";
          label-muted = " .) mute";
          label-volume-foreground = colors.${theme}.foreground;
          format-muted-foreground = colors.${theme}.foreground;
          bar-volume-foreground-0 = colors.${theme}.foreground;
          bar-volume-foreground-1 = colors.${theme}.foreground;
          bar-volume-foreground-2 = colors.${theme}.foreground;
          bar-volume-foreground-3 = colors.${theme}.foreground;
          bar-volume-foreground-4 = colors.${theme}.foreground;
          bar-volume-foreground-5 = colors.${theme}.foreground;
          bar-volume-foreground-6 = colors.${theme}.foreground;
          bar-volume-gradient = true;
          bar-volume-indicator = "•";
          bar-volume-fill = "•";
          bar-volume-empty = "·";
          bar-volume-empty-foreground = colors.${theme}.foreground;
        };
        "module/ethernet" = {
          type = "internal/network";
          interface = "enp1s0";
          label-connected = "eth up: %upspeed:9% down: %downspeed%";
          label-disconnected = "no eth";
        };
        "module/wifi" = {
          type = "internal/network";
          interface = "wlan1";
          label-connected = "wifi up: %upspeed% down: %downspeed%";
          label-disconnected = "no wifi";
        };
        "module/cpu" = {
          type = "internal/cpu";
          interval = 3;
          format-padding = 1;
          format = "<label> <ramp-coreload>";
          label = " %percentage:2%%";
          ramp-coreload-0 = "▂";
          ramp-coreload-1 = "▃";
          ramp-coreload-2 = "▄";
          ramp-coreload-3 = "▅";
          ramp-coreload-4 = "▆";
          ramp-coreload-5 = "▇";
          ramp-coreload-0-foreground = colors.${theme}.foreground;
          ramp-coreload-1-foreground = colors.${theme}.foreground;
          ramp-coreload-2-foreground = colors.${theme}.foreground;
          ramp-coreload-3-foreground = colors.${theme}.foreground;
          ramp-coreload-4-foreground = colors.${theme}.foreground;
          ramp-coreload-5-foreground = colors.${theme}.highlight;
        };
        "module/temp" = {
          type = "internal/temperature";
          interval = 3;
          thermal-zone = 0;
          warn-temperature = 70;
          format = "<ramp> <label>";
          format-padding = 1;
          label = "%temperature-c%";
          ramp-0 = "_";
          ramp-1 = ".";
          ramp-2 = ":";
          ramp-3 = "|";
          ramp-4 = "!!";
          ramp-0-foreground = colors.${theme}.foreground;
          ramp-1-foreground = colors.${theme}.foreground;
          ramp-2-foreground = colors.${theme}.foreground;
          ramp-3-foreground = colors.${theme}.foreground;
          ramp-4-foreground = colors.${theme}.highlight;
          format-warn = "<label-warn>";
          label-warn = "  %temperature-c%";
          label-warn-padding = 1;
          label-warn-foreground = colors.${theme}.highlight;
        };
        "module/mem" = {
          type = "internal/memory";
          interval = 3;
          format = "<label>";
          label-padding = 1;
          label = " |[]| %percentage_used%%";
        };
      };
      script = ''
        polybar top &
      '';
    };

    dunst = {
      enable = true;
      settings = {
        global = {
          geometry = "320x5-10+30";
          transparency = 0;
          frame_color = colors."${theme}".highlight;
          frame_width = 3; # same as xmonad border
          separator_color = "frame";
          font = "Fira Sans";
          background = colors."${theme}".background;
          foreground = colors."${theme}".foreground;
          padding = 10;
          horizontal_padding = 10;
          word_wrap = "yes";
          markup = "full";
          format = "<b>%s</b>\\n%b\\n";
        };

        urgency_normal = {
          background = colors."${theme}".background;
          foreground = colors."${theme}".foreground;
          timeout = 10;
        };
      };
    };

    redshift = {
      enable = true;
      latitude = "37.39";
      longitude = "-122.09";
      temperature = {
        # orange = 1000, white = 5000
        day = 5000;
        night = 2300;
      };
    };

    gpg-agent = {
      enable = true;
      enableScDaemon = true;
      defaultCacheTtl = 72000;
      maxCacheTtl = 7200;
      enableSshSupport = false;
      enableExtraSocket = true;
      verbose = true;
      extraConfig = ''
        allow-emacs-pinentry
        # StreamLocalBindUnlink yes
        # RemoteForward /home/ben/.gnupg/S.gpg-agent /home/ben/.gnupg/S.gpg-agent.extra
      '';
    };
  };

  xsession = {
    enable = true;
    pointerCursor = {
      package = pkgs.vanilla-dmz;
      name = "Vanilla-DMZ";
    };
    windowManager = {
      xmonad = {
        enable = true;
        extraPackages = hpkgs: [
          hpkgs.xmonad-contrib
          hpkgs.xmonad-extras
          hpkgs.monad-logger
          #hpkgs.taffybar
        ];
        enableContribAndExtras = true;
        config = ./lib/xmonad.hs;
      };
    };
  };

  programs = {

    rofi = {
      enable = true;
    };

    notmuch = {
      enable = true;
      hooks.postNew = "${pkgs.afew}/bin/afew -tn && ${pkgs.afew}/bin/afew -t tag:inbox";
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
