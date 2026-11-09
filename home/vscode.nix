{pkgs, ...}: {
  # used for PlatformIO; extensions installed from inside VS Code are kept next to these
  programs.vscode = {
    enable = true;
    profiles.default.extensions = with pkgs.vscode-extensions; [
      platformio.platformio-vscode-ide
      ms-vscode.cpptools
      vscodevim.vim
      catppuccin.catppuccin-vsc
      catppuccin.catppuccin-vsc-icons
    ];
  };
}
