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
      "microsoft-teams"
      "keyboardcleantool"
      "obs"
      "duet"
      "arduino-ide"
      "thonny"
      "wine-stable"
      "steam"
      "mythic"
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
      #"creality-print"
      "blender"
      "freecad"
      "klayout"
      "libreoffice"
      #"ferdium"
      "qutebrowser"
      #"vmware-fusion"
      "autodesk-fusion"
      "chirp"
      # system tools
      "maccy"
      "karabiner-elements"
      "hammerspoon"
      "wacom-tablet"
      #"raspberry-pi-imager"
      #"vnc-viewer"
      "minecraft"
      "curseforge"
    ];
    brews = [
      "winetricks"
      "cava"
      "figlet"
      "cowsay"
      "mas"
      "inetutils"
      "openjdk"
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
      "qdmr"
    ];
    masApps = {
      "whatsapp" = 310633997;
      "plash" = 1494023538;
      "pipifier" = 1160374471;
      "meshtastic" = 1586432531;
    };
  };
}
