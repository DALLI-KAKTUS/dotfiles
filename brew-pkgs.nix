{...}: {
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      # cleanup = "uninstall";
      upgrade = true;
    };
    taps = [
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
      "wine-stable"
      "steam"
      "discord"
      "epic-games"
      "vlc"
      "gstreamer-runtime"
      "processing"
      "bambu-studio"
      "pronterface"
      "kicad"
      # "ra3xdh/qucs-s/qucs-s@nightly"
      "inkscape"
      "rar"
      # "ghdl"
      # "kdenlive"
      # "orca-slicer"
      # "ultimaker-cura"
      "creality-print"
      # "waveforms" # digilent
      "blender"
      "freecad"
      "openscad"
      # "klayout"
      "libreoffice"
      "qutebrowser"
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
      "hammerspoon"
      "wacom-tablet"
      # "gcc-arm-embedded" # upstream checksum broken for 15.3.rel2, re-enable once brew fixes it (still installed)
      "raspberry-pi-imager"
      "tigervnc"
      # games / launchers
      "curseforge"
      "minecraft"
      "mythic"
      # "uvtools" # disabled by homebrew (fails Gatekeeper), still installed
      # system tools
      # "duet" # second display
    ];
    brews = [
      "gnuplot"
      "winetricks"
      "cava"
      "figlet"
      "cowsay"
      "mas"
      "inetutils"
      "openjdk"
      "qdmr"
      "mole"
      "age"
      #maxim sdk depens
      "libusb-compat"
      "libftdi"
      "hidapi"
      "libusb"
      "platformio"
      "bear"
      "cmake"
      "ninja"
      "dfu-util"
      "pkg-config"
      "wireguard-tools"
      "tiger-vnc"
      "furkankly/tap/zoetrope"
    ];
    # masApps = {
    #   "whatsapp" = 310633997;
    #   "plash" = 1494023538;
    #   "pipifier" = 1160374471;
    #   "meshtastic" = 1586432531;
    #   "wireguard" = 1451685025;
    #   "microsoft-word" = 462054704;
    #   "keynote" = 409183694;
    #   "numbers" = 409203825;
    #   "pages" = 409201541;
    # };
  };
}
