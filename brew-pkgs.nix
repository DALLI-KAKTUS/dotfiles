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
      "creality-print"
      #"blender"
      #"freecad"
      "libreoffice"
      #"ferdium"
      "qutebrowser"
      "cemu"
      "vmware-fusion"
      "autodesk-fusion"
      # system tools
      "keyclu"
      "maccy"
      "middleclick"
      "linearmouse"
      "spaceid"
      "karabiner-elements"
      "hammerspoon"
      "hiddenbar"
    ];
    brews = [
      "winetricks"
      "cava"
      "figlet"
      "cowsay"
      "mas"
    ];
    masApps = {
      "whatsapp" = 310633997;
      "plash" = 1494023538;
      "pipifier" = 1160374471; 
    };
  };
}
