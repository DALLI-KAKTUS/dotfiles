{
  lib,
  pkgs,
  ...
}: let
  appSupport = "Library/Application Support";
  kicad = "Library/Preferences/kicad/10.0";

  # These apps rewrite their settings while running, so a read-only symlink would break them.
  # Each file is copied only when the target is missing: a new Mac gets these values and
  # later changes in the app stay local. Re-export into dotfiles/apps to keep them.
  # History, window state, project paths and secrets are stripped from the copies in the repo.
  seeds = {
    ".config/karabiner/karabiner.json" = ../dotfiles/Karabiner/karabiner.json;
    ".config/qalculate/qalculate-qt.cfg" = ../dotfiles/apps/qalculate/qalculate-qt.cfg;
    ".arduinoIDE/settings.json" = ../dotfiles/apps/arduino/settings.json;
    ".arduinoIDE/arduino-cli.yaml" = ../dotfiles/apps/arduino/arduino-cli.yaml;
    "Library/Thonny/configuration.ini" = ../dotfiles/apps/thonny/configuration.ini;
    "${appSupport}/org.inkscape.Inkscape/config/inkscape/preferences.xml" = ../dotfiles/apps/inkscape/preferences.xml;
    "${kicad}/kicad_common.json" = ../dotfiles/apps/kicad/kicad_common.json;
    "${kicad}/pcbnew.json" = ../dotfiles/apps/kicad/pcbnew.json;
    "${kicad}/eeschema.json" = ../dotfiles/apps/kicad/eeschema.json;
    "${kicad}/user.hotkeys" = ../dotfiles/apps/kicad/user.hotkeys;
    "${kicad}/colors/catppuccin-mocha.json" = ../dotfiles/apps/kicad/colors/catppuccin-mocha.json;
    "${kicad}/colors/user.json" = ../dotfiles/apps/kicad/colors/user.json;
  };

  seedScript = pkgs.writeShellScript "seed-app-settings" (lib.concatStrings (lib.mapAttrsToList (target: source: let
      dest = ''"$HOME"/${lib.escapeShellArg target}'';
    in ''
      if [ ! -e ${dest} ]; then
        mkdir -p "$(dirname ${dest})"
        cp ${source} ${dest}
        chmod u+w ${dest}
      fi
    '')
    seeds));
in {
  home.activation = {
    seedAppSettings = lib.hm.dag.entryAfter ["writeBoundary"] ''
      run ${seedScript}
    '';
    # desktop picture; only touched when it differs, failures (no GUI session) are ignored
    wallpaper = lib.hm.dag.entryAfter ["writeBoundary"] ''
      if [ "$(${pkgs.desktoppr}/bin/desktoppr 2>/dev/null | head -1)" != "${../dotfiles/wallpaper.png}" ]; then
        run ${pkgs.desktoppr}/bin/desktoppr ${../dotfiles/wallpaper.png} || true
      fi
    '';
  };

  # opened at login (Loop starts itself through its own launchAtLogin setting)
  launchd.agents = lib.genAttrs ["Maccy" "Vorssaint" "WhatsApp"] (app: {
    enable = true;
    config = {
      ProgramArguments = ["/usr/bin/open" "-a" app];
      RunAtLoad = true;
    };
  });
}
