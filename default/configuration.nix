# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, inputs, ... }:

{ 
  services.xserver.enable = true;
  services.xserver.displayManager.gdm = {
    enable=true;
    wayland=true;
  };
  imports =
    [ # Include the results of the hardware scan.
      inputs.home-manager.nixosModules.default
    ];
    # make zsh default shell for all users
   users.defaultUserShell = pkgs.zsh;
   programs.zsh.enable=true;
  # Unfree Packages
   nixpkgs.config.allowUnfree = true;

  # flatpak
   services.flatpak.enable = true;
   xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
   xdg.portal.enable = true;

  # Home manager
   home-manager = {
       useGlobalPkgs = true;
       useUserPackages = true;
      # also pass inputs to home-manager modules
      extraSpecialArgs = {inherit inputs;};
      users = {
        "Kaktus" = import ./home.nix;
      };
   };
  # windows aplications
   hardware.spacenavd.enable=true;
  # devenv
   nix.extraOptions = ''
    trusted-users = root Kaktus
   '';
  # Hyprland
  programs.hyprland.enable = true;

# Define a user account. Don't forget to set a password with ‘passwd’.
   users.users.Kaktus= {
     isNormalUser = true;
     extraGroups = [ "wheel" "netdev" ]; # Enable ‘sudo’ for the user.
     packages = with pkgs; [
       # cold start
       firefox
           ];
   };
  # Font Configuration
  fonts = {
    enableDefaultPackages = true;
    fontconfig = {
      enable = true;
      defaultFonts = {
        serif = [  "VictorMono Nerd Font" ];
        sansSerif = [ "VictorMono Nerd Font" ];
        monospace = [ "VictorMono Nerd Font" ];
      };
  };
    packages = with pkgs; [
      (nerdfonts.override { fonts = [ "VictorMono" ]; })
    ];
  };
  environment.sessionVariables = {
    # If your cursor becomes invisible
    WLR_NO_HARDWARE_CURSORS = "1";
    # Hint electron apps to use wayland
    NIXOS_OZONE_WL = "1";
  };
  # Virtualbox
   virtualisation.vmware.guest.enable = true;
   virtualisation.vmware.host.enable = true;
   users.extraGroups.vboxusers.members = [ "Kaktus" ];
   virtualisation.virtualbox.host.enable = true;
   #virtualisation.virtualbox.host.enableExtensionPack = true;

  # docker podman
  virtualisation.containers.enable = true;
  virtualisation = {
    podman = {
      enable = true;
      # Create a `docker` alias for podman, to use it as a drop-in replacement
      dockerCompat = true;
      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;
    };
  };
  # $ nix search wget
   environment.systemPackages = with pkgs; [
     neovim 
     kate # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
     # cold start
     wget
     zsh
     neofetch
     btop
     git
     tree
     home-manager
     lf
     fd
     # sound pkgs
     alsa-utils
     alsa-tools
     pulseaudio-ctl
     pavucontrol
     #bluetooth
     bluetuith
     bluez-tools
     #sistem araçları
     intel-gpu-tools
     gparted
     gptfdisk
     htop
     ncdu
     smartmontools
     nixos-firewall-tool
     zram-generator
     docker
     baobab
     wirelesstools
     brightnessctl
     networkmanagerapplet
     lshw
     xorg.xeyes
     lm_sensors
     unzip
     gcc_multi
     pciutils
     lm_sensors
     spacenavd
     libimobiledevice
     ifuse
     dive 
     podman-tui 
     podman-compose
     tldr
     ];
  system.stateVersion = "24.05"; # Did you read the comment?

}

