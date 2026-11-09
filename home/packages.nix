{pkgs, ...}: let
  py = pkgs.python313Packages;
  # gds3xtrude (GDS layouts to OpenSCAD) and the old solidpython 1.x it needs aren't in
  # nixpkgs; they used to be `pip install --user` packages
  solidpython = py.buildPythonPackage rec {
    pname = "solidpython";
    version = "1.1.3";
    format = "wheel";
    src = pkgs.fetchPypi {
      inherit pname version format;
      dist = "py3";
      python = "py3";
      hash = "sha256-BiiZuorvPj5pN21M0QbebPx1kAKpe3i5py1+6St9i5Y=";
    };
    dependencies = with py; [euclid3 ply prettytable pypng];
    # it pins PrettyTable 0.7.2 and pypng 0.0.19; the newer ones work for what it uses
    pythonRelaxDeps = true;
  };
  gds3xtrude = py.buildPythonPackage rec {
    pname = "gds3xtrude";
    version = "0.0.13";
    pyproject = true;
    src = pkgs.fetchPypi {
      inherit pname version;
      hash = "sha256-bAraBuIPZaQABt3nINr8qkM/UTl/nK8HMtdnS1B6GRk=";
    };
    build-system = [py.setuptools];
    dependencies = [solidpython];
  };
in {
  home.packages = with pkgs; [
    # CLI tools
    krabby
    fastfetch
    asciiquarium-transparent
    cbonsai
    tree
    fd
    ncdu
    #baobab
    nh
    duf
    sd
    bat
    ripgrep
    ripgrep-all
    tldr
    dos2unix
    wget
    ed
    exif
    zip
    unzip
    p7zip
    sshfs-fuse
    devenv
    figlet
    cowsay
    cava
    gnuplot

    # Embedded and build tools
    cmake
    ninja
    bear
    dfu-util
    platformio-core
    qdmr
    wireguard-tools

    # KiKit has to run in KiCad's own Python (it imports pcbnew). It is installed into that
    # Python's user site on first use, which survives KiCad updates; the KiKit PCM plugin
    # inside KiCad uses the same install.
    (writeShellScriptBin "kikit" ''
      py=/Applications/KiCad/KiCad.app/Contents/Frameworks/Python.framework/Versions/Current/bin/python3
      if ! "$py" -c 'import kikit' 2>/dev/null; then
        echo "kikit: installing KiKit into KiCad's Python (one time)" >&2
        "$py" -m pip install --user --quiet kikit || exit 1
      fi
      exec "$py" -m kikit.ui "$@"
    '')

    # GUI apps
    openscad
    printrun # pronterface
    rar
    gcc-arm-embedded
    mpv # qutebrowser's ,m plays the hinted link here
    obsidian
    qalculate-qt
    logisim-evolution
    #logisim
    #gtkwave
    #audacity
    #gimp
    #zathura
    #firebird-emu
    #gnuradio

    # Dev
    tectonic
    esptool
    #nodejs_22
    (python313.withPackages (ps:
      with ps; [
        pyserial # needed by esptool for ESP32
        scipy
        pandas
        matplotlib
        scikit-learn
        uv
        intelhex
        pyusb
        gds3xtrude
      ]))

    # Language Servers
    lua-language-server
    typescript-language-server
    solargraph
    vscode-langservers-extracted # html
    nil
    vhdl-ls
    svls
    pyright

    # Formatters
    stylua
    black
    isort
    prettierd
    prettier
    rustfmt
    alejandra
  ];
  programs.java.enable = true;
}
