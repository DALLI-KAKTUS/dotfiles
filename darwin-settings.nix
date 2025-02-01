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
        autohide = true;
        autohide-delay = 0.16;
        mru-spaces = false;
        largesize = 64;
        magnification = true;
        mouse-over-hilite-stack = true;
        wvous-bl-corner = 11;
      };
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
      };
      WindowManager.GloballyEnabled = false; # stage manager
      trackpad = {
        Clicking = true;
        TrackpadThreeFingerDrag = true;
      };
    };
    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToEscape = true;
    };
  };
  # backwards compat; don't change
  system.stateVersion = 5;
}
