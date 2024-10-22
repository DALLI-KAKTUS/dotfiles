{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    grub2-themes.url = "github:vinceliuice/grub2-themes";
    ags.url = "github:Aylur/ags";
    fhs.url = "github:GermanBread/nixos-fhs/stable";
  };
  outputs = { self, nixpkgs, home-manager, grub2-themes, ags, ... }@inputs:
    let
      lib = nixpkgs.lib;
      system = "x86_64-linux";
    in {
       nixosConfigurations.default = lib.nixosSystem {
          inherit system;
          specialArgs = {inherit inputs;};
          modules = [
            ./default/hardware-configuration.nix
            ./default/core-configuration.nix
            ./default/configuration.nix
            grub2-themes.nixosModules.default
            home-manager.nixosModules.default
            ({ users.users.Kaktus.extraGroups = [ "plugdev" ]; })
          ];
       };
    };
}
