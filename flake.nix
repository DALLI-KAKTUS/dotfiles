{
  description = "nix-darwin and home-manager configuration for my Mac";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Controls system level software and settings including fonts
    darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # installs Homebrew itself, so a fresh Mac doesn't need the curl | bash installer
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
  };

  outputs = {
    nixpkgs,
    nixpkgs-unstable,
    darwin,
    ...
  } @ inputs: let
    host = "macOS";
    system = "aarch64-darwin";
    pkgs-unstable = nixpkgs-unstable.legacyPackages.${system};
  in {
    # `nix fmt`
    formatter.${system} = nixpkgs.legacyPackages.${system}.alejandra;

    darwinConfigurations."${host}" = darwin.lib.darwinSystem {
      inherit system;
      specialArgs = {
        inherit pkgs-unstable;
      };
      modules = [
        ./brew-pkgs.nix
        ./darwin-settings.nix
        inputs.nix-homebrew.darwinModules.nix-homebrew
        {
          nix-homebrew = {
            enable = true;
            user = "kaktus";
            # take over the existing /opt/homebrew install instead of failing on it
            autoMigrate = true;
          };
        }
        inputs.home-manager.darwinModules.home-manager
        {
          users.users.kaktus.home = "/Users/kaktus";
          home-manager = {
            useUserPackages = false;
            useGlobalPkgs = true;
            # existing unmanaged files get moved aside instead of failing the switch
            backupFileExtension = "hm-backup";
            extraSpecialArgs = {
              inherit pkgs-unstable;
            };

            users.kaktus.imports = [./home];
          };
        }
      ];
    };
  };
}
