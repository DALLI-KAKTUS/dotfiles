{pkgs-unstable, ...}: let
  # Vim keys (opencode has no vim mode of its own). The tarball is built here from a
  # hash-pinned source so opencode doesn't download the plugin at runtime; to update,
  # change version and hash. v2 support is experimental in the plugin.
  vimcodeVersion = "0.19.2";
  vimcode =
    pkgs-unstable.runCommand "vimcode-${vimcodeVersion}.tgz" {
      src = pkgs-unstable.fetchFromGitHub {
        owner = "oribarilan";
        repo = "vimcode";
        rev = "v${vimcodeVersion}";
        hash = "sha256-semTl23YFmkSRV31Q1/AcbIjKXO7qgUBCqsYUtZYRIo=";
      };
    } ''
      mkdir package
      cp -r $src/package.json $src/LICENSE $src/README.md $src/src package/
      chmod -R u+w package
      tar --sort=name --owner=0 --group=0 --numeric-owner --mtime=@0 -cf - package | gzip -n > $out
    '';
in {
  programs.opencode = {
    enable = true;
    # TODO: TEMPORARY OVERRIDE, the goal is the plain `package = pkgs-unstable.opencode;`
    # Why (opencode 2.2.5, 2026-11): nixpkgs has no Darwin cache for it and the local build
    # is broken. Bun can't verify GitHub's certificate inside the sandbox, and nixpkgs' fixed
    # node_modules hash doesn't match what a Mac produces. nixpkgs doesn't verify outputHash;
    # it was taken from the first build on this Mac.
    # Remove it when this says "will be fetched" without listing builds:
    #   nix build --dry-run nixpkgs/nixos-unstable#opencode
    # If the version changes before then, outputHash needs the new hash,
    # and the build downloads ~5 GB of node_modules plus LLVM/SDK.
    package = pkgs-unstable.opencode.overrideAttrs (old: {
      node_modules = old.node_modules.overrideAttrs (_: {
        preBuild = "export NODE_EXTRA_CA_CERTS=${pkgs-unstable.cacert}/etc/ssl/certs/ca-bundle.crt";
        outputHash = "sha256-dIveiaiPFGSItwLyeMuPDxTE9gpvvnlTCB/+nG24qCc=";
      });
    });
    settings = {
      autoupdate = false;
      # Claude subscription: the built-in claude-agent provider that uses the Claude Code login
      # (once: `opencode auth login claude-agent`)
      model = "claude-agent/sonnet";
      # Fable doesn't work on the subscription ("requires usage credits")
      providers.claude-agent.models = {
        fable.disabled = true;
        claude-fable-5.disabled = true;
      };
    };
  };

  # v2 loads plugins from cli.json; the home-manager module has no option for it
  xdg.configFile."opencode/cli.json".text = builtins.toJSON {
    theme.name = "catppuccin";
    plugins = [
      {
        package = "vimcode@file:${vimcode}";
        options.updateCheck = false;
      }
    ];
  };
}
