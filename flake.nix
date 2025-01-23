{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-alien.url = "github:thiagokokada/nix-alien";
    grub2-themes.url = "github:vinceliuice/grub2-themes";
    waveforms.url = "github:liff/waveforms-flake";
  };
  outputs = { self, nixpkgs, home-manager, grub2-themes, waveforms, nix-alien, ... }@inputs:
    let
      lib = nixpkgs.lib;
      system = "x86_64-linux";
      host = "default";
    in {
       nixosConfigurations."${host}" = lib.nixosSystem {
          specialArgs = {
          inherit system;
          inherit inputs;
          };
          modules = [
            ./default/hardware-configuration.nix
            ./default/core-configuration.nix
            ./default/configuration.nix
            grub2-themes.nixosModules.default
            home-manager.nixosModules.default
            waveforms.nixosModule # digilent waveforms flake for analog discovery 3
            ({ users.users.Kaktus.extraGroups = [ "plugdev" ]; })
            #nix-alien
            ({nixpkgs.overlays = [ self.inputs.nix-alien.overlays.default];})
          ];
       };
    };
}
