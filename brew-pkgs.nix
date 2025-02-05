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
      "cemu"
      "keyclu"
      "maccy"
      "loop"
      "dropshelf"
      "middleclick"
      "linearmouse"
      "vmware-fusion"
      "autodesk-fusion"
      "spaceid"
      "hammerspoon"
      "karabiner-elements"
      "hiddenbar"
      "qutebrowser"
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
