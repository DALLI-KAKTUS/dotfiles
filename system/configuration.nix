{ config, pkgs, ... }:

{
  config = {
    nixpkgs.hostPlatform = "x86_64-linux";

    environment.systemPackages = [
      pkgs.zsh
      pkgs.git
      pkgs.curl
      pkgs.vim
      pkgs.shadow
      pkgs.kitty
    ];

    # Zsh'i guvenli kabuk listesine ekle
    environment.etc."shells" = {
      text = ''
        /bin/sh
        /bin/bash
        /usr/bin/bash
        ${pkgs.zsh}/bin/zsh
      '';
      mode = "0644";
    };
# dalli_server kullanicisinin olusturulmasi
users.groups.dalli_server = {};
users.users.dalli_server = {
      enable = true; 
      isNormalUser = true;
      group = "dalli_server";
      extraGroups = [ "sudo" ];
      home = "/home/dalli_server";
      createHome = true;
      
      # HATA VEREN SATIR:
      # shell = pkgs.zsh; 

      # DUZELTILMIS SATIR (String Interpolation kullanilarak mutlak yol belirtilir):
      shell = "${pkgs.zsh}/bin/zsh"; 
    };
  };
}
