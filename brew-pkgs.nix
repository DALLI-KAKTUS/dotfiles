_: {
  homebrew = {
    enable = true;
    # `re` installs what is listed and nothing else; update with `brew update && brew upgrade`
    onActivation = {
      autoUpdate = false;
      # cleanup = "uninstall";
      upgrade = false;
    };
    # third-party taps must be trusted or `brew bundle` refuses their casks and aborts the switch
    taps = [
      {
        name = "Sikarugir-App/sikarugir";
        trusted = true;
      }
      {
        name = "furkankly/tap";
        trusted = true;
      }
    ];
    casks = [
      # "TheBoredTeam/boring-notch/boring-notch"
      "loop"
      "Sikarugir-App/sikarugir/sikarugir"
      # "gerlero/openfoam/openfoam"
      "keyboardcleantool"
      "vorssaint"
      "obs"
      "arduino-ide"
      "thonny"
      "macfuse"
      "pacifist"
      "wine-stable" # disabled by Homebrew, still installed; see README
      "steam"
      "discord"
      "epic-games"
      "vlc"
      "gstreamer-runtime" # disabled by Homebrew, still installed; see README
      "processing"
      "bambu-studio"
      "kicad"
      # "ra3xdh/qucs-s/qucs-s@nightly"
      "inkscape"
      # "ghdl"
      # "kdenlive"
      # "orca-slicer"
      # "ultimaker-cura"
      "creality-print"
      # "waveforms" # digilent
      "blender"
      "freecad"
      # "klayout"
      "libreoffice"
      "qutebrowser" # disabled by Homebrew, still installed here; see README
      "google-chrome"
      # "chatgpt"
      "claude"
      "claude-code"
      # "vmware-fusion"
      # "autodesk-fusion"
      "chirp"
      # system tools
      "maccy"
      "karabiner-elements"
      "wacom-tablet"
      "raspberry-pi-imager"
      "tigervnc"
      # games / launchers
      "curseforge"
      "minecraft"
      "mythic"
      # "uvtools" # disabled by homebrew (fails Gatekeeper), still installed
      "duet" # second display
    ];
    # command line tools live in home/packages.nix; these stay in Homebrew on purpose
    brews = [
      "mas"
      # Homebrew's build prefixes the GNU tools with g (gping, gtelnet...); the Nix one
      # would shadow macOS's own ping, hostname and ifconfig
      "inetutils"
      "mole" # broken in nixpkgs
      # goes with the Homebrew wine; the Nix one pulls zenity, which doesn't build on macOS
      "winetricks"
      # libraries for the Maxim SDK build
      "libusb-compat"
      "libftdi"
      "hidapi"
      "libusb"
      "pkgconf"
      "furkankly/tap/zoetrope"
    ];
    masApps = {
      "whatsapp" = 310633997;
      "plash" = 1494023538;
      "pipifier" = 1160374471;
      "meshtastic" = 1586432531;
      "wireguard" = 1451685025;
      "microsoft-word" = 462054704;
      "keynote" = 409183694;
      "numbers" = 409203825;
      "pages" = 409201541;
    };
  };
}
