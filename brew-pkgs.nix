{
  pkgs,
  darwin,
  ...
}: {
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      cleanup = "uninstall";
      upgrade = true;
    };
    taps = [
    ];
    casks = [
      "TheBoredTeam/boring-notch/boring-notch"
      "gerlero/openfoam/openfoam"
      "keyboardcleantool"
      "obs"
      "arduino-ide"
      "thonny"
      "macfuse"
      "wine-stable"
      "steam"
      "epic-games"
      "processing"
      "bambu-studio"
      "pronterface"
      "kicad"
      "inkscape"
      "rar"
      #"ghdl"
      #"kdenlive"
      #"orca-slicer"
      #"ultimaker-cura"
      "creality-print"
      "blender"
      "freecad"
      "openscad"
      #"klayout"
      "libreoffice"
      "qutebrowser"
      #"vmware-fusion"
      #"autodesk-fusion"
      "chirp"
      # system tools
      "maccy"
      "karabiner-elements"
      "hammerspoon"
      "wacom-tablet"
      #"raspberry-pi-imager"
      #"vnc-viewer"
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
      #maxim sdk depens
      "libusb-compat"
      "libftdi"
      "hidapi"
      "libusb"
      "platformio"
      "cmake"
      "ninja"
      "dfu-util"
      "pkg-config"
      "libusb"
    ];
    masApps = {
      "whatsapp" = 310633997;
      "plash" = 1494023538;
      "pipifier" = 1160374471;
      "meshtastic" = 1586432531;
    };
  };
}
