{
<<<<<<< HEAD
  description = "my minimal flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Controls system level software and settings including fonts
    darwin.url = "github:lnl7/nix-darwin/nix-darwin-25.11";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    # For spotlight search
    mac-app-util.url = "github:hraban/mac-app-util";
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
    darwin,
    mac-app-util,
    ...
  } @ inputs: let
    lib = darwin.lib;
    host = "macOS";
    system = "aarch64-darwin";
    pkgs-unstable = nixpkgs-unstable.legacyPackages.${system};
  in {
    darwinConfigurations."${host}" = lib.darwinSystem {
      inherit system;
      specialArgs = {
        inherit pkgs-unstable;
      };
      modules = [
        ./brew-pkgs.nix
        ./darwin-settings.nix
        mac-app-util.darwinModules.default
        inputs.home-manager.darwinModules.home-manager
        {
          users.users.kaktus.home = "/Users/kaktus";
          home-manager = {
            useUserPackages = false;
            useGlobalPkgs = true;
            extraSpecialArgs = {
              inherit pkgs-unstable;
            };

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
=======
  description = "Ubuntu Hibrit Yonetim: System Manager + Home Manager";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    system-manager = {
      url = "github:numtide/system-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, system-manager, home-manager }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      systemConfigs = {
        default = system-manager.lib.makeSystemConfig {
          modules = [ ./system/configuration.nix ];
        };
      };
      homeConfigurations = {
        "dalli_server" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./home/home.nix ];
        };
      };
    };
>>>>>>> 4d4cd6e (basladik)
}
