{pkgs, ...}: {
  nix.extraOptions = ''
    experimental-features = nix-command flakes
    extra-platforms = x86_64-darwin aarch64-darwin
  '';
  # Unfree Paketler
  nixpkgs.config.allowUnfree = true;
  programs.zsh.enable = true;
  security.pam.enableSudoTouchIdAuth = true;

  system = {
    defaults = {
      dock = {
        orientation = "bottom";
        autohide = true;
        autohide-delay = 0.16;
        autohide-time-modifier = 0.1;
        mru-spaces = false;
        tilesize = 50;
        largesize = 70;
        magnification = true;
        mouse-over-hilite-stack = true;
        mineffect = "genie";
        showhidden = true;
        scroll-to-open = true;
        minimize-to-application = true;

        # hot corners
        wvous-bl-corner = 11; # launchpad
        wvous-br-corner = 14; # Quick Note
        wvous-tl-corner = 4;  # Desktop
        wvous-tr-corner = 12; # Notification Center
        persistent-apps = [
          "/System/Applications/Launchpad.app"
          "/Applications/Safari.app"
          "/Users/kaktus/Applications/Home Manager Trampolines/kitty.app"
          "/System/Applications/System Settings.app"
          "/System/Applications/iPhone Mirroring.app"
        ];
      };
      NSGlobalDomain.KeyRepeat= 2;
      menuExtraClock = {
        ShowDate = 2;
        Show24Hour = false;
        ShowAMPM = false;
        FlashDateSeparators = false;
        IsAnalog = true;
      };
      finder = {
        AppleShowAllExtensions = true;
        AppleShowAllFiles = true;
        FXDefaultSearchScope = "SCcf";
        ShowPathbar = true;
        ShowStatusBar = false;


      };
      WindowManager.GloballyEnabled = false; # stage manager
      trackpad = {
        Clicking = true;
        TrackpadThreeFingerDrag = true;
      };
    };
    keyboard = {
      enableKeyMapping = true;
    };
  };
  # backwards compat; don't change
  system.stateVersion = 5;
}
