{ config, lib, pkgs, ... }:

{
  # enable flakes
   nix.settings.experimental-features = [ "nix-command" "flakes" ];

  services.usbmuxd.enable = true;
  # Use GRUB EFI boot loader.
   boot.loader.systemd-boot.enable = false;
   boot.loader.grub.enable = true;
   boot.loader.grub.device = "nodev";
   boot.loader.grub.useOSProber = true;
   boot.loader.grub.efiSupport = true;
   boot.loader.efi.canTouchEfiVariables = true;
   boot.loader.efi.efiSysMountPoint = "/boot";
   boot.supportedFilesystems = [ "ntfs" ];
  # zram
   zramSwap.enable = true;
  # Grub Theme
  boot.loader.grub2-theme = {
    enable = true;
    theme = "tela";
    footer = true;
    customResolution = "1920x1080";  # Optional: Set a custom resolution
  };
  #networking name
   networking.useDHCP = false;
   networking.hostName = "DALLI_KAKTUS"; # Define your hostname.
   networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.
   services.dnsmasq.enable = true;

  # Set your time zone.
   time.timeZone = "Europe/Istanbul";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
   console = {
     font = "Lat2-Terminus16";
     useXkbConfig = true; # use xkb.options in tty.
   };
   
  # Enable the X11 windowing system and xfce4
   services.xserver={
   	enable = true;
	desktopManager = {
	xfce.enable =true;
	};
	xkb.layout = "tr"; # Configure keymap in X11
  };

  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
   services.printing.enable = true;

  # Enable sound.
  # hardware.pulseaudio.enable = true;
  # OR
   hardware.pulseaudio.enable = false;
   services.pipewire = {
     enable = true;
     alsa.enable = true;
     alsa.support32Bit = true;
     pulse.enable = true;
   };
  # Bluetooth audio
   services.pipewire.wireplumber.extraConfig.bluetoothEnhancements = {
      "monitor.bluez.properties" = {
      "bluez5.enable-sbc-xq" = true;
      "bluez5.enable-msbc" = true;
      "bluez5.enable-hw-volume" = true;
      "bluez5.roles" = [ "hsp_hs" "hsp_ag" "hfp_hf" "hfp_ag" ];
       };
    };

  # Enable touchpad support (enabled default in most desktopManager).
   services.libinput.enable = true;

  # bluetooth setup
   hardware.bluetooth.enable = true; # enables support for Bluetooth
   hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot
   services.blueman.enable = true;

  #nvidia
   hardware.opengl = {
    enable = true;
   };
  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = [
    "nvidia"
    "vmware"
  ];

   hardware.nvidia = {

    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    powerManagement.enable = false;
    # Fine-grained power management. Turns off GPU when not in use.
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module
    open = false;

    # Enable the Nvidia settings menu,
	# accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    prime = {
        # sync mode kullanılıyor gerekirse offload mode denenecek
        sync.enable = true;
		# Make sure to use the correct Bus ID values for your system!
		intelBusId = "PCI:0:2:0";
		nvidiaBusId = "PCI:1:0:0";
        # amdgpuBusId = "PCI:54:0:0"; For AMD GPU
	};
  };
  # TLP
  services.thermald.enable = true;
  services.tlp = {
      enable = true;
      settings = {
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

        CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
        CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

        CPU_MIN_PERF_ON_AC = 0;
        CPU_MAX_PERF_ON_AC = 100;
        CPU_MIN_PERF_ON_BAT = 0;
        CPU_MAX_PERF_ON_BAT = 20;

       #Optional helps save long term battery health
       START_CHARGE_THRESH_BAT0 = 40; # 40 and bellow it starts to charge
       STOP_CHARGE_THRESH_BAT0 = 80; # 80 and above it stops charging

      };
};

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

}
