{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  services.xserver.enable = true; # X sunucusunu etkinleştir
  services.xserver.displayManager.startx.enable = true; # startx'i etkinleştir
  services.xserver.autorun = true; # Otomatik başlatmayı etkinleştir
  services.xserver.displayManager.gdm = {
    enable = true; # GDM (GNOME Display Manager) etkinleştir
    wayland = true; # Wayland kullan
  };
  programs.dconf.enable = true;
  programs.hyprland.enable = true; #hyprlandi etkinleştir
  services.upower.enable = true; # ags için upower etkinleştir
  imports = [
    # Donanım taramasının sonuçlarını dahil et.
    inputs.home-manager.nixosModules.default
  ];
  
  # zsh'yi tüm kullanıcılar için varsayılan kabuk yap
  users.defaultUserShell = pkgs.zsh;
  programs.zsh.enable = true; # Zsh'yi etkinleştir

  # Unfree Paketler
  nixpkgs.config.allowUnfree = true; # Unfree paketlere izin ver
  # bozuk paketler
  nixpkgs.config.allowBroken = true;
  # güvenli olmayan paketler
  nixpkgs.config.permittedInsecurePackages = [
    "dotnet-runtime-6.0.36"
    "dotnet-sdk-wrapped-6.0.428"
    "dotnet-sdk-6.0.428"
  ];
  # Flatpak
  services.flatpak.enable = true; # Flatpak'ı etkinleştir
  xdg.portal = {
    enable = true; # XDG portalını etkinleştir
    xdgOpenUsePortal = true;
      extraPortals = [
        pkgs.xdg-desktop-portal-gtk
        pkgs.xdg-desktop-portal-hyprland
      ];
  };

  # Home Manager
  home-manager = {
    useGlobalPkgs = true; # Global paketleri kullan
    useUserPackages = true; # Kullanıcı paketlerini kullan
    # Ayrıca home-manager modüllerine girişleri ilet
    extraSpecialArgs = { inherit inputs; };
    users = {
      "Kaktus" = import ./home.nix; # "Kaktus" kullanıcısının ayarlarını dahil et
    };
  };

  # Windows uygulamaları
  hardware.spacenavd.enable = true; # Spacenav desteğini etkinleştir

  # Geliştirme ortamı
  nix.extraOptions = ''
    trusted-users = root Kaktus # Güvenilir kullanıcılar
  '';

  # Steam
  programs.java.enable = true; # Java'yı etkinleştir
  programs.steam.enable = true; # Steam'i etkinleştir
  programs.gamescope.enable = true;
  # Kullanıcı hesabı tanımlama. Şifreyi 'passwd' ile ayarlamayı unutmayın.
  users.users.Kaktus = {
    isNormalUser = true; # Normal kullanıcı olarak tanımla
    extraGroups = ["podman" "input" "uinput" "wheel" "netdev" "networkmanager"]; # Kullanıcıya 'sudo' erişimi sağla (input ve uinput kanata için gerekli)
    packages = with pkgs; [
      firefox # Firefox tarayıcısını ekle
    ];
  };

  # Font Konfigürasyonu
  fonts = {
    enableDefaultPackages = true; # Varsayılan font paketlerini etkinleştir
    fontconfig = {
      enable = true; # Font yapılandırmasını etkinleştir
      defaultFonts = {
        serif = ["VictorMono Nerd Font"]; # Serif font
        sansSerif = ["VictorMono Nerd Font"]; # Sans serif font
        monospace = ["VictorMono Nerd Font"]; # Monospace font
      };
    };
    packages = with pkgs; [
      (nerdfonts.override { fonts = ["VictorMono"]; }) # Nerd fontları
    ];
  };

  environment.sessionVariables = {
    # Electron uygulamalarının Wayland kullanmasını sağla
    NIXOS_OZONE_WL = "1"; # Wayland için Ozone desteği
  };

  # Virtualbox
  virtualisation.vmware.guest.enable = true; # VMware misafir desteğini etkinleştir
  virtualisation.vmware.host.enable = true; # VMware ana bilgisayar desteğini etkinleştir
  users.extraGroups.vboxusers.members = ["Kaktus"]; # Kaktus kullanıcısını vboxusers grubuna ekle
  virtualisation.virtualbox.host.enable = true; # VirtualBox ana bilgisayar desteğini etkinleştir
  # virtualisation.virtualbox.host.enableExtensionPack = true; # Genişletme paketini etkinleştirmek için

  # Docker Podman
  virtualisation.containers.enable = true; # Konteynerleri etkinleştir
  hardware.nvidia-container-toolkit.enable = true; # NVIDIA konteyner aracı desteğini etkinleştir
  virtualisation = {
    podman = {
      enable = true; # Podman'ı etkinleştir
      dockerCompat = true; # Podman'ı, Docker ile birlikte kullan
      defaultNetwork.settings.dns_enabled = true; # Podman-compose ile oluşturulan konteynerler için gerekli

    };
  };

  # search with $ nix search <package>
  environment.systemPackages = with pkgs; [
    
    neovim # Neovim metin editörü
    kate # Yapılandırma.nix dosyasını düzenlemek için bir editör ekle
    # Soğuk başlatma için
    wget # Wget aracı
    zsh # Zsh kabuğu
    neofetch # Sistem bilgilerini görüntülemek için
    btop # Sistem kaynaklarını görüntülemek için
    git # Git sürüm kontrol aracı
    tree # Ağaç yapısını görüntülemek için
    home-manager # Home Manager
    fd # Hızlı dosya bulucu
    python311 # python
  # Ses paketleri
    alsa-utils # ALSA araçları
    alsa-tools # ALSA araçları
    pulseaudio-ctl # PulseAudio kontrol aracı
    pavucontrol # PulseAudio ses kontrolü
    # Bluetooth
    bluetuith # Bluetooth yönetimi için
    bluez-tools # BlueZ araçları
    # Sistem araçları
    gparted # Disk bölümlerini yönetmek için
    gptfdisk # GPT disk bölümleri için
    htop # Etkileşimli sistem izleyici
    ncdu # Disk kullanım analizi
    smartmontools # SMART disk durumu araçları
    nixos-firewall-tool # NixOS güvenlik duvarı aracı
    zram-generator # ZRAM oluşturucu
    baobab # Disk kullanımını görselleştirmek için
    wirelesstools # Kablosuz araçlar
    brightnessctl # Ekran parlaklığını kontrol etmek için
    networkmanagerapplet # Ağ yöneticisi simgesi
    lshw # Donanım bilgilerini görüntülemek için
    xorg.xhost # X sunucusu kontrol aracı
    xorg.xeyes # X göz simülatörü
    lm_sensors # Donanım sensörleri
    unzip # ZIP dosyalarını çıkarmak için
    zip
    gcc_multi # Çoklu GCC desteği
    pciutils # PCI cihaz bilgileri
    lm_sensors # Donanım sensörleri (tekrar eklenmiş, gereksiz olabilir)
    spacenavd # Spacenav desteği
    libimobiledevice # iOS cihazlarıyla etkileşim için
    ifuse # iOS dosya sistemi bağlama aracı
    dive # Docker görüntülerini analiz etmek için
    podman-tui # Podman için metin tabanlı kullanıcı arayüzü
    podman-compose # Podman için bileşen oluşturucu
    tldr # Kısa komut açıklamaları
    steam-run # Steam oyunlarını başlatmak için
    glxinfo # GLX bilgi aracı
    clinfo
    gwe
    nvtop-nvidia
    virtualglLib
    vulkan-loader
    vulkan-tools
    openssl # ssl sertifika aracı
  ];

  system.stateVersion = "24.05"; # Yorum: Bu yapılandırma, NixOS 24.05 sürümüne uygun
}
