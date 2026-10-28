{pkgs, ...}: let
  # Control Center layout is JSON stored inside plist data values, which CustomUserPreferences can't write
  ccData = name:
    pkgs.writeText "controlcenter-${name}.json"
    (builtins.toJSON (builtins.fromJSON (builtins.readFile (./dotfiles/controlcenter + "/${name}.json"))));
  asUser = ''launchctl asuser "$(id -u -- kaktus)" sudo --user=kaktus --'';
in {
  nix.settings = {
    experimental-features = ["nix-command" "flakes"];
    extra-platforms = ["x86_64-darwin" "aarch64-darwin"];
  };
  # Haftalık otomatik temizlik: 14 günden eski nesilleri sil, store'u optimize et
  nix.gc = {
    automatic = true;
    interval = {
      Weekday = 0;
      Hour = 3;
      Minute = 0;
    };
    options = "--delete-older-than 14d";
  };
  nix.optimise.automatic = true;
  # Unfree Paketler
  nixpkgs.config.allowUnfree = true;
  programs.zsh.enable = true;
  security.pam.services.sudo_local.touchIdAuth = true;

  networking = {
    computerName = "Berke \"KAKTUS\" DİNÇ";
    localHostName = "Berke-KAKTUS-DINC-3";
    applicationFirewall.enable = true;
  };

  system = {
    primaryUser = "kaktus";
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
        show-recents = false;
        showAppExposeGestureEnabled = true;
        showMissionControlGestureEnabled = true;
        expose-group-apps = false; # mission control: don't group windows by app

        # hot corners
        wvous-bl-corner = 11; # launchpad
        wvous-br-corner = 14; # Quick Note
        wvous-tl-corner = 4; # Desktop
        wvous-tr-corner = 12; # Notification Center
        persistent-apps = [
          "/System/Applications/Apps.app"
          "/Applications/Safari.app"
          "${pkgs.kitty}/Applications/kitty.app"
          "/System/Applications/System Settings.app"
          "/System/Applications/iPhone Mirroring.app"
        ];
      };
      NSGlobalDomain = {
        KeyRepeat = 2;
        InitialKeyRepeat = 15;
        NSWindowShouldDragOnGesture = true;
        AppleInterfaceStyleSwitchesAutomatically = true; # auto dark/light
        AppleMeasurementUnits = "Centimeters";
        AppleMetricUnits = 1;
        AppleTemperatureUnit = "Celsius";
        "com.apple.trackpad.scaling" = 1.5; # tracking speed
        "com.apple.sound.beep.volume" = 0.6074452;
      };
      hitoolbox.AppleFnUsageType = "Change Input Source"; # globe key
      menuExtraClock = {
        ShowDate = 2;
        Show24Hour = false;
        ShowAMPM = false;
        FlashDateSeparators = false;
        IsAnalog = true;
        ShowDayOfWeek = false;
        ShowSeconds = false;
      };
      loginwindow.GuestEnabled = false;
      finder = {
        AppleShowAllExtensions = true;
        AppleShowAllFiles = true;
        FXDefaultSearchScope = "SCcf";
        ShowPathbar = true;
        ShowStatusBar = false;
        FXRemoveOldTrashItems = true; # empty trash after 30 days
      };
      controlcenter = {
        BatteryShowPercentage = true;
        Sound = false; # hide sound icon in menu bar
      };
      WindowManager = {
        GloballyEnabled = true; # stage manager
        StageManagerHideWidgets = false;
        EnableTiledWindowMargins = true;
        AppWindowGroupingBehavior = true; # show all windows of an app at once
        AutoHide = false;
        HideDesktop = false;
        StandardHideWidgets = false;
      };

      trackpad = {
        Dragging = true;
        Clicking = true;
        TrackpadThreeFingerDrag = true;
        # three finger swipes are taken by three finger drag
        TrackpadThreeFingerHorizSwipeGesture = 0;
        TrackpadThreeFingerVertSwipeGesture = 0;
        TrackpadThreeFingerTapGesture = 0;
        # light click
        FirstClickThreshold = 0;
        SecondClickThreshold = 0;
      };

      # settings without a dedicated nix-darwin option
      CustomUserPreferences = {
        NSGlobalDomain = {
          AppleActionOnDoubleClick = "Maximize"; # double click title bar
          "com.apple.mouse.scaling" = 1.5;
          # orange accent & highlight color
          AppleAccentColor = 1;
          AppleHighlightColor = "1.000000 0.874510 0.701961 Orange";
          NSGlassTintAmount = 0.4119107; # liquid glass tint
          "com.apple.sound.beep.sound" = "/System/Library/Sounds/Tink.aiff";
          # language & region
          AppleLanguages = ["en-TR" "tr-TR"];
          AppleLocale = "en_TR";
          AppleFirstWeekday.gregorian = 2; # monday
        };
        # keyboard: only Turkish Q
        "com.apple.HIToolbox" = {
          AppleEnabledInputSources = [
            {
              InputSourceKind = "Non Keyboard Input Method";
              "Bundle ID" = "com.apple.CharacterPaletteIM";
            }
            {
              InputSourceKind = "Non Keyboard Input Method";
              "Bundle ID" = "com.apple.PressAndHold";
            }
            {
              InputSourceKind = "Keyboard Layout";
              "KeyboardLayout ID" = -35;
              "KeyboardLayout Name" = "Turkish-QWERTY";
            }
            {
              InputSourceKind = "Non Keyboard Input Method";
              "Bundle ID" = "com.apple.inputmethod.ironwood";
            }
          ];
          AppleSelectedInputSources = [
            {
              InputSourceKind = "Non Keyboard Input Method";
              "Bundle ID" = "com.apple.PressAndHold";
            }
            {
              InputSourceKind = "Keyboard Layout";
              "KeyboardLayout ID" = -35;
              "KeyboardLayout Name" = "Turkish-QWERTY";
            }
          ];
        };
        # menu bar: Control Center items shown and their order (distance from the right edge)
        "com.apple.controlcenter" = {
          "NSStatusItem Visible BentoBox" = true;
          "NSStatusItem Visible Shortcuts" = true;
          "NSStatusItem Visible KeyboardBrightness" = false;
          "NSStatusItem VisibleCC Battery" = true;
          "NSStatusItem VisibleCC BentoBox-0" = true;
          "NSStatusItem VisibleCC Clock" = true;
          "NSStatusItem VisibleCC WiFi" = true;
          "NSStatusItem Preferred Position BentoBox" = 74.0;
          "NSStatusItem Preferred Position WiFi" = 108.0;
          "NSStatusItem Preferred Position BentoBox-0" = 124.0;
          "NSStatusItem Preferred Position Battery" = 146.0;
          "NSStatusItem Preferred Position KeyboardBrightness" = 430.0;
          "NSStatusItem Preferred Position Shortcuts" = 455.0;
        };
        # Control Center modules: 2 = show in menu bar, 8/24 = don't show
        # (Sound and BatteryShowPercentage are set with system.defaults.controlcenter above)
        "~kaktus/Library/Preferences/ByHost/com.apple.controlcenter" = {
          AccessibilityShortcuts = 4;
          AirDrop = 8;
          Battery = 6;
          BatteryShowEnergyMode = 1;
          Bluetooth = 8;
          FocusModes = 8;
          Hearing = 1;
          KeyboardBrightness = 9;
          MusicRecognition = 1;
          NowPlaying = 0;
          ScreenMirroring = 24;
          ShowSuggestions = true;
          Siri = 8;
          Spotlight = 8;
          StageManager = 24;
          UserSwitcher = 8;
          VPN = 8;
          VoiceControl = 8;
          Weather = 8;
          WiFi = 2;
        };
        # input source menu hidden from the menu bar
        "com.apple.TextInputMenu".visible = false;
        "com.apple.TextInputMenuAgent"."NSStatusItem VisibleCC Item-0" = false;
        # screen saver after 5 minutes
        "~kaktus/Library/Preferences/ByHost/com.apple.screensaver".idleTime = 300;
        # don't reopen windows when logging back in
        "com.apple.loginwindow".TALLogoutSavesState = false;
        "com.apple.desktopservices" = {
          # no .DS_Store on network and USB drives
          DSDontWriteNetworkStores = true;
          DSDontWriteUSBStores = true;
        };
        "com.apple.screencapture".showsClicks = true;
        "com.MrKai77.Loop" = import ./dotfiles/loop.nix;
        "com.apple.finder" = import ./dotfiles/finder-views.nix;
        # Siri: on, but no "Hey Siri", no type to Siri, hidden from menu bar
        "com.apple.assistant.support" = {
          "Assistant Enabled" = true;
          "Dictation Enabled" = true;
        };
        "com.apple.Siri" = {
          StatusMenuVisible = false;
          TypeToSiriEnabled = false;
          VoiceTriggerUserEnabled = false;
          ContinuousSpellCheckingEnabled = false;
          GrammarCheckingEnabled = true;
        };
      };
    };
    keyboard = {
      enableKeyMapping = true;
    };
  };
  # Control Center modules, their sizes and order (dotfiles/controlcenter/layout.json)
  # and the controls added to it (controls.json); ControlCenter is restarted to load them
  system.activationScripts.postActivation.text = ''
    echo >&2 "control center layout..."
    ${asUser} defaults write com.apple.controlcenter ControlCenterDisplayableChronoControlsProviderConfiguration -data "$(/usr/bin/xxd -p ${ccData "controls"} | tr -d '\n')"
    ${asUser} defaults -currentHost write com.apple.controlcenter.bentoboxes boxes -data "$(/usr/bin/xxd -p ${ccData "layout"} | tr -d '\n')"
    killall -qu kaktus ControlCenter || true
  '';
  # backwards compat; don't change
  system.stateVersion = 5;
}
