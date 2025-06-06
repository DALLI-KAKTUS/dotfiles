{
  pkgs,
  darwin,
  ...
}: {
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      #cleanup = "uninstall";
      upgrade = true;
    };
    taps = [
    ];
    casks = [
      "chatgpt" # delete it
      "keyboardcleantool"
      "obs"
      "duet"
      "arduino-ide"
      "wine-stable"
      "steam"
      "processing"
      #"ultimaker-cura"
      "bambu-studio"
      "pronterface"
      "kicad"
      "ghdl"
      #"kdenlive"
      #"handbrake"
      #"orca-slicer"
      "ultimaker-cura"
      #"creality-print"
      #"blender"
      #"freecad"
      "libreoffice"
      #"ferdium"
      "qutebrowser"
      "cemu"
      "vmware-fusion"
      "autodesk-fusion"
      "chirp"
      # system tools
      "keyclu"
      "maccy"
      "middleclick"
      "linearmouse"
      "spaceid"
      "karabiner-elements"
      "hammerspoon"
      "hiddenbar"
      "wacom-tablet"
      "raspberry-pi-imager"
      "vnc-viewer"
      "minecraft"
      "curseforge"
      "osu"
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
