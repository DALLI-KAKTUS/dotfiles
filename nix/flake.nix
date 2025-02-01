{
  description = "my minimal flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Controls system level software and settings including fonts
    darwin.url = "github:lnl7/nix-darwin/nix-darwin-24.11";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    # For spotlight search
    mac-app-util.url = "github:hraban/mac-app-util";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    darwin,
    mac-app-util,
    ...
  } @ inputs: let
    lib = darwin.lib;
    host = "macOS";
    system = "aarch64-darwin";
  in {
    darwinConfigurations."${host}" = lib.darwinSystem {
      inherit system;
      modules = [
        ./brew-pkgs.nix
        ./darwin-settings.nix
        mac-app-util.darwinModules.default
        inputs.home-manager.darwinModules.home-manager
        {
          users.users.kaktus.home = "/Users/kaktus";
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.kaktus.imports = [
              ./home-settings.nix
              ./home-programs.nix
              mac-app-util.homeManagerModules.default
              {home.stateVersion = "24.11";}
            ];
          };
        }
      ];
    };
  };
}
