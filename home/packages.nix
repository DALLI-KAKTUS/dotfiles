{pkgs, ...}: {
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
    libqalculate

    # GUI apps
    vscode #only for platformio i am not gay
    obsidian
    qalculate-qt
    logisim-evolution
    #logisim
    #gtkwave
    #gnuplot
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
        # python paketleri
        pyserial # esp32'nin çalışması için gerekli
        scipy
        pandas
        matplotlib
        scikit-learn
        uv
        intelhex
        pyusb
      ]))

    # Language Servers
    nil
    vhdl-ls
    svls
    pyright

    # Formatters
    stylua
    black
    isort
    prettierd
    rustfmt
    alejandra
  ];
  programs.java.enable = true;
}
