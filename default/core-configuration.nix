{
  config,
  lib,
  pkgs,
  ...
}: {
  # Flakes özelliğini etkinleştir
  nix.settings.experimental-features = ["nix-command" "flakes"];

  services.usbmuxd.enable = true; # USB Muxer servisini etkinleştir

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
    footer = true; # Alt bilgi ekle
    customResolution = "1920x1080"; # Özel çözünürlük ayarı (isteğe bağlı)
  };

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

  # Klavye ayarları
  services.xserver.xkb.layout = "tr"; # Türkçe klavye düzeni

  # Yazıcıları etkinleştir
  services.printing.enable = true; # CUPS ile belgeleri yazdırmayı etkinleştir

  # Ses ayarları
  # hardware.pulseaudio.enable = true; # PulseAudio'yu etkinleştir
  # OR
  hardware.pulseaudio.enable = false; # PulseAudio'yu devre dışı bırak
  services.pipewire = {
    enable = true; # PipeWire'ı etkinleştir
    alsa.enable = true; # ALSA'yı etkinleştir
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

  # NVIDIA ayarları
  hardware.opengl = {
    enable = true; # OpenGL desteğini etkinleştir
  };

  # Xorg ve Wayland için NVIDIA sürücülerini yükle
  services.xserver.videoDrivers = [
    "nvidia" # NVIDIA sürücüsü
    "vmware" # VMware sürücüsü
  ];

  hardware.nvidia = {
    # Modesetting gereklidir.
    modesetting.enable = true; # Modesetting'i etkinleştir

    # NVIDIA güç yönetimi. Deneysel, uyku/askıya alma sorunlarına yol açabilir.
    powerManagement.enable = false; # Güç yönetimini devre dışı bırak
    powerManagement.finegrained = false; # İnce güç yönetimini devre dışı bırak

    # NVidia açık kaynaklı çekirdek modülünü kullan
    open = false; # Kapalı sürüm kullan

    # NVIDIA ayarları menüsünü etkinleştir
    nvidiaSettings = true; # nvidia-settings erişimi

    # GPU'nuz için uygun sürücü sürümünü seçin.
    package = config.boot.kernelPackages.nvidiaPackages.stable; # Stabil NVIDIA paketi

    prime = {
      # Senkronizasyon modu kullanılıyor, gerekirse offload modu denenecek
      sync.enable = true; # Senkronizasyonu etkinleştir
      # Sisteminiz için doğru Bus ID değerlerini kullandığınızdan emin olun!
      intelBusId = "PCI:0:2:0"; # Intel Bus ID
      nvidiaBusId = "PCI:1:0:0"; # NVIDIA Bus ID
      # amdgpuBusId = "PCI:54:0:0"; # AMD GPU için (isteğe bağlı)
    };
  };

  # TLP hizmetlerini etkinleştir
  services.thermald.enable = true; # Termal yönetimi etkinleştir
  services.tlp = {
    enable = true; # TLP'yi etkinleştir
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance"; # AC'de CPU ölçeklendirme yöneticisi
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave"; # Bataryada CPU ölçeklendirme yöneticisi

      CPU_ENERGY_PERF_POLICY_ON_BAT = "power"; # Bataryada enerji performans politikası
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance"; # AC'de enerji performans politikası

      CPU_MIN_PERF_ON_AC = 0; # AC'de minimum performans
      CPU_MAX_PERF_ON_AC = 100; # AC'de maksimum performans
      CPU_MIN_PERF_ON_BAT = 0; # Bataryada minimum performans
      CPU_MAX_PERF_ON_BAT = 20; # Bataryada maksimum performans

      # Uzun vadeli batarya sağlığına yardımcı olmak için isteğe bağlı
      START_CHARGE_THRESH_BAT0 = 40; # 40 ve altındaki değerlerde şarj başlat
      STOP_CHARGE_THRESH_BAT0 = 80; # 80 ve üzerindeki değerlerde şarjı durdur
    };
  };

  # Bazı programlar SUID sarıcılarına ihtiyaç duyar, daha fazla yapılandırılabilir veya
  # kullanıcı oturumlarında başlatılabilir.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # Hangi servisleri etkinleştirmek istediğinizi listeleyin:

  # OpenSSH daemon'unu etkinleştir.
  # services.openssh.enable = true;

  # Güvenlik duvarında açık portları ayarla.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Ya da güvenlik duvarını tamamen devre dışı bırak.
  # networking.firewall.enable = false;

  # NixOS yapılandırma dosyasını kopyala ve sonuç sistemden bağlantı kur
  # (/run/current-system/configuration.nix). Bu, yanlışlıkla yapılandırma.nix dosyasını silerseniz
  # yararlıdır.
  # system.copySystemConfiguration = true;
}
