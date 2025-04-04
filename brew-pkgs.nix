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
      "pablopunk/brew/swift-shift"
      "keyboardcleantool"
      "altserver"
      "obs"
      "duet"
      "arduino-ide"
      "wine-stable"
      "steam"
      "processing"
      #"ultimaker-cura"
      "kicad"
      "ghdl"
      #"kdenlive"
      #"handbrake"
      #"orca-slicer"
      "ultimaker-cura"
      "creality-print"
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
    ];
    brews = [
      "winetricks"
      "cava"
      "figlet"
      "cowsay"
      "mas"
      "inetutils"
      #maxim sdk depens
      "libusb-compat"
      "libftdi"
      "hidapi"
      "libusb"
      "platformio"
      "cmake"
      "ninja"
      "dfu-util"
    ];
    masApps = {
      "whatsapp" = 310633997;
      "plash" = 1494023538;
      "pipifier" = 1160374471; 
    };
  };
}
