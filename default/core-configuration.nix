{
  config,
  lib,
  pkgs,
  ...
}: {
  # Flakes özelliğini etkinleştir
  nix.settings.experimental-features = ["nix-command" "flakes"];

  services.usbmuxd.enable = true; # USB Muxer servisini etkinleştir
  # Kernel
  boot.kernelPackages = pkgs.linuxPackages_zen;
  # GRUB EFI önyükleyicisini kullan.
  boot.loader.systemd-boot.enable = false; # systemd-boot'u devre dışı bırak
  boot.loader.grub.enable = true; # GRUB'u etkinleştir
  boot.loader.grub.device = "nodev"; # Önyükleme cihazını ayarla
  boot.loader.grub.useOSProber = true; # Diğer işletim sistemlerini bulmak için OS Prober'ı kullan
  boot.loader.grub.efiSupport = true; # EFI desteğini etkinleştir
  boot.loader.efi.canTouchEfiVariables = true; # EFI değişkenlerine dokunma izni
  boot.loader.efi.efiSysMountPoint = "/boot"; # EFI sistem montaj noktası
  boot.supportedFilesystems = ["ntfs"]; # NTFS dosya sistemini destekle

  # ZRAM yapılandırması
  zramSwap.enable = true; # ZRAM değişim alanını etkinleştir

  # GRUB Teması
  boot.loader.grub2-theme = {
    enable = true; # GRUB temasını etkinleştir
    theme = "tela"; # Tema adı
    icon = "color";
    footer = true; # Alt bilgi ekle
    customResolution = "1920x1080"; # Özel çözünürlük ayarı (isteğe bağlı)
  };
  # suspend sonrası uyandırmada hyprland hata vermesin diye
  boot.kernelParams= [
  ];
  # Ağ ayarları
  # networking.hostName = "DALLI_KAKTUS"; # Ana bilgisayar adını tanımla
  networking.networkmanager.enable = true; # NetworkManager'ı etkinleştir
  services.dnsmasq.enable = true; # DNSMasq'ı etkinleştir
  networking.wireless.enable = true; # wireless'i etkinleştir
  networking.wireless.userControlled.enable = true; # Kullanıcı kontrollü wireless'i etkinleştir

  # Zaman dilimini ayarla
  time.timeZone = "Europe/Istanbul"; # Zaman dilimi ayarı

  # Gerekirse ağ proxy'sini yapılandır
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Uluslararasılaşma ayarları
  i18n.defaultLocale = "en_US.UTF-8"; # Varsayılan yerelleştirme ayarı
  console = {
    font = "Lat2-Terminus16"; # Konsol yazı tipi
    useXkbConfig = true; # TTY'de xkb ayarlarını kullan
  };
  # Mouse aksiyonlrı
  programs.mouse-actions.enable = true;
  # Klavye ayarları
  services.xserver.xkb.layout = "tr"; # Türkçe klavye düzeni
  # kanata için gerekli ayarlar
    services.kanata = {
    enable = true;
    keyboards = {
      "internalKeyboard".config = ''
        (defsrc
          esc
          caps
          lctl

        )

        (deflayer colemak
          caps
          esc
          lctl
        )
      '';
    };
  };

  # Yazıcıları etkinleştir
  services.printing.enable = true; # CUPS ile belgeleri yazdırmayı etkinleştir

  # Ses ayarları
  # hardware.pulseaudio.enable = true; # PulseAudio'yu etkinleştir
  # OR
  hardware.pulseaudio.enable = false; # PulseAudio'yu devre dışı bırak
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true; # PipeWire'ı etkinleştir
    alsa.enable = true; # ALSA'yı etkinleştir
    wireplumber.enable = true; # wireplumber'ı etkinleştir 
    alsa.support32Bit = true; # 32 bit desteği
    pulse.enable = true; # Pulse desteğini etkinleştir
  };

  # Bluetooth ses desteği
  services.pipewire.wireplumber.extraConfig.bluetoothEnhancements = {
    "monitor.bluez.properties" = {
      "bluez5.enable-sbc-xq" = true; # SBC XQ desteğini etkinleştir
      "bluez5.enable-msbc" = true; # mSBC desteğini etkinleştir
      "bluez5.enable-hw-volume" = true; # Donanım ses kontrolünü etkinleştir
      "bluez5.roles" = ["hsp_hs" "hsp_ag" "hfp_hf" "hfp_ag"]; # Bluetooth rollerini ayarla
    };
  };

  # Dokunmatik yüzey desteğini etkinleştir
  services.libinput.enable = true; # Libinput'ı etkinleştir

  # Bluetooth ayarları
  hardware.bluetooth.enable = true; # Bluetooth desteğini etkinleştir
  hardware.bluetooth.powerOnBoot = true; # Başlangıçta Bluetooth'u aç

  # Blueman'ı etkinleştir
  services.blueman.enable = true; # Bluetooth yöneticisi
  # Güç Yönetimi
  services.tlp = {
        enable = true;
        settings = {
          CPU_SCALING_GOVERNOR_ON_AC = "performance";
          CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

          CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
          CPU_ENERGY_PERF_POLICY_ON_BAT = "power";

          CPU_MIN_PERF_ON_AC = 0;
          CPU_MAX_PERF_ON_AC = 100;
          CPU_MIN_PERF_ON_BAT = 0;
          CPU_MAX_PERF_ON_BAT = 50;

         #Optional helps save long term battery health
         #START_CHARGE_THRESH_BAT0 = 40; # 40 and bellow it starts to charge
         #STOP_CHARGE_THRESH_BAT0 = 80; # 80 and above it stops charging

        };
  };
  # NVIDIA ayarları
  hardware.graphics.enable = true;
  #intel için ek paketler
  hardware.graphics.extraPackages = with pkgs; [
    intel-gpu-tools
    intel-media-driver
    vpl-gpu-rt
    libvdpau-va-gl
    nvidia-vaapi-driver
    vaapiIntel
    vaapiVdpau
    vulkan-validation-layers
  ];
  # Xorg ve Wayland için NVIDIA sürücülerini yükle
  services.xserver.videoDrivers = [
    "nvidia" # NVIDIA sürücüsü
    "modesetting" # Intel Sürücüsü
    #"vmware" # VMware sürücüsü
  ];

  hardware.nvidia = {
    # Modesetting gereklidir.
    modesetting.enable = true; # Modesetting'i etkinleştir
    nvidiaPersistenced = true;
    # NVIDIA güç yönetimi. Deneysel, uyku/askıya alma sorunlarına yol açabilir.
    powerManagement.enable = true; # Güç yönetimini devre dışı bırak
    powerManagement.finegrained = true; # İnce güç yönetimini devre dışı bırak
    # NVidia açık kaynaklı çekirdek modülünü kullan
    open = false; # Kapalı sürüm kullan
    # NVIDIA ayarları menüsünü etkinleştir
    nvidiaSettings = true; # nvidia-settings erişimi

    # GPU'nuz için uygun sürücü sürümünü seçin.
    package = config.boot.kernelPackages.nvidiaPackages.production; # Stabil NVIDIA paketi

    prime = {
      # ooffload modu kullanılıyor, gerekirse sync modu denenecek
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
      sync.enable = false; # Senkronizasyonu etkinleştir
      # Sisteminiz için doğru Bus ID değerlerini kullandığınızdan emin olun!
      intelBusId = "PCI:0:2:0"; # Intel Bus ID
      nvidiaBusId = "PCI:1:0:0"; # NVIDIA Bus ID
      # amdgpuBusId = "PCI:54:0:0"; # AMD GPU için (isteğe bağlı)
    };
  };

  services.thermald.enable = true; # Termal yönetimi etkinleştir
}
